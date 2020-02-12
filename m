Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A3415AF27
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgBLRyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 12:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgBLRyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 12:54:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650ED21569;
        Wed, 12 Feb 2020 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581530093;
        bh=WkJhzxIV5lbtO/qGh+/OBS6fLW7yOpH0U3+Cleth/9o=;
        h=Subject:To:From:Date:From;
        b=DtBRl93gbMJkPZm2RJL2/J5quOLSl9pGP7agX6pGuEguU6SutTzZP685v1ogoA0Dk
         Sz2YMjc2S3xK2g7R54CoCE2DBx6XWaipxayc1kwiqrsfiWX+EFFOgZhNa7/MLrmTqc
         wLmOOzfBKlS7ZZGf3nja3+Sj7hFhREQcaVGabuMI=
Subject: patch "USB: misc: iowarrior: add support for the 28 and 28L devices" added to usb-linus
To:     gregkh@linuxfoundation.org, jung@codemercs.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 09:54:44 -0800
Message-ID: <1581530084112137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: misc: iowarrior: add support for the 28 and 28L devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5f6f8da2d7b5a431d3f391d0d73ace8edfb42af7 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 11 Feb 2020 20:04:22 -0800
Subject: USB: misc: iowarrior: add support for the 28 and 28L devices

Add new device ids for the 28 and 28L devices.  These have 4 interfaces
instead of 2, but the driver binds the same, so the driver changes are
minimal.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212040422.2991-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 990acbe14852..d20b60acfe8a 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -33,6 +33,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOWPV2	0x1512
 /* full speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW56	0x1503
+/* fuller speed iowarrior */
+#define USB_DEVICE_ID_CODEMERCS_IOW28	0x1504
+#define USB_DEVICE_ID_CODEMERCS_IOW28L	0x1505
 
 /* OEMed devices */
 #define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
@@ -139,6 +142,8 @@ static const struct usb_device_id iowarrior_ids[] = {
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24SAG)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28L)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -379,6 +384,8 @@ static ssize_t iowarrior_write(struct file *file,
 		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
 	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
+	case USB_DEVICE_ID_CODEMERCS_IOW28:
+	case USB_DEVICE_ID_CODEMERCS_IOW28L:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -777,7 +784,9 @@ static int iowarrior_probe(struct usb_interface *interface,
 	}
 
 	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)) {
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -791,7 +800,9 @@ static int iowarrior_probe(struct usb_interface *interface,
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
 	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
-	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)))
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 
-- 
2.25.0


