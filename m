Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5627735403F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbhDEJQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240736AbhDEJQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0680D61002;
        Mon,  5 Apr 2021 09:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614191;
        bh=c1lIHUX6h0kYVXVVmDKxDXNLRej7fk86mem3YXbhBow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fT8NhexHGFaoHNgIdSRKPWd6UYXYATn9M8XoPCBi4D05a5qa0VGpz0nasohfbhM9s
         0E4wphG5aj3EKMk8w8DrteAsCZ+hSpzZegB+9NInMNqWLt87/Ru+JFqweGvysUwW+h
         +zasitaA1Uo5vERSg+6Z1ePnuphwLr/JgIY088DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 118/152] KVM: x86/mmu: Use atomic ops to set SPTEs in TDP MMU map
Date:   Mon,  5 Apr 2021 10:54:27 +0200
Message-Id: <20210405085038.072378763@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 9a77daacc87dee9fd63e31243f21894132ed8407 ]

To prepare for handling page faults in parallel, change the TDP MMU
page fault handler to use atomic operations to set SPTEs so that changes
are not lost if multiple threads attempt to modify the same SPTE.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

Message-Id: <20210202185734.1680553-21-bgardon@google.com>
[Document new locking rules. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/locking.rst |   9 +-
 arch/x86/include/asm/kvm_host.h    |  13 +++
 arch/x86/kvm/mmu/tdp_mmu.c         | 142 ++++++++++++++++++++++-------
 3 files changed, 130 insertions(+), 34 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index b21a34c34a21..0aa4817b466d 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -16,7 +16,14 @@ The acquisition orders for mutexes are as follows:
 - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
   them together is quite rare.
 
-On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
+On x86:
+
+- vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
+
+- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
+  taken inside kvm->arch.mmu_lock, and cannot be taken without already
+  holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
+  there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
 
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0cfd620b293..42fca28d6189 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1030,6 +1030,19 @@ struct kvm_arch {
 	 * tdp_mmu_page set and a root_count of 0.
 	 */
 	struct list_head tdp_mmu_pages;
+
+	/*
+	 * Protects accesses to the following fields when the MMU lock
+	 * is held in read mode:
+	 *  - tdp_mmu_pages (above)
+	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
+	 *  - lpage_disallowed_mmu_pages
+	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
+	 *    by the TDP MMU
+	 * It is acceptable, but not necessary, to acquire this lock when
+	 * the thread holds the MMU lock in write mode.
+	 */
+	spinlock_t tdp_mmu_pages_lock;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc49a5b90086..bb6faa9193b4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,6 +7,7 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
 #ifdef CONFIG_X86_64
@@ -33,6 +34,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
@@ -225,7 +227,8 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level);
+				u64 old_spte, u64 new_spte, int level,
+				bool shared);
 
 static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 {
@@ -267,17 +270,26 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
  *
  * @kvm: kvm instance
  * @sp: the new page
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be adding or removing pages.
  * @account_nx: This page replaces a NX large page and should be marked for
  *		eventual reclaim.
  */
 static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool account_nx)
+			      bool shared, bool account_nx)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	if (shared)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
+
+	if (shared)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -285,14 +297,24 @@ static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  *
  * @kvm: kvm instance
  * @sp: the page to be removed
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be adding or removing pages.
  */
-static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				bool shared)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	if (shared)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
 	if (sp->lpage_disallowed)
 		unaccount_huge_nx_page(kvm, sp);
+
+	if (shared)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -300,28 +322,39 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp)
  *
  * @kvm: kvm instance
  * @pt: the page removed from the paging structure
+ * @shared: This operation may not be running under the exclusive use
+ *	    of the MMU lock and the operation must synchronize with other
+ *	    threads that might be modifying SPTEs.
  *
  * Given a page table that has been removed from the TDP paging structure,
  * iterates through the page table to clear SPTEs and free child page tables.
  */
-static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
+					bool shared)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(pt);
 	int level = sp->role.level;
 	gfn_t gfn = sp->gfn;
 	u64 old_child_spte;
+	u64 *sptep;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	tdp_mmu_unlink_page(kvm, sp);
+	tdp_mmu_unlink_page(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		old_child_spte = READ_ONCE(*(pt + i));
-		WRITE_ONCE(*(pt + i), 0);
+		sptep = pt + i;
+
+		if (shared) {
+			old_child_spte = xchg(sptep, 0);
+		} else {
+			old_child_spte = READ_ONCE(*sptep);
+			WRITE_ONCE(*sptep, 0);
+		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
 			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-			old_child_spte, 0, level - 1);
+			old_child_spte, 0, level - 1, shared);
 	}
 
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
@@ -338,12 +371,16 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
  * @level: the level of the PT the SPTE is part of in the paging structure
+ * @shared: This operation may not be running under the exclusive use of
+ *	    the MMU lock and the operation must synchronize with other
+ *	    threads that might be modifying SPTEs.
  *
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				  u64 old_spte, u64 new_spte, int level,
+				  bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -415,18 +452,51 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
 		handle_removed_tdp_mmu_page(kvm,
-				spte_to_child_pt(old_spte, level));
+				spte_to_child_pt(old_spte, level), shared);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level)
+				u64 old_spte, u64 new_spte, int level,
+				bool shared)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
+			      shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 				      new_spte, level);
 }
 
+/*
+ * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
+ * associated bookkeeping
+ *
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @new_spte: The value the SPTE should be set to
+ * Returns: true if the SPTE was set, false if it was not. If false is returned,
+ *	    this function will have no side-effects.
+ */
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	u64 *root_pt = tdp_iter_root_pt(iter);
+	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
+	int as_id = kvm_mmu_page_as_id(root);
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
+		      new_spte) != iter->old_spte)
+		return false;
+
+	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			    iter->level, true);
+
+	return true;
+}
+
+
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
  * @kvm: kvm instance
@@ -456,7 +526,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			      iter->level);
+			      iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
@@ -631,23 +701,18 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	int ret = 0;
 	int make_spte_ret = 0;
 
-	if (unlikely(is_noslot_pfn(pfn))) {
+	if (unlikely(is_noslot_pfn(pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
-				     new_spte);
-	} else {
+	else
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
-				       rcu_dereference(iter->sptep));
-	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else
-		tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+		return RET_PF_RETRY;
 
 	/*
 	 * If the page fault was caused by a write but the page is write
@@ -661,8 +726,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte)))
+	if (unlikely(is_mmio_spte(new_spte))) {
+		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
+				     new_spte);
 		ret = RET_PF_EMULATE;
+	} else
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+				       rcu_dereference(iter->sptep));
 
 	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
 			       rcu_dereference(iter->sptep));
@@ -721,7 +791,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
+			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, 0))
+				break;
 
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
 					KVM_PAGES_PER_HPAGE(iter.level));
@@ -738,19 +809,24 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
 			child_pt = sp->spt;
 
-			tdp_mmu_link_page(vcpu->kvm, sp,
-					  huge_page_disallowed &&
-					  req_level >= iter.level);
-
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			trace_kvm_mmu_get_page(sp, true);
-			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
+			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
+						    new_spte)) {
+				tdp_mmu_link_page(vcpu->kvm, sp, true,
+						  huge_page_disallowed &&
+						  req_level >= iter.level);
+
+				trace_kvm_mmu_get_page(sp, true);
+			} else {
+				tdp_mmu_free_sp(sp);
+				break;
+			}
 		}
 	}
 
-	if (WARN_ON(iter.level != level)) {
+	if (iter.level != level) {
 		rcu_read_unlock();
 		return RET_PF_RETRY;
 	}
-- 
2.30.1



