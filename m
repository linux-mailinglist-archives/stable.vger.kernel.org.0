Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4162A514C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgKCUji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgKCUic (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDD52224E;
        Tue,  3 Nov 2020 20:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435911;
        bh=qhaudTHeILbUjgQ/rzfULsIFFnLjSihgHyKXTP3z4oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x87eRNa1QkgkPxJppjrrlAMKz4pZeT1graXESUtrHhXabmuOs1i18i6AbJDrwfCmg
         NvuWOYfJA1fLrKpNN145zgDgKT7xCFgknRgSOeCFKLVfcg2Dk3OTyoY+OhJZ4WCYEu
         xhK/lQife9iYpvUNEIYu2TU9t7BFsyuw9xaAUe7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 036/391] afs: Fix afs_invalidatepage to adjust the dirty region
Date:   Tue,  3 Nov 2020 21:31:27 +0100
Message-Id: <20201103203350.144623063@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f86726a69dec5df6ba051baf9265584419478b64 ]

Fix afs_invalidatepage() to adjust the dirty region recorded in
page->private when truncating a page.  If the dirty region is entirely
removed, then the private data is cleared and the page dirty state is
cleared.

Without this, if the page is truncated and then expanded again by truncate,
zeros from the expanded, but no-longer dirty region may get written back to
the server if the page gets laundered due to a conflicting 3rd-party write.

It mustn't, however, shorten the dirty region of the page if that page is
still mmapped and has been marked dirty by afs_page_mkwrite(), so a flag is
stored in page->private to record this.

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/file.c              | 71 ++++++++++++++++++++++++++++++++------
 fs/afs/internal.h          | 16 +++++++--
 fs/afs/write.c             |  1 +
 include/trace/events/afs.h |  5 +--
 4 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index bdcf418e4a5c0..5015f2b107824 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -600,6 +600,63 @@ static int afs_readpages(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+/*
+ * Adjust the dirty region of the page on truncation or full invalidation,
+ * getting rid of the markers altogether if the region is entirely invalidated.
+ */
+static void afs_invalidate_dirty(struct page *page, unsigned int offset,
+				 unsigned int length)
+{
+	struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
+	unsigned long priv;
+	unsigned int f, t, end = offset + length;
+
+	priv = page_private(page);
+
+	/* we clean up only if the entire page is being invalidated */
+	if (offset == 0 && length == thp_size(page))
+		goto full_invalidate;
+
+	 /* If the page was dirtied by page_mkwrite(), the PTE stays writable
+	  * and we don't get another notification to tell us to expand it
+	  * again.
+	  */
+	if (afs_is_page_dirty_mmapped(priv))
+		return;
+
+	/* We may need to shorten the dirty region */
+	f = afs_page_dirty_from(priv);
+	t = afs_page_dirty_to(priv);
+
+	if (t <= offset || f >= end)
+		return; /* Doesn't overlap */
+
+	if (f < offset && t > end)
+		return; /* Splits the dirty region - just absorb it */
+
+	if (f >= offset && t <= end)
+		goto undirty;
+
+	if (f < offset)
+		t = offset;
+	else
+		f = end;
+	if (f == t)
+		goto undirty;
+
+	priv = afs_page_dirty(f, t);
+	set_page_private(page, priv);
+	trace_afs_page_dirty(vnode, tracepoint_string("trunc"), page->index, priv);
+	return;
+
+undirty:
+	trace_afs_page_dirty(vnode, tracepoint_string("undirty"), page->index, priv);
+	clear_page_dirty_for_io(page);
+full_invalidate:
+	priv = (unsigned long)detach_page_private(page);
+	trace_afs_page_dirty(vnode, tracepoint_string("inval"), page->index, priv);
+}
+
 /*
  * invalidate part or all of a page
  * - release a page and clean up its private data if offset is 0 (indicating
@@ -608,29 +665,23 @@ static int afs_readpages(struct file *file, struct address_space *mapping,
 static void afs_invalidatepage(struct page *page, unsigned int offset,
 			       unsigned int length)
 {
-	struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
-	unsigned long priv;
-
 	_enter("{%lu},%u,%u", page->index, offset, length);
 
 	BUG_ON(!PageLocked(page));
 
+#ifdef CONFIG_AFS_FSCACHE
 	/* we clean up only if the entire page is being invalidated */
 	if (offset == 0 && length == PAGE_SIZE) {
-#ifdef CONFIG_AFS_FSCACHE
 		if (PageFsCache(page)) {
 			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
 			fscache_wait_on_page_write(vnode->cache, page);
 			fscache_uncache_page(vnode->cache, page);
 		}
+	}
 #endif
 
-		if (PagePrivate(page)) {
-			priv = (unsigned long)detach_page_private(page);
-			trace_afs_page_dirty(vnode, tracepoint_string("inval"),
-					     page->index, priv);
-		}
-	}
+	if (PagePrivate(page))
+		afs_invalidate_dirty(page, offset, length);
 
 	_leave("");
 }
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index fc96c090893f7..dbe4120e9a422 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -863,11 +863,13 @@ struct afs_vnode_cache_aux {
  * 0...PAGE_SIZE inclusive, so we can't support 64K pages on a 32-bit system.
  */
 #ifdef CONFIG_64BIT
-#define __AFS_PAGE_PRIV_MASK	0xffffffffUL
+#define __AFS_PAGE_PRIV_MASK	0x7fffffffUL
 #define __AFS_PAGE_PRIV_SHIFT	32
+#define __AFS_PAGE_PRIV_MMAPPED	0x80000000UL
 #else
-#define __AFS_PAGE_PRIV_MASK	0xffffUL
+#define __AFS_PAGE_PRIV_MASK	0x7fffUL
 #define __AFS_PAGE_PRIV_SHIFT	16
+#define __AFS_PAGE_PRIV_MMAPPED	0x8000UL
 #endif
 
 static inline size_t afs_page_dirty_from(unsigned long priv)
@@ -885,6 +887,16 @@ static inline unsigned long afs_page_dirty(size_t from, size_t to)
 	return ((unsigned long)(to - 1) << __AFS_PAGE_PRIV_SHIFT) | from;
 }
 
