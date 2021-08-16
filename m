Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42BF3ED028
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhHPIWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhHPIWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7364761B04;
        Mon, 16 Aug 2021 08:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629102113;
        bh=qA5c8IozoTZQak7U6okCTyESNmypi9F62NkYNG9Bfzs=;
        h=Subject:To:Cc:From:Date:From;
        b=t+TmyUNTfi0aJq1Pq4FL1yNhEg1HXB4buPYiD6r6giuy9+ErHNDX5Sl/+wyiKbnz/
         DmGS+/3YQZFVIbgMh7v4zV63xuKkYpZCuWBi8V4oO3dcNdfDE0qxPy5NyNfjtBS0cx
         1sBPOR9JTSpcFCri6A3cJYBybZcdor/BhJJJuvzI=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all" failed to apply to 5.10-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:21:50 +0200
Message-ID: <1629102110147162@kroah.com>
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

From 524a1e4e381fc5e7781008d5bd420fd1357c0113 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 12 Aug 2021 11:14:13 -0700
Subject: [PATCH] KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all
 SPTEs

Pass "all ones" as the end GFN to signal "zap all" for the TDP MMU and
really zap all SPTEs in this case.  As is, zap_gfn_range() skips non-leaf
SPTEs whose range exceeds the range to be zapped.  If shadow_phys_bits is
not aligned to the range size of top-level SPTEs, e.g. 512gb with 4-level
paging, the "zap all" flows will skip top-level SPTEs whose range extends
beyond shadow_phys_bits and leak their SPs when the VM is destroyed.

Use the current upper bound (based on host.MAXPHYADDR) to detect that the
caller wants to zap all SPTEs, e.g. instead of using the max theoretical
gfn, 1 << (52 - 12).  The more precise upper bound allows the TDP iterator
to terminate its walk earlier when running on hosts with MAXPHYADDR < 52.

Add a WARN on kmv->arch.tdp_mmu_pages when the TDP MMU is destroyed to
help future debuggers should KVM decide to leak SPTEs again.

The bug is most easily reproduced by running (and unloading!) KVM in a
VM whose host.MAXPHYADDR < 39, as the SPTE for gfn=0 will be skipped.

  =============================================================================
  BUG kvm_mmu_page_header (Not tainted): Objects remaining in kvm_mmu_page_header on __kmem_cache_shutdown()
  -----------------------------------------------------------------------------
  Slab 0x000000004d8f7af1 objects=22 used=2 fp=0x00000000624d29ac flags=0x4000000000000200(slab|zone=1)
  CPU: 0 PID: 1582 Comm: rmmod Not tainted 5.14.0-rc2+ #420
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   dump_stack_lvl+0x45/0x59
   slab_err+0x95/0xc9
   __kmem_cache_shutdown.cold+0x3c/0x158
   kmem_cache_destroy+0x3d/0xf0
   kvm_mmu_module_exit+0xa/0x30 [kvm]
   kvm_arch_exit+0x5d/0x90 [kvm]
   kvm_exit+0x78/0x90 [kvm]
   vmx_exit+0x1a/0x50 [kvm_intel]
   __x64_sys_delete_module+0x13f/0x220
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210812181414.3376143-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0853370bd811..8783b9eb2b33 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -43,6 +43,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
+	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -81,8 +82,6 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
@@ -94,7 +93,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
+	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -724,8 +723,17 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
+	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
 
+	/*
+	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
+	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
+	 * and so KVM will never install a SPTE for such addresses.
+	 */
+	end = min(end, max_gfn_host);
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -744,9 +752,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		/*
 		 * If this is a non-last-level SPTE that covers a larger range
 		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level.
+		 * lower level, except when zapping all SPTEs.
 		 */
-		if ((iter.gfn < start ||
+		if (!zap_all &&
+		    (iter.gfn < start ||
 		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -794,12 +803,11 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush = false;
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn,
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull,
 						  flush, false);
 
 	if (flush)
@@ -838,7 +846,6 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
@@ -854,8 +861,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, max_gfn, true, flush,
-				      true);
+		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
 
 		/*
 		 * Put the reference acquired in

