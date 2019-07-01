Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0139D82
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfFHLlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbfFHLlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:41:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0B86214AF;
        Sat,  8 Jun 2019 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994081;
        bh=kpwtncCienadC4RcdW6GwxkoRXyld5yuUZOnCwHAaOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXkUVwrdOizCeetP+UgLwYyPSpbXrJTccNL6RTU4cf/YJnQPQ4js+LOSDZzGdh4Yt
         4imK3jGSLJz6aL2t2r/3SPqN4rMT5tsl8lBr5ifEk7m1MNx/XIsRlx7yLOg1UQ7bSz
         pvrO6NVyPJY33qQMf/6eC0JOGdBhJ6q5/zaN2YYc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 52/70] KVM: PPC: Book3S HV: Use new mutex to synchronize MMU setup
Date:   Sat,  8 Jun 2019 07:39:31 -0400
Message-Id: <20190608113950.8033-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

[ Upstream commit 0d4ee88d92884c661fcafd5576da243aa943dc24 ]

Currently the HV KVM code uses kvm->lock in conjunction with a flag,
kvm->arch.mmu_ready, to synchronize MMU setup and hold off vcpu
execution until the MMU-related data structures are ready.  However,
this means that kvm->lock is being taken inside vcpu->mutex, which
is contrary to Documentation/virtual/kvm/locking.txt and results in
lockdep warnings.

To fix this, we add a new mutex, kvm->arch.mmu_setup_lock, which nests
inside the vcpu mutexes, and is taken in the places where kvm->lock
was taken that are related to MMU setup.

Additionally we take the new mutex in the vcpu creation code at the
point where we are creating a new vcore, in order to provide mutual
exclusion with kvmppc_update_lpcr() and ensure that an update to
kvm->arch.lpcr doesn't get missed, which could otherwise lead to a
stale vcore->lpcr value.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 36 ++++++++++++++---------------
 arch/powerpc/kvm/book3s_hv.c        | 31 ++++++++++++++++++-------
 3 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index e6b5bb012ccb..8d3658275a34 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -317,6 +317,7 @@ struct kvm_arch {
 #endif
 	struct kvmppc_ops *kvm_ops;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	struct mutex mmu_setup_lock;	/* nests inside vcpu mutexes */
 	u64 l1_ptcr;
 	int max_nested_lpid;
 	struct kvm_nested_guest *nested_guests[KVM_MAX_NESTED_GUESTS];
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index be7bc070eae5..c1ced22455f9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -63,7 +63,7 @@ struct kvm_resize_hpt {
 	struct work_struct work;
 	u32 order;
 
-	/* These fields protected by kvm->lock */
+	/* These fields protected by kvm->arch.mmu_setup_lock */
 
 	/* Possible values and their usage:
 	 *  <0     an error occurred during allocation,
@@ -73,7 +73,7 @@ struct kvm_resize_hpt {
 	int error;
 
 	/* Private to the work thread, until error != -EBUSY,
-	 * then protected by kvm->lock.
+	 * then protected by kvm->arch.mmu_setup_lock.
 	 */
 	struct kvm_hpt_info hpt;
 };
@@ -139,7 +139,7 @@ long kvmppc_alloc_reset_hpt(struct kvm *kvm, int order)
 	long err = -EBUSY;
 	struct kvm_hpt_info info;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (kvm->arch.mmu_ready) {
 		kvm->arch.mmu_ready = 0;
 		/* order mmu_ready vs. vcpus_running */
@@ -183,7 +183,7 @@ out:
 		/* Ensure that each vcpu will flush its TLB on next entry. */
 		cpumask_setall(&kvm->arch.need_tlb_flush);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return err;
 }
 
@@ -1447,7 +1447,7 @@ static void resize_hpt_pivot(struct kvm_resize_hpt *resize)
 
 static void resize_hpt_release(struct kvm *kvm, struct kvm_resize_hpt *resize)
 {
-	if (WARN_ON(!mutex_is_locked(&kvm->lock)))
+	if (WARN_ON(!mutex_is_locked(&kvm->arch.mmu_setup_lock)))
 		return;
 
 	if (!resize)
@@ -1474,14 +1474,14 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 	if (WARN_ON(resize->error != -EBUSY))
 		return;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	/* Request is still current? */
 	if (kvm->arch.resize_hpt == resize) {
 		/* We may request large allocations here:
-		 * do not sleep with kvm->lock held for a while.
+		 * do not sleep with kvm->arch.mmu_setup_lock held for a while.
 		 */
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.mmu_setup_lock);
 
 		resize_hpt_debug(resize, "resize_hpt_prepare_work(): order = %d\n",
 				 resize->order);
@@ -1494,9 +1494,9 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 		if (WARN_ON(err == -EBUSY))
 			err = -EINPROGRESS;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.mmu_setup_lock);
 		/* It is possible that kvm->arch.resize_hpt != resize
-		 * after we grab kvm->lock again.
+		 * after we grab kvm->arch.mmu_setup_lock again.
 		 */
 	}
 
