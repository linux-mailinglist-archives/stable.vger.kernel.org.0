Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C0B5EA3E9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiIZLgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbiIZLef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BCE6DFA1;
        Mon, 26 Sep 2022 03:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 853AEB801BF;
        Mon, 26 Sep 2022 10:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF88DC433C1;
        Mon, 26 Sep 2022 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188896;
        bh=QlSD194E8UHIoxw/b4CWEX4R9SntIHtgTWnYrvSgo8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eoap5wtvuNb81myh0EnLJ1a/mVWQkDlJ893Ae5sKSe4Lme5C3JUbP3QLe790ve78U
         +uaXTyK9dCfI+LIYAhUM6KW4yqI93p9T8UMFBspxgtlY3DL9ZfCiqJV448FFLf+nXx
         lEwXOFNV2n7hJT/GXMdCfQm6mqL9Bpk/q+Xj39W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/148] KVM: x86/mmu: Fold rmap_recycle into rmap_add
Date:   Mon, 26 Sep 2022 12:12:31 +0200
Message-Id: <20220926100800.523753916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

[ Upstream commit 68be1306caea8948738cab04014ca4506b590d38 ]

Consolidate rmap_recycle and rmap_add into a single function since they
are only ever called together (and only from one place). This has a nice
side effect of eliminating an extra kvm_vcpu_gfn_to_memslot(). In
addition it makes mmu_set_spte(), which is a very long function, a
little shorter.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-3-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 604f533262ae ("KVM: x86/mmu: add missing update to max_mmu_rmap_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f267cca9fe09..ba1749a770eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1071,20 +1071,6 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_head *rmap_head;
-
-	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	return pte_list_add(vcpu, spte, rmap_head);
-}
-
-
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_memslots *slots;
@@ -1097,9 +1083,9 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 
 	/*
-	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
-	 * context of a vCPU so have to determine which memslots to use based
-	 * on context information in sp->role.
+	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
+	 * so we have to determine which memslots to use based on context
+	 * information in sp->role.
 	 */
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
@@ -1639,19 +1625,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
-	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
+	struct kvm_rmap_head *rmap_head;
+	int rmap_count;
 
 	sp = sptep_to_sp(spte);
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
-	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
+		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_flush_remote_tlbs_with_address(
+				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2718,7 +2709,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			bool host_writable)
 {
 	int was_rmapped = 0;
-	int rmap_count;
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
@@ -2778,9 +2768,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (!was_rmapped) {
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_count = rmap_add(vcpu, sptep, gfn);
-		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, sptep, gfn);
+		rmap_add(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.35.1



