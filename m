Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659DC2A57D0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbgKCUv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgKCUv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC0F2071E;
        Tue,  3 Nov 2020 20:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436717;
        bh=mBXyxO7ug7xUgmt42FXa3IFZYYfuyjhlhInNpetqWAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhj6RRoxzUGSAaHPvpfYssc5aRWxwuFKU8W9sdaTcN19T7cjJ4XbkCZBC+wdF4exH
         S7aa0M2PE1meFFniNBYvKQCZLe4iePhisQILmO9Js8bzdERIfGrz1gUh7WI2k2pjas
         zf2ttHmOhYK1DDDdl5MuG5Y97d+sE6ho9fwovQHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.9 345/391] ext4: clear buffer verified flag if read meta block from disk
Date:   Tue,  3 Nov 2020 21:36:36 +0100
Message-Id: <20201103203410.416848527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit d9befedaafcf3a111428baa7c45b02923eab2d87 upstream.

The metadata buffer is no longer trusted after we read it from disk
again because it is not uptodate for some reasons (e.g. failed to write
back). Otherwise we may get below memory corruption problem in
ext4_ext_split()->memset() if we read stale data from the newly
allocated extent block on disk which has been failed to async write
out but miss verify again since the verified bit has already been set
on the buffer.

[   29.774674] BUG: unable to handle kernel paging request at ffff88841949d000
...
[   29.783317] Oops: 0002 [#2] SMP
[   29.784219] R10: 00000000000f4240 R11: 0000000000002e28 R12: ffff88842fa1c800
[   29.784627] CPU: 1 PID: 126 Comm: kworker/u4:3 Tainted: G      D W
[   29.785546] R13: ffffffff9cddcc20 R14: ffffffff9cddd420 R15: ffff88842fa1c2f8
[   29.786679] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),BIOS ?-20190727_0738364
[   29.787588] FS:  0000000000000000(0000) GS:ffff88842fa00000(0000) knlGS:0000000000000000
[   29.789288] Workqueue: writeback wb_workfn
[   29.790319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.790321]  (flush-8:0)
[   29.790844] CR2: 0000000000000008 CR3: 00000004234f2000 CR4: 00000000000006f0
[   29.791924] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.792839] RIP: 0010:__memset+0x24/0x30
[   29.793739] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   29.794256] Code: 90 90 90 90 90 90 0f 1f 44 00 00 49 89 f9 48 89 d1 83 e2 07 48 c1 e9 033
[   29.795161] Kernel panic - not syncing: Fatal exception in interrupt
...
[   29.808149] Call Trace:
[   29.808475]  ext4_ext_insert_extent+0x102e/0x1be0
[   29.809085]  ext4_ext_map_blocks+0xa89/0x1bb0
[   29.809652]  ext4_map_blocks+0x290/0x8a0
[   29.809085]  ext4_ext_map_blocks+0xa89/0x1bb0
[   29.809652]  ext4_map_blocks+0x290/0x8a0
[   29.810161]  ext4_writepages+0xc85/0x17c0
...

Fix this by clearing buffer's verified bit if we read meta block from
disk again.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200924073337.861472-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/balloc.c  |    1 +
 fs/ext4/extents.c |    1 +
 fs/ext4/ialloc.c  |    1 +
 fs/ext4/inode.c   |    5 ++++-
 fs/ext4/super.c   |    1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -494,6 +494,7 @@ ext4_read_block_bitmap_nowait(struct sup
 	 * submit the buffer_head for reading
 	 */
 	set_buffer_new(bh);
+	clear_buffer_verified(bh);
 	trace_ext4_read_block_bitmap_load(sb, block_group, ignore_locked);
 	bh->b_end_io = ext4_end_bitmap_read;
 	get_bh(bh);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -501,6 +501,7 @@ __read_extent_tree_block(const char *fun
 
 	if (!bh_uptodate_or_lock(bh)) {
 		trace_ext4_ext_load_extent(inode, pblk, _RET_IP_);
+		clear_buffer_verified(bh);
 		err = bh_submit_read(bh);
 		if (err < 0)
 			goto errout;
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -188,6 +188,7 @@ ext4_read_inode_bitmap(struct super_bloc
 	/*
 	 * submit the buffer_head for reading
 	 */
+	clear_buffer_verified(bh);
 	trace_ext4_load_inode_bitmap(sb, block_group);
 	bh->b_end_io = ext4_end_bitmap_read;
 	get_bh(bh);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -884,6 +884,7 @@ struct buffer_head *ext4_bread(handle_t
 		return bh;
 	if (!bh || ext4_buffer_uptodate(bh))
 		return bh;
+	clear_buffer_verified(bh);
 	ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
@@ -909,9 +910,11 @@ int ext4_bread_batch(struct inode *inode
 
 	for (i = 0; i < bh_count; i++)
 		/* Note that NULL bhs[i] is valid because of holes. */
-		if (bhs[i] && !ext4_buffer_uptodate(bhs[i]))
+		if (bhs[i] && !ext4_buffer_uptodate(bhs[i])) {
+			clear_buffer_verified(bhs[i]);
 			ll_rw_block(REQ_OP_READ, REQ_META | REQ_PRIO, 1,
 				    &bhs[i]);
+		}
 
 	if (!wait)
 		return 0;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -156,6 +156,7 @@ ext4_sb_bread(struct super_block *sb, se
 		return ERR_PTR(-ENOMEM);
 	if (ext4_buffer_uptodate(bh))
 		return bh;
+	clear_buffer_verified(bh);
 	ll_rw_block(REQ_OP_READ, REQ_META | op_flags, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))


