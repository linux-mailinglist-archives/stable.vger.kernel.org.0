Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2C1BEE21
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 11:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfIZJMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 05:12:48 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42876 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfIZJMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 05:12:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id c195so1110637lfg.9;
        Thu, 26 Sep 2019 02:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKDYWL5jP7ajoKT3dPjrbKASExuHF8+ZZfOI4omjdpc=;
        b=XPJR8h+FUoQQyVurHol5k/Y7gcXdi2mnwR4bdDWIHPvOChOULPSOM7zBDFnE8sVjY5
         EFjX3axYcLd5W4eCWS5t2FfBW3RTHlhj34Hw2u9360SovmAcPMcr/TFBZY7n4mUJloy5
         mH82PCqNBK7Gaae5miGac+aiuZWz55Adx9E4j4Yfkt0NffGgXM2x/mELJkjUp0YxkfWO
         urveh8sFCCiFr/EQiPn/7NyQ9attjLdMSL+NIlbepJRdt9p0wCzWnWP+blpOjn6LMACg
         Bl6qsgRfbQOxA4dc/LXkfVodHjCfC85ryWNNALdv/AjhTYWpy0YvCYtMl03yhNB/Yva7
         MfkA==
X-Gm-Message-State: APjAAAWJWULRABLTjNaDU0kDd5SMByB4Gi6T+Mg5w+wCKK7DfF/gIgBR
        FZPwwcZ0BZ5FeoDQx/5YAZAjxmz3
X-Google-Smtp-Source: APXvYqxLBm2G3bPS02nHgMMOQ+MjjSjzib9tQmAzzXHvuE7ivw25+HwU7ohsS3npSu1FDBtQ4NdXaA==
X-Received: by 2002:ac2:48af:: with SMTP id u15mr1550965lfg.75.1569489164262;
        Thu, 26 Sep 2019 02:12:44 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id k13sm369346ljc.96.2019.09.26.02.12.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 02:12:43 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iDPpR-0006QS-PB; Thu, 26 Sep 2019 11:12:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/4] USB: usblcd: fix I/O after disconnect
Date:   Thu, 26 Sep 2019 11:12:20 +0200
Message-Id: <20190926091228.24634-2-johan@kernel.org>
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

