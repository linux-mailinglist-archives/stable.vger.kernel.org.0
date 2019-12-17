Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8EE122119
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfLQBAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:00:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34638 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbfLQAvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:33 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0003K7-H5; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15F-0005T2-VV; Tue, 17 Dec 2019 00:51:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:45:56 +0000
Message-ID: <lsq.1576543535.397191990@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 022/136] USB: usblcd: fix I/O after disconnect
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit eb7f5a490c5edfe8126f64bc58b9ba2edef0a425 upstream.

Make sure to stop all I/O on disconnect by adding a disconnected flag
which is used to prevent new I/O from being started and by stopping all
ongoing I/O before returning.

This also fixes a potential use-after-free on driver unbind in case the
driver data is freed before the completion handler has run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190926091228.24634-7-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/usblcd.c | 33 +++++++++++++++++++++++++++++++--
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
 

