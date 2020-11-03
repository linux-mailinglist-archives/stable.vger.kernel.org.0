Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259DF2A5121
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgKCUiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgKCUiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F149D22226;
        Tue,  3 Nov 2020 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435897;
        bh=MNWuRsbaqZbwvImpaxXFVUygwK+q3aVGcuO+mMLktVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1jNp5b+YNccWiDilChBwaT8KaugHZOdPoXFKkMS2GWAoMjqMbuHZSFAqHtSJK2XE
         rKVuHuHWZI5gVAyrbRFMVGyCcQbbFd/l2kY/MfGxb6O744GnI2V2IOQ6oQLzOyZTNO
         rdHGduf6DZT57QmUEX3vhRafesgYTtkaO3TStYgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 031/391] afs: Fix to take ref on page when PG_private is set
Date:   Tue,  3 Nov 2020 21:31:22 +0100
Message-Id: <20201103203349.864174637@linuxfoundation.org>
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

[ Upstream commit fa04a40b169fcee615afbae97f71a09332993f64 ]

Fix afs to take a ref on a page when it sets PG_private on it and to drop
the ref when removing the flag.

Note that in afs_write_begin(), a lot of the time, PG_private is already
set on a page to which we're going to add some data.  In such a case, we
leave the bit set and mustn't increment the page count.

As suggested by Matthew Wilcox, use attach/detach_page_private() where
possible.

Fixes: 31143d5d515e ("AFS: implement basic file write support")
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c      | 12 ++++--------
 fs/afs/dir_edit.c |  6 ++----
 fs/afs/file.c     |  8 ++------
 fs/afs/write.c    | 18 ++++++++++--------
 4 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 1d2e61e0ab047..1bb5b9d7f0a2c 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -281,8 +281,7 @@ retry:
 			if (ret < 0)
 				goto error;
 
-			set_page_private(req->pages[i], 1);
-			SetPagePrivate(req->pages[i]);
+			attach_page_private(req->pages[i], (void *)1);
 			unlock_page(req->pages[i]);
 			i++;
 		} else {
@@ -1975,8 +1974,7 @@ static int afs_dir_releasepage(struct page *page, gfp_t gfp_flags)
 
 	_enter("{{%llx:%llu}[%lu]}", dvnode->fid.vid, dvnode->fid.vnode, page->index);
 
-	set_page_private(page, 0);
-	ClearPagePrivate(page);
+	detach_page_private(page);
 
 	/* The directory will need reloading. */
 	if (test_and_clear_bit(AFS_VNODE_DIR_VALID, &dvnode->flags))
@@ -2003,8 +2001,6 @@ static void afs_dir_invalidatepage(struct page *page, unsigned int offset,
 		afs_stat_v(dvnode, n_inval);
 
 	/* we clean up only if the entire page is being invalidated */
-	if (offset == 0 && length == PAGE_SIZE) {
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-	}
+	if (offset == 0 && length == PAGE_SIZE)
+		detach_page_private(page);
 }
diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index b108528bf010d..2ffe09abae7fc 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -243,10 +243,8 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 						   index, gfp);
 			if (!page)
 				goto error;
-			if (!PagePrivate(page)) {
-				set_page_private(page, 1);
-				SetPagePrivate(page);
-			}
+			if (!PagePrivate(page))
+				attach_page_private(page, (void *)1);
 			dir_page = kmap(page);
 		}
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 371d1488cc549..bdcf418e4a5c0 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -626,11 +626,9 @@ static void afs_invalidatepage(struct page *page, unsigned int offset,
 #endif
 
 		if (PagePrivate(page)) {
-			priv = page_private(page);
+			priv = (unsigned long)detach_page_private(page);
 			trace_afs_page_dirty(vnode, tracepoint_string("inval"),
 					     page->index, priv);
-			set_page_private(page, 0);
-			ClearPagePrivate(page);
 		}
 	}
 
@@ -660,11 +658,9 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 #endif
 
 	if (PagePrivate(page)) {
-		priv = page_private(page);
+		priv = (unsigned long)detach_page_private(page);
 		trace_afs_page_dirty(vnode, tracepoint_string("rel"),
 				     page->index, priv);
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
 	}
 
 	/* indicate that the page can be released */
diff --git a/fs/afs/write.c b/fs/afs/write.c
index b937ec047ec98..02facb19a0f1d 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -151,8 +151,10 @@ try_again:
 	priv |= f;
 	trace_afs_page_dirty(vnode, tracepoint_string("begin"),
 			     page->index, priv);
-	SetPagePrivate(page);
-	set_page_private(page, priv);
+	if (PagePrivate(page))
+		set_page_private(page, priv);
+	else
+		attach_page_private(page, (void *)priv);
 	_leave(" = 0");
 	return 0;
 
@@ -334,10 +336,9 @@ static void afs_pages_written_back(struct afs_vnode *vnode,
 		ASSERTCMP(pv.nr, ==, count);
 
 		for (loop = 0; loop < count; loop++) {
-			priv = page_private(pv.pages[loop]);
+			priv = (unsigned long)detach_page_private(pv.pages[loop]);
 			trace_afs_page_dirty(vnode, tracepoint_string("clear"),
 					     pv.pages[loop]->index, priv);
-			set_page_private(pv.pages[loop], 0);
 			end_page_writeback(pv.pages[loop]);
 		}
 		first += count;
@@ -863,8 +864,10 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 	priv |= 0; /* From */
 	trace_afs_page_dirty(vnode, tracepoint_string("mkwrite"),
 			     vmf->page->index, priv);
-	SetPagePrivate(vmf->page);
-	set_page_private(vmf->page, priv);
+	if (PagePrivate(vmf->page))
+		set_page_private(vmf->page, priv);
+	else
+		attach_page_private(vmf->page, (void *)priv);
 	file_update_time(file);
 
 	sb_end_pagefault(inode->i_sb);
@@ -926,10 +929,9 @@ int afs_launder_page(struct page *page)
 		ret = afs_store_data(mapping, page->index, page->index, t, f, true);
 	}
 
+	priv = (unsigned long)detach_page_private(page);
 	trace_afs_page_dirty(vnode, tracepoint_string("laundered"),
 			     page->index, priv);
-	set_page_private(page, 0);
-	ClearPagePrivate(page);
 
 #ifdef CONFIG_AFS_FSCACHE
 	if (PageFsCache(page)) {
-- 
2.27.0



