Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B0454A662
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354882AbiFNCcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355303AbiFNC1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53360427FF;
        Mon, 13 Jun 2022 19:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C081161123;
        Tue, 14 Jun 2022 02:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0FCC3411E;
        Tue, 14 Jun 2022 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172687;
        bh=NSlycFjduxzkyRLbG8gBMYKto4K11+uaNjz5PTLaJf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeLtorQBgvOY50xI1kcYRAe0UrO3of2oSVGfZqMa5b5OAv002cSnChz4/yQBLfdg8
         xWPGhVK4XLZm2TUQeOWg7UF9/REhwgM9MD1M4syKDWfEySi6mzfQEmCLsW6sy2GQgl
         nHD9WwYCZkborKn20u7IiyQPem0EpkQB1Z1WFyPkU6Hob29rLmUEHNjRT1ORI8F9sT
         ypOyal3zAkx6SYy2ZYVfycT219dpzauNboHD4q8JgW590+r6/LjPBwP7NXACvAttrZ
         U/c/2bV6V4kTCqAPVypGWmB2Zu0vpK7nDLcUHyknW5YbSAc3hQvf4m3fIxAEsGQ2LH
         10GFh3HiCNsQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.18 4/6] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging
Date:   Mon, 13 Jun 2022 22:11:13 -0400
Message-Id: <20220614021116.1101331-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614021116.1101331-1-sashal@kernel.org>
References: <20220614021116.1101331-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 5ba7c4c6d1c7af47a916f728bb5940669684a087 ]

Currently disabling dirty logging with the TDP MMU is extremely slow.
On a 96 vCPU / 96G VM backed with gigabyte pages, it takes ~200 seconds
to disable dirty logging with the TDP MMU, as opposed to ~4 seconds with
the shadow MMU.

When disabling dirty logging, zap non-leaf parent entries to allow
replacement with huge pages instead of recursing and zapping all of the
child, leaf entries. This reduces the number of TLB flushes required.
and reduces the disable dirty log time with the TDP MMU to ~3 seconds.

Opportunistically add a WARN() to catch GFNs that are mapped at a
higher level than their max level.

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220525230904.1584480-1-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_iter.c |  9 +++++++++
 arch/x86/kvm/mmu/tdp_iter.h |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c  | 38 +++++++++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 6d3b3e5a5533..ee4802d7b36c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -145,6 +145,15 @@ static bool try_step_up(struct tdp_iter *iter)
 	return true;
 }
 
+/*
+ * Step the iterator back up a level in the paging structure. Should only be
+ * used when the iterator is below the root level.
+ */
+void tdp_iter_step_up(struct tdp_iter *iter)
+{
+	WARN_ON(!try_step_up(iter));
+}
+
 /*
  * Step to the next SPTE in a pre-order traversal of the paging structure.
  * To get to the next SPTE, the iterator either steps down towards the goal
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..adfca0cf94d3 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -114,5 +114,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_up(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 922b06bf4b94..b61a11d462cc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1748,12 +1748,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
+	int max_mapping_level;
 	kvm_pfn_t pfn;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
@@ -1761,15 +1761,41 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		/*
+		 * This is a leaf SPTE. Check if the PFN it maps can
+		 * be mapped at a higher level.
+		 */
 		pfn = spte_to_pfn(iter.old_spte);
-		if (kvm_is_reserved_pfn(pfn) ||
-		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
-							    pfn, PG_LEVEL_NUM))
+
+		if (kvm_is_reserved_pfn(pfn))
 			continue;
 
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
+				iter.gfn, pfn, PG_LEVEL_NUM);
+
+		WARN_ON(max_mapping_level < iter.level);
+
+		/*
+		 * If this page is already mapped at the highest
+		 * viable level, there's nothing more to do.
+		 */
+		if (max_mapping_level == iter.level)
+			continue;
+
+		/*
+		 * The page can be remapped at a higher level, so step
+		 * up to zap the parent SPTE.
+		 */
+		while (max_mapping_level > iter.level)
+			tdp_iter_step_up(&iter);
+
 		/* Note, a successful atomic zap also does a remote TLB flush. */
-		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
-			goto retry;
+		tdp_mmu_zap_spte_atomic(kvm, &iter);
+
+		/*
+		 * If the atomic zap fails, the iter will recurse back into
+		 * the same subtree to retry.
+		 */
 	}
 
 	rcu_read_unlock();
-- 
2.35.1

