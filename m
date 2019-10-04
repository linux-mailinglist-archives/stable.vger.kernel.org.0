Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD27CB700
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfJDJE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDJE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:04:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C610206C0;
        Fri,  4 Oct 2019 09:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570179865;
        bh=Oa8qu5e5fvhw2X9/YTvbD42dwgiPyzTdrR4OnXMcpC8=;
        h=Subject:To:From:Date:From;
        b=M3DjEFrsW+1LWtD0kedqHtFWMc/p11oIoFUP6uyKJuDXE/g8eK5czSdSp7qkjgH3A
         7CPo517S1T1TCHZ+ufVzxCUme0TqYBaesyKusMUSmZXyV0a6AwpN/681yJ5ar1X+/B
         cm8IWL7syVUsb76Ff82UN2grg/O28dx9nyrMFTbI=
Subject: patch "USB: adutux: fix NULL-derefs on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 11:04:11 +0200
Message-ID: <157017985171112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: adutux: fix NULL-derefs on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b2fa7baee744fde746c17bc1860b9c6f5c2eebb7 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 25 Sep 2019 11:29:13 +0200
Subject: USB: adutux: fix NULL-derefs on disconnect

The driver was using its struct usb_device pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg statements in the completion handlers
which relies on said pointer.

The pointer was also dereferenced unconditionally in a dev_dbg statement
release() something which would lead to a NULL-deref whenever a device
was disconnected before the final character-device close if debugging
was enabled.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 1ef37c6047fe ("USB: adutux: remove custom debug macro and module parameter")
Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190925092913.8608-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/adutux.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index bcc138990e2f..f9efec719359 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -75,6 +75,7 @@ struct adu_device {
 	char			serial_number[8];
 
 	int			open_count; /* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char		*read_buffer_primary;
 	int			read_buffer_length;
@@ -116,7 +117,7 @@ static void adu_abort_transfers(struct adu_device *dev)
 {
 	unsigned long flags;
 
-	if (dev->udev == NULL)
+	if (dev->disconnected)
 		return;
 
 	/* shutdown transfer */
@@ -243,7 +244,7 @@ static int adu_open(struct inode *inode, struct file *file)
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev || !dev->udev) {
+	if (!dev) {
 		retval = -ENODEV;
 		goto exit_no_device;
 	}
@@ -326,7 +327,7 @@ static int adu_release(struct inode *inode, struct file *file)
 	}
 
 	adu_release_internal(dev);
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		if (!dev->open_count)	/* ... and we're the last user */
 			adu_delete(dev);
@@ -354,7 +355,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 		return -ERESTARTSYS;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -518,7 +519,7 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 		goto exit_nolock;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -764,11 +765,14 @@ static void adu_disconnect(struct usb_interface *interface)
 
 	usb_deregister_dev(interface, &adu_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
 	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
+	dev->disconnected = 1;
 	mutex_unlock(&dev->mtx);
 
 	/* if the device is not opened, then we clean up right now */
-- 
2.23.0


