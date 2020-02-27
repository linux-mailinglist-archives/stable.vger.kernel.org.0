Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748E1171B1B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgB0N7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732136AbgB0N7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E73920801;
        Thu, 27 Feb 2020 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811974;
        bh=lWkynrj0Gr/70px+CsO3TZpEUaIDq8yPdN6Pjb49AGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFEu9xHrpOxPLIRuU+JSNNhDdXnlVoG+5s4VYVcD5UyRmRWK46FPjq9j7z5MizFdw
         Qt00gARUFnzKNKgaGDDtcbpnu/Gv4WHtgVAJGTSfaoDEM8/2hvfVAzfCMpZkrgCO08
         ohUlZ+Y7v9AWGgPz0As9Km6OY7S4jxbaMH3ptLFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Jung <jung@codemercs.com>
Subject: [PATCH 4.14 173/237] USB: misc: iowarrior: add support for 2 OEMed devices
Date:   Thu, 27 Feb 2020 14:36:27 +0100
Message-Id: <20200227132309.151534544@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 461d8deb26a7d70254bc0391feb4fd8a95e674e8 upstream.

Add support for two OEM devices that are identical to existing
IO-Warrior devices, except for the USB device id.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212040422.2991-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -33,6 +33,10 @@
 /* full speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW56	0x1503
 
+/* OEMed devices */
+#define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
+#define USB_DEVICE_ID_CODEMERCS_IOW56AM		0x158b
+
 /* Get a minor range for your devices from the usb maintainer */
 #ifdef CONFIG_USB_DYNAMIC_MINORS
 #define IOWARRIOR_MINOR_BASE	0
@@ -137,6 +141,8 @@ static const struct usb_device_id iowarr
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV1)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV2)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24SAG)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -364,6 +370,7 @@ static ssize_t iowarrior_write(struct fi
 	}
 	switch (dev->product_id) {
 	case USB_DEVICE_ID_CODEMERCS_IOW24:
+	case USB_DEVICE_ID_CODEMERCS_IOW24SAG:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV1:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
@@ -378,6 +385,7 @@ static ssize_t iowarrior_write(struct fi
 		goto exit;
 		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
+	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -502,6 +510,7 @@ static long iowarrior_ioctl(struct file
 	switch (cmd) {
 	case IOW_WRITE:
 		if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24 ||
+		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24SAG ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV1 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV2 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW40) {
@@ -786,7 +795,8 @@ static int iowarrior_probe(struct usb_in
 		goto error;
 	}
 
-	if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) {
+	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -799,7 +809,8 @@ static int iowarrior_probe(struct usb_in
 	/* we have to check the report_size often, so remember it in the endianness suitable for our machine */
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56))
+	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 


