Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD199171B79
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbgB0OCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733202AbgB0OCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC3E20578;
        Thu, 27 Feb 2020 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812167;
        bh=bji/UNK8mMEXp12l0PaZsW0JTTAb0Peu6SUk0C9bnuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8S3zxwgytszPU/Nmyy6nXzWAXJm6J+DvTIA0TZmBkcXwBHW0ZLLMUwH8mD07WkG8
         YTWDXwEHgtqYOWhJ2+spdjNgLAVdBMAUos3U2Lww2FXEaURvXbNj/vRdAkx/CKpMKD
         2PHoADjn+ngvQiY8xhzMJGCQ1TqIPjTmH5mqZ2lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Jung <jung@codemercs.com>
Subject: [PATCH 4.19 11/97] USB: misc: iowarrior: add support for the 100 device
Date:   Thu, 27 Feb 2020 14:36:19 +0100
Message-Id: <20200227132216.416403671@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bab5417f5f0118ce914bc5b2f8381e959e891155 upstream.

Add a new device id for the 100 devie.  It has 4 interfaces like the 28
and 28L devices but a larger endpoint so more I/O pins.

Cc: Christoph Jung <jung@codemercs.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200214161148.GA3963518@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -36,6 +36,7 @@
 /* fuller speed iowarrior */
 #define USB_DEVICE_ID_CODEMERCS_IOW28	0x1504
 #define USB_DEVICE_ID_CODEMERCS_IOW28L	0x1505
+#define USB_DEVICE_ID_CODEMERCS_IOW100	0x1506
 
 /* OEMed devices */
 #define USB_DEVICE_ID_CODEMERCS_IOW24SAG	0x158a
@@ -148,6 +149,7 @@ static const struct usb_device_id iowarr
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW56AM)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW28L)},
+	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW100)},
 	{}			/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, iowarrior_ids);
@@ -390,6 +392,7 @@ static ssize_t iowarrior_write(struct fi
 	case USB_DEVICE_ID_CODEMERCS_IOW56AM:
 	case USB_DEVICE_ID_CODEMERCS_IOW28:
 	case USB_DEVICE_ID_CODEMERCS_IOW28L:
+	case USB_DEVICE_ID_CODEMERCS_IOW100:
 		/* The IOW56 uses asynchronous IO and more urbs */
 		if (atomic_read(&dev->write_busy) == MAX_WRITES_IN_FLIGHT) {
 			/* Wait until we are below the limit for submitted urbs */
@@ -801,7 +804,8 @@ static int iowarrior_probe(struct usb_in
 	if ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
 	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
 	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
-	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)) {
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L) ||
+	    (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW100)) {
 		res = usb_find_last_int_out_endpoint(iface_desc,
 				&dev->int_out_endpoint);
 		if (res) {
@@ -817,7 +821,8 @@ static int iowarrior_probe(struct usb_in
 	    ((dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56) ||
 	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW56AM) ||
 	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28) ||
-	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L)))
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW28L) ||
+	     (dev->product_id == USB_DEVICE_ID_CODEMERCS_IOW100)))
 		/* IOWarrior56 has wMaxPacketSize different from report size */
 		dev->report_size = 7;
 


