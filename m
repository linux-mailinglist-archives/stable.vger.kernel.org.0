Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20321EA94D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgFASAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbgFASAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CF3206E2;
        Mon,  1 Jun 2020 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034414;
        bh=lEs7O1rZBUCuzb/jSCMrxt3jnkduhVK1kGNYfbO8NQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayWs9azZVJejB2X7ASSvKqHHR2dpB3V2buTe7Rg3IL7400lNB2sk/DluBAebi6Rsx
         JKDJL34oOBWjsAHK3VOThjayHX1RZqkApuvbarDf426zp+4LjLzlO0D2nyOIrw8jdD
         2n5+kf1j8yNOysaMZKtzPXSEa9cUGORZfyUJxgmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Payne <marc.payne@mdpsys.co.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 06/77] r8152: support additional Microsoft Surface Ethernet Adapter variant
Date:   Mon,  1 Jun 2020 19:53:11 +0200
Message-Id: <20200601174017.556921943@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Payne <marc.payne@mdpsys.co.uk>

[ Upstream commit c27a204383616efba5a4194075e90819961ff66a ]

Device id 0927 is the RTL8153B-based component of the 'Surface USB-C to
Ethernet and USB Adapter' and may be used as a component of other devices
in future. Tested and working with the r8152 driver.

Update the cdc_ether blacklist due to the RTL8153 'network jam on suspend'
issue which this device will cause (personally confirmed).

Signed-off-by: Marc Payne <marc.payne@mdpsys.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |   11 +++++++++--
 drivers/net/usb/r8152.c     |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -821,14 +821,21 @@ static const struct usb_device_id	produc
 	.driver_info = 0,
 },
 
-/* Microsoft Surface 3 dock (based on Realtek RTL8153) */
+/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x07c6, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = 0,
 },
 
-	/* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
+/* Microsoft Surface Ethernet Adapter (based on Realtek RTL8153B) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(MICROSOFT_VENDOR_ID, 0x0927, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
+/* TP-LINK UE300 USB 3.0 Ethernet Adapters (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, 0x0601, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5329,6 +5329,7 @@ static const struct usb_device_id rtl815
 	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},


