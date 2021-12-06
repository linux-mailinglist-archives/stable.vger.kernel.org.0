Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD3469F28
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391456AbhLFPpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390591AbhLFPme (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FCDC0698DA;
        Mon,  6 Dec 2021 07:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36B65B81126;
        Mon,  6 Dec 2021 15:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF95C34900;
        Mon,  6 Dec 2021 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804528;
        bh=imDWMiwWigWsxOyupcs1CjIlUc8FG5gGODOXbYZNBDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCgWKVqTe+XEQ8HgfaoNAFOCBa7FHE9uITxcnDjARDcO3jACbOvkBgsDFAfLSPY7J
         Pw8ZEiLOH5Lbg2AkqinHpzt+Q/W2qPduPVE9fdwIjMO1cfiqHJkzA8Iv9pcaelBqKK
         h07prGFp44pouPrYVHholHPfpfNx6EX97cmMf/o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/207] KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible path
Date:   Mon,  6 Dec 2021 15:57:14 +0100
Message-Id: <20211206145616.505438193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4b85c921cd393764d22c0cdab6d7d5d120aa0980 ]

Drop the "flush" param and return values to/from the TDP MMU's helper for
zapping collapsible SPTEs.  Because the helper runs with mmu_lock held
for read, not write, it uses tdp_mmu_zap_spte_atomic(), and the atomic
zap handles the necessary remote TLB flush.

Similarly, because mmu_lock is dropped and re-acquired between zapping
legacy MMUs and zapping TDP MMUs, kvm_mmu_zap_collapsible_sptes() must
handle remote TLB flushes from the legacy MMU before calling into the TDP
MMU.

Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211120045046.3940942-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++-------
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2e74e8c1651a..0a88cb4f731f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5855,8 +5855,6 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot)
 {
-	bool flush;
-
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
 		/*
@@ -5864,17 +5862,14 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		 * logging at a 4k granularity and never creates collapsible
 		 * 2m SPTEs during dirty logging.
 		 */
-		flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-		if (flush)
+		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
 			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, false);
-		if (flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index aa75689a91b4c..0e4227b59d7bb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1413,10 +1413,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static bool zap_collapsible_spte_range(struct kvm *kvm,
+static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1427,10 +1426,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
-			flush = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1442,6 +1439,7 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
+		/* Note, a successful atomic zap also does a remote TLB flush. */
 		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
 			 * The iter must explicitly re-read the SPTE because
@@ -1450,30 +1448,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
-		flush = true;
 	}
 
 	rcu_read_unlock();
-
-	return flush;
 }
 
 /*
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-
-	return flush;
+		zap_collapsible_spte_range(kvm, root, slot);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 358f447d40120..ba3681cd38ab4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -66,9 +66,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-- 
2.33.0



