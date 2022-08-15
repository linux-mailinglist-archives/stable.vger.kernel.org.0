Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8CB594DC4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbiHPAxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347674AbiHPAvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:51:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96009DA3F3;
        Mon, 15 Aug 2022 13:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B734B60F60;
        Mon, 15 Aug 2022 20:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4976C433D6;
        Mon, 15 Aug 2022 20:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596440;
        bh=AXxqXUKNIERoCew8Y87JYI1nbz3dGpMZarK68vSCs0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsbZyJuPzwufhfY81tRvCHpBt+0oSgNFsdH69FOkSgkOfs2YGzdRJuqShLhUSaZnq
         w7QfTwJsfgHGrbq7FqZufBPyoyeK/0dWv440xFWHs3XSA6gsgjQFwGFs7G5JiEjfDo
         mID/WDhjlutGlaDf3viTcroZ4NiDE7TwjCXhgK8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1079/1157] btrfs: tree-log: make the return value for log syncing consistent
Date:   Mon, 15 Aug 2022 20:07:15 +0200
Message-Id: <20220815180523.311733735@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f31f09f6be1c6c1a673e0566e258281a7bbaaa51 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c     |  2 +-
 fs/btrfs/tree-log.c | 18 +++++++++---------
 fs/btrfs/tree-log.h |  3 +++
 3 files changed, 13 insertions(+), 10 deletions(-)

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
index 370388fadf96..c94713c811bb 100644
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
-- 
2.35.1



