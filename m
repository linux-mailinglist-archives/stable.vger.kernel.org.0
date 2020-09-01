Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51225946C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgIAPjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbgIAPje (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3238221582;
        Tue,  1 Sep 2020 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974773;
        bh=vcsLtRlmQDLhSf0waVJGVw8YjZj3t5CkOONNkB6ufRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVCIZKnpgJ3kJJ7fO2CVwzoOpjybX7O2grplXcU/sBlNFN6UE2IlJTwI4ff82DsTZ
         HYhBv9cqrwgDYa4o7yp+8WVWM+7ohe5JV+VRM4UxyZWJbr2vGVfrifCvNWSK8lISdV
         YPRK8pQvDnTeiH9LqhcU6zK92jVGrMi/eLf945Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 055/255] btrfs: make btrfs_qgroup_check_reserved_leak take btrfs_inode
Date:   Tue,  1 Sep 2020 17:08:31 +0200
Message-Id: <20200901151003.362523900@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7ba1218b1630e..d932844d0e80a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8640,7 +8640,7 @@ void btrfs_destroy_inode(struct inode *inode)
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
-	btrfs_qgroup_check_reserved_leak(inode);
+	btrfs_qgroup_check_reserved_leak(BTRFS_I(inode));
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(BTRFS_I(inode), 0, (u64)-1, 0);
 	btrfs_inode_clear_file_extent_range(BTRFS_I(inode), 0, (u64)-1);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5bd4089ad0e1a..574a669894774 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3742,7 +3742,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
  * Check qgroup reserved space leaking, normally at destroy inode
  * time
  */
-void btrfs_qgroup_check_reserved_leak(struct inode *inode)
+void btrfs_qgroup_check_reserved_leak(struct btrfs_inode *inode)
 {
 	struct extent_changeset changeset;
 	struct ulist_node *unode;
@@ -3750,19 +3750,19 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
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
index 1bc6544594690..406366f20cb0a 100644
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



