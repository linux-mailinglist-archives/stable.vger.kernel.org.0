Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528F4FD642
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfKOGXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:23:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfKOGW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:59 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43BE92075E;
        Fri, 15 Nov 2019 06:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798977;
        bh=+53pkdTiCtyd61JemDLRgWS5rw+0DoDosOZxlDJ0d00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoXyLLl+yrnv8snA7mVKgH0/2OtReuuh93/zfyWzjdKr6rJ62IJma0/wVxruDfN21
         Ea8tWDOr6WlsLBK/Ml04jsY1NM8uVqte9HhQS3O4v9+zf11DRXChsz4HpLfjpCsww4
         Tt+3ZH+Fcivd2dF+1D9tl32MYg/wCZV321C47a7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 30/31] kvm: x86: mmu: Recovery of shattered NX large pages
Date:   Fri, 15 Nov 2019 14:20:59 +0800
Message-Id: <20191115062020.185221469@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

commit 1aa9b9572b10529c2e64e2b8f44025d86e124308 upstream.

The page table pages corresponding to broken down large pages are zapped in
FIFO order, so that the large page can potentially be recovered, if it is
not longer being used for execution.  This removes the performance penalty
for walking deeper EPT page tables.

By default, one large page will last about one hour once the guest
reaches a steady state.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.9:
 - Update another error path in kvm_create_vm() to use out_err_no_mmu_notifier
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    6 +
 arch/x86/include/asm/kvm_host.h     |    4 +
 arch/x86/kvm/mmu.c                  |  129 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h                  |    4 +
 arch/x86/kvm/x86.c                  |   11 +++
 virt/kvm/kvm_main.c                 |   30 ++++++++
 6 files changed, 183 insertions(+), 1 deletion(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1988,6 +1988,12 @@ bytes respectively. Such letter suffixes
 			If the software workaround is enabled for the host,
 			guests do need not to enable it for nested guests.
 
+	kvm.nx_huge_pages_recovery_ratio=
+			[KVM] Controls how many 4KiB pages are periodically zapped
+			back to huge pages.  0 disables the recovery, otherwise if
+			the value is N KVM will zap 1/Nth of the 4KiB pages every
+			minute.  The default is 60.
+
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
 
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,6 +261,7 @@ struct kvm_rmap_head {
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
+	struct list_head lpage_disallowed_link;
 
 	/*
 	 * The following two entries are used to key the shadow page in the
@@ -725,6 +726,7 @@ struct kvm_arch {
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
+	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 
@@ -799,6 +801,8 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+
+	struct task_struct *nx_lpage_recovery_thread;
 };
 
 struct kvm_vm_stat {
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -37,6 +37,7 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -47,16 +48,26 @@
 extern bool itlb_multihit_kvm_mitigation;
 
 static int __read_mostly nx_huge_pages = -1;
+static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
+static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
 
 static struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
 	.get = param_get_bool,
 };
 
+static struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
+	.set = set_nx_huge_pages_recovery_ratio,
+	.get = param_get_uint,
+};
+
 module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
 __MODULE_PARM_TYPE(nx_huge_pages, "bool");
+module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
+		&nx_huge_pages_recovery_ratio, 0644);
+__MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
 
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
@@ -880,6 +891,8 @@ static void account_huge_nx_page(struct
 		return;
 
 	++kvm->stat.nx_lpage_splits;
+	list_add_tail(&sp->lpage_disallowed_link,
+		      &kvm->arch.lpage_disallowed_mmu_pages);
 	sp->lpage_disallowed = true;
 }
 
@@ -904,6 +917,7 @@ static void unaccount_huge_nx_page(struc
 {
 	--kvm->stat.nx_lpage_splits;
 	sp->lpage_disallowed = false;
+	list_del(&sp->lpage_disallowed_link);
 }
 
 static bool __mmu_gfn_lpage_is_disallowed(gfn_t gfn, int level,
@@ -5172,6 +5186,8 @@ static int set_nx_huge_pages(const char
 			idx = srcu_read_lock(&kvm->srcu);
 			kvm_mmu_invalidate_zap_all_pages(kvm);
 			srcu_read_unlock(&kvm->srcu, idx);
+
+			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -5247,3 +5263,116 @@ void kvm_mmu_module_exit(void)
 	unregister_shrinker(&mmu_shrinker);
 	mmu_audit_disable();
 }
+
+static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
+{
+	unsigned int old_val;
+	int err;
+
+	old_val = nx_huge_pages_recovery_ratio;
+	err = param_set_uint(val, kp);
+	if (err)
+		return err;
+
+	if (READ_ONCE(nx_huge_pages) &&
+	    !old_val && nx_huge_pages_recovery_ratio) {
+		struct kvm *kvm;
+
+		mutex_lock(&kvm_lock);
+
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+
+		mutex_unlock(&kvm_lock);
+	}
+
+	return err;
+}
+
+static void kvm_recover_nx_lpages(struct kvm *kvm)
+{
+	int rcu_idx;
+	struct kvm_mmu_page *sp;
+	unsigned int ratio;
+	LIST_HEAD(invalid_list);
+	ulong to_zap;
+
+	rcu_idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
+	while (to_zap && !list_empty(&kvm->arch.lpage_disallowed_mmu_pages)) {
+		/*
+		 * We use a separate list instead of just using active_mmu_pages
+		 * because the number of lpage_disallowed pages is expected to
+		 * be relatively small compared to the total.
+		 */
+		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
+				      struct kvm_mmu_page,
+				      lpage_disallowed_link);
+		WARN_ON_ONCE(!sp->lpage_disallowed);
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		WARN_ON_ONCE(sp->lpage_disallowed);
+
+		if (!--to_zap || need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			if (to_zap)
+				cond_resched_lock(&kvm->mmu_lock);
+		}
+	}
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, rcu_idx);
+}
+
+static long get_nx_lpage_recovery_timeout(u64 start_time)
+{
+	return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
+		? start_time + 60 * HZ - get_jiffies_64()
+		: MAX_SCHEDULE_TIMEOUT;
+}
+
+static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
+{
+	u64 start_time;
+	long remaining_time;
+
+	while (true) {
+		start_time = get_jiffies_64();
+		remaining_time = get_nx_lpage_recovery_timeout(start_time);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		while (!kthread_should_stop() && remaining_time > 0) {
+			schedule_timeout(remaining_time);
+			remaining_time = get_nx_lpage_recovery_timeout(start_time);
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+
+		set_current_state(TASK_RUNNING);
+
+		if (kthread_should_stop())
+			return 0;
+
+		kvm_recover_nx_lpages(kvm);
+	}
+}
+
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	int err;
+
+	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
+					  "kvm-nx-lpage-recovery",
+					  &kvm->arch.nx_lpage_recovery_thread);
+	if (!err)
+		kthread_unpark(kvm->arch.nx_lpage_recovery_thread);
+
+	return err;
+}
+
+void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
+{
+	if (kvm->arch.nx_lpage_recovery_thread)
+		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
+}
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -185,4 +185,8 @@ void kvm_mmu_gfn_disallow_lpage(struct k
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
+
+int kvm_mmu_post_init_vm(struct kvm *kvm);
+void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
+
 #endif
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8108,6 +8108,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
+	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
@@ -8136,6 +8137,11 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	return 0;
 }
 
