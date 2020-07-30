Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14064232B35
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 07:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgG3FQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 01:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgG3FQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 01:16:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF1BB2083B;
        Thu, 30 Jul 2020 05:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596086160;
        bh=l+mLep5Fq3HQ2W2V6P3qTfg50YfIS9+OiWKLlSLFlvw=;
        h=Subject:To:From:Date:From;
        b=2QqKNyEhJCWBDRp/We3jgkbyCwvtw26ArppTx26JNz7SqBrDguwVU3tqJ6mKFQrLS
         N1UPGBpFuZ1Sd4sDFyTS+Sbkv/T1OdTdwsdR41XY2R7datFI/mT7TVpGQqhMNT1Fcb
         T81QrH2vNTZrSJh1ewfuB9pqqubNTfDxWyCGRQjo=
Subject: patch "usb: xhci: define IDs for various ASMedia host controllers" added to usb-next
To:     cyrozap@gmail.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jul 2020 07:14:24 +0200
Message-ID: <1596086064172167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: define IDs for various ASMedia host controllers

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1841cb255da41e87bed9573915891d056f80e2e7 Mon Sep 17 00:00:00 2001
From: Forest Crossman <cyrozap@gmail.com>
Date: Mon, 27 Jul 2020 23:24:07 -0500
Subject: usb: xhci: define IDs for various ASMedia host controllers

Not all ASMedia host controllers have a device ID that matches its part
number. #define some of these IDs to make it clearer at a glance which
chips require what quirks.

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Link: https://lore.kernel.org/r/20200728042408.180529-2-cyrozap@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9234c82e70e4..baa5af88ca67 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -57,7 +57,9 @@
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
+#define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
+#define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
 
 static const char hcd_name[] = "xhci_hcd";
 
@@ -260,13 +262,13 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x1042)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x1142)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-			pdev->device == 0x2142)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI)
 		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-- 
2.28.0


