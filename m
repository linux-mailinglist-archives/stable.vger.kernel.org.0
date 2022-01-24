Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBB0499BF7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380076AbiAXV6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575178AbiAXVvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:51:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1AFC09399A;
        Mon, 24 Jan 2022 12:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA646614EC;
        Mon, 24 Jan 2022 20:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6F2C340E5;
        Mon, 24 Jan 2022 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056438;
        bh=1EyoLpH3u/C9VtsMId1mXlNNHGrLClCkoMSf0/DC940=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLgTzt1yc5ItOqDI8P+TLqBjsG/ARSuemdOe/hGg6U2jspgAt9xWSHYGZ5tCQ0Wid
         Wwxg4gmdEjv7KguZbJRCvOdm7Xb7IPB1qSINAsc7DJDcETIhjYkEplbvaRVQs72FOj
         Why7G/wKE9E7cCHF7E/9Hlz4o0/g7L1IzEZwaF8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/846] HID: magicmouse: Report battery level over USB
Date:   Mon, 24 Jan 2022 19:40:02 +0100
Message-Id: <20220124184117.738416048@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 0b91b4e4dae63cd43871fc2012370b86ee588f91 ]

When connected over USB, the Apple Magic Mouse 2 and the Apple Magic
Trackpad 2 register multiple interfaces, one of them is used to report
the battery level.

However, unlike when connected over Bluetooth, the battery level is not
reported automatically and it is required to fetch it manually.

Fix the battery report descriptor and add a timer to fetch the battery
level.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 94 +++++++++++++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index d7687ce706144..eba1e8087bfd1 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -57,6 +57,8 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
 #define MOUSE_REPORT_ID    0x29
 #define MOUSE2_REPORT_ID   0x12
 #define DOUBLE_REPORT_ID   0xf7
