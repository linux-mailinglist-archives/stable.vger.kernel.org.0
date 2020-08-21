Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2594F24DDE9
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgHURX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgHUQPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D016022B40;
        Fri, 21 Aug 2020 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026531;
        bh=eRrwXSxeTs840s39vCPAEof4ZeUFt1wv1CS6+1RMabc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qn7DV+seYZkb/LsnRmkI6Kw1YPTVPf9kRs+lp6yC61UjDJUD9AmLRFra6tm/v6+eI
         FYtp+ZK1GWHSdRftpXmdefh583hE2PQzzZBs6VsJ7KwUAo0tA+zWMHIDmUumQxbGxb
         6t0o5mtrsdiQIb+26aVZdzkMsaGp39gEiQyVxCSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 53/62] btrfs: make btrfs_qgroup_check_reserved_leak take btrfs_inode
Date:   Fri, 21 Aug 2020 12:14:14 -0400
Message-Id: <20200821161423.347071-53-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
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
index 3f77ec5de8ec7..0a07e0aea7f0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8632,7 +8632,7 @@ void btrfs_destroy_inode(struct inode *inode)
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

