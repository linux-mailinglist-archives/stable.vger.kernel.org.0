Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A7353F2D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhDEJKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238787AbhDEJKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33FC161002;
        Mon,  5 Apr 2021 09:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613804;
        bh=a48yWRZI6qBuWB8cl0PuZFWfU0yAlhAh0CiEqSDVE2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02C5HmnGzeRyrKmKg60ad0r2VmelGQVxSNcPMYRRBBsqEq6wa3aDCAZ3ucglVh3n7
         LB/URCHiuUbcKWTElAbBWriODBe8mCucTx8W0Dl6vNskoknqUbzOcNulXm3kOOJpMg
         2RhtE7MshuYlgz0FvcbVR1GM04O59TvPnnq23fY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/126] KVM: x86: compile out TDP MMU on 32-bit systems
Date:   Mon,  5 Apr 2021 10:54:19 +0200
Message-Id: <20210405085034.266385602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 897218ff7cf19290ec2d69652ce673d8ed6fedeb ]

The TDP MMU assumes that it can do atomic accesses to 64-bit PTEs.
Rather than just disabling it, compile it out completely so that it
is possible to use for example 64-bit xchg.

To limit the number of stubs, wrap all accesses to tdp_mmu_enabled
or tdp_mmu_page with a function.  Calls to all other functions in
tdp_mmu.c are eliminated and do not even reach the linker.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/Makefile           |  3 ++-
 arch/x86/kvm/mmu/mmu.c          | 36 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 29 +-------------------------
 arch/x86/kvm/mmu/tdp_mmu.h      | 32 +++++++++++++++++++++++++----
 6 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 47cd8f9b3fe7..af858f495e75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1001,6 +1001,7 @@ struct kvm_arch {
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 
+#ifdef CONFIG_X86_64
 	/*
 	 * Whether the TDP MMU is enabled for this VM. This contains a
 	 * snapshot of the TDP MMU module parameter from when the VM was
@@ -1027,6 +1028,7 @@ struct kvm_arch {
 	 * the thread holds the MMU lock in write mode.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+#endif /* CONFIG_X86_64 */
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b804444e16d4..1d1e31917a88 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o mmu/tdp_iter.o mmu/tdp_mmu.o
+			   mmu/spte.o
+kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0f45ad05f895..94e6bf004576 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1225,7 +1225,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 	while (mask) {
@@ -1254,7 +1254,7 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 	while (mask) {
@@ -1301,7 +1301,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn);
 
@@ -1513,7 +1513,7 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 
 	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
 
 	return r;
@@ -1525,7 +1525,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 
 	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
 
 	return r;
@@ -1580,7 +1580,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 	int young = false;
 
 	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
 
 	return young;
@@ -1591,7 +1591,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	int young = false;
 
 	young = kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_hva(kvm, hva);
 
 	return young;
@@ -3153,7 +3153,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
 	if (kvm_mmu_put_root(kvm, sp)) {
-		if (sp->tdp_mmu_page)
+		if (is_tdp_mmu_page(sp))
 			kvm_tdp_mmu_free_root(kvm, sp);
 		else if (sp->role.invalid)
 			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
@@ -3247,7 +3247,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 	unsigned i;
 
-	if (vcpu->kvm->arch.tdp_mmu_enabled) {
+	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 
 		if (!VALID_PAGE(root))
@@ -5434,7 +5434,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
@@ -5497,7 +5497,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
-	if (kvm->arch.tdp_mmu_enabled) {
+	if (is_tdp_mmu_enabled(kvm)) {
 		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
@@ -5521,7 +5521,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
 	spin_unlock(&kvm->mmu_lock);
 
@@ -5587,7 +5587,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 }
@@ -5614,7 +5614,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
@@ -5637,7 +5637,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
 	spin_unlock(&kvm->mmu_lock);
 
@@ -5653,7 +5653,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
@@ -5681,7 +5681,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
 
 	spin_unlock(&kvm->mmu_lock);
@@ -5992,7 +5992,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		if (sp->tdp_mmu_page) {
+		if (is_tdp_mmu_page(sp)) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
 				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
 		} else {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f599cc64178..cf67fa6fb8fe 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -56,10 +56,12 @@ struct kvm_mmu_page {
 	/* Number of writes since the last time traversal visited this page.  */
 	atomic_t write_flooding_count;
 
+#ifdef CONFIG_X86_64
 	bool tdp_mmu_page;
 
 	/* Used for freeing the page asyncronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
+#endif
 };
 
 extern struct kmem_cache *mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index eb38f74af3f2..075b9d63bd57 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -10,24 +10,13 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
-#ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
-#endif
-
-static bool is_tdp_mmu_enabled(void)
-{
-#ifdef CONFIG_X86_64
-	return tdp_enabled && READ_ONCE(tdp_mmu_enabled);
-#else
-	return false;
-#endif /* CONFIG_X86_64 */
-}
 
 /* Initializes the TDP MMU for the VM, if enabled. */
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
-	if (!is_tdp_mmu_enabled())
+	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
 		return;
 
 	/* This should not be changed for the lifetime of the VM. */
@@ -96,22 +85,6 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
-bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
-{
-	struct kvm_mmu_page *sp;
-
-	if (!kvm->arch.tdp_mmu_enabled)
-		return false;
-	if (WARN_ON(!VALID_PAGE(hpa)))
-		return false;
-
-	sp = to_shadow_page(hpa);
-	if (WARN_ON(!sp))
-		return false;
-
-	return sp->tdp_mmu_page && sp->root_count;
-}
-
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index cbbdbadd1526..b4b65e3699b3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,10 +5,6 @@
 
 #include <linux/kvm_host.h>
 
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
-
-bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
@@ -47,4 +43,32 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 
+#ifdef CONFIG_X86_64
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
+#else
+static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
+static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
+static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
+#endif
+
+static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
+{
+	struct kvm_mmu_page *sp;
+
+	if (!is_tdp_mmu_enabled(kvm))
+		return false;
+	if (WARN_ON(!VALID_PAGE(hpa)))
+		return false;
+
+	sp = to_shadow_page(hpa);
+	if (WARN_ON(!sp))
+		return false;
+
+	return is_tdp_mmu_page(sp) && sp->root_count;
+}
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.30.1



