Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667F248009E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhL0Prk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45840 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240693AbhL0Ppd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32118B810AA;
        Mon, 27 Dec 2021 15:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C301C36AEA;
        Mon, 27 Dec 2021 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619930;
        bh=jRDhDbldlrBOpYjZkEhCpvn0mka3CKHI9DK8YCS7tns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuS9Lmdw3eqncKuQxT09ljqsURow41lHTR4SwpTTpxqF4nQhYEqLUk/juX3MVJGaC
         /0liFwrd81e93Oz7sn0keL2GTeQbt2EtJfAEoGgpAyisdXLWE0ui5e7WWEQJQt+jTm
         Wm2DCJ5WYblQMh9J6KtGdAkHMr09PagaXKTXSzyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 087/128] KVM: x86/mmu: Dont advance iterator after restart due to yielding
Date:   Mon, 27 Dec 2021 16:31:02 +0100
Message-Id: <20211227151334.416334181@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 3a0f64de479cae75effb630a2e0a237ca0d0623c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_iter.c |    6 ++++++
 arch/x86/kvm/mmu/tdp_iter.h |    6 ++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |   29 ++++++++++++++++-------------
 3 files changed, 28 insertions(+), 13 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -26,6 +26,7 @@ static gfn_t round_gfn_for_level(gfn_t g
  */
 void tdp_iter_restart(struct tdp_iter *iter)
 {
+	iter->yielded = false;
 	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->level = iter->root_level;
 
@@ -160,6 +161,11 @@ static bool try_step_up(struct tdp_iter
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
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -501,6 +501,8 @@ static inline bool tdp_mmu_set_spte_atom
 							struct tdp_iter *iter,
 							u64 new_spte)
 {
+	WARN_ON_ONCE(iter->yielded);
+
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
@@ -611,6 +613,8 @@ static inline void __tdp_mmu_set_spte(st
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
+	WARN_ON_ONCE(iter->yielded);
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -676,18 +680,19 @@ static inline void tdp_mmu_set_spte_no_d
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
@@ -707,12 +712,10 @@ static inline bool tdp_mmu_iter_cond_res
 
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


