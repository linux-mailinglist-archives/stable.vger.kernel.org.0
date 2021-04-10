Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30C835AEB1
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhDJPMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234733AbhDJPMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618067554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6SyHI7qAP6/9cu703oa1R7UT5+/BkdlcwzRYz7m9g7c=;
        b=aNlaEwclZ7DbnvTUtdmEQEONE5w3LUeQ2lrICC32E8KgUmZeGZOCkZ/7MVc452KQBITfIr
        4AFvUs0+1fvq9rOQhCxH/BmvLF9pN07RQ2H5B9nkCuwdMZE2oG0K7kQZxyNzPj7C/nVDmr
        JxylTvaGGX39CEH3sHD4kh1OJH8dru0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-7ANCXBcJP9CIkeoIVeBLWA-1; Sat, 10 Apr 2021 11:12:32 -0400
X-MC-Unique: 7ANCXBcJP9CIkeoIVeBLWA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA8CD81744F;
        Sat, 10 Apr 2021 15:12:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A9935D9D3;
        Sat, 10 Apr 2021 15:12:31 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, sasha@kernel.org
Subject: [PATCH 5.10/5.11 3/9] KVM: x86/mmu: Rename goal_gfn to next_last_level_gfn
Date:   Sat, 10 Apr 2021 11:12:23 -0400
Message-Id: <20210410151229.4062930-4-pbonzini@redhat.com>
In-Reply-To: <20210410151229.4062930-1-pbonzini@redhat.com>
References: <20210410151229.4062930-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
2.26.2


