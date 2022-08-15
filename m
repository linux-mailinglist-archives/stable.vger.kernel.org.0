Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43801592DF3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiHOLOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiHOLOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481C91928D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF01461113
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB460C433C1;
        Mon, 15 Aug 2022 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562039;
        bh=yimJXsHI+EKHIfkNLTnCpt3m3cQypL0trntz3oWQVjE=;
        h=Subject:To:Cc:From:Date:From;
        b=Lvb69BFMT2EtJY4i1HowcmDB/GW1VdjA/s8Pho2Mqe+tR3C+aTaSBxrfrSiXXnHPu
         8VmEiSBgAuefB8FkzQHEo07XHK3lq3JncSyyxi7qOcMuTW044lWnaEWvfhhwpQk3Xz
         yndcIf52w2d3DQfxlZ8y9T43vJ7t38Re8pwfAIhk=
Subject: FAILED: patch "[PATCH] btrfs: replace BTRFS_MAX_EXTENT_SIZE with" failed to apply to 5.15-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:13:56 +0200
Message-ID: <1660562036202214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7b12a62f008a3041f42f2426983e59a6a0a3c59 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Sat, 9 Jul 2022 08:18:40 +0900
Subject: [PATCH] btrfs: replace BTRFS_MAX_EXTENT_SIZE with
 fs_info->max_extent_size

On zoned filesystem, data write out is limited by max_zone_append_size,
and a large ordered extent is split according the size of a bio. OTOH,
the number of extents to be written is calculated using
BTRFS_MAX_EXTENT_SIZE, and that estimated number is used to reserve the
metadata bytes to update and/or create the metadata items.

The metadata reservation is done at e.g, btrfs_buffered_write() and then
released according to the estimation changes. Thus, if the number of extent
increases massively, the reserved metadata can run out.

The increase of the number of extents easily occurs on zoned filesystem
if BTRFS_MAX_EXTENT_SIZE > max_zone_append_size. And, it causes the
following warning on a small RAM environment with disabling metadata
over-commit (in the following patch).

