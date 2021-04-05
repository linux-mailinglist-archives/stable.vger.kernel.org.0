Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6A35406F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbhDEJRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239828AbhDEJRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4514460FE4;
        Mon,  5 Apr 2021 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614263;
        bh=1lwWg6dDdtuAt8elUoxi0DIi1c715sU36dAzUAQyEOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UA3Km+YFwcDOKwNve5avW5pkyke1Z4RBh+tTOVJShozBrlcXzkgaPXQ3yWXSrDj8y
         Y4KEphfj1/AbNDNojZDOQ3aiIDx8o9WmY0Du7YGDA7tm7cjap6gHEheMMMdsXpOWfV
         ZDf2zUpykguH8kENezkUBAwse3mmVLn0VWaejXF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 108/152] KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
Date:   Mon,  5 Apr 2021 10:54:17 +0200
Message-Id: <20210405085037.744578727@linuxfoundation.org>
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

[ Upstream commit ed5e484b79e8a9b8be714bd85b6fc70bd6dc99a7 ]

In some functions the TDP iter risks not making forward progress if two
threads livelock yielding to one another. This is possible if two threads
are trying to execute wrprot_gfn_range. Each could write protect an entry
and then yield. This would reset the tdp_iter's walk over the paging
structure and the loop would end up repeating the same entry over and
over, preventing either thread from making forward progress.

Fix this issue by only yielding if the loop has made forward progress
since the last yield.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

Message-Id: <20210202185734.1680553-14-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_iter.c | 18 +-----------------
 arch/x86/kvm/mmu/tdp_iter.h |  7 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c  | 21 ++++++++++++++++-----
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 9917c55b7d24..1a09d212186b 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -31,6 +31,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->root_level = root_level;
 	iter->min_level = min_level;
 	iter->level = root_level;
@@ -158,23 +159,6 @@ void tdp_iter_next(struct tdp_iter *iter)
 	iter->valid = false;
 }
 
-/*
- * Restart the walk over the paging structure from the root, starting from the
- * highest gfn the iterator had previously reached. Assumes that the entire
- * paging structure, except the root page, may have been completely torn down
- * and rebuilt.
- */
-void tdp_iter_refresh_walk(struct tdp_iter *iter)
-{
-	gfn_t next_last_level_gfn = iter->next_last_level_gfn;
-
-	if (iter->gfn > next_last_level_gfn)
-		next_last_level_gfn = iter->gfn;
-
-	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
-		       iter->root_level, iter->min_level, next_last_level_gfn);
-}
-
 u64 *tdp_iter_root_pt(struct tdp_iter *iter)
 {
 	return iter->pt_path[iter->root_level - 1];
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b2dd269c631f..d480c540ee27 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -16,6 +16,12 @@ struct tdp_iter {
 	 * for this GFN.
 	 */
 	gfn_t next_last_level_gfn;
+	/*
+	 * The next_last_level_gfn at the time when the thread last
+	 * yielded. Only yielding when the next_last_level_gfn !=
+	 * yielded_gfn helps ensure forward progress.
+	 */
+	gfn_t yielded_gfn;
 	/* Pointers to the page tables traversed to reach the current SPTE */
 	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
@@ -54,7 +60,6 @@ u64 *spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-void tdp_iter_refresh_walk(struct tdp_iter *iter);
 u64 *tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0dd27767c770..a07d37abb63f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -420,8 +420,9 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * TLB flush before yielding.
  *
  * If this function yields, it will also reset the tdp_iter's walk over the
- * paging structure and the calling function should allow the iterator to
- * continue its traversal from the paging structure root.
+ * paging structure and the calling function should skip to the next
+ * iteration to allow the iterator to continue its traversal from the
+ * paging structure root.
  *
  * Return true if this function yielded and the iterator's traversal was reset.
  * Return false if a yield was not needed.
@@ -429,12 +430,22 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 					     struct tdp_iter *iter, bool flush)
 {
+	/* Ensure forward progress has been made before yielding. */
+	if (iter->next_last_level_gfn == iter->yielded_gfn)
+		return false;
+
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
 		cond_resched_lock(&kvm->mmu_lock);
-		tdp_iter_refresh_walk(iter);
+
+		WARN_ON(iter->gfn > iter->next_last_level_gfn);
+
+		tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
+			       iter->root_level, iter->min_level,
+			       iter->next_last_level_gfn);
+
 		return true;
 	}
 
@@ -474,8 +485,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		flush_needed = !can_yield ||
-			       !tdp_mmu_iter_cond_resched(kvm, &iter, true);
+		flush_needed = !(can_yield &&
+				 tdp_mmu_iter_cond_resched(kvm, &iter, true));
 	}
 	return flush_needed;
 }
-- 
2.30.1



