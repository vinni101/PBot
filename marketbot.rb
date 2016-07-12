require 'slack-ruby-bot'
require 'yahoo-finance'
require 'net/http'
require 'json'

SlackRubyBot::Client.logger.level = Logger::WARN

class MarketBot < SlackRubyBot::Bot
  scan(/(?<![-.])\b[0-9]+\b(?!\.[0-9])/) do |client, data, index|

    url = "https://still-sierra-46096.herokuapp.com/policies/#{index[0]}.json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    policies = JSON.parse(response)
    #client.say(channel: data.channel, text: "Check policy url: #{policies["policyowner"]}.")
    #uri = URI(url)
    #response = Net::HTTP.get(uri)
    #policies = JSON.parse(response)
    #YahooFinance::Client.new.quotes(stocks, [:name, :symbol, :last_trade_price, :change, :change_in_percent]).each do |quote|
    #  next if quote.symbol == 'N/A'
      client.web_client.chat_postMessage(
        channel: data.channel,
         as_user: true,
         attachments: [
           {
             fallback: "#{policies["policyowner"]}",
             title: "Policy no: #{policies["policy_number"]}",
             text: "Policy Owner: #{policies["policyowner"]}",
             color: '#00FF00'
           }
         ]
      )
    #end
  end
end

MarketBot.run