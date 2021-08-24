Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA3D3F680B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhHXRkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242244AbhHXRhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C355461BF4;
        Tue, 24 Aug 2021 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824874;
        bh=CxL4seaQPq+aQ8H0R+cHUBfV2Q6lhuouE3GD6ILzpE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swuwX7DWqRrYXe7PDLDVZuj3jthbVVHn74ZJFo19trIzbHwRq9NcsRazLAlRwu5io
         3fu6+3aOGysT4lROMkG20Qr9o/9ICIHj493CU6HSzzkY9k4gKFGH0X/wF/zYkYXxnG
         FYLmeUpaUVth66wDj1706J4NaYiOirw1cosTEA+ngAioniWCHPTsk9HyJuiPMb9vYD
         Cytb6EnNGhgC3xERpUd8StgBzZS3YHNdw8a/UxPK0ynh7cwepGr2ArnctnpJXQMxl9
         bNCfv+mPq5bPQt3EaEVrCUcYQF/Se17JPy6fUgtA0yrwRMbtFq3xoxvMBaYPp4YJOF
         u8vHY5WZDlwmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 10/31] PCI/MSI: Protect msi_desc::masked for multi-MSI
Date:   Tue, 24 Aug 2021 13:07:22 -0400
Message-Id: <20210824170743.710957-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index 7e419aaf3c24..23517100c9a5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -710,6 +710,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spin_lock_init(&dev->msi_lock);
 	INIT_LIST_HEAD(&dev->msi_list);
 #endif
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e3865e274389..dffa5c5bcc76 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -187,24 +187,25 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
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
 
 /*
diff --git a/include/linux/device.h b/include/linux/device.h
index eb891c9c4b62..df0199e768d4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -794,6 +794,7 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spinlock_t		msi_lock;
 	struct list_head	msi_list;
 #endif
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index d0d50cf00b4d..037f47fe76e6 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -128,7 +128,7 @@ void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
 u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 
-- 
2.30.2

