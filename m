Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506F25FB53F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJKOw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJKOvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D090F98CAC;
        Tue, 11 Oct 2022 07:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E19B611CB;
        Tue, 11 Oct 2022 14:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C204EC433C1;
        Tue, 11 Oct 2022 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499856;
        bh=e9OTnvLXO3T6YLDIow2pwUGTs1YW6DDt9WTM+zMjobw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOCYrkDBeQAKXrLLSWPploafToQP1TrZKeWbY4n7DdEEAXWdZQ6LiCDLR6XhHpCoh
         tiJ5jIt1fhTiV1Rt23oeqGyYmaB6ZVPCZdcCSUPEb8iojZvymzCHG//BCIONBAGWL9
         cvP+zLN8pWmFxYWePaj+MBWayYSNy3BVgg8gDuX1cnohGX7BNsMgs8PbMkO68nhZAI
         w5Pv/GJRst9i+bTOGU3+FwaQttO4j0WcFgljiEOKJ1dNnZ3XJB2b1SHTfnk4W/WfVF
         YIAF1ZeYVapc0h66aHtpFSZEFG0brZzyWRmqTFIBMzGPv2IxCwSutAzrGy1XWTWdcS
         y//Jtl1soomEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 25/46] btrfs: add lockdep annotations for num_writers wait event
Date:   Tue, 11 Oct 2022 10:49:53 -0400
Message-Id: <20221011145015.1622882-25-sashal@kernel.org>
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

[ Upstream commit e1489b4fe6045a79a5e9c658eed65311977e230a ]

Annotate the num_writers wait event in fs/btrfs/transaction.c with
lockdep in order to catch deadlocks involving this wait event.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h       |  6 ++++++
 fs/btrfs/disk-io.c     |  2 ++
 fs/btrfs/transaction.c | 38 +++++++++++++++++++++++++++++++++-----
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dfeb7174219e..707e644bab92 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1092,6 +1092,12 @@ struct btrfs_fs_info {
 	/* Updates are not protected by any lock */
 	struct btrfs_commit_stats commit_stats;
 
+	/*
+	 * Annotations for transaction events (structures are empty when
+	 * compiled without lockdep).
+	 */
+	struct lockdep_map btrfs_trans_num_writers_map;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2633137c3e9f..a04b32f7df9d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2990,6 +2990,8 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->zoned_data_reloc_io_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
+	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_writers);
+
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0bec10740ad3..b3cb54d852f8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -313,6 +313,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		atomic_inc(&cur_trans->num_writers);
 		extwriter_counter_inc(cur_trans, type);
 		spin_unlock(&fs_info->trans_lock);
+		btrfs_lockdep_acquire(fs_info, btrfs_trans_num_writers);
 		return 0;
 	}
 	spin_unlock(&fs_info->trans_lock);
@@ -334,16 +335,20 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	if (!cur_trans)
 		return -ENOMEM;
 
+	btrfs_lockdep_acquire(fs_info, btrfs_trans_num_writers);
+
 	spin_lock(&fs_info->trans_lock);
 	if (fs_info->running_transaction) {
 		/*
 		 * someone started a transaction after we unlocked.  Make sure
 		 * to redo the checks above
 		 */
+		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
 		goto loop;
 	} else if (BTRFS_FS_ERROR(fs_info)) {
 		spin_unlock(&fs_info->trans_lock);
+		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
 		return -EROFS;
 	}
@@ -1022,6 +1027,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	extwriter_counter_dec(cur_trans, trans->type);
 
 	cond_wake_up(&cur_trans->writer_wait);
+
+	btrfs_lockdep_release(info, btrfs_trans_num_writers);
+
 	btrfs_put_transaction(cur_trans);
 
 	if (current->journal_info == trans)
@@ -1994,6 +2002,12 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 	if (cur_trans == fs_info->running_transaction) {
 		cur_trans->state = TRANS_STATE_COMMIT_DOING;
 		spin_unlock(&fs_info->trans_lock);
+
+		/*
+		 * The thread has already released the lockdep map as reader
+		 * already in btrfs_commit_transaction().
+		 */
+		btrfs_might_wait_for_event(fs_info, btrfs_trans_num_writers);
 		wait_event(cur_trans->writer_wait,
 			   atomic_read(&cur_trans->num_writers) == 1);
 
@@ -2222,7 +2236,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 			btrfs_put_transaction(prev_trans);
 			if (ret)
-				goto cleanup_transaction;
+				goto lockdep_release;
 		} else {
 			spin_unlock(&fs_info->trans_lock);
 		}
@@ -2236,7 +2250,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		 */
 		if (BTRFS_FS_ERROR(fs_info)) {
 			ret = -EROFS;
-			goto cleanup_transaction;
+			goto lockdep_release;
 		}
 	}
 
@@ -2250,19 +2264,21 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	ret = btrfs_start_delalloc_flush(fs_info);
 	if (ret)
-		goto cleanup_transaction;
+		goto lockdep_release;
 
 	ret = btrfs_run_delayed_items(trans);
 	if (ret)
-		goto cleanup_transaction;
+		goto lockdep_release;
 
 	wait_event(cur_trans->writer_wait,
 		   extwriter_counter_read(cur_trans) == 0);
 
 	/* some pending stuffs might be added after the previous flush. */
 	ret = btrfs_run_delayed_items(trans);
-	if (ret)
+	if (ret) {
+		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		goto cleanup_transaction;
+	}
 
 	btrfs_wait_delalloc_flush(fs_info);
 
@@ -2284,6 +2300,14 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	add_pending_snapshot(trans);
 	cur_trans->state = TRANS_STATE_COMMIT_DOING;
 	spin_unlock(&fs_info->trans_lock);
+
+	/*
+	 * The thread has started/joined the transaction thus it holds the
+	 * lockdep map as a reader. It has to release it before acquiring the
+	 * lockdep map as a writer.
+	 */
+	btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
+	btrfs_might_wait_for_event(fs_info, btrfs_trans_num_writers);
 	wait_event(cur_trans->writer_wait,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
@@ -2515,6 +2539,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	cleanup_transaction(trans, ret);
 
 	return ret;
+
+lockdep_release:
+	btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
+	goto cleanup_transaction;
 }
 
 /*
-- 
2.35.1

