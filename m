Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871266D8C65
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjDFBGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbjDFBGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0501BF;
        Wed,  5 Apr 2023 18:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D9364296;
        Thu,  6 Apr 2023 01:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5104CC433EF;
        Thu,  6 Apr 2023 01:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743205;
        bh=tLXrapMBSD8eve0LjKIuHXgghMFY0rB6PhuyjgtgxJE=;
        h=Date:To:From:Subject:From;
        b=zjHnOzCRscnPd/zlLKpPZrPBe5PqyhTRPEQsnOCeUrEjA3SMB3leS1IXPJtXvgdTk
         Xb+oonwji30LhXfTBHxhZPC5fL70SXgetni33mykwzAIDaSI3UVdrpfsKMwMe0FLHd
         iGf37yVZJ7Ojg67gG0NPrp0fL4BHqzRsncwRDdD4=
Date:   Wed, 05 Apr 2023 18:06:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, surenb@google.com, stable@vger.kernel.org,
        songliubraving@fb.com, soheil@google.com, shakeelb@google.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        posk@google.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, mingo@redhat.com, minchan@google.com,
        michalechner92@googlemail.com, mhocko@suse.com,
        mgorman@techsingularity.net, luto@kernel.org, lstoakes@gmail.com,
        ldufour@linux.ibm.com, kent.overstreet@linux.dev,
        joelaf@google.com, jannh@google.com, hughd@google.com,
        hannes@cmpxchg.org, gthelen@google.com, edumazet@google.com,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        chriscli@google.com, bigeasy@linutronix.de,
        axelrasmussen@google.com, arjunroy@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-be-more-cautious-about-dead-nodes.patch removed from -mm tree
Message-Id: <20230406010645.5104CC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: be more cautious about dead nodes
has been removed from the -mm tree.  Its filename was
     maple_tree-be-more-cautious-about-dead-nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <Liam.Howlett@oracle.com>
Subject: maple_tree: be more cautious about dead nodes
Date: Mon, 27 Feb 2023 09:36:00 -0800

Patch series "Fix VMA tree modification under mmap read lock".

Syzbot reported a BUG_ON in mm/mmap.c which was found to be caused by an
inconsistency between threads walking the VMA maple tree.  The
inconsistency is caused by the page fault handler modifying the maple tree
while holding the mmap_lock for read.

This only happens for stack VMAs.  We had thought this was safe as it only
modifies a single pivot in the tree.  Unfortunately, syzbot constructed a
test case where the stack had no guard page and grew the stack to abut the
next VMA.  This causes us to delete the NULL entry between the two VMAs
and rewrite the node.

We considered several options for fixing this, including dropping the
mmap_lock, then reacquiring it for write; and relaxing the definition of
the tree to permit a zero-length NULL entry in the node.  We decided the
best option was to backport some of the RCU patches from -next, which
solve the problem by allocating a new node and RCU-freeing the old node. 
Since the problem exists in 6.1, we preferred a solution which is similar
to the one we intended to merge next merge window.

These patches have been in -next since next-20230301, and have received
intensive testing in Android as part of the RCU page fault patchset.  They
were also sent as part of the "Per-VMA locks" v4 patch series.  Patches 1
to 7 are bug fixes for RCU mode of the tree and patch 8 enables RCU mode
for the tree.

Performance v6.3-rc3 vs patched v6.3-rc3: Running these changes through
mmtests showed there was a 15-20% performance decrease in
will-it-scale/brk1-processes.  This tests creating and inserting a single
VMA repeatedly through the brk interface and isn't representative of any
real world applications.


This patch (of 8):

ma_pivots() and ma_data_end() may be called with a dead node.  Ensure to
that the node isn't dead before using the returned values.

This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230327185532.2354250-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-2-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: freak07 <michalechner92@googlemail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   52 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-be-more-cautious-about-dead-nodes
+++ a/lib/maple_tree.c
@@ -544,6 +544,7 @@ static inline bool ma_dead_node(const st
 
 	return (parent == node);
 }
