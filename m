Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33952AB958
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgKINIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgKINIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8282076E;
        Mon,  9 Nov 2020 13:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927302;
        bh=a1Knb/cQT4fRI+gV0ieknx0fecnTLvbLev4U69v7yHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYZrfEag0609Y8XJvXp9gOw6KUhME0B+MyqAxIxR7mGvi4JbLPCcSjn7U6rxGkvY9
         gCyJ1sX66BKo0PQpuIm7p7+eoirzdYCmLHTXQyBA+BZXcpu6wn5pf+enKL+pz66vKs
         l7Qi50PwgBBe/ATMJUjgsVRu2KXb2i9QkO4ei9r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 14/71] btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up
Date:   Mon,  9 Nov 2020 13:55:08 +0100
Message-Id: <20201109125020.583747558@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit f4340622e02261fae599e3da936ff4808b418173 upstream.

We have a BUG_ON() in flush_write_bio() to handle the return value of
submit_one_bio().

Move the BUG_ON() one level up to all its callers.

This patch will introduce temporary variable, @flush_ret to keep code
change minimal in this patch. That variable will be cleaned up when
enhancing the error handling later.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Cherry-picked for 4.19 to ease backporting later fixes]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   55 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 14 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -160,15 +160,28 @@ static int __must_check submit_one_bio(s
 	return blk_status_to_errno(ret);
 }
 
-static void flush_write_bio(struct extent_page_data *epd)
+/*
+ * Submit bio from extent page data via submit_one_bio
+ *
+ * Return 0 if everything is OK.
+ * Return <0 for error.
+ */
+static int __must_check flush_write_bio(struct extent_page_data *epd)
 {
-	if (epd->bio) {
-		int ret;
+	int ret = 0;
 
+	if (epd->bio) {
 		ret = submit_one_bio(epd->bio, 0, 0);
-		BUG_ON(ret < 0); /* -ENOMEM */
+		/*
+		 * Clean up of epd->bio is handled by its endio function.
+		 * And endio is either triggered by successful bio execution
+		 * or the error handler of submit bio hook.
+		 * So at this point, no matter what happened, we don't need
+		 * to clean up epd->bio.
+		 */
 		epd->bio = NULL;
 	}
+	return ret;
 }
 
 int __init extent_io_init(void)
@@ -3538,7 +3551,8 @@ lock_extent_buffer_for_io(struct extent_
 
 	if (!btrfs_try_tree_write_lock(eb)) {
 		flush = 1;
-		flush_write_bio(epd);
+		ret = flush_write_bio(epd);
+		BUG_ON(ret < 0);
 		btrfs_tree_lock(eb);
 	}
 
@@ -3547,7 +3561,8 @@ lock_extent_buffer_for_io(struct extent_
 		if (!epd->sync_io)
 			return 0;
 		if (!flush) {
-			flush_write_bio(epd);
+			ret = flush_write_bio(epd);
+			BUG_ON(ret < 0);
 			flush = 1;
 		}
 		while (1) {
@@ -3588,7 +3603,8 @@ lock_extent_buffer_for_io(struct extent_
 
 		if (!trylock_page(p)) {
 			if (!flush) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				BUG_ON(ret < 0);
 				flush = 1;
 			}
 			lock_page(p);
@@ -3779,6 +3795,7 @@ int btree_write_cache_pages(struct addre
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 	int ret = 0;
+	int flush_ret;
 	int done = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
@@ -3878,7 +3895,8 @@ retry:
 		index = 0;
 		goto retry;
 	}
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -3975,7 +3993,8 @@ retry:
 			 * tmpfs file mapping
 			 */
 			if (!trylock_page(page)) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				BUG_ON(ret < 0);
 				lock_page(page);
 			}
 
@@ -3985,8 +4004,10 @@ retry:
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page))
-					flush_write_bio(epd);
+				if (PageWriteback(page)) {
+					ret = flush_write_bio(epd);
+					BUG_ON(ret < 0);
+				}
 				wait_on_page_writeback(page);
 			}
 
@@ -4045,6 +4066,7 @@ retry:
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4054,7 +4076,8 @@ int extent_write_full_page(struct page *
 
 	ret = __extent_writepage(page, wbc, &epd);
 
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -4062,6 +4085,7 @@ int extent_write_locked_range(struct ino
 			      int mode)
 {
 	int ret = 0;
+	int flush_ret;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
@@ -4096,7 +4120,8 @@ int extent_write_locked_range(struct ino
 		start += PAGE_SIZE;
 	}
 
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -4104,6 +4129,7 @@ int extent_writepages(struct address_spa
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(mapping->host)->io_tree,
@@ -4112,7 +4138,8 @@ int extent_writepages(struct address_spa
 	};
 
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 


