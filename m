Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6689FDB15
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfKOKSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:18:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfKOKSZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:18:25 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 269BE20748;
        Fri, 15 Nov 2019 10:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813104;
        bh=cja6BeswdWYflU3guYClKcDJ1v2uQR4YI3Otnp0hhOo=;
        h=Subject:To:From:Date:From;
        b=0XRMyXuxaFv86LZofbOvd3C7+iMGfMUN1ej8BK8ubxUbZqUKYCC3RAhHMZCoZu2A9
         tQrj1jI8gGZfAl5yPVpm3/oW1vCsLNvFexsWAcA0SUKZB5C0sFvC4YlbFJrfI2FJvb
         lu/xIWxRFp1dj69PFh+3AuR20cXtU3wf88g2N2Q4=
Subject: patch "USB: serial: mos7840: add USB ID to support Moxa UPort 2210" added to usb-next
To:     pavel@loebl.cz, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:18:21 +0800
Message-ID: <157381310167184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: mos7840: add USB ID to support Moxa UPort 2210

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From e696d00e65e81d46e911f24b12e441037bf11b38 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pavel=20L=C3=B6bl?= <pavel@loebl.cz>
Date: Fri, 1 Nov 2019 08:01:50 +0100
Subject: USB: serial: mos7840: add USB ID to support Moxa UPort 2210
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add USB ID for MOXA UPort 2210. This device contains mos7820 but
it passes GPIO0 check implemented by driver and it's detected as
mos7840. Hence product id check is added to force mos7820 mode.

Signed-off-by: Pavel Löbl <pavel@loebl.cz>
Cc: stable <stable@vger.kernel.org>
[ johan: rename id defines and add vendor-id check ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7840.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index a698d46ba773..3eeeee38debc 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -119,11 +119,15 @@
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
  * ATEN UC2322 device using Moschip MCS7820
+ * MOXA UPort 2210 device using Moschip MCS7820
  */
 #define USB_VENDOR_ID_ATENINTL		0x0557
 #define ATENINTL_DEVICE_ID_UC2324	0x2011
 #define ATENINTL_DEVICE_ID_UC2322	0x7820
 
+#define USB_VENDOR_ID_MOXA		0x110a
+#define MOXA_DEVICE_ID_2210		0x2210
+
 /* Interrupt Routine Defines    */
 
 #define SERIAL_IIR_RLS      0x06
@@ -195,6 +199,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
+	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},
 	{}			/* terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -2020,6 +2025,7 @@ static int mos7840_probe(struct usb_serial *serial,
 				const struct usb_device_id *id)
 {
 	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
+	u16 vid = le16_to_cpu(serial->dev->descriptor.idVendor);
 	u8 *buf;
 	int device_type;
 
@@ -2030,6 +2036,11 @@ static int mos7840_probe(struct usb_serial *serial,
 		goto out;
 	}
 
+	if (vid == USB_VENDOR_ID_MOXA && product == MOXA_DEVICE_ID_2210) {
+		device_type = MOSCHIP_DEVICE_ID_7820;
+		goto out;
+	}
+
 	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
2.24.0


