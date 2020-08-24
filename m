Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C28A24F86F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgHXIuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgHXIuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B00207D3;
        Mon, 24 Aug 2020 08:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259002;
        bh=zKQ8ZtWYpiM4WvCVnO7PZSUwlvnZhnWf8oE8kLvil2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qj8YaQTjSrNrnv3fhi5zYT4DWd1eoEvAsrGqA8CDq2sKGrB1nAF8pz9apUmtolR6w
         690vRqdOom6wuJi+YMlC6moQ7IZ+o0vUheT9pbnCeiZb0BZZo2u6k6yRHTDsQx/YeP
         KitZUeyKqzLiKKzUZpA1W+fYHaAuuifqZSN7nkV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/33] btrfs: export helpers for subvolume name/id resolution
Date:   Mon, 24 Aug 2020 10:31:05 +0200
Message-Id: <20200824082346.992358892@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit c0c907a47dccf2cf26251a8fb4a8e7a3bf79ce84 ]

The functions will be used outside of export.c and super.c to allow
resolving subvolume name from a given id, eg. for subvolume deletion by
id ioctl.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ split from the next patch ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h  | 2 ++
 fs/btrfs/export.c | 8 ++++----
 fs/btrfs/export.h | 5 +++++
 fs/btrfs/super.c  | 8 ++++----
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b06d4942da77..8fb9a1e0048be 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4096,6 +4096,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid);
 
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 2513a7f533342..92f80ed642194 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -55,9 +55,9 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 	return type;
 }
 
-static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				       u64 root_objectid, u32 generation,
-				       int check_generation)
+struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
+				u64 root_objectid, u32 generation,
+				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root;
@@ -150,7 +150,7 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
 }
 
-static struct dentry *btrfs_get_parent(struct dentry *child)
+struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = d_inode(child);
 	struct btrfs_root *root = BTRFS_I(dir)->root;
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 074348a95841f..7a305e5549991 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -16,4 +16,9 @@ struct btrfs_fid {
 	u64 parent_root_objectid;
 } __attribute__ ((packed));
 
+struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
+				u64 root_objectid, u32 generation,
+				int check_generation);
+struct dentry *btrfs_get_parent(struct dentry *child);
+
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 404051bf5cba9..540e6f141745a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -843,8 +843,8 @@ out:
 	return error;
 }
 
-static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
-					   u64 subvol_objectid)
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid)
 {
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_root *fs_root;
@@ -1323,8 +1323,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				goto out;
 			}
 		}
-		subvol_name = get_subvol_name_from_objectid(btrfs_sb(mnt->mnt_sb),
-							    subvol_objectid);
+		subvol_name = btrfs_get_subvol_name_from_objectid(
+					btrfs_sb(mnt->mnt_sb), subvol_objectid);
 		if (IS_ERR(subvol_name)) {
 			root = ERR_CAST(subvol_name);
 			subvol_name = NULL;
-- 
2.25.1



