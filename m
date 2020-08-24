Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D36524F7C9
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgHXJVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbgHXIzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE01204FD;
        Mon, 24 Aug 2020 08:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259337;
        bh=C6zcMQdfWST2uH7HAuv1/2Y7TTwR978n6yFKsEYL96c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rW6+D8vaBoEeJ+n9XO9ToflfkiNnp/QzjnCEPuiu7XKUN1OaCgY8eY2g94Jmj2uP8
         OirTowXMOydmBjHL4UD1b4Sw7XGei0MrA4r7I5R7HKB7WS1mwtlb0iRhlhgcYsZO9Q
         fypN9ebZrz8FRnUe3aplqkIl+w+EKNP2Y6ELw3Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/71] btrfs: export helpers for subvolume name/id resolution
Date:   Mon, 24 Aug 2020 10:30:56 +0200
Message-Id: <20200824082356.140981583@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
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
index 15cb96ad15d8c..554727d82d432 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3271,6 +3271,8 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid);
 
 static inline __printf(2, 3) __cold
 void btrfs_no_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1f3755b3a37ae..665ec85cb09b8 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -57,9 +57,9 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
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
@@ -152,7 +152,7 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
 }
 
-static struct dentry *btrfs_get_parent(struct dentry *child)
+struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = d_inode(child);
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
diff --git a/fs/btrfs/export.h b/fs/btrfs/export.h
index 57488ecd7d4ef..f32f4113c976a 100644
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -18,4 +18,9 @@ struct btrfs_fid {
 	u64 parent_root_objectid;
 } __attribute__ ((packed));
 
+struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
+				u64 root_objectid, u32 generation,
+				int check_generation);
+struct dentry *btrfs_get_parent(struct dentry *child);
+
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ed539496089f1..3e6e21a7c5e6f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1000,8 +1000,8 @@ out:
 	return error;
 }
 
-static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
-					   u64 subvol_objectid)
+char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
+					  u64 subvol_objectid)
 {
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_root *fs_root;
@@ -1412,8 +1412,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
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



