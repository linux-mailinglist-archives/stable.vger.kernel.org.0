Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45E66AF3F8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjCGTMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjCGTL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:11:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D130C59D6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B82B819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428A1C433EF;
        Tue,  7 Mar 2023 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215346;
        bh=0n9czdKISxurp1VKl89g+IVHi5zZ4EEr7nbD/+gto8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oICkaDLQnI4kTznXOsJIAWWbCTLmKKIzgjaD4/fDaddGWVHB3OfGtVVHXsJGGf+bC
         tZ8Vh7KK0Ido+WvVA9KMkvr9Pzl3X+ngP+yjiw5EFUM+pdPP2kZxhEPw0KnzMuL0Dr
         VWZLilHmH3IrxjZlI/fT1KPWeA6vLdgX9DqGKF8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Allen Ballway <ballway@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/567] HID: multitouch: Add quirks for flipped axes
Date:   Tue,  7 Mar 2023 17:59:28 +0100
Message-Id: <20230307165915.980014661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Ballway <ballway@chromium.org>

[ Upstream commit a2f416bf062a38bb76cccd526d2d286b8e4db4d9 ]

Certain touchscreen devices, such as the ELAN9034, are oriented
incorrectly and report touches on opposite points on the X and Y axes.
For example, a 100x200 screen touched at (10,20) would report (90, 180)
and vice versa.

This is fixed by adding device quirks to transform the touch points
into the correct spaces, from X -> MAX(X) - X, and Y -> MAX(Y) - Y.

