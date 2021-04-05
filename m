Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494DD354075
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhDEJSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240643AbhDEJR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FDC61002;
        Mon,  5 Apr 2021 09:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614272;
        bh=ed7zGFRyj9lYWwEiWmJdD4qTh+LC8HNBqzgp7RsaQ3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4vO5MaeOFCILhSYCxUFYMsAS22uVNLuLtHzCfDgfJmRq3Ty7Csu7+rg0NSGbar7Z
         z+1466a/nQW9g4OXTumh9+6PEqGfNWX0o+EvFktVkZJXh43bfeqYot/grAEjUa9mPO
         SFvR0fCjfdF+MlYAdW9eISr9VsP5sNlDF+Y6ibQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 111/152] KVM: x86/mmu: Factor out handling of removed page tables
Date:   Mon,  5 Apr 2021 10:54:20 +0200
Message-Id: <20210405085037.838787784@linuxfoundation.org>
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

[ Upstream commit a066e61f13cf4b17d043ad8bea0cdde2b1e5ee49 ]

Factor out the code to handle a disconnected subtree of the TDP paging
structure from the code to handle the change to an individual SPTE.
Future commits will build on this to allow asynchronous page freeing.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

Message-Id: <20210202185734.1680553-6-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 71 ++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3a8bbc812a28..3efaa8b44e45 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -234,6 +234,45 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+/**
+ * handle_removed_tdp_mmu_page - handle a pt removed from the TDP structure
+ *
+ * @kvm: kvm instance
+ * @pt: the page removed from the paging structure
+ *
+ * Given a page table that has been removed from the TDP paging structure,
+ * iterates through the page table to clear SPTEs and free child page tables.
+ */
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(pt);
+	int level = sp->role.level;
+	gfn_t gfn = sp->gfn;
+	u64 old_child_spte;
+	int i;
+
+	trace_kvm_mmu_prepare_zap_page(sp);
+
+	list_del(&sp->link);
+
+	if (sp->lpage_disallowed)
+		unaccount_huge_nx_page(kvm, sp);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		old_child_spte = READ_ONCE(*(pt + i));
+		WRITE_ONCE(*(pt + i), 0);
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
+			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
+			old_child_spte, 0, level - 1);
+	}
+
+	kvm_flush_remote_tlbs_with_address(kvm, gfn,
+					   KVM_PAGES_PER_HPAGE(level));
+
+	free_page((unsigned long)pt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -254,10 +293,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-	u64 *pt;
-	struct kvm_mmu_page *sp;
-	u64 old_child_spte;
-	int i;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -321,31 +356,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.
 	 */
-	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
-		pt = spte_to_child_pt(old_spte, level);
-		sp = sptep_to_sp(pt);
-
-		trace_kvm_mmu_prepare_zap_page(sp);
-
-		list_del(&sp->link);
-
-		if (sp->lpage_disallowed)
-			unaccount_huge_nx_page(kvm, sp);
-
-		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-			old_child_spte = READ_ONCE(*(pt + i));
-			WRITE_ONCE(*(pt + i), 0);
-			handle_changed_spte(kvm, as_id,
-				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-				old_child_spte, 0, level - 1);
-		}
-
-		kvm_flush_remote_tlbs_with_address(kvm, gfn,
-						   KVM_PAGES_PER_HPAGE(level));
-
-		free_page((unsigned long)pt);
-		kmem_cache_free(mmu_page_header_cache, sp);
-	}
+	if (was_present && !was_leaf && (pfn_changed || !is_present))
+		handle_removed_tdp_mmu_page(kvm,
+				spte_to_child_pt(old_spte, level));
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-- 
2.30.1



