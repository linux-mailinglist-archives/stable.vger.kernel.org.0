Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2F01220E2
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLQA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34776 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726742AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003Ku-QR; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005W0-GT; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:32 +0000
Message-ID: <lsq.1576543535.458010526@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 058/136] USB: yurex: fix NULL-derefs on disconnect
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
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009153848.8664-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/yurex.c | 11 +++++++----
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
@@ -422,7 +425,7 @@ static ssize_t yurex_read(struct file *f
 	dev = (struct usb_yurex *)file->private_data;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		return -ENODEV;
 	}
@@ -453,7 +456,7 @@ static ssize_t yurex_write(struct file *
 		goto error;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;

