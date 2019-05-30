Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1BF2F386
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfE3DNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbfE3DNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D6C244EF;
        Thu, 30 May 2019 03:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186019;
        bh=T1OAIHJK2VqEpf73x8rM2XJMH3ZYZPwP1CIqcF0Eg54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVEpfC9zjSCGQp8TUD+e8TkTBf9MhBuJ6DrjSVX4Fqhz3UJaDE1I8bv94vIYNp4ln
         imvGd8EPUA5Nb7roXrUVE/no526whZiRF+0OsH/QqsHgQZntpEuQfzoXAFPgfRUK8V
         hOAB1OzkPWeHAhDZOEd29wUBYbUdWMWjAIqlVI+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 088/346] btrfs: fix panic during relocation after ENOSPC before writeback happens
Date:   Wed, 29 May 2019 20:02:41 -0700
Message-Id: <20190530030545.620153475@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ff612ba7849964b1898fd3ccd1f56941129c6aab ]

We've been seeing the following sporadically throughout our fleet

panic: kernel BUG at fs/btrfs/relocation.c:4584!
netversion: 5.0-0
Backtrace:
 #0 [ffffc90003adb880] machine_kexec at ffffffff81041da8
 #1 [ffffc90003adb8c8] __crash_kexec at ffffffff8110396c
 #2 [ffffc90003adb988] crash_kexec at ffffffff811048ad
 #3 [ffffc90003adb9a0] oops_end at ffffffff8101c19a
 #4 [ffffc90003adb9c0] do_trap at ffffffff81019114
 #5 [ffffc90003adba00] do_error_trap at ffffffff810195d0
 #6 [ffffc90003adbab0] invalid_op at ffffffff81a00a9b
    [exception RIP: btrfs_reloc_cow_block+692]
    RIP: ffffffff8143b614  RSP: ffffc90003adbb68  RFLAGS: 00010246
    RAX: fffffffffffffff7  RBX: ffff8806b9c32000  RCX: ffff8806aad00690
    RDX: ffff880850b295e0  RSI: ffff8806b9c32000  RDI: ffff88084f205bd0
    RBP: ffff880849415000   R8: ffffc90003adbbe0   R9: ffff88085ac90000
    R10: ffff8805f7369140  R11: 0000000000000000  R12: ffff880850b295e0
    R13: ffff88084f205bd0  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffc90003adbbb0] __btrfs_cow_block at ffffffff813bf1cd
 #8 [ffffc90003adbc28] btrfs_cow_block at ffffffff813bf4b3
 #9 [ffffc90003adbc78] btrfs_search_slot at ffffffff813c2e6c

The way relocation moves data extents is by creating a reloc inode and
preallocating extents in this inode and then copying the data into these
preallocated extents.  Once we've done this for all of our extents,
we'll write out these dirty pages, which marks the extent written, and
goes into btrfs_reloc_cow_block().  From here we get our current
reloc_control, which _should_ match the reloc_control for the current
block group we're relocating.

However if we get an ENOSPC in this path at some point we'll bail out,
never initiating writeback on this inode.  Not a huge deal, unless we
happen to be doing relocation on a different block group, and this block
group is now rc->stage == UPDATE_DATA_PTRS.  This trips the BUG_ON() in
btrfs_reloc_cow_block(), because we expect to be done modifying the data
inode.  We are in fact done modifying the metadata for the data inode
we're currently using, but not the one from the failed block group, and
thus we BUG_ON().

(This happens when writeback finishes for extents from the previous
group, when we are at btrfs_finish_ordered_io() which updates the data
reloc tree (inode item, drops/adds extent items, etc).)

Fix this by writing out the reloc data inode always, and then breaking
out of the loop after that point to keep from tripping this BUG_ON()
later.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
[ add note from Filipe ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0d..0395b8233c905 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4271,27 +4271,36 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 		mutex_lock(&fs_info->cleaner_mutex);
 		ret = relocate_block_group(rc);
 		mutex_unlock(&fs_info->cleaner_mutex);
-		if (ret < 0) {
+		if (ret < 0)
 			err = ret;
-			goto out;
-		}
-
-		if (rc->extents_found == 0)
-			break;
-
-		btrfs_info(fs_info, "found %llu extents", rc->extents_found);
 
+		/*
+		 * We may have gotten ENOSPC after we already dirtied some
+		 * extents.  If writeout happens while we're relocating a
+		 * different block group we could end up hitting the
+		 * BUG_ON(rc->stage == UPDATE_DATA_PTRS) in
+		 * btrfs_reloc_cow_block.  Make sure we write everything out
+		 * properly so we don't trip over this problem, and then break
+		 * out of the loop if we hit an error.
+		 */
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
 			ret = btrfs_wait_ordered_range(rc->data_inode, 0,
 						       (u64)-1);
-			if (ret) {
+			if (ret)
 				err = ret;
-				goto out;
-			}
 			invalidate_mapping_pages(rc->data_inode->i_mapping,
 						 0, -1);
 			rc->stage = UPDATE_DATA_PTRS;
 		}
+
+		if (err < 0)
+			goto out;
+
+		if (rc->extents_found == 0)
+			break;
+
+		btrfs_info(fs_info, "found %llu extents", rc->extents_found);
+
 	}
 
 	WARN_ON(rc->block_group->pinned > 0);
-- 
2.20.1



