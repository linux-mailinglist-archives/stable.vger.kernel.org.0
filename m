Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9521702B
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgGGPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbgGGPOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA91D2065D;
        Tue,  7 Jul 2020 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134873;
        bh=6jX1+4WfqU839QEYfkUKFHCVasi+/XagE9XC7bX4rzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/6HztoQ0PRDeO3wI1v/9Zng9taWFNtcTYa6JHgXShsr7SQIHsP5dgazEKSZUxKIi
         sAMd1zdjhtVGXpmF14PZrfGoyIMw/Ip4AUqeLF7iSDdIiOPoQuLjxAGiOBBIRJj7ew
         m4hCdD6oSO80dztc0/A456XkOptwbUOLak8J+lRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 03/24] btrfs: fix data block group relocation failure due to concurrent scrub
Date:   Tue,  7 Jul 2020 17:13:35 +0200
Message-Id: <20200707145749.113278441@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 432cd2a10f1c10cead91fe706ff5dc52f06d642a ]

When running relocation of a data block group while scrub is running in
parallel, it is possible that the relocation will fail and abort the
current transaction with an -EINVAL error:

   [134243.988595] BTRFS info (device sdc): found 14 extents, stage: move data extents
   [134243.999871] ------------[ cut here ]------------
   [134244.000741] BTRFS: Transaction aborted (error -22)
   [134244.001692] WARNING: CPU: 0 PID: 26954 at fs/btrfs/ctree.c:1071 __btrfs_cow_block+0x6a7/0x790 [btrfs]
   [134244.003380] Modules linked in: btrfs blake2b_generic xor raid6_pq (...)
   [134244.012577] CPU: 0 PID: 26954 Comm: btrfs Tainted: G        W         5.6.0-rc7-btrfs-next-58 #5
   [134244.014162] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
   [134244.016184] RIP: 0010:__btrfs_cow_block+0x6a7/0x790 [btrfs]
   [134244.017151] Code: 48 c7 c7 (...)
   [134244.020549] RSP: 0018:ffffa41607863888 EFLAGS: 00010286
   [134244.021515] RAX: 0000000000000000 RBX: ffff9614bdfe09c8 RCX: 0000000000000000
   [134244.022822] RDX: 0000000000000001 RSI: ffffffffb3d63980 RDI: 0000000000000001
   [134244.024124] RBP: ffff961589e8c000 R08: 0000000000000000 R09: 0000000000000001
   [134244.025424] R10: ffffffffc0ae5955 R11: 0000000000000000 R12: ffff9614bd530d08
   [134244.026725] R13: ffff9614ced41b88 R14: ffff9614bdfe2a48 R15: 0000000000000000
   [134244.028024] FS:  00007f29b63c08c0(0000) GS:ffff9615ba600000(0000) knlGS:0000000000000000
   [134244.029491] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [134244.030560] CR2: 00007f4eb339b000 CR3: 0000000130d6e006 CR4: 00000000003606f0
   [134244.031997] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   [134244.033153] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   [134244.034484] Call Trace:
   [134244.034984]  btrfs_cow_block+0x12b/0x2b0 [btrfs]
   [134244.035859]  do_relocation+0x30b/0x790 [btrfs]
   [134244.036681]  ? do_raw_spin_unlock+0x49/0xc0
   [134244.037460]  ? _raw_spin_unlock+0x29/0x40
   [134244.038235]  relocate_tree_blocks+0x37b/0x730 [btrfs]
   [134244.039245]  relocate_block_group+0x388/0x770 [btrfs]
   [134244.040228]  btrfs_relocate_block_group+0x161/0x2e0 [btrfs]
   [134244.041323]  btrfs_relocate_chunk+0x36/0x110 [btrfs]
   [134244.041345]  btrfs_balance+0xc06/0x1860 [btrfs]
   [134244.043382]  ? btrfs_ioctl_balance+0x27c/0x310 [btrfs]
   [134244.045586]  btrfs_ioctl_balance+0x1ed/0x310 [btrfs]
   [134244.045611]  btrfs_ioctl+0x1880/0x3760 [btrfs]
   [134244.049043]  ? do_raw_spin_unlock+0x49/0xc0
   [134244.049838]  ? _raw_spin_unlock+0x29/0x40
   [134244.050587]  ? __handle_mm_fault+0x11b3/0x14b0
   [134244.051417]  ? ksys_ioctl+0x92/0xb0
   [134244.052070]  ksys_ioctl+0x92/0xb0
   [134244.052701]  ? trace_hardirqs_off_thunk+0x1a/0x1c
   [134244.053511]  __x64_sys_ioctl+0x16/0x20
   [134244.054206]  do_syscall_64+0x5c/0x280
   [134244.054891]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
   [134244.055819] RIP: 0033:0x7f29b51c9dd7
   [134244.056491] Code: 00 00 00 (...)
   [134244.059767] RSP: 002b:00007ffcccc1dd08 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
   [134244.061168] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f29b51c9dd7
   [134244.062474] RDX: 00007ffcccc1dda0 RSI: 00000000c4009420 RDI: 0000000000000003
   [134244.063771] RBP: 0000000000000003 R08: 00005565cea4b000 R09: 0000000000000000
   [134244.065032] R10: 0000000000000541 R11: 0000000000000202 R12: 00007ffcccc2060a
   [134244.066327] R13: 00007ffcccc1dda0 R14: 0000000000000002 R15: 00007ffcccc1dec0
   [134244.067626] irq event stamp: 0
   [134244.068202] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
   [134244.069351] hardirqs last disabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
   [134244.070909] softirqs last  enabled at (0): [<ffffffffb2abdedf>] copy_process+0x74f/0x2020
   [134244.072392] softirqs last disabled at (0): [<0000000000000000>] 0x0
   [134244.073432] ---[ end trace bd7c03622e0b0a99 ]---

