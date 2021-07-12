Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535BC3C51CD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343871AbhGLHni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347884AbhGLHkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2477B611F1;
        Mon, 12 Jul 2021 07:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075418;
        bh=+Klb3H2JXmu8TWZqMs7JTF0kUys4BvGnTeWBBCwIDCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iirzKHSmjOPTUjnyV+nA1PT5ecIliVLUHe0y4NNP3iYwt+7VSnIEsKrblX0CNnvhd
         +2lUdMCpg+8poBa41D3CZKSNduZRC+OfiEkxhhvoKgM+U4lwb2n3VPJyb7i9g7jYIe
         eCoIfejiPCsJQOJW8Q03vClG3Jhn6sWC9biVHZoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 215/800] Input: goodix - platform/x86: touchscreen_dmi - Move upside down quirks to touchscreen_dmi.c
Date:   Mon, 12 Jul 2021 08:03:58 +0200
Message-Id: <20210712060943.891778237@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c682b028f0a2..4f53d3c57e69 100644
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
@@ -1123,13 +1078,6 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
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
index bde740d6120e..b452865da2a1 100644
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
@@ -1330,6 +1347,16 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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
@@ -1338,6 +1365,19 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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
@@ -1413,6 +1453,22 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



