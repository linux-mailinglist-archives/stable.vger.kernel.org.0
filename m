Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F20CB9BB
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfJDMCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDMCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:02:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F37A120862;
        Fri,  4 Oct 2019 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570190565;
        bh=mQW0ddnR5i5fkrXPL26eqBv9z0PPDcE/uAmoMYDwrtg=;
        h=Subject:To:From:Date:From;
        b=So1fLnWq6nHj0+7BeRUCRl9NzT1Fis2qYL0lGbdWMrgLr6J89gv0p59cF5HTmRdow
         cpWCTHdLVFSV9mAITR2nUB3Bjj/2JQ8i6NHqQtCnUyrjCBmQRcY0kHI1FgKRXnbid7
         RqUiaBDzJLXZSb94TTo9qTt7mkV1yOsEeaVd4CvU=
Subject: patch "USB: legousbtower: fix potential NULL-deref on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:02:35 +0200
Message-ID: <157019055572109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: legousbtower: fix potential NULL-deref on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cd81e6fa8e033e7bcd59415b4a65672b4780030b Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 19 Sep 2019 10:30:38 +0200
Subject: USB: legousbtower: fix potential NULL-deref on disconnect

The driver is using its struct usb_device pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg and dev_err statements in the
completion handlers which relies on said pointer.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 9d974b2a06e3 ("USB: legousbtower.c: remove err() usage")
Fixes: fef526cae700 ("USB: legousbtower: remove custom debug macro")
Fixes: 4dae99638097 ("USB: legotower: remove custom debug macro and module parameter")
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/legousbtower.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 773e4188f336..4fa999882635 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -190,6 +190,7 @@ struct lego_usb_tower {
 	unsigned char		minor;		/* the starting minor number for this device */
 
 	int			open_count;	/* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char*			read_buffer;
 	size_t			read_buffer_length; /* this much came in */
@@ -289,8 +290,6 @@ static inline void lego_usb_tower_debug_data(struct device *dev,
  */
 static inline void tower_delete (struct lego_usb_tower *dev)
 {
-	tower_abort_transfers (dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -430,7 +429,8 @@ static int tower_release (struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->udev == NULL) {
+
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 
 		/* unlock here as tower_delete frees dev */
@@ -466,10 +466,9 @@ static void tower_abort_transfers (struct lego_usb_tower *dev)
 	if (dev->interrupt_in_running) {
 		dev->interrupt_in_running = 0;
 		mb();
-		if (dev->udev)
-			usb_kill_urb (dev->interrupt_in_urb);
+		usb_kill_urb(dev->interrupt_in_urb);
 	}
-	if (dev->interrupt_out_busy && dev->udev)
+	if (dev->interrupt_out_busy)
 		usb_kill_urb(dev->interrupt_out_urb);
 }
 
@@ -505,7 +504,7 @@ static __poll_t tower_poll (struct file *file, poll_table *wait)
 
 	dev = file->private_data;
 
-	if (!dev->udev)
+	if (dev->disconnected)
 		return EPOLLERR | EPOLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -552,7 +551,7 @@ static ssize_t tower_read (struct file *file, char __user *buffer, size_t count,
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -638,7 +637,7 @@ static ssize_t tower_write (struct file *file, const char __user *buffer, size_t
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -748,7 +747,7 @@ static void tower_interrupt_in_callback (struct urb *urb)
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && dev->udev) {
+	if (dev->interrupt_in_running) {
 		retval = usb_submit_urb (dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval)
 			dev_err(&dev->udev->dev,
@@ -813,6 +812,7 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 
 	dev->udev = udev;
 	dev->open_count = 0;
+	dev->disconnected = 0;
 
 	dev->read_buffer = NULL;
 	dev->read_buffer_length = 0;
@@ -938,6 +938,10 @@ static void tower_disconnect (struct usb_interface *interface)
 	/* give back our minor and prevent further open() */
 	usb_deregister_dev (interface, &tower_class);
 
+	/* stop I/O */
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->lock);
 
 	/* if the device is not opened, then we clean up right now */
@@ -945,7 +949,7 @@ static void tower_disconnect (struct usb_interface *interface)
 		mutex_unlock(&dev->lock);
 		tower_delete (dev);
 	} else {
-		dev->udev = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);
-- 
2.23.0


