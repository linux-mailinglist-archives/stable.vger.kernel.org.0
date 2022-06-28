Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5CA55DE1A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243480AbiF1CVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243587AbiF1CUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFCB24BE7;
        Mon, 27 Jun 2022 19:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF32EB818E4;
        Tue, 28 Jun 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68968C341CB;
        Tue, 28 Jun 2022 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382816;
        bh=K9ia8O3vm2iIwML8IcB1DpRQglcVE9/U1gPMqOenZkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sf4xfPS4+gGAmr6ObiuOBzKOIK6mJjDRKDGj0x6h6T6bmrUGaSVQyhdhgPkp/DqvO
         5boJz7RGZmzZYLTbc/XpE+lSIuWx5XzDW80rhCB1ZYcWhyaco/GNa9ak+jIHE7H3xY
         +wizDAkclocbCDDDY6Uicu6SVuE65I3eys/DynjaE9PRFiX++ynypejveJ9O347gTx
         Bw9zkaJzRXn1m8GcxazyHTZfXJ3AVS5xjvv/9yYRutiTqUiu57iiT1x+iO21+9Yf2k
         eK1DPBOPAXCHub2oKX7b8ASj96CNgXs1tV13SUoeVxrFBNq+HN/4DV2fv79LBbHInK
         /bxhg1FfNEnfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 35/53] btrfs: add missing inode updates on each iteration when replacing extents
Date:   Mon, 27 Jun 2022 22:18:21 -0400
Message-Id: <20220628021839.594423-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 983d8209c6803345c9958f4cc358d1155f93a099 ]

When replacing file extents, called during fallocate, hole punching,
clone and deduplication, we may not be able to replace/drop all the
target file extent items with a single transaction handle. We may get
-ENOSPC while doing it, in which case we release the transaction handle,
balance the dirty pages of the btree inode, flush delayed items and get
a new transaction handle to operate on what's left of the target range.

By dropping and replacing file extent items we have effectively modified
the inode, so we should bump its iversion and update its mtime/ctime
before we update the inode item. This is because if the transaction
we used for partially modifying the inode gets committed by someone after
we release it and before we finish the rest of the range, a power failure
happens, then after mounting the filesystem our inode has an outdated
iversion and mtime/ctime, corresponding to the values it had before we
changed it.

So add the missing iversion and mtime/ctime updates.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/file.c    | 19 +++++++++++++++++++
 fs/btrfs/inode.c   |  1 +
 fs/btrfs/reflink.c |  1 +
 4 files changed, 23 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 077c95e9baa5..fd831047994f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1331,6 +1331,8 @@ struct btrfs_replace_extent_info {
 	 * existing extent into a file range.
 	 */
 	bool is_new_extent;
+	/* Indicate if we should update the inode's mtime and ctime. */
+	bool update_times;
 	/* Meaningful only if is_new_extent is true. */
 	int qgroup_reserved;
 	/*
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 380054c94e4b..ab882ddfb0e8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2850,6 +2850,25 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 			extent_info->file_offset += replace_len;
 		}
 
+		/*
+		 * We are releasing our handle on the transaction, balance the
+		 * dirty pages of the btree inode and flush delayed items, and
+		 * then get a new transaction handle, which may now point to a
+		 * new transaction in case someone else may have committed the
+		 * transaction we used to replace/drop file extent items. So
+		 * bump the inode's iversion and update mtime and ctime except
+		 * if we are called from a dedupe context. This is because a
+		 * power failure/crash may happen after the transaction is
+		 * committed and before we finish replacing/dropping all the
+		 * file extent items we need.
+		 */
+		inode_inc_iversion(&inode->vfs_inode);
+
+		if (!extent_info || extent_info->update_times) {
+			inode->vfs_inode.i_mtime = current_time(&inode->vfs_inode);
+			inode->vfs_inode.i_ctime = inode->vfs_inode.i_mtime;
+		}
+
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret)
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 861b9748a0d9..acd0604aced9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9916,6 +9916,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
 	extent_info.is_new_extent = true;
+	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
 	extent_info.insertions = 0;
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 998e3f180d90..79ea8353994e 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -489,6 +489,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
 			clone_info.is_new_extent = false;
+			clone_info.update_times = !no_time_update;
 			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
 					drop_start, new_key.offset + datal - 1,
 					&clone_info, &trans);
-- 
2.35.1

