local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game.Players.LocalPlayer
local Window = Rayfield:CreateWindow({
   Name = "Interplus v0.1 | Fortline Games",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Interplus",
   LoadingSubtitle = "Loading...",
   ShowText = "Interplus", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Interplus"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Main", "home")

local Section = Tab:CreateSection("Main")

local player = game.Players.LocalPlayer
local function buffTools(container)
	for _, tool in pairs(container:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Configuration") then
			local cfg = tool.Configuration
			if cfg:FindFirstChild("HitDamage") then
				cfg.HitDamage.Value = 99999999999999
			end
			if cfg:FindFirstChild("ShotCooldown") then
				cfg.ShotCooldown.Value = 0
			end
			if cfg:FindFirstChild("TotalRecoilMax") then
				cfg.TotalRecoilMax.Value = 0
			end
			if cfg:FindFirstChild("GravityFactor") then
				cfg.GravityFactor.Value = 0
			end
			if cfg:FindFirstChild("ChargeRate") then
				cfg.ChargeRate.Value = 5000
			end
		end
	end
end

local Button = Tab:CreateButton({
   Name = "Mod All Weapons",
   Callback = function()
	buffTools(player.Backpack)
	buffTools(player.Character)
	Rayfield:Notify({
   		Title = "Interplus",
   		Content = "All weapons modded! But if you die, you have to press this again!",
   		Duration = 6.5,
   		Image = "check",
	})
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Toggle Inf Health",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
    local safe = workspace:WaitForChild("Safe")
    local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")

    -- make a value to save og pos if it doesn't exist
    if not safe:FindFirstChild("OriginalPos") then
        local posVal = Instance.new("Vector3Value")
        posVal.Name = "OriginalPos"
        posVal.Value = safe.Position
        posVal.Parent = safe
    end

    -- stop any old loop
    if safe:FindFirstChild("MoveLoop") then
        safe.MoveLoop.Value = false
        safe.MoveLoop:Destroy()
    end

    if Value == true then
        local moveFlag = Instance.new("BoolValue")
        moveFlag.Name = "MoveLoop"
        moveFlag.Value = true
        moveFlag.Parent = safe

        task.spawn(function()
            while moveFlag.Value do
                if hrp then
                    safe.Position = hrp.Position
                end
                task.wait(0.015)
            end
        end)
    else
        -- if no saved pos, use ur fallback coords
        if safe:FindFirstChild("OriginalPos") then
            safe.Position = safe.OriginalPos.Value
        else
            safe.Position = Vector3.new(14.196513175964355, 262.8415832519531, 24.971466064453125)
        end
    end
end


})

local Button = Tab:CreateButton({
   Name = "Enable Hold F To Rapidfire (PC only, sorry!)",
   Callback = function()
	local uis = game:GetService("UserInputService")
	local holding = false

	uis.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.F then
			holding = true
			while holding do
				local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
				if tool then
					-- activates tool
					tool:Activate()
					task.wait(0.001)
					tool:Deactivate()
				end
				task.wait(0.015)
			end
		end
	end)

	uis.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F then
			holding = false
		end
	end)
end

})
