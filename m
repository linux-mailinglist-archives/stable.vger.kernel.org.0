Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277D3D9257
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389550AbfJPNWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:22:08 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59651 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729306AbfJPNWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:22:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E239E21B2B;
        Wed, 16 Oct 2019 09:22:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Z5L/8h
        wG6Qg7JOb8d1rlf7+hr5xE3vg+sCR8mdVQA+A=; b=O2RTFuu0Uglv6sbK9J5lV9
        fdeml5A+NcluyUZ660t0XgrrmFobkzg2CyW4m5fXpDuJ++OlqvSm//tyzsMG+jsU
        9MjcZmQT4XGiOzXK9OQhL2P6HzJpLZTAUN6MdwISiKCbHLheTb6cI+DM2dhjXXDH
        x7INFyOaqdephlzXbdSHTBF2jEQdI/dtojAaIw1Y8z0xeGJkzSjlkp6Hf/XpnibP
        jovzH6QTK48T8ifJH4A532DAS3ca30YHhtS8ilQZpfQ2NejKJjlepjoV4E7mFuGj
        tlZO34P6GkhjhLGBNq9CJKYIRD5HJWUuNxULEbmCmgeskcJx5G1+8YlPLe7+d8fg
        ==
X-ME-Sender: <xms:fxmnXaL47wW3-SqxkXiutw-PMYsPtWalTJp0NLtTbplz4FzRugeqJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrudefiedrvdefiedrleegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:fxmnXWZeC3PbL1halhNFZY9jjfpmR_oZmXRHoRzYds2byJ8ngWAPIg>
    <xmx:fxmnXVvCWW5dIeboWCPn4tuMQXJtEWGc7G0mphRrUOd0rmVgreuBQQ>
    <xmx:fxmnXTuMuMVe2fnSVTXeaHgJMpDOLkzHRxmMI1UUROYNlhyld6HG8w>
    <xmx:fxmnXZqy5mLAfZ_AG1Izh8Z2bJJ8DCvhsfvptvyGZnPEUItWs4g3RQ>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67B46D6005B;
        Wed, 16 Oct 2019 09:22:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix incorrect updating of log root tree" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, clm@fb.com, dsterba@suse.com,
        fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 06:22:06 -0700
Message-ID: <157123212650198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4203e968947071586a98b5314fd7ffdea3b4f971 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 30 Sep 2019 16:27:25 -0400
Subject: [PATCH] btrfs: fix incorrect updating of log root tree

We've historically had reports of being unable to mount file systems
because the tree log root couldn't be read.  Usually this is the "parent
transid failure", but could be any of the related errors, including
"fsid mismatch" or "bad tree block", depending on which block got
allocated.

The modification of the individual log root items are serialized on the
per-log root root_mutex.  This means that any modification to the
per-subvol log root_item is completely protected.

However we update the root item in the log root tree outside of the log
root tree log_mutex.  We do this in order to allow multiple subvolumes
to be updated in each log transaction.

This is problematic however because when we are writing the log root
tree out we update the super block with the _current_ log root node
information.  Since these two operations happen independently of each
other, you can end up updating the log root tree in between writing out
the dirty blocks and setting the super block to point at the current
root.

This means we'll point at the new root node that hasn't been written
out, instead of the one we should be pointing at.  Thus whatever garbage
or old block we end up pointing at complains when we mount the file
system later and try to replay the log.

Fix this by copying the log's root item into a local root item copy.
Then once we're safely under the log_root_tree->log_mutex we update the
root item in the log_root_tree.  This way we do not modify the
log_root_tree while we're committing it, fixing the problem.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Chris Mason <clm@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 77b6797fcac3..2488eb4b70fc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2932,7 +2932,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
  * in the tree of log roots
  */
 static int update_log_root(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *log)
+			   struct btrfs_root *log,
+			   struct btrfs_root_item *root_item)
 {
 	struct btrfs_fs_info *fs_info = log->fs_info;
 	int ret;
@@ -2940,10 +2941,10 @@ static int update_log_root(struct btrfs_trans_handle *trans,
 	if (log->log_transid == 1) {
 		/* insert root item on the first sync */
 		ret = btrfs_insert_root(trans, fs_info->log_root_tree,
-				&log->root_key, &log->root_item);
+				&log->root_key, root_item);
 	} else {
 		ret = btrfs_update_root(trans, fs_info->log_root_tree,
-				&log->root_key, &log->root_item);
+				&log->root_key, root_item);
 	}
 	return ret;
 }
@@ -3041,6 +3042,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
+	struct btrfs_root_item new_root_item;
 	int log_transid = 0;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
@@ -3104,17 +3106,25 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	/*
+	 * We _must_ update under the root->log_mutex in order to make sure we
+	 * have a consistent view of the log root we are trying to commit at
+	 * this moment.
+	 *
+	 * We _must_ copy this into a local copy, because we are not holding the
+	 * log_root_tree->log_mutex yet.  This is important because when we
+	 * commit the log_root_tree we must have a consistent view of the
+	 * log_root_tree when we update the super block to point at the
+	 * log_root_tree bytenr.  If we update the log_root_tree here we'll race
+	 * with the commit and possibly point at the new block which we may not
+	 * have written out.
+	 */
 	btrfs_set_root_node(&log->root_item, log->node);
+	memcpy(&new_root_item, &log->root_item, sizeof(new_root_item));
 
 	root->log_transid++;
 	log->log_transid = root->log_transid;
 	root->log_start_pid = 0;
-	/*
-	 * Update or create log root item under the root's log_mutex to prevent
-	 * races with concurrent log syncs that can lead to failure to update
-	 * log root item because it was not created yet.
-	 */
-	ret = update_log_root(trans, log);
 	/*
 	 * IO has been started, blocks of the log tree have WRITTEN flag set
 	 * in their headers. new modifications of the log will be written to
@@ -3135,6 +3145,14 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	mutex_lock(&log_root_tree->log_mutex);
+
+	/*
+	 * Now we are safe to update the log_root_tree because we're under the
+	 * log_mutex, and we're a current writer so we're holding the commit
+	 * open until we drop the log_mutex.
+	 */
+	ret = update_log_root(trans, log, &new_root_item);
+
 	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
 		/* atomic_dec_and_test implies a barrier */
 		cond_wake_up_nomb(&log_root_tree->log_writer_wait);

