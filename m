Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B6A37C59C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhELPl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236227AbhELPhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD00461C54;
        Wed, 12 May 2021 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832727;
        bh=uFzse4yyDJgE5qIn6NDkV/QkeInMD7ekJ8/HvF6kFQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tO0QOr/eBluqYY4hr8+ZM18K+il0dCV5uoJC7COUw3+gWMSdIEMp9fc8mdifjRFVN
         VVq6RBIRvCzTRRsFR87ZLEjN194V6RijnHEf3+Hz3LxhkfEIKPnhGILm3V1MjNJpSn
         LidlpnfoxoXPmoSLGWQntR2Q6oRjkfMaAFK/phaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/530] HID: lenovo: Fix lenovo_led_set_tp10ubkbd() error handling
Date:   Wed, 12 May 2021 16:48:27 +0200
Message-Id: <20210512144832.817967855@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 658d04e6eb6be1601ae95d7bee92bbf4096cdc1e ]

Fix the following issues with lenovo_led_set_tp10ubkbd() error handling:

1. On success hid_hw_raw_request() returns the number of bytes sent.
   So we should check for (ret != 3) rather then for (ret != 0).

2. Actually propagate errors to the caller.

3. Since the LEDs are part of an USB keyboard-dock the mute LEDs can go
   away at any time. Don't log an error when ret == -ENODEV and set the
   LED_HW_PLUGGABLE flag to avoid errors getting logged when the USB gets
   disconnected.

Fixes: bc04b37ea0ec ("HID: lenovo: Add ThinkPad 10 Ultrabook Keyboard support")
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 4dc5e5f932ed..ee175ab54281 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -62,8 +62,8 @@ struct lenovo_drvdata {
 #define TP10UBKBD_LED_OFF		1
 #define TP10UBKBD_LED_ON		2
 
-static void lenovo_led_set_tp10ubkbd(struct hid_device *hdev, u8 led_code,
-				     enum led_brightness value)
+static int lenovo_led_set_tp10ubkbd(struct hid_device *hdev, u8 led_code,
+				    enum led_brightness value)
 {
 	struct lenovo_drvdata *data = hid_get_drvdata(hdev);
 	int ret;
@@ -75,10 +75,18 @@ static void lenovo_led_set_tp10ubkbd(struct hid_device *hdev, u8 led_code,
 	data->led_report[2] = value ? TP10UBKBD_LED_ON : TP10UBKBD_LED_OFF;
 	ret = hid_hw_raw_request(hdev, data->led_report[0], data->led_report, 3,
 				 HID_OUTPUT_REPORT, HID_REQ_SET_REPORT);
-	if (ret)
-		hid_err(hdev, "Set LED output report error: %d\n", ret);
+	if (ret != 3) {
+		if (ret != -ENODEV)
+			hid_err(hdev, "Set LED output report error: %d\n", ret);
+
+		ret = ret < 0 ? ret : -EIO;
+	} else {
+		ret = 0;
+	}
 
 	mutex_unlock(&data->led_report_mutex);
+
+	return ret;
 }
 
 static void lenovo_tp10ubkbd_sync_fn_lock(struct work_struct *work)
@@ -349,7 +357,7 @@ static ssize_t attr_fn_lock_store(struct device *dev,
 {
 	struct hid_device *hdev = to_hid_device(dev);
 	struct lenovo_drvdata *data = hid_get_drvdata(hdev);
-	int value;
+	int value, ret;
 
 	if (kstrtoint(buf, 10, &value))
 		return -EINVAL;
@@ -364,7 +372,9 @@ static ssize_t attr_fn_lock_store(struct device *dev,
 		lenovo_features_set_cptkbd(hdev);
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
-		lenovo_led_set_tp10ubkbd(hdev, TP10UBKBD_FN_LOCK_LED, value);
+		ret = lenovo_led_set_tp10ubkbd(hdev, TP10UBKBD_FN_LOCK_LED, value);
+		if (ret)
+			return ret;
 		break;
 	}
 
@@ -785,6 +795,7 @@ static int lenovo_led_brightness_set(struct led_classdev *led_cdev,
 	struct lenovo_drvdata *data_pointer = hid_get_drvdata(hdev);
 	u8 tp10ubkbd_led[] = { TP10UBKBD_MUTE_LED, TP10UBKBD_MICMUTE_LED };
 	int led_nr = 0;
+	int ret = 0;
 
 	if (led_cdev == &data_pointer->led_micmute)
 		led_nr = 1;
@@ -799,11 +810,11 @@ static int lenovo_led_brightness_set(struct led_classdev *led_cdev,
 		lenovo_led_set_tpkbd(hdev);
 		break;
 	case USB_DEVICE_ID_LENOVO_TP10UBKBD:
-		lenovo_led_set_tp10ubkbd(hdev, tp10ubkbd_led[led_nr], value);
+		ret = lenovo_led_set_tp10ubkbd(hdev, tp10ubkbd_led[led_nr], value);
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int lenovo_register_leds(struct hid_device *hdev)
@@ -825,6 +836,7 @@ static int lenovo_register_leds(struct hid_device *hdev)
 	data->led_mute.name = name_mute;
 	data->led_mute.brightness_get = lenovo_led_brightness_get;
 	data->led_mute.brightness_set_blocking = lenovo_led_brightness_set;
+	data->led_mute.flags = LED_HW_PLUGGABLE;
 	data->led_mute.dev = &hdev->dev;
 	ret = led_classdev_register(&hdev->dev, &data->led_mute);
 	if (ret < 0)
@@ -833,6 +845,7 @@ static int lenovo_register_leds(struct hid_device *hdev)
 	data->led_micmute.name = name_micm;
 	data->led_micmute.brightness_get = lenovo_led_brightness_get;
 	data->led_micmute.brightness_set_blocking = lenovo_led_brightness_set;
+	data->led_micmute.flags = LED_HW_PLUGGABLE;
 	data->led_micmute.dev = &hdev->dev;
 	ret = led_classdev_register(&hdev->dev, &data->led_micmute);
 	if (ret < 0) {
-- 
2.30.2



