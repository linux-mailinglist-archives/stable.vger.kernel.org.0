Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E344D39C
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 09:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhKKJAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 04:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhKKJAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 04:00:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD7AC061767;
        Thu, 11 Nov 2021 00:57:51 -0800 (PST)
Date:   Thu, 11 Nov 2021 08:57:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636621069;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=DB/6RgQ/PZizcqcCryGHpNqX5euRa/sbj4pJCAFPBsc=;
        b=MzgT7Ol9MzuFhvso8ccr6eQFnIAwlWWF2LHomn2aCjslMc3nrI/RQy7HDq1FLqb4Z4r6b8
        vOmqeu8flsl9kChLoy6DMDL431isKylQ4KTxtwIrl/K4BCo3yTdHkGWa8YzBaDhjlUsa8J
        SlL3xHTOijvyS1XusZ7OjpJMVR6GZcwgp2u0ZAMNv5JpvMKZaR0fV5ygINqrSteGDu/fBO
        aOlgIDldAviLCODsNGpkDIVfhnzgT0Piwaxh/xsdPJ1CeRTYk4lR+S/9Jy9IZx8d2yNlxn
        nXv/X3R/JTphyp27E6rWVbvuiJKdTPk46WXJXqjY9uzRP5vnWVfDkgem8X0tJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636621069;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=DB/6RgQ/PZizcqcCryGHpNqX5euRa/sbj4pJCAFPBsc=;
        b=gPsN0m4hsP3OKBqkOfnm/aa1w7QpdbYM1Iwr1gE76qyI1E8KvZCdcGuKTc2VQ9OT78DE47
        G6ENsoqsQFiTN8Cw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Move non-mask check back into low level accessors
Cc:     Josef Johansson <josef@oderland.se>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
MIME-Version: 1.0
Message-ID: <163662106897.414.14667708131641356919.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     9c8e9c9681a0f3f1ae90a90230d059c7a1dece5a
Gitweb:        https://git.kernel.org/tip/9c8e9c9681a0f3f1ae90a90230d059c7a1dece5a
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 04 Nov 2021 00:27:29 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 11 Nov 2021 09:50:30 +01:00

PCI/MSI: Move non-mask check back into low level accessors

The recent rework of PCI/MSI[X] masking moved the non-mask checks from the
low level accessors into the higher level mask/unmask functions.

This missed the fact that these accessors can be invoked from other places
as well. The missing checks break XEN-PV which sets pci_msi_ignore_mask and
also violates the virtual MSIX and the msi_attrib.maskbit protections.

Instead of sprinkling checks all over the place, lift them back into the
low level accessor functions. To avoid checking three different conditions
combine them into one property of msi_desc::msi_attrib.

[ josef: Fixed the missed conversion in the core code ]

Fixes: fcacdfbef5a1 ("PCI/MSI: Provide a new set of mask and unmask functions")
Reported-by: Josef Johansson <josef@oderland.se>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Josef Johansson <josef@oderland.se>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/pci/msi.c   | 26 ++++++++++++++------------
 include/linux/msi.h |  2 +-
 kernel/irq/msi.c    |  4 ++--
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 12e296d..6da7910 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -148,6 +148,9 @@ static noinline void pci_msi_update_mask(struct msi_desc *desc, u32 clear, u32 s
 	raw_spinlock_t *lock = &desc->dev->msi_lock;
 	unsigned long flags;
 
+	if (!desc->msi_attrib.can_mask)
+		return;
+
 	raw_spin_lock_irqsave(lock, flags);
 	desc->msi_mask &= ~clear;
 	desc->msi_mask |= set;
@@ -181,7 +184,8 @@ static void pci_msix_write_vector_ctrl(struct msi_desc *desc, u32 ctrl)
 {
 	void __iomem *desc_addr = pci_msix_desc_addr(desc);
 
-	writel(ctrl, desc_addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+	if (desc->msi_attrib.can_mask)
+		writel(ctrl, desc_addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
 
 static inline void pci_msix_mask(struct msi_desc *desc)
@@ -200,23 +204,17 @@ static inline void pci_msix_unmask(struct msi_desc *desc)
 
 static void __pci_msi_mask_desc(struct msi_desc *desc, u32 mask)
 {
-	if (pci_msi_ignore_mask || desc->msi_attrib.is_virtual)
-		return;
-
 	if (desc->msi_attrib.is_msix)
 		pci_msix_mask(desc);
-	else if (desc->msi_attrib.maskbit)
+	else
 		pci_msi_mask(desc, mask);
 }
 
 static void __pci_msi_unmask_desc(struct msi_desc *desc, u32 mask)
 {
-	if (pci_msi_ignore_mask || desc->msi_attrib.is_virtual)
-		return;
-
 	if (desc->msi_attrib.is_msix)
 		pci_msix_unmask(desc);
-	else if (desc->msi_attrib.maskbit)
+	else
 		pci_msi_unmask(desc, mask);
 }
 
@@ -484,7 +482,8 @@ msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
 	entry->msi_attrib.is_virtual    = 0;
 	entry->msi_attrib.entry_nr	= 0;
-	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
+	entry->msi_attrib.can_mask	= !pci_msi_ignore_mask &&
+					  !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
 	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
@@ -495,7 +494,7 @@ msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_32;
 
 	/* Save the initial mask status */
-	if (entry->msi_attrib.maskbit)
+	if (entry->msi_attrib.can_mask)
 		pci_read_config_dword(dev, entry->mask_pos, &entry->msi_mask);
 
 out:
@@ -639,10 +638,13 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.is_virtual =
 			entry->msi_attrib.entry_nr >= vec_count;
 
+		entry->msi_attrib.can_mask	= !pci_msi_ignore_mask &&
+						  !entry->msi_attrib.is_virtual;
+
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
-		if (!entry->msi_attrib.is_virtual) {
+		if (entry->msi_attrib.can_mask) {
 			addr = pci_msix_desc_addr(entry);
 			entry->msix_ctrl = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 		}
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 49cf6eb..e616f94 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -148,7 +148,7 @@ struct msi_desc {
 				u8	is_msix		: 1;
 				u8	multiple	: 3;
 				u8	multi_cap	: 3;
-				u8	maskbit		: 1;
+				u8	can_mask	: 1;
 				u8	is_64		: 1;
 				u8	is_virtual	: 1;
 				u16	entry_nr;
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 6a5ecee..7f350ae 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -529,10 +529,10 @@ static bool msi_check_reservation_mode(struct irq_domain *domain,
 
 	/*
 	 * Checking the first MSI descriptor is sufficient. MSIX supports
-	 * masking and MSI does so when the maskbit is set.
+	 * masking and MSI does so when the can_mask attribute is set.
 	 */
 	desc = first_msi_entry(dev);
-	return desc->msi_attrib.is_msix || desc->msi_attrib.maskbit;
+	return desc->msi_attrib.is_msix || desc->msi_attrib.can_mask;
 }
 
 int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
