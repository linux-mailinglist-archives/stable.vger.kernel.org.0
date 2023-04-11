Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B4C6DDC8F
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDKNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjDKNqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701E9E48
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED39D626A7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F13C433A0;
        Tue, 11 Apr 2023 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220812;
        bh=0CnalbmoM6+cTqEhSL0hb/+hpRF/hUNp784XehGL7fs=;
        h=Subject:To:Cc:From:Date:From;
        b=SQgORYipK3wOl5YaalWe5Objx2atr6yWIWKIxgT5EVc/wS0OzcuYPLuSd8VRm99IS
         /rOgKKIXCoXKlSOGBvjfc7SDhEVTZppX+3xjZ07VSQ0mPXb8jZCHlSqwyBxhz80996
         W9XNWV2YK3qyGWB4iYYDfdlY/XN1XdZPuHs5xHSI=
Subject: FAILED: patch "[PATCH] maple_tree: be more cautious about dead nodes" failed to apply to 6.1-stable tree
To:     Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        arjunroy@google.com, axelrasmussen@google.com,
        bigeasy@linutronix.de, chriscli@google.com, dave@stgolabs.net,
        david@redhat.com, dhowells@redhat.com, edumazet@google.com,
        gthelen@google.com, hannes@cmpxchg.org, hughd@google.com,
        jannh@google.com, joelaf@google.com, kent.overstreet@linux.dev,
        ldufour@linux.ibm.com, lstoakes@gmail.com, luto@kernel.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        michalechner92@googlemail.com, minchan@google.com,
        mingo@redhat.com, paulmck@kernel.org, peterx@redhat.com,
        peterz@infradead.org, posk@google.com, punit.agrawal@bytedance.com,
        rientjes@google.com, rppt@kernel.org, shakeelb@google.com,
        soheil@google.com, songliubraving@fb.com, stable@vger.kernel.org,
        surenb@google.com, vbabka@suse.cz, will@kernel.org,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:46:49 +0200
Message-ID: <2023041149-mashed-decompose-eca7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 39d0bd86c499ecd6abae42a9b7112056c5560691
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041149-mashed-decompose-eca7@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

39d0bd86c499 ("maple_tree: be more cautious about dead nodes")
65be6f058b0e ("maple_tree: fix potential rcu issue")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39d0bd86c499ecd6abae42a9b7112056c5560691 Mon Sep 17 00:00:00 2001
From: Liam Howlett <Liam.Howlett@oracle.com>
Date: Mon, 27 Feb 2023 09:36:00 -0800
Subject: [PATCH] maple_tree: be more cautious about dead nodes

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

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9e2735cbc2b4..095b9cb1f4f1 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -544,6 +544,7 @@ static inline bool ma_dead_node(const struct maple_node *node)
 
 	return (parent == node);
 }
+
 /*
  * mte_dead_node() - check if the @enode is dead.
  * @enode: The encoded maple node
@@ -625,6 +626,8 @@ static inline unsigned int mas_alloc_req(const struct ma_state *mas)
  * @node - the maple node
  * @type - the node type
  *
+ * In the event of a dead node, this array may be %NULL
+ *
  * Return: A pointer to the maple node pivots
  */
 static inline unsigned long *ma_pivots(struct maple_node *node,
@@ -1096,8 +1099,11 @@ static int mas_ascend(struct ma_state *mas)
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
@@ -1401,6 +1407,9 @@ static inline unsigned char ma_data_end(struct maple_node *node,
 {
 	unsigned char offset;
 
+	if (!pivots)
+		return 0;
+
 	if (type == maple_arange_64)
 		return ma_meta_end(node, type);
 
@@ -1436,6 +1445,9 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 		return ma_meta_end(node, type);
 
 	pivots = ma_pivots(node, type);
+	if (unlikely(ma_dead_node(node)))
+		return 0;
+
 	offset = mt_pivots[type] - 1;
 	if (likely(!pivots[offset]))
 		return ma_meta_end(node, type);
@@ -4505,6 +4517,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 	node = mas_mn(mas);
 	slots = ma_slots(node, mt);
 	pivots = ma_pivots(node, mt);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
+
 	mas->max = pivots[offset];
 	if (offset)
 		mas->min = pivots[offset - 1] + 1;
@@ -4526,6 +4541,9 @@ static inline int mas_prev_node(struct ma_state *mas, unsigned long min)
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
 		offset = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		if (offset)
 			mas->min = pivots[offset - 1] + 1;
 
@@ -4574,6 +4592,7 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 	struct maple_enode *enode;
 	int level = 0;
 	unsigned char offset;
+	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
 
@@ -4597,7 +4616,11 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
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
@@ -4613,6 +4636,9 @@ static inline int mas_next_node(struct ma_state *mas, struct maple_node *node,
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		offset = 0;
 		pivot = pivots[0];
 	}
@@ -4659,11 +4685,14 @@ static inline void *mas_next_nentry(struct ma_state *mas,
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
@@ -4817,6 +4846,11 @@ static inline void *mas_prev_nentry(struct ma_state *mas, unsigned long limit,
 
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
@@ -6617,11 +6651,11 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
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
@@ -6641,13 +6675,13 @@ static inline void *mas_first_entry(struct ma_state *mas, struct maple_node *mn,
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
 