+static inline unsigned long afs_page_dirty_mmapped(unsigned long priv)
+{
+	return priv | __AFS_PAGE_PRIV_MMAPPED;
+}
+
+static inline bool afs_is_page_dirty_mmapped(unsigned long priv)
+{
+	return priv & __AFS_PAGE_PRIV_MMAPPED;
+}
+
 #include <trace/events/afs.h>
 
 /*****************************************************************************/
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 1a49f5c89342e..a2511e3ad2cca 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -867,6 +867,7 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 	wait_on_page_writeback(vmf->page);
 
 	priv = afs_page_dirty(0, PAGE_SIZE);
+	priv = afs_page_dirty_mmapped(priv);
 	trace_afs_page_dirty(vnode, tracepoint_string("mkwrite"),
 			     vmf->page->index, priv);
 	if (PagePrivate(vmf->page))
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 05b5506cd24ca..13c05e28c0b6c 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -904,10 +904,11 @@ TRACE_EVENT(afs_page_dirty,
 		    __entry->priv = priv;
 			   ),
 
-	    TP_printk("vn=%p %lx %s %zx-%zx",
+	    TP_printk("vn=%p %lx %s %zx-%zx%s",
 		      __entry->vnode, __entry->page, __entry->where,
 		      afs_page_dirty_from(__entry->priv),
-		      afs_page_dirty_to(__entry->priv))
+		      afs_page_dirty_to(__entry->priv),
+		      afs_is_page_dirty_mmapped(__entry->priv) ? " M" : "")
 	    );
 
 TRACE_EVENT(afs_call_state,
-- 
2.27.0



