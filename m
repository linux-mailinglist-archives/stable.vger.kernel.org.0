Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D314E253
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgA3SvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbgA3Sp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67551215A4;
        Thu, 30 Jan 2020 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409927;
        bh=Zq4F/Ve3Iyslt78uHqrrDIEnnHV8eM3FeTzoQFH0KQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDdozfyQtRtua5OPO4XKjn4mS5hWLrffkuka60SbcW3CpQOsAJVUPoBlKjJPi2fnT
         zh5PE/gzDtCQDyOL8gGGXocY4X+ZJziCB1+BdGbEnwdOx8vXWhXEjHpaTFvUdTy7yK
         V2Mb9FSyzd/mLmD2Ez4/SS5nXuO+nbMcVyH0Tg08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/110] iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping
Date:   Thu, 30 Jan 2020 19:39:03 +0100
Message-Id: <20200130183624.526829149@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 3c124435e8dd516df4b2fc983f4415386fd6edae ]

Non-Transparent Bridge (NTB) devices (among others) may have many DMA
aliases seeing the hardware will send requests with different device ids
depending on their origin across the bridged hardware.

See commit ad281ecf1c7d ("PCI: Add DMA alias quirk for Microsemi Switchtec
NTB") for more information on this.

The AMD IOMMU IRQ remapping functionality ignores all PCI aliases for
IRQs so if devices send an interrupt from one of their aliases they
will be blocked on AMD hardware with the IOMMU enabled.

To fix this, ensure IRQ remapping is enabled for all aliases with
MSI interrupts.

This is analogous to the functionality added to the Intel IRQ remapping
code in commit 3f0c625c6ae7 ("iommu/vt-d: Allow interrupts from the entire
bus for aliased devices")

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 16e0e3af2de0e..454695b372c8c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3741,7 +3741,20 @@ static void set_remap_table_entry(struct amd_iommu *iommu, u16 devid,
 	iommu_flush_dte(iommu, devid);
 }
 
-static struct irq_remap_table *alloc_irq_table(u16 devid)
+static int set_remap_table_entry_alias(struct pci_dev *pdev, u16 alias,
+				       void *data)
+{
+	struct irq_remap_table *table = data;
+
+	irq_lookup_table[alias] = table;
+	set_dte_irq_entry(alias, table);
+
+	iommu_flush_dte(amd_iommu_rlookup_table[alias], alias);
+
+	return 0;
+}
+
+static struct irq_remap_table *alloc_irq_table(u16 devid, struct pci_dev *pdev)
 {
 	struct irq_remap_table *table = NULL;
 	struct irq_remap_table *new_table = NULL;
@@ -3787,7 +3800,12 @@ static struct irq_remap_table *alloc_irq_table(u16 devid)
 	table = new_table;
 	new_table = NULL;
 
-	set_remap_table_entry(iommu, devid, table);
+	if (pdev)
+		pci_for_each_dma_alias(pdev, set_remap_table_entry_alias,
+				       table);
+	else
+		set_remap_table_entry(iommu, devid, table);
+
 	if (devid != alias)
 		set_remap_table_entry(iommu, alias, table);
 
@@ -3804,7 +3822,8 @@ out_unlock:
 	return table;
 }
 
-static int alloc_irq_index(u16 devid, int count, bool align)
+static int alloc_irq_index(u16 devid, int count, bool align,
+			   struct pci_dev *pdev)
 {
 	struct irq_remap_table *table;
 	int index, c, alignment = 1;
@@ -3814,7 +3833,7 @@ static int alloc_irq_index(u16 devid, int count, bool align)
 	if (!iommu)
 		return -ENODEV;
 
-	table = alloc_irq_table(devid);
+	table = alloc_irq_table(devid, pdev);
 	if (!table)
 		return -ENODEV;
 
@@ -4247,7 +4266,7 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 		struct irq_remap_table *table;
 		struct amd_iommu *iommu;
 
-		table = alloc_irq_table(devid);
+		table = alloc_irq_table(devid, NULL);
 		if (table) {
 			if (!table->min_index) {
 				/*
@@ -4264,11 +4283,15 @@ static int irq_remapping_alloc(struct irq_domain *domain, unsigned int virq,
 		} else {
 			index = -ENOMEM;
 		}
-	} else {
+	} else if (info->type == X86_IRQ_ALLOC_TYPE_MSI ||
+		   info->type == X86_IRQ_ALLOC_TYPE_MSIX) {
 		bool align = (info->type == X86_IRQ_ALLOC_TYPE_MSI);
 
-		index = alloc_irq_index(devid, nr_irqs, align);
+		index = alloc_irq_index(devid, nr_irqs, align, info->msi_dev);
+	} else {
+		index = alloc_irq_index(devid, nr_irqs, false, NULL);
 	}
+
 	if (index < 0) {
 		pr_warn("Failed to allocate IRTE\n");
 		ret = index;
-- 
2.20.1



