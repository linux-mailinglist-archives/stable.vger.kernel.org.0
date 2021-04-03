Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD535330E
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 10:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhDCIHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 04:07:20 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52561 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231575AbhDCIHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 04:07:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 871CAEC5;
        Sat,  3 Apr 2021 04:07:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 04:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lS6tv9
        SZCb77urNdHzre/inxwZ8i4xVj/2NI5kD8Bg0=; b=lACdbI8yO6Oz893E6r7ZJM
        6COGZssOX7p2I6t3P/8C3uFA09FBuIo1dyVXDujazlOQObFLjGeio0kCFFg7ZxX3
        bMKjrvMcjzHxatVgAy5VtcG/txmQEpdISFplN0GoEmJBFvfwutSmciQAoTqMhHLh
        vCKdrc++Gn1GFr31Uh9VbuIgTF02LVcgnGx1hG2U3l8WCS/iLSw7m7wSa1mXPnri
        LvuFFoZdSc3IPn4D73KBAuV2GtCRFm6YviKTyIXWqizHQxUHJwX+fBr0zt0Em5Qu
        t/8T48q1jtLGCa8HXPGVxETVOkKCvK3wRICAQhTatNA6UVsV+vQroI7ACwU8I+fw
        ==
X-ME-Sender: <xms:NSJoYMgGQreYAApYTyv2tThbApRgs7lBoGoGAb1hdo8Kw3MGMCvcog>
    <xme:NSJoYFCvilFiR15044QaVKlj1BtpDqY450pL46vrffpHc5Ht7yrW_cIDvbSGs7dAq
    MrA-ZKnt_ICzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:NSJoYEHdrkbse9IrXG-tm42q39oTRW33sYMLaWdmGFrnTcQ3zJc2Wg>
    <xmx:NSJoYNQGDM769xL0eStqj4ZnAWKsFo8TpdQ-FWZwMWyuBktqaVGfzQ>
    <xmx:NSJoYJwk9ejtjM8yIsA71kejW2l4orq0R7E1Ji05984cr6Y6g27fTA>
    <xmx:NSJoYKqYxcucZ4NRG9uvCbnN2DIRSTfArIAu_gFr8KbRxEgrpPGpn93HnoA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A227124005B;
        Sat,  3 Apr 2021 04:07:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed" failed to apply to 5.11-stable tree
To:     bgardon@google.com, pbonzini@redhat.com, pfeiner@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Apr 2021 10:07:08 +0200
Message-ID: <1617437228185186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1af4a96025b33587ca953c7ef12a1b20c6e70412 Mon Sep 17 00:00:00 2001
From: Ben Gardon <bgardon@google.com>
Date: Tue, 2 Feb 2021 10:57:20 -0800
Subject: [PATCH] KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed

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

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7cfc0639b1ef..c8a1149cb229 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -501,6 +501,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -515,9 +521,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-
-		flush_needed = !(can_yield &&
-				 tdp_mmu_iter_cond_resched(kvm, &iter, true));
+		flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -880,6 +884,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -888,8 +895,6 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -933,6 +938,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
 				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
@@ -947,8 +955,6 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -1056,6 +1062,9 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool spte_set = false;
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+			continue;
+
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
@@ -1063,8 +1072,6 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
-
-		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 
 	return spte_set;
@@ -1105,6 +1112,11 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
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
@@ -1116,7 +1128,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter, true);
+		spte_set = true;
 	}
 
 	if (spte_set)

