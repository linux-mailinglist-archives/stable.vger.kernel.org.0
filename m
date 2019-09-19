Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17FB8532
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405313AbfISWSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392625AbfISWSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:18:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14B6217D6;
        Thu, 19 Sep 2019 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931518;
        bh=rnOZ6QzYOdj7zq9IIKSly3ybfBdDx2tHfI82NcO/ph0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0kN3fOTrKsb8Ylj/pe5EXlhvGe7ZFdczEtyQU162H4eQqiwKoOlgfeOZJ8aQ8mPg
         cz/jtnp0wTccLucKAzdapuWOBDzuwVsjjF2jYJuYbq3W8zABPsXH2RIW2JD9/L6ebD
         KSPcc1kEGbUE0SrA0whahSr8MnzFASGI938aZC1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 16/74] Btrfs: fix assertion failure during fsync and use of stale transaction
Date:   Fri, 20 Sep 2019 00:03:29 +0200
Message-Id: <20190919214805.890256386@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 410f954cb1d1c79ae485dd83a175f21954fd87cd upstream.

Sometimes when fsync'ing a file we need to log that other inodes exist and
when we need to do that we acquire a reference on the inodes and then drop
that reference using iput() after logging them.

That generally is not a problem except if we end up doing the final iput()
(dropping the last reference) on the inode and that inode has a link count
of 0, which can happen in a very short time window if the logging path
gets a reference on the inode while it's being unlinked.

In that case we end up getting the eviction callback, btrfs_evict_inode(),
invoked through the iput() call chain which needs to drop all of the
inode's items from its subvolume btree, and in order to do that, it needs
to join a transaction at the helper function evict_refill_and_join().
However because the task previously started a transaction at the fsync
handler, btrfs_sync_file(), it has current->journal_info already pointing
to a transaction handle and therefore evict_refill_and_join() will get
that transaction handle from btrfs_join_transaction(). From this point on,
two different problems can happen:

