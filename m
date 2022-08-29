Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902275A47E6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiH2LCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiH2LCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4BF3AB38;
        Mon, 29 Aug 2022 04:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6995C61132;
        Mon, 29 Aug 2022 11:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E0FC433C1;
        Mon, 29 Aug 2022 11:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770919;
        bh=JFszvvfNIEW/xserBuvtdDUlhOD02mgyujNkLisWBDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsNj85ylZOjGnwfPnJ8yDFwKdu5qoLcqImVJkuvPSwfRXc3hAfqF79e0CxyDfFBwX
         L81XQAtL/SvOXH9Vte6jiMSbNogUSxzSo1+eO1j8oVb3FXlrpr4k28R6qxt9BqCYBr
         8Gp5VJzVy7OnMFYd6UhPlAeNeJLO1MVGNj+Yqm7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/136] btrfs: pass the dentry to btrfs_log_new_name() instead of the inode
Date:   Mon, 29 Aug 2022 12:58:09 +0200
Message-Id: <20220829105805.495470085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d5f5bd546552a94eefd68c42f40f778c40a89d2c ]

In the next patch in the series, there will be the need to access the old
name, and its length, of an inode when logging the inode during a rename.
So instead of passing the inode to btrfs_log_new_name() pass the dentry,
because from the dentry we can get the inode, the name and its length.

This will avoid passing 3 new parameters to btrfs_log_new_name() in the
next patch - the name, its length and an index number. This way we end
up passing only 1 new parameter, the index number.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c    |  8 ++++----
 fs/btrfs/tree-log.c | 19 +++++++++++++++----
 fs/btrfs/tree-log.h |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 26a4acb856a38..428a56f248bba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6952,7 +6952,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 				goto fail;
 		}
 		d_instantiate(dentry, inode);
-		btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent);
+		btrfs_log_new_name(trans, old_dentry, NULL, parent);
 	}
 
 fail:
@@ -9621,13 +9621,13 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		BTRFS_I(new_inode)->dir_index = new_idx;
 
 	if (root_log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir),
+		btrfs_log_new_name(trans, old_dentry, BTRFS_I(old_dir),
 				   new_dentry->d_parent);
 		btrfs_end_log_trans(root);
 		root_log_pinned = false;
 	}
 	if (dest_log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(new_inode), BTRFS_I(new_dir),
+		btrfs_log_new_name(trans, new_dentry, BTRFS_I(new_dir),
 				   old_dentry->d_parent);
 		btrfs_end_log_trans(dest);
 		dest_log_pinned = false;
@@ -9908,7 +9908,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		BTRFS_I(old_inode)->dir_index = index;
 
 	if (log_pinned) {
-		btrfs_log_new_name(trans, BTRFS_I(old_inode), BTRFS_I(old_dir),
+		btrfs_log_new_name(trans, old_dentry, BTRFS_I(old_dir),
 				   new_dentry->d_parent);
 		btrfs_end_log_trans(root);
 		log_pinned = false;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e9e1aae89030a..1d7e9812f55e1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6628,14 +6628,25 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 	mutex_unlock(&dir->log_mutex);
 }
 
-/*
- * Call this after adding a new name for a file and it will properly
- * update the log to reflect the new name.
+/**
+ * Update the log after adding a new name for an inode.
+ *
+ * @trans:              Transaction handle.
+ * @old_dentry:         The dentry associated with the old name and the old
+ *                      parent directory.
+ * @old_dir:            The inode of the previous parent directory for the case
+ *                      of a rename. For a link operation, it must be NULL.
+ * @parent:             The dentry associated with the directory under which the
+ *                      new name is located.
+ *
+ * Call this after adding a new name for an inode, as a result of a link or
+ * rename operation, and it will properly update the log to reflect the new name.
  */
 void btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
+			struct dentry *old_dentry, struct btrfs_inode *old_dir,
 			struct dentry *parent)
 {
+	struct btrfs_inode *inode = BTRFS_I(d_inode(old_dentry));
 	struct btrfs_log_ctx ctx;
 
 	/*
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 731bd9c029f55..7ffcac8a89905 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -84,7 +84,7 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode *dir);
 void btrfs_log_new_name(struct btrfs_trans_handle *trans,
-			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
+			struct dentry *old_dentry, struct btrfs_inode *old_dir,
 			struct dentry *parent);
 
 #endif
-- 
2.35.1



