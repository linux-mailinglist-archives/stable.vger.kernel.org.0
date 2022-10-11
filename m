Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0BD5FB549
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiJKOxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiJKOvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1034B9A9CE;
        Tue, 11 Oct 2022 07:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 546C2B8124E;
        Tue, 11 Oct 2022 14:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E199C43147;
        Tue, 11 Oct 2022 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499858;
        bh=QEEJPb16Pm9R+x2qQLK/1+PijYhxQF1TFO6866ROspY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACIJN9q9t4u5q5P1JM808zfAXwi33KsQD8l+dREp1MUJZCX2wYXHBrQWC8jBqkq8h
         0bv3YSZFLLaStM4/lH3lgcaSff9wGZBCZrX7iZp8VcS8wYmogKmL5DlcHCZvesBb0K
         1rWmHaCwq0bQEYYfAILvMSOkdKWtMiUYs3tSPSvj+RcpmKMFJZxi0D6MWf3uhl9MXZ
         rPUYy0XPuYea6v86B3uTTGGey8JslMUSZoohdi5ZHlQVWCaeALQE9N6aY4fVXgH/JE
         aiWvY3MjhddFpdbl9qeKOG7NiNCVssSj+T5X/9m0SbCyQxKlHm/D+o5a2lm9tAL2x2
         kSNCgjwyK0OCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 26/46] btrfs: add lockdep annotations for num_extwriters wait event
Date:   Tue, 11 Oct 2022 10:49:54 -0400
Message-Id: <20221011145015.1622882-26-sashal@kernel.org>
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

[ Upstream commit 5a9ba6709f13313984900d635b4c73c9eb7d644e ]

Similarly to the num_writers wait event in fs/btrfs/transaction.c add a
lockdep annotation for the num_extwriters wait event.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     |  1 +
 fs/btrfs/transaction.c | 13 +++++++++++++
 3 files changed, 15 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 707e644bab92..e886cf639c0f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1097,6 +1097,7 @@ struct btrfs_fs_info {
 	 * compiled without lockdep).
 	 */
 	struct lockdep_map btrfs_trans_num_writers_map;
+	struct lockdep_map btrfs_trans_num_extwriters_map;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a04b32f7df9d..811d743e26e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2991,6 +2991,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	seqlock_init(&fs_info->profiles_lock);
 
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_writers);
+	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_extwriters);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b3cb54d852f8..44e47db4c8e8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -314,6 +314,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		extwriter_counter_inc(cur_trans, type);
 		spin_unlock(&fs_info->trans_lock);
 		btrfs_lockdep_acquire(fs_info, btrfs_trans_num_writers);
+		btrfs_lockdep_acquire(fs_info, btrfs_trans_num_extwriters);
 		return 0;
 	}
 	spin_unlock(&fs_info->trans_lock);
@@ -336,6 +337,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 
 	btrfs_lockdep_acquire(fs_info, btrfs_trans_num_writers);
+	btrfs_lockdep_acquire(fs_info, btrfs_trans_num_extwriters);
 
 	spin_lock(&fs_info->trans_lock);
 	if (fs_info->running_transaction) {
@@ -343,11 +345,13 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 		 * someone started a transaction after we unlocked.  Make sure
 		 * to redo the checks above
 		 */
+		btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
 		goto loop;
 	} else if (BTRFS_FS_ERROR(fs_info)) {
 		spin_unlock(&fs_info->trans_lock);
+		btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 		btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 		kfree(cur_trans);
 		return -EROFS;
@@ -1028,6 +1032,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	cond_wake_up(&cur_trans->writer_wait);
 
+	btrfs_lockdep_release(info, btrfs_trans_num_extwriters);
 	btrfs_lockdep_release(info, btrfs_trans_num_writers);
 
 	btrfs_put_transaction(cur_trans);
@@ -2270,6 +2275,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto lockdep_release;
 
+	/*
+	 * The thread has started/joined the transaction thus it holds the
+	 * lockdep map as a reader. It has to release it before acquiring the
+	 * lockdep map as a writer.
+	 */
+	btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
+	btrfs_might_wait_for_event(fs_info, btrfs_trans_num_extwriters);
 	wait_event(cur_trans->writer_wait,
 		   extwriter_counter_read(cur_trans) == 0);
 
@@ -2541,6 +2553,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	return ret;
 
 lockdep_release:
+	btrfs_lockdep_release(fs_info, btrfs_trans_num_extwriters);
 	btrfs_lockdep_release(fs_info, btrfs_trans_num_writers);
 	goto cleanup_transaction;
 }
-- 
2.35.1

