Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A5E3BBF23
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhGEPbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhGEPb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF77061997;
        Mon,  5 Jul 2021 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498932;
        bh=GGSDtAdxzjHSHDsf8YrTAWML9GL98TFyDuH7C4/yPtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpnu/fLfDnxs5IeB2sPeju4K2dVQU4AoRy7Abr3qI4LbNlNU5uPsEfxTd9ZGbb11t
         4iAPa4/UAiW3BpKdpHqpIqS9ARCXKgHScQshamCeCKS/r3rKcBrZQ8qAmSz6h/6que
         TmIL809mW23tSdanHkWrosVJ89PYHV5kYS8rR36uyoJsiSi8ABOLvO83rfKSyynt48
         FPnrwjhZ4k83UAIEdH/EiJ0yLfnHFnhHvsvbDaHFBv0RTtMnl9V8JeA5leyMjh2VaE
         00djRgz7N7jlpYJW+xLA8lxcEZH48efVUK1gt7+5YYvmfpE/Z9CxBdYXvc730CBHso
         P+2MbkLdZUsiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pascal Giard <pascal.giard@etsmtl.ca>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 28/59] HID: sony: fix freeze when inserting ghlive ps3/wii dongles
Date:   Mon,  5 Jul 2021 11:27:44 -0400
Message-Id: <20210705152815.1520546-28-sashal@kernel.org>
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

From: Pascal Giard <pascal.giard@etsmtl.ca>

[ Upstream commit fb1a79a6b6e1223ddb18f12aa35e36f832da2290 ]

This commit fixes a freeze on insertion of a Guitar Hero Live PS3/WiiU
USB dongle. Indeed, with the current implementation, inserting one of
those USB dongles will lead to a hard freeze. I apologize for not
catching this earlier, it didn't occur on my old laptop.

While the issue was isolated to memory alloc/free, I could not figure
out why it causes a freeze. So this patch fixes this issue by
simplifying memory allocation and usage.

We remind that for the dongle to work properly, a control URB needs to
be sent periodically. We used to alloc/free the URB each time this URB
needed to be sent.

With this patch, the memory for the URB is allocated on the probe, reused
for as long as the dongle is plugged in, and freed once the dongle is
unplugged.

Signed-off-by: Pascal Giard <pascal.giard@etsmtl.ca>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 98 +++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 8319b0ce385a..b3722c51ec78 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -597,9 +597,8 @@ struct sony_sc {
 	/* DS4 calibration data */
 	struct ds4_calibration_data ds4_calib_data[6];
 	/* GH Live */
+	struct urb *ghl_urb;
 	struct timer_list ghl_poke_timer;
-	struct usb_ctrlrequest *ghl_cr;
-	u8 *ghl_databuf;
 };
 
 static void sony_set_leds(struct sony_sc *sc);
