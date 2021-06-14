Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EB43A6B0E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 17:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhFNP6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 11:58:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234429AbhFNP6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 11:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=8p8DIkgI123uyaFucDHlL3THLzWQithE96inzTy5GLI=; b=xqoDnhNiFFQP8me6Cib1z1liH5
        /Ui4a3e1rpsOiws7lFNpDlXaaTY99VkwWaNFVmMuIgOEsqIxRwEIKIpTwNrpld3y9wZON8ldLGtRb
        4W4gh5SQNEFKC3XgGoisDwHqUBYm0iWRrXJ7BQ4K5FXHzretMvPqCX+mX71BdYjmAIQ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsow4-009LpY-4w; Mon, 14 Jun 2021 17:55:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     gregkh@linuxfoundation.org
Cc:     stern@rowland.harvard.edu, Thinh.Nguyen@synopsys.com,
        gustavoars@kernel.org, tglx@linutronix.de, cuibixuan@huawei.com,
        oneukum@suse.com, chris.chiu@canonical.com, hgajjar@de.adit-jv.com,
        linux-usb@vger.kernel.org, martin.zobel@kinexon.com,
        philipp.mohrenweiser@kinexon.com, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Subject: [PATCH] usb: core: hub: Disable autosuspend for Cypress CY7C65632
Date:   Mon, 14 Jun 2021 17:55:23 +0200
Message-Id: <20210614155524.2228800-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Cypress CY7C65632 appears to have an issue with auto suspend and
detecting devices, not too dissimilar to the SMSC 5534B hub. It is
easiest to reproduce by connecting multiple mass storage devices to
the hub at the same time. On a Lenovo Yoga, around 1 in 3 attempts
result in the devices not being detected. It is however possible to
make them appear using lsusb -v.

Disabling autosuspend for this hub resolves the issue.

Cc: stable@vger.kernel.org
Fixes: 1208f9e1d758 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/usb/core/hub.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3bd379d5d1be..d1efc7141333 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -41,6 +41,8 @@
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
 #define USB_VENDOR_SMSC				0x0424
 #define USB_PRODUCT_USB5534B			0x5534
+#define USB_VENDOR_CYPRESS			0x04b4
+#define USB_PRODUCT_CY7C65632			0x6570
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5719,6 +5721,11 @@ static const struct usb_device_id hub_id_table[] = {
       .idProduct = USB_PRODUCT_USB5534B,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+                   | USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_CYPRESS,
+      .idProduct = USB_PRODUCT_CY7C65632,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
 			| USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
-- 
2.32.0

