Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7495E3A580
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 14:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfFIMhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 08:37:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33623 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbfFIMhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 08:37:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so6472012wru.0
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 05:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bJhNdBF7aL34NSJsYHYje3Gbtu5H7QtIDqkqDqeiiwE=;
        b=fZLTRCpFpgJ55GcOTUV6wWda0kYKzewTEfVvZjsQZh9j5fUheqyCiKz+Md3KyXbEur
         FhnTwhskFaJP9R8isuK2ouqWPy9XC/woooEihZHeCwYisCu6mDsm160kEkzh35fvpNJG
         BR9p70gJi26jMCHkftsLOTW/nxxeCUZGhiriqZQwz5NWXQjo6VVjCHzQRwPxY+NPNrtS
         N2soPhQIOlQUQMGpevmeTd+NCHR5kW8iq2W1vWzaDDxXifkosUx3ndu63FVzNAgdaA0R
         Fdfjy8afPlOhQGbyuBWprxZsOHhA9SnS0U21z12/GMdGiSLdzLE2ZaMTh/1YunTj+Q+p
         //lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bJhNdBF7aL34NSJsYHYje3Gbtu5H7QtIDqkqDqeiiwE=;
        b=P0XJifjhyqXk+5F5P9VY32xVlZ7uKRHz/9jYf7nDjzm0zQIjgeW22Dc1BsOqXTpB+j
         FrHuEZ+xb3AwLa+4NL/DDQTmuh6Mm3PKVqLYU96/sr+KuGnIa5/SHoMYHHTEOco5eKHf
         UN82mcXnmmi10yCsIfwzjFZ3wB3wjp20BELKlglFNWAG9aPv+lshQHyecqEnm0P3NQeu
         HDoItJ2//dQlzDpPYX7f+6Oqd0furGMj0+xv65JpR37shqRvBA7+8kDCUgyWi6c2t3ow
         jBZ8Mk4CHFGQlCGCWXuvZrHiIltw+slVqjbT+LJgWj5dztFiS+TAEEe3+vAKWTe8JCIy
         DFkg==
X-Gm-Message-State: APjAAAVEyhE2KRigSqZQI6OeDgxYrPJ1DmbfoRFRAratefCzqO3ec2va
        d8P2IwRmg4yjPVcd27ZDS1c=
X-Google-Smtp-Source: APXvYqylUCB/6XnqoQDFHrXDUHvXORUMygN3U6Zu1Vn0sLTz/zma8aymwoFIN1FQWdTUyVKWX/9AOA==
X-Received: by 2002:adf:d081:: with SMTP id y1mr15801264wrh.34.1560083857085;
        Sun, 09 Jun 2019 05:37:37 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id x83sm7069265wmb.42.2019.06.09.05.37.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 05:37:36 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     kristian.evensen@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4.14] qmi_wwan: Add quirk for Quectel dynamic config
Date:   Sun,  9 Jun 2019 14:37:35 +0200
Message-Id: <20190609123735.24788-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e4bf63482c309287ca84d91770ffa7dcc18e37eb upstream.

Most, if not all, Quectel devices use dynamic interface numbers, and
users are able to change the USB configuration at will. Matching on for
example interface number is therefore not possible.

Instead, the QMI device can be identified by looking at the interface
class, subclass and protocol (all 0xff), as well as the number of
endpoints. The reason we need to look at the number of endpoints, is
that the diagnostic port interface has the same class, subclass and
protocol as QMI. However, the diagnostic port only has two endpoints,
while QMI has three.

Until now, we have identified the QMI device by combining a match on
class, subclass and protocol, with a call to the function
quectel_diag_detect(). In quectel_diag_detect(), we check if the number
of endpoints matches for known Quectel vendor/product ids.

Adding new vendor/product ids to quectel_diag_detect() is not a good
long-term solution. This commit replaces the function with a quirk, and
applies the quirk to affected Quectel devices that I have been able to
test the change with (EP06, EM12 and EC25). If the quirk is set and the
number of endpoints equal two, we return from qmi_wwan_probe() with
-ENODEV.

