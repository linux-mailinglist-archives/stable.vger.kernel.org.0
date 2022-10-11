Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F232C5FB547
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJKOxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiJKOvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E469A9EB;
        Tue, 11 Oct 2022 07:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2856DCE1884;
        Tue, 11 Oct 2022 14:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC0EC433D7;
        Tue, 11 Oct 2022 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499859;
        bh=OUbzELi5snzSX2q/P6nJJi4FNEwM4PHYExZ0B70G1tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ii+o+dDm7W8aZ6zCQP4QwkI9BNOTF/xhQL0oeV6Xad326aG8n60AK7+9p5/WaybxM
         FJx0oU1aDJ29W3k1byVS+O1uZ55njzumSTGz5IqVLDTHuJ1lknNxOmLFpUz4b8+H1D
         oHtbbKUgj7hmEI/sRgFCicGHE2DbSPUc5RATMyDN+37o18uI32Djh2sVldMtnSG45Q
         oMMqxpkMTGgmWUYY7dhl124Jf3SLefrPkZwoI1BNFvn5iH6COeOA+VyMb/4Gtr9ZEA
         ZP6dKwAjFcRh2hWS+NJTFB838mrJ6g4X425eQw3na20VDz4xt2EMYbjOB7XqxhwovN
         bq3Y+fT7vPaag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/46] btrfs: add lockdep annotations for transaction states wait events
Date:   Tue, 11 Oct 2022 10:49:55 -0400
Message-Id: <20221011145015.1622882-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioannis Angelakopoulos <iangelak@fb.com>

[ Upstream commit 3e738c531aad8caa7f3d20ab878a8a0d3574e730 ]

Add lockdep annotations for the transaction states that have wait
events;

  1) TRANS_STATE_COMMIT_START
  2) TRANS_STATE_UNBLOCKED
  3) TRANS_STATE_SUPER_COMMITTED
  4) TRANS_STATE_COMPLETED

The new macros introduced here to annotate the transaction states wait
events have the same effect as the generic lockdep annotation macros.

With the exception of the lockdep annotation for TRANS_STATE_COMMIT_START
the transaction thread has to acquire the lockdep maps for the
transaction states as reader after the lockdep map for num_writers is
released so that lockdep does not complain.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h       | 32 +++++++++++++++++++++++++
 fs/btrfs/disk-io.c     |  8 +++++++
 fs/btrfs/transaction.c | 53 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e886cf639c0f..f8172e269f03 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1098,6 +1098,7 @@ struct btrfs_fs_info {
 	 */
 	struct lockdep_map btrfs_trans_num_writers_map;
 	struct lockdep_map btrfs_trans_num_extwriters_map;
+	struct lockdep_map btrfs_state_change_map[4];
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
@@ -1181,6 +1182,13 @@ enum {
 	BTRFS_ROOT_RESET_LOCKDEP_CLASS,
 };
 
+enum btrfs_lockdep_trans_states {
+	BTRFS_LOCKDEP_TRANS_COMMIT_START,
+	BTRFS_LOCKDEP_TRANS_UNBLOCKED,
+	BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED,
+	BTRFS_LOCKDEP_TRANS_COMPLETED,
+};
+
 /*
  * Lockdep annotation for wait events.
  *
@@ -1219,6 +1227,22 @@ enum {
 #define btrfs_lockdep_release(owner, lock)					\
 	rwsem_release(&owner->lock##_map, _THIS_IP_)
 
+/*
+ * Macros for the transaction states wait events, similar to the generic wait
+ * event macros.
+ */
+#define btrfs_might_wait_for_state(owner, i)					\
+	do {									\
+		rwsem_acquire(&owner->btrfs_state_change_map[i], 0, 0, _THIS_IP_); \
+		rwsem_release(&owner->btrfs_state_change_map[i], _THIS_IP_);	\
+	} while (0)
+
+#define btrfs_trans_state_lockdep_acquire(owner, i)				\
+	rwsem_acquire_read(&owner->btrfs_state_change_map[i], 0, 0, _THIS_IP_)
+
+#define btrfs_trans_state_lockdep_release(owner, i)				\
+	rwsem_release(&owner->btrfs_state_change_map[i], _THIS_IP_)
+
 /* Initialization of the lockdep map */
 #define btrfs_lockdep_init_map(owner, lock)					\
 	do {									\
@@ -1226,6 +1250,14 @@ enum {
 		lockdep_init_map(&owner->lock##_map, #lock, &lock##_key, 0);	\
 	} while (0)
 
+/* Initialization of the transaction states lockdep maps. */
+#define btrfs_state_lockdep_init_map(owner, lock, state)			\
+	do {									\
+		static struct lock_class_key lock##_key;			\
+		lockdep_init_map(&owner->btrfs_state_change_map[state], #lock,	\
+				 &lock##_key, 0);				\
+	} while (0)
+
 static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
 {
 	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 811d743e26e6..68c6cb4e9283 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2992,6 +2992,14 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_writers);
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_extwriters);
+	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_commit_start,
+				     BTRFS_LOCKDEP_TRANS_COMMIT_START);
+	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_unblocked,
+				     BTRFS_LOCKDEP_TRANS_UNBLOCKED);
+	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_super_committed,
+				     BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
+	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_completed,
+				     BTRFS_LOCKDEP_TRANS_COMPLETED);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 44e47db4c8e8..d3576f84020d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -550,6 +550,7 @@ static void wait_current_trans(struct btrfs_fs_info *fs_info)
 		refcount_inc(&cur_trans->use_count);
 		spin_unlock(&fs_info->trans_lock);
 
