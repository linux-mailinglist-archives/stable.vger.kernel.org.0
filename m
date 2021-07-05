Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756293BBF30
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhGEPbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232098AbhGEPbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C296197D;
        Mon,  5 Jul 2021 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498936;
        bh=YqYnD+ZLROinqXEZDCMwG16fcbFfNbdEVXXLCM1fA/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl+TZm0bwPxyp5vPsvioRlcY7cMASfNjkhSHXT9J0XZKa7gX1CHvXtfLeN63hMPul
         h7XCIH8dGXEQEDfSnX74TRtHnWjFBNSReb19fUrhzcgYP63yKH/XAPpxvPc0ANg8o4
         SCRFTvRIjIzq1QxX711WC9XGGoSaRxAHzIGpN9I05JOR0E734JqF5leB15iA6TPwHz
         vaBYgLhhq6eE8wu9ACyqvJvEotR0r/JaAMsrljq6sOPKEr4Nw82K7omKTE1BccrrBy
         usws2A14fZ1W+/wBxURKmeuqlECNqVY61ssD+G2ngCHIfmku6q2fNvVhy48LixFLW5
         6uNNZesHUpqPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 31/59] platform/x86: asus-nb-wmi: Revert "add support for ASUS ROG Zephyrus G14 and G15"
Date:   Mon,  5 Jul 2021 11:27:47 -0400
Message-Id: <20210705152815.1520546-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luke D. Jones" <luke@ljones.dev>

[ Upstream commit 28117f3a5c3c8375a3304af76357d5bf9cf30f0b ]

The quirks added to asus-nb-wmi for the ASUS ROG Zephyrus G14 and G15 are
wrong, they tell the asus-wmi code to use the vendor specific WMI backlight
interface. But there is no such interface on these laptops.

As a side effect, these quirks stop the acpi_video driver to register since
they make acpi_video_get_backlight_type() return acpi_backlight_vendor,
leaving only the native AMD backlight driver in place, which is the one we
want. This happy coincidence is being replaced with a new quirk in
drivers/acpi/video_detect.c which actually sets the backlight_type to
acpi_backlight_native fixinf this properly. This reverts
commit 13bceda68fb9 ("platform/x86: asus-nb-wmi: add support for ASUS ROG
Zephyrus G14 and G15").

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20210419074915.393433-3-luke@ljones.dev
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 82 ------------------------------
 1 file changed, 82 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b07b1288346e..0cb927f0f301 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -110,16 +110,6 @@ static struct quirk_entry quirk_asus_forceals = {
 	.wmi_force_als_set = true,
 };
 
-static struct quirk_entry quirk_asus_ga401i = {
-	.wmi_backlight_power = true,
-	.wmi_backlight_set_devstate = true,
-};
-
-static struct quirk_entry quirk_asus_ga502i = {
-	.wmi_backlight_power = true,
-	.wmi_backlight_set_devstate = true,
-};
-
 static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
 	.use_kbd_dock_devid = true,
 };
@@ -430,78 +420,6 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_forceals,
 	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA401IH",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IH"),
-		},
-		.driver_data = &quirk_asus_ga401i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA401II",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA401II"),
-		},
-		.driver_data = &quirk_asus_ga401i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA401IU",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IU"),
-		},
-		.driver_data = &quirk_asus_ga401i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA401IV",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IV"),
-		},
-		.driver_data = &quirk_asus_ga401i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA401IVC",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA401IVC"),
-		},
-		.driver_data = &quirk_asus_ga401i,
-	},
-		{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA502II",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA502II"),
-		},
-		.driver_data = &quirk_asus_ga502i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA502IU",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IU"),
-		},
-		.driver_data = &quirk_asus_ga502i,
-	},
-	{
-		.callback = dmi_matched,
-		.ident = "ASUSTeK COMPUTER INC. GA502IV",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA502IV"),
-		},
-		.driver_data = &quirk_asus_ga502i,
-	},
 	{
 		.callback = dmi_matched,
 		.ident = "Asus Transformer T100TA / T100HA / T100CHI",
-- 
2.30.2

