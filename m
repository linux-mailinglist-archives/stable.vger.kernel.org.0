Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302AE3B6337
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhF1OxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhF1OvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB6561CB9;
        Mon, 28 Jun 2021 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891029;
        bh=nQmVfg9UwN0FdLusYZjX62DtsMTjnG3Es9svWslVXBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf32iUs3Z6mkHYrhCIm56rDazTAW1rkD8EQtJ6PhCQHOjgCfnL/yACYpG1prZdFWk
         YVL7gQVjME0BQ1ICu0OhuBSmVY8sHy9OO2AkU1Xb4DHPrKAHnkC7vxtdNPZ4QeCpZ+
         6MmZw3C5RZVcCecrtMZbCYF+dpnkdAwJ/GLgmO0iVEreE51cx3ug7sa4sSo7WVwhsI
         3y7p2KecOEf0iaSNZzRd66w0wtIjSS7lwHcmvhJKL3mrevBTRPzQOsq3HwpUadjOt+
         8b/SKOhtFZ35xvSZk4cyOv7fDhU6uE+FsXwoOCM09Z3tnMaS1LQsATsHOLY1MtcyJ0
         ib3z7I/XLKjcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 45/88] usb: core: hub: Disable autosuspend for Cypress CY7C65632
Date:   Mon, 28 Jun 2021 10:35:45 -0400
Message-Id: <20210628143628.33342-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/usb/core/hub.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 40743e9e9d93..276a63ae510e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -38,6 +38,8 @@
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
 #define USB_VENDOR_SMSC				0x0424
 #define USB_PRODUCT_USB5534B			0x5534
+#define USB_VENDOR_CYPRESS			0x04b4
+#define USB_PRODUCT_CY7C65632			0x6570
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5325,6 +5327,11 @@ static const struct usb_device_id hub_id_table[] = {
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
2.30.2

