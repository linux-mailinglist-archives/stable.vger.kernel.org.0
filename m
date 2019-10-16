Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24529DA11F
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbfJPWTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389156AbfJPVyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:03 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9BB21D7A;
        Wed, 16 Oct 2019 21:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262842;
        bh=5Q+tZoi1kYHkwdrZt+g11s4XOtQloH3zBD5qFpga5nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSmsbedW1WL3aYx75ZlUWEtnf1P4WiyvmNoYcG8+CirorBjX+VYD7b5EVTgCILD7f
         /4y3Ka5HEhPM3qDU0ruQs/KAsO5XIhiVrUKmY2329DUw/coGgrthf4RZ6+vcbmBEvo
         2Rn9LiCO2hTfLdFnxx5o3b+FvToDuMton2Z/7ff8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 47/79] USB: ldusb: fix NULL-derefs on driver unbind
Date:   Wed, 16 Oct 2019 14:50:22 -0700
Message-Id: <20191016214809.824933237@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 58ecf131e74620305175a7aa103f81350bb37570 upstream.

The driver was using its struct usb_interface pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg, dev_warn and dev_err statements in
the completion handlers which relies on said pointer.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/ldusb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -158,6 +158,7 @@ MODULE_PARM_DESC(min_interrupt_out_inter
 struct ld_usb {
 	struct mutex		mutex;		/* locks this structure */
 	struct usb_interface*	intf;		/* save off the usb interface pointer */
+	unsigned long		disconnected:1;
 
 	int			open_count;	/* number of times this port has been opened */
 
@@ -197,12 +198,10 @@ static void ld_usb_abort_transfers(struc
 	/* shutdown transfer */
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running = 0;
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
 	if (dev->interrupt_out_busy)
-		if (dev->intf)
-			usb_kill_urb(dev->interrupt_out_urb);
+		usb_kill_urb(dev->interrupt_out_urb);
 }
 
 /**
@@ -210,8 +209,6 @@ static void ld_usb_abort_transfers(struc
  */
 static void ld_usb_delete(struct ld_usb *dev)
 {
-	ld_usb_abort_transfers(dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -267,7 +264,7 @@ static void ld_usb_interrupt_in_callback
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && !dev->buffer_overflow && dev->intf) {
+	if (dev->interrupt_in_running && !dev->buffer_overflow) {
 		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval) {
 			dev_err(&dev->intf->dev,
@@ -396,7 +393,7 @@ static int ld_usb_release(struct inode *
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		mutex_unlock(&dev->mutex);
 		/* unlock here as ld_usb_delete frees dev */
@@ -427,7 +424,7 @@ static unsigned int ld_usb_poll(struct f
 
 	dev = file->private_data;
 
-	if (!dev->intf)
+	if (dev->disconnected)
 		return POLLERR | POLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -466,7 +463,7 @@ static ssize_t ld_usb_read(struct file *
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -546,7 +543,7 @@ static ssize_t ld_usb_write(struct file
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -782,6 +779,9 @@ static void ld_usb_disconnect(struct usb
 	/* give back our minor */
 	usb_deregister_dev(intf, &ld_usb_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->mutex);
 
 	/* if the device is not opened, then we clean up right now */
@@ -789,7 +789,7 @@ static void ld_usb_disconnect(struct usb
 		mutex_unlock(&dev->mutex);
 		ld_usb_delete(dev);
 	} else {
-		dev->intf = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);


