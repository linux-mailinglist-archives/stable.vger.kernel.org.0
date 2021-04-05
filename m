Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1C353F45
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhDEJKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239214AbhDEJJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48CB461394;
        Mon,  5 Apr 2021 09:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613771;
        bh=6+h6WVR2L38idR3DW+NBHZIA0fWBqAp+53ZIp21wA44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toW/uriiA8RlKN0SlT+V8Qogq3IzkwA3/UJOHsXwOQWZ/hjCok9fNyHP5IiyS4FX0
         J19S5tF5PU8mHS/wdrf9plIL27UqPCkzRwyMbnS0EyWf4uKpDB06l5g0ghnTl1XBSE
         yyXtOW2amvGYZrOQB9KWOzvybLeeIGRhB2lE0gPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/126] KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed
Date:   Mon,  5 Apr 2021 10:54:08 +0200
Message-Id: <20210405085033.914881679@linuxfoundation.org>
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

[ Upstream commit 1af4a96025b33587ca953c7ef12a1b20c6e70412 ]

Given certain conditions, some TDP MMU functions may not yield
reliably / frequently enough. For example, if a paging structure was
very large but had few, if any writable entries, wrprot_gfn_range
could traverse many entries before finding a writable entry and yielding
because the check for yielding only happens after an SPTE is modified.

Fix this issue by moving the yield to the beginning of the loop.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

Message-Id: <20210202185734.1680553-15-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f0bc5d3ce3d4..0d17457f1c84 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -462,6 +462,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool flush_needed = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (can_yield &&
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
+			flush_needed = false;
+			continue;
+		}
+
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -476,9 +482,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-
-		flush_needed = !(can_yield &&
-				 tdp_mmu_iter_cond_resched(kvm, &iter, true));
+		flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -838,6 +842,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -846,8 +853,6 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -891,6 +896,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
 				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
@@ -905,8 +913,6 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -1014,6 +1020,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -1021,8 +1030,6 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 
 	return spte_set;
@@ -1063,6 +1070,11 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	bool spte_set = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
+			spte_set = false;
+			continue;
+		}
+
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1075,7 +1087,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter, true);
+		spte_set = true;
 	}
 
 	if (spte_set)
-- 
2.30.1



