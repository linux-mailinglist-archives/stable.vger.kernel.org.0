Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD13A57FE
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFMLix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231658AbhFMLix (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 07:38:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ACF36109F;
        Sun, 13 Jun 2021 11:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623584212;
        bh=Tk2jtNrNpx2gA0y0us6CkzFllWr0vN4QgICn5Qehn6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHQ+VRHz+wR7JVfqgarcZu+gBaBx8RwATPPtVVS9vIfkW6+Bw3zQyMProiR9YDMEp
         TMcRFMtlCzBW24fbMl9aJx05sse5zJZ8CZgiPMni7yWskfMK6onAYvIj+o5IrQFqnH
         Lglsq2v5wymBpTzkwCoZCMfauMrw3AJfeXsdbMsIx0/8J4ZiIcVF5AN+kEo6OW9Zey
         4DWXmQaStxVzR2O+/M8vRw9MSCN4SqwFB5QgEC2qSwlSQ43IrtcFrzn9D23lcslpvW
         KTiGA5V0+OUUrLjWkmuR7dvjjzoo4v4aVlj5JJB4hcWMIk0cWnmaN0akLg4G3fBfpq
         nsN9Uqf3ip7hQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, idryomov@gmail.com, stable@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: [PATCH v4] ceph: fix write_begin optimization when write is beyond EOF
Date:   Sun, 13 Jun 2021 07:36:50 -0400
Message-Id: <20210613113650.8672-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YMXmRo17oy8fDn2b@casper.infradead.org>
References: <YMXmRo17oy8fDn2b@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write.

Add a new helper function that corrects and clarifies the logic.

Cc: <stable@vger.kernel.org> # v5.10+
Cc: Matthew Wilcox <willy@infradead.org>
Fixes: 1cc1699070bd ("ceph: fold ceph_update_writeable_page into ceph_write_begin")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 63 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 13 deletions(-)

This version just has a couple of future-proofing tweaks that Willy
suggested.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 26e66436f005..b20a17cfec42 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1302,6 +1302,54 @@ ceph_find_incompatible(struct page *page)
 	return NULL;
 }
 
+/**
+ * prep_noread_page - prep a page for writing without reading first
+ * @page: page being prepared
+ * @pos: starting position for the write
+ * @len: length of write
+ *
+ * In some cases we don't need to read at all:
+ * - full page write
+ * - file is currently zero-length
+ * - write that lies in a page that is completely beyond EOF
+ * - write that covers the the page from start to EOF or beyond it
+ *
+ * If any of these criteria are met, then zero out the unwritten parts
+ * of the page and return true. Otherwise, return false.
+ */
+static bool prep_noread_page(struct page *page, loff_t pos, size_t len)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	pgoff_t index = pos / PAGE_SIZE;
+	size_t offset = offset_in_page(pos);
+
+	/* clamp length to end of the current page */
+	if (len > PAGE_SIZE)
+		len = PAGE_SIZE - offset;
+
+	/* full page write */
+	if (offset == 0 && len == PAGE_SIZE)
+		goto zero_out;
+
+	/* zero-length file */
+	if (i_size == 0)
+		goto zero_out;
+
+	/* position beyond last page in the file */
+	if (index > ((i_size - 1) / PAGE_SIZE))
+		goto zero_out;
+
+	/* write that covers the the page from start to EOF or beyond it */
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
@@ -1315,7 +1363,6 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 	struct ceph_snap_context *snapc;
 	struct page *page = NULL;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int pos_in_page = pos & ~PAGE_MASK;
 	int r = 0;
 
 	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
@@ -1350,19 +1397,9 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
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
+		if (prep_noread_page(page, pos, len))
 			break;
-		}
 
 		/*
 		 * We need to read it. If we get back -EINPROGRESS, then the page was
-- 
2.31.1

