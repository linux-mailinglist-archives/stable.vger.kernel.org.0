Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0523614
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbfETM3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389921AbfETM3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0CF9216C4;
        Mon, 20 May 2019 12:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355375;
        bh=dLb2N2hX7UKXH6OrDatTHd+ApsBFdBnB33FzCvux9UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzyqeSPc3QJAxPNMVvmFriPEYemJt2KMC/boTHk1+7NkIgm5I4AUmfVS+EOvJbKjW
         bz7+2HEyRbJjOyoO+VHT/q84mnedZX78tSXAUDNC18CMdAYZ1fcBU6Uhiwyk2/tBOm
         0dTy4JiTv2jDEKNLY2u4DPhU/LtxfBTz1Lmhl9JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.0 094/123] Btrfs: do not start a transaction at iterate_extent_inodes()
Date:   Mon, 20 May 2019 14:14:34 +0200
Message-Id: <20190520115251.228581786@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit bfc61c36260ca990937539cd648ede3cd749bc10 upstream.

When finding out which inodes have references on a particular extent, done
by backref.c:iterate_extent_inodes(), from the BTRFS_IOC_LOGICAL_INO (both
v1 and v2) ioctl and from scrub we use the transaction join API to grab a
reference on the currently running transaction, since in order to give
accurate results we need to inspect the delayed references of the currently
running transaction.

However, if there is currently no running transaction, the join operation
will create a new transaction. This is inefficient as the transaction will
eventually be committed, doing unnecessary IO and introducing a potential
point of failure that will lead to a transaction abort due to -ENOSPC, as
recently reported [1].

That's because the join, creates the transaction but does not reserve any
space, so when attempting to update the root item of the root passed to
btrfs_join_transaction(), during the transaction commit, we can end up
failling with -ENOSPC. Users of a join operation are supposed to actually
do some filesystem changes and reserve space by some means, which is not
the case of iterate_extent_inodes(), it is a read-only operation for all
contextes from which it is called.

The reported [1] -ENOSPC failure stack trace is the following:

 heisenberg kernel: ------------[ cut here ]------------
 heisenberg kernel: BTRFS: Transaction aborted (error -28)
 heisenberg kernel: WARNING: CPU: 0 PID: 7137 at fs/btrfs/root-tree.c:136 btrfs_update_root+0x22b/0x320 [btrfs]
(...)
 heisenberg kernel: CPU: 0 PID: 7137 Comm: btrfs-transacti Not tainted 4.19.0-4-amd64 #1 Debian 4.19.28-2
 heisenberg kernel: Hardware name: FUJITSU LIFEBOOK U757/FJNB2A5, BIOS Version 1.21 03/19/2018
 heisenberg kernel: RIP: 0010:btrfs_update_root+0x22b/0x320 [btrfs]
(...)
 heisenberg kernel: RSP: 0018:ffffb5448828bd40 EFLAGS: 00010286
 heisenberg kernel: RAX: 0000000000000000 RBX: ffff8ed56bccef50 RCX: 0000000000000006
 heisenberg kernel: RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff8ed6bda166a0
 heisenberg kernel: RBP: 00000000ffffffe4 R08: 00000000000003df R09: 0000000000000007
 heisenberg kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff8ed63396a078
 heisenberg kernel: R13: ffff8ed092d7c800 R14: ffff8ed64f5db028 R15: ffff8ed6bd03d068
 heisenberg kernel: FS:  0000000000000000(0000) GS:ffff8ed6bda00000(0000) knlGS:0000000000000000
 heisenberg kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 heisenberg kernel: CR2: 00007f46f75f8000 CR3: 0000000310a0a002 CR4: 00000000003606f0
 heisenberg kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 heisenberg kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 heisenberg kernel: Call Trace:
 heisenberg kernel:  commit_fs_roots+0x166/0x1d0 [btrfs]
 heisenberg kernel:  ? _cond_resched+0x15/0x30
 heisenberg kernel:  ? btrfs_run_delayed_refs+0xac/0x180 [btrfs]
 heisenberg kernel:  btrfs_commit_transaction+0x2bd/0x870 [btrfs]
 heisenberg kernel:  ? start_transaction+0x9d/0x3f0 [btrfs]
 heisenberg kernel:  transaction_kthread+0x147/0x180 [btrfs]
 heisenberg kernel:  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
 heisenberg kernel:  kthread+0x112/0x130
 heisenberg kernel:  ? kthread_bind+0x30/0x30
 heisenberg kernel:  ret_from_fork+0x35/0x40
 heisenberg kernel: ---[ end trace 05de912e30e012d9 ]---

So fix that by using the attach API, which does not create a transaction
when there is currently no running transaction.

[1] https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net/

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1910,13 +1910,19 @@ int iterate_extent_inodes(struct btrfs_f
 			extent_item_objectid);
 
 	if (!search_commit_root) {
-		trans = btrfs_join_transaction(fs_info->extent_root);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		trans = btrfs_attach_transaction(fs_info->extent_root);
+		if (IS_ERR(trans)) {
+			if (PTR_ERR(trans) != -ENOENT &&
+			    PTR_ERR(trans) != -EROFS)
+				return PTR_ERR(trans);
+			trans = NULL;
+		}
+	}
+
+	if (trans)
 		btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-	} else {
+	else
 		down_read(&fs_info->commit_root_sem);
-	}
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
 				   tree_mod_seq_elem.seq, &refs,
@@ -1949,7 +1955,7 @@ int iterate_extent_inodes(struct btrfs_f
 
 	free_leaf_list(refs);
 out:
-	if (!search_commit_root) {
+	if (trans) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 		btrfs_end_transaction(trans);
 	} else {


