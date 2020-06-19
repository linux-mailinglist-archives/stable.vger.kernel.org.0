Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6F8201043
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404515AbgFSP2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391095AbgFSP2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B89920734;
        Fri, 19 Jun 2020 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580481;
        bh=cV0X/MeoY3Sv3TVXNWOniAHxN+5Eu1HWefRaFgTTk24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ugjn541DzIZNQA+2rKd1jKmADYs0pdIR6y6rwfnZJf5sLP4SKbqemJlTGZBO6vw+7
         LLTqYkAeMGf17BoUlcGBJOT1ptwyazp6H4PN8ezZrO26CLR44STfVvebLlvswP1Fdx
         ncRSsDpcoQzFKhYMnbCpdEQzRbmvZwqt8Ia/pzrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 265/376] btrfs: fix space_info bytes_may_use underflow after nocow buffered write
Date:   Fri, 19 Jun 2020 16:33:03 +0200
Message-Id: <20200619141722.875180723@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 467dc47ea99c56e966e99d09dae54869850abeeb upstream.

When doing a buffered write we always try to reserve data space for it,
even when the file has the NOCOW bit set or the write falls into a file
range covered by a prealloc extent. This is done both because it is
expensive to check if we can do a nocow write (checking if an extent is
shared through reflinks or if there's a hole in the range for example),
and because when writeback starts we might actually need to fallback to
COW mode (for example the block group containing the target extents was
turned into RO mode due to a scrub or balance).

When we are unable to reserve data space we check if we can do a nocow
write, and if we can, we proceed with dirtying the pages and setting up
the range for delalloc. In this case the bytes_may_use counter of the
data space_info object is not incremented, unlike in the case where we
are able to reserve data space (done through btrfs_check_data_free_space()
which calls btrfs_alloc_data_chunk_ondemand()).

Later when running delalloc we attempt to start writeback in nocow mode
but we might revert back to cow mode, for example because in the meanwhile
a block group was turned into RO mode by a scrub or relocation. The cow
path after successfully allocating an extent ends up calling
btrfs_add_reserved_bytes(), which expects the bytes_may_use counter of
the data space_info object to have been incremented before - but we did
not do it when the buffered write started, since there was not enough
available data space. So btrfs_add_reserved_bytes() ends up decrementing
the bytes_may_use counter anyway, and when the counter's current value
is smaller then the size of the allocated extent we get a stack trace
like the following:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 20138 at fs/btrfs/space-info.h:115 btrfs_add_reserved_bytes+0x3d6/0x4e0 [btrfs]
 Modules linked in: btrfs blake2b_generic xor raid6_pq libcrc32c (...)
 CPU: 0 PID: 20138 Comm: kworker/u8:15 Not tainted 5.6.0-rc7-btrfs-next-58 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
 Workqueue: writeback wb_workfn (flush-btrfs-1754)
 RIP: 0010:btrfs_add_reserved_bytes+0x3d6/0x4e0 [btrfs]
 Code: ff ff 48 (...)
 RSP: 0018:ffffbda18a4b3568 EFLAGS: 00010287
 RAX: 0000000000000000 RBX: ffff9ca076f5d800 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff9ca068470410
 RBP: fffffffffffff000 R08: 0000000000000001 R09: 0000000000000000
 R10: ffff9ca079d58040 R11: 0000000000000000 R12: ffff9ca068470400
 R13: ffff9ca0408b2000 R14: 0000000000001000 R15: ffff9ca076f5d800
 FS:  0000000000000000(0000) GS:ffff9ca07a600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005605dbfe7048 CR3: 0000000138570006 CR4: 00000000003606f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  find_free_extent+0x4a0/0x16c0 [btrfs]
  btrfs_reserve_extent+0x91/0x180 [btrfs]
  cow_file_range+0x12d/0x490 [btrfs]
  run_delalloc_nocow+0x341/0xa40 [btrfs]
  btrfs_run_delalloc_range+0x1ea/0x6d0 [btrfs]
  ? find_lock_delalloc_range+0x221/0x250 [btrfs]
  writepage_delalloc+0xe8/0x150 [btrfs]
  __extent_writepage+0xe8/0x4c0 [btrfs]
  extent_write_cache_pages+0x237/0x530 [btrfs]
  ? btrfs_wq_submit_bio+0x9f/0xc0 [btrfs]
  extent_writepages+0x44/0xa0 [btrfs]
  do_writepages+0x23/0x80
  __writeback_single_inode+0x59/0x700
  writeback_sb_inodes+0x267/0x5f0
  __writeback_inodes_wb+0x87/0xe0
  wb_writeback+0x382/0x590
  ? wb_workfn+0x4a2/0x6c0
  wb_workfn+0x4a2/0x6c0
  process_one_work+0x26d/0x6a0
  worker_thread+0x4f/0x3e0
  ? process_one_work+0x6a0/0x6a0
  kthread+0x103/0x140
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x3a/0x50
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffff94ebdedf>] copy_process+0x74f/0x2020
 softirqs last  enabled at (0): [<ffffffff94ebdedf>] copy_process+0x74f/0x2020
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace f9f6ef8ec4cd8ec9 ]---

