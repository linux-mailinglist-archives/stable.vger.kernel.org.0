Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2CE35C057
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbhDLJMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238295AbhDLJI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957C66120F;
        Mon, 12 Apr 2021 09:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218253;
        bh=Imyu3iKBedxNrc5glBzPQhzm0Ygxp41v2Wiv7LUcxDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DIbddibpgxptrm0zF27BP0eLj1l5xPsaybEzKXSHvBqX3qgJo7+uwajdcW7V0vdj
         e16W69/M+EIm7/0h+4Aof8q3Q96vpmWj0wLKWTd6JdY81hy19ysqZzwULNPXf0I/pp
         JP/RwFV4Eitbr/4zy4et/QngZ67ud9tn0+FjWG8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 093/210] KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn
Date:   Mon, 12 Apr 2021 10:39:58 +0200
Message-Id: <20210412084019.116920212@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

[ Upstream commit 74953d3530280dc53256054e1906f58d07bfba44 ]

The goal_gfn field in tdp_iter can be misleading as it implies that it
is the iterator's final goal. It is really a target for the lowest gfn
mapped by the leaf level SPTE the iterator will traverse towards. Change
the field's name to be more precise.

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210202185734.1680553-13-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_iter.c | 20 ++++++++++----------
 arch/x86/kvm/mmu/tdp_iter.h |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 87b7e16911db..9917c55b7d24 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -22,21 +22,21 @@ static gfn_t round_gfn_for_level(gfn_t gfn, int level)
 
 /*
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
- * rooted at root_pt, starting with the walk to translate goal_gfn.
+ * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
-		    int min_level, gfn_t goal_gfn)
+		    int min_level, gfn_t next_last_level_gfn)
 {
 	WARN_ON(root_level < 1);
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
-	iter->goal_gfn = goal_gfn;
+	iter->next_last_level_gfn = next_last_level_gfn;
 	iter->root_level = root_level;
 	iter->min_level = min_level;
 	iter->level = root_level;
 	iter->pt_path[iter->level - 1] = root_pt;
 
-	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	iter->valid = true;
@@ -82,7 +82,7 @@ static bool try_step_down(struct tdp_iter *iter)
 
 	iter->level--;
 	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	return true;
@@ -106,7 +106,7 @@ static bool try_step_side(struct tdp_iter *iter)
 		return false;
 
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
-	iter->goal_gfn = iter->gfn;
+	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
 	iter->old_spte = READ_ONCE(*iter->sptep);
 
@@ -166,13 +166,13 @@ void tdp_iter_next(struct tdp_iter *iter)
  */
 void tdp_iter_refresh_walk(struct tdp_iter *iter)
 {
-	gfn_t goal_gfn = iter->goal_gfn;
+	gfn_t next_last_level_gfn = iter->next_last_level_gfn;
 
-	if (iter->gfn > goal_gfn)
-		goal_gfn = iter->gfn;
+	if (iter->gfn > next_last_level_gfn)
+		next_last_level_gfn = iter->gfn;
 
 	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
-		       iter->root_level, iter->min_level, goal_gfn);
+		       iter->root_level, iter->min_level, next_last_level_gfn);
 }
 
 u64 *tdp_iter_root_pt(struct tdp_iter *iter)
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 47170d0dc98e..b2dd269c631f 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -15,7 +15,7 @@ struct tdp_iter {
 	 * The iterator will traverse the paging structure towards the mapping
 	 * for this GFN.
 	 */
-	gfn_t goal_gfn;
+	gfn_t next_last_level_gfn;
 	/* Pointers to the page tables traversed to reach the current SPTE */
 	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
@@ -52,7 +52,7 @@ struct tdp_iter {
 u64 *spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
-		    int min_level, gfn_t goal_gfn);
+		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_refresh_walk(struct tdp_iter *iter);
 u64 *tdp_iter_root_pt(struct tdp_iter *iter);
-- 
2.30.2



