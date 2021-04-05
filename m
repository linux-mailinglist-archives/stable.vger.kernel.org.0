Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDB635403C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239120AbhDEJQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240743AbhDEJQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5937860FE4;
        Mon,  5 Apr 2021 09:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614188;
        bh=u8VwryUUxQM9tUhn+ulhhIFfOmHAp8egZEO/fAVA63E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA56dsV+BoUlg0hbyDNWm2ZKlvv0p6lP1G/9Ofm42V9iv0LipxTi2oNg1e3EJor74
         itN6Q5Hsfuh90uyNEwG3egAU7LhTh98r3xN+r1LoEbkRt37s0Y6Pk7QI10A4sNggc6
         IeKgu3jghEdZnFarGyol+J3TCcpeENs8gqDzZXVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 117/152] KVM: x86/mmu: Factor out functions to add/remove TDP MMU pages
Date:   Mon,  5 Apr 2021 10:54:26 +0200
Message-Id: <20210405085038.041851116@linuxfoundation.org>
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

[ Upstream commit a9442f594147f95307f691cfba0c31e25dc79b9d ]

Move the work of adding and removing TDP MMU pages to/from  "secondary"
data structures to helper functions. These functions will be built on in
future commits to enable MMU operations to proceed (mostly) in parallel.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-20-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 47 +++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4a2b8844f00f..bc49a5b90086 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -262,6 +262,39 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+/**
+ * tdp_mmu_link_page - Add a new page to the list of pages used by the TDP MMU
+ *
+ * @kvm: kvm instance
+ * @sp: the new page
+ * @account_nx: This page replaces a NX large page and should be marked for
+ *		eventual reclaim.
+ */
+static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			      bool account_nx)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
+	if (account_nx)
+		account_huge_nx_page(kvm, sp);
+}
+
+/**
+ * tdp_mmu_unlink_page - Remove page from the list of pages used by the TDP MMU
+ *
+ * @kvm: kvm instance
+ * @sp: the page to be removed
+ */
+static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	list_del(&sp->link);
+	if (sp->lpage_disallowed)
+		unaccount_huge_nx_page(kvm, sp);
+}
+
 /**
  * handle_removed_tdp_mmu_page - handle a pt removed from the TDP structure
  *
@@ -281,10 +314,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	list_del(&sp->link);
-
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	tdp_mmu_unlink_page(kvm, sp);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		old_child_spte = READ_ONCE(*(pt + i));
@@ -706,15 +736,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
-			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
 			child_pt = sp->spt;
+
+			tdp_mmu_link_page(vcpu->kvm, sp,
+					  huge_page_disallowed &&
+					  req_level >= iter.level);
+
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
 			trace_kvm_mmu_get_page(sp, true);
-			if (huge_page_disallowed && req_level >= iter.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-
 			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
 		}
 	}
-- 
2.30.1



