Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4816A99C39
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389784AbfHVRcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391600AbfHVRZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:43 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F0523429;
        Thu, 22 Aug 2019 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494742;
        bh=xwobzQCBfNShWtmlyQSWxiukM+RcWbEW9xop9qTy3zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTBeC9Fb4Cw46FlL51BUFp68qq5Ca0tIVa3VQWgBvkJ650HhCiio1N3/yR1Gksfsx
         ebCW70R4xZ8ndudylWfnM9zTJTUC2cc6jR35xHlW2i5OOIhSvwOW+v1Tk9fzdNdMvh
         dMWMpOvdpLZiTHlJ/ZiEpeWH7jimnuNXJitlLpqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/85] Btrfs: fix deadlock between fiemap and transaction commits
Date:   Thu, 22 Aug 2019 10:19:09 -0700
Message-Id: <20190822171732.892648246@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6d155d2e363f26290ffd50591169cb96c2a609e ]

The fiemap handler locks a file range that can have unflushed delalloc,
and after locking the range, it tries to attach to a running transaction.
If the running transaction started its commit, that is, it is in state
TRANS_STATE_COMMIT_START, and either the filesystem was mounted with the
flushoncommit option or the transaction is creating a snapshot for the
subvolume that contains the file that fiemap is operating on, we end up
deadlocking. This happens because fiemap is blocked on the transaction,
waiting for it to complete, and the transaction is waiting for the flushed
dealloc to complete, which requires locking the file range that the fiemap
task already locked. The following stack traces serve as an example of
when this deadlock happens:

  (...)
  [404571.515510] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
  [404571.515956] Call Trace:
  [404571.516360]  ? __schedule+0x3ae/0x7b0
  [404571.516730]  schedule+0x3a/0xb0
  [404571.517104]  lock_extent_bits+0x1ec/0x2a0 [btrfs]
  [404571.517465]  ? remove_wait_queue+0x60/0x60
  [404571.517832]  btrfs_finish_ordered_io+0x292/0x800 [btrfs]
  [404571.518202]  normal_work_helper+0xea/0x530 [btrfs]
  [404571.518566]  process_one_work+0x21e/0x5c0
  [404571.518990]  worker_thread+0x4f/0x3b0
  [404571.519413]  ? process_one_work+0x5c0/0x5c0
  [404571.519829]  kthread+0x103/0x140
  [404571.520191]  ? kthread_create_worker_on_cpu+0x70/0x70
  [404571.520565]  ret_from_fork+0x3a/0x50
  [404571.520915] kworker/u8:6    D    0 31651      2 0x80004000
  [404571.521290] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper [btrfs]
  (...)
  [404571.537000] fsstress        D    0 13117  13115 0x00004000
  [404571.537263] Call Trace:
  [404571.537524]  ? __schedule+0x3ae/0x7b0
  [404571.537788]  schedule+0x3a/0xb0
  [404571.538066]  wait_current_trans+0xc8/0x100 [btrfs]
  [404571.538349]  ? remove_wait_queue+0x60/0x60
  [404571.538680]  start_transaction+0x33c/0x500 [btrfs]
  [404571.539076]  btrfs_check_shared+0xa3/0x1f0 [btrfs]
  [404571.539513]  ? extent_fiemap+0x2ce/0x650 [btrfs]
  [404571.539866]  extent_fiemap+0x2ce/0x650 [btrfs]
  [404571.540170]  do_vfs_ioctl+0x526/0x6f0
  [404571.540436]  ksys_ioctl+0x70/0x80
  [404571.540734]  __x64_sys_ioctl+0x16/0x20
  [404571.540997]  do_syscall_64+0x60/0x1d0
  [404571.541279]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  (...)
  [404571.543729] btrfs           D    0 14210  14208 0x00004000
  [404571.544023] Call Trace:
  [404571.544275]  ? __schedule+0x3ae/0x7b0
  [404571.544526]  ? wait_for_completion+0x112/0x1a0
  [404571.544795]  schedule+0x3a/0xb0
  [404571.545064]  schedule_timeout+0x1ff/0x390
  [404571.545351]  ? lock_acquire+0xa6/0x190
  [404571.545638]  ? wait_for_completion+0x49/0x1a0
  [404571.545890]  ? wait_for_completion+0x112/0x1a0
  [404571.546228]  wait_for_completion+0x131/0x1a0
  [404571.546503]  ? wake_up_q+0x70/0x70
  [404571.546775]  btrfs_wait_ordered_extents+0x27c/0x400 [btrfs]
  [404571.547159]  btrfs_commit_transaction+0x3b0/0xae0 [btrfs]
  [404571.547449]  ? btrfs_mksubvol+0x4a4/0x640 [btrfs]
  [404571.547703]  ? remove_wait_queue+0x60/0x60
  [404571.547969]  btrfs_mksubvol+0x605/0x640 [btrfs]
  [404571.548226]  ? __sb_start_write+0xd4/0x1c0
  [404571.548512]  ? mnt_want_write_file+0x24/0x50
  [404571.548789]  btrfs_ioctl_snap_create_transid+0x169/0x1a0 [btrfs]
  [404571.549048]  btrfs_ioctl_snap_create_v2+0x11d/0x170 [btrfs]
  [404571.549307]  btrfs_ioctl+0x133f/0x3150 [btrfs]
  [404571.549549]  ? mem_cgroup_charge_statistics+0x4c/0xd0
  [404571.549792]  ? mem_cgroup_commit_charge+0x84/0x4b0
  [404571.550064]  ? __handle_mm_fault+0xe3e/0x11f0
  [404571.550306]  ? do_raw_spin_unlock+0x49/0xc0
  [404571.550608]  ? _raw_spin_unlock+0x24/0x30
  [404571.550976]  ? __handle_mm_fault+0xedf/0x11f0
  [404571.551319]  ? do_vfs_ioctl+0xa2/0x6f0
  [404571.551659]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
  [404571.552087]  do_vfs_ioctl+0xa2/0x6f0
  [404571.552355]  ksys_ioctl+0x70/0x80
  [404571.552621]  __x64_sys_ioctl+0x16/0x20
  [404571.552864]  do_syscall_64+0x60/0x1d0
  [404571.553104]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  (...)