1) evict_refill_and_join() will often change the transaction handle's
   block reserve (->block_rsv) and set its ->bytes_reserved field to a
   value greater than 0. If evict_refill_and_join() never commits the
   transaction, the eviction handler ends up decreasing the reference
   count (->use_count) of the transaction handle through the call to
   btrfs_end_transaction(), and after that point we have a transaction
   handle with a NULL ->block_rsv (which is the value prior to the
   transaction join from evict_refill_and_join()) and a ->bytes_reserved
   value greater than 0. If after the eviction/iput completes the inode
   logging path hits an error or it decides that it must fallback to a
   transaction commit, the btrfs fsync handle, btrfs_sync_file(), gets a
   non-zero value from btrfs_log_dentry_safe(), and because of that
   non-zero value it tries to commit the transaction using a handle with
   a NULL ->block_rsv and a non-zero ->bytes_reserved value. This makes
   the transaction commit hit an assertion failure at
   btrfs_trans_release_metadata() because ->bytes_reserved is not zero but
   the ->block_rsv is NULL. The produced stack trace for that is like the
   following:

   [192922.917158] assertion failed: !trans->bytes_reserved, file: fs/btrfs/transaction.c, line: 816
   [192922.917553] ------------[ cut here ]------------
   [192922.917922] kernel BUG at fs/btrfs/ctree.h:3532!
   [192922.918310] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
   [192922.918666] CPU: 2 PID: 883 Comm: fsstress Tainted: G        W         5.1.4-btrfs-next-47 #1
   [192922.919035] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
   [192922.919801] RIP: 0010:assfail.constprop.25+0x18/0x1a [btrfs]
   (...)
   [192922.920925] RSP: 0018:ffffaebdc8a27da8 EFLAGS: 00010286
   [192922.921315] RAX: 0000000000000051 RBX: ffff95c9c16a41c0 RCX: 0000000000000000
   [192922.921692] RDX: 0000000000000000 RSI: ffff95cab6b16838 RDI: ffff95cab6b16838
   [192922.922066] RBP: ffff95c9c16a41c0 R08: 0000000000000000 R09: 0000000000000000
   [192922.922442] R10: ffffaebdc8a27e70 R11: 0000000000000000 R12: ffff95ca731a0980
   [192922.922820] R13: 0000000000000000 R14: ffff95ca84c73338 R15: ffff95ca731a0ea8
   [192922.923200] FS:  00007f337eda4e80(0000) GS:ffff95cab6b00000(0000) knlGS:0000000000000000
   [192922.923579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [192922.923948] CR2: 00007f337edad000 CR3: 00000001e00f6002 CR4: 00000000003606e0
   [192922.924329] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   [192922.924711] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   [192922.925105] Call Trace:
   [192922.925505]  btrfs_trans_release_metadata+0x10c/0x170 [btrfs]
   [192922.925911]  btrfs_commit_transaction+0x3e/0xaf0 [btrfs]
   [192922.926324]  btrfs_sync_file+0x44c/0x490 [btrfs]
   [192922.926731]  do_fsync+0x38/0x60
   [192922.927138]  __x64_sys_fdatasync+0x13/0x20
   [192922.927543]  do_syscall_64+0x60/0x1c0
   [192922.927939]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
   (...)
   [192922.934077] ---[ end trace f00808b12068168f ]---

2) If evict_refill_and_join() decides to commit the transaction, it will
   be able to do it, since the nested transaction join only increments the
   transaction handle's ->use_count reference counter and it does not
   prevent the transaction from getting committed. This means that after
   eviction completes, the fsync logging path will be using a transaction
   handle that refers to an already committed transaction. What happens
   when using such a stale transaction can be unpredictable, we are at
   least having a use-after-free on the transaction handle itself, since
   the transaction commit will call kmem_cache_free() against the handle
   regardless of its ->use_count value, or we can end up silently losing
   all the updates to the log tree after that iput() in the logging path,
   or using a transaction handle that in the meanwhile was allocated to
   another task for a new transaction, etc, pretty much unpredictable
   what can happen.

In order to fix both of them, instead of using iput() during logging, use
btrfs_add_delayed_iput(), so that the logging path of fsync never drops
the last reference on an inode, that step is offloaded to a safe context
(usually the cleaner kthread).

The assertion failure issue was sporadically triggered by the test case
generic/475 from fstests, which loads the dm error target while fsstress
is running, which lead to fsync failing while logging inodes with -EIO
errors and then trying later to commit the transaction, triggering the
assertion failure.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/btrfs/tree-log.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4846,7 +4846,7 @@ again:
 				err = btrfs_log_inode(trans, root, other_inode,
 						      LOG_OTHER_INODE,
 						      0, LLONG_MAX, ctx);
-				iput(other_inode);
+				btrfs_add_delayed_iput(other_inode);
 				if (err)
 					goto out_unlock;
 				else
@@ -5264,7 +5264,7 @@ process_leaf:
 			}
 
 			if (btrfs_inode_in_log(di_inode, trans->transid)) {
-				iput(di_inode);
+				btrfs_add_delayed_iput(di_inode);
 				break;
 			}
 
@@ -5276,7 +5276,7 @@ process_leaf:
 			if (!ret &&
 			    btrfs_must_commit_transaction(trans, di_inode))
 				ret = 1;
-			iput(di_inode);
+			btrfs_add_delayed_iput(di_inode);
 			if (ret)
 				goto next_dir_inode;
 			if (ctx->log_new_dentries) {
@@ -5422,7 +5422,7 @@ static int btrfs_log_all_parents(struct
 			if (!ret && ctx && ctx->log_new_dentries)
 				ret = log_new_dir_dentries(trans, root,
 							   dir_inode, ctx);
-			iput(dir_inode);
+			btrfs_add_delayed_iput(dir_inode);
 			if (ret)
 				goto out;
 		}


