Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25F341C37
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCSMTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhCSMTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E672464F6E;
        Fri, 19 Mar 2021 12:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156360;
        bh=p62c9aVLhB/GP6AJPK19TAcdoegO/Zj8rseAjSCIvDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbAGcx1hxN458IFh0rr4/j9XDfjrpNOS1bFrvzRRpSH7lGQV5STILBVQWLYNKucw1
         suUgHNgj59MbmrN0hu2clhi7AdWVDQk064qcN7efR7JgIIvJomIBmwzoYn7Wmq/tqj
         mQmKiiVUAxj+hd3BQqPVuurnDeJS3I7StP4ghDI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 07/18] btrfs: scrub: Dont check free space before marking a block group RO
Date:   Fri, 19 Mar 2021 13:18:45 +0100
Message-Id: <20210319121745.707090901@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit b12de52896c0e8213f70e3a168fde9e6eee95909 upstream.

[BUG]
When running btrfs/072 with only one online CPU, it has a pretty high
chance to fail:

#  btrfs/072 12s ... _check_dmesg: something found in dmesg (see xfstests-dev/results//btrfs/072.dmesg)
#  - output mismatch (see xfstests-dev/results//btrfs/072.out.bad)
#      --- tests/btrfs/072.out     2019-10-22 15:18:14.008965340 +0800
#      +++ /xfstests-dev/results//btrfs/072.out.bad      2019-11-14 15:56:45.877152240 +0800
#      @@ -1,2 +1,3 @@
#       QA output created by 072
#       Silence is golden
#      +Scrub find errors in "-m dup -d single" test
#      ...

And with the following call trace:

  BTRFS info (device dm-5): scrub: started on devid 1
  ------------[ cut here ]------------
  BTRFS: Transaction aborted (error -27)
  WARNING: CPU: 0 PID: 55087 at fs/btrfs/block-group.c:1890 btrfs_create_pending_block_groups+0x3e6/0x470 [btrfs]
  CPU: 0 PID: 55087 Comm: btrfs Tainted: G        W  O      5.4.0-rc1-custom+ #13
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:btrfs_create_pending_block_groups+0x3e6/0x470 [btrfs]
  Call Trace:
   __btrfs_end_transaction+0xdb/0x310 [btrfs]
   btrfs_end_transaction+0x10/0x20 [btrfs]
   btrfs_inc_block_group_ro+0x1c9/0x210 [btrfs]
   scrub_enumerate_chunks+0x264/0x940 [btrfs]
   btrfs_scrub_dev+0x45c/0x8f0 [btrfs]
   btrfs_ioctl+0x31a1/0x3fb0 [btrfs]
   do_vfs_ioctl+0x636/0xaa0
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x43/0x50
   do_syscall_64+0x79/0xe0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  ---[ end trace 166c865cec7688e7 ]---

[CAUSE]
The error number -27 is -EFBIG, returned from the following call chain:
btrfs_end_transaction()
|- __btrfs_end_transaction()
   |- btrfs_create_pending_block_groups()
      |- btrfs_finish_chunk_alloc()
         |- btrfs_add_system_chunk()

This happens because we have used up all space of
btrfs_super_block::sys_chunk_array.

The root cause is, we have the following bad loop of creating tons of
system chunks:

1. The only SYSTEM chunk is being scrubbed
   It's very common to have only one SYSTEM chunk.
2. New SYSTEM bg will be allocated
   As btrfs_inc_block_group_ro() will check if we have enough space
   after marking current bg RO. If not, then allocate a new chunk.
3. New SYSTEM bg is still empty, will be reclaimed
   During the reclaim, we will mark it RO again.
4. That newly allocated empty SYSTEM bg get scrubbed
   We go back to step 2, as the bg is already mark RO but still not
   cleaned up yet.

If the cleaner kthread doesn't get executed fast enough (e.g. only one
CPU), then we will get more and more empty SYSTEM chunks, using up all
the space of btrfs_super_block::sys_chunk_array.

[FIX]
Since scrub/dev-replace doesn't always need to allocate new extent,
especially chunk tree extent, so we don't really need to do chunk
pre-allocation.

To break above spiral, here we introduce a new parameter to
btrfs_inc_block_group(), @do_chunk_alloc, which indicates whether we
need extra chunk pre-allocation.

For relocation, we pass @do_chunk_alloc=true, while for scrub, we pass
@do_chunk_alloc=false.
This should keep unnecessary empty chunks from popping up for scrub.

