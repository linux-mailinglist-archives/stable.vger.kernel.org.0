Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74DE4CF69C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiCGJmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiCGJkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF09C76653;
        Mon,  7 Mar 2022 01:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB5660FF6;
        Mon,  7 Mar 2022 09:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2BBC340E9;
        Mon,  7 Mar 2022 09:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645784;
        bh=VaOmKGxQ+cGj1k1AnIumsW+U0WowPvpi5pKTa3n9e5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be14d1Yy8CQQCkY/zXU5CF2CHQZsFfMbLMKZjtiSKP9UjyAu1KP5xUIgS1rmGvs5Q
         ObUyHl04fdNAs7qKcDD1VTey2p9UMu7oKK6FsVhfrsUtNknrGfnFEj5/U6qVL447V0
         zjqwYaVQGaW2rJBAvxH1+HJoBTwhZV7k0yu/Tkiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/262] ext4: drop ineligible txn start stop APIs
Date:   Mon,  7 Mar 2022 10:16:18 +0100
Message-Id: <20220307091703.485324988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

[ Upstream commit 7bbbe241ec7ce0def9f71464c878fdbd2b0dcf37 ]

This patch drops ext4_fc_start_ineligible() and
ext4_fc_stop_ineligible() APIs. Fast commit ineligible transactions
should simply call ext4_fc_mark_ineligible() after starting the
trasaction.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211223202140.2061101-3-harshads@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h        |  6 ++--
 fs/ext4/extents.c     |  6 ++--
 fs/ext4/fast_commit.c | 79 ++++++++-----------------------------------
 fs/ext4/ioctl.c       |  3 +-
 fs/ext4/super.c       |  1 -
 5 files changed, 20 insertions(+), 75 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7ebc816ae39f8..58829af68fed1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1724,9 +1724,9 @@ struct ext4_sb_info {
 	 */
 	struct work_struct s_error_work;
 
-	/* Ext4 fast commit stuff */
+	/* Ext4 fast commit sub transaction ID */
 	atomic_t s_fc_subtid;
-	atomic_t s_fc_ineligible_updates;
+
 	/*
 	 * After commit starts, the main queue gets locked, and the further
 	 * updates get added in the staging queue.
@@ -2925,8 +2925,6 @@ void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
 void ext4_fc_track_create(handle_t *handle, struct dentry *dentry);
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode);
 void ext4_fc_mark_ineligible(struct super_block *sb, int reason);
-void ext4_fc_start_ineligible(struct super_block *sb, int reason);
-void ext4_fc_stop_ineligible(struct super_block *sb);
 void ext4_fc_start_update(struct inode *inode);
 void ext4_fc_stop_update(struct inode *inode);
 void ext4_fc_del(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c35cb6d9b7b5f..c19813402ce98 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5340,7 +5340,7 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode, 0);
@@ -5379,7 +5379,6 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
@@ -5481,7 +5480,7 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
 
 	/* Expand file to avoid data loss if there is error while shifting */
 	inode->i_size += len;
@@ -5556,7 +5555,6 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 out_mmap:
 	filemap_invalidate_unlock(mapping);
 out_mutex:
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 7bcd3be07ee46..43da096d9b85e 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -65,21 +65,11 @@
  *
  * Fast Commit Ineligibility
  * -------------------------
- * Not all operations are supported by fast commits today (e.g extended
- * attributes). Fast commit ineligibility is marked by calling one of the
- * two following functions:
- *
- * - ext4_fc_mark_ineligible(): This makes next fast commit operation to fall
- *   back to full commit. This is useful in case of transient errors.
  *
- * - ext4_fc_start_ineligible() and ext4_fc_stop_ineligible() - This makes all
- *   the fast commits happening between ext4_fc_start_ineligible() and
- *   ext4_fc_stop_ineligible() and one fast commit after the call to
- *   ext4_fc_stop_ineligible() to fall back to full commits. It is important to
- *   make one more fast commit to fall back to full commit after stop call so
- *   that it guaranteed that the fast commit ineligible operation contained
- *   within ext4_fc_start_ineligible() and ext4_fc_stop_ineligible() is
- *   followed by at least 1 full commit.
+ * Not all operations are supported by fast commits today (e.g extended
+ * attributes). Fast commit ineligibility is marked by calling
+ * ext4_fc_mark_ineligible(): This makes next fast commit operation to fall back
+ * to full commit.
  *
  * Atomicity of commits
  * --------------------
@@ -328,44 +318,6 @@ void ext4_fc_mark_ineligible(struct super_block *sb, int reason)
 	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;
 }
 
