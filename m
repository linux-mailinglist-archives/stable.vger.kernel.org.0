Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD3A14DA7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfEFOyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbfEFOrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2345420449;
        Mon,  6 May 2019 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154022;
        bh=3JVlmMrmZ8inwgitDqC6YIIsyrdFyhAUdtAx4FXiL2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+kUS72Oup49jzQMGYYrsr7nsI5qHJf+kiLfyIhidqA9+PZIYwkaAj9c05PLh3Vrg
         KhbVwkYOoKMAr9j1sxKRqZLYOqG6Ip9B7WGcAbokhPfM4kheHX3qE1p+ejKPg16rU+
         eugao9BwJu2/hOX6vLU/aObI4XlYrhBhT7HrDdmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christo Gouws <gouws.christo@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 01/62] ALSA: line6: use dynamic buffers
Date:   Mon,  6 May 2019 16:32:32 +0200
Message-Id: <20190506143051.233540661@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit e5c812e84f0dece3400d5caf42522287e6ef139f upstream.

The line6 driver uses a lot of USB buffers off of the stack, which is
not allowed on many systems, causing the driver to crash on some of
them.  Fix this up by dynamically allocating the buffers with kmalloc()
which allows for proper DMA-able memory.

Reported-by: Christo Gouws <gouws.christo@gmail.com>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Christo Gouws <gouws.christo@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/driver.c   |   60 ++++++++++++++++++++++++++-------------------
 sound/usb/line6/podhd.c    |   21 +++++++++------
 sound/usb/line6/toneport.c |   24 +++++++++++++-----
 3 files changed, 65 insertions(+), 40 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -337,12 +337,16 @@ int line6_read_data(struct usb_line6 *li
 {
 	struct usb_device *usbdev = line6->usbdev;
 	int ret;
-	unsigned char len;
+	unsigned char *len;
 	unsigned count;
 
 	if (address > 0xffff || datalen > 0xff)
 		return -EINVAL;
 
+	len = kmalloc(sizeof(*len), GFP_KERNEL);
+	if (!len)
+		return -ENOMEM;
+
 	/* query the serial number: */
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
@@ -351,7 +355,7 @@ int line6_read_data(struct usb_line6 *li
 
 	if (ret < 0) {
 		dev_err(line6->ifcdev, "read request failed (error %d)\n", ret);
-		return ret;
+		goto exit;
 	}
 
 	/* Wait for data length. We'll get 0xff until length arrives. */
@@ -361,28 +365,29 @@ int line6_read_data(struct usb_line6 *li
 		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
-				      0x0012, 0x0000, &len, 1,
+				      0x0012, 0x0000, len, 1,
 				      LINE6_TIMEOUT * HZ);
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
 				"receive length failed (error %d)\n", ret);
-			return ret;
+			goto exit;
 		}
 
-		if (len != 0xff)
+		if (*len != 0xff)
 			break;
 	}
 
-	if (len == 0xff) {
+	ret = -EIO;
+	if (*len == 0xff) {
 		dev_err(line6->ifcdev, "read failed after %d retries\n",
 			count);
-		return -EIO;
-	} else if (len != datalen) {
+		goto exit;
+	} else if (*len != datalen) {
 		/* should be equal or something went wrong */
 		dev_err(line6->ifcdev,
 			"length mismatch (expected %d, got %d)\n",
-			(int)datalen, (int)len);
-		return -EIO;
+			(int)datalen, (int)*len);
+		goto exit;
 	}
 
 	/* receive the result: */
@@ -391,12 +396,12 @@ int line6_read_data(struct usb_line6 *li
 			      0x0013, 0x0000, data, datalen,
 			      LINE6_TIMEOUT * HZ);
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(line6->ifcdev, "read failed (error %d)\n", ret);
-		return ret;
-	}
 
-	return 0;
+exit:
+	kfree(len);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(line6_read_data);
 