+#define USB_BATTERY_TIMEOUT_MS 60000
+
 /* These definitions are not precise, but they're close enough.  (Bits
  * 0x03 seem to indicate the aspect ratio of the touch, bits 0x70 seem
  * to be some kind of bit mask -- 0x20 may be a near-field reading,
@@ -140,6 +142,7 @@ struct magicmouse_sc {
 
 	struct hid_device *hdev;
 	struct delayed_work work;
+	struct timer_list battery_timer;
 };
 
 static int magicmouse_firm_touch(struct magicmouse_sc *msc)
@@ -738,6 +741,44 @@ static void magicmouse_enable_mt_work(struct work_struct *work)
 		hid_err(msc->hdev, "unable to request touch data (%d)\n", ret);
 }
 
+static int magicmouse_fetch_battery(struct hid_device *hdev)
+{
+#ifdef CONFIG_HID_BATTERY_STRENGTH
+	struct hid_report_enum *report_enum;
+	struct hid_report *report;
+
+	if (!hdev->battery || hdev->vendor != USB_VENDOR_ID_APPLE ||
+	    (hdev->product != USB_DEVICE_ID_APPLE_MAGICMOUSE2 &&
+	     hdev->product != USB_DEVICE_ID_APPLE_MAGICTRACKPAD2))
+		return -1;
+
+	report_enum = &hdev->report_enum[hdev->battery_report_type];
+	report = report_enum->report_id_hash[hdev->battery_report_id];
+
+	if (!report || report->maxfield < 1)
+		return -1;
+
+	if (hdev->battery_capacity == hdev->battery_max)
+		return -1;
+
+	hid_hw_request(hdev, report, HID_REQ_GET_REPORT);
+	return 0;
+#else
+	return -1;
+#endif
+}
+
+static void magicmouse_battery_timer_tick(struct timer_list *t)
+{
+	struct magicmouse_sc *msc = from_timer(msc, t, battery_timer);
+	struct hid_device *hdev = msc->hdev;
+
+	if (magicmouse_fetch_battery(hdev) == 0) {
+		mod_timer(&msc->battery_timer,
+			  jiffies + msecs_to_jiffies(USB_BATTERY_TIMEOUT_MS));
+	}
+}
+
 static int magicmouse_probe(struct hid_device *hdev,
 	const struct hid_device_id *id)
 {
@@ -745,11 +786,6 @@ static int magicmouse_probe(struct hid_device *hdev,
 	struct hid_report *report;
 	int ret;
 
-	if (id->vendor == USB_VENDOR_ID_APPLE &&
-	    id->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2 &&
-	    hdev->type != HID_TYPE_USBMOUSE)
-		return -ENODEV;
-
 	msc = devm_kzalloc(&hdev->dev, sizeof(*msc), GFP_KERNEL);
 	if (msc == NULL) {
 		hid_err(hdev, "can't alloc magicmouse descriptor\n");
@@ -775,6 +811,16 @@ static int magicmouse_probe(struct hid_device *hdev,
 		return ret;
 	}
 
+	timer_setup(&msc->battery_timer, magicmouse_battery_timer_tick, 0);
+	mod_timer(&msc->battery_timer,
+		  jiffies + msecs_to_jiffies(USB_BATTERY_TIMEOUT_MS));
+	magicmouse_fetch_battery(hdev);
+
+	if (id->vendor == USB_VENDOR_ID_APPLE &&
+	    (id->product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
+	     (id->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2 && hdev->type != HID_TYPE_USBMOUSE)))
+		return 0;
+
 	if (!msc->input) {
 		hid_err(hdev, "magicmouse input not registered\n");
 		ret = -ENOMEM;
@@ -835,17 +881,52 @@ static void magicmouse_remove(struct hid_device *hdev)
 {
 	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
 
-	if (msc)
+	if (msc) {
 		cancel_delayed_work_sync(&msc->work);
+		del_timer_sync(&msc->battery_timer);
+	}
 
 	hid_hw_stop(hdev);
 }
 
+static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+				     unsigned int *rsize)
+{
+	/*
+	 * Change the usage from:
+	 *   0x06, 0x00, 0xff, // Usage Page (Vendor Defined Page 1)  0
+	 *   0x09, 0x0b,       // Usage (Vendor Usage 0x0b)           3
+	 * To:
+	 *   0x05, 0x01,       // Usage Page (Generic Desktop)        0
+	 *   0x09, 0x02,       // Usage (Mouse)                       2
+	 */
+	if (hdev->vendor == USB_VENDOR_ID_APPLE &&
+	    (hdev->product == USB_DEVICE_ID_APPLE_MAGICMOUSE2 ||
+	     hdev->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2) &&
+	    *rsize == 83 && rdesc[46] == 0x84 && rdesc[58] == 0x85) {
+		hid_info(hdev,
+			 "fixing up magicmouse battery report descriptor\n");
+		*rsize = *rsize - 1;
+		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
+		if (!rdesc)
+			return NULL;
+
+		rdesc[0] = 0x05;
+		rdesc[1] = 0x01;
+		rdesc[2] = 0x09;
+		rdesc[3] = 0x02;
+	}
+
+	return rdesc;
+}
+
 static const struct hid_device_id magic_mice[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_MAGICMOUSE), .driver_data = 0 },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_MAGICMOUSE2), .driver_data = 0 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE,
+		USB_DEVICE_ID_APPLE_MAGICMOUSE2), .driver_data = 0 },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_MAGICTRACKPAD), .driver_data = 0 },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE,
@@ -861,6 +942,7 @@ static struct hid_driver magicmouse_driver = {
 	.id_table = magic_mice,
 	.probe = magicmouse_probe,
 	.remove = magicmouse_remove,
+	.report_fixup = magicmouse_report_fixup,
 	.raw_event = magicmouse_raw_event,
 	.event = magicmouse_event,
 	.input_mapping = magicmouse_input_mapping,
-- 
2.34.1