@@ -1505,7 +1505,7 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 	if (kvm->arch.resize_hpt != resize)
 		resize_hpt_release(kvm, resize);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 }
 
 long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
@@ -1522,7 +1522,7 @@ long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
 	if (shift && ((shift < 18) || (shift > 46)))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	resize = kvm->arch.resize_hpt;
 
@@ -1565,7 +1565,7 @@ long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
 	ret = 100; /* estimated time in ms */
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return ret;
 }
 
@@ -1588,7 +1588,7 @@ long kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
 	if (shift && ((shift < 18) || (shift > 46)))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	resize = kvm->arch.resize_hpt;
 
@@ -1625,7 +1625,7 @@ out:
 	smp_mb();
 out_no_hpt:
 	resize_hpt_release(kvm, resize);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return ret;
 }
 
@@ -1868,7 +1868,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 		return -EINVAL;
 
 	/* lock out vcpus from running while we're doing this */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	mmu_ready = kvm->arch.mmu_ready;
 	if (mmu_ready) {
 		kvm->arch.mmu_ready = 0;	/* temporarily */
@@ -1876,7 +1876,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 		smp_mb();
 		if (atomic_read(&kvm->arch.vcpus_running)) {
 			kvm->arch.mmu_ready = 1;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.mmu_setup_lock);
 			return -EBUSY;
 		}
 	}
@@ -1963,7 +1963,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 	/* Order HPTE updates vs. mmu_ready */
 	smp_wmb();
 	kvm->arch.mmu_ready = mmu_ready;
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 
 	if (err)
 		return err;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b2b29d4f9842..4519c55ba19d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2257,11 +2257,17 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 			pr_devel("KVM: collision on id %u", id);
 			vcore = NULL;
 		} else if (!vcore) {
+			/*
+			 * Take mmu_setup_lock for mutual exclusion
+			 * with kvmppc_update_lpcr().
+			 */
 			err = -ENOMEM;
 			vcore = kvmppc_vcore_create(kvm,
 					id & ~(kvm->arch.smt_mode - 1));
+			mutex_lock(&kvm->arch.mmu_setup_lock);
 			kvm->arch.vcores[core] = vcore;
 			kvm->arch.online_vcores++;
+			mutex_unlock(&kvm->arch.mmu_setup_lock);
 		}
 	}
 	mutex_unlock(&kvm->lock);
@@ -3820,7 +3826,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 	int r = 0;
 	struct kvm *kvm = vcpu->kvm;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (!kvm->arch.mmu_ready) {
 		if (!kvm_is_radix(kvm))
 			r = kvmppc_hv_setup_htab_rma(vcpu);
@@ -3830,7 +3836,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 			kvm->arch.mmu_ready = 1;
 		}
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return r;
 }
 
@@ -4435,7 +4441,8 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 
 /*
  * Update LPCR values in kvm->arch and in vcores.
- * Caller must hold kvm->lock.
+ * Caller must hold kvm->arch.mmu_setup_lock (for mutual exclusion
+ * of kvm->arch.lpcr update).
  */
 void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned long mask)
 {
@@ -4487,7 +4494,7 @@ void kvmppc_setup_partition_table(struct kvm *kvm)
 
 /*
  * Set up HPT (hashed page table) and RMA (real-mode area).
- * Must be called with kvm->lock held.
+ * Must be called with kvm->arch.mmu_setup_lock held.
  */
 static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 {
@@ -4575,7 +4582,10 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 	goto out_srcu;
 }
 
-/* Must be called with kvm->lock held and mmu_ready = 0 and no vcpus running */
+/*
+ * Must be called with kvm->arch.mmu_setup_lock held and
+ * mmu_ready = 0 and no vcpus running.
+ */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
 	if (nesting_enabled(kvm))
@@ -4592,7 +4602,10 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	return 0;
 }
 
-/* Must be called with kvm->lock held and mmu_ready = 0 and no vcpus running */
+/*
+ * Must be called with kvm->arch.mmu_setup_lock held and
+ * mmu_ready = 0 and no vcpus running.
+ */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
 	int err;
@@ -4697,6 +4710,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 	char buf[32];
 	int ret;
 
+	mutex_init(&kvm->arch.mmu_setup_lock);
+
 	/* Allocate the guest's logical partition ID */
 
 	lpid = kvmppc_alloc_lpid();
@@ -5222,7 +5237,7 @@ static int kvmhv_configure_mmu(struct kvm *kvm, struct kvm_ppc_mmuv3_cfg *cfg)
 	if (kvmhv_on_pseries() && !radix)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (radix != kvm_is_radix(kvm)) {
 		if (kvm->arch.mmu_ready) {
 			kvm->arch.mmu_ready = 0;
@@ -5250,7 +5265,7 @@ static int kvmhv_configure_mmu(struct kvm *kvm, struct kvm_ppc_mmuv3_cfg *cfg)
 	err = 0;
 
  out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return err;
 }
 
-- 
2.20.1

