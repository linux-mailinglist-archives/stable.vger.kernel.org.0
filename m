Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0943F671A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbhHXRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240729AbhHXR2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439A261B67;
        Tue, 24 Aug 2021 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824722;
        bh=8dBB6G1ZWdciXvvQEXhWalJ65WApTFS2mtegZ3nqsgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ccl4eChdjEDFW8wWuVK7dLIkOwgJgEzNRQZEajRbgxNNLW07x1WyF6EfCiBbyXBlj
         1iybDPCV9tMkoTky/Nr+DLA9/jD0AXPrUkk1FLLWgQWZrniM53NNVXj5yxpnG2ZDGP
         v0KCK+YWLXZ/P/s0jxxLncNK3PZ0k1sw+niG47NMMqyS2OFy3crr4HptcktmCz9eXl
         DXD55eRe0nzmRqsDs2s5OTBHS5S+OZMY1qz4ImvWuhuPAt3JQnOQpYUcXavdMcEhSc
         jAbgEvq89ph+BbxMalklQfcnmTEbgJYCwE8GBsa27VRFPglE5TJihKGaWTZW4+v1n2
         pAYdk3gvBg7vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 25/64] PCI/MSI: Protect msi_desc::masked for multi-MSI
Date:   Tue, 24 Aug 2021 13:04:18 -0400
Message-Id: <20210824170457.710623-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 77e89afc25f30abd56e76a809ee2884d7c1b63ce upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c    |  1 +
 drivers/pci/msi.c      | 19 ++++++++++---------
 include/linux/device.h |  1 +
 include/linux/msi.h    |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 92415a748ad2..e834087448a4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1445,6 +1445,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spin_lock_init(&dev->msi_lock);
 	INIT_LIST_HEAD(&dev->msi_list);
 #endif
 	INIT_LIST_HEAD(&dev->links.consumers);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 034f60b75a6e..ecf15f0ea295 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -170,24 +170,25 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
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
index 0b2e67014a83..fab5798a47fd 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -917,6 +917,7 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spinlock_t		msi_lock;
 	struct list_head	msi_list;
 #endif
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index a89cdea8795a..3440ec051ebb 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -144,7 +144,7 @@ void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
 u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 
-- 
2.30.2

