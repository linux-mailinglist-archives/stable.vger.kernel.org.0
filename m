Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58974B1F15
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbfIMNPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389717AbfIMNPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:35 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF5F208C2;
        Fri, 13 Sep 2019 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380534;
        bh=ZsgX5z2lSOe2LRzc3NcDZczs7jYpydFb/XsB3NhNePk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS22UJ1NtSv97f8AVseWHZYas9mRLnViHftFlMw1qciEbHHrCBPHhrIuRBiJj/6HK
         bEwa36dAIqxx5QGUJcE4Y453eYbZEAmCDFh1iv03Cre+j8jOiEr2n6nSKymD8w8jcp
         eHv4xWYmEhoSHZUuObIsP9MMmJOAQL7XkMkMyhM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/190] btrfs: Remove extent_io_ops::fill_delalloc
Date:   Fri, 13 Sep 2019 14:05:22 +0100
Message-Id: <20190913130605.056342077@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5eaad97af8aeff38debe7d3c69ec3a0d71f8350f ]

This callback is called only from writepage_delalloc which in turn is
guaranteed to be called from the data page writeout path. In the end
there is no reason to have the call to this function to be indrected via
the extent_io_ops structure. This patch removes the callback definition,
exports the function and calls it directly. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ rename to btrfs_run_delalloc_range ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h     |  3 +++
 fs/btrfs/extent_io.c | 20 +++++++++-----------
 fs/btrfs/extent_io.h |  5 -----
 fs/btrfs/inode.c     | 15 +++++++--------
 4 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 82682da5a40dd..4644f9b629a53 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3200,6 +3200,9 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    struct btrfs_trans_handle *trans, int mode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
+int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+		u64 start, u64 end, int *page_started, unsigned long *nr_written,
+		struct writeback_control *wbc);
 extern const struct dentry_operations btrfs_dentry_operations;
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_inode_set_ops(struct inode *inode);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 90b0a6eff5350..cb598eb4f3bd1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3199,7 +3199,7 @@ static void update_nr_written(struct writeback_control *wbc,
 /*
  * helper for __extent_writepage, doing all of the delayed allocation setup.
  *
- * This returns 1 if our fill_delalloc function did all the work required
+ * This returns 1 if btrfs_run_delalloc_range function did all the work required
  * to write the page (copy into inline extent).  In this case the IO has
  * been started and the page is already unlocked.
  *
@@ -3220,7 +3220,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 	int ret;
 	int page_started = 0;
 
-	if (epd->extent_locked || !tree->ops || !tree->ops->fill_delalloc)
+	if (epd->extent_locked)
 		return 0;
 
 	while (delalloc_end < page_end) {
@@ -3233,18 +3233,16 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 			delalloc_start = delalloc_end + 1;
 			continue;
 		}
-		ret = tree->ops->fill_delalloc(inode, page,
-					       delalloc_start,
-					       delalloc_end,
-					       &page_started,
-					       nr_written, wbc);
+		ret = btrfs_run_delalloc_range(inode, page, delalloc_start,
+				delalloc_end, &page_started, nr_written, wbc);
 		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
-			/* fill_delalloc should be return < 0 for error
-			 * but just in case, we use > 0 here meaning the
-			 * IO is started, so we don't want to return > 0
-			 * unless things are going well.
+			/*
+			 * btrfs_run_delalloc_range should return < 0 for error
+			 * but just in case, we use > 0 here meaning the IO is
+			 * started, so we don't want to return > 0 unless
+			 * things are going well.
 			 */
 			ret = ret < 0 ? ret : -EIO;
 			goto done;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b4d03e677e1d7..ed27becd963c5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,11 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	int (*fill_delalloc)(void *private_data, struct page *locked_page,
-			     u64 start, u64 end, int *page_started,
-			     unsigned long *nr_written,
-			     struct writeback_control *wbc);
-
 	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 355ff08e9d44e..bfacce295ef1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -110,8 +110,8 @@ static void __endio_write_update_ordered(struct inode *inode,
  * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
  * and EXTENT_DELALLOC simultaneously, because that causes the reserved metadata
  * to be released, which we want to happen only when finishing the ordered
- * extent (btrfs_finish_ordered_io()). Also note that the caller of the
- * fill_delalloc() callback already does proper cleanup for the first page of
+ * extent (btrfs_finish_ordered_io()). Also note that the caller of
+ * btrfs_run_delalloc_range already does proper cleanup for the first page of
  * the range, that is, it invokes the callback writepage_end_io_hook() for the
  * range of the first page.
  */
@@ -1599,12 +1599,12 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
 }
 
 /*
- * extent_io.c call back to do delayed allocation processing
+ * Function to process delayed allocation (create CoW) for ranges which are
+ * being touched for the first time.
  */
-static int run_delalloc_range(void *private_data, struct page *locked_page,
-			      u64 start, u64 end, int *page_started,
-			      unsigned long *nr_written,
-			      struct writeback_control *wbc)
+int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
+		u64 start, u64 end, int *page_started, unsigned long *nr_written,
+		struct writeback_control *wbc)
 {
 	struct inode *inode = private_data;
 	int ret;
@@ -10598,7 +10598,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.fill_delalloc = run_delalloc_range,
 	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.writepage_start_hook = btrfs_writepage_start_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
-- 
2.20.1



