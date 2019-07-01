Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874D94FDF5
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfFWUYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:24:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53783 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbfFWUYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:24:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A249221F8A;
        Sun, 23 Jun 2019 16:24:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rmkI3r
        vAR2EyLI6gNRS8+KwVWXjQOap4XRSdHl0m/A8=; b=mAVWlz/GbHOxGLxXy4WXRq
        1nMkGSI7g/SUhRRtt5HPG6q7HwTa2IGciaWdg9R2R5f8szeScXTJ3DdMF2//4eHD
        g54721zEM85n/SZJGu7yPYoDL4rgkgGBiJhFGY4FXURlHVeaULq2AwyoqdG5Vclv
        NqiQYT8UTbqEFTKpOylRpf/sJ9hxecSPbFJh2UUNl2rBfkHb7XUIujzRKJ5q651x
        AoytyZEpmrG5C+LdtDGGJRjpbZ1hXeLnhkw5jxH/j+5qqlelBpGE6dyJRY64k7F2
        N5nPtWBk5CtLBQrz0mrJehquS3DFCB9Jmq/DS+3ktuSWIb4vZMLcLrPygrv8/qNQ
        ==
X-ME-Sender: <xms:AOAPXUflRr5Jk_tNcJpQmu4S_V8-zARXJfupZGU0FHbbIzHL_JHb4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehqvghmuhdqphhrohhjvggtthdrohhrghenucfkphepudejvd
    druddtgedrvdegkedrgeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhr
    ohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:AOAPXYdtb6SoPADnCv7LQ66rqK05aM5XvuP8wj5OzbaOOhoe9i51ow>
    <xmx:AOAPXXzIkBVx5tvFwMdwF3Jysk5W7hNpbKLC-HRS57zDSnjnEPFakg>
    <xmx:AOAPXf8yxCs6lPC5rpQWlBEnG7gUPFbqCQgXd8MLf6uCPidhypcpzQ>
    <xmx:AOAPXS_1_T_I6B9Q3DMVsLnuZ0D4WNcDC3oSU86bg2SnXo8G6Nc7qw>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC0C78005B;
        Sun, 23 Jun 2019 16:24:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix race between block group removal and block group" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:22:00 +0200
Message-ID: <156132132042243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8eaf40c0e24e98899a0f3ac9d25a33aafe13822a Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 12 Jun 2019 11:05:42 +0100
Subject: [PATCH] Btrfs: fix race between block group removal and block group
 allocation

If a task is removing the block group that currently has the highest start
offset amongst all existing block groups, there is a short time window
where it races with a concurrent block group allocation, resulting in a
transaction abort with an error code of EEXIST.

The following diagram explains the race in detail:

      Task A                                                        Task B

 btrfs_remove_block_group(bg offset X)

   remove_extent_mapping(em offset X)
     -> removes extent map X from the
        tree of extent maps
        (fs_info->mapping_tree), so the
        next call to find_next_chunk()
        will return offset X

                                                   btrfs_alloc_chunk()
                                                     find_next_chunk()
                                                       --> returns offset X

                                                     __btrfs_alloc_chunk(offset X)
                                                       btrfs_make_block_group()
                                                         btrfs_create_block_group_cache()
                                                           --> creates btrfs_block_group_cache
                                                               object with a key corresponding
                                                               to the block group item in the
                                                               extent, the key is:
                                                               (offset X, BTRFS_BLOCK_GROUP_ITEM_KEY, 1G)

                                                         --> adds the btrfs_block_group_cache object
                                                             to the list new_bgs of the transaction
                                                             handle

                                                   btrfs_end_transaction(trans handle)
                                                     __btrfs_end_transaction()
                                                       btrfs_create_pending_block_groups()
                                                         --> sees the new btrfs_block_group_cache
                                                             in the new_bgs list of the transaction
                                                             handle
                                                         --> its call to btrfs_insert_item() fails
                                                             with -EEXIST when attempting to insert
                                                             the block group item key
                                                             (offset X, BTRFS_BLOCK_GROUP_ITEM_KEY, 1G)
                                                             because task A has not removed that key yet
                                                         --> aborts the running transaction with
                                                             error -EEXIST

   btrfs_del_item()
     -> removes the block group's key from
        the extent tree, key is
        (offset X, BTRFS_BLOCK_GROUP_ITEM_KEY, 1G)

