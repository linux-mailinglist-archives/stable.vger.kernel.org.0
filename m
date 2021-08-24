Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FE3F6777
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbhHXRfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241718AbhHXRby (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B6E461409;
        Tue, 24 Aug 2021 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824755;
        bh=zoRRCzAM4yGoQkyCKPigv1AZ6Bk70CcbVme16ixhZG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJ8mz5n9AB4WJr9HU+p+5NqLIoaRDysdTe8IcpuEzHlADwfUu9pj9+7fZmhXdOg7Z
         j9DryBAh+JLw1QxG1V2ixbYgw7iz7GqPoutsB4TneZoNh4UaU2qZHjz5xqxSy7vkTT
         Yrpo6ZQidsPydn5J24druIqFUHIB28hVqVzz+eHaOSKhqL2m4cfyyDytuDEzyZSkkp
         0ZoRxReT2gEabwVy/+ynhDbcDdQzEG2V35LDqhp94L/zVcUfO4FIDu2FbqxVGepzCG
         X88TK/Qx1EhuR/UTimVHhW94B1tWKT4fowLKKDSPVDLIyIL0yEfAxTmGYqX/bbX2Sk
         pws/eQyrBtxtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 59/64] btrfs: prevent rename2 from exchanging a subvol with a directory from different parents
Date:   Tue, 24 Aug 2021 13:04:52 -0400
Message-Id: <20210824170457.710623-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3f79f6f6247c83f448c8026c3ee16d4636ef8d4f ]

Cross-rename lacks a check when that would prevent exchanging a
directory and subvolume from different parent subvolume. This causes
data inconsistencies and is caught before commit by tree-checker,
turning the filesystem to read-only.

Calling the renameat2 with RENAME_EXCHANGE flags like

  renameat2(AT_FDCWD, namesrc, AT_FDCWD, namedest, (1 << 1))

on two paths:

  namesrc = dir1/subvol1/dir2
 namedest = subvol2/subvol3

