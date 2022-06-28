Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E7455E19D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbiF1CXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243976AbiF1CWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BB82528C;
        Mon, 27 Jun 2022 19:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6542A617C4;
        Tue, 28 Jun 2022 02:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE81AC341CD;
        Tue, 28 Jun 2022 02:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382923;
        bh=39mQqdEYNICeu1z3BzFMggiTFKEliPD2oRwcgHuljhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NE7C4qlQNVho16VaxY1Ty5J6T2JrWT8wsDWRyKEGufSdYbkLGPdHsTUpmLi0plC40
         hmlueoStEry1Y0VqPnRACmLPsl4T+NQSpS4/s7qNnnUNoi1tVCxIjSyArH8io914nS
         8jpLYt1bNyWtn7oIznCJ2IMriRjRERM2+0un3W7p+060AyTfLYzulFChMSc7hhtgM0
         aJ7Sc7VxBo7/54CTD+w8r2rsxOjwqE0ZTfcTR1SpJ9JVbVJ83SPNYOfjNrjQSsWiMj
         +j4h44G2cD8YIjZaGTfA1H3i9Vpg062HLmqKiasBl1+5rwhePvbA7Ur4CygFG16HaH
         WzmBKLSfIIm/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/41] btrfs: add missing inode updates on each iteration when replacing extents
Date:   Mon, 27 Jun 2022 22:20:43 -0400
Message-Id: <20220628022100.595243-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
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
index 21c44846b002..bd665a123d5c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1290,6 +1290,8 @@ struct btrfs_replace_extent_info {
 	 * existing extent into a file range.
 	 */
 	bool is_new_extent;
+	/* Indicate if we should update the inode's mtime and ctime. */
+	bool update_times;
 	/* Meaningful only if is_new_extent is true. */
 	int qgroup_reserved;
 	/*
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ff578c934bbc..07ec05a810b4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2829,6 +2829,25 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
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
index 044d584c3467..9fd1d8fc0a53 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10260,6 +10260,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
 	extent_info.is_new_extent = true;
+	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
 	extent_info.insertions = 0;
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index fa60af00ebca..8545e8e812b7 100644
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

