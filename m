Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA0498A83
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbiAXTE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:04:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59202 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344401AbiAXTCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1220660B77;
        Mon, 24 Jan 2022 19:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91827C340EA;
        Mon, 24 Jan 2022 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050939;
        bh=Twcu7HJqRbI05jHuCpGu4Sqgln0sqf2CeKVvVXdvOM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/K45fPvO8cHuTDim/lvUR2zTiBXP77ssK9PJHRqIj66UF8GdN2PigYDdI4KO45T9
         yixh8r/Hp+SSIy2nvcDAdkjZwS61+SOO+IA/5XPeip+mOAr9VhrNhup60M/ANPcE9I
         NVZolFbAXCNwIxRbHMoiBqrQIT6qIdKhQ4QB1BdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Davidlohr Bueso <dbueso@suse.de>, Jan Kara <jack@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 152/157] rbtree: cache leftmost node internally
Date:   Mon, 24 Jan 2022 19:44:02 +0100
Message-Id: <20220124183937.581136702@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

commit cd9e61ed1eebbcd5dfad59475d41ec58d9b64b6a upstream.

Patch series "rbtree: Cache leftmost node internally", v4.

A series to extending rbtrees to internally cache the leftmost node such
that we can have fast overlap check optimization for all interval tree
users[1].  The benefits of this series are that:

(i)   Unify users that do internal leftmost node caching.
(ii)  Optimize all interval tree users.
(iii) Convert at least two new users (epoll and procfs) to the new interface.

This patch (of 16):

Red-black tree semantics imply that nodes with smaller or greater (or
equal for duplicates) keys always be to the left and right,
respectively.  For the kernel this is extremely evident when considering
our rb_first() semantics.  Enabling lookups for the smallest node in the
tree in O(1) can save a good chunk of cycles in not having to walk down
the tree each time.  To this end there are a few core users that
explicitly do this, such as the scheduler and rtmutexes.  There is also
the desire for interval trees to have this optimization allowing faster
overlap checking.

This patch introduces a new 'struct rb_root_cached' which is just the
root with a cached pointer to the leftmost node.  The reason why the
regular rb_root was not extended instead of adding a new structure was
that this allows the user to have the choice between memory footprint
and actual tree performance.  The new wrappers on top of the regular
rb_root calls are:

 - rb_first_cached(cached_root) -- which is a fast replacement
     for rb_first.

 - rb_insert_color_cached(node, cached_root, new)

 - rb_erase_cached(node, cached_root)

In addition, augmented cached interfaces are also added for basic
insertion and deletion operations; which becomes important for the
interval tree changes.

With the exception of the inserts, which adds a bool for updating the
new leftmost, the interfaces are kept the same.  To this end, porting rb
users to the cached version becomes really trivial, and keeping current
rbtree semantics for users that don't care about the optimization
requires zero overhead.

Link: http://lkml.kernel.org/r/20170719014603.19029-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rbtree.txt         |   33 +++++++++++++++++++++++++++++++++
 include/linux/rbtree.h           |   21 +++++++++++++++++++++
 include/linux/rbtree_augmented.h |   33 ++++++++++++++++++++++++++++++---
 lib/rbtree.c                     |   34 +++++++++++++++++++++++++++++-----
 4 files changed, 113 insertions(+), 8 deletions(-)

--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,6 +190,39 @@ Example:
   for (node = rb_first(&mytree); node; node = rb_next(node))
 	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 
+Cached rbtrees
+--------------
+
+Computing the leftmost (smallest) node is quite a common task for binary
+search trees, such as for traversals or users relying on a the particular
+order for their own logic. To this end, users can use 'struct rb_root_cached'
+to optimize O(logN) rb_first() calls to a simple pointer fetch avoiding
+potentially expensive tree iterations. This is done at negligible runtime
+overhead for maintanence; albeit larger memory footprint.
+
+Similar to the rb_root structure, cached rbtrees are initialized to be
+empty via:
+
+  struct rb_root_cached mytree = RB_ROOT_CACHED;
+
+Cached rbtree is simply a regular rb_root with an extra pointer to cache the
+leftmost node. This allows rb_root_cached to exist wherever rb_root does,
+which permits augmented trees to be supported as well as only a few extra
+interfaces:
+
+  struct rb_node *rb_first_cached(struct rb_root_cached *tree);
+  void rb_insert_color_cached(struct rb_node *, struct rb_root_cached *, bool);
+  void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);
+
+Both insert and erase calls have their respective counterpart of augmented
+trees:
+
+  void rb_insert_augmented_cached(struct rb_node *node, struct rb_root_cached *,
+				  bool, struct rb_augment_callbacks *);
+  void rb_erase_augmented_cached(struct rb_node *, struct rb_root_cached *,
+				 struct rb_augment_callbacks *);
+
+
 Support for Augmented rbtrees
 -----------------------------
 
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -44,10 +44,25 @@ struct rb_root {
 	struct rb_node *rb_node;
 };
 
+/*
+ * Leftmost-cached rbtrees.
+ *
+ * We do not cache the rightmost node based on footprint
+ * size vs number of potential users that could benefit
+ * from O(1) rb_last(). Just not worth it, users that want
+ * this feature can always implement the logic explicitly.
+ * Furthermore, users that want to cache both pointers may
+ * find it a bit asymmetric, but that's ok.
+ */
+struct rb_root_cached {
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+};
 
 #define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3))
 
 #define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT_CACHED (struct rb_root_cached) { {NULL, }, NULL }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)  (READ_ONCE((root)->rb_node) == NULL)