+
 /*
  * mte_dead_node() - check if the @enode is dead.
  * @enode: The encoded maple node
@@ -625,6 +626,8 @@ static inline unsigned int mas_alloc_req
  * @node - the maple node
  * @type - the node type
  *
+ * In the event of a dead node, this array may be %NULL
+ *
  * Return: A pointer to the maple node pivots
  */
 static inline unsigned long *ma_pivots(struct maple_node *node,
@@ -1096,8 +1099,11 @@ static int mas_ascend(struct ma_state *m
 		a_type = mas_parent_enum(mas, p_enode);
 		a_node = mte_parent(p_enode);
 		a_slot = mte_parent_slot(p_enode);
-		pivots = ma_pivots(a_node, a_type);
 		a_enode = mt_mk_node(a_node, a_type);
+		pivots = ma_pivots(a_node, a_type);
+
+		if (unlikely(ma_dead_node(a_node)))
+			return 1;
 
 		if (!set_min && a_slot) {
 			set_min = true;
@@ -1401,6 +1407,9 @@ static inline unsigned char ma_data_end(
 {
 	unsigned char offset;
 
+	if (!pivots)
+		return 0;
+
 	if (type == maple_arange_64)
 		return ma_meta_end(node, type);
 
@@ -1436,6 +1445,9 @@ static inline unsigned char mas_data_end
 		return ma_meta_end(node, type);
 
 	pivots = ma_pivots(node, type);
+	if (unlikely(ma_dead_node(node)))
+		return 0;
+
 	offset = mt_pivots[type] - 1;
 	if (likely(!pivots[offset]))
 		return ma_meta_end(node, type);
@@ -4505,6 +4517,9 @@ static inline int mas_prev_node(struct m
 	node = mas_mn(mas);
 	slots = ma_slots(node, mt);
 	pivots = ma_pivots(node, mt);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
+
 	mas->max = pivots[offset];
 	if (offset)
 		mas->min = pivots[offset - 1] + 1;
@@ -4526,6 +4541,9 @@ static inline int mas_prev_node(struct m
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
 		offset = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		if (offset)
 			mas->min = pivots[offset - 1] + 1;
 
@@ -4574,6 +4592,7 @@ static inline int mas_next_node(struct m
 	struct maple_enode *enode;
 	int level = 0;
 	unsigned char offset;
+	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
 
@@ -4597,7 +4616,11 @@ static inline int mas_next_node(struct m
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 		pivots = ma_pivots(node, mt);
-	} while (unlikely(offset == ma_data_end(node, mt, pivots, mas->max)));
+		node_end = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
+	} while (unlikely(offset == node_end));
 
 	slots = ma_slots(node, mt);
 	pivot = mas_safe_pivot(mas, pivots, ++offset, mt);
@@ -4613,6 +4636,9 @@ static inline int mas_next_node(struct m
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		offset = 0;
 		pivot = pivots[0];
 	}
@@ -4659,11 +4685,14 @@ static inline void *mas_next_nentry(stru
 		return NULL;
 	}
 
-	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	pivots = ma_pivots(node, type);
 	count = ma_data_end(node, type, pivots, mas->max);
-	if (ma_dead_node(node))
+	if (unlikely(ma_dead_node(node)))
+		return NULL;
+
+	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	if (unlikely(ma_dead_node(node)))
 		return NULL;
 
 	if (mas->index > max)
@@ -4817,6 +4846,11 @@ retry:
 
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
+	if (unlikely(ma_dead_node(mn))) {
+		mas_rewalk(mas, index);
+		goto retry;
+	}
+
 	if (offset == mt_pivots[mt])
 		pivot = mas->max;
 	else
@@ -6617,11 +6651,11 @@ static inline void *mas_first_entry(stru
 	while (likely(!ma_is_leaf(mt))) {
 		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
-		pivots = ma_pivots(mn, mt);
-		max = pivots[0];
 		entry = mas_slot(mas, slots, 0);
+		pivots = ma_pivots(mn, mt);
 		if (unlikely(ma_dead_node(mn)))
 			return NULL;
+		max = pivots[0];
 		mas->node = entry;
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
@@ -6641,13 +6675,13 @@ static inline void *mas_first_entry(stru
 	if (likely(entry))
 		return entry;
 
-	pivots = ma_pivots(mn, mt);
-	mas->index = pivots[0] + 1;
 	mas->offset = 1;
 	entry = mas_slot(mas, slots, 1);
+	pivots = ma_pivots(mn, mt);
 	if (unlikely(ma_dead_node(mn)))
 		return NULL;
 
+	mas->index = pivots[0] + 1;
 	if (mas->index > limit)
 		goto none;
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


