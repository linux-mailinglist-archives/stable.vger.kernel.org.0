Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D1A43A1AB
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhJYTk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237110AbhJYTit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E2E60E97;
        Mon, 25 Oct 2021 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190497;
        bh=kDzUY+TY0srqy4pJ9vW70pzP6B4vvtzWWRM+X8PjjT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuD1SapaKuSomJxscO5gremzB2iXNyiz412ASC+3YHN/ms7RgqS6sCwdz6SBShupS
         HXV2UdC2F4lzQUQAfwuy495k1dc6W+5MROHwSJZBDAB78xtuqI0QYDcszKDSeDQGjR
         phXeo0ZZ3/6C+vXcy9gw9dm22RXWlkTq04mRFHEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/95] btrfs: deal with errors when checking if a dir entry exists during log replay
Date:   Mon, 25 Oct 2021 21:15:09 +0200
Message-Id: <20211025191007.341880123@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 77a5b9e3d14cbce49ceed2766b2003c034c066dc ]

Currently inode_in_dir() ignores errors returned from
btrfs_lookup_dir_index_item() and from btrfs_lookup_dir_item(), treating
any errors as if the directory entry does not exists in the fs/subvolume
tree, which is obviously not correct, as we can get errors such as -EIO
when reading extent buffers while searching the fs/subvolume's tree.

Fix that by making inode_in_dir() return the errors and making its only
caller, add_inode_ref(), deal with returned errors as well.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c3bb5c4375ab..3b93a98fd544 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -894,9 +894,11 @@ out:
 }
 
 /*
- * helper function to see if a given name and sequence number found
- * in an inode back reference are already in a directory and correctly
- * point to this inode
+ * See if a given name and sequence number found in an inode back reference are
+ * already in a directory and correctly point to this inode.
+ *
+ * Returns: < 0 on error, 0 if the directory entry does not exists and 1 if it
+ * exists.
  */
 static noinline int inode_in_dir(struct btrfs_root *root,
 				 struct btrfs_path *path,
@@ -905,29 +907,35 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key location;
-	int match = 0;
+	int ret = 0;
 
 	di = btrfs_lookup_dir_index_item(NULL, root, path, dirid,
 					 index, name, name_len, 0);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		if (PTR_ERR(di) != -ENOENT)
+			ret = PTR_ERR(di);
+		goto out;
+	} else if (di) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
 		if (location.objectid != objectid)
 			goto out;
-	} else
+	} else {
 		goto out;
-	btrfs_release_path(path);
+	}
 
+	btrfs_release_path(path);
 	di = btrfs_lookup_dir_item(NULL, root, path, dirid, name, name_len, 0);
-	if (di && !IS_ERR(di)) {
-		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
-		if (location.objectid != objectid)
-			goto out;
-	} else
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
 		goto out;
-	match = 1;
+	} else if (di) {
+		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
+		if (location.objectid == objectid)
+			ret = 1;
+	}
 out:
 	btrfs_release_path(path);
-	return match;
+	return ret;
 }
 
 /*
@@ -1477,10 +1485,12 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 
-		/* if we already have a perfect match, we're done */
-		if (!inode_in_dir(root, path, btrfs_ino(BTRFS_I(dir)),
-					btrfs_ino(BTRFS_I(inode)), ref_index,
-					name, namelen)) {
+		ret = inode_in_dir(root, path, btrfs_ino(BTRFS_I(dir)),
+				   btrfs_ino(BTRFS_I(inode)), ref_index,
+				   name, namelen);
+		if (ret < 0) {
+			goto out;
+		} else if (ret == 0) {
 			/*
 			 * look for a conflicting back reference in the
 			 * metadata. if we find one we have to unlink that name
@@ -1538,6 +1548,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 			btrfs_update_inode(trans, root, inode);
 		}
+		/* Else, ret == 1, we already have a perfect match, we're done. */
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
 		kfree(name);
-- 
2.33.0



