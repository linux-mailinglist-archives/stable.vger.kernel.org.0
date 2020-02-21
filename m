Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF781677D2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgBUHwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729870AbgBUHwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE8D20578;
        Fri, 21 Feb 2020 07:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271525;
        bh=+QlcluC9QLk6waoQcGx030akdh5WEF/5dwtHWd7jK7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CELuC8tOl5x7NLlS2zpE8aLIU5IYf88JcJ8KIb71dbZfagmoVnSY5qJWUvGEM+xxX
         g8Uhbkdcu0MN4RNtwduu9TfO7/dI7HTEM7TX6mQzlQ9dx/7k4HakF31CFpAFsy29+B
         MFJDGsNYL/WCXDf4Ms3FgDD7ayawKTDjLhelWzSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Sewart <jamessewart@arista.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 152/399] PCI: Add nr_devfns parameter to pci_add_dma_alias()
Date:   Fri, 21 Feb 2020 08:37:57 +0100
Message-Id: <20200221072417.259270897@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bd25674ee4dba..7a6c056b9b9cc 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -230,11 +230,8 @@ static struct pci_dev *setup_aliases(struct device *dev)
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
index 7b5fa2eabe095..951099279192d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5998,7 +5998,8 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
 /**
  * pci_add_dma_alias - Add a DMA devfn alias for a device
  * @dev: the PCI device for which alias is added
- * @devfn: alias slot and function
+ * @devfn_from: alias slot and function
+ * @nr_devfns: number of subsequent devfns to alias
  *
  * This helper encodes an 8-bit devfn as a bit number in dma_alias_mask
  * which is used to program permissible bus-devfn source addresses for DMA
@@ -6014,8 +6015,13 @@ EXPORT_SYMBOL_GPL(pci_pr3_present);
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
@@ -6023,9 +6029,15 @@ void pci_add_dma_alias(struct pci_dev *dev, u8 devfn)
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
index c0b7aa4dc0f51..9aa590eb712fe 100644
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
 
@@ -4067,9 +4067,9 @@ DECLARE_PCI_FIXUP_HEADER(0x8086, 0x244e, quirk_use_pcie_bridge_dma_alias);
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
@@ -4093,13 +4093,8 @@ static void quirk_pex_vca_alias(struct pci_dev *pdev)
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
@@ -5334,7 +5329,7 @@ static void quirk_switchtec_ntb_dma_alias(struct pci_dev *pdev)
 			pci_dbg(pdev,
 				"Aliasing Partition %d Proxy ID %02x.%d\n",
 				pp, PCI_SLOT(devfn), PCI_FUNC(devfn));
-			pci_add_dma_alias(pdev, devfn);
+			pci_add_dma_alias(pdev, devfn, 1);
 		}
 	}
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c393dff2d66f6..930fab2930736 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2310,7 +2310,7 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
 }
 #endif
 
-void pci_add_dma_alias(struct pci_dev *dev, u8 devfn);
+void pci_add_dma_alias(struct pci_dev *dev, u8 devfn_from, unsigned nr_devfns);
 bool pci_devs_are_dma_aliases(struct pci_dev *dev1, struct pci_dev *dev2);
 int pci_for_each_dma_alias(struct pci_dev *pdev,
 			   int (*fn)(struct pci_dev *pdev,
-- 
2.20.1



