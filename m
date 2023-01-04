Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209C765D856
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbjADQNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbjADQNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:13:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9FA63C3
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:13:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEAB1B817AC
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130C1C433EF;
        Wed,  4 Jan 2023 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848778;
        bh=xtyBHY6DJU8F7weQTFuB9OxFQ12nizJ9w4NtglMAi/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0fypydGY3EkUUUmwf90XBTn2s5HGTVN0KzCR1VQYCMYLROS/w2Mq1SPkkVHM/4k6
         bm7n/kFtkg9a3S9o4TvCLYRWI/dFlEMEXXd+qvnzPwX5vl2trPzdUHC5rb4Mk39+Is
         Xe1kBlMEuL/m5TBbAJx8h33SHBNZsMSWV9rdUiRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/207] platform/x86: x86-android-tablets: Add Lenovo Yoga Tab 3 (YT3-X90F) charger + fuel-gauge data
Date:   Wed,  4 Jan 2023 17:05:14 +0100
Message-Id: <20230104160513.691109303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b6c14ff1deaafd30036ec36d5205acd5a578b1cd ]

The Lenovo Yoga Tab 3 (YT3-X90F) is an Intel Cherry Trail based tablet
which ships with Android as Factory OS. Its DSDT contains a bunch of I2C
devices which are not actually there, causing various resource conflicts.
Use acpi_quirk_skip_i2c_client_enumeration() to not enumerate these.

The YT3-X90F has quite a bit of exotic hardware, this adds initial
support by manually instantiating the i2c-clients for the 2 charger +
2 fuel-gauge chips used for the 2 batteries.

Support for other parts of the hw will be added by follow-up patches.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221127182458.104528-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets.c | 135 ++++++++++++++++++++-
 1 file changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index f04e06eeb958..bbfae1395e18 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -5,7 +5,7 @@
  * devices typically have a bunch of things hardcoded, rather than specified
  * in their DSDT.
  *
- * Copyright (C) 2021 Hans de Goede <hdegoede@redhat.com>
+ * Copyright (C) 2021-2022 Hans de Goede <hdegoede@redhat.com>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -987,6 +987,130 @@ static void lenovo_yoga_tab2_830_1050_exit(void)
 	}
 }
 
