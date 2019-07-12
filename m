Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A166DB9
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfGLMc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfGLMc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC85E21019;
        Fri, 12 Jul 2019 12:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934776;
        bh=gKxjcJ/kV8JN4O/HJXR/CIy10hJdll8KTiBfIX4a+Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5CagKHY3XGxcsvdEcxRN8i/WJr9nmji5bBNhRtedwoeNrbhcIOSHU9Pafo7D7N6s
         Rc0/qir8RKlK/3P5OCCg9wGUuWoHFPm29XtfGl/x3c4+ljcCYdlmojbk5H5QrB9wI6
         u8XdPLG867SFoQ3UwVHyl53wzgVULwCEjgWNtsuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
Subject: [PATCH 5.2 27/61] p54usb: Fix race between disconnect and firmware loading
Date:   Fri, 12 Jul 2019 14:19:40 +0200
Message-Id: <20190712121622.086164187@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 6e41e2257f1094acc37618bf6c856115374c6922 upstream.

The syzbot fuzzer found a bug in the p54 USB wireless driver.  The
issue involves a race between disconnect and the firmware-loader
callback routine, and it has several aspects.

One big problem is that when the firmware can't be loaded, the
callback routine tries to unbind the driver from the USB _device_ (by
calling device_release_driver) instead of from the USB _interface_ to
which it is actually bound (by calling usb_driver_release_interface).

The race involves access to the private data structure.  The driver's
disconnect handler waits for a completion that is signalled by the
firmware-loader callback routine.  As soon as the completion is
signalled, you have to assume that the private data structure may have
been deallocated by the disconnect handler -- even if the firmware was
loaded without errors.  However, the callback routine does access the
private data several times after that point.

Another problem is that, in order to ensure that the USB device
structure hasn't been freed when the callback routine runs, the driver
takes a reference to it.  This isn't good enough any more, because now
that the callback routine calls usb_driver_release_interface, it has
to ensure that the interface structure hasn't been freed.

Finally, the driver takes an unnecessary reference to the USB device
structure in the probe function and drops the reference in the
disconnect handler.  This extra reference doesn't accomplish anything,
because the USB core already guarantees that a device structure won't
be deallocated while a driver is still bound to any of its interfaces.

To fix these problems, this patch makes the following changes:

	Call usb_driver_release_interface() rather than
	device_release_driver().

	Don't signal the completion until after the important
	information has been copied out of the private data structure,
	and don't refer to the private data at all thereafter.

	Lock udev (the interface's parent) before unbinding the driver
	instead of locking udev->parent.

	During the firmware loading process, take a reference to the
	USB interface instead of the USB device.

	Don't take an unnecessary reference to the device during probe
	(and then don't drop it during disconnect).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/p54/p54usb.c |   43 ++++++++++++-----------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/intersil/p54/p54usb.c
+++ b/drivers/net/wireless/intersil/p54/p54usb.c
@@ -30,6 +30,8 @@ MODULE_ALIAS("prism54usb");
 MODULE_FIRMWARE("isl3886usb");
 MODULE_FIRMWARE("isl3887usb");
 
+static struct usb_driver p54u_driver;
+
 /*
  * Note:
  *
@@ -918,9 +920,9 @@ static void p54u_load_firmware_cb(const
 {
 	struct p54u_priv *priv = context;
 	struct usb_device *udev = priv->udev;
+	struct usb_interface *intf = priv->intf;
 	int err;
 
-	complete(&priv->fw_wait_load);
 	if (firmware) {
 		priv->fw = firmware;
 		err = p54u_start_ops(priv);
@@ -929,26 +931,22 @@ static void p54u_load_firmware_cb(const
 		dev_err(&udev->dev, "Firmware not found.\n");
 	}
 
-	if (err) {
-		struct device *parent = priv->udev->dev.parent;
-
-		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
-
-		if (parent)
-			device_lock(parent);
+	complete(&priv->fw_wait_load);
+	/*
+	 * At this point p54u_disconnect may have already freed
+	 * the "priv" context. Do not use it anymore!
+	 */
+	priv = NULL;
 
-		device_release_driver(&udev->dev);
-		/*
-		 * At this point p54u_disconnect has already freed
-		 * the "priv" context. Do not use it anymore!
-		 */
-		priv = NULL;
+	if (err) {
+		dev_err(&intf->dev, "failed to initialize device (%d)\n", err);
 
-		if (parent)
-			device_unlock(parent);
+		usb_lock_device(udev);
+		usb_driver_release_interface(&p54u_driver, intf);
+		usb_unlock_device(udev);
 	}
 
-	usb_put_dev(udev);
+	usb_put_intf(intf);
 }
 
 static int p54u_load_firmware(struct ieee80211_hw *dev,
@@ -969,14 +967,14 @@ static int p54u_load_firmware(struct iee
 	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
 	       p54u_fwlist[i].fw);
 
-	usb_get_dev(udev);
+	usb_get_intf(intf);
 	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
 				      device, GFP_KERNEL, priv,
 				      p54u_load_firmware_cb);
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
 					  "(%d)!\n", p54u_fwlist[i].fw, err);
-		usb_put_dev(udev);
+		usb_put_intf(intf);
 	}
 
 	return err;
@@ -1008,8 +1006,6 @@ static int p54u_probe(struct usb_interfa
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
 
-	usb_get_dev(udev);
-
 	/* really lazy and simple way of figuring out if we're a 3887 */
 	/* TODO: should just stick the identification in the device table */
 	i = intf->altsetting->desc.bNumEndpoints;
@@ -1050,10 +1046,8 @@ static int p54u_probe(struct usb_interfa
 		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
 	err = p54u_load_firmware(dev, intf);
-	if (err) {
-		usb_put_dev(udev);
+	if (err)
 		p54_free_common(dev);
-	}
 	return err;
 }
 
@@ -1069,7 +1063,6 @@ static void p54u_disconnect(struct usb_i
 	wait_for_completion(&priv->fw_wait_load);
 	p54_unregister_common(dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
 }


