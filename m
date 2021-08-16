Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EF33ED502
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhHPNHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237803AbhHPNGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397F0632AA;
        Mon, 16 Aug 2021 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119137;
        bh=xOVhp/NDLSf2S7OS/VumBtohqodqe5ncxW6D0p/M8B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4HDywF4LI1ca3ThXeOcAWbrCM3Pa5ilXOLb/J6GVhI6Xqp9Oz1Bfb1crdpDNojtM
         t/fut9AMoF+5xDoIdlW7BXGu3NZb93FjHcCCbfs0IZVQ2uhPbmIu3Bzh67TLDtxfA2
         Jzogpkd+aT/Lgi2tbVLG04AjtPhAgcrg1+UNjN1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 56/62] PCI/MSI: Protect msi_desc::masked for multi-MSI
Date:   Mon, 16 Aug 2021 15:02:28 +0200
Message-Id: <20210816125430.129726785@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/base/core.c    |    1 +
 drivers/pci/msi.c      |   19 ++++++++++---------
 include/linux/device.h |    1 +
 include/linux/msi.h    |    2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1722,6 +1722,7 @@ void device_initialize(struct device *de
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spin_lock_init(&dev->msi_lock);
 	INIT_LIST_HEAD(&dev->msi_list);
 #endif
 	INIT_LIST_HEAD(&dev->links.consumers);
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -170,24 +170,25 @@ static inline __attribute_const__ u32 ms
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
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1260,6 +1260,7 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 #ifdef CONFIG_GENERIC_MSI_IRQ
+	raw_spinlock_t		msi_lock;
 	struct list_head	msi_list;
 #endif
 
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -194,7 +194,7 @@ void __pci_read_msi_msg(struct msi_desc
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
 u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-u32 __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 


