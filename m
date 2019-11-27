Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE05D10BECC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfK0UpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbfK0UpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C9217BC;
        Wed, 27 Nov 2019 20:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887522;
        bh=UP8xhnwm9mOQf3lkpaDQYpf15dpt1IpTihG2vFWLnpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11qwYI3oKsTFz9rY1r2HlxM/9nsU0dV3Uf0EcVdnkQ4pIhXuJ2fdDc16zs5Sx6tOx
         pwB+1FYWF7PYYIQUrhktBaTw9uyeBJHe9ldUK29tcQjBgosTRr87IHeMzpl2GR+cX/
         WcVI2cUMZRoe3KWA/jyKH1OveYaqPiCc7a1lW7iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pavel=20L=C3=B6bl?= <pavel@loebl.cz>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 143/151] USB: serial: mos7840: add USB ID to support Moxa UPort 2210
Date:   Wed, 27 Nov 2019 21:32:06 +0100
Message-Id: <20191127203047.224401813@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Löbl <pavel@loebl.cz>

commit e696d00e65e81d46e911f24b12e441037bf11b38 upstream.

Add USB ID for MOXA UPort 2210. This device contains mos7820 but
it passes GPIO0 check implemented by driver and it's detected as
mos7840. Hence product id check is added to force mos7820 mode.

Signed-off-by: Pavel Löbl <pavel@loebl.cz>
Cc: stable <stable@vger.kernel.org>
[ johan: rename id defines and add vendor-id check ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -131,11 +131,15 @@
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
@@ -206,6 +210,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
+	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},
 	{}			/* terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -2089,6 +2094,7 @@ static int mos7840_probe(struct usb_seri
 				const struct usb_device_id *id)
 {
 	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
+	u16 vid = le16_to_cpu(serial->dev->descriptor.idVendor);
 	u8 *buf;
 	int device_type;
 
@@ -2098,6 +2104,11 @@ static int mos7840_probe(struct usb_seri
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


