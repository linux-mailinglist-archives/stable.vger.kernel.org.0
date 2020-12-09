Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D822D4345
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbgLINb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 08:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732040AbgLINb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 08:31:56 -0500
Subject: patch "xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607520675;
        bh=1PSduasDUkbo4VdtCqp+r4SozAVyijZtPNZN4Np/NZ0=;
        h=To:From:Date:From;
        b=YUtKinFiMiKBlqlCy1Fo6M3XW/rZ+Lia9q1L5wk+lzqxt3fH0epRo+Usn9UuIyg11
         QOND7IGSSTiXexEXNFADu9mQFuOf5vOAn4S0ND0XPut75Bv3uCP88VZ2efY9K1dRo+
         D1eFjo+rDtoucQanWZKmyev+kUbJx6biPLJXS+54=
To:     mika.westerberg@linux.intel.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 14:32:12 +0100
Message-ID: <160752073210212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 5a8e3229ac27956bdcc25b2709e5d196d109a27a Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 8 Dec 2020 11:29:11 +0200
Subject: xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI

Intel Maple Ridge is successor of Titan Ridge Thunderbolt controller. As
Titan Ridge this one also includes xHCI host controller. In order to
safe energy we should put it to low power state by default when idle.
For this reason allow host runtime PM for Maple Ridge.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-5-mathias.nyman@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5f94d7edeb37..84da8406d5b4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -56,6 +56,7 @@
 #define PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI		0x8a13
 #define PCI_DEVICE_ID_INTEL_CML_XHCI			0xa3af
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
+#define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -240,7 +241,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_4C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-- 
2.29.2


