Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862302A5125
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgKCUi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgKCUiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE5C22277;
        Tue,  3 Nov 2020 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435904;
        bh=i4ns7iSzB8dZdjIZi8xUq472DzQzfOmUOGL8C5RbVU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJlvfn4htv+gJLi93LFPnG+V66n+zDeu2dTvVriVasg3FtmndP/oCexFEOMvpXqTc
         +d24kfGsXlyHJ0aSTv8UyYvQQtKTP9w34Lu5qjShZE7dILUElq4s34BWUBDBFT2iHu
         HL8QKwSDfdju3q/Aj/m9dq68vM2NhkU3D6Ew5PdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 034/391] afs: Wrap page->private manipulations in inline functions
Date:   Tue,  3 Nov 2020 21:31:25 +0100
Message-Id: <20201103203350.037886844@linuxfoundation.org>
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

[ Upstream commit 185f0c7073bd5c78f86265f703f5daf1306ab5a7 ]

The afs filesystem uses page->private to store the dirty range within a
page such that in the event of a conflicting 3rd-party write to the server,
we write back just the bits that got changed locally.

However, there are a couple of problems with this:

 (1) I need a bit to note if the page might be mapped so that partial
     invalidation doesn't shrink the range.

 (2) There aren't necessarily sufficient bits to store the entire range of
     data altered (say it's a 32-bit system with 64KiB pages or transparent
     huge pages are in use).

So wrap the accesses in inline functions so that future commits can change
how this works.

Also move them out of the tracing header into the in-directory header.
There's not really any need for them to be in the tracing header.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h          | 28 ++++++++++++++++++++++++++++
 fs/afs/write.c             | 31 +++++++++++++------------------
 include/trace/events/afs.h | 19 +++----------------
 3 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c8acb58ac5d8f..523bf9698ecdc 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -857,6 +857,34 @@ struct afs_vnode_cache_aux {
 	u64			data_version;
 } __packed;
 
+/*
+ * We use page->private to hold the amount of the page that we've written to,
+ * splitting the field into two parts.  However, we need to represent a range
+ * 0...PAGE_SIZE inclusive, so we can't support 64K pages on a 32-bit system.
+ */
+#if PAGE_SIZE > 32768
+#define __AFS_PAGE_PRIV_MASK	0xffffffffUL
+#define __AFS_PAGE_PRIV_SHIFT	32
+#else
+#define __AFS_PAGE_PRIV_MASK	0xffffUL
+#define __AFS_PAGE_PRIV_SHIFT	16
+#endif
+
+static inline size_t afs_page_dirty_from(unsigned long priv)
+{
+	return priv & __AFS_PAGE_PRIV_MASK;
+}
+
+static inline size_t afs_page_dirty_to(unsigned long priv)
+{
+	return (priv >> __AFS_PAGE_PRIV_SHIFT) & __AFS_PAGE_PRIV_MASK;
+}
+
+static inline unsigned long afs_page_dirty(size_t from, size_t to)
+{
+	return ((unsigned long)to << __AFS_PAGE_PRIV_SHIFT) | from;
+}
+
 #include <trace/events/afs.h>
 
 /*****************************************************************************/
diff --git a/fs/afs/write.c b/fs/afs/write.c
index f28d85c38cd89..ea1768b3c0b56 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -117,8 +117,8 @@ try_again:
 	t = f = 0;
 	if (PagePrivate(page)) {
 		priv = page_private(page);
-		f = priv & AFS_PRIV_MAX;
-		t = priv >> AFS_PRIV_SHIFT;
+		f = afs_page_dirty_from(priv);
+		t = afs_page_dirty_to(priv);
 		ASSERTCMP(f, <=, t);
 	}
 
