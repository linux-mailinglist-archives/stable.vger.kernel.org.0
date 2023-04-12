Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9843A6DEEFB
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjDLIql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjDLIqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4131C7298
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA69630EB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AF1C433D2;
        Wed, 12 Apr 2023 08:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289140;
        bh=aOTydfSydu8LZiuVFPVcxG0ImXMaesNFTYHoo/0CCjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxQlZwH1s5h+ouONXqGZZqS5ifhUmUUa2tvmLT/k94G7M0QeYkryjxNFY5nPWEPpC
         bGs8yAWaSQ3fFPFkgzdoKOrYTh5tcSvjYeUr4vEfaMU0YmXqQ8YXkZwZB+Dq9/i269
         qXT+J1X8FSmhhkqjgGIgpZ6OLrbfEilOfkThvQic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liam Howlett <Liam.Howlett@oracle.com>,
        Jirka Hladky <jhladky@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 6.1 152/164] maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()
Date:   Wed, 12 Apr 2023 10:34:34 +0200
Message-Id: <20230412082843.094437943@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 541e06b772c1aaffb3b6a245ccface36d7107af2 upstream.

Preallocations are common in the VMA code to avoid allocating under
certain locking conditions.  The preallocations must also cover the
worst-case scenario.  Removing the GFP_ZERO flag from the
kmem_cache_alloc() (and bulk variant) calls will reduce the amount of time
spent zeroing memory that may not be used.  Only zero out the necessary
area to keep track of the allocations in the maple state.  Zero the entire
node prior to using it in the tree.

This required internal changes to node counting on allocation, so the test
code is also updated.

