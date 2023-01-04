Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68065D84B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbjADQN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239688AbjADQM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49240DEB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A74B81732
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464B8C433EF;
        Wed,  4 Jan 2023 16:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848744;
        bh=zK54ZTDM2O8ctkUh7WXZCb5LE8tAKZh34jCi4+FZ33Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKsznuo4C/FFLA3LfHoLogHZKD91tmVy2X1ldYkH/krdsOqB1VuS3k9GPiTSA0R4b
         AYgbUFEBIch2+dJS1LSSRkIOB2545n7j7GvwFXLQc2gOzefdr0ByCHQmNnXtOhcKIu
         j5VEkn/p1X5SntE3/Djam4sVBAIPPHjwYN/6q7M8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/207] platform/x86: x86-android-tablets: Add Medion Lifetab S10346 data
Date:   Wed,  4 Jan 2023 17:05:13 +0100
Message-Id: <20230104160513.651524637@linuxfoundation.org>
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

[ Upstream commit 902ce18ab1f4444ff9d49865bea35a07adcc03fd ]

The Medion Lifetab S10346 is a x86 ACPI tablet which ships with Android
x86 as factory OS. Its DSDT contains a bunch of I2C devices which are not
actually there, causing various resource conflicts. Enumeration of these
is skipped through the acpi_quirk_skip_i2c_client_enumeration().

Add support for manually instantiating the I2C devices which are
actually present on this tablet by adding the necessary device info to
the x86-android-tablets module.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20221208110224.107354-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets.c | 92 ++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index 4acd6fa8d43b..f04e06eeb958 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -987,6 +987,88 @@ static void lenovo_yoga_tab2_830_1050_exit(void)
 	}
 }
 
+/* Medion Lifetab S10346 tablets have an Android factory img with everything hardcoded */
+static const char * const medion_lifetab_s10346_accel_mount_matrix[] = {
+	"0", "1", "0",
+	"1", "0", "0",
+	"0", "0", "1"
+};
+
+static const struct property_entry medion_lifetab_s10346_accel_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("mount-matrix", medion_lifetab_s10346_accel_mount_matrix),
+	{ }
+};
+
+static const struct software_node medion_lifetab_s10346_accel_node = {
+	.properties = medion_lifetab_s10346_accel_props,
+};
+
+/* Note the LCD panel is mounted upside down, this is correctly indicated in the VBT */
+static const struct property_entry medion_lifetab_s10346_touchscreen_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-x"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	{ }
+};
+
+static const struct software_node medion_lifetab_s10346_touchscreen_node = {
+	.properties = medion_lifetab_s10346_touchscreen_props,
+};
+
+static const struct x86_i2c_client_info medion_lifetab_s10346_i2c_clients[] __initconst = {
+	{
+		/* kxtj21009 accel */
+		.board_info = {
+			.type = "kxtj21009",
+			.addr = 0x0f,
+			.dev_name = "kxtj21009",
+			.swnode = &medion_lifetab_s10346_accel_node,
+		},
+		.adapter_path = "\\_SB_.I2C3",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_GPIOINT,
+			.chip = "INT33FC:02",
+			.index = 23,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_HIGH,
+		},
+	}, {
+		/* goodix touchscreen */
+		.board_info = {
+			.type = "GDIX1001:00",
+			.addr = 0x14,
+			.dev_name = "goodix_ts",
+			.swnode = &medion_lifetab_s10346_touchscreen_node,
+		},
+		.adapter_path = "\\_SB_.I2C4",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_APIC,
+			.index = 0x44,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_LOW,
+		},
+	},
+};
+
+static struct gpiod_lookup_table medion_lifetab_s10346_goodix_gpios = {
+	.dev_id = "i2c-goodix_ts",
+	.table = {
+		GPIO_LOOKUP("INT33FC:01", 26, "reset", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:02", 3, "irq", GPIO_ACTIVE_HIGH),
+		{ }
+	},
+};
+
+static struct gpiod_lookup_table * const medion_lifetab_s10346_gpios[] = {
+	&medion_lifetab_s10346_goodix_gpios,
+	NULL
+};
+
+static const struct x86_dev_info medion_lifetab_s10346_info __initconst = {
+	.i2c_client_info = medion_lifetab_s10346_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(medion_lifetab_s10346_i2c_clients),
+	.gpiod_lookup_tables = medion_lifetab_s10346_gpios,
+};
+
 /* Nextbook Ares 8 tablets have an Android factory img with everything hardcoded */
 static const char * const nextbook_ares8_accel_mount_matrix[] = {
 	"0", "-1", "0",
@@ -1245,6 +1327,16 @@ static const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 		},
 		.driver_data = (void *)&lenovo_yoga_tab2_830_1050_info,
 	},
+	{
+		/* Medion Lifetab S10346 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are much too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
+		},
+		.driver_data = (void *)&medion_lifetab_s10346_info,
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
-- 
2.35.1



