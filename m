Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2D353F23
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbhDEJKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239354AbhDEJJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4457061393;
        Mon,  5 Apr 2021 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613785;
        bh=6LPeolNlHI+0JREf+xrum12fwofLfxMTazazS8w0K8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtbfWv8yJlO8aq4DOTKJagoO7El7TETTGPZAGf02SjM47xR+yjbFb5VRXUnovw0oB
         tiTeJZ4p8kgHldWto/+vkDeN6JQdArueU30Xdg4AucvIs3OrJw8PEDidvm5+HB/NJi
         PugiyPKmEAmmYXlRWcqpyZ46SpVeVIaT1rT1Cy/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/126] KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap
Date:   Mon,  5 Apr 2021 10:54:13 +0200
Message-Id: <20210405085034.075409532@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a54a9ed979d1..34ef3e1a0f84 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -111,7 +111,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -124,7 +124,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -504,20 +504,21 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
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
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
-			flush_needed = false;
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -535,11 +536,11 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush_needed = true;
+		flush = true;
 	}
 
 	rcu_read_unlock();
-	return flush_needed;
+	return flush;
 }
 
 /*
@@ -554,7 +555,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush |= zap_gfn_range(kvm, root, start, end, true);
+		flush = zap_gfn_range(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -757,7 +758,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-- 
2.30.1



