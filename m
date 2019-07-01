Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C17B11EFB
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfEBP0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfEBP0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EDD120675;
        Thu,  2 May 2019 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810776;
        bh=4XYGcUokyF/6Pgm2GV1BUbhc/l96az6bJgTZCvYWcMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB2Trh0+CdEFOjhuA4i9VB3Cr4Xg3kcurJcOkItXv4qyxSip3P7dZ8PaskUlQLZav
         GHyK8kiNWpp7A4tf70yQ8Phx4UVowX6CL5OCYPh9mQqekERGM4CRuKM/AihFbEp3q3
         Oi7wtCsljOCTwpqKkUTZL4kUNgRc2aq1DpUBMX44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 25/72] KVM: arm/arm64: vgic-its: Take the srcu lock when writing to guest memory
Date:   Thu,  2 May 2019 17:20:47 +0200
Message-Id: <20190502143335.415332123@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6ecfb11bf37743c1ac49b266595582b107b61d4 ]

When halting a guest, QEMU flushes the virtual ITS caches, which
amounts to writing to the various tables that the guest has allocated.

When doing this, we fail to take the srcu lock, and the kernel
shouts loudly if running a lockdep kernel:

[   69.680416] =============================
[   69.680819] WARNING: suspicious RCU usage
[   69.681526] 5.1.0-rc1-00008-g600025238f51-dirty #18 Not tainted
[   69.682096] -----------------------------
[   69.682501] ./include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!
[   69.683225]
[   69.683225] other info that might help us debug this:
[   69.683225]
[   69.683975]
[   69.683975] rcu_scheduler_active = 2, debug_locks = 1
[   69.684598] 6 locks held by qemu-system-aar/4097:
[   69.685059]  #0: 0000000034196013 (&kvm->lock){+.+.}, at: vgic_its_set_attr+0x244/0x3a0
[   69.686087]  #1: 00000000f2ed935e (&its->its_lock){+.+.}, at: vgic_its_set_attr+0x250/0x3a0
[   69.686919]  #2: 000000005e71ea54 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[   69.687698]  #3: 00000000c17e548d (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[   69.688475]  #4: 00000000ba386017 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[   69.689978]  #5: 00000000c2c3c335 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[   69.690729]
[   69.690729] stack backtrace:
[   69.691151] CPU: 2 PID: 4097 Comm: qemu-system-aar Not tainted 5.1.0-rc1-00008-g600025238f51-dirty #18
[   69.691984] Hardware name: rockchip evb_rk3399/evb_rk3399, BIOS 2019.04-rc3-00124-g2feec69fb1 03/15/2019
[   69.692831] Call trace:
[   69.694072]  lockdep_rcu_suspicious+0xcc/0x110
[   69.694490]  gfn_to_memslot+0x174/0x190
[   69.694853]  kvm_write_guest+0x50/0xb0
[   69.695209]  vgic_its_save_tables_v0+0x248/0x330
[   69.695639]  vgic_its_set_attr+0x298/0x3a0
[   69.696024]  kvm_device_ioctl_attr+0x9c/0xd8
[   69.696424]  kvm_device_ioctl+0x8c/0xf8
[   69.696788]  do_vfs_ioctl+0xc8/0x960
[   69.697128]  ksys_ioctl+0x8c/0xa0
[   69.697445]  __arm64_sys_ioctl+0x28/0x38
[   69.697817]  el0_svc_common+0xd8/0x138
[   69.698173]  el0_svc_handler+0x38/0x78
[   69.698528]  el0_svc+0x8/0xc

The fix is to obviously take the srcu lock, just like we do on the
read side of things since bf308242ab98. One wonders why this wasn't
fixed at the same time, but hey...

Fixes: bf308242ab98 ("KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/include/asm/kvm_mmu.h   | 11 +++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-its.c     |  8 ++++----
 virt/kvm/arm/vgic/vgic-v3.c      |  4 ++--
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 265ea9cf7df7..523c499e42db 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -317,6 +317,17 @@ static inline int kvm_read_guest_lock(struct kvm *kvm,
 	return ret;
 }
 
+static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
+				       const void *data, unsigned long len)
+{
+	int srcu_idx = srcu_read_lock(&kvm->srcu);
+	int ret = kvm_write_guest(kvm, gpa, data, len);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return ret;
+}
+
 static inline void *kvm_get_hyp_vector(void)
 {
 	switch(read_cpuid_part()) {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d6fff7de5539..b2558447c67d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -394,6 +394,17 @@ static inline int kvm_read_guest_lock(struct kvm *kvm,
 	return ret;
 }
 
+static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
+				       const void *data, unsigned long len)
+{
+	int srcu_idx = srcu_read_lock(&kvm->srcu);
+	int ret = kvm_write_guest(kvm, gpa, data, len);
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+
+	return ret;
+}
+
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 /*
  * EL2 vectors can be mapped and rerouted in a number of ways,
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f376c82afb61..c1071ed888e2 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1935,7 +1935,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return kvm_write_guest(kvm, gpa, &val, ite_esz);
+	return kvm_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
 /**
@@ -2082,7 +2082,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return kvm_write_guest(kvm, ptr, &val, dte_esz);
+	return kvm_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
 /**
@@ -2262,7 +2262,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return kvm_write_guest(its->dev->kvm, gpa, &val, esz);
+	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
 static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
@@ -2333,7 +2333,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 */
 	val = 0;
 	BUG_ON(cte_esz > sizeof(val));
-	ret = kvm_write_guest(its->dev->kvm, gpa, &val, cte_esz);
+	ret = kvm_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9c0dd234ebe8..3f2350a4d4ab 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -358,7 +358,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	if (status) {
 		/* clear consumed data */
 		val &= ~(1 << bit_nr);
-		ret = kvm_write_guest(kvm, ptr, &val, 1);
+		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
 		if (ret)
 			return ret;
 	}
@@ -409,7 +409,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		else
 			val &= ~(1 << bit_nr);
 
-		ret = kvm_write_guest(kvm, ptr, &val, 1);
+		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
 		if (ret)
 			return ret;
 	}
-- 
2.19.1



