Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCDF3BBFD2
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhGEPdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhGEPcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B878E619A2;
        Mon,  5 Jul 2021 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499009;
        bh=eM8hCoUT7pQxHAolavTM2YgZVGuSIS2E+h8/fmFb1wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7/HNE/YLTi42XKK4qvAUzPbG4Ra7xK9biMAbMlqunSdqM+yAvRZvggmt8yKfm8GV
         mkiylfZw/H9Qrql8EiVUEASDIqWNvvMI5oCBWKOTEtOXrSx63m+wMERY2GAIZOyP0q
         lbjuhS8s5+UBQZnfYhOGMIy5LUF1nAJVoiwfVGeOG96bPfFQ0Nf0Lx7h5niAjgz1UL
         iyMZPXQResvKgQN1oIngNoKYNhZdbP9etE9NpP1OPbaHsdKNNK8WGEJllmiF+4oIHv
         k1MPj/CK52S02ssFIpoYxLE3Q4BJEkoDsXQBmbHoUWgastn28VZjT9WKbd+JRN5EKj
         tnPgd/pnAbSTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/41] Input: goodix - platform/x86: touchscreen_dmi - Move upside down quirks to touchscreen_dmi.c
Date:   Mon,  5 Jul 2021 11:29:26 -0400
Message-Id: <20210705153001.1521447-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5a6f0dbe621a5c20dc912ac474debf9f11129e03 ]

Move the DMI quirks for upside-down mounted Goodix touchscreens from
drivers/input/touchscreen/goodix.c to
drivers/platform/x86/touchscreen_dmi.c,
where all the other x86 touchscreen quirks live.

Note the touchscreen_dmi.c code attaches standard touchscreen
device-properties to an i2c-client device based on a combination of a
DMI match + a device-name match. I've verified that the: Teclast X98 Pro,
WinBook TW100 and WinBook TW700 uses an ACPI devicename of "GDIX1001:00"
based on acpidumps and/or dmesg output available on the web.

This patch was tested on a Teclast X89 tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c     | 52 ------------------------
 drivers/platform/x86/touchscreen_dmi.c | 56 ++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 45113767db96..a06385c55af2 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -178,51 +178,6 @@ static const unsigned long goodix_irq_flags[] = {
 	IRQ_TYPE_LEVEL_HIGH,
 };
 
-/*
- * Those tablets have their coordinates origin at the bottom right
- * of the tablet, as if rotated 180 degrees
- */
-static const struct dmi_system_id rotated_screen[] = {
-#if defined(CONFIG_DMI) && defined(CONFIG_X86)
-	{
-		.ident = "Teclast X89",
-		.matches = {
-			/* tPAD is too generic, also match on bios date */
-			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
-			DMI_MATCH(DMI_BOARD_NAME, "tPAD"),
-			DMI_MATCH(DMI_BIOS_DATE, "12/19/2014"),
-		},
-	},
-	{
-		.ident = "Teclast X98 Pro",
-		.matches = {
-			/*
-			 * Only match BIOS date, because the manufacturers
-			 * BIOS does not report the board name at all
-			 * (sometimes)...
-			 */
-			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
-			DMI_MATCH(DMI_BIOS_DATE, "10/28/2015"),
-		},
-	},
-	{
-		.ident = "WinBook TW100",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "WinBook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TW100")
-		}
-	},
-	{
-		.ident = "WinBook TW700",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "WinBook"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TW700")
-		},
-	},
-#endif
-	{}
-};
-
 static const struct dmi_system_id nine_bytes_report[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
@@ -1121,13 +1076,6 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 				  ABS_MT_POSITION_Y, ts->prop.max_y);
 	}
 
-	if (dmi_check_system(rotated_screen)) {
-		ts->prop.invert_x = true;
-		ts->prop.invert_y = true;
-		dev_dbg(&ts->client->dev,
-			"Applying '180 degrees rotated screen' quirk\n");
-	}
-
 	if (dmi_check_system(nine_bytes_report)) {
 		ts->contact_size = 9;
 
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 3743d895399e..e52ff09b81de 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -299,6 +299,23 @@ static const struct ts_dmi_data estar_beauty_hd_data = {
 	.properties	= estar_beauty_hd_props,
 };
 
+/* Generic props + data for upside-down mounted GDIX1001 touchscreens */
+static const struct property_entry gdix1001_upside_down_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-x"),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	{ }
+};
+
+static const struct ts_dmi_data gdix1001_00_upside_down_data = {
+	.acpi_name	= "GDIX1001:00",
+	.properties	= gdix1001_upside_down_props,
+};
+
+static const struct ts_dmi_data gdix1001_01_upside_down_data = {
+	.acpi_name	= "GDIX1001:01",
+	.properties	= gdix1001_upside_down_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -1268,6 +1285,16 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "X3 Plus"),
 		},
 	},
+	{
+		/* Teclast X89 (Windows version / BIOS) */
+		.driver_data = (void *)&gdix1001_01_upside_down_data,
+		.matches = {
+			/* tPAD is too generic, also match on bios date */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_BOARD_NAME, "tPAD"),
+			DMI_MATCH(DMI_BIOS_DATE, "12/19/2014"),
+		},
+	},
 	{
 		/* Teclast X98 Plus II */
 		.driver_data = (void *)&teclast_x98plus2_data,
@@ -1276,6 +1303,19 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "X98 Plus II"),
 		},
 	},
+	{
+		/* Teclast X98 Pro */
+		.driver_data = (void *)&gdix1001_00_upside_down_data,
+		.matches = {
+			/*
+			 * Only match BIOS date, because the manufacturers
+			 * BIOS does not report the board name at all
+			 * (sometimes)...
+			 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_BIOS_DATE, "10/28/2015"),
+		},
+	},
 	{
 		/* Trekstor Primebook C11 */
 		.driver_data = (void *)&trekstor_primebook_c11_data,
@@ -1351,6 +1391,22 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "VINGA Twizzle J116"),
 		},
 	},
+	{
+		/* "WinBook TW100" */
+		.driver_data = (void *)&gdix1001_00_upside_down_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "WinBook"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TW100")
+		}
+	},
+	{
+		/* WinBook TW700 */
+		.driver_data = (void *)&gdix1001_00_upside_down_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "WinBook"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TW700")
+		},
+	},
 	{
 		/* Yours Y8W81, same case and touchscreen as Chuwi Vi8 */
 		.driver_data = (void *)&chuwi_vi8_data,
-- 
2.30.2

