Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1704A592DF4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiHOLOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiHOLOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:14:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36044183B5
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B023CE0FAA
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E13BC433C1;
        Mon, 15 Aug 2022 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562049;
        bh=GDtSsPErCPfpvadUFuGHVGHxKhBcI7hV1/XdTjlAeE8=;
        h=Subject:To:Cc:From:Date:From;
        b=Annx2HaT3FXJbnhVQ5Mar3fTtA+RqUZKtwwjvE6aYxFROWd9+fs67PBz9n8ltx6Ze
         WHtUNO/SZRco3NsWYmPc+e3EZYHzL67gm6yDx9wkKqy3gm2hQjuc1YfxtqjKeD1SI3
         UbYPrnRHQLtFXp8RcRtxHU9jufxzwGWBpCtjXsxE=
Subject: FAILED: patch "[PATCH] btrfs: tree-log: make the return value for log syncing" failed to apply to 5.15-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:13:59 +0200
Message-ID: <166056203982219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f31f09f6be1c6c1a673e0566e258281a7bbaaa51 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 13 Jun 2022 15:09:48 -0400
Subject: [PATCH] btrfs: tree-log: make the return value for log syncing
 consistent

Currently we will return 1 or -EAGAIN if we decide we need to commit
the transaction rather than sync the log.  In practice this doesn't
really matter, we interpret any !0 and !BTRFS_NO_LOG_SYNC as needing to
commit the transaction.  However this makes it hard to figure out what
the correct thing to do is.

Fix this up by defining BTRFS_LOG_FORCE_COMMIT and using this in all the
places where we want to force the transaction to be committed.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9dfde1af8a64..89c6d7ff1987 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2308,7 +2308,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	btrfs_release_log_ctx_extents(&ctx);
 	if (ret < 0) {
 		/* Fallthrough and commit/free transaction. */
-		ret = 1;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 	}
 
 	/* we've logged all the items and now have a consistent
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1201f083d4db..d898ba13285f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -171,7 +171,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		int index = (root->log_transid + 1) % 2;
 
 		if (btrfs_need_log_full_commit(trans)) {
-			ret = -EAGAIN;
+			ret = BTRFS_LOG_FORCE_COMMIT;
 			goto out;
 		}
 
@@ -194,7 +194,7 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
 		 * writing.
 		 */
 		if (zoned && !created) {
-			ret = -EAGAIN;
+			ret = BTRFS_LOG_FORCE_COMMIT;
 			goto out;
 		}
 
@@ -3121,7 +3121,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	/* bail out if we need to do a full commit */
 	if (btrfs_need_log_full_commit(trans)) {
-		ret = -EAGAIN;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		mutex_unlock(&root->log_mutex);
 		goto out;
 	}
@@ -3222,7 +3222,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		}
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = -EAGAIN;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto out;
 	}
 
@@ -3261,7 +3261,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		blk_finish_plug(&plug);
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = -EAGAIN;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto out_wake_log_root;
 	}
 
@@ -5848,7 +5848,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	    inode_only == LOG_INODE_ALL &&
 	    inode->last_unlink_trans >= trans->transid) {
 		btrfs_set_log_full_commit(trans);
-		ret = 1;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto out_unlock;
 	}
 
@@ -6562,12 +6562,12 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	bool log_dentries = false;
 
 	if (btrfs_test_opt(fs_info, NOTREELOG)) {
-		ret = 1;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto end_no_trans;
 	}
 
 	if (btrfs_root_refs(&root->root_item) == 0) {
-		ret = 1;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto end_no_trans;
 	}
 
@@ -6665,7 +6665,7 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 end_trans:
 	if (ret < 0) {
 		btrfs_set_log_full_commit(trans);
-		ret = 1;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 	}
 
 	if (ret)
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 1620f8170629..57ab5f3b8dc7 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -12,6 +12,9 @@
 /* return value for btrfs_log_dentry_safe that means we don't need to log it at all */
 #define BTRFS_NO_LOG_SYNC 256
 
+/* We can't use the tree log for whatever reason, force a transaction commit */
+#define BTRFS_LOG_FORCE_COMMIT				(1)
+
 struct btrfs_log_ctx {
 	int log_ret;
 	int log_transid;

