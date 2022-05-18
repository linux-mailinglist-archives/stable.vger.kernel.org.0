Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397C052BA86
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiERM1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiERM1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:27:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB73A76CA;
        Wed, 18 May 2022 05:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 901F2B81FB9;
        Wed, 18 May 2022 12:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D3FC34117;
        Wed, 18 May 2022 12:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876826;
        bh=y1xog3J27YTwN0A9xZLgHTReF4/FxWbtCjlVdhy8QJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFj2DXIRo1N/U3qEMl2Iy2DE+pSVPenlaK9KFY4mkHbOj6WHGecZdpgwDUSBoueHF
         0wwUw+x8j+X/UYNQRj4VhrZBN5I9G/8XAoYYqPnDdvEmZJa1IAt7sWZjKp+L1XfpQm
         5pR+GKEgKvMPi/9PuPkVtEHDBnxkvUIeGYJz60k1OAaIPO60J/s7KkIlkNhcekD2GK
         Dh1c57fI3FxFPrPL3uZTcKTEBJ3x5Kf/EcSkly4ucx73O0hPSwUqJXh3e+SKZzG0fH
         wx7M/PdOwD5sZAF8plxYGh2S8Lr6ICUklhrAl4gzPQ5/pSP1IZPbjVtWZR/bEHepAg
         j7Wt3bB8fNkfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Mark Pearson <markpearson@lenvo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 09/23] platform/x86: thinkpad_acpi: Convert btusb DMI list to quirks
Date:   Wed, 18 May 2022 08:26:22 -0400
Message-Id: <20220518122641.342120-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c25d7f32e3e209462cd82e6e93e66b72dbb2308f ]

DMI matching in thinkpad_acpi happens local to a function meaning
quirks can only match that function.

Future changes to thinkpad_acpi may need to quirk other code, so
change this to use a quirk infrastructure.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mark Pearson <markpearson@lenvo.com>
Link: https://lore.kernel.org/r/20220429030501.1909-2-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3fb8cda31eb9..c43586f1cb4b 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -309,6 +309,15 @@ struct ibm_init_struct {
 	struct ibm_struct *data;
 };
 
+/* DMI Quirks */
+struct quirk_entry {
+	bool btusb_bug;
+};
+
+static struct quirk_entry quirk_btusb_bug = {
+	.btusb_bug = true,
+};
+
 static struct {
 	u32 bluetooth:1;
 	u32 hotkey:1;
@@ -338,6 +347,7 @@ static struct {
 	u32 hotkey_poll_active:1;
 	u32 has_adaptive_kbd:1;
 	u32 kbd_lang:1;
+	struct quirk_entry *quirks;
 } tp_features;
 
 static struct {
@@ -4361,9 +4371,10 @@ static void bluetooth_exit(void)
 	bluetooth_shutdown();
 }
 
-static const struct dmi_system_id bt_fwbug_list[] __initconst = {
+static const struct dmi_system_id fwbug_list[] __initconst = {
 	{
 		.ident = "ThinkPad E485",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20KU"),
@@ -4371,6 +4382,7 @@ static const struct dmi_system_id bt_fwbug_list[] __initconst = {
 	},
 	{
 		.ident = "ThinkPad E585",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20KV"),
@@ -4378,6 +4390,7 @@ static const struct dmi_system_id bt_fwbug_list[] __initconst = {
 	},
 	{
 		.ident = "ThinkPad A285 - 20MW",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20MW"),
@@ -4385,6 +4398,7 @@ static const struct dmi_system_id bt_fwbug_list[] __initconst = {
 	},
 	{
 		.ident = "ThinkPad A285 - 20MX",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20MX"),
@@ -4392,6 +4406,7 @@ static const struct dmi_system_id bt_fwbug_list[] __initconst = {
 	},
 	{
 		.ident = "ThinkPad A485 - 20MU",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20MU"),
@@ -4399,6 +4414,7 @@ static const struct dmi_system_id bt_fwbug_list[] __initconst = {
 	},
 	{
 		.ident = "ThinkPad A485 - 20MV",
+		.driver_data = &quirk_btusb_bug,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_BOARD_NAME, "20MV"),
@@ -4421,7 +4437,8 @@ static int __init have_bt_fwbug(void)
 	 * Some AMD based ThinkPads have a firmware bug that calling
 	 * "GBDC" will cause bluetooth on Intel wireless cards blocked
 	 */
-	if (dmi_check_system(bt_fwbug_list) && pci_dev_present(fwbug_cards_ids)) {
+	if (tp_features.quirks && tp_features.quirks->btusb_bug &&
+	    pci_dev_present(fwbug_cards_ids)) {
 		vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_RFKILL,
 			FW_BUG "disable bluetooth subdriver for Intel cards\n");
 		return 1;
@@ -11438,6 +11455,7 @@ static void thinkpad_acpi_module_exit(void)
 
 static int __init thinkpad_acpi_module_init(void)
 {
+	const struct dmi_system_id *dmi_id;
 	int ret, i;
 
 	tpacpi_lifecycle = TPACPI_LIFE_INIT;
@@ -11477,6 +11495,10 @@ static int __init thinkpad_acpi_module_init(void)
 		return -ENODEV;
 	}
 
+	dmi_id = dmi_first_match(fwbug_list);
+	if (dmi_id)
+		tp_features.quirks = dmi_id->driver_data;
+
 	/* Device initialization */
 	tpacpi_pdev = platform_device_register_simple(TPACPI_DRVR_NAME, -1,
 							NULL, 0);
-- 
2.35.1