The -EINVAL error comes from the following chain of function calls:

  __btrfs_cow_block() <-- aborts the transaction
    btrfs_reloc_cow_block()
      replace_file_extents()
        get_new_location() <-- returns -EINVAL

When relocating a data block group, for each allocated extent of the block
group, we preallocate another extent (at prealloc_file_extent_cluster()),
associated with the data relocation inode, and then dirty all its pages.
These preallocated extents have, and must have, the same size that extents
from the data block group being relocated have.

Later before we start the relocation stage that updates pointers (bytenr
field of file extent items) to point to the the new extents, we trigger
writeback for the data relocation inode. The expectation is that writeback
will write the pages to the previously preallocated extents, that it
follows the NOCOW path. That is generally the case, however, if a scrub
is running it may have turned the block group that contains those extents
into RO mode, in which case writeback falls back to the COW path.

However in the COW path instead of allocating exactly one extent with the
expected size, the allocator may end up allocating several smaller extents
due to free space fragmentation - because we tell it at cow_file_range()
that the minimum allocation size can match the filesystem's sector size.
This later breaks the relocation's expectation that an extent associated
to a file extent item in the data relocation inode has the same size as
the respective extent pointed by a file extent item in another tree - in
this case the extent to which the relocation inode poins to is smaller,
causing relocation.c:get_new_location() to return -EINVAL.

For example, if we are relocating a data block group X that has a logical
address of X and the block group has an extent allocated at the logical
address X + 128KiB with a size of 64KiB:

1) At prealloc_file_extent_cluster() we allocate an extent for the data
   relocation inode with a size of 64KiB and associate it to the file
   offset 128KiB (X + 128KiB - X) of the data relocation inode. This
   preallocated extent was allocated at block group Z;

2) A scrub running in parallel turns block group Z into RO mode and
   starts scrubing its extents;

3) Relocation triggers writeback for the data relocation inode;

4) When running delalloc (btrfs_run_delalloc_range()), we try first the
   NOCOW path because the data relocation inode has BTRFS_INODE_PREALLOC
   set in its flags. However, because block group Z is in RO mode, the
   NOCOW path (run_delalloc_nocow()) falls back into the COW path, by
   calling cow_file_range();

5) At cow_file_range(), in the first iteration of the while loop we call
   btrfs_reserve_extent() to allocate a 64KiB extent and pass it a minimum
   allocation size of 4KiB (fs_info->sectorsize). Due to free space
   fragmentation, btrfs_reserve_extent() ends up allocating two extents
   of 32KiB each, each one on a different iteration of that while loop;

6) Writeback of the data relocation inode completes;

7) Relocation proceeds and ends up at relocation.c:replace_file_extents(),
   with a leaf which has a file extent item that points to the data extent
   from block group X, that has a logical address (bytenr) of X + 128KiB
   and a size of 64KiB. Then it calls get_new_location(), which does a
   lookup in the data relocation tree for a file extent item starting at
   offset 128KiB (X + 128KiB - X) and belonging to the data relocation
   inode. It finds a corresponding file extent item, however that item
   points to an extent that has a size of 32KiB, which doesn't match the
   expected size of 64KiB, resuling in -EINVAL being returned from this
   function and propagated up to __btrfs_cow_block(), which aborts the
   current transaction.

To fix this make sure that at cow_file_range() when we call the allocator
we pass it a minimum allocation size corresponding the desired extent size
if the inode belongs to the data relocation tree, otherwise pass it the
filesystem's sector size as the minimum allocation size.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6d63050abe214..dfc0b3adf57af 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -947,6 +947,7 @@ static noinline int cow_file_range(struct inode *inode,
 	u64 alloc_hint = 0;
 	u64 num_bytes;
 	unsigned long ram_size;
+	u64 min_alloc_size;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
@@ -995,12 +996,28 @@ static noinline int cow_file_range(struct inode *inode,
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 
+	/*
+	 * Relocation relies on the relocated extents to have exactly the same
+	 * size as the original extents. Normally writeback for relocation data
+	 * extents follows a NOCOW path because relocation preallocates the
+	 * extents. However, due to an operation such as scrub turning a block
+	 * group to RO mode, it may fallback to COW mode, so we must make sure
+	 * an extent allocated during COW has exactly the requested size and can
+	 * not be split into smaller extents, otherwise relocation breaks and
+	 * fails during the stage where it updates the bytenr of file extent
+	 * items.
+	 */
+	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		min_alloc_size = num_bytes;
+	else
+		min_alloc_size = root->sectorsize;
+
 	while (num_bytes > 0) {
 		unsigned long op;
 
 		cur_alloc_size = num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
-					   root->sectorsize, 0, alloc_hint,
+					   min_alloc_size, 0, alloc_hint,
 					   &ins, 1, 1);
 		if (ret < 0)
 			goto out_unlock;
-- 
2.25.1



