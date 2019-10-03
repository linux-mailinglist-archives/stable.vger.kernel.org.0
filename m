Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8F7CAC06
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfJCQEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732407AbfJCQEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:04:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 838D4222BE;
        Thu,  3 Oct 2019 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118669;
        bh=+rsf6FiJFtlFHsTR3VE0hyGfcSyz7aArpis+gmgyn+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3XgL8ovnGE2S/DbU9TG5us1pQ4AocR88pUDD3828Z1WEF7yTdiqeOszJR/KjbUv+
         pceSz62oipL/GULtjamuF/fgup0EeNb6n+z5HoJuU1taPgrE//X+lBEnQ3CTvkbG1o
         wka2m8mRtLcotmDW2jrsWrPHjxwK2HEO2p/dP+RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jungyeon Yoon <jungyeon.yoon@gmail.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 095/129] btrfs: extent-tree: Make sure we only allocate extents from block groups with the same type
Date:   Thu,  3 Oct 2019 17:53:38 +0200
Message-Id: <20191003154402.856484772@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7938c48c72ff0..f3a2512344743 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7571,6 +7571,14 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
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



