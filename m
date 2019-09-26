Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30C2BEE26
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 11:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfIZJMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 05:12:49 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37924 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbfIZJMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 05:12:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so1362309ljj.5;
        Thu, 26 Sep 2019 02:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKDYWL5jP7ajoKT3dPjrbKASExuHF8+ZZfOI4omjdpc=;
        b=IYsAtosY9TeDfqjWQ3OdSKovIJC7JyzIUJ3egyLLFbb/mIhR6ifF9lz5to6+9r8iuB
         SNNd2/k6VCnrsJa8cVj/pNChRXjA7Eiyd32KtNY0zIH0yLKYSX50Z1o4R3RTPeoyAMgg
         qKbEXNlF1/+A0rNTzvf4vmNGfGPaOvycIt9ebOa1O7ck3E4a84gruQnrb/Tc8jXFb8li
         cPZXyS5ZulEMo5ua25Y7kpIGV/UACvw1eBubk1UKjG688KCPkvLvCM6s7kB3n2hulIJz
         Ko3JPgNH5FjNHpf8c6A8dRKZbrV0JaerEGLHq16uHQ2DKtRWSo71adW2KnVCeVjUxpfR
         Cm4g==
X-Gm-Message-State: APjAAAUjqB0ynAxLoXe6i2DxB77sWGJ3Nhd6k8hLQmdbdjQK5Tw+G0v7
        GJojAE8DjBZprHWHsCm4kNM=
X-Google-Smtp-Source: APXvYqwaayLvoGLaMSOcgGVE5tNXXHFfJmLAnUyqQyYv+e5U1lunaclulcsNRdjRgsCcxuQNR5dbIQ==
X-Received: by 2002:a2e:3902:: with SMTP id g2mr1844414lja.196.1569489167017;
        Thu, 26 Sep 2019 02:12:47 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id u8sm446699lfb.36.2019.09.26.02.12.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 02:12:45 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iDPpS-0006Qs-7F; Thu, 26 Sep 2019 11:12:50 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/4] USB: usblcd: fix I/O after disconnect
Date:   Thu, 26 Sep 2019 11:12:25 +0200
Message-Id: <20190926091228.24634-7-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190926091228.24634-1-johan@kernel.org>
References: <20190926091228.24634-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to stop all I/O on disconnect by adding a disconnected flag
which is used to prevent new I/O from being started and by stopping all
ongoing I/O before returning.

This also fixes a potential use-after-free on driver unbind in case the
driver data is freed before the completion handler has run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>	# 7bbe990c989e
Signed-off-by: Johan Hovold <johan@kernel.org>
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