@@ -625,66 +624,54 @@ static inline void sony_schedule_work(struct sony_sc *sc,
 
 static void ghl_magic_poke_cb(struct urb *urb)
 {
-	if (urb) {
-		/* Free sc->ghl_cr and sc->ghl_databuf allocated in
-		 * ghl_magic_poke()
-		 */
-		kfree(urb->setup_packet);
-		kfree(urb->transfer_buffer);
-	}
+	struct sony_sc *sc = urb->context;
+
+	if (urb->status < 0)
+		hid_err(sc->hdev, "URB transfer failed : %d", urb->status);
+
+	mod_timer(&sc->ghl_poke_timer, jiffies + GHL_GUITAR_POKE_INTERVAL*HZ);
 }
 
 static void ghl_magic_poke(struct timer_list *t)
 {
+	int ret;
 	struct sony_sc *sc = from_timer(sc, t, ghl_poke_timer);
 
-	int ret;
+	ret = usb_submit_urb(sc->ghl_urb, GFP_ATOMIC);
+	if (ret < 0)
+		hid_err(sc->hdev, "usb_submit_urb failed: %d", ret);
+}
+
+static int ghl_init_urb(struct sony_sc *sc, struct usb_device *usbdev)
+{
+	struct usb_ctrlrequest *cr;
+	u16 poke_size;
+	u8 *databuf;
 	unsigned int pipe;
-	struct urb *urb;
-	struct usb_device *usbdev = to_usb_device(sc->hdev->dev.parent->parent);
-	const u16 poke_size =
-		ARRAY_SIZE(ghl_ps3wiiu_magic_data);
 
+	poke_size = ARRAY_SIZE(ghl_ps3wiiu_magic_data);
 	pipe = usb_sndctrlpipe(usbdev, 0);
 
-	if (!sc->ghl_cr) {
-		sc->ghl_cr = kzalloc(sizeof(*sc->ghl_cr), GFP_ATOMIC);
-		if (!sc->ghl_cr)
-			goto resched;
-	}
-
-	if (!sc->ghl_databuf) {
-		sc->ghl_databuf = kzalloc(poke_size, GFP_ATOMIC);
-		if (!sc->ghl_databuf)
-			goto resched;
-	}
+	cr = devm_kzalloc(&sc->hdev->dev, sizeof(*cr), GFP_ATOMIC);
+	if (cr == NULL)
+		return -ENOMEM;
 
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!urb)
-		goto resched;
+	databuf = devm_kzalloc(&sc->hdev->dev, poke_size, GFP_ATOMIC);
+	if (databuf == NULL)
+		return -ENOMEM;
 
-	sc->ghl_cr->bRequestType =
+	cr->bRequestType =
 		USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT;
-	sc->ghl_cr->bRequest = USB_REQ_SET_CONFIGURATION;
-	sc->ghl_cr->wValue = cpu_to_le16(ghl_ps3wiiu_magic_value);
-	sc->ghl_cr->wIndex = 0;
-	sc->ghl_cr->wLength = cpu_to_le16(poke_size);
-	memcpy(sc->ghl_databuf, ghl_ps3wiiu_magic_data, poke_size);
-
+	cr->bRequest = USB_REQ_SET_CONFIGURATION;
+	cr->wValue = cpu_to_le16(ghl_ps3wiiu_magic_value);
+	cr->wIndex = 0;
+	cr->wLength = cpu_to_le16(poke_size);
+	memcpy(databuf, ghl_ps3wiiu_magic_data, poke_size);
 	usb_fill_control_urb(
-		urb, usbdev, pipe,
-		(unsigned char *) sc->ghl_cr, sc->ghl_databuf,
-		poke_size, ghl_magic_poke_cb, NULL);
-	ret = usb_submit_urb(urb, GFP_ATOMIC);
-	if (ret < 0) {
-		kfree(sc->ghl_databuf);
-		kfree(sc->ghl_cr);
-	}
-	usb_free_urb(urb);
-
-resched:
-	/* Reschedule for next time */
-	mod_timer(&sc->ghl_poke_timer, jiffies + GHL_GUITAR_POKE_INTERVAL*HZ);
+		sc->ghl_urb, usbdev, pipe,
+		(unsigned char *) cr, databuf, poke_size,
+		ghl_magic_poke_cb, sc);
+	return 0;
 }
 
 static int guitar_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -2981,6 +2968,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret;
 	unsigned long quirks = id->driver_data;
 	struct sony_sc *sc;
+	struct usb_device *usbdev;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 
 	if (!strcmp(hdev->name, "FutureMax Dance Mat"))
@@ -3000,6 +2988,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
 	sc->hdev = hdev;
+	usbdev = to_usb_device(sc->hdev->dev.parent->parent);
 
 	ret = hid_parse(hdev);
 	if (ret) {
@@ -3042,6 +3031,15 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	if (sc->quirks & GHL_GUITAR_PS3WIIU) {
+		sc->ghl_urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!sc->ghl_urb)
+			return -ENOMEM;
+		ret = ghl_init_urb(sc, usbdev);
+		if (ret) {
+			hid_err(hdev, "error preparing URB\n");
+			return ret;
+		}
+
 		timer_setup(&sc->ghl_poke_timer, ghl_magic_poke, 0);
 		mod_timer(&sc->ghl_poke_timer,
 			  jiffies + GHL_GUITAR_POKE_INTERVAL*HZ);
@@ -3054,8 +3052,10 @@ static void sony_remove(struct hid_device *hdev)
 {
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
-	if (sc->quirks & GHL_GUITAR_PS3WIIU)
+	if (sc->quirks & GHL_GUITAR_PS3WIIU) {
 		del_timer_sync(&sc->ghl_poke_timer);
+		usb_free_urb(sc->ghl_urb);
+	}
 
 	hid_hw_close(hdev);
 
-- 
2.30.2

