Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D5839E81C
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFGUMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhFGUMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:12:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220C7C061787
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=RoF96JaMPxx54YqITTsO5irsQ+AWjxZoMcqH7+IYh+I=; b=CE9zOTVrKZuP/j5x6lfO3aQZac
        eB7xOnCFvhQV2Hwe6Zv85+SI+znL5bb9q03AjIVEE/8irYmb1OaFAMhGWxVlrL/PvQbY/QcvketTc
        /Eiplxa9yRtS8zaqxGHk88tWpU8sIO+Qv4v24VgsE3bqPrxgijGIuPjs9s8X1EOKcmjIZmLBFqd2Y
        X5lzuH9Avg8Oa0uP2wGwME8fnYnxRNmmWCDbK0iHZpokdZ0c9qjrTEpAkjB4Nb4eIXUChjFDmm3ig
        kE0Chv2O9MIlqp9v6YuyuiCVomlDGBK9r+KQIi9xjzpOUXHGbhP2jnFWSLIy/JHpH6SoPnkkVMvWi
        aVAxGXLg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqLZK-00GCMj-DC; Mon, 07 Jun 2021 20:09:58 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Qian Cai <cai@lca.pw>, Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] XArray: add xas_split
Date:   Mon,  7 Jun 2021 21:08:44 +0100
Message-Id: <20210607200845.3860579-4-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607200845.3860579-1-willy@infradead.org>
References: <20210607200845.3860579-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8fc75643c5e14574c8be59b69182452ece28315a upstream

In order to use multi-index entries for huge pages in the page cache, we
need to be able to split a multi-index entry (eg if a file is truncated in
the middle of a huge page entry).  This version does not support splitting
more than one level of the tree at a time.  This is an acceptable
limitation for the page cache as we do not expect to support order-12
pages in the near future.

[akpm@linux-foundation.org: export xas_split_alloc() to modules]
[willy@infradead.org: fix xarray split]
  Link: https://lkml.kernel.org/r/20200910175450.GV6583@casper.infradead.org
[willy@infradead.org: fix xarray]
  Link: https://lkml.kernel.org/r/20201001233943.GW20115@casper.infradead.org

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lkml.kernel.org/r/20200903183029.14930-3-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 Documentation/core-api/xarray.rst |  16 +--
 include/linux/xarray.h            |  13 +++
 lib/test_xarray.c                 |  44 ++++++++
 lib/xarray.c                      | 168 ++++++++++++++++++++++++++++--
 4 files changed, 225 insertions(+), 16 deletions(-)

diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
index fcedc5349ace..2ad3c1fce579 100644
--- a/Documentation/core-api/xarray.rst
+++ b/Documentation/core-api/xarray.rst
@@ -461,13 +461,15 @@ or iterations will move the index to the first index in the range.
 Each entry will only be returned once, no matter how many indices it
 occupies.
 
-Using xas_next() or xas_prev() with a multi-index xa_state
-is not supported.  Using either of these functions on a multi-index entry
-will reveal sibling entries; these should be skipped over by the caller.
-
-Storing ``NULL`` into any index of a multi-index entry will set the entry
-at every index to ``NULL`` and dissolve the tie.  Splitting a multi-index
-entry into entries occupying smaller ranges is not yet supported.
+Using xas_next() or xas_prev() with a multi-index xa_state is not
+supported.  Using either of these functions on a multi-index entry will
+reveal sibling entries; these should be skipped over by the caller.
+
+Storing ``NULL`` into any index of a multi-index entry will set the
+entry at every index to ``NULL`` and dissolve the tie.  A multi-index
+entry can be split into entries occupying smaller ranges by calling
+xas_split_alloc() without the xa_lock held, followed by taking the lock
+and calling xas_split().
 
 Functions and structures
 ========================
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 63185fe7cd6a..2903f25bff5e 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1472,11 +1472,24 @@ void xas_create_range(struct xa_state *);
 
 #ifdef CONFIG_XARRAY_MULTI
 int xa_get_order(struct xarray *, unsigned long index);
+void xas_split(struct xa_state *, void *entry, unsigned int order);
+void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
 #else
 static inline int xa_get_order(struct xarray *xa, unsigned long index)
 {
 	return 0;
 }
