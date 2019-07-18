Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5146C661
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391514AbfGRDQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392006AbfGRDPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:20 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199BA21872;
        Thu, 18 Jul 2019 03:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419720;
        bh=hxhu6yz9h1gTOTuqm0e6PqzRXg9uHM908FZydBq4KSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYhP47Oxc2oc40FNAuJrvHS7jK+D0Nx9fs66Rl3juFMOwyjqNIYHIfKnluSonWD2B
         l3wuSr9dac/vIJgWfMq4EQkoifXRSd6bG7Ba0tSwE/fgAlnaP/K8rC9esnXNAzDav5
         GpSXLHAifKsAWHRbrWc//sU13G0hdOhblrI6YdWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 25/40] carl9170: fix misuse of device driver API
Date:   Thu, 18 Jul 2019 12:02:21 +0900
Message-Id: <20190718030048.988349013@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit feb09b2933275a70917a869989ea2823e7356be8 upstream.

This patch follows Alan Stern's recent patch:
"p54: Fix race between disconnect and firmware loading"

that overhauled carl9170 buggy firmware loading and driver
unbinding procedures.

Since the carl9170 code was adapted from p54 it uses the
same functions and is likely to have the same problem, but
it's just that the syzbot hasn't reproduce them (yet).

a summary from the changes (copied from the p54 patch):
 * Call usb_driver_release_interface() rather than
   device_release_driver().

 * Lock udev (the interface's parent) before unbinding the
   driver instead of locking udev->parent.

 * During the firmware loading process, take a reference
   to the USB interface instead of the USB device.

 * Don't take an unnecessary reference to the device during
   probe (and then don't drop it during disconnect).

and

 * Make sure to prevent use-after-free bugs by explicitly
   setting the driver context to NULL after signaling the
   completion.

Cc: <stable@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/carl9170/usb.c |   39 +++++++++++++-------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -128,6 +128,8 @@ static struct usb_device_id carl9170_usb
 };
 MODULE_DEVICE_TABLE(usb, carl9170_usb_ids);
 
+static struct usb_driver carl9170_driver;
+
 static void carl9170_usb_submit_data_urb(struct ar9170 *ar)
 {
 	struct urb *urb;
@@ -968,32 +970,28 @@ err_out:
 
 static void carl9170_usb_firmware_failed(struct ar9170 *ar)
 {
-	struct device *parent = ar->udev->dev.parent;
-	struct usb_device *udev;
-
-	/*
-	 * Store a copy of the usb_device pointer locally.
-	 * This is because device_release_driver initiates
-	 * carl9170_usb_disconnect, which in turn frees our
-	 * driver context (ar).
+	/* Store a copies of the usb_interface and usb_device pointer locally.
+	 * This is because release_driver initiates carl9170_usb_disconnect,
+	 * which in turn frees our driver context (ar).
 	 */
-	udev = ar->udev;
+	struct usb_interface *intf = ar->intf;
+	struct usb_device *udev = ar->udev;
 
 	complete(&ar->fw_load_wait);
+	/* at this point 'ar' could be already freed. Don't use it anymore */
+	ar = NULL;
 
 	/* unbind anything failed */
-	if (parent)
-		device_lock(parent);
-
-	device_release_driver(&udev->dev);
-	if (parent)
-		device_unlock(parent);
+	usb_lock_device(udev);
+	usb_driver_release_interface(&carl9170_driver, intf);
+	usb_unlock_device(udev);
 
-	usb_put_dev(udev);
+	usb_put_intf(intf);
 }
 
 static void carl9170_usb_firmware_finish(struct ar9170 *ar)
 {
+	struct usb_interface *intf = ar->intf;
 	int err;
 
 	err = carl9170_parse_firmware(ar);
@@ -1011,7 +1009,7 @@ static void carl9170_usb_firmware_finish
 		goto err_unrx;
 
 	complete(&ar->fw_load_wait);
-	usb_put_dev(ar->udev);
+	usb_put_intf(intf);
 	return;
 
 err_unrx:
@@ -1054,7 +1052,6 @@ static int carl9170_usb_probe(struct usb
 		return PTR_ERR(ar);
 
 	udev = interface_to_usbdev(intf);
-	usb_get_dev(udev);
 	ar->udev = udev;
 	ar->intf = intf;
 	ar->features = id->driver_info;
@@ -1096,15 +1093,14 @@ static int carl9170_usb_probe(struct usb
 	atomic_set(&ar->rx_anch_urbs, 0);
 	atomic_set(&ar->rx_pool_urbs, 0);
 
-	usb_get_dev(ar->udev);
+	usb_get_intf(intf);
 
 	carl9170_set_state(ar, CARL9170_STOPPED);
 
 	err = request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
 		&ar->udev->dev, GFP_KERNEL, ar, carl9170_usb_firmware_step2);
 	if (err) {
-		usb_put_dev(udev);
-		usb_put_dev(udev);
+		usb_put_intf(intf);
 		carl9170_free(ar);
 	}
 	return err;
@@ -1133,7 +1129,6 @@ static void carl9170_usb_disconnect(stru
 
 	carl9170_release_firmware(ar);
 	carl9170_free(ar);
-	usb_put_dev(udev);
 }
 
 #ifdef CONFIG_PM


