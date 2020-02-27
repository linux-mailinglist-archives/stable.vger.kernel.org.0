Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21B171F6E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbgB0OgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:32792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732463AbgB0N7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7358B20578;
        Thu, 27 Feb 2020 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811976;
        bh=i6x5Qh8hMlaagzIr8Q9WVmUCG+H+9lNY3RPagOVKOHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RILeiyty255WzpCa6M/CuI1slU2EgQIsAXtM30YAoBYZ1Oo2/oUNjB84s1Wp0wS+u
         mxEqN18GhWzUv4L6SEQHIzC8tqePJiTdqmeDGvCqyWfuUgqh6lzj4vJW5xRGDtQoob
         3/o49VQqtbIzgyJMNMPZbadjVCcOMjDytfDT6ayc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Jung <jung@codemercs.com>
Subject: [PATCH 4.14 174/237] USB: misc: iowarrior: add support for the 28 and 28L devices
Date:   Thu, 27 Feb 2020 14:36:28 +0100
Message-Id: <20200227132309.217146827@linuxfoundation.org>
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

commit 5f6f8da2d7b5a431d3f391d0d73ace8edfb42af7 upstream.

Add new device ids for the 28 and 28L devices.  These have 4 interfaces
instead of 2, but the driver binds the same, so the driver changes are
minimal.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200212040422.2991-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -32,6 +32,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOWPV2	0x1512
 /* full speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW56	0x1503
+/* fuller speed iowarrior */
+#define USB_DEVICE_ID_CODEMERCS_IOW28	0x1504
+#define USB_DEVICE_ID_CODEMERCS_IOW28L	0x1505
 
 /* OEMed devices */
 #define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
@@ -143,6 +146,8 @@ static const struct usb_device_id iowarr
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24SAG)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28L)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -386,6 +391,8 @@ static ssize_t iowarrior_write(struct fi
 		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
 	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
+	case USB_DEVICE_ID_CODEMERCS_IOW28:
+	case USB_DEVICE_ID_CODEMERCS_IOW28L:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -796,7 +803,9 @@ static int iowarrior_probe(struct usb_in
 	}
 
 	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)) {
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -810,7 +819,9 @@ static int iowarrior_probe(struct usb_in
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
 	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
-	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)))
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 