+
+static inline void xas_split(struct xa_state *xas, void *entry,
+		unsigned int order)
+{
+	xas_store(xas, entry);
+}
+
+static inline void xas_split_alloc(struct xa_state *xas, void *entry,
+		unsigned int order, gfp_t gfp)
+{
+}
 #endif
 
 /**
diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index bdd4d7995f79..8262c3f05a5d 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1503,6 +1503,49 @@ static noinline void check_store_range(struct xarray *xa)
 	}
 }
 
+#ifdef CONFIG_XARRAY_MULTI
+static void check_split_1(struct xarray *xa, unsigned long index,
+							unsigned int order)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+	unsigned int i = 0;
+
+	xa_store_order(xa, index, order, xa, GFP_KERNEL);
+
+	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
+	xas_lock(&xas);
+	xas_split(&xas, xa, order);
+	xas_unlock(&xas);
+
+	xa_for_each(xa, index, entry) {
+		XA_BUG_ON(xa, entry != xa);
+		i++;
+	}
+	XA_BUG_ON(xa, i != 1 << order);
+
+	xa_set_mark(xa, index, XA_MARK_0);
+	XA_BUG_ON(xa, !xa_get_mark(xa, index, XA_MARK_0));
+
+	xa_destroy(xa);
+}
+
+static noinline void check_split(struct xarray *xa)
+{
+	unsigned int order;
+
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
+		check_split_1(xa, 0, order);
+		check_split_1(xa, 1UL << order, order);
+		check_split_1(xa, 3UL << order, order);
+	}
+}
+#else
+static void check_split(struct xarray *xa) { }
+#endif
+
 static void check_align_1(struct xarray *xa, char *name)
 {
 	int i;
@@ -1729,6 +1772,7 @@ static int xarray_checks(void)
 	check_store_range(&array);
 	check_store_iter(&array);
 	check_align(&xa0);
+	check_split(&array);
 
 	check_workingset(&array, 0);
 	check_workingset(&array, 64);
diff --git a/lib/xarray.c b/lib/xarray.c
index 57b9c144f793..7d22b3059127 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -266,13 +266,14 @@ static void xa_node_free(struct xa_node *node)
  */
 static void xas_destroy(struct xa_state *xas)
 {
-	struct xa_node *node = xas->xa_alloc;
+	struct xa_node *next, *node = xas->xa_alloc;
 
-	if (!node)
-		return;
-	XA_NODE_BUG_ON(node, !list_empty(&node->private_list));
-	kmem_cache_free(radix_tree_node_cachep, node);
-	xas->xa_alloc = NULL;
+	while (node) {
+		XA_NODE_BUG_ON(node, !list_empty(&node->private_list));
+		next = rcu_dereference_raw(node->parent);
+		radix_tree_node_rcu_free(&node->rcu_head);
+		xas->xa_alloc = node = next;
+	}
 }
 
 /**
@@ -304,6 +305,7 @@ bool xas_nomem(struct xa_state *xas, gfp_t gfp)
 	xas->xa_alloc = kmem_cache_alloc(radix_tree_node_cachep, gfp);
 	if (!xas->xa_alloc)
 		return false;
+	xas->xa_alloc->parent = NULL;
 	XA_NODE_BUG_ON(xas->xa_alloc, !list_empty(&xas->xa_alloc->private_list));
 	xas->xa_node = XAS_RESTART;
 	return true;
@@ -339,6 +341,7 @@ static bool __xas_nomem(struct xa_state *xas, gfp_t gfp)
 	}
 	if (!xas->xa_alloc)
 		return false;
+	xas->xa_alloc->parent = NULL;
 	XA_NODE_BUG_ON(xas->xa_alloc, !list_empty(&xas->xa_alloc->private_list));
 	xas->xa_node = XAS_RESTART;
 	return true;
@@ -403,7 +406,7 @@ static unsigned long xas_size(const struct xa_state *xas)
 /*
  * Use this to calculate the maximum index that will need to be created
  * in order to add the entry described by @xas.  Because we cannot store a
- * multiple-index entry at index 0, the calculation is a little more complex
+ * multi-index entry at index 0, the calculation is a little more complex
  * than you might expect.
  */
 static unsigned long xas_max(struct xa_state *xas)
@@ -946,6 +949,153 @@ void xas_init_marks(const struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_init_marks);
 
