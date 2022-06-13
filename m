Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125135493EF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377801AbiFMNeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378799AbiFMNcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B7F71D8D;
        Mon, 13 Jun 2022 04:26:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED5A60B6E;
        Mon, 13 Jun 2022 11:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6744AC34114;
        Mon, 13 Jun 2022 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119600;
        bh=u2FxgfkoGnjzoKKN8QBayAg+rk7Gc72KjK/quKszqoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5ZxAnXSiHEXzT7ViLitmzCNYeDHGRMqkRCEWp3MinSj2Ub1J1iafCTIM0vV3pMBV
         HLofigD1yhAW7XQg85om9ttzJ6LUuOOBZ5Wf+ScplFfh4CyrayyMocrJR6Hp57W7Ea
         kbI4yNdOXzZUbm9ewyog//eR+/G7OKzSxSs3Dp9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 042/339] power: supply: axp288_fuel_gauge: Fix battery reporting on the One Mix 1
Date:   Mon, 13 Jun 2022 12:07:47 +0200
Message-Id: <20220613094927.796398867@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 34f243e9fb5ace1ca760c72e366247eaeff430c0 ]

Commit 3a06b912a5ce ("power: supply: axp288_fuel_gauge: Make "T3 MRD"
no_battery_list DMI entry more generic") added a generic no-battery DMI
match for many mini-PCs / HDMI-sticks which use "T3 MRD" as their DMI
board-name.

It turns out that the One Mix 1 mini laptop also uses "T3 MRD" for its
DMI boardname and it also has its chassis-type wrongly set to a value
of "3" (desktop). This was causing the axp288_fuel_gauge driver to
disable battery reporting because this matches the no-battery DMI
list entry for generic "T3 MRD" mini-PCs.

Change the no-battery DMI list into a quirks DMI list and add a
specific match for the One Mix 1 mini laptop before the generic
"T3 MRD" no-battery quirk entry to fix this.

Fixes: 3a06b912a5ce ("power: supply: axp288_fuel_gauge: Make "T3 MRD" no_battery_list DMI entry more generic")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 40 +++++++++++++++++++++---
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index e9f285dae489..5b8aa4a980cd 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -90,6 +90,8 @@
 #define AXP288_REG_UPDATE_INTERVAL		(60 * HZ)
 #define AXP288_FG_INTR_NUM			6
 
+#define AXP288_QUIRK_NO_BATTERY			BIT(0)
+
 static bool no_current_sense_res;
 module_param(no_current_sense_res, bool, 0444);
 MODULE_PARM_DESC(no_current_sense_res, "No (or broken) current sense resistor");
@@ -524,7 +526,7 @@ static struct power_supply_desc fuel_gauge_desc = {
  * detection reports one despite it not being there.
  * Please keep this listed sorted alphabetically.
  */
-static const struct dmi_system_id axp288_no_battery_list[] = {
+static const struct dmi_system_id axp288_quirks[] = {
 	{
 		/* ACEPC T8 Cherry Trail Z8350 mini PC */
 		.matches = {
@@ -534,6 +536,7 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			/* also match on somewhat unique bios-version */
 			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
 		/* ACEPC T11 Cherry Trail Z8350 mini PC */
@@ -544,6 +547,7 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			/* also match on somewhat unique bios-version */
 			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
 		/* Intel Cherry Trail Compute Stick, Windows version */
@@ -551,6 +555,7 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1AW32SC"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
 		/* Intel Cherry Trail Compute Stick, version without an OS */
@@ -558,34 +563,55 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "STK1A32SC"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
 		/* Meegopad T02 */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MEEGOPAD T02"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{	/* Mele PCG03 Mini PC */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Mini PC"),
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Mini PC"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
 		/* Minix Neo Z83-4 mini PC */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
-		}
+		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{
-		/* Various Ace PC/Meegopad/MinisForum/Wintel Mini-PCs/HDMI-sticks */
+		/*
+		 * One Mix 1, this uses the "T3 MRD" boardname used by
+		 * generic mini PCs, but it is a mini laptop so it does
+		 * actually have a battery!
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
+			DMI_MATCH(DMI_BIOS_DATE, "06/14/2018"),
+		},
+		.driver_data = NULL,
+	},
+	{
+		/*
+		 * Various Ace PC/Meegopad/MinisForum/Wintel Mini-PCs/HDMI-sticks
+		 * This entry must be last because it is generic, this allows
+		 * adding more specifuc quirks overriding this generic entry.
+		 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "3"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
 			DMI_MATCH(DMI_BIOS_VERSION, "5.11"),
 		},
+		.driver_data = (void *)AXP288_QUIRK_NO_BATTERY,
 	},
 	{}
 };
@@ -665,7 +691,9 @@ static int axp288_fuel_gauge_probe(struct platform_device *pdev)
 		[BAT_D_CURR] = "axp288-chrg-d-curr",
 		[BAT_VOLT] = "axp288-batt-volt",
 	};
+	const struct dmi_system_id *dmi_id;
 	struct device *dev = &pdev->dev;
+	unsigned long quirks = 0;
 	int i, pirq, ret;
 
 	/*
@@ -675,7 +703,11 @@ static int axp288_fuel_gauge_probe(struct platform_device *pdev)
 	if (!acpi_quirk_skip_acpi_ac_and_battery())
 		return -ENODEV;
 
-	if (dmi_check_system(axp288_no_battery_list))
+	dmi_id = dmi_first_match(axp288_quirks);
+	if (dmi_id)
+		quirks = (unsigned long)dmi_id->driver_data;
+
+	if (quirks & AXP288_QUIRK_NO_BATTERY)
 		return -ENODEV;
 
 	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
-- 
2.35.1



