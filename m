Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7E201384
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392005AbgFSPKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392028AbgFSPKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1DF21852;
        Fri, 19 Jun 2020 15:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579430;
        bh=J0wx930+IFDlxwhuiTVEVYIzw4NsTB697VAzJvLH0dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITBEDxBUw5Ahh/faENiA9O9hKFn4YRyCKxPBekyvImUz4E7movTI7SDjTjmx7zy0r
         7SUrN01tpv9fCRB7kUFar2eo71TPsem8kKkx0nCC5/bMACmuktvlbl6PMbUZP6DgnI
         MOjWcAri5Ua/SfFwazx/1m9ZnWGfYkZtAdbDjqQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/261] btrfs: improve global reserve stealing logic
Date:   Fri, 19 Jun 2020 16:32:24 +0200
Message-Id: <20200619141656.234884067@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7f9fe614407692f670601a634621138233ac00d7 ]

For unlink transactions and block group removal
btrfs_start_transaction_fallback_global_rsv will first try to start an
ordinary transaction and if it fails it will fall back to reserving the
required amount by stealing from the global reserve. This is problematic
because of all the same reasons we had with previous iterations of the
ENOSPC handling, thundering herd.  We get a bunch of failures all at
once, everybody tries to allocate from the global reserve, some win and
some lose, we get an ENSOPC.

Fix this behavior by introducing BTRFS_RESERVE_FLUSH_ALL_STEAL. It's
used to mark unlink reservation. To fix this we need to integrate this
logic into the normal ENOSPC infrastructure.  We still go through all of
the normal flushing work, and at the moment we begin to fail all the
tickets we try to satisfy any tickets that are allowed to steal by
stealing from the global reserve.  If this works we start the flushing
system over again just like we would with a normal ticket satisfaction.
This serializes our global reserve stealing, so we don't have the
thundering herd problem.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  2 +-
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/space-info.c  | 37 ++++++++++++++++++++++++++++++++++++-
 fs/btrfs/space-info.h  |  1 +
 fs/btrfs/transaction.c | 42 +++++-------------------------------------
 fs/btrfs/transaction.h |  3 +--
 7 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 2fead6c3c687..c2dd94e1b274 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1167,7 +1167,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	free_extent_map(em);
 
 	return btrfs_start_transaction_fallback_global_rsv(fs_info->extent_root,
-							   num_items, 1);
+							   num_items);
 }
 
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 169075550a5a..6d2c277c6e0a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2465,6 +2465,7 @@ enum btrfs_reserve_flush_enum {
 	BTRFS_RESERVE_FLUSH_LIMIT,
 	BTRFS_RESERVE_FLUSH_EVICT,
 	BTRFS_RESERVE_FLUSH_ALL,
+	BTRFS_RESERVE_FLUSH_ALL_STEAL,
 };
 
 enum btrfs_flush_state {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 94b0df3fb3c8..d2e7ddb95f6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4250,7 +4250,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 	 * 1 for the inode ref
 	 * 1 for the inode
 	 */
-	return btrfs_start_transaction_fallback_global_rsv(root, 5, 5);
+	return btrfs_start_transaction_fallback_global_rsv(root, 5);
 }
 
 static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 5b47e3c44c8f..7889a59a57fa 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -689,6 +689,34 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
 }
 