If we were joining the transaction instead of attaching to it, we would
not risk a deadlock because a join only blocks if the transaction is in a
state greater then or equals to TRANS_STATE_COMMIT_DOING, and the delalloc
flush performed by a transaction is done before it reaches that state,
when it is in the state TRANS_STATE_COMMIT_START. However a transaction
join is intended for use cases where we do modify the filesystem, and
fiemap only needs to peek at delayed references from the current
transaction in order to determine if extents are shared, and, besides
that, when there is no current transaction or when it blocks to wait for
a current committing transaction to complete, it creates a new transaction
without reserving any space. Such unnecessary transactions, besides doing
unnecessary IO, can cause transaction aborts (-ENOSPC) and unnecessary
rotation of the precious backup roots.

So fix this by adding a new transaction join variant, named join_nostart,
which behaves like the regular join, but it does not create a transaction
when none currently exists or after waiting for a committing transaction
to complete.

Fixes: 03628cdbc64db6 ("Btrfs: do not start a transaction during fiemap")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c     |  2 +-
 fs/btrfs/transaction.c | 22 ++++++++++++++++++----
 fs/btrfs/transaction.h |  3 +++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ac6c383d63140..19855659f6503 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1485,7 +1485,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 		goto out;
 	}
 
-	trans = btrfs_attach_transaction(root);
+	trans = btrfs_join_transaction_nostart(root);
 	if (IS_ERR(trans)) {
 		if (PTR_ERR(trans) != -ENOENT && PTR_ERR(trans) != -EROFS) {
 			ret = PTR_ERR(trans);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f1ca53a3ff0bf..26317bca56499 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -28,15 +28,18 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_COMMIT_START]	= (__TRANS_START | __TRANS_ATTACH),
 	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_START |
 					   __TRANS_ATTACH |
-					   __TRANS_JOIN),
+					   __TRANS_JOIN |
+					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK),
+					   __TRANS_JOIN_NOLOCK |
+					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK),
+					   __TRANS_JOIN_NOLOCK |
+					   __TRANS_JOIN_NOSTART),
 };
 
 void btrfs_put_transaction(struct btrfs_transaction *transaction)
@@ -531,7 +534,8 @@ again:
 		ret = join_transaction(fs_info, type);
 		if (ret == -EBUSY) {
 			wait_current_trans(fs_info);
-			if (unlikely(type == TRANS_ATTACH))
+			if (unlikely(type == TRANS_ATTACH ||
+				     type == TRANS_JOIN_NOSTART))
 				ret = -ENOENT;
 		}
 	} while (ret == -EBUSY);
@@ -647,6 +651,16 @@ struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root
 				 BTRFS_RESERVE_NO_FLUSH, true);
 }
 
+/*
+ * Similar to regular join but it never starts a transaction when none is
+ * running or after waiting for the current one to finish.
+ */
+struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root)
+{
+	return start_transaction(root, 0, TRANS_JOIN_NOSTART,
+				 BTRFS_RESERVE_NO_FLUSH, true);
+}
+
 /*
  * btrfs_attach_transaction() - catch the running transaction
  *
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 4cbb1b55387dc..c1d34cc704722 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -97,11 +97,13 @@ struct btrfs_transaction {
 #define __TRANS_JOIN		(1U << 11)
 #define __TRANS_JOIN_NOLOCK	(1U << 12)
 #define __TRANS_DUMMY		(1U << 13)
+#define __TRANS_JOIN_NOSTART	(1U << 14)
 
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
 #define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
+#define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
 
@@ -187,6 +189,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					int min_factor);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction_barrier(
 					struct btrfs_root *root);
-- 
2.20.1