@@ -69,6 +84,12 @@ extern struct rb_node *rb_prev(const str
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
 
+extern void rb_insert_color_cached(struct rb_node *,
+				   struct rb_root_cached *, bool);
+extern void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);
+/* Same as rb_first(), but O(1) */
+#define rb_first_cached(root) (root)->rb_leftmost
+
 /* Postorder iteration - always visit the parent after its children */
 extern struct rb_node *rb_first_postorder(const struct rb_root *);
 extern struct rb_node *rb_next_postorder(const struct rb_node *);
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -41,7 +41,9 @@ struct rb_augment_callbacks {
 	void (*rotate)(struct rb_node *old, struct rb_node *new);
 };
 
-extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+extern void __rb_insert_augmented(struct rb_node *node,
+				  struct rb_root *root,
+				  bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
 /*
  * Fixup the rbtree and update the augmented information when rebalancing.
@@ -57,7 +59,16 @@ static inline void
 rb_insert_augmented(struct rb_node *node, struct rb_root *root,
 		    const struct rb_augment_callbacks *augment)
 {
-	__rb_insert_augmented(node, root, augment->rotate);
+	__rb_insert_augmented(node, root, false, NULL, augment->rotate);
+}
+
+static inline void
+rb_insert_augmented_cached(struct rb_node *node,
+			   struct rb_root_cached *root, bool newleft,
+			   const struct rb_augment_callbacks *augment)
+{
+	__rb_insert_augmented(node, &root->rb_root,
+			      newleft, &root->rb_leftmost, augment->rotate);
 }
 
 #define RB_DECLARE_CALLBACKS(rbstatic, rbname, rbstruct, rbfield,	\
@@ -148,6 +159,7 @@ extern void __rb_erase_color(struct rb_n
 
 static __always_inline struct rb_node *
 __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		     struct rb_node **leftmost,
 		     const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *child = node->rb_right;
@@ -155,6 +167,9 @@ __rb_erase_augmented(struct rb_node *nod
 	struct rb_node *parent, *rebalance;
 	unsigned long pc;
 
+	if (leftmost && node == *leftmost)
+		*leftmost = rb_next(node);
+
 	if (!tmp) {
 		/*
 		 * Case 1: node to erase has no more than 1 child (easy!)
@@ -254,9 +269,21 @@ static __always_inline void
 rb_erase_augmented(struct rb_node *node, struct rb_root *root,
 		   const struct rb_augment_callbacks *augment)
 {
-	struct rb_node *rebalance = __rb_erase_augmented(node, root, augment);
+	struct rb_node *rebalance = __rb_erase_augmented(node, root,
+							 NULL, augment);
 	if (rebalance)
 		__rb_erase_color(rebalance, root, augment->rotate);
 }
 
+static __always_inline void
+rb_erase_augmented_cached(struct rb_node *node, struct rb_root_cached *root,
+			  const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *rebalance = __rb_erase_augmented(node, &root->rb_root,
+							 &root->rb_leftmost,
+							 augment);
+	if (rebalance)
+		__rb_erase_color(rebalance, &root->rb_root, augment->rotate);
+}
+
 #endif	/* _LINUX_RBTREE_AUGMENTED_H */
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -95,10 +95,14 @@ __rb_rotate_set_parents(struct rb_node *
 
 static __always_inline void
 __rb_insert(struct rb_node *node, struct rb_root *root,
+	    bool newleft, struct rb_node **leftmost,
 	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
 	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
 
+	if (newleft)
+		*leftmost = node;
+
 	while (true) {
 		/*
 		 * Loop invariant: node is red
@@ -417,19 +421,38 @@ static const struct rb_augment_callbacks
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	__rb_insert(node, root, dummy_rotate);
+	__rb_insert(node, root, false, NULL, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_insert_color);
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *rebalance;
-	rebalance = __rb_erase_augmented(node, root, &dummy_callbacks);
+	rebalance = __rb_erase_augmented(node, root,
+					 NULL, &dummy_callbacks);
 	if (rebalance)
 		____rb_erase_color(rebalance, root, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_erase);
 
+void rb_insert_color_cached(struct rb_node *node,
+			    struct rb_root_cached *root, bool leftmost)
+{
+	__rb_insert(node, &root->rb_root, leftmost,
+		    &root->rb_leftmost, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_insert_color_cached);
+
+void rb_erase_cached(struct rb_node *node, struct rb_root_cached *root)
+{
+	struct rb_node *rebalance;
+	rebalance = __rb_erase_augmented(node, &root->rb_root,
+					 &root->rb_leftmost, &dummy_callbacks);
+	if (rebalance)
+		____rb_erase_color(rebalance, &root->rb_root, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_erase_cached);
+
 /*
  * Augmented rbtree manipulation functions.
  *
@@ -438,9 +461,10 @@ EXPORT_SYMBOL(rb_erase);
  */
 
 void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+			   bool newleft, struct rb_node **leftmost,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
-	__rb_insert(node, root, augment_rotate);
+	__rb_insert(node, root, newleft, leftmost, augment_rotate);
 }
 EXPORT_SYMBOL(__rb_insert_augmented);
 
@@ -485,7 +509,7 @@ struct rb_node *rb_next(const struct rb_
 	 * as we can.
 	 */
 	if (node->rb_right) {
-		node = node->rb_right; 
+		node = node->rb_right;
 		while (node->rb_left)
 			node=node->rb_left;
 		return (struct rb_node *)node;
@@ -517,7 +541,7 @@ struct rb_node *rb_prev(const struct rb_
 	 * as we can.
 	 */
 	if (node->rb_left) {
-		node = node->rb_left; 
+		node = node->rb_left;
 		while (node->rb_right)
 			node=node->rb_right;
 		return (struct rb_node *)node;


