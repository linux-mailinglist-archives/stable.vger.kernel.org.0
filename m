Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA3E5307
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfJYSG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46818 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731455AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0008Os-PO; Fri, 25 Oct 2019 19:05:36 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001jZ-Tk; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Christian Lamparter" <chunkeey@gmail.com>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Fri, 25 Oct 2019 19:03:27 +0100
Message-ID: <lsq.1572026582.802343109@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 26/47] carl9170: fix misuse of device driver API
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/carl9170/usb.c | 39 +++++++++++--------------
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
@@ -967,32 +969,28 @@ err_out:
 
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
@@ -1010,7 +1008,7 @@ static void carl9170_usb_firmware_finish
 		goto err_unrx;
 
 	complete(&ar->fw_load_wait);
-	usb_put_dev(ar->udev);
+	usb_put_intf(intf);
 	return;
 
 err_unrx:
@@ -1053,7 +1051,6 @@ static int carl9170_usb_probe(struct usb
 		return PTR_ERR(ar);
 
 	udev = interface_to_usbdev(intf);
-	usb_get_dev(udev);
 	ar->udev = udev;
 	ar->intf = intf;
 	ar->features = id->driver_info;
@@ -1095,15 +1092,14 @@ static int carl9170_usb_probe(struct usb
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
@@ -1132,7 +1128,6 @@ static void carl9170_usb_disconnect(stru
 
 	carl9170_release_firmware(ar);
 	carl9170_free(ar);
-	usb_put_dev(udev);
 }
 
 #ifdef CONFIG_PM

