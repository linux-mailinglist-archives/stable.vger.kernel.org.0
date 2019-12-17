Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50A9122111
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLQBAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:00:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34664 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfLQAve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:34 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0003KF-PD; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005TN-4V; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:00 +0000
Message-ID: <lsq.1576543535.882286131@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/136] USB: legousbtower: fix potential NULL-deref
 on disconnect
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

commit cd81e6fa8e033e7bcd59415b4a65672b4780030b upstream.

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
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/legousbtower.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -196,6 +196,7 @@ struct lego_usb_tower {
 	unsigned char		minor;		/* the starting minor number for this device */
 
 	int			open_count;	/* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char*			read_buffer;
 	size_t			read_buffer_length; /* this much came in */
@@ -295,8 +296,6 @@ static inline void lego_usb_tower_debug_
  */
 static inline void tower_delete (struct lego_usb_tower *dev)
 {
-	tower_abort_transfers (dev);
-
 	/* free data structures */
 	usb_free_urb(dev->interrupt_in_urb);
 	usb_free_urb(dev->interrupt_out_urb);
@@ -436,7 +435,8 @@ static int tower_release (struct inode *
 		retval = -ENODEV;
 		goto unlock_exit;
 	}
-	if (dev->udev == NULL) {
+
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 
 		/* unlock here as tower_delete frees dev */
@@ -472,10 +472,9 @@ static void tower_abort_transfers (struc
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
 
@@ -511,7 +510,7 @@ static unsigned int tower_poll (struct f
 
 	dev = file->private_data;
 
-	if (!dev->udev)
+	if (dev->disconnected)
 		return POLLERR | POLLHUP;
 
 	poll_wait(file, &dev->read_wait, wait);
@@ -558,7 +557,7 @@ static ssize_t tower_read (struct file *
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -644,7 +643,7 @@ static ssize_t tower_write (struct file
 	}
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto unlock_exit;
@@ -753,7 +752,7 @@ static void tower_interrupt_in_callback
 
 resubmit:
 	/* resubmit if we're still running */
-	if (dev->interrupt_in_running && dev->udev) {
+	if (dev->interrupt_in_running) {
 		retval = usb_submit_urb (dev->interrupt_in_urb, GFP_ATOMIC);
 		if (retval)
 			dev_err(&dev->udev->dev,
@@ -823,6 +822,7 @@ static int tower_probe (struct usb_inter
 
 	dev->udev = udev;
 	dev->open_count = 0;
+	dev->disconnected = 0;
 
 	dev->read_buffer = NULL;
 	dev->read_buffer_length = 0;
@@ -970,6 +970,10 @@ static void tower_disconnect (struct usb
 	/* give back our minor and prevent further open() */
 	usb_deregister_dev (interface, &tower_class);
 
+	/* stop I/O */
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&dev->lock);
 
 	/* if the device is not opened, then we clean up right now */
@@ -977,7 +981,7 @@ static void tower_disconnect (struct usb
 		mutex_unlock(&dev->lock);
 		tower_delete (dev);
 	} else {
-		dev->udev = NULL;
+		dev->disconnected = 1;
 		/* wake up pollers */
 		wake_up_interruptible_all(&dev->read_wait);
 		wake_up_interruptible_all(&dev->write_wait);

