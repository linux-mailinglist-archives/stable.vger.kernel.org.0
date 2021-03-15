Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72C533B847
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhCOOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhCOOAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D1BE64F5C;
        Mon, 15 Mar 2021 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816792;
        bh=31kDPtM0zHYIOc9UVzxVZTWXEYvH7Rx6TGQp70apgAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF8gfT11rWMiILF2JJWLpi4JfVTzHDSRrdLSSpHijuCvVH87bgD6sCESF6sMTQKS+
         tiM4cS/KaNpV/UQaAZlyu8DjHbJ7aYNUIbzKkWdNPOiOWJsRXZw/2TJaj9bnJCq3jA
         qkwVPtM9nMHPrWxPu5YgDRqv5gSC5QNHm9R0aaKU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Forest Crossman <cyrozap@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 113/168] usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing
Date:   Mon, 15 Mar 2021 14:55:45 +0100
Message-Id: <20210315135554.071525001@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Forest Crossman <cyrozap@gmail.com>

commit b71c669ad8390dd1c866298319ff89fe68b45653 upstream.

I've confirmed that both the ASMedia ASM1042A and ASM3242 have the same
problem as the ASM1142 and ASM2142/ASM3142, where they lose some of the
upper bits of 64-bit DMA addresses. As with the other chips, this can
cause problems on systems where the upper bits matter, and adding the
XHCI_NO_64BIT_SUPPORT quirk completely fixes the issue.

Cc: stable@vger.kernel.org
Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210311115353.2137560-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -62,6 +62,7 @@
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
+#define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
 static const char hcd_name[] = "xhci_hcd";
 
@@ -258,11 +259,14 @@ static void xhci_pci_quirks(struct devic
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 	    (pdev->device == PCI_DEVICE_ID_ASMEDIA_1142_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI))
+	     pdev->device == PCI_DEVICE_ID_ASMEDIA_2142_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_ASMEDIA_3242_XHCI))
 		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&


