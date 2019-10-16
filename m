Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821E9D9F2F
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394807AbfJPVxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437375AbfJPVxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:12 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2EA21D7A;
        Wed, 16 Oct 2019 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262791;
        bh=POLCXjKVPmnPb4Te2lDMEypqewX48I3YWuiNw2otHjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lit7q/q9L+9LNh6bryHDFbdA+6/TN/e++kgR4hogfii9aAS5XxOYcGI8ENbrnOdvR
         pTkkXlWHl3NmJisnLQOl0P38z5+HpymCtfNMH+Z54qd5JbGbxYTZFw7NlUhv23zSRS
         r/7J6i+ivERCMe/FL17AJIfClTaiNwlKvOiY29fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 31/79] USB: yurex: fix NULL-derefs on disconnect
Date:   Wed, 16 Oct 2019 14:50:06 -0700
Message-Id: <20191016214756.986666753@linuxfoundation.org>
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

commit aafb00a977cf7d81821f7c9d12e04c558c22dc3c upstream.

The driver was using its struct usb_interface pointer as an inverted
disconnected flag, but was setting it to NULL without making sure all
code paths that used it were done with it.

Before commit ef61eb43ada6 ("USB: yurex: Fix protection fault after
device removal") this included the interrupt-in completion handler, but
there are further accesses in dev_err and dev_dbg statements in
yurex_write() and the driver-data destructor (sic!).

Fix this by unconditionally stopping also the control URB at disconnect
and by using a dedicated disconnected flag.

Note that we need to take a reference to the struct usb_interface to
avoid a use-after-free in the destructor whenever the device was
disconnected while the character device was still open.

Fixes: aadd6472d904 ("USB: yurex.c: remove dbg() usage")
Fixes: 45714104b9e8 ("USB: yurex.c: remove err() usage")
Cc: stable <stable@vger.kernel.org>     # 3.5: ef61eb43ada6
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -64,6 +64,7 @@ struct usb_yurex {
 
 	struct kref		kref;
 	struct mutex		io_mutex;
+	unsigned long		disconnected:1;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	waitq;
 
@@ -111,6 +112,7 @@ static void yurex_delete(struct kref *kr
 				dev->int_buffer, dev->urb->transfer_dma);
 		usb_free_urb(dev->urb);
 	}
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev);
 }
@@ -211,7 +213,7 @@ static int yurex_probe(struct usb_interf
 	init_waitqueue_head(&dev->waitq);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	iface_desc = interface->cur_altsetting;
@@ -334,8 +336,9 @@ static void yurex_disconnect(struct usb_
 
 	/* prevent more I/O from starting */
 	usb_poison_urb(dev->urb);
+	usb_poison_urb(dev->cntl_urb);
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	/* wakeup waiters */
@@ -423,7 +426,7 @@ static ssize_t yurex_read(struct file *f
 	dev = file->private_data;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		return -ENODEV;
 	}
@@ -458,7 +461,7 @@ static ssize_t yurex_write(struct file *
 		goto error;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;


