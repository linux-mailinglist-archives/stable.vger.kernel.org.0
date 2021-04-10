Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443C135AEBD
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhDJPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234871AbhDJPMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oktMs7lkpM0GXdwO2HUaIBMFKeDXHdYaotmkuKpmYt0=;
        b=WmnuYlwLOEOkIWykC+yI/rl9yv/30JRueLyfswHzLm9Ou0wH824APKwzqzHqnwjnqE59r5
        p3rura+BoEhr5AlRJTCz7h9YQtotZ/iAhDiy1QlPSXqRK1L4gXibiWY2rXvToAq4/eHxli
        uoDkUmQZ1rr6N0NSKxNteb16bfL2Ydo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-KwGpkgFnNFOQ8jBIPEHtNA-1; Sat, 10 Apr 2021 11:12:34 -0400
X-MC-Unique: KwGpkgFnNFOQ8jBIPEHtNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F403D1856A64;
        Sat, 10 Apr 2021 15:12:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A43B85D9D3;
        Sat, 10 Apr 2021 15:12:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 6/9] KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap
Date:   Sat, 10 Apr 2021 11:12:26 -0400
Message-Id: <20210410151229.4062930-7-pbonzini@redhat.com>
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a835429cda91621fca915d80672a157b47738afb ]

When flushing a range of GFNs across multiple roots, ensure any pending
flush from a previous root is honored before yielding while walking the
tables of the current root.

Note, kvm_tdp_mmu_zap_gfn_range() now intentionally overwrites its local
"flush" with the result to avoid redundant flushes.  zap_gfn_range()
preserves and return the incoming "flush", unless of course the flush was
performed prior to yielding and no new flush was triggered.

Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
Cc: stable@vger.kernel.org
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210325200119.1359384-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0567286fba39..0bb62b89476a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -105,7 +105,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -118,7 +118,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -461,18 +461,19 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
- * operation can cause a soft lockup.
+ * operation can cause a soft lockup.  Note, in some use cases a flush may be
+ * required by prior actions.  Ensure the pending flush is performed prior to
+ * yielding.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield)
+			  gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
 	struct tdp_iter iter;
-	bool flush_needed = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
-			flush_needed = false;
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -490,9 +491,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush_needed = true;
+		flush = true;
 	}
-	return flush_needed;
+
+	return flush;
 }
 
 /*
@@ -507,7 +509,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush |= zap_gfn_range(kvm, root, start, end, true);
+		flush = zap_gfn_range(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -701,7 +703,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-- 
2.26.2