Also, since there are two parameters for btrfs_inc_block_group_ro(),
add more comment for it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/block-group.c |   48 +++++++++++++++++++++++++++++++-----------------
 fs/btrfs/block-group.h |    3 ++-
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/scrub.c       |   21 ++++++++++++++++++++-
 4 files changed, 54 insertions(+), 20 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2048,8 +2048,17 @@ static u64 update_block_group_flags(stru
 	return flags;
 }
 
-int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache)
-
+/*
+ * Mark one block group RO, can be called several times for the same block
+ * group.
+ *
+ * @cache:		the destination block group
+ * @do_chunk_alloc:	whether need to do chunk pre-allocation, this is to
+ * 			ensure we still have some free space after marking this
+ * 			block group RO.
+ */
+int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache,
+			     bool do_chunk_alloc)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_trans_handle *trans;
@@ -2079,25 +2088,29 @@ again:
 		goto again;
 	}
 
-	/*
-	 * if we are changing raid levels, try to allocate a corresponding
-	 * block group with the new raid level.
-	 */
-	alloc_flags = update_block_group_flags(fs_info, cache->flags);
-	if (alloc_flags != cache->flags) {
-		ret = btrfs_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
+	if (do_chunk_alloc) {
 		/*
-		 * ENOSPC is allowed here, we may have enough space
-		 * already allocated at the new raid level to
-		 * carry on
+		 * If we are changing raid levels, try to allocate a
+		 * corresponding block group with the new raid level.
 		 */
-		if (ret == -ENOSPC)
-			ret = 0;
-		if (ret < 0)
-			goto out;
+		alloc_flags = update_block_group_flags(fs_info, cache->flags);
+		if (alloc_flags != cache->flags) {
+			ret = btrfs_chunk_alloc(trans, alloc_flags,
+						CHUNK_ALLOC_FORCE);
+			/*
+			 * ENOSPC is allowed here, we may have enough space
+			 * already allocated at the new raid level to carry on
+			 */
+			if (ret == -ENOSPC)
+				ret = 0;
+			if (ret < 0)
+				goto out;
+		}
 	}
 
-	ret = inc_block_group_ro(cache, 0);
+	ret = inc_block_group_ro(cache, !do_chunk_alloc);
+	if (!do_chunk_alloc)
+		goto unlock_out;
 	if (!ret)
 		goto out;
 	alloc_flags = btrfs_get_alloc_profile(fs_info, cache->space_info->flags);
@@ -2112,6 +2125,7 @@ out:
 		check_system_chunk(trans, alloc_flags);
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
+unlock_out:
 	mutex_unlock(&fs_info->ro_block_group_mutex);
 
 	btrfs_end_transaction(trans);
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -205,7 +205,8 @@ int btrfs_read_block_groups(struct btrfs
 int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 			   u64 type, u64 chunk_offset, u64 size);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans);
-int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache);
+int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache,
+			     bool do_chunk_alloc);
 void btrfs_dec_block_group_ro(struct btrfs_block_group_cache *cache);
 int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4428,7 +4428,7 @@ int btrfs_relocate_block_group(struct bt
 	rc->extent_root = extent_root;
 	rc->block_group = bg;
 
-	ret = btrfs_inc_block_group_ro(rc->block_group);
+	ret = btrfs_inc_block_group_ro(rc->block_group, true);
 	if (ret) {
 		err = ret;
 		goto out;
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3560,7 +3560,26 @@ int scrub_enumerate_chunks(struct scrub_
 		 * -> btrfs_scrub_pause()
 		 */
 		scrub_pause_on(fs_info);
-		ret = btrfs_inc_block_group_ro(cache);
+
+		/*
+		 * Don't do chunk preallocation for scrub.
+		 *
+		 * This is especially important for SYSTEM bgs, or we can hit
+		 * -EFBIG from btrfs_finish_chunk_alloc() like:
+		 * 1. The only SYSTEM bg is marked RO.
+		 *    Since SYSTEM bg is small, that's pretty common.
+		 * 2. New SYSTEM bg will be allocated
+		 *    Due to regular version will allocate new chunk.
+		 * 3. New SYSTEM bg is empty and will get cleaned up
+		 *    Before cleanup really happens, it's marked RO again.
+		 * 4. Empty SYSTEM bg get scrubbed
+		 *    We go back to 2.
+		 *
+		 * This can easily boost the amount of SYSTEM chunks if cleaner
+		 * thread can't be triggered fast enough, and use up all space
+		 * of btrfs_super_block::sys_chunk_array
+		 */
+		ret = btrfs_inc_block_group_ro(cache, false);
 		if (!ret && sctx->is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks


