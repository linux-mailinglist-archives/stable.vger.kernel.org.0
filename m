Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE8D100807
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKRPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:19:26 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:50197 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbfKRPT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:19:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 29F276A2;
        Mon, 18 Nov 2019 10:19:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rUOoyn
        CnVDa92qEemK8MqdK3mn3tWZbNAfsYHiLEKNs=; b=KAS1ZvcbcXAfU9x/JRPbGM
        rI9A1R8s6m+qr7XrKbcmVfigRQBeQTfR2CPCHwQXsmAoLmKNnkuQ036IunhcpTUW
        jPFUbMQdzuafVt54YZwaXQ2z/xJmgwXkS8QQyRk6k7pWFYlcVRUL2yaYm9uKuur3
        NHvYZAs+nmCcMABMxUSfwCGBMNi9FZVl22KHPlsnc6GregP0Ym6ThWAkIFyQKrTq
        OMPwNqrRkALU8ByA8/B0igufGQZ6JUi27LHgL611Ak1o24/CMe2cL+cZJpJI3Ssi
        JGzmDchPUH35/C/HkPVlqRPaGnSi2DKH46hJzD1KqnJAVY9heHljtOhvr+HW1N+A
        ==
X-ME-Sender: <xms:fLbSXag5j0evI4JXFJWbzZ3YW_dxFdzK15nYNUTcuHarkdDfQAP6Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehqvghmuhdrohhrghenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:fLbSXVaR3YNIjzY8p2gflYCeR7PHMasgJlCRDjpzz1dUuiNeWcRCJQ>
    <xmx:fLbSXYPF-HHQ41qoT6ifTKiV9x6t0d3wsLvWentKx_A5_FO1pSKSZw>
    <xmx:fLbSXebuitICL_WD04c1ruOwnIJrQ8_cZ6mc_vnc4ltfCsAcKOctgA>
    <xmx:fLbSXR9XzX6ZVBhTYouuMkO6J3bJno9cHZ8WyUOJF0fDwtVEmCo-Sg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E76873060061;
        Mon, 18 Nov 2019 10:19:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: fix log context list corruption after rename exchange" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, Damenly_Su@gmx.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:19:22 +0100
Message-ID: <1574090362101119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6c617102c7e4ac1398cb0b98ff1f0727755b520 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 8 Nov 2019 16:11:56 +0000
Subject: [PATCH] Btrfs: fix log context list corruption after rename exchange
 operation

During rename exchange we might have successfully log the new name in the
source root's log tree, in which case we leave our log context (allocated
on stack) in the root's list of log contextes. However we might fail to
log the new name in the destination root, in which case we fallback to
a transaction commit later and never sync the log of the source root,
which causes the source root log context to remain in the list of log
contextes. This later causes invalid memory accesses because the context
was allocated on stack and after rename exchange finishes the stack gets
reused and overwritten for other purposes.

