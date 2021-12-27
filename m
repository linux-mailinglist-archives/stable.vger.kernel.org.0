Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE51347FC30
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 12:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhL0L14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 06:27:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhL0L1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 06:27:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A10F1B80EBA
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B915DC36AEA;
        Mon, 27 Dec 2021 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640604473;
        bh=EzYXIWHNvBQFqJIOxAKdgR5mBVRuCVfzFirMKfuJAlE=;
        h=Subject:To:Cc:From:Date:From;
        b=h3JKx5Bh37pT46MILtoHkBIL7vLMfgmOfFUUtaYFulaGGvamchgwu92Xyev07DaQD
         oFq6xz8wXmPwxlc2iCgikwkWdsuLswY/aBHCPJ0drEVHtp5qxyBWm8nA8upJpErcqA
         w+4gGfSLBfAu7ZktQc5KTFktuHB2vRSM9faA+ARo=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Don't advance iterator after restart due to" failed to apply to 5.10-stable tree
To:     seanjc@google.com, ignat@cloudflare.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 12:27:50 +0100
Message-ID: <16406044709777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a0f64de479cae75effb630a2e0a237ca0d0623c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 14 Dec 2021 03:35:28 +0000
Subject: [PATCH] KVM: x86/mmu: Don't advance iterator after restart due to
 yielding

After dropping mmu_lock in the TDP MMU, restart the iterator during
tdp_iter_next() and do not advance the iterator.  Advancing the iterator
results in skipping the top-level SPTE and all its children, which is
fatal if any of the skipped SPTEs were not visited before yielding.

When zapping all SPTEs, i.e. when min_level == root_level, restarting the
iter and then invoking tdp_iter_next() is always fatal if the current gfn
has as a valid SPTE, as advancing the iterator results in try_step_side()
skipping the current gfn, which wasn't visited before yielding.

Sprinkle WARNs on iter->yielded being true in various helpers that are
often used in conjunction with yielding, and tag the helper with
__must_check to reduce the probabily of improper usage.

Failing to zap a top-level SPTE manifests in one of two ways.  If a valid
SPTE is skipped by both kvm_tdp_mmu_zap_all() and kvm_tdp_mmu_put_root(),
the shadow page will be leaked and KVM will WARN accordingly.

  WARNING: CPU: 1 PID: 3509 at arch/x86/kvm/mmu/tdp_mmu.c:46 [kvm]
  RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x3e/0x50 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_destroy_vm+0x130/0x1b0 [kvm]
   kvm_destroy_vm+0x162/0x2a0 [kvm]
   kvm_vcpu_release+0x34/0x60 [kvm]
   __fput+0x82/0x240
   task_work_run+0x5c/0x90
   do_exit+0x364/0xa10
   ? futex_unqueue+0x38/0x60
   do_group_exit+0x33/0xa0
   get_signal+0x155/0x850
   arch_do_signal_or_restart+0xed/0x750
   exit_to_user_mode_prepare+0xc5/0x120
   syscall_exit_to_user_mode+0x1d/0x40
   do_syscall_64+0x48/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

