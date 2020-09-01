Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C4259C2C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgIARMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729270AbgIAPQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:16:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AC0206EB;
        Tue,  1 Sep 2020 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973368;
        bh=NsIU05G0M60r+FNeX0Pk9wWb5akfubEq5ldKWmzuOFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvifdY+fpsFFIPT0WbYbbX1y6pEYDspjDbR4aeu6o5wgdSMK5mNlFMS8R1xhCslPQ
         DtUonEgmAxnZaUChf2khhNyNpoaks/GKwAwfMd9TgQZNuCssaQWHUvpAe4Na8pJ1Xm
         rlYVr29U7nLgA3++rRpUnJR0ZCJMZiDQC880mIIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 50/78] btrfs: fix space cache memory leak after transaction abort
Date:   Tue,  1 Sep 2020 17:10:26 +0200
Message-Id: <20200901150927.246944093@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit bbc37d6e475eee8ffa2156ec813efc6bbb43c06d upstream.

If a transaction aborts it can cause a memory leak of the pages array of
a block group's io_ctl structure. The following steps explain how that can
happen:

1) Transaction N is committing, currently in state TRANS_STATE_UNBLOCKED
   and it's about to start writing out dirty extent buffers;

2) Transaction N + 1 already started and another task, task A, just called
   btrfs_commit_transaction() on it;

3) Block group B was dirtied (extents allocated from it) by transaction
   N + 1, so when task A calls btrfs_start_dirty_block_groups(), at the
   very beginning of the transaction commit, it starts writeback for the
   block group's space cache by calling btrfs_write_out_cache(), which
   allocates the pages array for the block group's io_ctl with a call to
   io_ctl_init(). Block group A is added to the io_list of transaction
   N + 1 by btrfs_start_dirty_block_groups();

4) While transaction N's commit is writing out the extent buffers, it gets
   an IO error and aborts transaction N, also setting the file system to
   RO mode;

5) Task A has already returned from btrfs_start_dirty_block_groups(), is at
   btrfs_commit_transaction() and has set transaction N + 1 state to
   TRANS_STATE_COMMIT_START. Immediately after that it checks that the
   filesystem was turned to RO mode, due to transaction N's abort, and
   jumps to the "cleanup_transaction" label. After that we end up at
   btrfs_cleanup_one_transaction() which calls btrfs_cleanup_dirty_bgs().
   That helper finds block group B in the transaction's io_list but it
   never releases the pages array of the block group's io_ctl, resulting in
   a memory leak.

In fact at the point when we are at btrfs_cleanup_dirty_bgs(), the pages
array points to pages that were already released by us at
__btrfs_write_out_cache() through the call to io_ctl_drop_pages(). We end
up freeing the pages array only after waiting for the ordered extent to
complete through btrfs_wait_cache_io(), which calls io_ctl_free() to do
that. But in the transaction abort case we don't wait for the space cache's
ordered extent to complete through a call to btrfs_wait_cache_io(), so
that's why we end up with a memory leak - we wait for the ordered extent
to complete indirectly by shutting down the work queues and waiting for
any jobs in them to complete before returning from close_ctree().

We can solve the leak simply by freeing the pages array right after
releasing the pages (with the call to io_ctl_drop_pages()) at
__btrfs_write_out_cache(), since we will never use it anymore after that
and the pages array points to already released pages at that point, which
is currently not a problem since no one will use it after that, but not a
good practice anyway since it can easily lead to use-after-free issues.

So fix this by freeing the pages array right after releasing the pages at
__btrfs_write_out_cache().

This issue can often be reproduced with test case generic/475 from fstests
and kmemleak can detect it and reports it with the following trace:

unreferenced object 0xffff9bbf009fa600 (size 512):
  comm "fsstress", pid 38807, jiffies 4298504428 (age 22.028s)
  hex dump (first 32 bytes):
    00 a0 7c 4d 3d ed ff ff 40 a0 7c 4d 3d ed ff ff  ..|M=...@.|M=...
    80 a0 7c 4d 3d ed ff ff c0 a0 7c 4d 3d ed ff ff  ..|M=.....|M=...
  backtrace:
    [<00000000f4b5cfe2>] __kmalloc+0x1a8/0x3e0
    [<0000000028665e7f>] io_ctl_init+0xa7/0x120 [btrfs]
    [<00000000a1f95b2d>] __btrfs_write_out_cache+0x86/0x4a0 [btrfs]
    [<00000000207ea1b0>] btrfs_write_out_cache+0x7f/0xf0 [btrfs]
    [<00000000af21f534>] btrfs_start_dirty_block_groups+0x27b/0x580 [btrfs]
    [<00000000c3c23d44>] btrfs_commit_transaction+0xa6f/0xe70 [btrfs]
    [<000000009588930c>] create_subvol+0x581/0x9a0 [btrfs]
    [<000000009ef2fd7f>] btrfs_mksubvol+0x3fb/0x4a0 [btrfs]
    [<00000000474e5187>] __btrfs_ioctl_snap_create+0x119/0x1a0 [btrfs]
    [<00000000708ee349>] btrfs_ioctl_snap_create_v2+0xb0/0xf0 [btrfs]
    [<00000000ea60106f>] btrfs_ioctl+0x12c/0x3130 [btrfs]
    [<000000005c923d6d>] __x64_sys_ioctl+0x83/0xb0
    [<0000000043ace2c9>] do_syscall_64+0x33/0x80
    [<00000000904efbce>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c          |    1 +
 fs/btrfs/free-space-cache.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4432,6 +4432,7 @@ static void btrfs_cleanup_bg_io(struct b
 		cache->io_ctl.inode = NULL;
 		iput(inode);
 	}
+	ASSERT(cache->io_ctl.pages == NULL);
 	btrfs_put_block_group(cache);
 }
 
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1165,7 +1165,6 @@ int btrfs_wait_cache_io(struct btrfs_roo
 	ret = update_cache_item(trans, root, inode, path, offset,
 				io_ctl->entries, io_ctl->bitmaps);
 out:
-	io_ctl_free(io_ctl);
 	if (ret) {
 		invalidate_inode_pages2(inode->i_mapping);
 		BTRFS_I(inode)->generation = 0;
@@ -1314,6 +1313,7 @@ static int __btrfs_write_out_cache(struc
 	 * them out later
 	 */
 	io_ctl_drop_pages(io_ctl);
+	io_ctl_free(io_ctl);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
 			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);


