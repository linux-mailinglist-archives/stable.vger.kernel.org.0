Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8442D151C1D
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 15:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgBDOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 09:25:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:49626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgBDOZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 09:25:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD2AFAEDE;
        Tue,  4 Feb 2020 14:25:17 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E38C01E0B00; Tue,  4 Feb 2020 15:25:15 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/8] xarray: Fix premature termination of xas_for_each_marked()
Date:   Tue,  4 Feb 2020 15:25:07 +0100
Message-Id: <20200204142514.15826-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200204142514.15826-1-jack@suse.cz>
References: <20200204142514.15826-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xas_for_each_marked() is using entry == NULL as a termination condition
of the iteration. When xas_for_each_marked() is used protected only by
RCU, this can however race with xas_store(xas, NULL) in the following
way:

TASK1                                   TASK2
page_cache_delete()                     find_get_pages_range_tag()
                                          xas_for_each_marked()
                                            xas_find_marked()
                                              off = xas_find_chunk()

  xas_store(&xas, NULL)
    xas_init_marks(&xas);
    ...
    rcu_assign_pointer(*slot, NULL);
                                              entry = xa_entry(off);

And thus xas_for_each_marked() terminates prematurely possibly leading
to missed entries in the iteration (translating to missing writeback of
some pages or a similar problem).

Fix the problem by creating a special version of xas_find_marked() -
xas_find_valid_marked() - that does not return NULL marked entries and
changing xas_next_marked() in the same way.

CC: stable@vger.kernel.org
Fixes: ef8e5717db01 "page cache: Convert delete_batch to XArray"
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/xarray.h | 64 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index f73e1775ded0..5370716d7010 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1633,33 +1633,63 @@ static inline unsigned int xas_find_chunk(struct xa_state *xas, bool advance,
 }
 
 /**
- * xas_next_marked() - Advance iterator to next marked entry.
+ * xas_find_valid_marked() - Find the next marked valid entry in the XArray.
+ * @xas: XArray operation state.
+ * @max: Highest index to return.
+ * @mark: Mark number to search for.
+ *
+ * This is like xas_find_marked() except that we also skip over all %NULL
+ * marked entries.
+ *
+ * Return: The entry, if found, otherwise %NULL.
+ */
+static inline void *xas_find_valid_marked(struct xa_state *xas,
+					  unsigned long max, xa_mark_t mark)
+{
+	void *entry;
+
+	do {
+		entry = xas_find_marked(xas, max, mark);
+	} while (unlikely(entry == NULL) && xas_valid(xas));
+
+	return entry;
+}
+
+/**
+ * xas_next_valid_marked() - Advance iterator to next valid marked entry.
  * @xas: XArray operation state.
  * @max: Highest index to return.
  * @mark: Mark to search for.
  *
- * xas_next_marked() is an inline function to optimise xarray traversal for
- * speed.  It is equivalent to calling xas_find_marked(), and will call
- * xas_find_marked() for all the hard cases.
+ * xas_next_valid_marked() is an inline function to optimise xarray traversal
+ * for speed. It is equivalent to calling xas_find_valid_marked(), and will
+ * call xas_find_marked() for all the hard cases. The function skips over %NULL
+ * marked entries.
  *
  * Return: The next marked entry after the one currently referred to by @xas.
  */
-static inline void *xas_next_marked(struct xa_state *xas, unsigned long max,
-								xa_mark_t mark)
+static inline void *xas_next_valid_marked(struct xa_state *xas,
+					  unsigned long max, xa_mark_t mark)
 {
 	struct xa_node *node = xas->xa_node;
 	unsigned int offset;
+	void *entry;
 
 	if (unlikely(xas_not_node(node) || node->shift))
-		return xas_find_marked(xas, max, mark);
-	offset = xas_find_chunk(xas, true, mark);
-	xas->xa_offset = offset;
-	xas->xa_index = (xas->xa_index & ~XA_CHUNK_MASK) + offset;
-	if (xas->xa_index > max)
-		return NULL;
-	if (offset == XA_CHUNK_SIZE)
-		return xas_find_marked(xas, max, mark);
-	return xa_entry(xas->xa, node, offset);
+		return xas_find_valid_marked(xas, max, mark);
+
+	do {
+		offset = xas_find_chunk(xas, true, mark);
+		xas->xa_offset = offset;
+		xas->xa_index = (xas->xa_index & ~XA_CHUNK_MASK) + offset;
+		if (xas->xa_index > max)
+			return NULL;
+		if (offset == XA_CHUNK_SIZE)
+			return xas_find_valid_marked(xas, max, mark);
+		entry = xa_entry(xas->xa, node, offset);
+	} while (unlikely(!entry));
+
+	return entry;
 }
 
 /*
@@ -1702,8 +1732,8 @@ enum {
  * xas_pause() first.
  */
 #define xas_for_each_marked(xas, entry, max, mark) \
-	for (entry = xas_find_marked(xas, max, mark); entry; \
-	     entry = xas_next_marked(xas, max, mark))
+	for (entry = xas_find_valid_marked(xas, max, mark); entry; \
+	     entry = xas_next_valid_marked(xas, max, mark))
 
 /**
  * xas_for_each_conflict() - Iterate over a range of an XArray.
-- 
2.16.4

