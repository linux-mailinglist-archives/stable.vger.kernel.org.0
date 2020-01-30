Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143D414E24C
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgA3SpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbgA3SpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DB32082E;
        Thu, 30 Jan 2020 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409912;
        bh=8SpjqQJ6XefrrOUtpsnLYmKICQ97bfsQ1FpvcQPhArE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXmdeo5ZVAork8Hx6BDZYxGJ5FPRpnijTxgb5YwRTq+aM/ksd6R/NISFK15eLV4I3
         dGkuVUc/WxHmQGpt71j58AIIKzB4+3org+7B8d7X5m8mpe0gAFhYyzp9xsDXPYN5yZ
         4XLtVqH+YLKYUvKAJ1CdoxRglpcra5FKvwOMa964=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Slawomir Pawlowski <slawomir.pawlowski@intel.com>,
        Przemek Kitszel <przemyslawx.kitszel@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/110] PCI: Add DMA alias quirk for Intel VCA NTB
Date:   Thu, 30 Jan 2020 19:38:57 +0100
Message-Id: <20200130183623.811457664@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Pawlowski <slawomir.pawlowski@intel.com>

[ Upstream commit 56b4cd4b7da9ee95778eb5c8abea49f641ebfd91 ]

Intel Visual Compute Accelerator (VCA) is a family of PCIe add-in devices
exposing computational units via Non Transparent Bridges (NTB, PEX 87xx).

Similarly to MIC x200, we need to add DMA aliases to allow buffer access
when IOMMU is enabled.

Add aliases to allow computational unit access to host memory.  These
aliases mark the whole VCA device as one IOMMU group.

All possible slot numbers (0x20) are used, since we are unable to tell what
slot is used on other side.  This quirk is intended for both host and
computational unit sides.  The VCA devices have up to five functions: four
for DMA channels and one additional.

Link: https://lore.kernel.org/r/5683A335CC8BE1438C3C30C49DCC38DF637CED8E@IRSMSX102.ger.corp.intel.com
Signed-off-by: Slawomir Pawlowski <slawomir.pawlowski@intel.com>
Signed-off-by: Przemek Kitszel <przemyslawx.kitszel@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1593b8494ebbc..2f88b1ff7ada4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4080,6 +4080,40 @@ static void quirk_mic_x200_dma_alias(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2260, quirk_mic_x200_dma_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2264, quirk_mic_x200_dma_alias);
 
+/*
+ * Intel Visual Compute Accelerator (VCA) is a family of PCIe add-in devices
+ * exposing computational units via Non Transparent Bridges (NTB, PEX 87xx).
+ *
+ * Similarly to MIC x200, we need to add DMA aliases to allow buffer access
+ * when IOMMU is enabled.  These aliases allow computational unit access to
+ * host memory.  These aliases mark the whole VCA device as one IOMMU
+ * group.
+ *
+ * All possible slot numbers (0x20) are used, since we are unable to tell
+ * what slot is used on other side.  This quirk is intended for both host
+ * and computational unit sides.  The VCA devices have up to five functions
+ * (four for DMA channels and one additional).
+ */
+static void quirk_pex_vca_alias(struct pci_dev *pdev)
+{
+	const unsigned int num_pci_slots = 0x20;
+	unsigned int slot;
+
+	for (slot = 0; slot < num_pci_slots; slot++) {
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x0));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x1));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x2));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x3));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x4));
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2954, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2955, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2956, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2958, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2959, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x295A, quirk_pex_vca_alias);
+
 /*
  * The IOMMU and interrupt controller on Broadcom Vulcan/Cavium ThunderX2 are
  * associated not at the root bus, but at a bridge below. This quirk avoids
-- 
2.20.1



