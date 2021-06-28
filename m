Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D53B6292
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhF1Osd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235107AbhF1OoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD0E61CF0;
        Mon, 28 Jun 2021 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890840;
        bh=8GLORhw4t5Hdc0b9YmP6gVJWKK55j/62svtWPx1bMus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o64yRvAN2DoR/WJ9L//kbwswqkvbgef+W9SIc+1lv079DqHjYblkspbwOtpkZWwz7
         nDGK7rfXPQEIKuEdqe5h++yHNGGIh1c7FnVW6u6zuBEaQ4cz3P96SbgKHVHy+OJ5kU
         +IQOdYo4MNplWE6VHP1XlymumBu7U5rCB0p8/TYu8iE6fMT/r+cKQynGD97wxcSPT3
         22HQzC0rw74WYMxBVTCu7pAYoAniCbqI3HuWRCqJMsBDy/ksG7MrtfXNrS+5Cm/D5e
         6Lr4/w2LXS1l0tzH1Q4kYfq6ybGBA0GJ2623odDytp0BrttwvlZMY1izelLdkL0ldH
         CsyDsifbysVyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 060/109] usb: core: hub: Disable autosuspend for Cypress CY7C65632
Date:   Mon, 28 Jun 2021 10:32:16 -0400
Message-Id: <20210628143305.32978-61-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 0ddc2e30065f..a7f16dbfffdf 100644
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
 
@@ -5442,6 +5444,11 @@ static const struct usb_device_id hub_id_table[] = {
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