In order for this patch to apply cleanly to 4.14, two minor changes had
to be made. First, the original work-around (quectel_diag_detect()) for
the dynamic interface numbers was never backported to 4.14, so there is
no need to remove this code. Second, support for the EM12 was also not
backported to 4.14. Since supporting EM12 is a trivial change (just
another VID/PID match), and the match for EM12 is changed by this patch,
I chose to not submit adding EM12-support as a separate patch.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6d39dab49..c2d6c501d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -63,6 +63,7 @@ enum qmi_wwan_flags {
 
 enum qmi_wwan_quirks {
 	QMI_WWAN_QUIRK_DTR = 1 << 0,	/* needs "set DTR" request */
+	QMI_WWAN_QUIRK_QUECTEL_DYNCFG = 1 << 1,	/* check num. endpoints */
 };
 
 struct qmimux_hdr {
@@ -845,6 +846,16 @@ static const struct driver_info	qmi_wwan_info_quirk_dtr = {
 	.data           = QMI_WWAN_QUIRK_DTR,
 };
 
+static const struct driver_info	qmi_wwan_info_quirk_quectel_dyncfg = {
+	.description	= "WWAN/QMI device",
+	.flags		= FLAG_WWAN | FLAG_SEND_ZLP,
+	.bind		= qmi_wwan_bind,
+	.unbind		= qmi_wwan_unbind,
+	.manage_power	= qmi_wwan_manage_power,
+	.rx_fixup       = qmi_wwan_rx_fixup,
+	.data           = QMI_WWAN_QUIRK_DTR | QMI_WWAN_QUIRK_QUECTEL_DYNCFG,
+};
+
 #define HUAWEI_VENDOR_ID	0x12D1
 
 /* map QMI/wwan function by a fixed interface number */
@@ -865,6 +876,15 @@ static const struct driver_info	qmi_wwan_info_quirk_dtr = {
 #define QMI_GOBI_DEVICE(vend, prod) \
 	QMI_FIXED_INTF(vend, prod, 0)
 
+/* Quectel does not use fixed interface numbers on at least some of their
+ * devices. We need to check the number of endpoints to ensure that we bind to
+ * the correct interface.
+ */
+#define QMI_QUIRK_QUECTEL_DYNCFG(vend, prod) \
+	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_VENDOR_SPEC, \
+				      USB_SUBCLASS_VENDOR_SPEC, 0xff), \
+	.driver_info = (unsigned long)&qmi_wwan_info_quirk_quectel_dyncfg
+
 static const struct usb_device_id products[] = {
 	/* 1. CDC ECM like devices match on the control interface */
 	{	/* Huawei E392, E398 and possibly others sharing both device id and more... */
@@ -969,6 +989,9 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
@@ -1258,11 +1281,9 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
-	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0125, 4)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
-	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0306, 4)},	/* Quectel EP06 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
 
 	/* 4. Gobi 1000 devices */
@@ -1344,6 +1365,7 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 {
 	struct usb_device_id *id = (struct usb_device_id *)prod;
 	struct usb_interface_descriptor *desc = &intf->cur_altsetting->desc;
+	const struct driver_info *info;
 
 	/* Workaround to enable dynamic IDs.  This disables usbnet
 	 * blacklisting functionality.  Which, if required, can be
@@ -1373,6 +1395,19 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
+	info = (void *)&id->driver_info;
+
+	/* Several Quectel modems supports dynamic interface configuration, so
+	 * we need to match on class/subclass/protocol. These values are
+	 * identical for the diagnostic- and QMI-interface, but bNumEndpoints is
+	 * different. Ignore the current interface if the number of endpoints
+	 * equals the number for the diag interface (two).
+	 */
+	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
+		if (desc->bNumEndpoints == 2)
+			return -ENODEV;
+	}
+
 	return usbnet_probe(intf, id);
 }
 
-- 
2.20.1

