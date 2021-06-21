Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EF43AEDB8
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhFUQWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhFUQVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A104D61352;
        Mon, 21 Jun 2021 16:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292339;
        bh=K3UXGVGEXfHHx/fsn/oAVdyCMC7NfXsOP4Y6FB8e5e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EA9q/nWDxLtoqoiPtTswOx+s6s0c3isVxXqxnEqgM6yAQFZvHRTMU816dUraRSJsI
         jgUZXeFhH7PgODrBflRo3TchvguUSSlSTSNyhc9qKOsB3qYGrQN4Y0SIdsmDXO56j9
         Zn3z2dveUC4qWjvSi2vyBhTDbKDXRkgPg8150L8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 5.4 54/90] usb: core: hub: Disable autosuspend for Cypress CY7C65632
Date:   Mon, 21 Jun 2021 18:15:29 +0200
Message-Id: <20210621154905.983661575@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit a7d8d1c7a7f73e780aa9ae74926ae5985b2f895f upstream.

The Cypress CY7C65632 appears to have an issue with auto suspend and
detecting devices, not too dissimilar to the SMSC 5534B hub. It is
easiest to reproduce by connecting multiple mass storage devices to
the hub at the same time. On a Lenovo Yoga, around 1 in 3 attempts
result in the devices not being detected. It is however possible to
make them appear using lsusb -v.

Disabling autosuspend for this hub resolves the issue.

Fixes: 1208f9e1d758 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210614155524.2228800-1-andrew@lunn.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -39,6 +39,8 @@
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
 #define USB_VENDOR_SMSC				0x0424
 #define USB_PRODUCT_USB5534B			0x5534
+#define USB_VENDOR_CYPRESS			0x04b4
+#define USB_PRODUCT_CY7C65632			0x6570
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5515,6 +5517,11 @@ static const struct usb_device_id hub_id
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+                   | USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_CYPRESS,
+      .idProduct = USB_PRODUCT_CY7C65632,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
 			| USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
       .bInterfaceClass = USB_CLASS_HUB,


