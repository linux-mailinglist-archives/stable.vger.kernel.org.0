Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480382320EF
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 16:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgG2OwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 10:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgG2OwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 10:52:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 473B120829;
        Wed, 29 Jul 2020 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596034327;
        bh=yUoxFcQVmiJxsCYpLNkCWRdXsHAOhYD0WGgDdTcP2uo=;
        h=Subject:To:From:Date:From;
        b=Vvw1oIWgtJAhrkx7qNkS9pOrzeoxtlewNljzewJWbiC3fO3+EVPzvc57xdZSEDmeJ
         Sopnip/udmLVe3fefHMxr24t1OWVnCmu+IWx37znEXlZ5wpfMwwEFounrrZLiREfXy
         TpDwTNLGgH1mupfhchjdazK3T0OvZuWzmR17Db/M=
Subject: patch "usb: xhci: Fix ASMedia ASM1142 DMA addressing" added to usb-testing
To:     cyrozap@gmail.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 29 Jul 2020 16:51:50 +0200
Message-ID: <1596034310637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Fix ASMedia ASM1142 DMA addressing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From ec37198acca7b4c17b96247697406e47aafe0605 Mon Sep 17 00:00:00 2001
From: Forest Crossman <cyrozap@gmail.com>
Date: Mon, 27 Jul 2020 23:24:08 -0500
Subject: usb: xhci: Fix ASMedia ASM1142 DMA addressing

I've confirmed that the ASMedia ASM1142 has the same problem as the
ASM2142/ASM3142, in that it too reports that it supports 64-bit DMA
addresses when in fact it does not. As with the ASM2142/ASM3142, this
can cause problems on systems where the upper bits matter, and adding
the XHCI_NO_64BIT_SUPPORT quirk completely fixes the issue.

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200728042408.180529-3-cyrozap@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index baa5af88ca67..3feaafebfe58 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_1			0x43bc
 #define PCI_DEVICE_ID_ASMEDIA_1042_XHCI			0x1042
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
+#define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
 
 static const char hcd_name[] = "xhci_hcd";
@@ -268,7 +269,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI)
+	    (pdev->device == PCI_DEVICE_ID_ASMEDIA_1142_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI))
 		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-- 
2.28.0


