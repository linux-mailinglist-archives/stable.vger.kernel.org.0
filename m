Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DF06D8C6B
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbjDFBG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDFBG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BDD59E0;
        Wed,  5 Apr 2023 18:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC5964293;
        Thu,  6 Apr 2023 01:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D745AC433EF;
        Thu,  6 Apr 2023 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743211;
        bh=waMn5VXND86MR7KROqyw9G1O7F6zxhs61MLCsnYaJHM=;
        h=Date:To:From:Subject:From;
        b=cTg7Ezed6pG5nizLQZ7hEdf6kS8tddwPYZ42QE/9fBIq+WNr45dw6yD7k4tJkHSb8
         SiYlaFVE6jv1Z1qn/Dia9WJes5RpSUAighLnH+msERW7tA1e1fjIiM1gonVE+8M5YD
         OC/ltrGZfQi8C0gRdpGIH/lrkgpjPvr80p6XphcA=
Date:   Wed, 05 Apr 2023 18:06:51 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch removed from -mm tree
Message-Id: <20230406010651.D745AC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add RCU lock checking to rcu callback functions
has been removed from the -mm tree.  Its filename was
     maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add RCU lock checking to rcu callback functions
Date: Mon, 27 Feb 2023 09:36:06 -0800

Dereferencing RCU objects within the RCU callback without the RCU check
has caused lockdep to complain.  Fix the RCU dereferencing by using the
RCU callback lock to ensure the operation is safe.

Also stop creating a new lock to use for dereferencing during destruction
of the tree or subtree.  Instead, pass through a pointer to the tree that
has the lock that is held for RCU dereferencing checking.  It also does
not make sense to use the maple state in the freeing scenario as the tree
walk is a special case where the tree no longer has the normal encodings
and parent pointers.

Link: https://lkml.kernel.org/r/20230227173632.3292573-8-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |  188 ++++++++++++++++++++++-----------------------
 1 file changed, 96 insertions(+), 92 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-rcu-lock-checking-to-rcu-callback-functions
+++ a/lib/maple_tree.c
@@ -824,6 +824,11 @@ static inline void *mt_slot(const struct
 	return rcu_dereference_check(slots[offset], mt_locked(mt));
 }
 
+static inline void *mt_slot_locked(struct maple_tree *mt, void __rcu **slots,
+				   unsigned char offset)
+{
+	return rcu_dereference_protected(slots[offset], mt_locked(mt));
+}
 /*
  * mas_slot_locked() - Get the slot value when holding the maple tree lock.
  * @mas: The maple state
@@ -835,7 +840,7 @@ static inline void *mt_slot(const struct
 static inline void *mas_slot_locked(struct ma_state *mas, void __rcu **slots,
 				       unsigned char offset)
 {
-	return rcu_dereference_protected(slots[offset], mt_locked(mas->tree));
+	return mt_slot_locked(mas->tree, slots, offset);
 }
 
 /*
@@ -907,34 +912,35 @@ static inline void ma_set_meta(struct ma
 }
 
 /*
- * mas_clear_meta() - clear the metadata information of a node, if it exists
- * @mas: The maple state
+ * mt_clear_meta() - clear the metadata information of a node, if it exists
+ * @mt: The maple tree
  * @mn: The maple node
- * @mt: The maple node type
+ * @type: The maple node type
  * @offset: The offset of the highest sub-gap in this node.
  * @end: The end of the data in this node.
  */
-static inline void mas_clear_meta(struct ma_state *mas, struct maple_node *mn,
-				  enum maple_type mt)
+static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
+				  enum maple_type type)
 {
 	struct maple_metadata *meta;
 	unsigned long *pivots;
 	void __rcu **slots;
 	void *next;
 
-	switch (mt) {
+	switch (type) {
 	case maple_range_64:
 		pivots = mn->mr64.pivot;
 		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
 			slots = mn->mr64.slot;
-			next = mas_slot_locked(mas, slots,
-					       MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) && mte_node_type(next))))
-				return; /* The last slot is a node, no metadata */
+			next = mt_slot_locked(mt, slots,
+					      MAPLE_RANGE64_SLOTS - 1);
+			if (unlikely((mte_to_node(next) &&
+				      mte_node_type(next))))
+				return; /* no metadata, could be node */
 		}
 		fallthrough;
 	case maple_arange_64:
