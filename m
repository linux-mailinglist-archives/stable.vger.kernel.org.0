Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7025E14554A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAVNUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbgAVNUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:36 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807DE24125;
        Wed, 22 Jan 2020 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699236;
        bh=7D5grPqzziheSCzZD8+gFuEldZWR0pqYl212jLCLHYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq2aGp85MFsYhrTxMX5M6fXSpq05PGsKKg7/2gjJDPa30tnNsk9jHtVlOqxcqBw/i
         v81U7k8zNMS73U/GqL+F2uAk7vJfrCRRA03ibyPF5qaMYJBRNzHHivjjxVQdpqTpCW
         E4xP3zGnFN5YmTwsQ4OzOCSbm+rDMo2nQHBtpopU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/222] btrfs: rework arguments of btrfs_unlink_subvol
Date:   Wed, 22 Jan 2020 10:27:49 +0100
Message-Id: <20200122092839.655192369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 045d3967b6920b663fc010ad414ade1b24143bd1 ]

btrfs_unlink_subvol takes the name of the dentry and the root objectid
based on what kind of inode this is, either a real subvolume link or a
empty one that we inherited as a snapshot.  We need to fix how we unlink
in the case for BTRFS_EMPTY_SUBVOL_DIR_OBJECTID in the future, so rework
btrfs_unlink_subvol to just take the dentry and handle getting the right
objectid given the type of inode this is.  There is no functional change
here, simply pushing the work into btrfs_unlink_subvol() proper.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c |   46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4215,18 +4215,30 @@ out:
 }
 
 static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
-			       struct inode *dir, u64 objectid,
-			       const char *name, int name_len)
+			       struct inode *dir, struct dentry *dentry)
 {
 	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
+	const char *name = dentry->d_name.name;
+	int name_len = dentry->d_name.len;
 	u64 index;
 	int ret;
+	u64 objectid;
 	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
 
+	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
+		objectid = inode->root->root_key.objectid;
+	} else if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
+		objectid = inode->location.objectid;
+	} else {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -4464,8 +4476,7 @@ int btrfs_delete_subvolume(struct inode
 
 	btrfs_record_snapshot_destroy(trans, BTRFS_I(dir));
 
-	ret = btrfs_unlink_subvol(trans, dir, dest->root_key.objectid,
-				  dentry->d_name.name, dentry->d_name.len);
+	ret = btrfs_unlink_subvol(trans, dir, dentry);
 	if (ret) {
 		err = ret;
 		btrfs_abort_transaction(trans, ret);
@@ -4560,10 +4571,7 @@ static int btrfs_rmdir(struct inode *dir
 		return PTR_ERR(trans);
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-		err = btrfs_unlink_subvol(trans, dir,
-					  BTRFS_I(inode)->location.objectid,
-					  dentry->d_name.name,
-					  dentry->d_name.len);
+		err = btrfs_unlink_subvol(trans, dir, dentry);
 		goto out;
 	}
 
@@ -9519,7 +9527,6 @@ static int btrfs_rename_exchange(struct
 	u64 new_ino = btrfs_ino(BTRFS_I(new_inode));
 	u64 old_idx = 0;
 	u64 new_idx = 0;
-	u64 root_objectid;
 	int ret;
 	bool root_log_pinned = false;
 	bool dest_log_pinned = false;
@@ -9625,10 +9632,7 @@ static int btrfs_rename_exchange(struct
 
 	/* src is a subvolume */
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID) {
-		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, old_dir, root_objectid,
-					  old_dentry->d_name.name,
-					  old_dentry->d_name.len);
+		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
@@ -9644,10 +9648,7 @@ static int btrfs_rename_exchange(struct
 
 	/* dest is a subvolume */
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID) {
-		root_objectid = BTRFS_I(new_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, new_dir, root_objectid,
-					  new_dentry->d_name.name,
-					  new_dentry->d_name.len);
+		ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
@@ -9845,7 +9846,6 @@ static int btrfs_rename(struct inode *ol
 	struct inode *new_inode = d_inode(new_dentry);
 	struct inode *old_inode = d_inode(old_dentry);
 	u64 index = 0;
-	u64 root_objectid;
 	int ret;
 	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
 	bool log_pinned = false;
@@ -9953,10 +9953,7 @@ static int btrfs_rename(struct inode *ol
 				BTRFS_I(old_inode), 1);
 
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
-		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
-		ret = btrfs_unlink_subvol(trans, old_dir, root_objectid,
-					old_dentry->d_name.name,
-					old_dentry->d_name.len);
+		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else {
 		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
 					BTRFS_I(d_inode(old_dentry)),
@@ -9975,10 +9972,7 @@ static int btrfs_rename(struct inode *ol
 		new_inode->i_ctime = current_time(new_inode);
 		if (unlikely(btrfs_ino(BTRFS_I(new_inode)) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-			root_objectid = BTRFS_I(new_inode)->location.objectid;
-			ret = btrfs_unlink_subvol(trans, new_dir, root_objectid,
-						new_dentry->d_name.name,
-						new_dentry->d_name.len);
+			ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 			BUG_ON(new_inode->i_nlink == 0);
 		} else {
 			ret = btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),


