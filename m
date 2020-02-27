Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D4171C90
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbgB0ONV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388958AbgB0ONT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5BAF20801;
        Thu, 27 Feb 2020 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812798;
        bh=+0asDplfb07wNNmLESV2a03zLzTheHS3Q5EA2UglSmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaBvKdyToTv9IDOqa1Ihwp48Bi/FNPZ+/d9QSDVKOzmZ3LoqNN3jfguwchUR+I7HK
         GfvP069ryLaWkYx5tquyD2dXH/4hfBKEKNKO5ieDtfJiT0cPlQ9r77Gx5Pkm95nxW4
         5kz0kVC3n7P5QtE2u6hcAI/Ds+Fyj7YV7JQnZlxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Jung <jung@codemercs.com>
Subject: [PATCH 5.5 020/150] USB: misc: iowarrior: add support for 2 OEMed devices
Date:   Thu, 27 Feb 2020 14:35:57 +0100
Message-Id: <20200227132235.691647719@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
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
@@ -133,6 +137,8 @@ static const struct usb_device_id iowarr
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV1)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV2)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24SAG)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -357,6 +363,7 @@ static ssize_t iowarrior_write(struct fi
 	}
 	switch (dev->product_id) {
 	case USB_DEVICE_ID_CODEMERCS_IOW24:
+	case USB_DEVICE_ID_CODEMERCS_IOW24SAG:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV1:
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
@@ -371,6 +378,7 @@ static ssize_t iowarrior_write(struct fi
 		goto exit;
 		break;
 	case USB_DEVICE_ID_CODEMERCS_IOW56:
+	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -493,6 +501,7 @@ static long iowarrior_ioctl(struct file
 	switch (cmd) {
 	case IOW_WRITE:
 		if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24 ||
+		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW24SAG ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV1 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOWPV2 ||
 		    dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW40) {
@@ -767,7 +776,8 @@ static int iowarrior_probe(struct usb_in
 		goto error;
 	}
 
-	if (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) {
+	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -780,7 +790,8 @@ static int iowarrior_probe(struct usb_in
 	/* we have to check the report_size often, so remember it in the endianness suitable for our machine */
 	dev->report_size = usb_endpoint_maxp(dev->int_in_endpoint);
 	if ((dev->interface->cur_altsetting->desc.bInterfaceNumber == 0) &&
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56))
+	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 


