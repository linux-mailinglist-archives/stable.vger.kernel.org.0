Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945E224DCB9
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHURHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgHUQSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:18:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E303A22CE3;
        Fri, 21 Aug 2020 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026676;
        bh=4Ip8e6mznvrSokDlCMttTqplUxZxiTzeDRZ75dPnUb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhIrbj+kbLQ8r96qDGs9tuzNvwSv4gBRQft2VvvPD5aL7WFuotQnfU6xZXxdCq3I6
         q0UP5HywKwbEO6fUF4Z3xMX37IEB+nEirWXLPmf/+3z7LjKMdp+xQMZ8UyKkPGtuSA
         DlfHayfw25tXXtQcCNv8gLynsC8z7SP6N+2ToiYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/48] btrfs: make btrfs_qgroup_check_reserved_leak take btrfs_inode
Date:   Fri, 21 Aug 2020 12:16:57 -0400
Message-Id: <20200821161704.348164-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit cfdd45921571eb24073e0737fa0bd44b4218f914 ]

vfs_inode is used only for the inode number everything else requires
btrfs_inode.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ use btrfs_ino ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c  |  2 +-
 fs/btrfs/qgroup.c | 14 +++++++-------
 fs/btrfs/qgroup.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e408181a5eba3..39cc1971d5f97 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9560,7 +9560,7 @@ void btrfs_destroy_inode(struct inode *inode)
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
-	btrfs_qgroup_check_reserved_leak(inode);
+	btrfs_qgroup_check_reserved_leak(BTRFS_I(inode));
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(BTRFS_I(inode), 0, (u64)-1, 0);
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b94f6f99e90d0..04fd02e6124dd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3769,7 +3769,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
  * Check qgroup reserved space leaking, normally at destroy inode
  * time
  */
-void btrfs_qgroup_check_reserved_leak(struct inode *inode)
+void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode)
 {
 	struct extent_changeset changeset;
 	struct ulist_node *unode;
@@ -3777,19 +3777,19 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 	int ret;
 
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
+	ret = clear_record_extent_bits(&inode->io_tree, 0, (u64)-1,
 			EXTENT_QGROUP_RESERVED, &changeset);
 
 	WARN_ON(ret < 0);
 	if (WARN_ON(changeset.bytes_changed)) {
 		ULIST_ITER_INIT(&iter);
 		while ((unode = ulist_next(&changeset.range_changed, &iter))) {
-			btrfs_warn(BTRFS_I(inode)->root->fs_info,
-				"leaking qgroup reserved space, ino: %lu, start: %llu, end: %llu",
-				inode->i_ino, unode->val, unode->aux);
+			btrfs_warn(inode->root->fs_info,
+		"leaking qgroup reserved space, ino: %llu, start: %llu, end: %llu",
+				btrfs_ino(inode), unode->val, unode->aux);
 		}
-		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
-				BTRFS_I(inode)->root->root_key.objectid,
+		btrfs_qgroup_free_refroot(inode->root->fs_info,
+				inode->root->root_key.objectid,
 				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
 
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 17e8ac992c502..b0420c4f5d0ef 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -399,7 +399,7 @@ void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root);
  */
 void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
 
-void btrfs_qgroup_check_reserved_leak(struct inode *inode);
+void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode);
 
 /* btrfs_qgroup_swapped_blocks related functions */
 void btrfs_qgroup_init_swapped_blocks(
-- 
2.25.1