@@ -206,22 +206,18 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 
 	if (PagePrivate(page)) {
 		priv = page_private(page);
-		f = priv & AFS_PRIV_MAX;
-		t = priv >> AFS_PRIV_SHIFT;
+		f = afs_page_dirty_from(priv);
+		t = afs_page_dirty_to(priv);
 		if (from < f)
 			f = from;
 		if (to > t)
 			t = to;
-		priv = (unsigned long)t << AFS_PRIV_SHIFT;
-		priv |= f;
+		priv = afs_page_dirty(f, t);
 		set_page_private(page, priv);
 		trace_afs_page_dirty(vnode, tracepoint_string("dirty+"),
 				     page->index, priv);
 	} else {
-		f = from;
-		t = to;
-		priv = (unsigned long)t << AFS_PRIV_SHIFT;
-		priv |= f;
+		priv = afs_page_dirty(from, to);
 		attach_page_private(page, (void *)priv);
 		trace_afs_page_dirty(vnode, tracepoint_string("dirty"),
 				     page->index, priv);
@@ -522,8 +518,8 @@ static int afs_write_back_from_locked_page(struct address_space *mapping,
 	 */
 	start = primary_page->index;
 	priv = page_private(primary_page);
-	offset = priv & AFS_PRIV_MAX;
-	to = priv >> AFS_PRIV_SHIFT;
+	offset = afs_page_dirty_from(priv);
+	to = afs_page_dirty_to(priv);
 	trace_afs_page_dirty(vnode, tracepoint_string("store"),
 			     primary_page->index, priv);
 
@@ -568,8 +564,8 @@ static int afs_write_back_from_locked_page(struct address_space *mapping,
 			}
 
 			priv = page_private(page);
-			f = priv & AFS_PRIV_MAX;
-			t = priv >> AFS_PRIV_SHIFT;
+			f = afs_page_dirty_from(priv);
+			t = afs_page_dirty_to(priv);
 			if (f != 0 &&
 			    !test_bit(AFS_VNODE_NEW_CONTENT, &vnode->flags)) {
 				unlock_page(page);
@@ -870,8 +866,7 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 	 */
 	wait_on_page_writeback(vmf->page);
 
-	priv = (unsigned long)PAGE_SIZE << AFS_PRIV_SHIFT; /* To */
-	priv |= 0; /* From */
+	priv = afs_page_dirty(0, PAGE_SIZE);
 	trace_afs_page_dirty(vnode, tracepoint_string("mkwrite"),
 			     vmf->page->index, priv);
 	if (PagePrivate(vmf->page))
@@ -930,8 +925,8 @@ int afs_launder_page(struct page *page)
 		f = 0;
 		t = PAGE_SIZE;
 		if (PagePrivate(page)) {
-			f = priv & AFS_PRIV_MAX;
-			t = priv >> AFS_PRIV_SHIFT;
+			f = afs_page_dirty_from(priv);
+			t = afs_page_dirty_to(priv);
 		}
 
 		trace_afs_page_dirty(vnode, tracepoint_string("launder"),
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 5f0c1cf1ea130..05b5506cd24ca 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -884,19 +884,6 @@ TRACE_EVENT(afs_dir_check_failed,
 		      __entry->vnode, __entry->off, __entry->i_size)
 	    );
 
-/*
- * We use page->private to hold the amount of the page that we've written to,
- * splitting the field into two parts.  However, we need to represent a range
- * 0...PAGE_SIZE inclusive, so we can't support 64K pages on a 32-bit system.
- */
-#if PAGE_SIZE > 32768
-#define AFS_PRIV_MAX	0xffffffff
-#define AFS_PRIV_SHIFT	32
-#else
-#define AFS_PRIV_MAX	0xffff
-#define AFS_PRIV_SHIFT	16
-#endif
-
 TRACE_EVENT(afs_page_dirty,
 	    TP_PROTO(struct afs_vnode *vnode, const char *where,
 		     pgoff_t page, unsigned long priv),
@@ -917,10 +904,10 @@ TRACE_EVENT(afs_page_dirty,
 		    __entry->priv = priv;
 			   ),
 
-	    TP_printk("vn=%p %lx %s %lu-%lu",
+	    TP_printk("vn=%p %lx %s %zx-%zx",
 		      __entry->vnode, __entry->page, __entry->where,
-		      __entry->priv & AFS_PRIV_MAX,
-		      __entry->priv >> AFS_PRIV_SHIFT)
+		      afs_page_dirty_from(__entry->priv),
+		      afs_page_dirty_to(__entry->priv))
 	    );
 
 TRACE_EVENT(afs_call_state,
-- 
2.27.0



