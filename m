Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0675339E813
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhFGUL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFGULz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:11:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C6DC061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=POnruMVNTXYPeUDlaBOyg52K2ybjsRkCFKM716zqtcI=; b=L4xb+KJkwLSGIg9Jq2F/3xiEPk
        ppK0VehTmQzTql6+VQmLRed0rXNqeEKog+D7Eg1OlwQ9Rh2s9zd419W+kqP5QByeDpAfQvX0tIYhK
        8BfvQRtgT7nS4KHG3dC8M9IB5gO4SZtakYpaXtMBGMWhWKD6lJotLtm9DV69IDjZvMOIdUCNSFyJw
        kh1tR5wQc0dHxpQE6rMASLMTgIYQOXgT12bDIgj+V+DhJ0DlJj+qnnv5sil5QqCii1jFNxc5O4eHz
        75SBdgIMCNb/c4OusX/ImExUc1WkQeY6aaiTpwGyjjb263ejUnz1vYZn8QQ9dRN5doDsJPBNA+vWs
        GqXAbzLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqLYu-00GCM5-Ix; Mon, 07 Jun 2021 20:09:35 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Qian Cai <cai@lca.pw>, Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] XArray: add xa_get_order
Date:   Mon,  7 Jun 2021 21:08:43 +0100
Message-Id: <20210607200845.3860579-3-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607200845.3860579-1-willy@infradead.org>
References: <20210607200845.3860579-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 57417cebc96b57122a2207fc84a6077d20c84b4b upstream

Patch series "Fix read-only THP for non-tmpfs filesystems".

As described more verbosely in the [3/3] changelog, we can inadvertently
put an order-0 page in the page cache which occupies 512 consecutive
entries.  Users are running into this if they enable the
READ_ONLY_THP_FOR_FS config option; see
https://bugzilla.kernel.org/show_bug.cgi?id=206569 and Qian Cai has also
reported it here:
https://lore.kernel.org/lkml/20200616013309.GB815@lca.pw/

This is a rather intrusive way of fixing the problem, but has the
advantage that I've actually been testing it with the THP patches, which
means that it sees far more use than it does upstream -- indeed, Song has
been entirely unable to reproduce it.  It also has the advantage that it
removes a few patches from my gargantuan backlog of THP patches.

This patch (of 3):

This function returns the order of the entry at the index.  We need this
because there isn't space in the shadow entry to encode its order.

[akpm@linux-foundation.org: export xa_get_order to modules]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lkml.kernel.org/r/20200903183029.14930-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200903183029.14930-2-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/xarray.h |  9 +++++++++
 lib/test_xarray.c      | 21 +++++++++++++++++++++
 lib/xarray.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 3b257c97837d..63185fe7cd6a 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1470,6 +1470,15 @@ void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
 
+#ifdef CONFIG_XARRAY_MULTI
+int xa_get_order(struct xarray *, unsigned long index);
+#else
+static inline int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	return 0;
+}
+#endif
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index d4f97925dbd8..bdd4d7995f79 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1649,6 +1649,26 @@ static noinline void check_account(struct xarray *xa)
 #endif
 }
 
+static noinline void check_get_order(struct xarray *xa)
+{
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned int order;
+	unsigned long i, j;
+
+	for (i = 0; i < 3; i++)
+		XA_BUG_ON(xa, xa_get_order(xa, i) != 0);
+
+	for (order = 0; order < max_order; order++) {
+		for (i = 0; i < 10; i++) {
+			xa_store_order(xa, i << order, order,
+					xa_mk_index(i << order), GFP_KERNEL);
+			for (j = i << order; j < (i + 1) << order; j++)
+				XA_BUG_ON(xa, xa_get_order(xa, j) != order);
+			xa_erase(xa, i << order);
+		}
+	}
+}
+
 static noinline void check_destroy(struct xarray *xa)
 {
 	unsigned long index;
@@ -1697,6 +1717,7 @@ static int xarray_checks(void)
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
+	check_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
diff --git a/lib/xarray.c b/lib/xarray.c
index 08d71c7b7599..57b9c144f793 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1592,6 +1592,46 @@ void *xa_store_range(struct xarray *xa, unsigned long first,
 	return xas_result(&xas, NULL);
 }
 EXPORT_SYMBOL(xa_store_range);
+
+/**
+ * xa_get_order() - Get the order of an entry.
+ * @xa: XArray.
+ * @index: Index of the entry.
+ *
+ * Return: A number between 0 and 63 indicating the order of the entry.
+ */
+int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+	int order = 0;
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+
+	if (!entry)
+		goto unlock;
+
+	if (!xas.xa_node)
+		goto unlock;
+
+	for (;;) {
+		unsigned int slot = xas.xa_offset + (1 << order);
+
+		if (slot >= XA_CHUNK_SIZE)
+			break;
+		if (!xa_is_sibling(xas.xa_node->slots[slot]))
+			break;
+		order++;
+	}
+
+	order += xas.xa_node->shift;
+unlock:
+	rcu_read_unlock();
+
+	return order;
+}
+EXPORT_SYMBOL(xa_get_order);
 #endif /* CONFIG_XARRAY_MULTI */
 
 /**
-- 
2.30.2