+static bool steal_from_global_rsv(struct btrfs_fs_info *fs_info,
+				  struct btrfs_space_info *space_info,
+				  struct reserve_ticket *ticket)
+{
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	u64 min_bytes;
+
+	if (global_rsv->space_info != space_info)
+		return false;
+
+	spin_lock(&global_rsv->lock);
+	min_bytes = div_factor(global_rsv->size, 5);
+	if (global_rsv->reserved < min_bytes + ticket->bytes) {
+		spin_unlock(&global_rsv->lock);
+		return false;
+	}
+	global_rsv->reserved -= ticket->bytes;
+	ticket->bytes = 0;
+	list_del_init(&ticket->list);
+	wake_up(&ticket->wait);
+	space_info->tickets_id++;
+	if (global_rsv->reserved < global_rsv->size)
+		global_rsv->full = 0;
+	spin_unlock(&global_rsv->lock);
+
+	return true;
+}
+
 /*
  * maybe_fail_all_tickets - we've exhausted our flushing, start failing tickets
  * @fs_info - fs_info for this fs
@@ -721,6 +749,10 @@ static bool maybe_fail_all_tickets(struct btrfs_fs_info *fs_info,
 		ticket = list_first_entry(&space_info->tickets,
 					  struct reserve_ticket, list);
 
+		if (ticket->steal &&
+		    steal_from_global_rsv(fs_info, space_info, ticket))
+			return true;
+
 		/*
 		 * may_commit_transaction will avoid committing the transaction
 		 * if it doesn't feel like the space reclaimed by the commit
@@ -940,6 +972,7 @@ static int handle_reserve_ticket(struct btrfs_fs_info *fs_info,
 
 	switch (flush) {
 	case BTRFS_RESERVE_FLUSH_ALL:
+	case BTRFS_RESERVE_FLUSH_ALL_STEAL:
 		wait_reserve_ticket(fs_info, space_info, ticket);
 		break;
 	case BTRFS_RESERVE_FLUSH_LIMIT:
@@ -1039,7 +1072,9 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		init_waitqueue_head(&ticket.wait);
-		if (flush == BTRFS_RESERVE_FLUSH_ALL) {
+		ticket.steal = (flush == BTRFS_RESERVE_FLUSH_ALL_STEAL);
+		if (flush == BTRFS_RESERVE_FLUSH_ALL ||
+		    flush == BTRFS_RESERVE_FLUSH_ALL_STEAL) {
 			list_add_tail(&ticket.list, &space_info->tickets);
 			if (!space_info->flush) {
 				space_info->flush = 1;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 8867e84aa33d..8b9a1d8fefcb 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -72,6 +72,7 @@ struct btrfs_space_info {
 struct reserve_ticket {
 	u64 bytes;
 	int error;
+	bool steal;
 	struct list_head list;
 	wait_queue_head_t wait;
 };
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cdca0f656594..a94270a95bbd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -491,7 +491,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		 * refill that amount for whatever is missing in the reserve.
 		 */
 		num_bytes = btrfs_calc_insert_metadata_size(fs_info, num_items);
-		if (delayed_refs_rsv->full == 0) {
+		if (flush == BTRFS_RESERVE_FLUSH_ALL &&
+		    delayed_refs_rsv->full == 0) {
 			delayed_refs_bytes = num_bytes;
 			num_bytes <<= 1;
 		}
@@ -627,43 +628,10 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
-					unsigned int num_items,
-					int min_factor)
+					unsigned int num_items)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *trans;
-	u64 num_bytes;
-	int ret;
-
-	/*
-	 * We have two callers: unlink and block group removal.  The
-	 * former should succeed even if we will temporarily exceed
-	 * quota and the latter operates on the extent root so
-	 * qgroup enforcement is ignored anyway.
-	 */
-	trans = start_transaction(root, num_items, TRANS_START,
-				  BTRFS_RESERVE_FLUSH_ALL, false);
-	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
-		return trans;
-
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return trans;
-
-	num_bytes = btrfs_calc_insert_metadata_size(fs_info, num_items);
-	ret = btrfs_cond_migrate_bytes(fs_info, &fs_info->trans_block_rsv,
-				       num_bytes, min_factor);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ERR_PTR(ret);
-	}
-
-	trans->block_rsv = &fs_info->trans_block_rsv;
-	trans->bytes_reserved = num_bytes;
-	trace_btrfs_space_reservation(fs_info, "transaction",
-				      trans->transid, num_bytes, 1);
-
-	return trans;
+	return start_transaction(root, num_items, TRANS_START,
+				 BTRFS_RESERVE_FLUSH_ALL_STEAL, false);
 }
 
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 2c5a6f6e5bb0..b15c31d23148 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -181,8 +181,7 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   unsigned int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
-					unsigned int num_items,
-					int min_factor);
+					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
-- 
2.25.1



