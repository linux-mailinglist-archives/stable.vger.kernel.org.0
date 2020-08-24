Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA624F5C8
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgHXIxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbgHXIxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB76C2072D;
        Mon, 24 Aug 2020 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259191;
        bh=ZqJNIiiwA28tyhVtUywZznol3MimkOdjb66+geBpQGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkL74E3mIf6+oKdESajER2RgJas8yTIBwv4MxEWgzwmzPcrpxEZ2GifTPfU1DBzds
         qN58eJ/pCkhcxm+CQwshGPs5JB6JqnHQrRW1jMuco+ZefQdP88fmIbPIkMNg51Wjet
         BDQUqByieQfVgCVKzB+asK/4XDBEl4Zm9d10hV60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/50] btrfs: export helpers for subvolume name/id resolution
Date:   Mon, 24 Aug 2020 10:31:08 +0200
Message-Id: <20200824082352.275946548@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
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
index 5412b12491cb8..de951987fd23d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3262,6 +3262,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid);
 
 static inline __printf(2, 3)
 void btrfs_no_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 3aeb5770f8965..b6ce765aa7f33 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -56,9 +56,9 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
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
@@ -151,7 +151,7 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
 }
 
-static struct dentry *btrfs_get_parent(struct dentry *child)
+struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = d_inode(child);
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 91b3908e7c549..15db024621414 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -17,4 +17,9 @@ struct btrfs_fid {
 	u64 parent_root_objectid;
 } __attribute__ ((packed));
 
+struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
+				u64 root_objectid, u32 generation,
+				int check_generation);
+struct dentry *btrfs_get_parent(struct dentry *child);
+
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 17a8463ef35c1..ca95e57b60ee1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -939,8 +939,8 @@ out:
 	return error;
 }
 
-static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
-					   u64 subvol_objectid)
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid)
 {
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_root *fs_root;
@@ -1427,8 +1427,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
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



