Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF56A2EBA2
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbfE3DOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728835AbfE3DOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C0324586;
        Thu, 30 May 2019 03:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186082;
        bh=pgrKVLsh0b+AWDDmrQVRBK0DwAU3bC6pO8ssl/MfGN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4o/1nIjgK9NN5K1zOtVJfxxjgeeT+Nbzt7eQuRVKHgJ5UhtbYquG6uil8rZqBgi8
         7H7j4D//wAYenLvsiYYPn4mno6pBqv3+clsUrjqVyDUu+ToE3RYIQdFRzb7PUurzOp
         KG1D24pUtSAjTv0ESJE/6M2WOgLLxmDmhsZdsapc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 204/346] qmi_wwan: Add quirk for Quectel dynamic config
Date:   Wed, 29 May 2019 20:04:37 -0700
Message-Id: <20190530030551.498788951@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e4bf63482c309287ca84d91770ffa7dcc18e37eb ]

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

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 65 ++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 366217263d704..d9a6699abe592 100644
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
@@ -969,20 +989,9 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
-	{	/* Quectel EP06/EG06/EM06 */
-		USB_DEVICE_AND_INTERFACE_INFO(0x2c7c, 0x0306,
-					      USB_CLASS_VENDOR_SPEC,
-					      USB_SUBCLASS_VENDOR_SPEC,
-					      0xff),
-		.driver_info	    = (unsigned long)&qmi_wwan_info_quirk_dtr,
-	},
-	{	/* Quectel EG12/EM12 */
-		USB_DEVICE_AND_INTERFACE_INFO(0x2c7c, 0x0512,
-					      USB_CLASS_VENDOR_SPEC,
-					      USB_SUBCLASS_VENDOR_SPEC,
-					      0xff),
-		.driver_info	    = (unsigned long)&qmi_wwan_info_quirk_dtr,
-	},
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
@@ -1283,7 +1292,6 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
-	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0125, 4)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
@@ -1363,27 +1371,12 @@ static bool quectel_ec20_detected(struct usb_interface *intf)
 	return false;
 }
 
-static bool quectel_diag_detected(struct usb_interface *intf)
-{
-	struct usb_device *dev = interface_to_usbdev(intf);
-	struct usb_interface_descriptor intf_desc = intf->cur_altsetting->desc;
-	u16 id_vendor = le16_to_cpu(dev->descriptor.idVendor);
-	u16 id_product = le16_to_cpu(dev->descriptor.idProduct);
-
-	if (id_vendor != 0x2c7c || intf_desc.bNumEndpoints != 2)
-		return false;
-
-	if (id_product == 0x0306 || id_product == 0x0512)
-		return true;
-	else
-		return false;
-}
-
 static int qmi_wwan_probe(struct usb_interface *intf,
 			  const struct usb_device_id *prod)
 {
 	struct usb_device_id *id = (struct usb_device_id *)prod;
 	struct usb_interface_descriptor *desc = &intf->cur_altsetting->desc;
+	const struct driver_info *info;
 
 	/* Workaround to enable dynamic IDs.  This disables usbnet
 	 * blacklisting functionality.  Which, if required, can be
@@ -1417,10 +1410,14 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 	 * we need to match on class/subclass/protocol. These values are
 	 * identical for the diagnostic- and QMI-interface, but bNumEndpoints is
 	 * different. Ignore the current interface if the number of endpoints
-	 * the number for the diag interface (two).
+	 * equals the number for the diag interface (two).
 	 */
-	if (quectel_diag_detected(intf))
-		return -ENODEV;
+	info = (void *)&id->driver_info;
+
+	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
+		if (desc->bNumEndpoints == 2)
+			return -ENODEV;
+	}
 
 	return usbnet_probe(intf, id);
 }
-- 
2.20.1



