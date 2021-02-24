Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A90323D01
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhBXNBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235402AbhBXMzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD5864F27;
        Wed, 24 Feb 2021 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171100;
        bh=rzJ+MgPneSw4WzQ5AVOBAiFhwQBZg63ogCP4HtzvObA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3SM4uWgUZP7yKsVkb0PvfICowwoWKOkTLbU7C6ehkr29eeAF5N7ucS6GyHRwC08r
         r2VixzX7JXaIA+RQdqkreLOXssjz8Z57HATG+TiEF0bv4TkI8AbFrU4IpEKt2wTcI9
         hF+ti+iS4T8WFNZZw8N1tvXevE1Vddbl64HuBksjJL9IgH8lkDUpQ71WSw6pBmKA5h
         v6LrNhS6zU69Hbl0zaepVy/3y9omVM361ytr9+Lf9Sk0Xj9fHFyw29SBM9j5VnC0U5
         AKJCrwE/bhHYBAx6thkpAYlLMofnTrpifFEUniuyPZLLkbl50NMzzN7eZI98/xRu54
         hnaWPgnxN8b5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 55/67] btrfs: only let one thread pre-flush delayed refs in commit
Date:   Wed, 24 Feb 2021 07:50:13 -0500
Message-Id: <20210224125026.481804-55-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e19eb11f4f3d3b0463cd897016064a79cb6d8c6d ]

I've been running a stress test that runs 20 workers in their own
subvolume, which are running an fsstress instance with 4 threads per
worker, which is 80 total fsstress threads.  In addition to this I'm
running balance in the background as well as creating and deleting
snapshots.  This test takes around 12 hours to run normally, going
slower and slower as the test goes on.

The reason for this is because fsstress is running fsync sometimes, and
because we're messing with block groups we often fall through to
btrfs_commit_transaction, so will often have 20-30 threads all calling
btrfs_commit_transaction at the same time.

These all get stuck contending on the extent tree while they try to run
delayed refs during the initial part of the commit.

This is suboptimal, really because the extent tree is a single point of
failure we only want one thread acting on that tree at once to reduce
lock contention.

Fix this by making the flushing mechanism a bit operation, to make it
easy to use test_and_set_bit() in order to make sure only one task does
this initial flush.

Once we're into the transaction commit we only have one thread doing
delayed ref running, it's just this initial pre-flush that is
problematic.  With this patch my stress test takes around 90 minutes to
run, instead of 12 hours.

The memory barrier is not necessary for the flushing bit as it's
ordered, unlike plain int. The transaction state accessed in
btrfs_should_end_transaction could be affected by that too as it's not
always used under transaction lock. Upon Nikolay's analysis in [1]
it's not necessary:

  In should_end_transaction it's read without holding any locks. (U)

  It's modified in btrfs_cleanup_transaction without holding the
  fs_info->trans_lock (U), but the STATE_ERROR flag is going to be set.

  set in cleanup_transaction under fs_info->trans_lock (L)
  set in btrfs_commit_trans to COMMIT_START under fs_info->trans_lock.(L)
  set in btrfs_commit_trans to COMMIT_DOING under fs_info->trans_lock.(L)
  set in btrfs_commit_trans to COMMIT_UNBLOCK under
  fs_info->trans_lock.(L)

  set in btrfs_commit_trans to COMMIT_COMPLETED without locks but at this
  point the transaction is finished and fs_info->running_trans is NULL (U
  but irrelevant).

  So by the looks of it we can have a concurrent READ race with a WRITE,
  due to reads not taking a lock. In this case what we want to ensure is
  we either see new or old state. I consulted with Will Deacon and he said
  that in such a case we'd want to annotate the accesses to ->state with
  (READ|WRITE)_ONCE so as to avoid a theoretical tear, in this case I
  don't think this could happen but I imagine at some point KCSAN would
  flag such an access as racy (which it is).

[1] https://lore.kernel.org/linux-btrfs/e1fd5cc1-0f28-f670-69f4-e9958b4964e6@suse.com

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ add comments regarding memory barrier ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.h | 12 ++++++------
 fs/btrfs/transaction.c | 32 +++++++++++++++-----------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 1c977e6d45dc3..52364ea322d67 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -135,6 +135,11 @@ struct btrfs_delayed_data_ref {
 	u64 offset;
 };
 
+enum btrfs_delayed_ref_flags {
+	/* Indicate that we are flushing delayed refs for the commit */
+	BTRFS_DELAYED_REFS_FLUSHING,
+};
+
 struct btrfs_delayed_ref_root {
 	/* head ref rbtree */
 	struct rb_root_cached href_root;
@@ -158,12 +163,7 @@ struct btrfs_delayed_ref_root {
 
 	u64 pending_csums;
 
-	/*
-	 * set when the tree is flushing before a transaction commit,
-	 * used by the throttling code to decide if new updates need
-	 * to be run right away
-	 */
-	int flushing;
+	unsigned long flags;
 
 	u64 run_delayed_start;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fbf93067642ac..3cced84752178 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -909,9 +909,8 @@ bool btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 
-	smp_mb();
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
-	    cur_trans->delayed_refs.flushing)
+	    test_bit(BTRFS_DELAYED_REFS_FLUSHING, &cur_trans->delayed_refs.flags))
 		return true;
 
 	return should_end_transaction(trans);
@@ -2043,23 +2042,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
-	/* make a pass through all the delayed refs we have so far
-	 * any runnings procs may add more while we are here
-	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
-	if (ret) {
-		btrfs_end_transaction(trans);
-		return ret;
-	}
-
-	cur_trans = trans->transaction;
-
 	/*
-	 * set the flushing flag so procs in this transaction have to
-	 * start sending their work down.
+	 * We only want one transaction commit doing the flushing so we do not
+	 * waste a bunch of time on lock contention on the extent root node.
 	 */
-	cur_trans->delayed_refs.flushing = 1;
-	smp_wmb();
+	if (!test_and_set_bit(BTRFS_DELAYED_REFS_FLUSHING,
+			      &cur_trans->delayed_refs.flags)) {
+		/*
+		 * Make a pass through all the delayed refs we have so far.
+		 * Any running threads may add more while we are here.
+		 */
+		ret = btrfs_run_delayed_refs(trans, 0);
+		if (ret) {
+			btrfs_end_transaction(trans);
+			return ret;
+		}
+	}
 
 	btrfs_create_pending_block_groups(trans);
 
-- 
2.27.0

