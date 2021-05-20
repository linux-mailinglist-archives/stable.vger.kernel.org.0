Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1052638AB1B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbhETLU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240711AbhETLTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED5361D7A;
        Thu, 20 May 2021 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505424;
        bh=X3SnReuXDsKphPexqYIEMg+WHYb1iuXlfu/gsByQGKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/0nCD+1ImE/G3hVcVC12AFOoYlNyvJQZLgD//0L3N3mRncs0NYnT9I6u4rB/gx3W
         KzEn9U3jqcQyLLbgx5xyAYbuVNfO2png7a7CajJD0h8jpbV1Yk84/prkG2JX5lUQkA
         gpbElO4RLFX4o1bgmR46BeLA703ccCXtW9baQupM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 111/190] HID: plantronics: Workaround for double volume key presses
Date:   Thu, 20 May 2021 11:22:55 +0200
Message-Id: <20210520092105.864707827@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit f567d6ef8606fb427636e824c867229ecb5aefab ]

Plantronics Blackwire 3220 Series (047f:c056) sends HID reports twice
for each volume key press. This patch adds a quirk to hid-plantronics
for this product ID, which will ignore the second volume key press if
it happens within 5 ms from the last one that was handled.

The patch was tested on the mentioned model only, it shouldn't affect
other models, however, this quirk might be needed for them too.
Auto-repeat (when a key is held pressed) is not affected, because the
rate is about 3 times per second, which is far less frequent than once
in 5 ms.

Fixes: 81bb773faed7 ("HID: plantronics: Update to map volume up/down controls")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h         |  1 +
 drivers/hid/hid-plantronics.c | 60 +++++++++++++++++++++++++++++++++--
 include/linux/hid.h           |  2 ++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 773452c6edfa..cbf13e993902 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -769,6 +769,7 @@
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index 584b10d3fc3d..460711c1124a 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -16,6 +16,7 @@
 
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 
 #define PLT_HID_1_0_PAGE	0xffa00000
 #define PLT_HID_2_0_PAGE	0xffa20000
@@ -39,6 +40,16 @@
 #define PLT_ALLOW_CONSUMER (field->application == HID_CP_CONSUMERCONTROL && \
 			    (usage->hid & HID_USAGE_PAGE) == HID_UP_CONSUMER)
 
+#define PLT_QUIRK_DOUBLE_VOLUME_KEYS BIT(0)
+
+#define PLT_DOUBLE_KEY_TIMEOUT 5 /* ms */
+
+struct plt_drv_data {
+	unsigned long device_type;
+	unsigned long last_volume_key_ts;
+	u32 quirks;
+};
+
 static int plantronics_input_mapping(struct hid_device *hdev,
 				     struct hid_input *hi,
 				     struct hid_field *field,
@@ -46,7 +57,8 @@ static int plantronics_input_mapping(struct hid_device *hdev,
 				     unsigned long **bit, int *max)
 {
 	unsigned short mapped_key;
-	unsigned long plt_type = (unsigned long)hid_get_drvdata(hdev);
+	struct plt_drv_data *drv_data = hid_get_drvdata(hdev);
+	unsigned long plt_type = drv_data->device_type;
 
 	/* special case for PTT products */
 	if (field->application == HID_GD_JOYSTICK)
@@ -108,6 +120,30 @@ mapped:
 	return 1;
 }
 
+static int plantronics_event(struct hid_device *hdev, struct hid_field *field,
+			     struct hid_usage *usage, __s32 value)
+{
+	struct plt_drv_data *drv_data = hid_get_drvdata(hdev);
+
+	if (drv_data->quirks & PLT_QUIRK_DOUBLE_VOLUME_KEYS) {
+		unsigned long prev_ts, cur_ts;
+
+		/* Usages are filtered in plantronics_usages. */
+
+		if (!value) /* Handle key presses only. */
+			return 0;
+
+		prev_ts = drv_data->last_volume_key_ts;
+		cur_ts = jiffies;
+		if (jiffies_to_msecs(cur_ts - prev_ts) <= PLT_DOUBLE_KEY_TIMEOUT)
+			return 1; /* Ignore the repeated key. */
+
+		drv_data->last_volume_key_ts = cur_ts;
+	}
+
+	return 0;
+}
+
 static unsigned long plantronics_device_type(struct hid_device *hdev)
 {
 	unsigned i, col_page;
@@ -136,15 +172,24 @@ exit:
 static int plantronics_probe(struct hid_device *hdev,
 			     const struct hid_device_id *id)
 {
+	struct plt_drv_data *drv_data;
 	int ret;
 
+	drv_data = devm_kzalloc(&hdev->dev, sizeof(*drv_data), GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
-	hid_set_drvdata(hdev, (void *)plantronics_device_type(hdev));
+	drv_data->device_type = plantronics_device_type(hdev);
+	drv_data->quirks = id->driver_data;
+	drv_data->last_volume_key_ts = jiffies - msecs_to_jiffies(PLT_DOUBLE_KEY_TIMEOUT);
+
+	hid_set_drvdata(hdev, drv_data);
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT |
 		HID_CONNECT_HIDINPUT_FORCE | HID_CONNECT_HIDDEV_FORCE);
@@ -156,15 +201,26 @@ err:
 }
 
 static const struct hid_device_id plantronics_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, plantronics_devices);
 
+static const struct hid_usage_id plantronics_usages[] = {
+	{ HID_CP_VOLUMEUP, EV_KEY, HID_ANY_ID },
+	{ HID_CP_VOLUMEDOWN, EV_KEY, HID_ANY_ID },
+	{ HID_TERMINATOR, HID_TERMINATOR, HID_TERMINATOR }
+};
+
 static struct hid_driver plantronics_driver = {
 	.name = "plantronics",
 	.id_table = plantronics_devices,
+	.usage_table = plantronics_usages,
 	.input_mapping = plantronics_input_mapping,
+	.event = plantronics_event,
 	.probe = plantronics_probe,
 };
 module_hid_driver(plantronics_driver);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d93ba6014e3c..19c53b64e07a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -246,6 +246,8 @@ struct hid_item {
 #define HID_CP_SELECTION	0x000c0080
 #define HID_CP_MEDIASELECTION	0x000c0087
 #define HID_CP_SELECTDISC	0x000c00ba
+#define HID_CP_VOLUMEUP		0x000c00e9
+#define HID_CP_VOLUMEDOWN	0x000c00ea
 #define HID_CP_PLAYBACKSPEED	0x000c00f1
 #define HID_CP_PROXIMITY	0x000c0109
 #define HID_CP_SPEAKERSYSTEM	0x000c0160
-- 
2.30.2