+/* Lenovo Yoga Tab 3 Pro YT3-X90F */
+
+/*
+ * There are 2 batteries, with 2 bq27500 fuel-gauges and 2 bq25892 chargers,
+ * "bq25890-charger-1" is instantiated from: drivers/i2c/busses/i2c-cht-wc.c.
+ */
+static const char * const lenovo_yt3_bq25892_0_suppliers[] = { "cht_wcove_pwrsrc" };
+static const char * const bq25890_1_psy[] = { "bq25890-charger-1" };
+
+static const struct property_entry fg_bq25890_1_supply_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", bq25890_1_psy),
+	{ }
+};
+
+static const struct software_node fg_bq25890_1_supply_node = {
+	.properties = fg_bq25890_1_supply_props,
+};
+
+/* bq25892 charger settings for the flat lipo battery behind the screen */
+static const struct property_entry lenovo_yt3_bq25892_0_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", lenovo_yt3_bq25892_0_suppliers),
+	PROPERTY_ENTRY_STRING("linux,power-supply-name", "bq25892-second-chrg"),
+	PROPERTY_ENTRY_U32("linux,iinlim-percentage", 40),
+	PROPERTY_ENTRY_BOOL("linux,skip-reset"),
+	/* Values taken from Android Factory Image */
+	PROPERTY_ENTRY_U32("ti,charge-current", 2048000),
+	PROPERTY_ENTRY_U32("ti,battery-regulation-voltage", 4352000),
+	PROPERTY_ENTRY_U32("ti,termination-current", 128000),
+	PROPERTY_ENTRY_U32("ti,precharge-current", 128000),
+	PROPERTY_ENTRY_U32("ti,minimum-sys-voltage", 3700000),
+	PROPERTY_ENTRY_U32("ti,boost-voltage", 4998000),
+	PROPERTY_ENTRY_U32("ti,boost-max-current", 500000),
+	PROPERTY_ENTRY_BOOL("ti,use-ilim-pin"),
+	{ }
+};
+
+static const struct software_node lenovo_yt3_bq25892_0_node = {
+	.properties = lenovo_yt3_bq25892_0_props,
+};
+
+static const struct x86_i2c_client_info lenovo_yt3_i2c_clients[] __initconst = {
+	{
+		/* bq27500 fuel-gauge for the flat lipo battery behind the screen */
+		.board_info = {
+			.type = "bq27500",
+			.addr = 0x55,
+			.dev_name = "bq27500_0",
+			.swnode = &fg_bq25890_supply_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C1",
+	}, {
+		/* bq25892 charger for the flat lipo battery behind the screen */
+		.board_info = {
+			.type = "bq25892",
+			.addr = 0x6b,
+			.dev_name = "bq25892_0",
+			.swnode = &lenovo_yt3_bq25892_0_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C1",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_GPIOINT,
+			.chip = "INT33FF:01",
+			.index = 5,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_LOW,
+		},
+	}, {
+		/* bq27500 fuel-gauge for the round li-ion cells in the hinge */
+		.board_info = {
+			.type = "bq27500",
+			.addr = 0x55,
+			.dev_name = "bq27500_1",
+			.swnode = &fg_bq25890_1_supply_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C2",
+	}
+};
+
+static int __init lenovo_yt3_init(void)
+{
+	struct gpio_desc *gpiod;
+	int ret;
+
+	/*
+	 * The "bq25892_0" charger IC has its /CE (Charge-Enable) and OTG pins
+	 * connected to GPIOs, rather then having them hardwired to the correct
+	 * values as is normally done.
+	 *
+	 * The bq25890_charger driver controls these through I2C, but this only
+	 * works if not overridden by the pins. Set these pins here:
+	 * 1. Set /CE to 0 to allow charging.
+	 * 2. Set OTG to 0 disable V5 boost output since the 5V boost output of
+	 *    the main "bq25892_1" charger is used when necessary.
+	 */
+
+	/* /CE pin */
+	ret = x86_android_tablet_get_gpiod("INT33FF:02", 22, &gpiod);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The gpio_desc returned by x86_android_tablet_get_gpiod() is a "raw"
+	 * gpio_desc, that is there is no way to pass lookup-flags like
+	 * GPIO_ACTIVE_LOW. Set the GPIO to 0 here to enable charging since
+	 * the /CE pin is active-low, but not marked as such in the gpio_desc.
+	 */
+	gpiod_set_value(gpiod, 0);
+
+	/* OTG pin */
+	ret = x86_android_tablet_get_gpiod("INT33FF:03", 19, &gpiod);
+	if (ret < 0)
+		return ret;
+
+	gpiod_set_value(gpiod, 0);
+
+	return 0;
+}
+
+static const struct x86_dev_info lenovo_yt3_info __initconst = {
+	.i2c_client_info = lenovo_yt3_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(lenovo_yt3_i2c_clients),
+	.init = lenovo_yt3_init,
+};
+
 /* Medion Lifetab S10346 tablets have an Android factory img with everything hardcoded */
 static const char * const medion_lifetab_s10346_accel_mount_matrix[] = {
 	"0", "1", "0",
@@ -1327,6 +1451,15 @@ static const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 		},
 		.driver_data = (void *)&lenovo_yoga_tab2_830_1050_info,
 	},
+	{
+		/* Lenovo Yoga Tab 3 Pro YT3-X90F */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)&lenovo_yt3_info,
+	},
 	{
 		/* Medion Lifetab S10346 */
 		.matches = {
-- 
2.35.1



