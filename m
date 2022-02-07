Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6B54ABC88
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380400AbiBGLhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376352AbiBGL2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A6C02B74A;
        Mon,  7 Feb 2022 03:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56620B811A6;
        Mon,  7 Feb 2022 11:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79378C004E1;
        Mon,  7 Feb 2022 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233206;
        bh=PPIZ3FNBzNLS7oB1P31CdMJyNI6i1ZhWc0GS/K9Cs1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCCwZ8QC9dia0qWVyqGvXW0ns4UHc9+x75m3rhqoYIdizCn7o3/pNBvVAFpxFv6q3
         dlBooOHbDNtt+jBAdhGQQtRRJcjzxuhhJrSNQby/QYLgT7bQlnR7Zl/gkxwLeYsK+Q
         8mkYOYm0FJyBasK+uEWJL243psSeAw80nBFQnowI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 019/110] btrfs: fix use-after-free after failure to create a snapshot
Date:   Mon,  7 Feb 2022 12:05:52 +0100
Message-Id: <20220207103802.908849578@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 28b21c558a3753171097193b6f6602a94169093a upstream.

At ioctl.c:create_snapshot(), we allocate a pending snapshot structure and
then attach it to the transaction's list of pending snapshots. After that
we call btrfs_commit_transaction(), and if that returns an error we jump
to 'fail' label, where we kfree() the pending snapshot structure. This can
result in a later use-after-free of the pending snapshot:

1) We allocated the pending snapshot and added it to the transaction's
   list of pending snapshots;

2) We call btrfs_commit_transaction(), and it fails either at the first
   call to btrfs_run_delayed_refs() or btrfs_start_dirty_block_groups().
   In both cases, we don't abort the transaction and we release our
   transaction handle. We jump to the 'fail' label and free the pending
   snapshot structure. We return with the pending snapshot still in the
   transaction's list;

3) Another task commits the transaction. This time there's no error at
   all, and then during the transaction commit it accesses a pointer
   to the pending snapshot structure that the snapshot creation task
   has already freed, resulting in a user-after-free.

This issue could actually be detected by smatch, which produced the
following warning:

  fs/btrfs/ioctl.c:843 create_snapshot() warn: '&pending_snapshot->list' not removed from list

So fix this by not having the snapshot creation ioctl directly add the
pending snapshot to the transaction's list. Instead add the pending
snapshot to the transaction handle, and then at btrfs_commit_transaction()
we add the snapshot to the list only when we can guarantee that any error
returned after that point will result in a transaction abort, in which
case the ioctl code can safely free the pending snapshot and no one can
access it anymore.

CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c       |    5 +----
 fs/btrfs/transaction.c |   24 ++++++++++++++++++++++++
 fs/btrfs/transaction.h |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -775,10 +775,7 @@ static int create_snapshot(struct btrfs_
 		goto fail;
 	}
 
-	spin_lock(&fs_info->trans_lock);
-	list_add(&pending_snapshot->list,
-		 &trans->transaction->pending_snapshots);
-	spin_unlock(&fs_info->trans_lock);
+	trans->pending_snapshot = pending_snapshot;
 
 	ret = btrfs_commit_transaction(trans);
 	if (ret)
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2033,6 +2033,27 @@ static inline void btrfs_wait_delalloc_f
 		btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
+/*
+ * Add a pending snapshot associated with the given transaction handle to the
+ * respective handle. This must be called after the transaction commit started
+ * and while holding fs_info->trans_lock.
+ * This serves to guarantee a caller of btrfs_commit_transaction() that it can
+ * safely free the pending snapshot pointer in case btrfs_commit_transaction()
+ * returns an error.
+ */
+static void add_pending_snapshot(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_transaction *cur_trans = trans->transaction;
+
+	if (!trans->pending_snapshot)
+		return;
+
+	lockdep_assert_held(&trans->fs_info->trans_lock);
+	ASSERT(cur_trans->state >= TRANS_STATE_COMMIT_START);
+
+	list_add(&trans->pending_snapshot->list, &cur_trans->pending_snapshots);
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -2106,6 +2127,8 @@ int btrfs_commit_transaction(struct btrf
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		enum btrfs_trans_state want_state = TRANS_STATE_COMPLETED;
 
+		add_pending_snapshot(trans);
+
 		spin_unlock(&fs_info->trans_lock);
 		refcount_inc(&cur_trans->use_count);
 
@@ -2196,6 +2219,7 @@ int btrfs_commit_transaction(struct btrf
 	 * COMMIT_DOING so make sure to wait for num_writers to == 1 again.
 	 */
 	spin_lock(&fs_info->trans_lock);
+	add_pending_snapshot(trans);
 	cur_trans->state = TRANS_STATE_COMMIT_DOING;
 	spin_unlock(&fs_info->trans_lock);
 	wait_event(cur_trans->writer_wait,
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -123,6 +123,8 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	/* Set by a task that wants to create a snapshot. */
+	struct btrfs_pending_snapshot *pending_snapshot;
 	refcount_t use_count;
 	unsigned int type;
 	/*


