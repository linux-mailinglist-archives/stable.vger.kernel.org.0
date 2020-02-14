Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5023F15ED88
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390322AbgBNQGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:06:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390314AbgBNQGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F8492082F;
        Fri, 14 Feb 2020 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696365;
        bh=aYvPL4xL2X6g2nzpVJWpIYuUFC45aYyDMfrrbDYhJj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPXb2vKkaq7qt1wmnF0HuzX08rSPsrlVzDCPE/ddHTMe+xUaD8f0cfKi4sLkN6FAX
         MQNA6R1JqCJ4EnqZOjxum2E0ag8DTObbKbpzcLFHr/SmPg/kf854OvRyaBVTcaRlgq
         XtD/OvuUlpB2yRPzIKLLG8e8RZIKC29zZV6t9buI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Sewart <jamessewart@arista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 196/459] PCI: Add nr_devfns parameter to pci_add_dma_alias()
Date:   Fri, 14 Feb 2020 10:57:26 -0500
Message-Id: <20200214160149.11681-196-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Sewart <jamessewart@arista.com>

[ Upstream commit 09298542cd891b43778db1f65aa3613aa5a562eb ]

Add a "nr_devfns" parameter to pci_add_dma_alias() so it can be used to
create DMA aliases for a range of devfns.

[bhelgaas: incorporate nr_devfns fix from James, update
quirk_pex_vca_alias() and setup_aliases()]
Signed-off-by: James Sewart <jamessewart@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c |  7 ++-----
 drivers/pci/pci.c         | 22 +++++++++++++++++-----
 drivers/pci/quirks.c      | 23 +++++++++--------------
 include/linux/pci.h       |  2 +-
 4 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 454695b372c8c..8bd5d608a82c2 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -272,11 +272,8 @@ static struct pci_dev *setup_aliases(struct device *dev)
 	 */
 	ivrs_alias = amd_iommu_alias_table[pci_dev_id(pdev)];
 	if (ivrs_alias != pci_dev_id(pdev) &&
-	    PCI_BUS_NUM(ivrs_alias) == pdev->bus->number) {
-		pci_add_dma_alias(pdev, ivrs_alias & 0xff);
-		pci_info(pdev, "Added PCI DMA alias %02x.%d\n",
-			PCI_SLOT(ivrs_alias), PCI_FUNC(ivrs_alias));
-	}
+	    PCI_BUS_NUM(ivrs_alias) == pdev->bus->number)
+		pci_add_dma_alias(pdev, ivrs_alias & 0xff, 1);
 
 	clone_aliases(pdev);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index cbf3d3889874c..981ae16f935bc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5875,7 +5875,8 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
 /**
  * pci_add_dma_alias - Add a DMA devfn alias for a device
  * @dev: the PCI device for which alias is added
- * @devfn: alias slot and function
+ * @devfn_from: alias slot and function
+ * @nr_devfns: number of subsequent devfns to alias
  *
  * This helper encodes an 8-bit devfn as a bit number in dma_alias_mask
  * which is used to program permissible bus-devfn source addresses for DMA
@@ -5891,8 +5892,13 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
  * cannot be left as a userspace activity).  DMA aliases should therefore
  * be configured via quirks, such as the PCI fixup header quirk.
  */
