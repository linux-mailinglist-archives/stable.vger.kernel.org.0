Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782F51F1C1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfEOLSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbfEOLSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A30A216F4;
        Wed, 15 May 2019 11:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919088;
        bh=qe0NEEBfQyHz+s/aUOwt23GSKbbMg/UR2UXQUUVIQHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPe38SgFGEomicUPA/DDgbPB931gTIruCgAlDf4TJ8W/xDeOEjnP+FAZrbDvSYiLT
         1+vd0nK54fmryIrzmLjXvUvd3wDTsPLuBLmpPLFxPUyAaiSlJj8d/a7BhmDW809iBS
         /wf1GSdPY1qmDlDpQLuBVI7lEWZRbPfw6t93U/Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 063/115] Btrfs: fix missing delayed iputs on unmount
Date:   Wed, 15 May 2019 12:55:43 +0200
Message-Id: <20190515090704.117076835@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d6fd0ae25c6495674dc5a41a8d16bc8e0073276d ]

There's a race between close_ctree() and cleaner_kthread().
close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
sees it set, but this is racy; the cleaner might have already checked
the bit and could be cleaning stuff. In particular, if it deletes unused
block groups, it will create delayed iputs for the free space cache
inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
longer running delayed iputs after a commit. Therefore, if the cleaner
creates more delayed iputs after delayed iputs are run in
btrfs_commit_super(), we will leak inodes on unmount and get a busy
inode crash from the VFS.

Fix it by parking the cleaner before we actually close anything. Then,
any remaining delayed iputs will always be handled in
btrfs_commit_super(). This also ensures that the commit in close_ctree()
is really the last commit, so we can get rid of the commit in
cleaner_kthread().

The fstest/generic/475 followed by 476 can trigger a crash that
manifests as a slab corruption caused by accessing the freed kthread
structure by a wake up function. Sample trace:

[ 5657.077612] BUG: unable to handle kernel NULL pointer dereference at 00000000000000cc
[ 5657.079432] PGD 1c57a067 P4D 1c57a067 PUD da10067 PMD 0
[ 5657.080661] Oops: 0000 [#1] PREEMPT SMP
[ 5657.081592] CPU: 1 PID: 5157 Comm: fsstress Tainted: G        W         4.19.0-rc8-default+ #323
[ 5657.083703] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[ 5657.086577] RIP: 0010:shrink_page_list+0x2f9/0xe90
[ 5657.091937] RSP: 0018:ffffb5c745c8f728 EFLAGS: 00010287
[ 5657.092953] RAX: 0000000000000074 RBX: ffffb5c745c8f830 RCX: 0000000000000000
[ 5657.094590] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9a8747fdf3d0
[ 5657.095987] RBP: ffffb5c745c8f9e0 R08: 0000000000000000 R09: 0000000000000000
[ 5657.097159] R10: ffff9a8747fdf5e8 R11: 0000000000000000 R12: ffffb5c745c8f788
[ 5657.098513] R13: ffff9a877f6ff2c0 R14: ffff9a877f6ff2c8 R15: dead000000000200
[ 5657.099689] FS:  00007f948d853b80(0000) GS:ffff9a877d600000(0000) knlGS:0000000000000000
[ 5657.101032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5657.101953] CR2: 00000000000000cc CR3: 00000000684bd000 CR4: 00000000000006e0
[ 5657.103159] Call Trace:
[ 5657.103776]  shrink_inactive_list+0x194/0x410
[ 5657.104671]  shrink_node_memcg.constprop.84+0x39a/0x6a0
[ 5657.105750]  shrink_node+0x62/0x1c0
[ 5657.106529]  try_to_free_pages+0x1a4/0x500
[ 5657.107408]  __alloc_pages_slowpath+0x2c9/0xb20
[ 5657.108418]  __alloc_pages_nodemask+0x268/0x2b0
[ 5657.109348]  kmalloc_large_node+0x37/0x90
[ 5657.110205]  __kmalloc_node+0x236/0x310
[ 5657.111014]  kvmalloc_node+0x3e/0x70

Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add trace ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/btrfs/disk-io.c | 51 ++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e0bdc0c902e44..813834552aa10 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1688,9 +1688,8 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int again;
-	struct btrfs_trans_handle *trans;
 
-	do {
+	while (1) {
 		again = 0;
 
 		/* Make the cleaner go to sleep early. */
@@ -1739,42 +1738,16 @@ static int cleaner_kthread(void *arg)
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 sleep:
+		if (kthread_should_park())
+			kthread_parkme();
+		if (kthread_should_stop())
+			return 0;
 		if (!again) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (!kthread_should_stop())
-				schedule();
+			schedule();
 			__set_current_state(TASK_RUNNING);
 		}
-	} while (!kthread_should_stop());
-
-	/*
-	 * Transaction kthread is stopped before us and wakes us up.
-	 * However we might have started a new transaction and COWed some
-	 * tree blocks when deleting unused block groups for example. So
-	 * make sure we commit the transaction we started to have a clean
-	 * shutdown when evicting the btree inode - if it has dirty pages
-	 * when we do the final iput() on it, eviction will trigger a
-	 * writeback for it which will fail with null pointer dereferences
-	 * since work queues and other resources were already released and
-	 * destroyed by the time the iput/eviction/writeback is made.
-	 */
-	trans = btrfs_attach_transaction(root);
-	if (IS_ERR(trans)) {
-		if (PTR_ERR(trans) != -ENOENT)
-			btrfs_err(fs_info,
-				  "cleaner transaction attach returned %ld",
-				  PTR_ERR(trans));
-	} else {
-		int ret;
-
-		ret = btrfs_commit_transaction(trans);
-		if (ret)
-			btrfs_err(fs_info,
-				  "cleaner open transaction commit returned %d",
-				  ret);
 	}
-
-	return 0;
 }
 
 static int transaction_kthread(void *arg)
@@ -3713,6 +3686,13 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+	/*
+	 * We don't want the cleaner to start new transactions, add more delayed
+	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
+	 * because that frees the task_struct, and the transaction kthread might
+	 * still try to wake up the cleaner.
+	 */
+	kthread_park(fs_info->cleaner_kthread);
 
 	/* wait for the qgroup rescan worker to stop */
 	btrfs_qgroup_wait_for_completion(fs_info, false);
@@ -3740,9 +3720,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	if (!sb_rdonly(fs_info->sb)) {
 		/*
-		 * If the cleaner thread is stopped and there are
-		 * block groups queued for removal, the deletion will be
-		 * skipped when we quit the cleaner thread.
+		 * The cleaner kthread is stopped, so do one final pass over
+		 * unused block groups.
 		 */
 		btrfs_delete_unused_bgs(fs_info);
 
-- 
2.20.1



