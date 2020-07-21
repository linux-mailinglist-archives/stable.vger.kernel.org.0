Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14101227F95
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGUMGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 08:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgGUMGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 08:06:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 462C72080D;
        Tue, 21 Jul 2020 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595333163;
        bh=MP4EBOzjaIRBiMaCTDMfHH+oIX5XMk5o4tBV3d1jwI0=;
        h=Subject:To:From:Date:From;
        b=ec8T192potPqzx0cKPSQGliTIC9YXMtUMaiQLGMcnt6KlLpxQtECIfCFu+7EnTJQr
         QWpk/yeiC1YIIEbx9cq7AVqmyxuXgBobJTGac8w6va7/OVLTvyHXC3R43bEKEukh/U
         +5g6/Z1MxTUF8Nq6+Cmoe+0F9f+j5nScMcpGtsfA=
Subject: patch "usb: xhci: Fix ASM2142/ASM3142 DMA addressing" added to usb-linus
To:     cyrozap@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Jul 2020 14:06:04 +0200
Message-ID: <15953331649141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Fix ASM2142/ASM3142 DMA addressing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dbb0897e805f2ab1b8bc358f6c3d878a376b8897 Mon Sep 17 00:00:00 2001
From: Forest Crossman <cyrozap@gmail.com>
Date: Fri, 17 Jul 2020 06:27:34 -0500
Subject: usb: xhci: Fix ASM2142/ASM3142 DMA addressing

The ASM2142/ASM3142 (same PCI IDs) does not support full 64-bit DMA
addresses, which can cause silent memory corruption or IOMMU errors on
platforms that use the upper bits. Add the XHCI_NO_64BIT_SUPPORT quirk
to fix this issue.

Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200717112734.328432-1-cyrozap@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index ef513c2fb843..9234c82e70e4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -265,6 +265,9 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 			pdev->device == 0x1142)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+			pdev->device == 0x2142)
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
-- 
2.27.0


