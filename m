Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E933B616D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhF1Of7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234636AbhF1Oct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCFF261C89;
        Mon, 28 Jun 2021 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890469;
        bh=4dSHOaEQAwIC7L/z6GDnBLBuNItxIOeL6nJQC2uEptM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuvH/kBiSEiIE4/IOqYd95uv0Uq2grF+XynbjJpv1MKlc2DTUap4xN1yc1s7jwgA/
         6vZQHK6xlop7wycUb3PGlbYZME5mFL4xv0C9EX6PRhyi6xWxnmh6YFyINbYcZ2fsG9
         2fZSws1vH5f8WiQHw9p866AqyKa9ivFDS2wPKmN4ioKWgin4FuKS3DLmALKdjk1dl9
         8pPB4J2/p4ET07VPGGvN4AuJd4O54EaL7K4IFwwKun7BU7Dcb8GQBsxEsHCoiv+ul2
         cj3NRklOl9YSTViE4yNLjuA2UTfOgVioPZCuJ0H4mZs5g8IWTuvOGciFBC6dZtl+Lu
         ndxTZve94CYXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Andrew W Elble <aweits@rit.edu>,
        David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        ceph-devel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 095/101] netfs: fix test for whether we can skip read when writing beyond EOF
Date:   Mon, 28 Jun 2021 10:26:01 -0400
Message-Id: <20210628142607.32218-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 827a746f405d25f79560c7868474aec5aee174e1 upstream.

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write.

Add a new helper function that corrects and clarifies the logic of
when we can skip reads, and have it only zero out the part of the page
that won't have data copied in for the write.

Finally, don't set the page Uptodate after zeroing. It's not up to date
since the write data won't have been copied in yet.

[DH made the following changes:

 - Prefixed the new function with "netfs_".

 - Don't call zero_user_segments() for a full-page write.

 - Altered the beyond-last-page check to avoid a DIV instruction and got
   rid of then-redundant zero-length file check.
]

[ Note: this fix is commit 827a746f405d in mainline kernels. The
	original bug was in ceph, but got lifted into the fs/netfs
	library for v5.13. This backport should apply to stable
	kernels v5.10 though v5.12. ]

Fixes: e1b1240c1ff5f ("netfs: Add write_begin helper")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
cc: ceph-devel@vger.kernel.org
Link: https://lore.kernel.org/r/20210613233345.113565-1-jlayton@kernel.org/
Link: https://lore.kernel.org/r/162367683365.460125.4467036947364047314.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/162391826758.1173366.11794946719301590013.stgit@warthog.procyon.org.uk/ # v2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c | 54 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 35c83f65475b..8b0507f69c15 100644
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
2.30.2

