Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3152C9DFD
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390914AbgLAJaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387951AbgLAI6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A522222C;
        Tue,  1 Dec 2020 08:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813070;
        bh=SBUTAK6tLgiSZKsOhoZXkz1FRmay8B6GvjFtemMGAKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhINjmCBxHIx0zK25otwsItqK+4Yq9eZ9blOf/1iUSUzV97OZVeLjaO6Wbpy9VWUv
         PQteuZw2q8eDzhe5Vv/wvL9TFhjj/690idHb7SuKD4ysO1Bes7d6ZryE+rkeAatcqF
         buYPXD8q2FjHTDnHjXzRHf5kqpQjdjO+uxlrmiA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <suy.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 07/50] btrfs: adjust return values of btrfs_inode_by_name
Date:   Tue,  1 Dec 2020 09:53:06 +0100
Message-Id: <20201201084645.707259089@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

commit 005d67127fa9dfb3382f2c9e918feed7a243a7fe upstream

Previously, btrfs_inode_by_name() returned 0 which left caller to check
objectid of location even location if the type was invalid.

Let btrfs_inode_by_name() return -EUCLEAN if a corrupted location of a
dir entry is found.  Removal of label out_err also simplifies the
function.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ drop unlikely ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5585,7 +5585,8 @@ no_delete:
 
 /*
  * this returns the key found in the dir entry in the location pointer.
- * If no dir entries were found, location->objectid is 0.
+ * If no dir entries were found, returns -ENOENT.
+ * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			       struct btrfs_key *location)
@@ -5603,27 +5604,27 @@ static int btrfs_inode_by_name(struct in
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
 			name, namelen, 0);
-	if (IS_ERR(di))
+	if (!di) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
-
-	if (IS_ERR_OR_NULL(di))
-		goto out_err;
+		goto out;
+	}
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
 	if (location->type != BTRFS_INODE_ITEM_KEY &&
 	    location->type != BTRFS_ROOT_ITEM_KEY) {
+		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
 			   __func__, name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
-		goto out_err;
 	}
 out:
 	btrfs_free_path(path);
 	return ret;
-out_err:
-	location->objectid = 0;
-	goto out;
 }
 
 /*
@@ -5924,9 +5925,6 @@ struct inode *btrfs_lookup_dentry(struct
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	if (location.objectid == 0)
-		return ERR_PTR(-ENOENT);
-
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
 		return inode;


