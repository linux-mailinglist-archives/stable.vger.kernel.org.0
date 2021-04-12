Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C4535C059
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhDLJM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239766AbhDLJIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:08:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E860261277;
        Mon, 12 Apr 2021 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218250;
        bh=Dmhjd9MKTBnJTAJTJJ81XvWp9wugxK5HUhcUmx9icOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzBX8Z4py60jkosEWAN/euFSl8bL6fX/Z9bEgYfgw22pz+eOxU6FLZF4DbsWDId31
         i/86rVoKXuTjsu3l+hyiaZLxvx7N3Lza0VYelSWLy6eL9hLIdrFYOOYeBkXylub7yB
         3BNuCXo8E3rSBMPUu5QJv75Y3sU3Sga8odckWnK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 092/210] KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
Date:   Mon, 12 Apr 2021 10:39:57 +0200
Message-Id: <20210412084019.078608558@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit e139a34ef9d5627a41e1c02210229082140d1f92 ]

The flushing and non-flushing variants of tdp_mmu_iter_cond_resched have
almost identical implementations. Merge the two functions and add a
flush parameter.

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-12-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index abdd89771b9b..0dd27767c770 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -412,33 +412,13 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
 
-/*
- * Flush the TLB and yield if the MMU lock is contended or this thread needs to
- * return control to the scheduler.
- *
- * If this function yields, it will also reset the tdp_iter's walk over the
- * paging structure and the calling function should allow the iterator to
- * continue its traversal from the paging structure root.
- *
- * Return true if this function yielded, the TLBs were flushed, and the
- * iterator's traversal was reset. Return false if a yield was not needed.
- */
-static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
-{
-	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-		kvm_flush_remote_tlbs(kvm);
-		cond_resched_lock(&kvm->mmu_lock);
-		tdp_iter_refresh_walk(iter);
-		return true;
-	}
-
-	return false;
-}
-
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
  * to the scheduler.
  *
+ * If this function should yield and flush is set, it will perform a remote
+ * TLB flush before yielding.
+ *
  * If this function yields, it will also reset the tdp_iter's walk over the
  * paging structure and the calling function should allow the iterator to
  * continue its traversal from the paging structure root.
@@ -446,9 +426,13 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
  * Return true if this function yielded and the iterator's traversal was reset.
  * Return false if a yield was not needed.
  */
-static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
+					     struct tdp_iter *iter, bool flush)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+
 		cond_resched_lock(&kvm->mmu_lock);
 		tdp_iter_refresh_walk(iter);
 		return true;
@@ -491,7 +475,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
 		flush_needed = !can_yield ||
-			       !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+			       !tdp_mmu_iter_cond_resched(kvm, &iter, true);
 	}
 	return flush_needed;
 }
@@ -864,7 +848,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -923,7 +907,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -1039,7 +1023,7 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 
 	return spte_set;
@@ -1092,7 +1076,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter, true);
 	}
 
 	if (spte_set)
-- 
2.30.2



