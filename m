Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1636DD9FA7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395447AbfJPV5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395441AbfJPV5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:04 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1705320872;
        Wed, 16 Oct 2019 21:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263022;
        bh=yk9sT55xKYSbTU7SwJdDXKQs5jxFZqeLsk4v9Gu/aQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzNpN+s/2N9vCJyGKM/9C4zN1CYF7vhdqa54EvXg0Tq6qME2noICXPppKVyczHJn6
         VuLVi3dxgTosd/qbBU8VB7L9iQNimILt2P3zvL7H6ZoYB7nuyPKomgZugOgVJFGL0o
         RW4q/30H8RKMC6stnYTGKUjiIOk89hptcZgbTh3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 23/81] USB: ldusb: fix NULL-derefs on driver unbind
Date:   Wed, 16 Oct 2019 14:50:34 -0700
Message-Id: <20191016214826.995001530@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
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
@@ -153,6 +153,7 @@ MODULE_PARM_DESC(min_interrupt_out_inter
 struct ld_usb {
 	struct mutex		mutex;		/* locks this structure */
 	struct usb_interface	*intf;		/* save off the usb interface pointer */
+	unsigned long		disconnected:1;
 
 	int			open_count;	/* number of times this port has been opened */
 
@@ -192,12 +193,10 @@ static void ld_usb_abort_transfers(struc
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
@@ -205,8 +204,6 @@ static void ld_usb_abort_transfers(struc
  */
 static void ld_usb_delete(struct ld_usb *dev)
 {
-	ld_usb_abort_transfers(dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -263,7 +260,7 @@ static void ld_usb_interrupt_in_callback
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && !dev->buffer_overflow && dev->intf) {
+	if (dev->interrupt_in_running && !dev->buffer_overflow) {
 		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval) {
 			dev_err(&dev->intf->dev,
@@ -392,7 +389,7 @@ static int ld_usb_release(struct inode *
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		mutex_unlock(&dev->mutex);
 		/* unlock here as ld_usb_delete frees dev */
@@ -423,7 +420,7 @@ static __poll_t ld_usb_poll(struct file
 
 	dev = file->private_data;
 
-	if (!dev->intf)
+	if (dev->disconnected)
 		return EPOLLERR | EPOLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -462,7 +459,7 @@ static ssize_t ld_usb_read(struct file *
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -542,7 +539,7 @@ static ssize_t ld_usb_write(struct file
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->intf == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		printk(KERN_ERR "ldusb: No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -764,6 +761,9 @@ static void ld_usb_disconnect(struct usb
 	/* give back our minor */
 	usb_deregister_dev(intf, &ld_usb_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->mutex);
 
 	/* if the device is not opened, then we clean up right now */
@@ -771,7 +771,7 @@ static void ld_usb_disconnect(struct usb
 		mutex_unlock(&dev->mutex);
 		ld_usb_delete(dev);
 	} else {
-		dev->intf = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);


