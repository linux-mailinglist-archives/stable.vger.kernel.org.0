Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF25AB0C9
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbiIBM7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbiIBM7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE01D345D;
        Fri,  2 Sep 2022 05:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F02156211D;
        Fri,  2 Sep 2022 12:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CB0C433C1;
        Fri,  2 Sep 2022 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122342;
        bh=ORU/2/OmjdcfBY6KpJu60URZdtECRnBHqc7OGRlwUpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoccmGXy+NMSUy/W7NPSv261L4b1+5Rl44jv1RyCKmzQQP+J67CncKUo7cuLl33A5
         6o3G9rgn74n7Ml5Y1JEU/Ye1gVJu/wrVBOxMSAmti2FNYpGRr2q2stk9kbjrQ1YqF/
         pgjMhrVScH2Ip9yVJOlEGnYWH6RoiUk+Jojr1O1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 17/37] mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse
Date:   Fri,  2 Sep 2022 14:19:39 +0200
Message-Id: <20220902121359.715096766@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 2555283eb40df89945557273121e9393ef9b542b upstream.

anon_vma->degree tracks the combined number of child anon_vmas and VMAs
that use the anon_vma as their ->anon_vma.

anon_vma_clone() then assumes that for any anon_vma attached to
src->anon_vma_chain other than src->anon_vma, it is impossible for it to
be a leaf node of the VMA tree, meaning that for such VMAs ->degree is
elevated by 1 because of a child anon_vma, meaning that if ->degree
equals 1 there are no VMAs that use the anon_vma as their ->anon_vma.

This assumption is wrong because the ->degree optimization leads to leaf
nodes being abandoned on anon_vma_clone() - an existing anon_vma is
reused and no new parent-child relationship is created.  So it is
possible to reuse an anon_vma for one VMA while it is still tied to
another VMA.

This is an issue because is_mergeable_anon_vma() and its callers assume
that if two VMAs have the same ->anon_vma, the list of anon_vmas
attached to the VMAs is guaranteed to be the same.  When this assumption
is violated, vma_merge() can merge pages into a VMA that is not attached
to the corresponding anon_vma, leading to dangling page->mapping
pointers that will be dereferenced during rmap walks.

Fix it by separately tracking the number of child anon_vmas and the
number of VMAs using the anon_vma as their ->anon_vma.

Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
Cc: stable@kernel.org
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    7 +++++--
 mm/rmap.c            |   29 ++++++++++++++++-------------
 2 files changed, 21 insertions(+), 15 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -39,12 +39,15 @@ struct anon_vma {
 	atomic_t refcount;
 
 	/*
-	 * Count of child anon_vmas and VMAs which points to this anon_vma.
+	 * Count of child anon_vmas. Equals to the count of all anon_vmas that
+	 * have ->parent pointing to this one, including itself.
 	 *
 	 * This counter is used for making decision about reusing anon_vma
 	 * instead of forking new one. See comments in function anon_vma_clone.
 	 */
-	unsigned degree;
+	unsigned long num_children;
+	/* Count of VMAs whose ->anon_vma pointer points to this object. */
+	unsigned long num_active_vmas;
 
 	struct anon_vma *parent;	/* Parent of this anon_vma */
 
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -89,7 +89,8 @@ static inline struct anon_vma *anon_vma_
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
 		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->degree = 1;	/* Reference for first vma */
+		anon_vma->num_children = 0;
+		anon_vma->num_active_vmas = 0;
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -197,6 +198,7 @@ int __anon_vma_prepare(struct vm_area_st
 		anon_vma = anon_vma_alloc();
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
+		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
 	}
 
@@ -206,8 +208,7 @@ int __anon_vma_prepare(struct vm_area_st
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_link(vma, avc, anon_vma);
-		/* vma reference or self-parent link for new root */
-		anon_vma->degree++;
+		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
 	}
@@ -292,19 +293,19 @@ int anon_vma_clone(struct vm_area_struct
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
-		 * Reuse existing anon_vma if its degree lower than two,
-		 * that means it has no vma and only one anon_vma child.
+		 * Reuse existing anon_vma if it has no vma and only one
+		 * anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
-		 * will always reuse it. Root anon_vma is never reused:
+		 * Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
 		if (!dst->anon_vma && src->anon_vma &&
-		    anon_vma != src->anon_vma && anon_vma->degree < 2)
+		    anon_vma->num_children < 2 &&
+		    anon_vma->num_active_vmas == 0)
 			dst->anon_vma = anon_vma;
 	}
 	if (dst->anon_vma)
-		dst->anon_vma->degree++;
+		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
 
@@ -354,6 +355,7 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma = anon_vma_alloc();
 	if (!anon_vma)
 		goto out_error;
+	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
@@ -374,7 +376,7 @@ int anon_vma_fork(struct vm_area_struct
 	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->degree++;
+	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
@@ -406,7 +408,7 @@ void unlink_anon_vmas(struct vm_area_str
 		 * to free them outside the lock.
 		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root.rb_root)) {
-			anon_vma->parent->degree--;
+			anon_vma->parent->num_children--;
 			continue;
 		}
 
@@ -414,7 +416,7 @@ void unlink_anon_vmas(struct vm_area_str
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma)
-		vma->anon_vma->degree--;
+		vma->anon_vma->num_active_vmas--;
 	unlock_anon_vma_root(root);
 
 	/*
@@ -425,7 +427,8 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		VM_WARN_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->num_children);
+		VM_WARN_ON(anon_vma->num_active_vmas);
 		put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);


