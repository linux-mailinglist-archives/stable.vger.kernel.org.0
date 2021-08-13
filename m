Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1DC3EB8A4
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbhHMPO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242346AbhHMPOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AF79610CC;
        Fri, 13 Aug 2021 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867612;
        bh=Q9o77BbtVoUm7yQcY/7r3FvoICo0D4P1pW3bc1t/ywY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFEbU/tuZVphRtHq5sx1d/77kKqfXfNmCveq3WbDS3LZwY6B5cuSeraTafLR4Md7Q
         GtTK7mrhpxc4hR7qHoMlSxHjxacA0/gPCyvKWZ1/8vHZw+AwvmLu3DHDgxjvblj/4q
         R2d2XLO9mj7j7uteYvkHIsKQYW7CQUoMht7+BaV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 22/27] btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve retry-after-EDQUOT
Date:   Fri, 13 Aug 2021 17:07:20 +0200
Message-Id: <20210813150524.106630482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit adca4d945c8dca28a85df45c5b117e6dac2e77f1 upstream

commit a514d63882c3 ("btrfs: qgroup: Commit transaction in advance to
reduce early EDQUOT") tries to reduce the early EDQUOT problems by
checking the qgroup free against threshold and tries to wake up commit
kthread to free some space.

The problem of that mechanism is, it can only free qgroup per-trans
metadata space, can't do anything to data, nor prealloc qgroup space.

Now since we have the ability to flush qgroup space, and implemented
retry-after-EDQUOT behavior, such mechanism can be completely replaced.

So this patch will cleanup such mechanism in favor of
retry-after-EDQUOT.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h       |    5 -----
 fs/btrfs/disk-io.c     |    1 -
 fs/btrfs/qgroup.c      |   43 ++-----------------------------------------
 fs/btrfs/transaction.c |    1 -
 fs/btrfs/transaction.h |   14 --------------
 5 files changed, 2 insertions(+), 62 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -505,11 +505,6 @@ enum {
 	 */
 	BTRFS_FS_EXCL_OP,
 	/*
-	 * To info transaction_kthread we need an immediate commit so it
-	 * doesn't need to wait for commit_interval
-	 */
-	BTRFS_FS_NEED_ASYNC_COMMIT,
-	/*
 	 * Indicate that balance has been set up from the ioctl and is in the
 	 * main phase. The fs_info::balance_ctl is initialized.
 	 * Set and cleared while holding fs_info::balance_mutex.
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1749,7 +1749,6 @@ static int transaction_kthread(void *arg
 
 		now = ktime_get_seconds();
 		if (cur->state < TRANS_STATE_COMMIT_START &&
-		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
 		     now - cur->start_time < fs_info->commit_interval)) {
 			spin_unlock(&fs_info->trans_lock);
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/btrfs.h>
-#include <linux/sizes.h>
 
 #include "ctree.h"
 #include "transaction.h"
@@ -2840,20 +2839,8 @@ out:
 	return ret;
 }
 
-/*
- * Two limits to commit transaction in advance.
- *
- * For RATIO, it will be 1/RATIO of the remaining limit as threshold.
- * For SIZE, it will be in byte unit as threshold.
- */
-#define QGROUP_FREE_RATIO		32
-#define QGROUP_FREE_SIZE		SZ_32M
-static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
-				const struct btrfs_qgroup *qg, u64 num_bytes)
+static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 {
-	u64 free;
-	u64 threshold;
-
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 	    qgroup_rsv_total(qg) + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
@@ -2862,32 +2849,6 @@ static bool qgroup_check_limits(struct b
 	    qgroup_rsv_total(qg) + (s64)qg->excl + num_bytes > qg->max_excl)
 		return false;
 
-	/*
-	 * Even if we passed the check, it's better to check if reservation
-	 * for meta_pertrans is pushing us near limit.
-	 * If there is too much pertrans reservation or it's near the limit,
-	 * let's try commit transaction to free some, using transaction_kthread
-	 */
-	if ((qg->lim_flags & (BTRFS_QGROUP_LIMIT_MAX_RFER |
-			      BTRFS_QGROUP_LIMIT_MAX_EXCL))) {
-		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
-			free = qg->max_excl - qgroup_rsv_total(qg) - qg->excl;
-			threshold = min_t(u64, qg->max_excl / QGROUP_FREE_RATIO,
-					  QGROUP_FREE_SIZE);
-		} else {
-			free = qg->max_rfer - qgroup_rsv_total(qg) - qg->rfer;
-			threshold = min_t(u64, qg->max_rfer / QGROUP_FREE_RATIO,
-					  QGROUP_FREE_SIZE);
-		}
-
-		/*
-		 * Use transaction_kthread to commit transaction, so we no
-		 * longer need to bother nested transaction nor lock context.
-		 */
-		if (free < threshold)
-			btrfs_commit_transaction_locksafe(fs_info);
-	}
-
 	return true;
 }
 
@@ -2937,7 +2898,7 @@ static int qgroup_reserve(struct btrfs_r
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if (enforce && !qgroup_check_limits(fs_info, qg, num_bytes)) {
+		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
 			ret = -EDQUOT;
 			goto out;
 		}
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2297,7 +2297,6 @@ int btrfs_commit_transaction(struct btrf
 	 */
 	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
-	clear_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
 
 	spin_lock(&fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -207,20 +207,6 @@ int btrfs_clean_one_deleted_snapshot(str
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
-
-/*
- * Try to commit transaction asynchronously, so this is safe to call
- * even holding a spinlock.
- *
- * It's done by informing transaction_kthread to commit transaction without
- * waiting for commit interval.
- */
-static inline void btrfs_commit_transaction_locksafe(
-		struct btrfs_fs_info *fs_info)
-{
-	set_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
-	wake_up_process(fs_info->transaction_kthread);
-}
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans);
 void btrfs_throttle(struct btrfs_fs_info *fs_info);


