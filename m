Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7D3B5461
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 18:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhF0Qlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 12:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhF0Qlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 12:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C90CD61428;
        Sun, 27 Jun 2021 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624811971;
        bh=tRDn6cZLCJ2Z+4FsLVLe4nhKGDMLvB3sQ9NAaEBIDy4=;
        h=From:To:Cc:Subject:Date:From;
        b=EZYXgG/cJdyLUH/KunruQFLrnEGQYP5UJeNgwdyfZxhMCBRL94MGEH0szJpNTnrEz
         4R9/mkQX/aNQ1okCmRJAJZHODfuOFrVvb7ouKdwTRssO63YjpfJ1xGMTExvcoTCoO4
         iSB/ELbii3vLFj3aWdpCRtaXM1v7Hpq+H5GNDADHyJrCHasFa+BSilCyxZbsjIAu9e
         lIdTr/PEtFLWLJ0b+9JW/3332inpW0xZyu6IhbQpyYHbwGhySZEOYiRxiKkOp6LCmX
         aFunBoB4Cjuh780ZD8gU16f+u424yCR4KaI9EdMsx4fgZIzmbKb8gEUEi86pNWu3OE
         H45zoy0IAnNfw==
From:   Jeff Layton <jlayton@kernel.org>
To:     stable@vger.kernel.org
Cc:     dhowells@redhat.com, Andrew W Elble <aweits@rit.edu>
Subject: [PATCH][RESEND] ceph: fix test for whether we can skip read when writing beyond EOF
Date:   Sun, 27 Jun 2021 12:39:29 -0400
Message-Id: <20210627163929.15768-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write.

Add a new helper function that corrects and clarifies the logic of
when we can skip reads, and have it only zero out the part of the page
that won't have data copied in for the write.

[ Note: this fix is commit 827a746f405d in mainline kernels. The
	original bug was in ceph, but got lifted into the fs/netfs
	library for v5.13. This backport should apply to stable
	kernels v5.10 though v5.12. ]

Cc: <stable@vger.kernel.org> # v5.10+
Fixes: 1cc1699070bd ("ceph: fold ceph_update_writeable_page into ceph_write_begin")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/ceph/addr.c | 54 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 26e66436f005..c000fe338f7e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1302,6 +1302,45 @@ ceph_find_incompatible(struct page *page)
 	return NULL;
 }
 
+/**
+ * prep_noread_page - prep a page for writing without reading first
+ * @page: page being prepared
+ * @pos: starting position for the write
+ * @len: length of write
+ *
+ * In some cases, write_begin doesn't need to read at all:
+ * - full page write
+ * - file is currently zero-length
+ * - write that lies in a page that is completely beyond EOF
+ * - write that covers the the page from start to EOF or beyond it
+ *
+ * If any of these criteria are met, then zero out the unwritten parts
+ * of the page and return true. Otherwise, return false.
+ */
+static bool skip_page_read(struct page *page, loff_t pos, size_t len)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	size_t offset = offset_in_page(pos);
+
+	/* Full page write */
+	if (offset == 0 && len >= PAGE_SIZE)
+		return true;
+
+	/* pos beyond last page in the file */
+	if (pos - offset >= i_size)
+		goto zero_out;
+
+	/* write that covers the whole page from start to EOF or beyond it */
+	if (offset == 0 && (pos + len) >= i_size)
+		goto zero_out;
+
+	return false;
+zero_out:
+	zero_user_segments(page, 0, offset, offset + len, PAGE_SIZE);
+	return true;
+}
+
 /*
  * We are only allowed to write into/dirty the page if the page is
  * clean, or already dirty within the same snap context.
@@ -1315,7 +1354,6 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 	struct ceph_snap_context *snapc;
 	struct page *page = NULL;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int pos_in_page = pos & ~PAGE_MASK;
 	int r = 0;
 
 	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
@@ -1350,19 +1388,9 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 			break;
 		}
 
-		/*
-		 * In some cases we don't need to read at all:
-		 * - full page write
-		 * - write that lies completely beyond EOF
-		 * - write that covers the the page from start to EOF or beyond it
-		 */
-		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
-		    (pos >= i_size_read(inode)) ||
-		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
-			zero_user_segments(page, 0, pos_in_page,
-					   pos_in_page + len, PAGE_SIZE);
+		/* No need to read in some cases */
+		if (skip_page_read(page, pos, len))
 			break;
-		}
 
 		/*
 		 * We need to read it. If we get back -EINPROGRESS, then the page was
-- 
2.31.1