This restores some micro-benchmark performance: up to +9% in mmtests mmap1
by my testing +10% to +20% in mmap, mmapaddr, mmapmany tests reported by
Red Hat

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2149636
Link: https://lkml.kernel.org/r/20230105160427.2988454-1-Liam.Howlett@oracle.com
Cc: stable@vger.kernel.org
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c                 |   80 ++++++++++++++++++++-------------------
 tools/testing/radix-tree/maple.c |   18 ++++----
 2 files changed, 52 insertions(+), 46 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -149,13 +149,12 @@ struct maple_subtree_state {
 /* Functions */
 static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 {
-	return kmem_cache_alloc(maple_node_cache, gfp | __GFP_ZERO);
+	return kmem_cache_alloc(maple_node_cache, gfp);
 }
 
 static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 {
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp | __GFP_ZERO, size,
-				     nodes);
+	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
@@ -1123,9 +1122,10 @@ static inline struct maple_node *mas_pop
 {
 	struct maple_alloc *ret, *node = mas->alloc;
 	unsigned long total = mas_allocated(mas);
+	unsigned int req = mas_alloc_req(mas);
 
 	/* nothing or a request pending. */
-	if (unlikely(!total))
+	if (WARN_ON(!total))
 		return NULL;
 
 	if (total == 1) {
@@ -1135,27 +1135,25 @@ static inline struct maple_node *mas_pop
 		goto single_node;
 	}
 
-	if (!node->node_count) {
+	if (node->node_count == 1) {
 		/* Single allocation in this node. */
 		mas->alloc = node->slot[0];
-		node->slot[0] = NULL;
 		mas->alloc->total = node->total - 1;
 		ret = node;
 		goto new_head;
 	}
-
 	node->total--;
-	ret = node->slot[node->node_count];
-	node->slot[node->node_count--] = NULL;
+	ret = node->slot[--node->node_count];
+	node->slot[node->node_count] = NULL;
 
 single_node:
 new_head:
-	ret->total = 0;
-	ret->node_count = 0;
-	if (ret->request_count) {
-		mas_set_alloc_req(mas, ret->request_count + 1);
-		ret->request_count = 0;
+	if (req) {
+		req++;
+		mas_set_alloc_req(mas, req);
 	}
+
+	memset(ret, 0, sizeof(*ret));
 	return (struct maple_node *)ret;
 }
 
@@ -1174,21 +1172,20 @@ static inline void mas_push_node(struct
 	unsigned long count;
 	unsigned int requested = mas_alloc_req(mas);
 
-	memset(reuse, 0, sizeof(*reuse));
 	count = mas_allocated(mas);
 
-	if (count && (head->node_count < MAPLE_ALLOC_SLOTS - 1)) {
-		if (head->slot[0])
-			head->node_count++;
-		head->slot[head->node_count] = reuse;
+	reuse->request_count = 0;
+	reuse->node_count = 0;
+	if (count && (head->node_count < MAPLE_ALLOC_SLOTS)) {
+		head->slot[head->node_count++] = reuse;
 		head->total++;
 		goto done;
 	}
 
 	reuse->total = 1;
 	if ((head) && !((unsigned long)head & 0x1)) {
-		head->request_count = 0;
 		reuse->slot[0] = head;
+		reuse->node_count = 1;
 		reuse->total += head->total;
 	}
 
@@ -1207,7 +1204,6 @@ static inline void mas_alloc_nodes(struc
 {
 	struct maple_alloc *node;
 	unsigned long allocated = mas_allocated(mas);
-	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
 	unsigned int count;
 	void **slots = NULL;
@@ -1223,24 +1219,29 @@ static inline void mas_alloc_nodes(struc
 		WARN_ON(!allocated);
 	}
 
-	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS - 1) {
+	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS) {
 		node = (struct maple_alloc *)mt_alloc_one(gfp);
 		if (!node)
 			goto nomem_one;
 
-		if (allocated)
+		if (allocated) {
 			node->slot[0] = mas->alloc;
+			node->node_count = 1;
+		} else {
+			node->node_count = 0;
+		}
 
-		success++;
 		mas->alloc = node;
+		node->total = ++allocated;
 		requested--;
 	}
 
 	node = mas->alloc;
+	node->request_count = 0;
 	while (requested) {
 		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->slot[0]) {
-			unsigned int offset = node->node_count + 1;
+		if (node->node_count) {
+			unsigned int offset = node->node_count;
 
 			slots = (void **)&node->slot[offset];
 			max_req -= offset;
@@ -1254,15 +1255,13 @@ static inline void mas_alloc_nodes(struc
 			goto nomem_bulk;
 
 		node->node_count += count;
-		/* zero indexed. */
-		if (slots == (void **)&node->slot)
-			node->node_count--;
-
-		success += count;
+		allocated += count;
 		node = node->slot[0];
+		node->node_count = 0;
+		node->request_count = 0;
 		requested -= count;
 	}
-	mas->alloc->total = success;
+	mas->alloc->total = allocated;
 	return;
 
 nomem_bulk:
@@ -1271,7 +1270,7 @@ nomem_bulk:
 nomem_one:
 	mas_set_alloc_req(mas, requested);
 	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
-		mas->alloc->total = success;
+		mas->alloc->total = allocated;
 	mas_set_err(mas, -ENOMEM);
 	return;
 
@@ -5720,6 +5719,7 @@ int mas_preallocate(struct ma_state *mas
 void mas_destroy(struct ma_state *mas)
 {
 	struct maple_alloc *node;
+	unsigned long total;
 
 	/*
 	 * When using mas_for_each() to insert an expected number of elements,
@@ -5742,14 +5742,20 @@ void mas_destroy(struct ma_state *mas)
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
 
-	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
+	total = mas_allocated(mas);
+	while (total) {
 		node = mas->alloc;
 		mas->alloc = node->slot[0];
-		if (node->node_count > 0)
-			mt_free_bulk(node->node_count,
-				     (void __rcu **)&node->slot[1]);
+		if (node->node_count > 1) {
+			size_t count = node->node_count - 1;
+
+			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
+			total -= count;
+		}
 		kmem_cache_free(maple_node_cache, node);
+		total--;
 	}
+
 	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -172,11 +172,11 @@ static noinline void check_new_node(stru
 
 		if (!MAPLE_32BIT) {
 			if (i >= 35)
-				e = i - 35;
+				e = i - 34;
 			else if (i >= 5)
-				e = i - 5;
+				e = i - 4;
 			else if (i >= 2)
-				e = i - 2;
+				e = i - 1;
 		} else {
 			if (i >= 4)
 				e = i - 4;
@@ -304,17 +304,17 @@ static noinline void check_new_node(stru
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	mn = mas_pop_node(&mas); /* get the next node. */
 	MT_BUG_ON(mt, mn == NULL);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 2);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
 
 	mas_push_node(&mas, mn);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	/* Check the limit of pop/push/pop */
 	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 2); /* Request */
@@ -322,14 +322,14 @@ static noinline void check_new_node(stru
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_alloc_req(&mas));
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS);
 	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));


