Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3CB6234AD
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389524AbfETM3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389300AbfETM3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DCA20675;
        Mon, 20 May 2019 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355372;
        bh=5SvO4Qffj2RWCKF8CcAzRO7jPPjGPIYILL4LywgVmZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU8sDL03oCK2y1L+ND91nI5KHYZ3GOjgLxaYKKq0/WXpNI47NvTmT1XFcji4VvFTj
         OPX8OY7Nk/oLbdc1uAC2mLsmmnwbgAedzMRfV7z2/6lNAoATupyfJ7U8ydXArF0Fz8
         TJ48xFFvw/lpS7i2TV2UKnGWXjlOD1v4+Z7jvmTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.0 093/123] Btrfs: do not start a transaction during fiemap
Date:   Mon, 20 May 2019 14:14:33 +0200
Message-Id: <20190520115251.154027281@linuxfoundation.org>
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

commit 03628cdbc64db6262e50d0357960a4e9562676a1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1454,8 +1454,8 @@ int btrfs_find_all_roots(struct btrfs_tr
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
@@ -1478,13 +1478,16 @@ int btrfs_check_shared(struct btrfs_root
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
@@ -1517,6 +1520,7 @@ int btrfs_check_shared(struct btrfs_root
 	} else {
 		up_read(&fs_info->commit_root_sem);
 	}
+out:
 	ulist_free(tmp);
 	ulist_free(roots);
 	return ret;


