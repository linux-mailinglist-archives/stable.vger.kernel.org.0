Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD822ABB0B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387823AbgKINTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387820AbgKINTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE7020663;
        Mon,  9 Nov 2020 13:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927983;
        bh=Iz+JLNJgmDLZjp5vlBNCDt510Qp8YB7z/1lRTcyYMi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4P3SE0hX68zk0OzstPAZcp4TxjJVGAtB33QmXaHG3Tt0I85HL+ZMwaIDN0v2QIYy
         9Wsvf87lPUemD1oMBKkgcbKRA4UcLj+QBIYrqA3dk5cuWGYpT7jRxdcW9zWTLJXfqa
         kIZ9fSGyo+A2sdyX4SRVkFVBP4wLhPZqv8UYJONk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 087/133] btrfs: drop the path before adding qgroup items when enabling qgroups
Date:   Mon,  9 Nov 2020 13:55:49 +0100
Message-Id: <20201109125034.893667242@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5223cc60b40ae525ae6c94e98824129f1a5b4ae5 ]

When enabling qgroups we walk the tree_root and then add a qgroup item
for every root that we have.  This creates a lock dependency on the
tree_root and qgroup_root, which results in the following lockdep splat
(with tree locks using rwsem), eg. in tests btrfs/017 or btrfs/022:

  ======================================================
  WARNING: possible circular locking dependency detected
  5.9.0-default+ #1299 Not tainted
  ------------------------------------------------------
  btrfs/24552 is trying to acquire lock:
  ffff9142dfc5f630 (btrfs-quota-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]

  but task is already holding lock:
  ffff9142dfc5d0b0 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (btrfs-root-00){++++}-{3:3}:
	 __lock_acquire+0x3fb/0x730
	 lock_acquire.part.0+0x6a/0x130
	 down_read_nested+0x46/0x130
	 __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
	 __btrfs_read_lock_root_node+0x3a/0x50 [btrfs]
	 btrfs_search_slot_get_root+0x11d/0x290 [btrfs]
	 btrfs_search_slot+0xc3/0x9f0 [btrfs]
	 btrfs_insert_item+0x6e/0x140 [btrfs]
	 btrfs_create_tree+0x1cb/0x240 [btrfs]
	 btrfs_quota_enable+0xcd/0x790 [btrfs]
	 btrfs_ioctl_quota_ctl+0xc9/0xe0 [btrfs]
	 __x64_sys_ioctl+0x83/0xa0
	 do_syscall_64+0x2d/0x70
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  -> #0 (btrfs-quota-00){++++}-{3:3}:
	 check_prev_add+0x91/0xc30
	 validate_chain+0x491/0x750
	 __lock_acquire+0x3fb/0x730
	 lock_acquire.part.0+0x6a/0x130
	 down_read_nested+0x46/0x130
	 __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
	 __btrfs_read_lock_root_node+0x3a/0x50 [btrfs]
	 btrfs_search_slot_get_root+0x11d/0x290 [btrfs]
	 btrfs_search_slot+0xc3/0x9f0 [btrfs]
	 btrfs_insert_empty_items+0x58/0xa0 [btrfs]
	 add_qgroup_item.part.0+0x72/0x210 [btrfs]
	 btrfs_quota_enable+0x3bb/0x790 [btrfs]
	 btrfs_ioctl_quota_ctl+0xc9/0xe0 [btrfs]
	 __x64_sys_ioctl+0x83/0xa0
	 do_syscall_64+0x2d/0x70
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  other info that might help us debug this:

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(btrfs-root-00);
				 lock(btrfs-quota-00);
				 lock(btrfs-root-00);
    lock(btrfs-quota-00);

   *** DEADLOCK ***

  5 locks held by btrfs/24552:
   #0: ffff9142df431478 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write_file+0x22/0xa0
   #1: ffff9142f9b10cc0 (&fs_info->subvol_sem){++++}-{3:3}, at: btrfs_ioctl_quota_ctl+0x7b/0xe0 [btrfs]
   #2: ffff9142f9b11a08 (&fs_info->qgroup_ioctl_lock){+.+.}-{3:3}, at: btrfs_quota_enable+0x3b/0x790 [btrfs]
   #3: ffff9142df431698 (sb_internal#2){.+.+}-{0:0}, at: start_transaction+0x406/0x510 [btrfs]
   #4: ffff9142dfc5d0b0 (btrfs-root-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]

  stack backtrace:
  CPU: 1 PID: 24552 Comm: btrfs Not tainted 5.9.0-default+ #1299
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   dump_stack+0x77/0x97
   check_noncircular+0xf3/0x110
   check_prev_add+0x91/0xc30
   validate_chain+0x491/0x750
   __lock_acquire+0x3fb/0x730
   lock_acquire.part.0+0x6a/0x130
   ? __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
   ? lock_acquire+0xc4/0x140
   ? __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
   down_read_nested+0x46/0x130
   ? __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
   __btrfs_tree_read_lock+0x35/0x1c0 [btrfs]
   ? btrfs_root_node+0xd9/0x200 [btrfs]
   __btrfs_read_lock_root_node+0x3a/0x50 [btrfs]
   btrfs_search_slot_get_root+0x11d/0x290 [btrfs]
   btrfs_search_slot+0xc3/0x9f0 [btrfs]
   btrfs_insert_empty_items+0x58/0xa0 [btrfs]
   add_qgroup_item.part.0+0x72/0x210 [btrfs]
   btrfs_quota_enable+0x3bb/0x790 [btrfs]
   btrfs_ioctl_quota_ctl+0xc9/0xe0 [btrfs]
   __x64_sys_ioctl+0x83/0xa0
   do_syscall_64+0x2d/0x70
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by dropping the path whenever we find a root item, add the
qgroup item, and then re-lookup the root item we found and continue
processing roots.

Reported-by: David Sterba <dsterba@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c0f350c3a0cf4..db953cb947bc4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1026,6 +1026,10 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 		if (found_key.type == BTRFS_ROOT_REF_KEY) {
+
+			/* Release locks on tree_root before we access quota_root */
+			btrfs_release_path(path);
+
 			ret = add_qgroup_item(trans, quota_root,
 					      found_key.offset);
 			if (ret) {
@@ -1044,6 +1048,20 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 				btrfs_abort_transaction(trans, ret);
 				goto out_free_path;
 			}
+			ret = btrfs_search_slot_for_read(tree_root, &found_key,
+							 path, 1, 0);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto out_free_path;
+			}
+			if (ret > 0) {
+				/*
+				 * Shouldn't happen, but in case it does we
+				 * don't need to do the btrfs_next_item, just
+				 * continue.
+				 */
+				continue;
+			}
 		}
 		ret = btrfs_next_item(tree_root, path);
 		if (ret < 0) {
-- 
2.27.0



