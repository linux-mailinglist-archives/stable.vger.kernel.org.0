Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CAE5AAE52
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbiIBMVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiIBMVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF17C6E8C;
        Fri,  2 Sep 2022 05:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA3B620E6;
        Fri,  2 Sep 2022 12:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4B9C43140;
        Fri,  2 Sep 2022 12:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121279;
        bh=0QXl4JqaFq4iPz9u4o3OB7ub7UpUJipo4GZ/K8OT0eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqlo0brOng6HJAro3Y2OrAYDOWOlObDJ7P6+gbs0EUbVxoIUIAfdlQ4EILWekNuR0
         ZmiPckaJDLsbcUaqX3MjnioEpJRUxFvKSapfrYFIXg0RyXUdFCuLDPWWeZYFPUhJql
         F1lGMTE9ulMe+0VFy4h4vySe5PQOvWLPidnIKOPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 30/31] mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse
Date:   Fri,  2 Sep 2022 14:18:56 +0200
Message-Id: <20220902121357.839647776@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
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
[manually fixed up different indentation in stable]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    7 +++++--
 mm/rmap.c            |   31 +++++++++++++++++--------------
 2 files changed, 22 insertions(+), 16 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -37,12 +37,15 @@ struct anon_vma {
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
@@ -78,7 +78,8 @@ static inline struct anon_vma *anon_vma_
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
 		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->degree = 1;	/* Reference for first vma */
+		anon_vma->num_children = 0;
+		anon_vma->num_active_vmas = 0;
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -187,6 +188,7 @@ int anon_vma_prepare(struct vm_area_stru
 			anon_vma = anon_vma_alloc();
 			if (unlikely(!anon_vma))
 				goto out_enomem_free_avc;
+			anon_vma->num_children++; /* self-parent link for new root */
 			allocated = anon_vma;
 		}
 
@@ -196,8 +198,7 @@ int anon_vma_prepare(struct vm_area_stru
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
 			anon_vma_chain_link(vma, avc, anon_vma);
-			/* vma reference or self-parent link for new root */
-			anon_vma->degree++;
+			anon_vma->num_active_vmas++;
 			allocated = NULL;
 			avc = NULL;
 		}
@@ -276,19 +277,19 @@ int anon_vma_clone(struct vm_area_struct
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
-		if (!dst->anon_vma && anon_vma != src->anon_vma &&
-				anon_vma->degree < 2)
+		if (!dst->anon_vma &&
+		    anon_vma->num_children < 2 &&
+		    anon_vma->num_active_vmas == 0)
 			dst->anon_vma = anon_vma;
 	}
 	if (dst->anon_vma)
-		dst->anon_vma->degree++;
+		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
 
@@ -338,6 +339,7 @@ int anon_vma_fork(struct vm_area_struct
 	anon_vma = anon_vma_alloc();
 	if (!anon_vma)
 		goto out_error;
+	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
@@ -358,7 +360,7 @@ int anon_vma_fork(struct vm_area_struct
 	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->degree++;
+	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
@@ -390,7 +392,7 @@ void unlink_anon_vmas(struct vm_area_str
 		 * to free them outside the lock.
 		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root)) {
-			anon_vma->parent->degree--;
+			anon_vma->parent->num_children--;
 			continue;
 		}
 
@@ -398,7 +400,7 @@ void unlink_anon_vmas(struct vm_area_str
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma)
-		vma->anon_vma->degree--;
+		vma->anon_vma->num_active_vmas--;
 	unlock_anon_vma_root(root);
 
 	/*
@@ -409,7 +411,8 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		VM_WARN_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->num_children);
+		VM_WARN_ON(anon_vma->num_active_vmas);
 		put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);


