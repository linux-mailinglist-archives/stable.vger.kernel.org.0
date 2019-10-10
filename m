Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493BFD296D
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 14:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbfJJMYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 08:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbfJJMYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 08:24:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745DC208C3;
        Thu, 10 Oct 2019 12:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570710283;
        bh=cj3GjTq7OEbtnIqmZtDAUa/CzBGZK0MlRwMR1/Uhghk=;
        h=Subject:To:From:Date:From;
        b=UH7+8hcF+RzVTsD0UpaPttfW/HhbEp7KNOfnd3avkEfVf03aPEiOtGKwcz/5/x6JI
         Z044cPKey2fzkh12HCFi6gLV94iqp3LVoCKF3qDvzfiUqohESk2pBStmB/lEa+sIRl
         1henXDzd9nrdXXuyno957v+0NzA6/jOQhzvvBTmo=
Subject: patch "USB: yurex: fix NULL-derefs on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 14:24:40 +0200
Message-ID: <1570710280122121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: yurex: fix NULL-derefs on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From aafb00a977cf7d81821f7c9d12e04c558c22dc3c Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Oct 2019 17:38:48 +0200
Subject: USB: yurex: fix NULL-derefs on disconnect

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
 drivers/usb/misc/yurex.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 8d52d4336c29..be0505b8b5d4 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -60,6 +60,7 @@ struct usb_yurex {
 
 	struct kref		kref;
 	struct mutex		io_mutex;
+	unsigned long		disconnected:1;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	waitq;
 
@@ -107,6 +108,7 @@ static void yurex_delete(struct kref *kref)
 				dev->int_buffer, dev->urb->transfer_dma);
 		usb_free_urb(dev->urb);
 	}
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev);
 }
@@ -205,7 +207,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
 	init_waitqueue_head(&dev->waitq);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	iface_desc = interface->cur_altsetting;
@@ -316,8 +318,9 @@ static void yurex_disconnect(struct usb_interface *interface)
 
 	/* prevent more I/O from starting */
 	usb_poison_urb(dev->urb);
+	usb_poison_urb(dev->cntl_urb);
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	/* wakeup waiters */
@@ -405,7 +408,7 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	dev = file->private_data;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		return -ENODEV;
 	}
@@ -440,7 +443,7 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 		goto error;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
-- 
2.23.0