+#ifdef CONFIG_XARRAY_MULTI
+static unsigned int node_get_marks(struct xa_node *node, unsigned int offset)
+{
+	unsigned int marks = 0;
+	xa_mark_t mark = XA_MARK_0;
+
+	for (;;) {
+		if (node_get_mark(node, offset, mark))
+			marks |= 1 << (__force unsigned int)mark;
+		if (mark == XA_MARK_MAX)
+			break;
+		mark_inc(mark);
+	}
+
+	return marks;
+}
+
+static void node_set_marks(struct xa_node *node, unsigned int offset,
+			struct xa_node *child, unsigned int marks)
+{
+	xa_mark_t mark = XA_MARK_0;
+
+	for (;;) {
+		if (marks & (1 << (__force unsigned int)mark)) {
+			node_set_mark(node, offset, mark);
+			if (child)
+				node_mark_all(child, mark);
+		}
+		if (mark == XA_MARK_MAX)
+			break;
+		mark_inc(mark);
+	}
+}
+
+/**
+ * xas_split_alloc() - Allocate memory for splitting an entry.
+ * @xas: XArray operation state.
+ * @entry: New entry which will be stored in the array.
+ * @order: New entry order.
+ * @gfp: Memory allocation flags.
+ *
+ * This function should be called before calling xas_split().
+ * If necessary, it will allocate new nodes (and fill them with @entry)
+ * to prepare for the upcoming split of an entry of @order size into
+ * entries of the order stored in the @xas.
+ *
+ * Context: May sleep if @gfp flags permit.
+ */
+void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
+		gfp_t gfp)
+{
+	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
+	unsigned int mask = xas->xa_sibs;
+
+	/* XXX: no support for splitting really large entries yet */
+	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT < order))
+		goto nomem;
+	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
+		return;
+
+	do {
+		unsigned int i;
+		void *sibling;
+		struct xa_node *node;
+
+		node = kmem_cache_alloc(radix_tree_node_cachep, gfp);
+		if (!node)
+			goto nomem;
+		node->array = xas->xa;
+		for (i = 0; i < XA_CHUNK_SIZE; i++) {
+			if ((i & mask) == 0) {
+				RCU_INIT_POINTER(node->slots[i], entry);
+				sibling = xa_mk_sibling(0);
+			} else {
+				RCU_INIT_POINTER(node->slots[i], sibling);
+			}
+		}
+		RCU_INIT_POINTER(node->parent, xas->xa_alloc);
+		xas->xa_alloc = node;
+	} while (sibs-- > 0);
+
+	return;
+nomem:
+	xas_destroy(xas);
+	xas_set_err(xas, -ENOMEM);
+}
+EXPORT_SYMBOL_GPL(xas_split_alloc);
+
+/**
+ * xas_split() - Split a multi-index entry into smaller entries.
+ * @xas: XArray operation state.
+ * @entry: New entry to store in the array.
+ * @order: New entry order.
+ *
+ * The value in the entry is copied to all the replacement entries.
+ *
+ * Context: Any context.  The caller should hold the xa_lock.
+ */
+void xas_split(struct xa_state *xas, void *entry, unsigned int order)
+{
+	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
+	unsigned int offset, marks;
+	struct xa_node *node;
+	void *curr = xas_load(xas);
+	int values = 0;
+
+	node = xas->xa_node;
+	if (xas_top(node))
+		return;
+
+	marks = node_get_marks(node, xas->xa_offset);
+
+	offset = xas->xa_offset + sibs;
+	do {
+		if (xas->xa_shift < node->shift) {
+			struct xa_node *child = xas->xa_alloc;
+
+			xas->xa_alloc = rcu_dereference_raw(child->parent);
+			child->shift = node->shift - XA_CHUNK_SHIFT;
+			child->offset = offset;
+			child->count = XA_CHUNK_SIZE;
+			child->nr_values = xa_is_value(entry) ?
+					XA_CHUNK_SIZE : 0;
+			RCU_INIT_POINTER(child->parent, node);
+			node_set_marks(node, offset, child, marks);
+			rcu_assign_pointer(node->slots[offset],
+					xa_mk_node(child));
+			if (xa_is_value(curr))
+				values--;
+		} else {
+			unsigned int canon = offset - xas->xa_sibs;
+
+			node_set_marks(node, canon, NULL, marks);
+			rcu_assign_pointer(node->slots[canon], entry);
+			while (offset > canon)
+				rcu_assign_pointer(node->slots[offset--],
+						xa_mk_sibling(canon));
+			values += (xa_is_value(entry) - xa_is_value(curr)) *
+					(xas->xa_sibs + 1);
+		}
+	} while (offset-- > xas->xa_offset);
+
+	node->nr_values += values;
+}
+EXPORT_SYMBOL_GPL(xas_split);
+#endif
+
 /**
  * xas_pause() - Pause a walk to drop a lock.
  * @xas: XArray operation state.
@@ -1407,7 +1557,7 @@ EXPORT_SYMBOL(__xa_store);
  * @gfp: Memory allocation flags.
  *
  * After this function returns, loads from this index will return @entry.
- * Storing into an existing multislot entry updates the entry of every index.
+ * Storing into an existing multi-index entry updates the entry of every index.
  * The marks associated with @index are unaffected unless @entry is %NULL.
  *
  * Context: Any context.  Takes and releases the xa_lock.
@@ -1549,7 +1699,7 @@ static void xas_set_range(struct xa_state *xas, unsigned long first,
  *
  * After this function returns, loads from any index between @first and @last,
  * inclusive will return @entry.
- * Storing into an existing multislot entry updates the entry of every index.
+ * Storing into an existing multi-index entry updates the entry of every index.
  * The marks associated with @index are unaffected unless @entry is %NULL.
  *
  * Context: Process context.  Takes and releases the xa_lock.  May sleep
-- 
2.30.2