+int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return kvm_mmu_post_init_vm(kvm);
+}
+
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -8242,6 +8248,11 @@ int x86_set_memory_region(struct kvm *kv
 }
 EXPORT_SYMBOL_GPL(x86_set_memory_region);
 
+void kvm_arch_pre_destroy_vm(struct kvm *kvm)
+{
+	kvm_mmu_pre_destroy_vm(kvm);
+}
+
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	if (current->mm == kvm->mm) {
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -613,6 +613,23 @@ static int kvm_create_vm_debugfs(struct
 	return 0;
 }
 
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+int __weak kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return 0;
+}
+
+/*
+ * Called just after removing the VM from the vm_list, but before doing any
+ * other destruction.
+ */
+void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
+{
+}
+
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	int r, i;
@@ -660,11 +677,15 @@ static struct kvm *kvm_create_vm(unsigne
 		kvm->buses[i] = kzalloc(sizeof(struct kvm_io_bus),
 					GFP_KERNEL);
 		if (!kvm->buses[i])
-			goto out_err;
+			goto out_err_no_mmu_notifier;
 	}
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
+		goto out_err_no_mmu_notifier;
+
+	r = kvm_arch_post_init_vm(kvm);
+	if (r)
 		goto out_err;
 
 	mutex_lock(&kvm_lock);
@@ -676,6 +697,11 @@ static struct kvm *kvm_create_vm(unsigne
 	return kvm;
 
 out_err:
+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+	if (kvm->mmu_notifier.ops)
+		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
+#endif
+out_err_no_mmu_notifier:
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
@@ -728,6 +754,8 @@ static void kvm_destroy_vm(struct kvm *k
 	mutex_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	mutex_unlock(&kvm_lock);
+	kvm_arch_pre_destroy_vm(kvm);
+
 	kvm_free_irq_routing(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++) {
 		if (kvm->buses[i])


