Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9DCB718
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfJDJMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbfJDJMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5E420867;
        Fri,  4 Oct 2019 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570180339;
        bh=zGWPEDxlxSysrrh+Tvs4jxEnDbYj4A91Gcbrq3fF7tg=;
        h=Subject:To:From:Date:From;
        b=xQtWPcxg6FNUQV8dj0f1ftdi5aW6EpJAhLR29yw3wvT3jc5D2J2zuI/o/c5J+4sfD
         qT/M/RAgl2OvFMp30COutL/sMuUrhh9foOlLqvKUo8h3IGin/s3ASMXaw4cLH+rEHi
         Hbvf/9R3b4ivHpRBLWb28Mjr8i+S0UGA18mOc5nU=
Subject: patch "USB: usblcd: fix I/O after disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:12:17 +0200
Message-ID: <15701803373232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usblcd: fix I/O after disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From eb7f5a490c5edfe8126f64bc58b9ba2edef0a425 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 26 Sep 2019 11:12:25 +0200
Subject: USB: usblcd: fix I/O after disconnect

Make sure to stop all I/O on disconnect by adding a disconnected flag
which is used to prevent new I/O from being started and by stopping all
ongoing I/O before returning.

This also fixes a potential use-after-free on driver unbind in case the
driver data is freed before the completion handler has run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>	# 7bbe990c989e
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190926091228.24634-7-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usblcd.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 9ba4a4e68d91..aa982d3ca36b 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
@@ -57,6 +58,8 @@ struct usb_lcd {
 							   using up all RAM */
 	struct usb_anchor	submitted;		/* URBs to wait for
 							   before suspend */
+	struct rw_semaphore	io_rwsem;
+	unsigned long		disconnected:1;
 };
 #define to_lcd_dev(d) container_of(d, struct usb_lcd, kref)
 
@@ -142,6 +145,13 @@ static ssize_t lcd_read(struct file *file, char __user * buffer,
 
 	dev = file->private_data;
 
+	down_read(&dev->io_rwsem);
+
+	if (dev->disconnected) {
+		retval = -ENODEV;
+		goto out_up_io;
+	}
+
 	/* do a blocking bulk read to get data from the device */
 	retval = usb_bulk_msg(dev->udev,
 			      usb_rcvbulkpipe(dev->udev,
@@ -158,6 +168,9 @@ static ssize_t lcd_read(struct file *file, char __user * buffer,
 			retval = bytes_read;
 	}
 
+out_up_io:
+	up_read(&dev->io_rwsem);
+
 	return retval;
 }
 
@@ -237,11 +250,18 @@ static ssize_t lcd_write(struct file *file, const char __user * user_buffer,
 	if (r < 0)
 		return -EINTR;
 
+	down_read(&dev->io_rwsem);
+
+	if (dev->disconnected) {
+		retval = -ENODEV;
+		goto err_up_io;
+	}
+
 	/* create a urb, and a buffer for it, and copy the data to the urb */
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!urb) {
 		retval = -ENOMEM;
-		goto err_no_buf;
+		goto err_up_io;
 	}
 
 	buf = usb_alloc_coherent(dev->udev, count, GFP_KERNEL,
@@ -278,6 +298,7 @@ static ssize_t lcd_write(struct file *file, const char __user * user_buffer,
 	   the USB core will eventually free it entirely */
 	usb_free_urb(urb);
 
+	up_read(&dev->io_rwsem);
 exit:
 	return count;
 error_unanchor:
@@ -285,7 +306,8 @@ static ssize_t lcd_write(struct file *file, const char __user * user_buffer,
 error:
 	usb_free_coherent(dev->udev, count, buf, urb->transfer_dma);
 	usb_free_urb(urb);
-err_no_buf:
+err_up_io:
+	up_read(&dev->io_rwsem);
 	up(&dev->limit_sem);
 	return retval;
 }
@@ -325,6 +347,7 @@ static int lcd_probe(struct usb_interface *interface,
 
 	kref_init(&dev->kref);
 	sema_init(&dev->limit_sem, USB_LCD_CONCURRENT_WRITES);
+	init_rwsem(&dev->io_rwsem);
 	init_usb_anchor(&dev->submitted);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
@@ -422,6 +445,12 @@ static void lcd_disconnect(struct usb_interface *interface)
 	/* give back our minor */
 	usb_deregister_dev(interface, &lcd_class);
 
+	down_write(&dev->io_rwsem);
+	dev->disconnected = 1;
+	up_write(&dev->io_rwsem);
+
+	usb_kill_anchored_urbs(&dev->submitted);
+
 	/* decrement our usage count */
 	kref_put(&dev->kref, lcd_delete);
 
-- 
2.23.0


