Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835BBDA147
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfJPWVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437522AbfJPVxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:32 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BB020872;
        Wed, 16 Oct 2019 21:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262812;
        bh=N3B1XunYOvxQ2/mobggQFW4xm0jh4n0dT7C9YTzBZa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wi8sHo11jwIvTZkdQDsXJ+EJvcISwAS06unX1pZPdAtiGRaPC5dBCzcNUuJ54I0If
         W9QFmaau3KpeQe35c7HUYM89Jml1XTTdQHsk1L/p0MaN5uIKXW0Rlr0vkpfG2vvQKr
         fUF0Kga7mW200MdZs/xPEU+0lmPHVJq3LUswQgQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 54/79] USB: usblcd: fix I/O after disconnect
Date:   Wed, 16 Oct 2019 14:50:29 -0700
Message-Id: <20191016214817.928301234@linuxfoundation.org>
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

commit eb7f5a490c5edfe8126f64bc58b9ba2edef0a425 upstream.

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
 drivers/usb/misc/usblcd.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
@@ -56,6 +57,8 @@ struct usb_lcd {
 							   using up all RAM */
 	struct usb_anchor	submitted;		/* URBs to wait for
 							   before suspend */
+	struct rw_semaphore	io_rwsem;
+	unsigned long		disconnected:1;
 };
 #define to_lcd_dev(d) container_of(d, struct usb_lcd, kref)
 
@@ -141,6 +144,13 @@ static ssize_t lcd_read(struct file *fil
 
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
@@ -157,6 +167,9 @@ static ssize_t lcd_read(struct file *fil
 			retval = bytes_read;
 	}
 
+out_up_io:
+	up_read(&dev->io_rwsem);
+
 	return retval;
 }
 
@@ -236,11 +249,18 @@ static ssize_t lcd_write(struct file *fi
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
@@ -277,6 +297,7 @@ static ssize_t lcd_write(struct file *fi
 	   the USB core will eventually free it entirely */
 	usb_free_urb(urb);
 
+	up_read(&dev->io_rwsem);
 exit:
 	return count;
 error_unanchor:
@@ -284,7 +305,8 @@ error_unanchor:
 error:
 	usb_free_coherent(dev->udev, count, buf, urb->transfer_dma);
 	usb_free_urb(urb);
-err_no_buf:
+err_up_io:
+	up_read(&dev->io_rwsem);
 	up(&dev->limit_sem);
 	return retval;
 }
@@ -327,6 +349,7 @@ static int lcd_probe(struct usb_interfac
 	}
 	kref_init(&dev->kref);
 	sema_init(&dev->limit_sem, USB_LCD_CONCURRENT_WRITES);
+	init_rwsem(&dev->io_rwsem);
 	init_usb_anchor(&dev->submitted);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
@@ -437,6 +460,12 @@ static void lcd_disconnect(struct usb_in
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
 


