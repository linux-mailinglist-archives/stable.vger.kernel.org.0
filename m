Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E863DA13B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfJPWVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437562AbfJPVxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:40 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C36F820872;
        Wed, 16 Oct 2019 21:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262819;
        bh=xjAbMylNRZ7+JF82LM6i3jsmUPM6c7W9EHG2TeB0IO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyO2BvALBQXL5Vjp4X+XgL0Iw44803MnJHrP1Rv4uytCQPQvfP2G/ovKlXNmhD+qD
         swEAtAdBcWCbdxymLWd2N/q/0wGNCX/wJCxViy7C7zaesy2ECY5EVmZvZcIpaDvcCQ
         CuQL55y+41l8k+vNfPzooEfshGLpYYmx4h9q6oWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 61/79] USB: legousbtower: fix potential NULL-deref on disconnect
Date:   Wed, 16 Oct 2019 14:50:36 -0700
Message-Id: <20191016214823.748343288@linuxfoundation.org>
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
Cc: stable <stable@vger.kernel.org>     # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |   26 +++++++++++++++-----------
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


