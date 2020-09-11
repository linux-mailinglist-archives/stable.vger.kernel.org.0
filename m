Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE5265FE9
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgIKM6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgIKMzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 941762223E;
        Fri, 11 Sep 2020 12:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828860;
        bh=6NJTXH9H75nCwxHAINVLGrcAIuAzlW7RQ8pGyZWdLZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3Svc6qNVfScrk9sX2zjawfqjfvsAUq+H8amrKG3U8o/wfyfV+CwyReJpmGnElWvl
         1LgnvlwPSDLKqzRiOPmZHmoeu75ECxG08b+N1rhleK2G36bD0lgumMrMHV2gXuan66
         r5WzkF1LZNuBhhTwxsadMtHvmdorWCfd8N3SKJTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
Subject: [PATCH 4.4 35/62] qmi_wwan: add support for Quectel EC21 and EC25
Date:   Fri, 11 Sep 2020 14:46:18 +0200
Message-Id: <20200911122504.143707128@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 9a765881bf3dcd32847d7108cf48cb04a4ed993f ]

The Quectel EC21 and EC25 need the same "set DTR" request as devices
based on the MDM9230 chipset, but has no USB3 support. Our best guess
is that the "set DTR" functionality depends on chipset and/or
baseband firmware generation. But USB3 is still an optional feature.

Since we cannot enable this unconditionally for all older devices, and
there doesn't appear to be anything we can use in the USB descriptors
to identify these chips, we are forced to use a device specific quirk
flag.

Reported-and-tested-by: Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index ec03cf1f107bc..ffb2499a222da 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -59,6 +59,10 @@ enum qmi_wwan_flags {
 	QMI_WWAN_FLAG_RAWIP = 1 << 0,
 };
 
+enum qmi_wwan_quirks {
+	QMI_WWAN_QUIRK_DTR = 1 << 0,	/* needs "set DTR" request */
+};
+
 static void qmi_wwan_netdev_setup(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -411,9 +415,14 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * clearing out state the clients might need.
 	 *
 	 * MDM9x30 is the first QMI chipset with USB3 support. Abuse
-	 * this fact to enable the quirk.
+	 * this fact to enable the quirk for all USB3 devices.
+	 *
+	 * There are also chipsets with the same "set DTR" requirement
+	 * but without USB3 support.  Devices based on these chips
+	 * need a quirk flag in the device ID table.
 	 */
-	if (le16_to_cpu(dev->udev->descriptor.bcdUSB) >= 0x0201) {
+	if (dev->driver_info->data & QMI_WWAN_QUIRK_DTR ||
+	    le16_to_cpu(dev->udev->descriptor.bcdUSB) >= 0x0201) {
 		qmi_wwan_manage_power(dev, 1);
 		qmi_wwan_change_dtr(dev, true);
 	}
@@ -526,6 +535,16 @@ static const struct driver_info	qmi_wwan_info = {
 	.rx_fixup       = qmi_wwan_rx_fixup,
 };
 
+static const struct driver_info	qmi_wwan_info_quirk_dtr = {
+	.description	= "WWAN/QMI device",
+	.flags		= FLAG_WWAN,
+	.bind		= qmi_wwan_bind,
+	.unbind		= qmi_wwan_unbind,
+	.manage_power	= qmi_wwan_manage_power,
+	.rx_fixup       = qmi_wwan_rx_fixup,
+	.data           = QMI_WWAN_QUIRK_DTR,
+};
+
 #define HUAWEI_VENDOR_ID	0x12D1
 
 /* map QMI/wwan function by a fixed interface number */
@@ -533,6 +552,11 @@ static const struct driver_info	qmi_wwan_info = {
 	USB_DEVICE_INTERFACE_NUMBER(vend, prod, num), \
 	.driver_info = (unsigned long)&qmi_wwan_info
 
+/* devices requiring "set DTR" quirk */
+#define QMI_QUIRK_SET_DTR(vend, prod, num) \
+	USB_DEVICE_INTERFACE_NUMBER(vend, prod, num), \
+	.driver_info = (unsigned long)&qmi_wwan_info_quirk_dtr
+
 /* Gobi 1000 QMI/wwan interface number is 3 according to qcserial */
 #define QMI_GOBI1K_DEVICE(vend, prod) \
 	QMI_FIXED_INTF(vend, prod, 3)
@@ -921,6 +945,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_FIXED_INTF(0x1e0e, 0x9001, 5)},	/* SIMCom 7230E */
+	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0125, 4)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
+	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.25.1



