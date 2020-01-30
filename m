Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2234914E215
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgA3Sti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbgA3SsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793CE20674;
        Thu, 30 Jan 2020 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410091;
        bh=B5CAqITg+xjRYKHIzLuJEemrbFWOdQXa62YKePITZSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv0FwV6LTiDiEXK5ZeRTaKMXjqHyar6cpEVQVrdUn4xy5EGb/KKvjiq4W7/YsBl4S
         116UOh6GLDhBU1Pw9PIH5JC+sf+kEMFMZ6NXzKyK/dNL/bJaZLDUy+XFO1GKjUrlEO
         mW2hLwo+GT3zYT+LeKZJestf4qlBoeIWkbVdntIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Slawomir Pawlowski <slawomir.pawlowski@intel.com>,
        Przemek Kitszel <przemyslawx.kitszel@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/55] PCI: Add DMA alias quirk for Intel VCA NTB
Date:   Thu, 30 Jan 2020 19:39:23 +0100
Message-Id: <20200130183616.186312117@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
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
index 36f8eb9f24a73..5b4c36ab15962 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3986,6 +3986,40 @@ static void quirk_mic_x200_dma_alias(struct pci_dev *pdev)
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



