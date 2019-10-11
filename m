Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD001D4667
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 19:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfJKRPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 13:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfJKRPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 13:15:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C64B710DCCA4;
        Fri, 11 Oct 2019 17:15:38 +0000 (UTC)
Received: from donizetti.redhat.com (unknown [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CB275D717;
        Fri, 11 Oct 2019 17:15:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     cinco-list@redhat.com
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>,
        stable@vger.kernel.org
Subject: [EMBARGOED RHEL8.1 PATCH v5 03/14] KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
Date:   Fri, 11 Oct 2019 19:15:15 +0200
Message-Id: <20191011171526.365-4-pbonzini@redhat.com>
In-Reply-To: <20191011171526.365-1-pbonzini@redhat.com>
References: <20191011171526.365-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Fri, 11 Oct 2019 17:15:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

James Harvey reported a livelock that was introduced by commit
d012a06ab1d23 ("Revert "KVM: x86/mmu: Zap only the relevant pages when
removing a memslot"").

The livelock occurs because kvm_mmu_zap_all() as it exists today will
voluntarily reschedule and drop KVM's mmu_lock, which allows other vCPUs
to add shadow pages.  With enough vCPUs, kvm_mmu_zap_all() can get stuck
in an infinite loop as it can never zap all pages before observing lock
contention or the need to reschedule.  The equivalent of kvm_mmu_zap_all()
that was in use at the time of the reverted commit (4e103134b8623, "KVM:
x86/mmu: Zap only the relevant pages when removing a memslot") employed
a fast invalidate mechanism and was not susceptible to the above livelock.

There are three ways to fix the livelock:

- Reverting the revert (commit d012a06ab1d23) is not a viable option as
  the revert is needed to fix a regression that occurs when the guest has
  one or more assigned devices.  It's unlikely we'll root cause the device
  assignment regression soon enough to fix the regression timely.

- Remove the conditional reschedule from kvm_mmu_zap_all().  However, although
  removing the reschedule would be a smaller code change, it's less safe
  in the sense that the resulting kvm_mmu_zap_all() hasn't been used in
  the wild for flushing memslots since the fast invalidate mechanism was
  introduced by commit 6ca18b6950f8d ("KVM: x86: use the fast way to
  invalidate all pages"), back in 2013.

- Reintroduce the fast invalidate mechanism and use it when zapping shadow
  pages in response to a memslot being deleted/moved, which is what this
  patch does.

For all intents and purposes, this is a revert of commit ea145aacf4ae8
("Revert "KVM: MMU: fast invalidate all pages"") and a partial revert of
commit 7390de1e99a70 ("Revert "KVM: x86: use the fast way to invalidate
all pages""), i.e. restores the behavior of commit 5304b8d37c2a5 ("KVM:
MMU: fast invalidate all pages") and commit 6ca18b6950f8d ("KVM: x86:
use the fast way to invalidate all pages") respectively.

Fixes: d012a06ab1d23 ("Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"")
Reported-by: James Harvey <jamespharvey20@gmail.com>
Cc: Alex Willamson <alex.williamson@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit 002c5f73c508f7df5681bda339831c27f3c1aef4)
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu.c              | 101 +++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7038e79b9851..58c03158fe5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -336,6 +336,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -850,6 +851,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d3ec7d3c0ed3..a8eeea5a2a18 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2060,6 +2060,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	if (!direct)
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
@@ -2209,7 +2215,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 #define for_each_valid_sp(_kvm, _sp, _gfn)				\
 	hlist_for_each_entry(_sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
-		if ((_sp)->role.invalid) {    \
+		if (is_obsolete_sp((_kvm), (_sp)) || (_sp)->role.invalid) {    \
 		} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
@@ -2266,6 +2272,11 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
 static void mmu_audit_disable(void) { }
 #endif
 
+static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+}
+
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
@@ -2490,6 +2501,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
@@ -4221,6 +4233,13 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			return false;
 
 		if (cached_root_available(vcpu, new_cr3, new_role)) {
+			/*
+			 * It is possible that the cached previous root page is
+			 * obsolete because of a change in the MMU generation
+			 * number. However, changing the generation number is
+			 * accompanied by KVM_REQ_MMU_RELOAD, which will free
+			 * the root set here and allocate a new one.
+			 */
 			kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
 			if (!skip_tlb_flush) {
 				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
@@ -5637,11 +5656,89 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	return alloc_mmu_pages(vcpu);
 }
 
+
+static void kvm_zap_obsolete_pages(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(invalid_list);
+	int ign;
+
+restart:
+	list_for_each_entry_safe_reverse(sp, node,
+	      &kvm->arch.active_mmu_pages, link) {
+		/*
+		 * No obsolete valid page exists before a newly created page
+		 * since active_mmu_pages is a FIFO list.
+		 */
+		if (!is_obsolete_sp(kvm, sp))
+			break;
+
+		/*
+		 * Do not repeatedly zap a root page to avoid unnecessary
+		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
+		 * progress:
+		 *    vcpu 0                        vcpu 1
+		 *                         call vcpu_enter_guest():
+		 *                            1): handle KVM_REQ_MMU_RELOAD
+		 *                                and require mmu-lock to
+		 *                                load mmu
+		 * repeat:
+		 *    1): zap root page and
+		 *        send KVM_REQ_MMU_RELOAD
+		 *
+		 *    2): if (cond_resched_lock(mmu-lock))
+		 *
+		 *                            2): hold mmu-lock and load mmu
+		 *
+		 *                            3): see KVM_REQ_MMU_RELOAD bit
+		 *                                on vcpu->requests is set
+		 *                                then return 1 to call
+		 *                                vcpu_enter_guest() again.
+		 *            goto repeat;
+		 *
+		 * Since we are reversely walking the list and the invalid
+		 * list will be moved to the head, skip the invalid page
+		 * can help us to avoid the infinity list walking.
+		 */
+		if (sp->role.invalid)
+			continue;
+
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			cond_resched_lock(&kvm->mmu_lock);
+			goto restart;
+		}
+
+		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
+			goto restart;
+	}
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+}
+
+/*
+ * Fast invalidate all shadow pages and use lock-break technique
+ * to zap obsolete pages.
+ *
+ * It's required when memslot is being deleted or VM is being
+ * destroyed, in these cases, we should ensure that KVM MMU does
+ * not use any resource of the being-deleted slot or all slots
+ * after calling the function.
+ */
+static void kvm_mmu_zap_all_fast(struct kvm *kvm)
+{
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
+
+	kvm_zap_obsolete_pages(kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all(kvm);
+	kvm_mmu_zap_all_fast(kvm);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.21.0


