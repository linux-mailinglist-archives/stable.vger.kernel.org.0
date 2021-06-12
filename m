Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943863A501F
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 20:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhFLShe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 14:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLShd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Jun 2021 14:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96B561182;
        Sat, 12 Jun 2021 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623522933;
        bh=OegiXBEbDz69Jlod1Nz5uiZDF03O+GavSJ/lYQnFGmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQmuCVuI2U36fPC04F/hsUvO1fT1kDJbmj/1UXug73mT7FQnKxHWIR3pE9AlsnGgW
         PE2gRi2XmJ71vTRt/XL9anB/GbEwKH7OHSmkwx3tDavm9eYx0IP7X9/VwshgBRnQVu
         w5JCX81abxaU78FoqYnzBy7sQgapnJteiMCdejERXc9+lO4qbHT/OjfOwNHAlmxtb4
         0ph3K4LcxzqSZEkwbghpprnV9pZt+fk3SNGigaq6JiGVRkxzgeDMvCrQjXCC7eKVIH
         AsBbOtvz022MqDfLAtAuEo1Yzo07sVDhNmtkDsjF1jbjzyLGZOCELpnOUBfv9VLjQX
         OlysUCnz8fz+A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, idryomov@gmail.com, stable@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: [PATCH v3] ceph: fix write_begin optimization when write is beyond EOF
Date:   Sat, 12 Jun 2021 14:35:31 -0400
Message-Id: <20210612183531.17074-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YMS4TOw8txQQ7VGr@casper.infradead.org>
References: <YMS4TOw8txQQ7VGr@casper.infradead.org>
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
Fixes: 1cc1699070bd ("ceph: fold ceph_update_writeable_page into ceph_write_begin")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 60 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 13 deletions(-)

Willy pointed out that I had missed the i_size == 0 case in my earlier
patch. Also, the whole condition was getting a bit messy. This factors
it out into a new helper (and we can maybe copy this helper into netfs
code).

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 26e66436f005..ba53e9a3f0c1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1302,6 +1302,51 @@ ceph_find_incompatible(struct page *page)
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
+static bool prep_noread_page(struct page *page, loff_t pos, unsigned int len)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	pgoff_t index = pos / PAGE_SIZE;
+	int pos_in_page = pos & ~PAGE_MASK;
+
+	/* full page write */
+	if (pos_in_page == 0 && len == PAGE_SIZE)
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
+	if (pos_in_page == 0 && (pos + len) >= i_size)
+		goto zero_out;
+
+	return false;
+zero_out:
+	zero_user_segments(page, 0, pos_in_page,
+			   pos_in_page + len, PAGE_SIZE);
+	return true;
+}
+
 /*
  * We are only allowed to write into/dirty the page if the page is
  * clean, or already dirty within the same snap context.
@@ -1315,7 +1360,6 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 	struct ceph_snap_context *snapc;
 	struct page *page = NULL;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int pos_in_page = pos & ~PAGE_MASK;
 	int r = 0;
 
 	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
@@ -1350,19 +1394,9 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
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