If kvm_tdp_mmu_zap_all() skips a gfn/SPTE but that SPTE is then zapped by
kvm_tdp_mmu_put_root(), KVM triggers a use-after-free in the form of
marking a struct page as dirty/accessed after it has been put back on the
free list.  This directly triggers a WARN due to encountering a page with
page_count() == 0, but it can also lead to data corruption and additional
errors in the kernel.

  WARNING: CPU: 7 PID: 1995658 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:171
  RIP: 0010:kvm_is_zone_device_pfn.part.0+0x9e/0xd0 [kvm]
  Call Trace:
   <TASK>
   kvm_set_pfn_dirty+0x120/0x1d0 [kvm]
   __handle_changed_spte+0x92e/0xca0 [kvm]
   __handle_changed_spte+0x63c/0xca0 [kvm]
   __handle_changed_spte+0x63c/0xca0 [kvm]
   __handle_changed_spte+0x63c/0xca0 [kvm]
   zap_gfn_range+0x549/0x620 [kvm]
   kvm_tdp_mmu_put_root+0x1b6/0x270 [kvm]
   mmu_free_root_page+0x219/0x2c0 [kvm]
   kvm_mmu_free_roots+0x1b4/0x4e0 [kvm]
   kvm_mmu_unload+0x1c/0xa0 [kvm]
   kvm_arch_destroy_vm+0x1f2/0x5c0 [kvm]
   kvm_put_kvm+0x3b1/0x8b0 [kvm]
   kvm_vcpu_release+0x4e/0x70 [kvm]
   __fput+0x1f7/0x8c0
   task_work_run+0xf8/0x1a0
   do_exit+0x97b/0x2230
   do_group_exit+0xda/0x2a0
   get_signal+0x3be/0x1e50
   arch_do_signal_or_restart+0x244/0x17f0
   exit_to_user_mode_prepare+0xcb/0x120
   syscall_exit_to_user_mode+0x1d/0x40
   do_syscall_64+0x4d/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Note, the underlying bug existed even before commit 1af4a96025b3 ("KVM:
x86/mmu: Yield in TDU MMU iter even if no SPTES changed") moved calls to
tdp_mmu_iter_cond_resched() to the beginning of loops, as KVM could still
incorrectly advance past a top-level entry when yielding on a lower-level
entry.  But with respect to leaking shadow pages, the bug was introduced
by yielding before processing the current gfn.

Alternatively, tdp_mmu_iter_cond_resched() could simply fall through, or
callers could jump to their "retry" label.  The downside of that approach
is that tdp_mmu_iter_cond_resched() _must_ be called before anything else
in the loop, and there's no easy way to enfornce that requirement.

Ideally, KVM would handling the cond_resched() fully within the iterator
macro (the code is actually quite clean) and avoid this entire class of
bugs, but that is extremely difficult do while also supporting yielding
after tdp_mmu_set_spte_atomic() fails.  Yielding after failing to set a
SPTE is very desirable as the "owner" of the REMOVED_SPTE isn't strictly
bounded, e.g. if it's zapping a high-level shadow page, the REMOVED_SPTE
may block operations on the SPTE for a significant amount of time.

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211214033528.123268-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b3ed302c1a35..caa96c270b95 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -26,6 +26,7 @@ static gfn_t round_gfn_for_level(gfn_t gfn, int level)
  */
 void tdp_iter_restart(struct tdp_iter *iter)
 {
+	iter->yielded = false;
 	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->level = iter->root_level;
 
@@ -160,6 +161,11 @@ static bool try_step_up(struct tdp_iter *iter)
  */
 void tdp_iter_next(struct tdp_iter *iter)
 {
+	if (iter->yielded) {
+		tdp_iter_restart(iter);
+		return;
+	}
+
 	if (try_step_down(iter))
 		return;
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1748b988d3a..e19cabbcb65c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -45,6 +45,12 @@ struct tdp_iter {
 	 * iterator walks off the end of the paging structure.
 	 */
 	bool valid;
+	/*
+	 * True if KVM dropped mmu_lock and yielded in the middle of a walk, in
+	 * which case tdp_iter_next() needs to restart the walk at the root
+	 * level instead of advancing to the next entry.
+	 */
+	bool yielded;
 };
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1db8496259ad..1beb4ca90560 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -502,6 +502,8 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter,
 					   u64 new_spte)
 {
+	WARN_ON_ONCE(iter->yielded);
+
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
@@ -575,6 +577,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
+	WARN_ON_ONCE(iter->yielded);
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -640,18 +644,19 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * If this function should yield and flush is set, it will perform a remote
  * TLB flush before yielding.
  *
- * If this function yields, it will also reset the tdp_iter's walk over the
- * paging structure and the calling function should skip to the next
- * iteration to allow the iterator to continue its traversal from the
- * paging structure root.
+ * If this function yields, iter->yielded is set and the caller must skip to
+ * the next iteration, where tdp_iter_next() will reset the tdp_iter's walk
+ * over the paging structures to allow the iterator to continue its traversal
+ * from the paging structure root.
  *
- * Return true if this function yielded and the iterator's traversal was reset.
- * Return false if a yield was not needed.
+ * Returns true if this function yielded.
  */
-static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
-					     struct tdp_iter *iter, bool flush,
-					     bool shared)
+static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
+							  struct tdp_iter *iter,
+							  bool flush, bool shared)
 {
+	WARN_ON(iter->yielded);
+
 	/* Ensure forward progress has been made before yielding. */
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
 		return false;
@@ -671,12 +676,10 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
 
-		tdp_iter_restart(iter);
-
-		return true;
+		iter->yielded = true;
 	}
 
-	return false;
+	return iter->yielded;
 }
 
 /*

