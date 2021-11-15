Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12856451E6C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355133AbhKPAgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344932AbhKOTZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A24A636F6;
        Mon, 15 Nov 2021 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003218;
        bh=mdJrWoohCu+eHCYDtn0pr+fXSS1u75FEgDZMS5nA2Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OG4ia+wp/5OHfFan+BmmwRNGp8jg0+TbtRM5BTEe78uePGLxXAlLi/JJWcHGiqYC3
         ZT3FNqmjEwiVpFxNC9aw7//Pc2nPmExkUI4LGguTN4gkmFd+q+yU0zU9xRFZGJqr4h
         p6EJIvSn9pZRNMXvIUeUmifF94+SbTWP7KViPROk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Johansson <josef@oderland.se>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 5.15 855/917] PCI/MSI: Move non-mask check back into low level accessors
Date:   Mon, 15 Nov 2021 18:05:50 +0100
Message-Id: <20211115165458.019187971@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 9c8e9c9681a0f3f1ae90a90230d059c7a1dece5a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c   |   26 ++++++++++++++------------
 include/linux/msi.h |    2 +-
 kernel/irq/msi.c    |    4 ++--
 3 files changed, 17 insertions(+), 15 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -148,6 +148,9 @@ static noinline void pci_msi_update_mask
 	raw_spinlock_t *lock = &desc->dev->msi_lock;
 	unsigned long flags;
 
+	if (!desc->msi_attrib.can_mask)
+		return;
+
 	raw_spin_lock_irqsave(lock, flags);
 	desc->msi_mask &= ~clear;
 	desc->msi_mask |= set;
@@ -181,7 +184,8 @@ static void pci_msix_write_vector_ctrl(s
 {
 	void __iomem *desc_addr = pci_msix_desc_addr(desc);
 
-	writel(ctrl, desc_addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+	if (desc->msi_attrib.can_mask)
+		writel(ctrl, desc_addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
 
 static inline void pci_msix_mask(struct msi_desc *desc)
@@ -200,23 +204,17 @@ static inline void pci_msix_unmask(struc
 
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
 
@@ -484,7 +482,8 @@ msi_setup_entry(struct pci_dev *dev, int
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
 	entry->msi_attrib.is_virtual    = 0;
 	entry->msi_attrib.entry_nr	= 0;
-	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
+	entry->msi_attrib.can_mask	= !pci_msi_ignore_mask &&
+					  !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
 	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
@@ -495,7 +494,7 @@ msi_setup_entry(struct pci_dev *dev, int
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_32;
 
 	/* Save the initial mask status */
-	if (entry->msi_attrib.maskbit)
+	if (entry->msi_attrib.can_mask)
 		pci_read_config_dword(dev, entry->mask_pos, &entry->msi_mask);
 
 out:
@@ -638,10 +637,13 @@ static int msix_setup_entries(struct pci
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
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -529,10 +529,10 @@ static bool msi_check_reservation_mode(s
 
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


