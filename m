Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0DC3E563C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhHJJII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41876 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238595AbhHJJIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:07 -0400
Date:   Tue, 10 Aug 2021 09:07:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586464;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8RPG2lJEC0pdGgdAbVE7D0T8O25y/ng0joQTgQaQ/4=;
        b=4xvD6/xzhCzpZuF4VPSlO7l+tMSX3a1lTVPSbDWlSIa6MDMXg9QMFkKmihMo/Ns0v5QDIN
        sukvUhOgempIhnuQBSS6BSJ84gO1appYiPtdCD7+lVYojn10AVZ2KyTWR/CAv8/SU8ESeG
        uXH9xqgWa6dx+I8StNerzSaM4ZGU9p2wsIAEy84QFO42Ys22CAjbK5P/PowT1CHsZub5mg
        qa6kTFl9ym6dzAbWG4gs2PxKuvnd800AF6oPZ9ItHlnU4qzHXjrj7SGORK0QAWfDukphQl
        4UVpVQfXrJUMaIC0OefthPEuW2xFRRYroOrpShXVCMXhdEdlgT8o8bnxS9zv7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586464;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8RPG2lJEC0pdGgdAbVE7D0T8O25y/ng0joQTgQaQ/4=;
        b=LZ0ltrTYU4zouMjJR4+/iDH24UH/dKNCktxlKq1xIBt8Yoaq5OW4FwGan9Aax/mg6Bg2Yi
        hleawlIRXUVr3SDA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Protect msi_desc::masked for multi-MSI
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.726833414@linutronix.de>
References: <20210729222542.726833414@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646392.395.7473987007081892890.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     77e89afc25f30abd56e76a809ee2884d7c1b63ce
Gitweb:        https://git.kernel.org/tip/77e89afc25f30abd56e76a809ee2884d7c1b63ce
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:47 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Protect msi_desc::masked for multi-MSI

Multi-MSI uses a single MSI descriptor and there is a single mask register
when the device supports per vector masking. To avoid reading back the mask
register the value is cached in the MSI descriptor and updates are done by
clearing and setting bits in the cache and writing it to the device.

But nothing protects msi_desc::masked and the mask register from being
modified concurrently on two different CPUs for two different Linux
interrupts which belong to the same multi-MSI descriptor.

Add a lock to struct device and protect any operation on the mask and the
mask register with it.

This makes the update of msi_desc::masked unconditional, but there is no
place which requires a modification of the hardware register without
updating the masked cache.

msi_mask_irq() is now an empty wrapper which will be cleaned up in follow
up changes.

The problem goes way back to the initial support of multi-MSI, but picking
the commit which introduced the mask cache is a valid cut off point
(2.6.30).

Fixes: f2440d9acbe8 ("PCI MSI: Refactor interrupt masking code")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.726833414@linutronix.de

---
 drivers/base/core.c    |  1 +
 drivers/pci/msi.c      | 19 ++++++++++---------
 include/linux/device.h |  1 +
 include/linux/msi.h    |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f636049..6c0ef9d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2837,6 +2837,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spin_lock_init(&dev->msi_lock);
 	INIT_LIST_HEAD(&dev->msi_list);
 #endif
 	INIT_LIST_HEAD(&dev->links.consumers);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f0f7026..e5e7533 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -143,24 +143,25 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	u32 mask_bits = desc->masked;
+	raw_spinlock_t *lock = &desc->dev->msi_lock;
+	unsigned long flags;
 
 	if (pci_msi_ignore_mask || !desc->msi_attrib.maskbit)
-		return 0;
+		return;
 
-	mask_bits &= ~mask;
-	mask_bits |= flag;
+	raw_spin_lock_irqsave(lock, flags);
+	desc->masked &= ~mask;
+	desc->masked |= flag;
 	pci_write_config_dword(msi_desc_to_pci_dev(desc), desc->mask_pos,
-			       mask_bits);
-
-	return mask_bits;
+			       desc->masked);
+	raw_spin_unlock_irqrestore(lock, flags);
 }
 
 static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	desc->masked = __pci_msi_desc_mask_irq(desc, mask, flag);
+	__pci_msi_desc_mask_irq(desc, mask, flag);
 }
 
 static void __iomem *pci_msix_desc_addr(struct msi_desc *desc)
diff --git a/include/linux/device.h b/include/linux/device.h
index 59940f1..e53aa50 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -506,6 +506,7 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spinlock_t		msi_lock;
 	struct list_head	msi_list;
 #endif
 #ifdef CONFIG_DMA_OPS
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6aff469..e8bdcb8 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -233,7 +233,7 @@ void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
 u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 