+		btrfs_might_wait_for_state(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 		wait_event(fs_info->transaction_wait,
 			   cur_trans->state >= TRANS_STATE_UNBLOCKED ||
 			   TRANS_ABORTED(cur_trans));
@@ -868,6 +869,15 @@ static noinline void wait_for_commit(struct btrfs_transaction *commit,
 	u64 transid = commit->transid;
 	bool put = false;
 
+	/*
+	 * At the moment this function is called with min_state either being
+	 * TRANS_STATE_COMPLETED or TRANS_STATE_SUPER_COMMITTED.
+	 */
+	if (min_state == TRANS_STATE_COMPLETED)
+		btrfs_might_wait_for_state(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
+	else
+		btrfs_might_wait_for_state(fs_info, BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
+
 	while (1) {
 		wait_event(commit->commit_wait, commit->state >= min_state);
 		if (put)
@@ -1980,6 +1990,7 @@ void btrfs_commit_transaction_async(struct btrfs_trans_handle *trans)
 	 * Wait for the current transaction commit to start and block
 	 * subsequent transaction joins
 	 */
+	btrfs_might_wait_for_state(fs_info, BTRFS_LOCKDEP_TRANS_COMMIT_START);
 	wait_event(fs_info->transaction_blocked_wait,
 		   cur_trans->state >= TRANS_STATE_COMMIT_START ||
 		   TRANS_ABORTED(cur_trans));
@@ -2137,12 +2148,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	ktime_t interval;
 
 	ASSERT(refcount_read(&trans->use_count) == 1);
+	btrfs_trans_state_lockdep_acquire(fs_info, BTRFS_LOCKDEP_TRANS_COMMIT_START);
 
 	/* Stop the commit early if ->aborted is set */
 	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
-		btrfs_end_transaction(trans);
-		return ret;
+		goto lockdep_trans_commit_start_release;
 	}
 
 	btrfs_trans_release_metadata(trans);
@@ -2159,10 +2170,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		 * Any running threads may add more while we are here.
 		 */
 		ret = btrfs_run_delayed_refs(trans, 0);
-		if (ret) {
-			btrfs_end_transaction(trans);
-			return ret;
-		}
+		if (ret)
+			goto lockdep_trans_commit_start_release;
 	}
 
 	btrfs_create_pending_block_groups(trans);
@@ -2191,10 +2200,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 		if (run_it) {
 			ret = btrfs_start_dirty_block_groups(trans);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				return ret;
-			}
+			if (ret)
+				goto lockdep_trans_commit_start_release;
 		}
 	}
 
@@ -2209,6 +2216,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 		if (trans->in_fsync)
 			want_state = TRANS_STATE_SUPER_COMMITTED;
+
+		btrfs_trans_state_lockdep_release(fs_info,
+						  BTRFS_LOCKDEP_TRANS_COMMIT_START);
 		ret = btrfs_end_transaction(trans);
 		wait_for_commit(cur_trans, want_state);
 
@@ -2222,6 +2232,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&fs_info->transaction_blocked_wait);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMMIT_START);
 
 	if (cur_trans->list.prev != &fs_info->trans_list) {
 		enum btrfs_trans_state want_state = TRANS_STATE_COMPLETED;
@@ -2323,6 +2334,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
+	/*
+	 * Make lockdep happy by acquiring the state locks after
+	 * btrfs_trans_num_writers is released. If we acquired the state locks
+	 * before releasing the btrfs_trans_num_writers lock then lockdep would
+	 * complain because we did not follow the reverse order unlocking rule.
+	 */
+	btrfs_trans_state_lockdep_acquire(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
+	btrfs_trans_state_lockdep_acquire(fs_info, BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
+	btrfs_trans_state_lockdep_acquire(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
+
 	/*
 	 * We've started the commit, clear the flag in case we were triggered to
 	 * do an async commit but somebody else started before the transaction
@@ -2332,6 +2353,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
+		btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 		goto scrub_continue;
 	}
 	/*
@@ -2466,6 +2488,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	mutex_unlock(&fs_info->reloc_mutex);
 
 	wake_up(&fs_info->transaction_wait);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (ret) {
@@ -2497,6 +2520,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	cur_trans->state = TRANS_STATE_SUPER_COMMITTED;
 	wake_up(&cur_trans->commit_wait);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
 
 	btrfs_finish_extent_commit(trans);
 
@@ -2510,6 +2534,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
 
 	spin_lock(&fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
@@ -2538,7 +2563,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 unlock_reloc:
 	mutex_unlock(&fs_info->reloc_mutex);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_UNBLOCKED);
 scrub_continue:
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_SUPER_COMMITTED);
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans);
@@ -2556,6 +2584,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 	btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 	goto cleanup_transaction;
+
+lockdep_trans_commit_start_release:
+	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMMIT_START);
+	btrfs_end_transaction(trans);
+	return ret;
 }
 
 /*
-- 
2.35.1

