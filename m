Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA4CD9F81
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395270AbfJPVzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390372AbfJPVzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:35 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9516C21D80;
        Wed, 16 Oct 2019 21:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262934;
        bh=M6SR5GjYxGUI+9nzIIp3JhPfCJi1hqJh+mra8AS75kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tii2GyRwd3z2uLltI0hB8YYCxt/l+xMGPwHxNcajQngEVScQZT6a45rg6f+28ni4y
         JGS8w6E7BCrc7AuVM8R+1cAzJesN02zYIw6bZho1OTyVh0qfQfYVnX+ckXtEXfrkfS
         IIfuGeoHVq2pIZLsc51sEA92Gny9NMDLSXcKaWmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 56/92] USB: ldusb: fix NULL-derefs on driver unbind
Date:   Wed, 16 Oct 2019 14:50:29 -0700
Message-Id: <20191016214838.885312409@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
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
@@ -768,6 +765,9 @@ static void ld_usb_disconnect(struct usb
 	/* give back our minor */
 	usb_deregister_dev(intf, &ld_usb_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->mutex);
 
 	/* if the device is not opened, then we clean up right now */
@@ -775,7 +775,7 @@ static void ld_usb_disconnect(struct usb
 		mutex_unlock(&dev->mutex);
 		ld_usb_delete(dev);
 	} else {
-		dev->intf = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);