The kernel's linked list corruption detector (CONFIG_DEBUG_LIST=y) can
detect this and report something like the following:

  [  691.489929] ------------[ cut here ]------------
  [  691.489947] list_add corruption. prev->next should be next (ffff88819c944530), but was ffff8881c23f7be4. (prev=ffff8881c23f7a38).
  [  691.489967] WARNING: CPU: 2 PID: 28933 at lib/list_debug.c:28 __list_add_valid+0x95/0xe0
  (...)
  [  691.489998] CPU: 2 PID: 28933 Comm: fsstress Not tainted 5.4.0-rc6-btrfs-next-62 #1
  [  691.490001] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  [  691.490003] RIP: 0010:__list_add_valid+0x95/0xe0
  (...)
  [  691.490007] RSP: 0018:ffff8881f0b3faf8 EFLAGS: 00010282
  [  691.490010] RAX: 0000000000000000 RBX: ffff88819c944530 RCX: 0000000000000000
  [  691.490011] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffffa2c497e0
  [  691.490013] RBP: ffff8881f0b3fe68 R08: ffffed103eaa4115 R09: ffffed103eaa4114
  [  691.490015] R10: ffff88819c944000 R11: ffffed103eaa4115 R12: 7fffffffffffffff
  [  691.490016] R13: ffff8881b4035610 R14: ffff8881e7b84728 R15: 1ffff1103e167f7b
  [  691.490019] FS:  00007f4b25ea2e80(0000) GS:ffff8881f5500000(0000) knlGS:0000000000000000
  [  691.490021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  691.490022] CR2: 00007fffbb2d4eec CR3: 00000001f2a4a004 CR4: 00000000003606e0
  [  691.490025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [  691.490027] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [  691.490029] Call Trace:
  [  691.490058]  btrfs_log_inode_parent+0x667/0x2730 [btrfs]
  [  691.490083]  ? join_transaction+0x24a/0xce0 [btrfs]
  [  691.490107]  ? btrfs_end_log_trans+0x80/0x80 [btrfs]
  [  691.490111]  ? dget_parent+0xb8/0x460
  [  691.490116]  ? lock_downgrade+0x6b0/0x6b0
  [  691.490121]  ? rwlock_bug.part.0+0x90/0x90
  [  691.490127]  ? do_raw_spin_unlock+0x142/0x220
  [  691.490151]  btrfs_log_dentry_safe+0x65/0x90 [btrfs]
  [  691.490172]  btrfs_sync_file+0x9f1/0xc00 [btrfs]
  [  691.490195]  ? btrfs_file_write_iter+0x1800/0x1800 [btrfs]
  [  691.490198]  ? rcu_read_lock_any_held.part.11+0x20/0x20
  [  691.490204]  ? __do_sys_newstat+0x88/0xd0
  [  691.490207]  ? cp_new_stat+0x5d0/0x5d0
  [  691.490218]  ? do_fsync+0x38/0x60
  [  691.490220]  do_fsync+0x38/0x60
  [  691.490224]  __x64_sys_fdatasync+0x32/0x40
  [  691.490228]  do_syscall_64+0x9f/0x540
  [  691.490233]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [  691.490235] RIP: 0033:0x7f4b253ad5f0
  (...)
  [  691.490239] RSP: 002b:00007fffbb2d6078 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
  [  691.490242] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4b253ad5f0
  [  691.490244] RDX: 00007fffbb2d5fe0 RSI: 00007fffbb2d5fe0 RDI: 0000000000000003
  [  691.490245] RBP: 000000000000000d R08: 0000000000000001 R09: 00007fffbb2d608c
  [  691.490247] R10: 00000000000002e8 R11: 0000000000000246 R12: 00000000000001f4
  [  691.490248] R13: 0000000051eb851f R14: 00007fffbb2d6120 R15: 00005635a498bda0

This started happening recently when running some test cases from fstests
like btrfs/004 for example, because support for rename exchange was added
last week to fsstress from fstests.

So fix this by deleting the log context for the source root from the list
if we have logged the new name in the source root.

Reported-by: Su Yue <Damenly_Su@gmx.com>
Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
CC: stable@vger.kernel.org # 4.19+
Tested-by: Su Yue <Damenly_Su@gmx.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c6dc4dd16cf7..015910079e73 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9744,6 +9744,18 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 			commit_transaction = true;
 	}
 	if (commit_transaction) {
+		/*
+		 * We may have set commit_transaction when logging the new name
+		 * in the destination root, in which case we left the source
+		 * root context in the list of log contextes. So make sure we
+		 * remove it to avoid invalid memory accesses, since the context
+		 * was allocated in our stack frame.
+		 */
+		if (sync_log_root) {
+			mutex_lock(&root->log_mutex);
+			list_del_init(&ctx_root.list);
+			mutex_unlock(&root->log_mutex);
+		}
 		ret = btrfs_commit_transaction(trans);
 	} else {
 		int ret2;
@@ -9757,6 +9769,9 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
+	ASSERT(list_empty(&ctx_root.list));
+	ASSERT(list_empty(&ctx_dest.list));
+
 	return ret;
 }
 