-void pci_add_dma_alias(struct pci_dev *dev, u8 devfn)
+void pci_add_dma_alias(struct pci_dev *dev, u8 devfn_from, unsigned nr_devfns)
 {
+	int devfn_to;
+
+	nr_devfns = min(nr_devfns, (unsigned) MAX_NR_DEVFNS - devfn_from);
+	devfn_to = devfn_from + nr_devfns - 1;
+
 	if (!dev->dma_alias_mask)
 		dev->dma_alias_mask = bitmap_zalloc(MAX_NR_DEVFNS, GFP_KERNEL);
 	if (!dev->dma_alias_mask) {
@@ -5900,9 +5906,15 @@ void pci_add_dma_alias(struct pci_dev *dev, u8 devfn)
 		return;
 	}
 
-	set_bit(devfn, dev->dma_alias_mask);
-	pci_info(dev, "Enabling fixed DMA alias to %02x.%d\n",
-		 PCI_SLOT(devfn), PCI_FUNC(devfn));
+	bitmap_set(dev->dma_alias_mask, devfn_from, nr_devfns);
+
+	if (nr_devfns == 1)
+		pci_info(dev, "Enabling fixed DMA alias to %02x.%d\n",
+				PCI_SLOT(devfn_from), PCI_FUNC(devfn_from));
+	else if (nr_devfns > 1)
+		pci_info(dev, "Enabling fixed DMA alias for devfn range from %02x.%d to %02x.%d\n",
+				PCI_SLOT(devfn_from), PCI_FUNC(devfn_from),
+				PCI_SLOT(devfn_to), PCI_FUNC(devfn_to));
 }
 
 bool pci_devs_are_dma_aliases(struct pci_dev *dev1, struct pci_dev *dev2)
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7b6df2d8d6cde..67a9ad3734d18 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3927,7 +3927,7 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 static void quirk_dma_func0_alias(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 0)
-		pci_add_dma_alias(dev, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
+		pci_add_dma_alias(dev, PCI_DEVFN(PCI_SLOT(dev->devfn), 0), 1);
 }
 
 /*
@@ -3941,7 +3941,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
 static void quirk_dma_func1_alias(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
-		pci_add_dma_alias(dev, PCI_DEVFN(PCI_SLOT(dev->devfn), 1));
+		pci_add_dma_alias(dev, PCI_DEVFN(PCI_SLOT(dev->devfn), 1), 1);
 }
 
 /*
@@ -4026,7 +4026,7 @@ static void quirk_fixed_dma_alias(struct pci_dev *dev)
 
 	id = pci_match_id(fixed_dma_alias_tbl, dev);
 	if (id)
-		pci_add_dma_alias(dev, id->driver_data);
+		pci_add_dma_alias(dev, id->driver_data, 1);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ADAPTEC2, 0x0285, quirk_fixed_dma_alias);
@@ -4068,9 +4068,9 @@ DECLARE_PCI_FIXUP_HEADER(0x8086, 0x244e, quirk_use_pcie_bridge_dma_alias);
  */
 static void quirk_mic_x200_dma_alias(struct pci_dev *pdev)
 {
-	pci_add_dma_alias(pdev, PCI_DEVFN(0x10, 0x0));
-	pci_add_dma_alias(pdev, PCI_DEVFN(0x11, 0x0));
-	pci_add_dma_alias(pdev, PCI_DEVFN(0x12, 0x3));
+	pci_add_dma_alias(pdev, PCI_DEVFN(0x10, 0x0), 1);
+	pci_add_dma_alias(pdev, PCI_DEVFN(0x11, 0x0), 1);
+	pci_add_dma_alias(pdev, PCI_DEVFN(0x12, 0x3), 1);
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2260, quirk_mic_x200_dma_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2264, quirk_mic_x200_dma_alias);
@@ -4094,13 +4094,8 @@ static void quirk_pex_vca_alias(struct pci_dev *pdev)
 	const unsigned int num_pci_slots = 0x20;
 	unsigned int slot;
 
-	for (slot = 0; slot < num_pci_slots; slot++) {
-		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x0));
-		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x1));
-		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x2));
-		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x3));
-		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x4));
-	}
+	for (slot = 0; slot < num_pci_slots; slot++)
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x0), 5);
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2954, quirk_pex_vca_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2955, quirk_pex_vca_alias);
@@ -5315,7 +5310,7 @@ static void quirk_switchtec_ntb_dma_alias(struct pci_dev *pdev)
 			pci_dbg(pdev,
 				"Aliasing Partition %d Proxy ID %02x.%d\n",
 				pp, PCI_SLOT(devfn), PCI_FUNC(devfn));
-			pci_add_dma_alias(pdev, devfn);
+			pci_add_dma_alias(pdev, devfn, 1);
 		}
 	}
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index be529d311122d..f39f22f9ee474 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2324,7 +2324,7 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
 }
 #endif
 
-void pci_add_dma_alias(struct pci_dev *dev, u8 devfn);
+void pci_add_dma_alias(struct pci_dev *dev, u8 devfn_from, unsigned nr_devfns);
 bool pci_devs_are_dma_aliases(struct pci_dev *dev1, struct pci_dev *dev2);
 int pci_for_each_dma_alias(struct pci_dev *pdev,
 			   int (*fn)(struct pci_dev *pdev,
-- 
2.20.1