-		meta = ma_meta(mn, mt);
+		meta = ma_meta(mn, type);
 		break;
 	default:
 		return;
@@ -5483,7 +5489,7 @@ no_gap:
 }
 
 /*
- * mas_dead_leaves() - Mark all leaves of a node as dead.
+ * mte_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
  * @slots: Pointer to the slot array
  * @type: The maple node type
@@ -5493,16 +5499,16 @@ no_gap:
  * Return: The number of leaves marked as dead.
  */
 static inline
-unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
-			      enum maple_type mt)
+unsigned char mte_dead_leaves(struct maple_enode *enode, struct maple_tree *mt,
+			      void __rcu **slots)
 {
 	struct maple_node *node;
 	enum maple_type type;
 	void *entry;
 	int offset;
 
-	for (offset = 0; offset < mt_slots[mt]; offset++) {
-		entry = mas_slot_locked(mas, slots, offset);
+	for (offset = 0; offset < mt_slot_count(enode); offset++) {
+		entry = mt_slot(mt, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
 		/* Use both node and type to catch LE & BE metadata */
@@ -5517,162 +5523,160 @@ unsigned char mas_dead_leaves(struct ma_
 	return offset;
 }
 
-static void __rcu **mas_dead_walk(struct ma_state *mas, unsigned char offset)
+/**
+ * mte_dead_walk() - Walk down a dead tree to just before the leaves
+ * @enode: The maple encoded node
+ * @offset: The starting offset
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
+static void __rcu **mte_dead_walk(struct maple_enode **enode, unsigned char offset)
 {
-	struct maple_node *next;
+	struct maple_node *node, *next;
 	void __rcu **slots = NULL;
 
-	next = mas_mn(mas);
+	next = mte_to_node(*enode);
 	do {
-		mas->node = mt_mk_node(next, next->type);
-		slots = ma_slots(next, next->type);
-		next = mas_slot_locked(mas, slots, offset);
+		*enode = ma_enode_ptr(next);
+		node = mte_to_node(*enode);
+		slots = ma_slots(node, node->type);
+		next = rcu_dereference_protected(slots[offset],
+					lock_is_held(&rcu_callback_map));
 		offset = 0;
 	} while (!ma_is_leaf(next->type));
 
 	return slots;
 }
 
+/**
+ * mt_free_walk() - Walk & free a tree in the RCU callback context
+ * @head: The RCU head that's within the node.
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
 static void mt_free_walk(struct rcu_head *head)
 {
 	void __rcu **slots;
 	struct maple_node *node, *start;
-	struct maple_tree mt;
+	struct maple_enode *enode;
 	unsigned char offset;
 	enum maple_type type;
-	MA_STATE(mas, &mt, 0, 0);
 
 	node = container_of(head, struct maple_node, rcu);
 
 	if (ma_is_leaf(node->type))
 		goto free_leaf;
 
-	mt_init_flags(&mt, node->ma_flags);
-	mas_lock(&mas);
 	start = node;
-	mas.node = mt_mk_node(node, node->type);
-	slots = mas_dead_walk(&mas, 0);
-	node = mas_mn(&mas);
+	enode = mt_mk_node(node, node->type);
+	slots = mte_dead_walk(&enode, 0);
+	node = mte_to_node(enode);
 	do {
 		mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
-
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
-		if ((offset < mt_slots[type]) && (slots[offset]))
-			slots = mas_dead_walk(&mas, offset);
-
-		node = mas_mn(&mas);
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
+
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
+		if ((offset < mt_slots[type]) &&
+		    rcu_dereference_protected(slots[offset],
+					      lock_is_held(&rcu_callback_map)))
+			slots = mte_dead_walk(&enode, offset);
+		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));
 
 	slots = ma_slots(node, node->type);
 	mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
 free_leaf:
 	mt_free_rcu(&node->rcu);
 }
 
-static inline void __rcu **mas_destroy_descend(struct ma_state *mas,
-			struct maple_enode *prev, unsigned char offset)
+static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
+	struct maple_tree *mt, struct maple_enode *prev, unsigned char offset)
 {
 	struct maple_node *node;
-	struct maple_enode *next = mas->node;
+	struct maple_enode *next = *enode;
 	void __rcu **slots = NULL;
+	enum maple_type type;
+	unsigned char next_offset = 0;
 
 	do {
-		mas->node = next;
-		node = mas_mn(mas);
-		slots = ma_slots(node, mte_node_type(mas->node));
-		next = mas_slot_locked(mas, slots, 0);
-		if ((mte_dead_node(next))) {
-			mte_to_node(next)->type = mte_node_type(next);
-			next = mas_slot_locked(mas, slots, 1);
-		}
+		*enode = next;
+		node = mte_to_node(*enode);
+		type = mte_node_type(*enode);
+		slots = ma_slots(node, type);
+		next = mt_slot_locked(mt, slots, next_offset);
+		if ((mte_dead_node(next)))
+			next = mt_slot_locked(mt, slots, ++next_offset);
 
-		mte_set_node_dead(mas->node);
-		node->type = mte_node_type(mas->node);
-		mas_clear_meta(mas, node, node->type);
+		mte_set_node_dead(*enode);
+		node->type = type;
 		node->piv_parent = prev;
 		node->parent_slot = offset;
-		offset = 0;
-		prev = mas->node;
+		offset = next_offset;
+		next_offset = 0;
+		prev = *enode;
 	} while (!mte_is_leaf(next));
 
 	return slots;
 }
 
-static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
+static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 			    bool free)
 {
 	void __rcu **slots;
 	struct maple_node *node = mte_to_node(enode);
 	struct maple_enode *start;
-	struct maple_tree mt;
 
-	MA_STATE(mas, &mt, 0, 0);
-
-	mas.node = enode;
 	if (mte_is_leaf(enode)) {
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
 
-	ma_flags &= ~MT_FLAGS_LOCK_MASK;
-	mt_init_flags(&mt, ma_flags);
-	mas_lock(&mas);
-
-	mte_to_node(enode)->ma_flags = ma_flags;
 	start = enode;
-	slots = mas_destroy_descend(&mas, start, 0);
-	node = mas_mn(&mas);
+	slots = mte_destroy_descend(&enode, mt, start, 0);
+	node = mte_to_node(enode); // Updated in the above call.
 	do {
 		enum maple_type type;
 		unsigned char offset;
 		struct maple_enode *parent, *tmp;
 
-		node->type = mte_node_type(mas.node);
-		node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+		node->slot_len = mte_dead_leaves(enode, mt, slots);
 		if (free)
 			mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
 
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
 		if (offset >= mt_slots[type])
 			goto next;
 
-		tmp = mas_slot_locked(&mas, slots, offset);
+		tmp = mt_slot_locked(mt, slots, offset);
 		if (mte_node_type(tmp) && mte_to_node(tmp)) {
-			parent = mas.node;
-			mas.node = tmp;
-			slots = mas_destroy_descend(&mas, parent, offset);
+			parent = enode;
+			enode = tmp;
+			slots = mte_destroy_descend(&enode, mt, parent, offset);
 		}
 next:
-		node = mas_mn(&mas);
-	} while (start != mas.node);
+		node = mte_to_node(enode);
+	} while (start != enode);
 
-	node = mas_mn(&mas);
-	node->type = mte_node_type(mas.node);
-	node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+	node = mte_to_node(enode);
+	node->slot_len = mte_dead_leaves(enode, mt, slots);
 	if (free)
 		mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
-
 free_leaf:
 	if (free)
 		mt_free_rcu(&node->rcu);
 	else
-		mas_clear_meta(&mas, node, node->type);
+		mt_clear_meta(mt, node, node->type);
 }
 
 /*
@@ -5688,10 +5692,10 @@ static inline void mte_destroy_walk(stru
 	struct maple_node *node = mte_to_node(enode);
 
 	if (mt_in_rcu(mt)) {
-		mt_destroy_walk(enode, mt->ma_flags, false);
+		mt_destroy_walk(enode, mt, false);
 		call_rcu(&node->rcu, mt_free_walk);
 	} else {
-		mt_destroy_walk(enode, mt->ma_flags, true);
+		mt_destroy_walk(enode, mt, true);
 	}
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


