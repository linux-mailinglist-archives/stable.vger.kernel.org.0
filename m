Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197683ED69E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbhHPNWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240953AbhHPNUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF99632CC;
        Mon, 16 Aug 2021 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119744;
        bh=GBVDmVeLVY6aL2EhaaOVhOjaHOaXAvz8SPbOlF1beqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf4ytMgBHhOKRJ4UqyDALoFegtFLqG9q2AlRddYhGUaWjSIuBImpwMeKu3sLlg2is
         TRmw+fC8al9l0cLKygQ7bXiSiJztRpaF7CUOPRRT7BzRIW8BamJtDiGV+v3pJhv/48
         IVDn4ILyniFKdD3OaGyI/djyJ36CONWGVJxDTSrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 146/151] KVM: x86/mmu: Dont leak non-leaf SPTEs when zapping all SPTEs
Date:   Mon, 16 Aug 2021 15:02:56 +0200
Message-Id: <20210816125448.883684223@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 524a1e4e381fc5e7781008d5bd420fd1357c0113 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -41,6 +41,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
+	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -79,8 +80,6 @@ static void tdp_mmu_free_sp_rcu_callback
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
@@ -92,7 +91,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kv
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
+	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -722,8 +721,17 @@ static bool zap_gfn_range(struct kvm *kv
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
@@ -742,9 +750,10 @@ retry:
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
@@ -792,12 +801,11 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct
 
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
@@ -836,7 +844,6 @@ static struct kvm_mmu_page *next_invalid
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
@@ -852,8 +859,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(s
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, max_gfn, true, flush,
-				      true);
+		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
 
 		/*
 		 * Put the reference acquired in