Signed-off-by: Allen Ballway <ballway@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: 03a86105556e ("HID: retain initial quirks set up when creating HID devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c             | 39 ++++++++++++++++++---
 drivers/hid/hid-quirks.c                 |  6 ++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 43 ++++++++++++++++++++++++
 drivers/hid/i2c-hid/i2c-hid.h            |  3 ++
 4 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6b86d368d5e74..592ffdd546fb4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
+#define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -1009,6 +1010,7 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			    struct mt_usages *slot)
 {
 	struct input_mt *mt = input->mt;
+	struct hid_device *hdev = td->hdev;
 	__s32 quirks = app->quirks;
 	bool valid = true;
 	bool confidence_state = true;
@@ -1086,6 +1088,10 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 		int orientation = wide;
 		int max_azimuth;
 		int azimuth;
+		int x;
+		int y;
+		int cx;
+		int cy;
 
 		if (slot->a != DEFAULT_ZERO) {
 			/*
@@ -1104,6 +1110,9 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			if (azimuth > max_azimuth * 2)
 				azimuth -= max_azimuth * 4;
 			orientation = -azimuth;
+			if (quirks & MT_QUIRK_ORIENTATION_INVERT)
+				orientation = -orientation;
+
 		}
 
 		if (quirks & MT_QUIRK_TOUCH_SIZE_SCALING) {
@@ -1115,10 +1124,23 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			minor = minor >> 1;
 		}
 
-		input_event(input, EV_ABS, ABS_MT_POSITION_X, *slot->x);
-		input_event(input, EV_ABS, ABS_MT_POSITION_Y, *slot->y);
-		input_event(input, EV_ABS, ABS_MT_TOOL_X, *slot->cx);
-		input_event(input, EV_ABS, ABS_MT_TOOL_Y, *slot->cy);
+		x = hdev->quirks & HID_QUIRK_X_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_X) - *slot->x :
+			*slot->x;
+		y = hdev->quirks & HID_QUIRK_Y_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_Y) - *slot->y :
+			*slot->y;
+		cx = hdev->quirks & HID_QUIRK_X_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_X) - *slot->cx :
+			*slot->cx;
+		cy = hdev->quirks & HID_QUIRK_Y_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_Y) - *slot->cy :
+			*slot->cy;
+
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, y);
+		input_event(input, EV_ABS, ABS_MT_TOOL_X, cx);
+		input_event(input, EV_ABS, ABS_MT_TOOL_Y, cy);
 		input_event(input, EV_ABS, ABS_MT_DISTANCE, !*slot->tip_state);
 		input_event(input, EV_ABS, ABS_MT_ORIENTATION, orientation);
 		input_event(input, EV_ABS, ABS_MT_PRESSURE, *slot->p);
@@ -1738,6 +1760,15 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		td->serial_maybe = true;
 
+
+	/* Orientation is inverted if the X or Y axes are
+	 * flipped, but normalized if both are inverted.
+	 */
+	if (hdev->quirks & (HID_QUIRK_X_INVERT | HID_QUIRK_Y_INVERT) &&
+	    !((hdev->quirks & HID_QUIRK_X_INVERT)
+	      && (hdev->quirks & HID_QUIRK_Y_INVERT)))
+		td->mtclass.quirks = MT_QUIRK_ORIENTATION_INVERT;
+
 	/* This allows the driver to correctly support devices
 	 * that emit events over several HID messages.
 	 */
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 4a8c32148e58f..bad1c1e3adec4 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -19,6 +19,7 @@
 #include <linux/input/elan-i2c-ids.h>
 
 #include "hid-ids.h"
+#include "i2c-hid/i2c-hid.h"
 
 /*
  * Alphabetically sorted by vendor then product.
@@ -1278,6 +1279,11 @@ unsigned long hid_lookup_quirk(const struct hid_device *hdev)
 		quirks = hid_gets_squirk(hdev);
 	mutex_unlock(&dquirks_lock);
 
+	/* Get quirks specific to I2C devices */
+	if (IS_ENABLED(CONFIG_I2C_DMI_CORE) && IS_ENABLED(CONFIG_DMI) &&
+	    hdev->bus == BUS_I2C)
+		quirks |= i2c_hid_get_dmi_quirks(hdev->vendor, hdev->product);
+
 	return quirks;
 }
 EXPORT_SYMBOL_GPL(hid_lookup_quirk);
diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index 8e0f67455c098..554a7dc285365 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -10,8 +10,10 @@
 #include <linux/types.h>
 #include <linux/dmi.h>
 #include <linux/mod_devicetable.h>
+#include <linux/hid.h>
 
 #include "i2c-hid.h"
+#include "../hid-ids.h"
 
 
 struct i2c_hid_desc_override {
@@ -416,6 +418,28 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 	{ }	/* Terminate list */
 };
 
+static const struct hid_device_id i2c_hid_elan_flipped_quirks = {
+	HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8, USB_VENDOR_ID_ELAN, 0x2dcd),
+		HID_QUIRK_X_INVERT | HID_QUIRK_Y_INVERT
+};
+
+/*
+ * This list contains devices which have specific issues based on the system
+ * they're on and not just the device itself. The driver_data will have a
+ * specific hid device to match against.
+ */
+static const struct dmi_system_id i2c_hid_dmi_quirk_table[] = {
+	{
+		.ident = "DynaBook K50/FR",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dynabook Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "dynabook K50/FR"),
+		},
+		.driver_data = (void *)&i2c_hid_elan_flipped_quirks,
+	},
+	{ }	/* Terminate list */
+};
+
 
 struct i2c_hid_desc *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name)
 {
@@ -450,3 +474,22 @@ char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 	*size = override->hid_report_desc_size;
 	return override->hid_report_desc;
 }
+
+u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
+{
+	u32 quirks = 0;
+	const struct dmi_system_id *system_id =
+			dmi_first_match(i2c_hid_dmi_quirk_table);
+
+	if (system_id) {
+		const struct hid_device_id *device_id =
+				(struct hid_device_id *)(system_id->driver_data);
+
+		if (device_id && device_id->vendor == vendor &&
+		    device_id->product == product)
+			quirks = device_id->driver_data;
+	}
+
+	return quirks;
+}
+EXPORT_SYMBOL_GPL(i2c_hid_get_dmi_quirks);
diff --git a/drivers/hid/i2c-hid/i2c-hid.h b/drivers/hid/i2c-hid/i2c-hid.h
index 236cc062d5ef8..7b93b6c21f126 100644
--- a/drivers/hid/i2c-hid/i2c-hid.h
+++ b/drivers/hid/i2c-hid/i2c-hid.h
@@ -9,6 +9,7 @@
 struct i2c_hid_desc *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name);
 char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 					       unsigned int *size);
+u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product);
 #else
 static inline struct i2c_hid_desc
 		   *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name)
@@ -16,6 +17,8 @@ static inline struct i2c_hid_desc
 static inline char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 							     unsigned int *size)
 { return NULL; }
+static inline u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
+{ return 0; }
 #endif
 
 /**
-- 
2.39.2