So to fix this, when falling back into cow mode check if space was not
reserved, by testing for the bit EXTENT_NORESERVE in the respective file
range, and if not, increment the bytes_may_use counter for the data
space_info object. Also clear the EXTENT_NORESERVE bit from the range, so
that if the cow path fails it decrements the bytes_may_use counter when
clearing the delalloc range (through the btrfs_clear_delalloc_extent()
callback).

Fixes: 7ee9e4405f264e ("Btrfs: check if we can nocow if we don't have data space")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -49,6 +49,7 @@
 #include "qgroup.h"
 #include "delalloc-space.h"
 #include "block-group.h"
+#include "space-info.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -1355,6 +1356,56 @@ static noinline int csum_exist_in_range(
 	return 1;
 }
 
+static int fallback_to_cow(struct inode *inode, struct page *locked_page,
+			   const u64 start, const u64 end,
+			   int *page_started, unsigned long *nr_written)
+{
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	u64 range_start = start;
+	u64 count;
+
+	/*
+	 * If EXTENT_NORESERVE is set it means that when the buffered write was
+	 * made we had not enough available data space and therefore we did not
+	 * reserve data space for it, since we though we could do NOCOW for the
+	 * respective file range (either there is prealloc extent or the inode
+	 * has the NOCOW bit set).
+	 *
+	 * However when we need to fallback to COW mode (because for example the
+	 * block group for the corresponding extent was turned to RO mode by a
+	 * scrub or relocation) we need to do the following:
+	 *
+	 * 1) We increment the bytes_may_use counter of the data space info.
+	 *    If COW succeeds, it allocates a new data extent and after doing
+	 *    that it decrements the space info's bytes_may_use counter and
+	 *    increments its bytes_reserved counter by the same amount (we do
+	 *    this at btrfs_add_reserved_bytes()). So we need to increment the
+	 *    bytes_may_use counter to compensate (when space is reserved at
+	 *    buffered write time, the bytes_may_use counter is incremented);
+	 *
+	 * 2) We clear the EXTENT_NORESERVE bit from the range. We do this so
+	 *    that if the COW path fails for any reason, it decrements (through
+	 *    extent_clear_unlock_delalloc()) the bytes_may_use counter of the
+	 *    data space info, which we incremented in the step above.
+	 */
+	count = count_range_bits(io_tree, &range_start, end, end + 1 - start,
+				 EXTENT_NORESERVE, 0);
+	if (count > 0) {
+		struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+		struct btrfs_space_info *sinfo = fs_info->data_sinfo;
+
+		spin_lock(&sinfo->lock);
+		btrfs_space_info_update_bytes_may_use(fs_info, sinfo, count);
+		spin_unlock(&sinfo->lock);
+
+		clear_extent_bit(io_tree, start, end, EXTENT_NORESERVE, 0, 0,
+				 NULL);
+	}
+
+	return cow_file_range(inode, locked_page, start, end, page_started,
+			      nr_written, 1);
+}
+
 /*
  * when nowcow writeback call back.  This checks for snapshots or COW copies
  * of the extents that exist in the file, and COWs the file as required.
@@ -1602,9 +1653,9 @@ out_check:
 		 * NOCOW, following one which needs to be COW'ed
 		 */
 		if (cow_start != (u64)-1) {
-			ret = cow_file_range(inode, locked_page,
-					     cow_start, found_key.offset - 1,
-					     page_started, nr_written, 1);
+			ret = fallback_to_cow(inode, locked_page, cow_start,
+					      found_key.offset - 1,
+					      page_started, nr_written);
 			if (ret) {
 				if (nocow)
 					btrfs_dec_nocow_writers(fs_info,
@@ -1693,8 +1744,8 @@ out_check:
 
 	if (cow_start != (u64)-1) {
 		cur_offset = end;
-		ret = cow_file_range(inode, locked_page, cow_start, end,
-				     page_started, nr_written, 1);
+		ret = fallback_to_cow(inode, locked_page, cow_start, end,
+				      page_started, nr_written);
 		if (ret)
 			goto error;
 	}


