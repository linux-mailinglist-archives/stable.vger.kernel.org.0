Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB0A35AEB3
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDJPMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234519AbhDJPMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0ycKSFpwPxcT2ilZ/AJl/uYLmiQ+lFD0fif24aNEQc=;
        b=DMDQnF+oPDry0teZfnNL41b6LmwYX1UA0kAEhu0FJxZC1lMCpRkTmS6jYpFDYvooTWHRY9
        8/fmsLJyGnMfQ4V3Ocjlo7HhUO5GHARPkxM/gcRURzK0+9Eroqrtd4zsp3EvX9DFpHabus
        /HqPUhy4g04DytyRfgjn3Y34V9p1Hl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-qaMJmdwNP4aSL6LfG37Xnw-1; Sat, 10 Apr 2021 11:12:33 -0400
X-MC-Unique: qaMJmdwNP4aSL6LfG37Xnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FBAE107ACC7;
        Sat, 10 Apr 2021 15:12:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C481A5D9D3;
        Sat, 10 Apr 2021 15:12:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 4/9] KVM: x86/mmu: Ensure forward progress when yielding in TDP MMU iter
Date:   Sat, 10 Apr 2021 11:12:24 -0400
Message-Id: <20210410151229.4062930-5-pbonzini@redhat.com>
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
2.26.2


