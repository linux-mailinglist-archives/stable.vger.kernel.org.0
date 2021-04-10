Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC835AEB8
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhDJPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234825AbhDJPMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzhRrfCt9pWIBDC08ZfuRJUiSWLNiQTMxzXRQmQs4PQ=;
        b=EoALCMDJIDRxo15RxuWGWF1Y7/pzpIRahg8EGzqkmcfB2+8r3UwzK8P8+GRR5qUGfkZTpf
        oPA9PAGoFZOkPGlLyhwcM5Qhc2W+Y2YIHc4HHoTOhapxtPFcOGyC0hQScgmlNaYxP2IEFl
        hwDDjuijEfh8inXaXWZxxqoZMUFp4qA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-TrbDwnz0MKWI27-gSgq4Rw-1; Sat, 10 Apr 2021 11:12:32 -0400
X-MC-Unique: TrbDwnz0MKWI27-gSgq4Rw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4007F5B38C;
        Sat, 10 Apr 2021 15:12:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4C0E18A5A;
        Sat, 10 Apr 2021 15:12:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 2/9] KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
Date:   Sat, 10 Apr 2021 11:12:22 -0400
Message-Id: <20210410151229.4062930-3-pbonzini@redhat.com>
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
2.26.2


