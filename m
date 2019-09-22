Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01CEBA85D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfIVTC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439103AbfIVTCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:02:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 761F9214D9;
        Sun, 22 Sep 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178932;
        bh=57TMLNQQ6YTr7rtXTwnbCE6W7TeG9GeUU2KIoRcYhjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ux+m6CYpj7PI9dewJRP9/WHAr++9vNFO2nQ4DR9Rl4yGSqlmbHDr2jjRLl1khL96/
         bw66f1/WwdLi5c4qKu5MJKmZX3VW8VXU7gYO6zUIrox483IxcB7BhT42WhfAfkRyTb
         ggoDWJxczdcm/nE6dz16vQR7zG+TUBls/N6zzN4U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Jungyeon Yoon <jungyeon.yoon@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 44/44] btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type
Date:   Sun, 22 Sep 2019 15:01:02 -0400
Message-Id: <20190922190103.4906-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2a28468e525f3924efed7f29f2bc5a2926e7e19a ]

[BUG]
With fuzzed image and MIXED_GROUPS super flag, we can hit the following
BUG_ON():

  kernel BUG at fs/btrfs/delayed-ref.c:491!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 1849 Comm: sync Tainted: G           O      5.2.0-custom #27
  RIP: 0010:update_existing_head_ref.cold+0x44/0x46 [btrfs]
  Call Trace:
   add_delayed_ref_head+0x20c/0x2d0 [btrfs]
   btrfs_add_delayed_tree_ref+0x1fc/0x490 [btrfs]
   btrfs_free_tree_block+0x123/0x380 [btrfs]
   __btrfs_cow_block+0x435/0x500 [btrfs]
   btrfs_cow_block+0x110/0x240 [btrfs]
   btrfs_search_slot+0x230/0xa00 [btrfs]
   ? __lock_acquire+0x105e/0x1e20
   btrfs_insert_empty_items+0x67/0xc0 [btrfs]
   alloc_reserved_file_extent+0x9e/0x340 [btrfs]
   __btrfs_run_delayed_refs+0x78e/0x1240 [btrfs]
   ? kvm_clock_read+0x18/0x30
   ? __sched_clock_gtod_offset+0x21/0x50
   btrfs_run_delayed_refs.part.0+0x4e/0x180 [btrfs]
   btrfs_run_delayed_refs+0x23/0x30 [btrfs]
   btrfs_commit_transaction+0x53/0x9f0 [btrfs]
   btrfs_sync_fs+0x7c/0x1c0 [btrfs]
   ? __ia32_sys_fdatasync+0x20/0x20
   sync_fs_one_sb+0x23/0x30
   iterate_supers+0x95/0x100
   ksys_sync+0x62/0xb0
   __ia32_sys_sync+0xe/0x20
   do_syscall_64+0x65/0x240
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

[CAUSE]
This situation is caused by several factors:
- Fuzzed image
  The extent tree of this fs missed one backref for extent tree root.
  So we can allocated space from that slot.

- MIXED_BG feature
  Super block has MIXED_BG flag.

- No mixed block groups exists
  All block groups are just regular ones.

This makes data space_info->block_groups[] contains metadata block
groups.  And when we reserve space for data, we can use space in
metadata block group.

Then we hit the following file operations:

- fallocate
  We need to allocate data extents.
  find_free_extent() choose to use the metadata block to allocate space
  from, and choose the space of extent tree root, since its backref is
  missing.

  This generate one delayed ref head with is_data = 1.

- extent tree update
  We need to update extent tree at run_delayed_ref time.

  This generate one delayed ref head with is_data = 0, for the same
  bytenr of old extent tree root.

Then we trigger the BUG_ON().

[FIX]
The quick fix here is to check block_group->flags before using it.

The problem can only happen for MIXED_GROUPS fs. Regular filesystems
won't have space_info with DATA|METADATA flag, and no way to hit the
bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203255
Reported-by: Jungyeon Yoon <jungyeon.yoon@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index df2bb4b61a00d..4c316ca3ee785 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7168,6 +7168,14 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 			 */
 			if ((flags & extra) && !(block_group->flags & extra))
 				goto loop;
+
+			/*
+			 * This block group has different flags than we want.
+			 * It's possible that we have MIXED_GROUP flag but no
+			 * block group is mixed.  Just skip such block group.
+			 */
+			btrfs_release_block_group(block_group, delalloc);
+			continue;
 		}
 
 have_block_group:
-- 
2.20.1

