Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7A115AF26
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgBLRyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 12:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgBLRyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 12:54:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C296D2073C;
        Wed, 12 Feb 2020 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581530092;
        bh=mkQa75lhnuLEcqxdg6gLtW3/mhR+xZt+G4aRD3a+Q84=;
        h=Subject:To:From:Date:From;
        b=1vQltiyHFtrGC7VAbkZOjURdOD5kMABdy5ygbERezFdB2NosI+a3CoBS+06hYK2nr
         PlijPgkqnwG5bzIN+AIC924de4YNkl8iWh15pV8WzFtBorY/70O5ye6F+1DmoTRqJI
         J3xzRqEY2LKZABI7p5Zq6364RPHiOe4UkCPtVbJE=
Subject: patch "USB: misc: iowarrior: add support for 2 OEMed devices" added to usb-linus
To:     gregkh@linuxfoundation.org, jung@codemercs.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 09:54:44 -0800
Message-ID: <158153008410913@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: misc: iowarrior: add support for 2 OEMed devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 461d8deb26a7d70254bc0391feb4fd8a95e674e8 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 11 Feb 2020 20:04:21 -0800
Subject: USB: misc: iowarrior: add support for 2 OEMed devices

Add support for two OEM devices that are identical to existing
IO-Warrior devices, except for the USB device id.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212040422.2991-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index dce44fbf031f..990acbe14852 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -34,6 +34,10 @@
 /* full speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW56	0x1503
 
+/* OEMed devices */
+#define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
+#define USB_DEVICE_ID_CODEMERCS_IOW56AM		0x158b
+
 /* Get a minor range for your devices from the usb maintainer */
 #ifdef CONFIG_USB_DYNAMIC_MINORS
 #define IOWARRIOR_MINOR_BASE	0
@@ -133,6 +137,8 @@ static const struct usb_device_id iowarrior_ids[] = {
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV1)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV2)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24SAG)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -357,6 +363,7 @@ static ssize_t iowarrior_write(struct file *file,
 	}
 	switch (dev->product_id) {
 	case USB_DEVICE_ID_CODEMERCS_IOW24:
+	case USB_DEVICE_ID_CODEMERCS_IOW24SAG:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV1:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
@@ -371,6 +378,7 @@ static ssize_t iowarrior_write(struct file *file,
 		goto exit;
 		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
+	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -493,6 +501,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case IOW_WRITE:
 		if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24 ||
+		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24SAG ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV1 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV2 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW40) {
@@ -767,7 +776,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) {
+	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -780,7 +790,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 	/* we have to check the report_size often, so remember it in the endianness suitable for our machine */
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56))
+	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 
-- 
2.25.0