[75721.498492] ------------[ cut here ]------------
[75721.505624] BTRFS: block rsv 1 returned -28
[75721.512230] WARNING: CPU: 24 PID: 2327559 at fs/btrfs/block-rsv.c:537 btrfs_use_block_rsv+0x560/0x760 [btrfs]
[75721.581854] CPU: 24 PID: 2327559 Comm: kworker/u64:10 Kdump: loaded Tainted: G        W         5.18.0-rc2-BTRFS-ZNS+ #109
[75721.597200] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.0 02/22/2021
[75721.607310] Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
[75721.616209] RIP: 0010:btrfs_use_block_rsv+0x560/0x760 [btrfs]
[75721.646649] RSP: 0018:ffffc9000fbdf3e0 EFLAGS: 00010286
[75721.654126] RAX: 0000000000000000 RBX: 0000000000004000 RCX: 0000000000000000
[75721.663524] RDX: 0000000000000004 RSI: 0000000000000008 RDI: fffff52001f7be6e
[75721.672921] RBP: ffffc9000fbdf420 R08: 0000000000000001 R09: ffff889f8d1fc6c7
[75721.682493] R10: ffffed13f1a3f8d8 R11: 0000000000000001 R12: ffff88980a3c0e28
[75721.692284] R13: ffff889b66590000 R14: ffff88980a3c0e40 R15: ffff88980a3c0e8a
[75721.701878] FS:  0000000000000000(0000) GS:ffff889f8d000000(0000) knlGS:0000000000000000
[75721.712601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[75721.720726] CR2: 000055d12e05c018 CR3: 0000800193594000 CR4: 0000000000350ee0
[75721.730499] Call Trace:
[75721.735166]  <TASK>
[75721.739886]  btrfs_alloc_tree_block+0x1e1/0x1100 [btrfs]
[75721.747545]  ? btrfs_alloc_logged_file_extent+0x550/0x550 [btrfs]
[75721.756145]  ? btrfs_get_32+0xea/0x2d0 [btrfs]
[75721.762852]  ? btrfs_get_32+0xea/0x2d0 [btrfs]
[75721.769520]  ? push_leaf_left+0x420/0x620 [btrfs]
[75721.776431]  ? memcpy+0x4e/0x60
[75721.781931]  split_leaf+0x433/0x12d0 [btrfs]
[75721.788392]  ? btrfs_get_token_32+0x580/0x580 [btrfs]
[75721.795636]  ? push_for_double_split.isra.0+0x420/0x420 [btrfs]
[75721.803759]  ? leaf_space_used+0x15d/0x1a0 [btrfs]
[75721.811156]  btrfs_search_slot+0x1bc3/0x2790 [btrfs]
[75721.818300]  ? lock_downgrade+0x7c0/0x7c0
[75721.824411]  ? free_extent_buffer.part.0+0x107/0x200 [btrfs]
[75721.832456]  ? split_leaf+0x12d0/0x12d0 [btrfs]
[75721.839149]  ? free_extent_buffer.part.0+0x14f/0x200 [btrfs]
[75721.846945]  ? free_extent_buffer+0x13/0x20 [btrfs]
[75721.853960]  ? btrfs_release_path+0x4b/0x190 [btrfs]
[75721.861429]  btrfs_csum_file_blocks+0x85c/0x1500 [btrfs]
[75721.869313]  ? rcu_read_lock_sched_held+0x16/0x80
[75721.876085]  ? lock_release+0x552/0xf80
[75721.881957]  ? btrfs_del_csums+0x8c0/0x8c0 [btrfs]
[75721.888886]  ? __kasan_check_write+0x14/0x20
[75721.895152]  ? do_raw_read_unlock+0x44/0x80
[75721.901323]  ? _raw_write_lock_irq+0x60/0x80
[75721.907983]  ? btrfs_global_root+0xb9/0xe0 [btrfs]
[75721.915166]  ? btrfs_csum_root+0x12b/0x180 [btrfs]
[75721.921918]  ? btrfs_get_global_root+0x820/0x820 [btrfs]
[75721.929166]  ? _raw_write_unlock+0x23/0x40
[75721.935116]  ? unpin_extent_cache+0x1e3/0x390 [btrfs]
[75721.942041]  btrfs_finish_ordered_io.isra.0+0xa0c/0x1dc0 [btrfs]
[75721.949906]  ? try_to_wake_up+0x30/0x14a0
[75721.955700]  ? btrfs_unlink_subvol+0xda0/0xda0 [btrfs]
[75721.962661]  ? rcu_read_lock_sched_held+0x16/0x80
[75721.969111]  ? lock_acquire+0x41b/0x4c0
[75721.974982]  finish_ordered_fn+0x15/0x20 [btrfs]
[75721.981639]  btrfs_work_helper+0x1af/0xa80 [btrfs]
[75721.988184]  ? _raw_spin_unlock_irq+0x28/0x50
[75721.994643]  process_one_work+0x815/0x1460
[75722.000444]  ? pwq_dec_nr_in_flight+0x250/0x250
[75722.006643]  ? do_raw_spin_trylock+0xbb/0x190
[75722.013086]  worker_thread+0x59a/0xeb0
[75722.018511]  kthread+0x2ac/0x360
[75722.023428]  ? process_one_work+0x1460/0x1460
[75722.029431]  ? kthread_complete_and_exit+0x30/0x30
[75722.036044]  ret_from_fork+0x22/0x30
[75722.041255]  </TASK>
[75722.045047] irq event stamp: 0
[75722.049703] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[75722.057610] hardirqs last disabled at (0): [<ffffffff8118a94a>] copy_process+0x1c1a/0x66b0
[75722.067533] softirqs last  enabled at (0): [<ffffffff8118a989>] copy_process+0x1c59/0x66b0
[75722.077423] softirqs last disabled at (0): [<0000000000000000>] 0x0
[75722.085335] ---[ end trace 0000000000000000 ]---

To fix the estimation, we need to introduce fs_info->max_extent_size to
replace BTRFS_MAX_EXTENT_SIZE, which allow setting the different size for
regular vs zoned filesystem.

Set fs_info->max_extent_size to BTRFS_MAX_EXTENT_SIZE by default. On zoned
filesystem, it is set to fs_info->max_zone_append_size.

CC: stable@vger.kernel.org # 5.12+
Fixes: d8e3fb106f39 ("btrfs: zoned: use ZONE_APPEND write for zoned mode")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b2a161227ac5..0ca83f72dbd9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1055,6 +1055,12 @@ struct btrfs_fs_info {
 	u32 csums_per_leaf;
 	u32 stripesize;
 
+	/*
+	 * Maximum size of an extent. BTRFS_MAX_EXTENT_SIZE on regular
+	 * filesystem, on zoned it depends on the device constraints.
+	 */
+	u64 max_extent_size;
+
 	/* Block groups and devices containing active swapfiles. */
 	spinlock_t swapfile_pins_lock;
 	struct rb_root swapfile_pins;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 494e55ed3709..90e513e54b48 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3159,6 +3159,8 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	fs_info->sectorsize_bits = ilog2(4096);
 	fs_info->stripesize = 4096;
 
+	fs_info->max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	spin_lock_init(&fs_info->swapfile_pins_lock);
 	fs_info->swapfile_pins = RB_ROOT;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 70fc7a650924..fb09b83e2ab4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2021,10 +2021,12 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 				    struct page *locked_page, u64 *start,
 				    u64 *end)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	const u64 orig_start = *start;
 	const u64 orig_end = *end;
-	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
+	/* The sanity tests may not set a valid fs_info. */
+	u64 max_bytes = fs_info ? fs_info->max_extent_size : BTRFS_MAX_EXTENT_SIZE;
 	u64 delalloc_start;
 	u64 delalloc_end;
 	bool found;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b26bb73d9b33..abf5fca26e2c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2201,6 +2201,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 void btrfs_split_delalloc_extent(struct inode *inode,
 				 struct extent_state *orig, u64 split)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 size;
 
 	/* not delalloc, ignore it */
@@ -2208,7 +2209,7 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 		return;
 
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > fs_info->max_extent_size) {
 		u32 num_extents;
 		u64 new_size;
 
@@ -2237,6 +2238,7 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 				 struct extent_state *other)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 new_size, old_size;
 	u32 num_extents;
 
@@ -2250,7 +2252,7 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
+	if (new_size <= fs_info->max_extent_size) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), -1);
 		spin_unlock(&BTRFS_I(inode)->lock);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index bdc533fa80ae..d8a0a522b3ca 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -739,8 +739,11 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 	}
 
 	fs_info->zone_size = zone_size;
-	fs_info->max_zone_append_size = max_zone_append_size;
+	fs_info->max_zone_append_size = ALIGN_DOWN(max_zone_append_size,
+						   fs_info->sectorsize);
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
+	if (fs_info->max_zone_append_size < fs_info->max_extent_size)
+		fs_info->max_extent_size = fs_info->max_zone_append_size;
 
 	/*
 	 * Check mount options here, because we might change fs_info->zoned