-/*
- * Start a fast commit ineligible update. Any commits that happen while
- * such an operation is in progress fall back to full commits.
- */
-void ext4_fc_start_ineligible(struct super_block *sb, int reason)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
-		return;
-
-	WARN_ON(reason >= EXT4_FC_REASON_MAX);
-	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;
-	atomic_inc(&sbi->s_fc_ineligible_updates);
-}
-
-/*
- * Stop a fast commit ineligible update. We set EXT4_MF_FC_INELIGIBLE flag here
- * to ensure that after stopping the ineligible update, at least one full
- * commit takes place.
- */
-void ext4_fc_stop_ineligible(struct super_block *sb)
-{
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
-		return;
-
-	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
-	atomic_dec(&EXT4_SB(sb)->s_fc_ineligible_updates);
-}
-
-static inline int ext4_fc_is_ineligible(struct super_block *sb)
-{
-	return (ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE) ||
-		atomic_read(&EXT4_SB(sb)->s_fc_ineligible_updates));
-}
-
 /*
  * Generic fast commit tracking function. If this is the first time this we are
  * called after a full commit, we initialize fast commit fields and then call
@@ -391,7 +343,7 @@ static int ext4_fc_track_template(
 	    (sbi->s_mount_state & EXT4_FC_REPLAY))
 		return -EOPNOTSUPP;
 
-	if (ext4_fc_is_ineligible(inode->i_sb))
+	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
 		return -EINVAL;
 
 	tid = handle->h_transaction->t_tid;
@@ -1140,11 +1092,8 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 
 	start_time = ktime_get();
 
-	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
-		(ext4_fc_is_ineligible(sb))) {
-		reason = EXT4_FC_REASON_INELIGIBLE;
-		goto out;
-	}
+	if (!test_opt2(sb, JOURNAL_FAST_COMMIT))
+		return jbd2_complete_transaction(journal, commit_tid);
 
 restart_fc:
 	ret = jbd2_fc_begin_commit(journal, commit_tid);
@@ -1160,6 +1109,14 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 		reason = EXT4_FC_REASON_FC_START_FAILED;
 		goto out;
 	}
+	/*
+	 * After establishing journal barrier via jbd2_fc_begin_commit(), check
+	 * if we are fast commit ineligible.
+	 */
+	if (ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE)) {
+		reason = EXT4_FC_REASON_INELIGIBLE;
+		goto out;
+	}
 
 	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
 	ret = ext4_fc_perform_commit(journal);
@@ -1178,12 +1135,6 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 	atomic_inc(&sbi->s_fc_subtid);
 	jbd2_fc_end_commit(journal);
 out:
-	/* Has any ineligible update happened since we started? */
-	if (reason == EXT4_FC_REASON_OK && ext4_fc_is_ineligible(sb)) {
-		sbi->s_fc_stats.fc_ineligible_reason_count[EXT4_FC_COMMIT_FAILED]++;
-		reason = EXT4_FC_REASON_INELIGIBLE;
-	}
-
 	spin_lock(&sbi->s_fc_lock);
 	if (reason != EXT4_FC_REASON_OK &&
 		reason != EXT4_FC_REASON_ALREADY_COMMITTED) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 220a4c8178b5e..fd70bebb14370 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -169,7 +169,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		err = -EINVAL;
 		goto err_out;
 	}
-	ext4_fc_start_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT);
 
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
@@ -252,7 +252,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 err_out1:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_ineligible(sb);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
 err_out:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 877c5c17e61f0..538a33c3b1176 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4613,7 +4613,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Initialize fast commit stuff */
 	atomic_set(&sbi->s_fc_subtid, 0);
-	atomic_set(&sbi->s_fc_ineligible_updates, 0);
 	INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_MAIN]);
 	INIT_LIST_HEAD(&sbi->s_fc_q[FC_Q_STAGING]);
 	INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_MAIN]);
-- 
2.34.1