A sample transaction abort trace:

  [78912.403537] ------------[ cut here ]------------
  [78912.403811] BTRFS: Transaction aborted (error -17)
  [78912.404082] WARNING: CPU: 2 PID: 20465 at fs/btrfs/extent-tree.c:10551 btrfs_create_pending_block_groups+0x196/0x250 [btrfs]
  (...)
  [78912.405642] CPU: 2 PID: 20465 Comm: btrfs Tainted: G        W         5.0.0-btrfs-next-46 #1
  [78912.405941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
  [78912.406586] RIP: 0010:btrfs_create_pending_block_groups+0x196/0x250 [btrfs]
  (...)
  [78912.407636] RSP: 0018:ffff9d3d4b7e3b08 EFLAGS: 00010282
  [78912.407997] RAX: 0000000000000000 RBX: ffff90959a3796f0 RCX: 0000000000000006
  [78912.408369] RDX: 0000000000000007 RSI: 0000000000000001 RDI: ffff909636b16860
  [78912.408746] RBP: ffff909626758a58 R08: 0000000000000000 R09: 0000000000000000
  [78912.409144] R10: ffff9095ff462400 R11: 0000000000000000 R12: ffff90959a379588
  [78912.409521] R13: ffff909626758ab0 R14: ffff9095036c0000 R15: ffff9095299e1158
  [78912.409899] FS:  00007f387f16f700(0000) GS:ffff909636b00000(0000) knlGS:0000000000000000
  [78912.410285] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [78912.410673] CR2: 00007f429fc87cbc CR3: 000000014440a004 CR4: 00000000003606e0
  [78912.411095] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [78912.411496] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [78912.411898] Call Trace:
  [78912.412318]  __btrfs_end_transaction+0x5b/0x1c0 [btrfs]
  [78912.412746]  btrfs_inc_block_group_ro+0xcf/0x160 [btrfs]
  [78912.413179]  scrub_enumerate_chunks+0x188/0x5b0 [btrfs]
  [78912.413622]  ? __mutex_unlock_slowpath+0x100/0x2a0
  [78912.414078]  btrfs_scrub_dev+0x2ef/0x720 [btrfs]
  [78912.414535]  ? __sb_start_write+0xd4/0x1c0
  [78912.414963]  ? mnt_want_write_file+0x24/0x50
  [78912.415403]  btrfs_ioctl+0x17fb/0x3120 [btrfs]
  [78912.415832]  ? lock_acquire+0xa6/0x190
  [78912.416256]  ? do_vfs_ioctl+0xa2/0x6f0
  [78912.416685]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
  [78912.417116]  do_vfs_ioctl+0xa2/0x6f0
  [78912.417534]  ? __fget+0x113/0x200
  [78912.417954]  ksys_ioctl+0x70/0x80
  [78912.418369]  __x64_sys_ioctl+0x16/0x20
  [78912.418812]  do_syscall_64+0x60/0x1b0
  [78912.419231]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [78912.419644] RIP: 0033:0x7f3880252dd7
  (...)
  [78912.420957] RSP: 002b:00007f387f16ed68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  [78912.421426] RAX: ffffffffffffffda RBX: 000055f5becc1df0 RCX: 00007f3880252dd7
  [78912.421889] RDX: 000055f5becc1df0 RSI: 00000000c400941b RDI: 0000000000000003
  [78912.422354] RBP: 0000000000000000 R08: 00007f387f16f700 R09: 0000000000000000
  [78912.422790] R10: 00007f387f16f700 R11: 0000000000000246 R12: 0000000000000000
  [78912.423202] R13: 00007ffda49c266f R14: 0000000000000000 R15: 00007f388145e040
  [78912.425505] ---[ end trace eb9bfe7c426fc4d3 ]---

Fix this by calling remove_extent_mapping(), at btrfs_remove_block_group(),
only at the very end, after removing the block group item key from the
extent tree (and removing the free space tree entry if we are using the
free space tree feature).

Fixes: 04216820fe83d5 ("Btrfs: fix race between fs trimming and block group remove/allocation")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c7adff343ba9..5faf057f6f37 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10831,17 +10831,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	remove_em = (atomic_read(&block_group->trimming) == 0);
 	spin_unlock(&block_group->lock);
 
-	if (remove_em) {
-		struct extent_map_tree *em_tree;
-
-		em_tree = &fs_info->mapping_tree.map_tree;
-		write_lock(&em_tree->lock);
-		remove_extent_mapping(em_tree, em);
-		write_unlock(&em_tree->lock);
-		/* once for the tree */
-		free_extent_map(em);
-	}
-
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	ret = remove_block_group_free_space(trans, block_group);
@@ -10858,6 +10847,19 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		goto out;
 
 	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+
+	if (remove_em) {
+		struct extent_map_tree *em_tree;
+
+		em_tree = &fs_info->mapping_tree.map_tree;
+		write_lock(&em_tree->lock);
+		remove_extent_mapping(em_tree, em);
+		write_unlock(&em_tree->lock);
+		/* once for the tree */
+		free_extent_map(em);
+	}
 out:
 	if (remove_rsv)
 		btrfs_delayed_refs_rsv_release(fs_info, 1);

