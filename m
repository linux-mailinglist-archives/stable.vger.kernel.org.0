Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA95353F18
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhDEJKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239063AbhDEJJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C7961393;
        Mon,  5 Apr 2021 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613760;
        bh=9PdRxrs1c2sQnXRC32FmVICCDQ8Cs1JdQhOHuU9wi+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILggRKkVwKMCmsqTgN6IyG7YBYioP5oeI+uo4VVx2pe7OC+vydZE15N9KzIAjcoK5
         w1Gzf2cmQ3TaSDF1JE4ny3cuu3RYcDLQp/0cCLfRqR0LJwujCHq8sFoGMT3pS2w82x
         nLyCpF7Bn09p5Qi/EeyEjBy8zYd4398/g3VGzO6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/126] KVM: x86/mmu: change TDP MMU yield function returns to match cond_resched
Date:   Mon,  5 Apr 2021 10:54:04 +0200
Message-Id: <20210405085033.779794008@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
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
index ffa0bd0e033f..22efd016f05e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -405,8 +405,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
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
@@ -414,18 +421,32 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
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
@@ -461,10 +482,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
@@ -1061,7 +1080,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
 	}
 
 	if (spte_set)
-- 
2.30.1