will cause key order problem with following write time tree-checker
report:

  [1194842.307890] BTRFS critical (device loop1): corrupt leaf: root=5 block=27574272 slot=10 ino=258, invalid previous key objectid, have 257 expect 258
  [1194842.322221] BTRFS info (device loop1): leaf 27574272 gen 8 total ptrs 11 free space 15444 owner 5
  [1194842.331562] BTRFS info (device loop1): refs 2 lock_owner 0 current 26561
  [1194842.338772]        item 0 key (256 1 0) itemoff 16123 itemsize 160
  [1194842.338793]                inode generation 3 size 16 mode 40755
  [1194842.338801]        item 1 key (256 12 256) itemoff 16111 itemsize 12
  [1194842.338809]        item 2 key (256 84 2248503653) itemoff 16077 itemsize 34
  [1194842.338817]                dir oid 258 type 2
  [1194842.338823]        item 3 key (256 84 2363071922) itemoff 16043 itemsize 34
  [1194842.338830]                dir oid 257 type 2
  [1194842.338836]        item 4 key (256 96 2) itemoff 16009 itemsize 34
  [1194842.338843]        item 5 key (256 96 3) itemoff 15975 itemsize 34
  [1194842.338852]        item 6 key (257 1 0) itemoff 15815 itemsize 160
  [1194842.338863]                inode generation 6 size 8 mode 40755
  [1194842.338869]        item 7 key (257 12 256) itemoff 15801 itemsize 14
  [1194842.338876]        item 8 key (257 84 2505409169) itemoff 15767 itemsize 34
  [1194842.338883]                dir oid 256 type 2
  [1194842.338888]        item 9 key (257 96 2) itemoff 15733 itemsize 34
  [1194842.338895]        item 10 key (258 12 256) itemoff 15719 itemsize 14
  [1194842.339163] BTRFS error (device loop1): block=27574272 write time tree block corruption detected
  [1194842.339245] ------------[ cut here ]------------
  [1194842.443422] WARNING: CPU: 6 PID: 26561 at fs/btrfs/disk-io.c:449 csum_one_extent_buffer+0xed/0x100 [btrfs]
  [1194842.511863] CPU: 6 PID: 26561 Comm: kworker/u17:2 Not tainted 5.14.0-rc3-git+ #793
  [1194842.511870] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
  [1194842.511876] Workqueue: btrfs-worker-high btrfs_work_helper [btrfs]
  [1194842.511976] RIP: 0010:csum_one_extent_buffer+0xed/0x100 [btrfs]
  [1194842.512068] RSP: 0018:ffffa2c284d77da0 EFLAGS: 00010282
  [1194842.512074] RAX: 0000000000000000 RBX: 0000000000001000 RCX: ffff928867bd9978
  [1194842.512078] RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff928867bd9970
  [1194842.512081] RBP: ffff92876b958000 R08: 0000000000000001 R09: 00000000000c0003
  [1194842.512085] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
  [1194842.512088] R13: ffff92875f989f98 R14: 0000000000000000 R15: 0000000000000000
  [1194842.512092] FS:  0000000000000000(0000) GS:ffff928867a00000(0000) knlGS:0000000000000000
  [1194842.512095] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [1194842.512099] CR2: 000055f5384da1f0 CR3: 0000000102fe4000 CR4: 00000000000006e0
  [1194842.512103] Call Trace:
  [1194842.512128]  ? run_one_async_free+0x10/0x10 [btrfs]
  [1194842.631729]  btree_csum_one_bio+0x1ac/0x1d0 [btrfs]
  [1194842.631837]  run_one_async_start+0x18/0x30 [btrfs]
  [1194842.631938]  btrfs_work_helper+0xd5/0x1d0 [btrfs]
  [1194842.647482]  process_one_work+0x262/0x5e0
  [1194842.647520]  worker_thread+0x4c/0x320
  [1194842.655935]  ? process_one_work+0x5e0/0x5e0
  [1194842.655946]  kthread+0x135/0x160
  [1194842.655953]  ? set_kthread_struct+0x40/0x40
  [1194842.655965]  ret_from_fork+0x1f/0x30
  [1194842.672465] irq event stamp: 1729
  [1194842.672469] hardirqs last  enabled at (1735): [<ffffffffbd1104f5>] console_trylock_spinning+0x185/0x1a0
  [1194842.672477] hardirqs last disabled at (1740): [<ffffffffbd1104cc>] console_trylock_spinning+0x15c/0x1a0
  [1194842.672482] softirqs last  enabled at (1666): [<ffffffffbdc002e1>] __do_softirq+0x2e1/0x50a
  [1194842.672491] softirqs last disabled at (1651): [<ffffffffbd08aab7>] __irq_exit_rcu+0xa7/0xd0

The corrupted data will not be written, and filesystem can be unmounted
and mounted again (all changes since the last commit will be lost).

Add the missing check for new_ino so that all non-subvolumes must reside
under the same parent subvolume. There's an exception allowing to
exchange two subvolumes from any parents as the directory representing a
subvolume is only a logical link and does not have any other structures
related to the parent subvolume, unlike files, directories etc, that
are always in the inode namespace of the parent subvolume.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.7+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ca0fafcd5a6..275a89b8e4b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9833,8 +9833,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
 
-	/* we only allow rename subvolume link between subvolumes */
-	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
+	/*
+	 * For non-subvolumes allow exchange only within one subvolume, in the
+	 * same inode namespace. Two subvolumes (represented as directory) can
+	 * be exchanged as they're a logical link and have a fixed inode number.
+	 */
+	if (root != dest &&
+	    (old_ino != BTRFS_FIRST_FREE_OBJECTID ||
+	     new_ino != BTRFS_FIRST_FREE_OBJECTID))
 		return -EXDEV;
 
 	/* close the race window with snapshot create/destroy ioctl */
-- 
2.30.2

