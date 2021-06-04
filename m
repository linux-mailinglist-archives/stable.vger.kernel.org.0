Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4410C39BCAA
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFDQM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 12:12:57 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:44754 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhFDQM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 12:12:57 -0400
Received: by mail-qt1-f174.google.com with SMTP id t17so7349043qta.11;
        Fri, 04 Jun 2021 09:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uw8SvaDBx6CB4Sz2J3BnNziO0DD2dTJgr3kfefUav3s=;
        b=OUmQoMuVsl2/gdLYLGBIjFOQIlXF/4+bioeib8WUyK8XJc6U+z/IFUAIHg5o2obLEH
         dwmSW+lt+dU/xTi0UfN4HZjyiZeHUc/tVSj+cQwnapk3+PuvVsu6SpBdFVTlqYC39YA1
         Xy9uc+j5d3F7xYbobyUa+dLmYM49MvNVi1irMz6l+bvRjp1+/C6mzDn50awTmMjYtSco
         WKw+pVrPzd201qy/IfqcXnTVU+yxo/UedwWDwD1VNF3zPyibAiBScGVO6e7UC8uioqyS
         o1RoASylsg+6gn3iYVilVw+A5976dwdANoeADioL9t2wQ0jwucedR4XDOdWKILlUwuDP
         PdcQ==
X-Gm-Message-State: AOAM530YOzDW1ggPbVVyRStwNQQKovo8dyodSntx0f5I/U4VWatF+rRo
        JVO9A8pmlazXGcQUBckaHfA=
X-Google-Smtp-Source: ABdhPJxObLXPGZwGZJpqoP+Y316Gdp2qDstHl41j6DquUhApzUyMGxqtxK2uMM5oCpN3vKAfKG4Pnw==
X-Received: by 2002:a05:622a:1185:: with SMTP id m5mr5298924qtk.140.1622823054270;
        Fri, 04 Jun 2021 09:10:54 -0700 (PDT)
Received: from localhost.localdomain ([104.221.112.78])
        by smtp.gmail.com with ESMTPSA id e128sm4213541qkd.127.2021.06.04.09.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 09:10:53 -0700 (PDT)
From:   Pascal Giard <pascal.giard@etsmtl.ca>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Pascal Giard <pascal.giard@etsmtl.ca>,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
Subject: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii dongles
Date:   Fri,  4 Jun 2021 12:10:23 -0400
Message-Id: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
X-Mailer: git-send-email 2.32.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.32.0.rc2

