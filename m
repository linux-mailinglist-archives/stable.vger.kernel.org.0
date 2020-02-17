Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67495160F0D
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbgBQJpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 04:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgBQJpE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 04:45:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EB4C206F4;
        Mon, 17 Feb 2020 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581932703;
        bh=opxYnsQaJxCkk0dECb7SaJdc34doq8pMzec1HPOYVzw=;
        h=Subject:To:From:Date:From;
        b=vIiOtEquLwlP0N33dXXeGVi3aZPx0xkyWBorNq/BxyyotRKvlageYts0oJ3C+ZlQY
         2hUpZhtzCU8X3j0zCv7NIlfxQWykfNGzIvLLbn6ER8FjZIgSDDlc/KOwAhDz878Mha
         +j6Dc6B+IGfwmnaB8dRhhlmcMjxJNAQW4bnYENcw=
Subject: patch "USB: misc: iowarrior: add support for the 100 device" added to usb-linus
To:     gregkh@linuxfoundation.org, jung@codemercs.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 10:45:01 +0100
Message-ID: <1581932701897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: misc: iowarrior: add support for the 100 device

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bab5417f5f0118ce914bc5b2f8381e959e891155 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 14 Feb 2020 08:11:48 -0800
Subject: USB: misc: iowarrior: add support for the 100 device

Add a new device id for the 100 devie.  It has 4 interfaces like the 28
and 28L devices but a larger endpoint so more I/O pins.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200214161148.GA3963518@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index d20b60acfe8a..dce20301e367 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -36,6 +36,7 @@
 /* fuller speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW28	0x1504
 #define USB_DEVICE_ID_CODEMERCS_IOW28L	0x1505
+#define USB_DEVICE_ID_CODEMERCS_IOW100	0x1506
 
 /* OEMed devices */
 #define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
@@ -144,6 +145,7 @@ static const struct usb_device_id iowarrior_ids[] = {
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28L)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW100)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -386,6 +388,7 @@ static ssize_t iowarrior_write(struct file *file,
 	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 	case USB_DEVICE_ID_CODEMERCS_IOW28:
 	case USB_DEVICE_ID_CODEMERCS_IOW28L:
+	case USB_DEVICE_ID_CODEMERCS_IOW100:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -786,7 +789,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
 	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
 	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)) {
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW100)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -802,7 +806,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
 	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
 	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
-	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)))
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW100)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 
-- 
2.25.0


