Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87490F56AB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733142AbfKHTKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733054AbfKHTKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2E3420673;
        Fri,  8 Nov 2019 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240215;
        bh=KtYj48o4KEAxpLKreC1Q2lNuWWIVvYTfhACSsyqR/m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuWbMifQRNIwZBwB0gx9XV0rvUGn4QneH9CsjCr+oh5a7TRMcHslvC03mGvSzL1Bw
         erfDkhOaaBrni9Q3qjMW26AO6S67kPmgugwdNIKR7QWbQe6oeRxoJaNG4o7VDs8KXs
         Lu7eGqpYrTDhIdcGsx9PDkyBAgqHEXSu/ASVL+YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 129/140] r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2
Date:   Fri,  8 Nov 2019 19:50:57 +0100
Message-Id: <20191108174912.786493721@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>

[ Upstream commit b3060531979422d5bb18d80226f978910284dc70 ]

This device is sold as 'ThinkPad USB-C Dock Gen 2 (40AS)'.
Chipset is RTL8153 and works with r8152.
Without this, the generic cdc_ether grabs the device, and the device jam
connected networks up when the machine suspends.

Signed-off-by: Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/r8152.c     |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -787,6 +787,13 @@ static const struct usb_device_id	produc
 	.driver_info = 0,
 },
 
+/* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* NVIDIA Tegra USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(NVIDIA_VENDOR_ID, 0x09ff, USB_CLASS_COMM,
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5402,6 +5402,7 @@ static const struct usb_device_id rtl815
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},


