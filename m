Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9610F40C458
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhIOLX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhIOLX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8D760E94;
        Wed, 15 Sep 2021 11:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631704959;
        bh=92cTCowUerQSc0LOdCSG2faSN9MglZCTN6NdUJh0bZA=;
        h=Subject:To:Cc:From:Date:From;
        b=zxxKEEMSFxKSTVH8Bjv2LuujKsIwWFkvQX3Ao4kiWPGMlGTYW9AVjipf/a35JlXeM
         EUE8zITZQA2g8E/OjH5Qk0jP5UwqSo/1Acm23QcuCRNfM9kqiA3iU80360mlibX44J
         FMtkQVydmFIzH90bM2d5V/KmhHFVNbLweNQrOKR8=
Subject: FAILED: patch "[PATCH] btrfs: wait on async extents when flushing delalloc" failed to apply to 5.10-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 13:22:36 +0200
Message-ID: <1631704956152117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e16460707e94c3d4c1b5418cb68b28b8efa903b2 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 14 Jul 2021 14:47:21 -0400
Subject: [PATCH] btrfs: wait on async extents when flushing delalloc

I've been debugging an early ENOSPC problem in production and finally
root caused it to this problem.  When we switched to the per-inode in
38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
shrink_delalloc") I pulled out the async extent handling, because we
were doing the correct thing by calling filemap_flush() if we had async
extents set.  This would properly wait on any async extents by locking
the page in the second flush, thus making sure our ordered extents were
properly set up.

However when I switched us back to page based flushing, I used
sync_inode(), which allows us to pass in our own wbc.  The problem here
is that sync_inode() is smarter than the filemap_* helpers, it tries to
avoid calling writepages at all.  This means that our second call could
skip calling do_writepages altogether, and thus not wait on the pagelock
for the async helpers.  This means we could come back before any ordered
extents were created and then simply continue on in our flushing
mechanisms and ENOSPC out when we have plenty of space to use.

Fix this by putting back the async pages logic in shrink_delalloc.  This
allows us to bulk write out everything that we need to, and then we can
wait in one place for the async helpers to catch up, and then wait on
any ordered extents that are created.

Fixes: e076ab2a2ca7 ("btrfs: shrink delalloc pages instead of full inodes")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 73b6413cc9af..25eb214f56ac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9879,10 +9879,6 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 					 &work->work);
 		} else {
 			ret = sync_inode(inode, wbc);
-			if (!ret &&
-			    test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-				     &BTRFS_I(inode)->runtime_flags))
-				ret = sync_inode(inode, wbc);
 			btrfs_add_delayed_iput(inode);
 			if (ret || wbc->nr_to_write <= 0)
 				goto out;
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index eb90a262563f..d9c8d738678f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -532,9 +532,49 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 	while ((delalloc_bytes || ordered_bytes) && loops < 3) {
 		u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
 		long nr_pages = min_t(u64, temp, LONG_MAX);
+		int async_pages;
 
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
 
+		/*
+		 * We need to make sure any outstanding async pages are now
+		 * processed before we continue.  This is because things like
+		 * sync_inode() try to be smart and skip writing if the inode is
+		 * marked clean.  We don't use filemap_fwrite for flushing
+		 * because we want to control how many pages we write out at a
+		 * time, thus this is the only safe way to make sure we've
+		 * waited for outstanding compressed workers to have started
+		 * their jobs and thus have ordered extents set up properly.
+		 *
+		 * This exists because we do not want to wait for each
+		 * individual inode to finish its async work, we simply want to
+		 * start the IO on everybody, and then come back here and wait
+		 * for all of the async work to catch up.  Once we're done with
+		 * that we know we'll have ordered extents for everything and we
+		 * can decide if we wait for that or not.
+		 *
+		 * If we choose to replace this in the future, make absolutely
+		 * sure that the proper waiting is being done in the async case,
+		 * as there have been bugs in that area before.
+		 */
+		async_pages = atomic_read(&fs_info->async_delalloc_pages);
+		if (!async_pages)
+			goto skip_async;
+
+		/*
+		 * We don't want to wait forever, if we wrote less pages in this
+		 * loop than we have outstanding, only wait for that number of
+		 * pages, otherwise we can wait for all async pages to finish
+		 * before continuing.
+		 */
+		if (async_pages > nr_pages)
+			async_pages -= nr_pages;
+		else
+			async_pages = 0;
+		wait_event(fs_info->async_submit_wait,
+			   atomic_read(&fs_info->async_delalloc_pages) <=
+			   async_pages);
+skip_async:
 		loops++;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, 0, (u64)-1);

