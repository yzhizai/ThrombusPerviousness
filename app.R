#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinydashboard)

load(file = 'Model.RData')
# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "The probability of favorable functional outcome"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Model1", tabName = "tab_mod1", icon = icon("glyphicon glyphicon-cog", lib = 'glyphicon')),
      menuItem("Model2", tabName = "tab_mod2", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab_mod1",
              fluidRow(
                box(
                  numericInput('ipt_IC', 'IC', value = 0, step = 1),
                  numericInput('ipt_NIHSS', 'NIHSS', value = 20, step = 1),
                  numericInput('ipt_SBP', 'SBP', value = 100, step = 1),
                  textOutput('opt_txt1')
                ),
                
                box(
                  plotOutput("distPlot1")
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "tab_mod2",
              fluidRow(
                box(
                  numericInput('ipt_NIC', 'NIC', value = 0, step = 1),
                  numericInput('ipt_NIHSS2', 'NIHSS', value = 20, step = 1),
                  textOutput('opt_txt2')
                ),
                
                box(
                  plotOutput("distPlot2")
                )
              )
      )
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    output$opt_txt1 <- renderText({
      input.data <- tibble(IC = input$ipt_NIC, 
                           NIHSS = input$ipt_NIHSS, 
                           SBP = input$ipt_SBP)
      
      pred.prob <- predict(fit1, newdata = input.data, type = 'fitted')
      sprintf('The probability of favorable functional outcome: %.3f', pred.prob)
    })
    output$distPlot1 <- renderPlot({
        # generate bins based on input$bins from ui.R
        plot(nom1)
    })
    
    output$opt_txt2 <- renderText({
      input.data <- tibble(NIC = input$ipt_NIC, 
                           NIHSS = input$ipt_NIHSS2)
      
      pred.prob <- predict(fit2, newdata = input.data, type = 'fitted')
      sprintf('The probability of favorable functional outcome: %.3f', pred.prob)
    })
    output$distPlot2 <- renderPlot({
      # generate bins based on input$bins from ui.R
      plot(nom2)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
