Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1363521A66
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfEQPQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:16:58 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42509 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729164AbfEQPQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:16:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D78F54C3;
        Fri, 17 May 2019 11:16:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=guhEel
        h85yQ9OEVNH4S/1VS77i67g8Q9ibLSXc53ILU=; b=BYRImRqpVLOxrsgR+TNJkS
        YFdedyLIM9ADiyRnBq+SBp76Q5riizAqWTUkGWtGWqNYrQINtJfX7EYMKLcJFg3H
        VZmKG8V/mukpjQFGTshLYUlttMDtHVBGfF5uINueTM32yQxhlDNUSOgGGfPKklxT
        9LdC11OIGZsFVPUAe9U/byD/dTc0NycTuuVGPhU2lKrUXOZsfDjrkcDxf1StpRMT
        av7/MtNHMTi2jogBQmz4hluYCeEdRWVhRXOD/sLQePvSirtPlbaFzCg98GrO/hq/
        nFfvrCDoBQ64jXowamN4Js4RZsyI/ndxapPj7rKiC93Rdbkj7ZlBuRYuMZQLvyiw
        ==
X-ME-Sender: <xms:aNDeXPF-aXWmDEEC7qOKW4BM22VQwkKgSXrSEfeebfAJGI7eFZBZdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:aNDeXJANFzeHejobCN6DozSfCvmQHi3iHWpuHnsZ1VALvXL2U_gDpw>
    <xmx:aNDeXBmZGouSPCsPrRsURBZqOT_-SL2wm6-9k1pPOsVjQcy6MJQpcQ>
    <xmx:aNDeXDrBJ1XHQwwFdwGbZMRV5ts0n9nR_5ujvvQYmGbEzrM0_gfzYw>
    <xmx:aNDeXLGR1N3lAatnJoDT26sWarknNc6-dGXBeeB7Z5xO5Bn77_ejag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DF6F80059;
        Fri, 17 May 2019 11:16:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: do not start a transaction during fiemap" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, calestyo@scientia.net, dsterba@suse.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:16:53 +0200
Message-ID: <155810621312649@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03628cdbc64db6262e50d0357960a4e9562676a1 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 15 Apr 2019 14:50:51 +0100
Subject: [PATCH] Btrfs: do not start a transaction during fiemap

During fiemap, for regular extents (non inline) we need to check if they
are shared and if they are, set the shared bit. Checking if an extent is
shared requires checking the delayed references of the currently running
transaction, since some reference might have not yet hit the extent tree
and be only in the in-memory delayed references.

However we were using a transaction join for this, which creates a new
transaction when there is no transaction currently running. That means
that two more potential failures can happen: creating the transaction and
committing it. Further, if no write activity is currently happening in the
system, and fiemap calls keep being done, we end up creating and
committing transactions that do nothing.

In some extreme cases this can result in the commit of the transaction
created by fiemap to fail with ENOSPC when updating the root item of a
subvolume tree because a join does not reserve any space, leading to a
trace like the following:

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

Since fiemap (and btrfs_check_shared()) is a read-only operation, do not do
a transaction join to avoid the overhead of creating a new transaction (if
there is currently no running transaction) and introducing a potential
point of failure when the new transaction gets committed, instead use a
transaction attach to grab a handle for the currently running transaction
if any.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Link: https://lore.kernel.org/linux-btrfs/b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net/
Fixes: afce772e87c36c ("btrfs: fix check_shared for fiemap ioctl")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 849b8c767efb..982152d3f920 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1460,8 +1460,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
  * callers (such as fiemap) which want to know whether the extent is
  * shared but do not need a ref count.
  *
- * This attempts to allocate a transaction in order to account for
- * delayed refs, but continues on even when the alloc fails.
+ * This attempts to attach to the running transaction in order to account for
+ * delayed refs, but continues on even when no running transaction exists.
  *
  * Return: 0 if extent is not shared, 1 if it is shared, < 0 on error.
  */
@@ -1484,13 +1484,16 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 	tmp = ulist_alloc(GFP_NOFS);
 	roots = ulist_alloc(GFP_NOFS);
 	if (!tmp || !roots) {
-		ulist_free(tmp);
-		ulist_free(roots);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	trans = btrfs_join_transaction(root);
+	trans = btrfs_attach_transaction(root);
 	if (IS_ERR(trans)) {
+		if (PTR_ERR(trans) != -ENOENT && PTR_ERR(trans) != -EROFS) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
 		trans = NULL;
 		down_read(&fs_info->commit_root_sem);
 	} else {
@@ -1523,6 +1526,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 	} else {
 		up_read(&fs_info->commit_root_sem);
 	}
+out:
 	ulist_free(tmp);
 	ulist_free(roots);
 	return ret;

