Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F2C354033
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbhDEJQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240699AbhDEJQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE5760FE4;
        Mon,  5 Apr 2021 09:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614178;
        bh=T60iLj0ENqxBxCnlQaz36mCq+YzMPA6UaSto3kUzanc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuKVNWnAYl6Fk6ruYCFdiPE8gDS3AWa09LTKIMn9zmq/ZgYevA3s9e5ST0AFpcwYX
         BohGjB4kQ06mIJ95uLcX+DCiUqFN5T7NcMF4aM43kEHYboV4udOw2MTklj79IwFmgA
         FqLv2yfFVa+kY6RSh3rry5kR6f87kTRbHcJLzpc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 105/152] KVM: x86/mmu: change TDP MMU yield function returns to match cond_resched
Date:   Mon,  5 Apr 2021 10:54:14 +0200
Message-Id: <20210405085037.645838880@linuxfoundation.org>
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

[ Upstream commit e28a436ca4f65384cceaf3f4da0e00aa74244e6a ]

Currently the TDP MMU yield / cond_resched functions either return
nothing or return true if the TLBs were not flushed. These are confusing
semantics, especially when making control flow decisions in calling
functions.

To clean things up, change both functions to have the same
return value semantics as cond_resched: true if the thread yielded,
false if it did not. If the function yielded in the _flush_ version,
then the TLBs will have been flushed.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-2-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 39 ++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 17976998bffb..abdd89771b9b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -413,8 +413,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 			 _mmu->shadow_root_level, _start, _end)
 
 /*
- * Flush the TLB if the process should drop kvm->mmu_lock.
- * Return whether the caller still needs to flush the tlb.
+ * Flush the TLB and yield if the MMU lock is contended or this thread needs to
+ * return control to the scheduler.
+ *
+ * If this function yields, it will also reset the tdp_iter's walk over the
+ * paging structure and the calling function should allow the iterator to
+ * continue its traversal from the paging structure root.
+ *
+ * Return true if this function yielded, the TLBs were flushed, and the
+ * iterator's traversal was reset. Return false if a yield was not needed.
  */
 static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
@@ -422,18 +429,32 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
 		kvm_flush_remote_tlbs(kvm);
 		cond_resched_lock(&kvm->mmu_lock);
 		tdp_iter_refresh_walk(iter);
-		return false;
-	} else {
 		return true;
 	}
+
+	return false;
 }
 
-static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+/*
+ * Yield if the MMU lock is contended or this thread needs to return control
+ * to the scheduler.
+ *
+ * If this function yields, it will also reset the tdp_iter's walk over the
+ * paging structure and the calling function should allow the iterator to
+ * continue its traversal from the paging structure root.
+ *
+ * Return true if this function yielded and the iterator's traversal was reset.
+ * Return false if a yield was not needed.
+ */
+static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 		cond_resched_lock(&kvm->mmu_lock);
 		tdp_iter_refresh_walk(iter);
+		return true;
 	}
+
+	return false;
 }
 
 /*
@@ -469,10 +490,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		if (can_yield)
-			flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
-		else
-			flush_needed = true;
+		flush_needed = !can_yield ||
+			       !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
 	}
 	return flush_needed;
 }
@@ -1073,7 +1092,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
 	}
 
 	if (spte_set)
-- 
2.30.1



