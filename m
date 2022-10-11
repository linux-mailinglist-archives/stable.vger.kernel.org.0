Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0989F5FB5DC
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiJKPAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiJKO5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:57:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286456C132;
        Tue, 11 Oct 2022 07:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70BCAB8124C;
        Tue, 11 Oct 2022 14:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5844AC43144;
        Tue, 11 Oct 2022 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499941;
        bh=01ACih7RDRoJVsPEoE2qtPSXDZdNEOzvssyyJNaROlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1yx3042DQxvKfREsllsx938aN+rJTX3Wo0tGOOjwA1yTw9XEkh/gvUtts4O9tsLx
         ksYvyQT5+zigUFoh7/mjpcCnJWox5/QeZxgYPgk/+tp6yafm7FMhlZpAyQkBw7mmyd
         EcXJqzfex1mGsCnMovU4O8NaRVftzz5O1J3nwztmK0OHr2a3OTmIEQ6Dybl8QwhwTs
         347ceiMkD5+8jlqn9/s/+DPyWi5Dc6/R8OHN9VIts1G280QxHTIrzfcMl1lWinbAgn
         5mGMfWZTgF0UqhonfBkiSUHOJUfhPpUq0GK9WAPqRYmDPliYCM7mDt62GwEvqJ2Bg+
         u5wlw+IwuR7kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 33/40] btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN
Date:   Tue, 11 Oct 2022 10:51:22 -0400
Message-Id: <20221011145129.1623487-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e562a8bdf652b010ce2525bcf15d145c9d3932bf ]

Introduce a new runtime flag, BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN,
which will inform qgroup rescan to cancel its work asynchronously.

This is to address the window when an operation makes qgroup numbers
inconsistent (like qgroup inheriting) while a qgroup rescan is running.

In that case, qgroup inconsistent flag will be cleared when qgroup
rescan finishes.
But we changed the ownership of some extents, which means the rescan is
already meaningless, and the qgroup inconsistent flag should not be
cleared.

With the new flag, each time we set INCONSISTENT flag, we also set this
new flag to inform any running qgroup rescan to exit immediately, and
leaving the INCONSISTENT flag there.

The new runtime flag can only be cleared when a new rescan is started.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 43 ++++++++++++++++++++++++++-----------------
 fs/btrfs/qgroup.h |  2 ++
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index db723c0026bd..8e7b188d1dc1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -333,6 +333,12 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 }
 #endif
 
+static void qgroup_mark_inconsistent(struct btrfs_fs_info *fs_info)
+{
+	fs_info->qgroup_flags |= (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
+				  BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN);
+}
+
 /*
  * The full config is read in one go, only called from open_ctree()
  * It doesn't use any locking, as at this point we're still single-threaded
@@ -401,7 +407,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			}
 			if (btrfs_qgroup_status_generation(l, ptr) !=
 			    fs_info->generation) {
-				flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+				qgroup_mark_inconsistent(fs_info);
 				btrfs_err(fs_info,
 					"qgroup generation mismatch, marked as inconsistent");
 			}
@@ -419,7 +425,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 		if ((qgroup && found_key.type == BTRFS_QGROUP_INFO_KEY) ||
 		    (!qgroup && found_key.type == BTRFS_QGROUP_LIMIT_KEY)) {
 			btrfs_err(fs_info, "inconsistent qgroup config");
-			flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			qgroup_mark_inconsistent(fs_info);
 		}
 		if (!qgroup) {
 			qgroup = add_qgroup_rb(fs_info, found_key.offset);
@@ -1717,7 +1723,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid,
 
 	ret = update_qgroup_limit_item(trans, qgroup);
 	if (ret) {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 		btrfs_info(fs_info, "unable to update quota limit for %llu",
 		       qgroupid);
 	}
@@ -1793,7 +1799,7 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_trans_handle *trans,
 	ret = btrfs_find_all_roots(NULL, trans->fs_info, bytenr, 0, &old_root,
 				   true);
 	if (ret < 0) {
-		trans->fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(trans->fs_info);
 		btrfs_warn(trans->fs_info,
 "error accounting new delayed refs extent (err code: %d), quota inconsistent",
 			ret);
@@ -2269,7 +2275,7 @@ static int qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(dst_path);
 	if (ret < 0)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 	return ret;
 }
 
@@ -2773,12 +2779,10 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 		spin_unlock(&fs_info->qgroup_lock);
 		ret = update_qgroup_info_item(trans, qgroup);
 		if (ret)
-			fs_info->qgroup_flags |=
-					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			qgroup_mark_inconsistent(fs_info);
 		ret = update_qgroup_limit_item(trans, qgroup);
 		if (ret)
-			fs_info->qgroup_flags |=
-					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			qgroup_mark_inconsistent(fs_info);
 		spin_lock(&fs_info->qgroup_lock);
 	}
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
@@ -2789,7 +2793,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 
 	ret = update_qgroup_status_item(trans);
 	if (ret)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 
 	return ret;
 }
@@ -2907,7 +2911,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 
 		ret = update_qgroup_limit_item(trans, dstgroup);
 		if (ret) {
-			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			qgroup_mark_inconsistent(fs_info);
 			btrfs_info(fs_info,
 				   "unable to update quota limit for %llu",
 				   dstgroup->qgroupid);
@@ -3013,7 +3017,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	if (!committing)
 		mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (need_rescan)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 	return ret;
 }
 
@@ -3286,7 +3290,8 @@ static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	return btrfs_fs_closing(fs_info) ||
 		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state) ||
-		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
+		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
+			  fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN;
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
@@ -3351,7 +3356,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	if (!stopped)
+	if (!stopped ||
+	    fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN)
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 	if (trans) {
 		ret = update_qgroup_status_item(trans);
@@ -3362,6 +3368,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 	}
 	fs_info->qgroup_rescan_running = false;
+	fs_info->qgroup_flags &= ~BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN;
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
@@ -3372,6 +3379,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
+	} else if (fs_info->qgroup_flags & BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN) {
+		btrfs_info(fs_info, "qgroup scan cancelled");
 	} else if (err >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			err > 0 ? " (inconsistency flag cleared)" : "");
@@ -3434,6 +3443,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	memset(&fs_info->qgroup_rescan_progress, 0,
 		sizeof(fs_info->qgroup_rescan_progress));
+	fs_info->qgroup_flags &= ~BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN;
 	fs_info->qgroup_rescan_progress.objectid = progress_objectid;
 	init_completion(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
@@ -4231,8 +4241,7 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
 	spin_unlock(&blocks->lock);
 out:
 	if (ret < 0)
-		fs_info->qgroup_flags |=
-			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 	return ret;
 }
 
@@ -4319,7 +4328,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 		btrfs_err_rl(fs_info,
 			     "failed to account subtree at bytenr %llu: %d",
 			     subvol_eb->start, ret);
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		qgroup_mark_inconsistent(fs_info);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 0c4dd2a9af96..90d3632c5524 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -100,6 +100,8 @@
  *     subtree rescan for them.
  */
 
+#define BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN		(1UL << 3)
+
 /*
  * Record a dirty extent, and info qgroup to update quota on it
  * TODO: Use kmem cache to alloc it.
-- 
2.35.1