@@ -408,12 +413,16 @@ int line6_write_data(struct usb_line6 *l
 {
 	struct usb_device *usbdev = line6->usbdev;
 	int ret;
-	unsigned char status;
+	unsigned char *status;
 	int count;
 
 	if (address > 0xffff || datalen > 0xffff)
 		return -EINVAL;
 
+	status = kmalloc(sizeof(*status), GFP_KERNEL);
+	if (!status)
+		return -ENOMEM;
+
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0), 0x67,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 			      0x0022, address, data, datalen,
@@ -422,7 +431,7 @@ int line6_write_data(struct usb_line6 *l
 	if (ret < 0) {
 		dev_err(line6->ifcdev,
 			"write request failed (error %d)\n", ret);
-		return ret;
+		goto exit;
 	}
 
 	for (count = 0; count < LINE6_READ_WRITE_MAX_RETRIES; count++) {
@@ -433,28 +442,29 @@ int line6_write_data(struct usb_line6 *l
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				      USB_DIR_IN,
 				      0x0012, 0x0000,
-				      &status, 1, LINE6_TIMEOUT * HZ);
+				      status, 1, LINE6_TIMEOUT * HZ);
 
 		if (ret < 0) {
 			dev_err(line6->ifcdev,
 				"receiving status failed (error %d)\n", ret);
-			return ret;
+			goto exit;
 		}
 
-		if (status != 0xff)
+		if (*status != 0xff)
 			break;
 	}
 
-	if (status == 0xff) {
+	if (*status == 0xff) {
 		dev_err(line6->ifcdev, "write failed after %d retries\n",
 			count);
-		return -EIO;
-	} else if (status != 0) {
+		ret = -EIO;
+	} else if (*status != 0) {
 		dev_err(line6->ifcdev, "write failed (error %d)\n", ret);
-		return -EIO;
+		ret = -EIO;
 	}
-
-	return 0;
+exit:
+	kfree(status);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(line6_write_data);
 
--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -221,28 +221,32 @@ static void podhd_startup_start_workqueu
 static int podhd_dev_start(struct usb_line6_podhd *pod)
 {
 	int ret;
-	u8 init_bytes[8];
+	u8 *init_bytes;
 	int i;
 	struct usb_device *usbdev = pod->line6.usbdev;
 
+	init_bytes = kmalloc(8, GFP_KERNEL);
+	if (!init_bytes)
+		return -ENOMEM;
+
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
 					0x67, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 					0x11, 0,
 					NULL, 0, LINE6_TIMEOUT * HZ);
 	if (ret < 0) {
 		dev_err(pod->line6.ifcdev, "read request failed (error %d)\n", ret);
-		return ret;
+		goto exit;
 	}
 
 	/* NOTE: looks like some kind of ping message */
 	ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 					USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
 					0x11, 0x0,
-					&init_bytes, 3, LINE6_TIMEOUT * HZ);
+					init_bytes, 3, LINE6_TIMEOUT * HZ);
 	if (ret < 0) {
 		dev_err(pod->line6.ifcdev,
 			"receive length failed (error %d)\n", ret);
-		return ret;
+		goto exit;
 	}
 
 	pod->firmware_version =
@@ -251,7 +255,7 @@ static int podhd_dev_start(struct usb_li
 	for (i = 0; i <= 16; i++) {
 		ret = line6_read_data(&pod->line6, 0xf000 + 0x08 * i, init_bytes, 8);
 		if (ret < 0)
-			return ret;
+			goto exit;
 	}
 
 	ret = usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
@@ -259,10 +263,9 @@ static int podhd_dev_start(struct usb_li
 					USB_TYPE_STANDARD | USB_RECIP_DEVICE | USB_DIR_OUT,
 					1, 0,
 					NULL, 0, LINE6_TIMEOUT * HZ);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+exit:
+	kfree(init_bytes);
+	return ret;
 }
 
 static void podhd_startup_workqueue(struct work_struct *work)
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -365,15 +365,20 @@ static bool toneport_has_source_select(s
 /*
 	Setup Toneport device.
 */
-static void toneport_setup(struct usb_line6_toneport *toneport)
+static int toneport_setup(struct usb_line6_toneport *toneport)
 {
-	int ticks;
+	int *ticks;
 	struct usb_line6 *line6 = &toneport->line6;
 	struct usb_device *usbdev = line6->usbdev;
 
+	ticks = kmalloc(sizeof(*ticks), GFP_KERNEL);
+	if (!ticks)
+		return -ENOMEM;
+
 	/* sync time on device with host: */
-	ticks = (int)get_seconds();
-	line6_write_data(line6, 0x80c6, &ticks, 4);
+	*ticks = (int)get_seconds();
+	line6_write_data(line6, 0x80c6, ticks, 4);
+	kfree(ticks);
 
 	/* enable device: */
 	toneport_send_cmd(usbdev, 0x0301, 0x0000);
@@ -388,6 +393,7 @@ static void toneport_setup(struct usb_li
 		toneport_update_led(toneport);
 
 	mod_timer(&toneport->timer, jiffies + TONEPORT_PCM_DELAY * HZ);
+	return 0;
 }
 
 /*
@@ -451,7 +457,9 @@ static int toneport_init(struct usb_line
 			return err;
 	}
 
-	toneport_setup(toneport);
+	err = toneport_setup(toneport);
+	if (err)
+		return err;
 
 	/* register audio system: */
 	return snd_card_register(line6->card);
@@ -463,7 +471,11 @@ static int toneport_init(struct usb_line
 */
 static int toneport_reset_resume(struct usb_interface *interface)
 {
-	toneport_setup(usb_get_intfdata(interface));
+	int err;
+
+	err = toneport_setup(usb_get_intfdata(interface));
+	if (err)
+		return err;
 	return line6_resume(interface);
 }
 #endif


