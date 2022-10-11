Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9245FB542
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJKOwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiJKOvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52739834A;
        Tue, 11 Oct 2022 07:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 823FB611B1;
        Tue, 11 Oct 2022 14:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16439C433C1;
        Tue, 11 Oct 2022 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499860;
        bh=pO9gHWeRi4XCpJEbr35YjEyd2oLIaxjzIdvvbxQBObE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od9vK6OzfmOfiwz2cccYSNYUey3bXTqt4lSKzVOHHwZZzlf6tc3TNaUDP8YUxo7w1
         6Ae3JHlfcnuiCWphDrNkD+VT0xqJk4uw2V1uvK63XEpGY4B+J6IyIocP+517vfqwzk
         EueTpM8ICOP0Lt9BIm9PAWuKeJ3NoD05buH2EvQxxXY8rPQmD3/+CRlkNoE68LG8/l
         fN8IAo4kwGtRyDOsyey3G8alJaHMwtG4U63+3NFRnJyXh7d+VrywEFqxH4sevZjdDi
         iYfuZXlLoG72Xg3EPxMlLJd1JRmqYrIqMN+1/toAZuzcMRbozseWNm+Na8Y7LCJNwR
         4u849ECR5M8tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 28/46] btrfs: add lockdep annotations for pending_ordered wait event
Date:   Tue, 11 Oct 2022 10:49:56 -0400
Message-Id: <20221011145015.1622882-28-sashal@kernel.org>
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

[ Upstream commit 8b53779eaa98b55f4cccadd4d12b3233e9633140 ]

In contrast to the num_writers and num_extwriters wait events, the
condition for the pending ordered wait event is signaled in a different
context from the wait event itself. The condition signaling occurs in
btrfs_remove_ordered_extent() in fs/btrfs/ordered-data.c while the wait
event is implemented in btrfs_commit_transaction() in
fs/btrfs/transaction.c

Thus the thread signaling the condition has to acquire the lockdep map
as a reader at the start of btrfs_remove_ordered_extent() and release it
after it has signaled the condition. In this case some dependencies
might be left out due to the placement of the annotation, but it is
better than no annotation at all.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h        | 1 +
 fs/btrfs/disk-io.c      | 1 +
 fs/btrfs/ordered-data.c | 3 +++
 fs/btrfs/transaction.c  | 1 +
 4 files changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f8172e269f03..8bd9a6d5ade6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1099,6 +1099,7 @@ struct btrfs_fs_info {
 	struct lockdep_map btrfs_trans_num_writers_map;
 	struct lockdep_map btrfs_trans_num_extwriters_map;
 	struct lockdep_map btrfs_state_change_map[4];
+	struct lockdep_map btrfs_trans_pending_ordered_map;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 68c6cb4e9283..393553fdfed6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2992,6 +2992,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_writers);
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_extwriters);
+	btrfs_lockdep_init_map(fs_info, btrfs_trans_pending_ordered);
 	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_commit_start,
 				     BTRFS_LOCKDEP_TRANS_COMMIT_START);
 	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_unblocked,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1952ac85222c..2a4cb6db42d1 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -525,6 +525,7 @@ void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
 	struct rb_node *node;
 	bool pending;
 
+	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
 	/* This is paired with btrfs_add_ordered_extent. */
 	spin_lock(&btrfs_inode->lock);
 	btrfs_mod_outstanding_extents(btrfs_inode, -1);
@@ -580,6 +581,8 @@ void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
 		}
 	}
 
+	btrfs_lockdep_release(fs_info, btrfs_trans_pending_ordered);
+
 	spin_lock(&root->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 	root->nr_ordered_extents--;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d3576f84020d..6e3b2cb6a04a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2310,6 +2310,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * transaction. Otherwise if this transaction commits before the ordered
 	 * extents complete we lose logged data after a power failure.
 	 */
+	btrfs_might_wait_for_event(fs_info, btrfs_trans_pending_ordered);
 	wait_event(cur_trans->pending_wait,
 		   atomic_read(&cur_trans->pending_ordered) == 0);
 
-- 
2.35.1

