Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C0E3CE2D0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbhGSPcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348318AbhGSPaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957A660041;
        Mon, 19 Jul 2021 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710966;
        bh=+upTqzT7ggDNePnKQ0Bnm4dP4suTNq9Nwowwqna4Uu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejB2lINf/nGdnVNvvmoTvQuOKH8FoGJVqvV/Gxas5vkCadCo20XsPh6IJlmqdsXyD
         Qin+Nx436iTPDhMTJxcOwcvjEr32VlNC4gG8v5Ljp10TqfNLwcqRlTTh+Kilkr4PGb
         zmrr03rkmw1kGFMJxEoxwTu8Jci/Edq6O+IqlZmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 177/351] NFS: Fix up inode attribute revalidation timeouts
Date:   Mon, 19 Jul 2021 16:52:03 +0200
Message-Id: <20210719144950.833808256@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 213bb58475b57786e4336bc8bfd5029e16257c49 ]

The inode is considered revalidated when we've checked the value of the
change attribute against our cached value since that suffices to
establish whether or not the other cached values are valid.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 50 ++++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 529c4099f482..327f9ae4dd3f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2066,24 +2066,22 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	} else {
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_CHANGE;
-		cache_revalidated = false;
+		if (!have_delegation ||
+		    (nfsi->cache_validity & NFS_INO_INVALID_CHANGE) != 0)
+			cache_revalidated = false;
 	}
 
-	if (fattr->valid & NFS_ATTR_FATTR_MTIME) {
+	if (fattr->valid & NFS_ATTR_FATTR_MTIME)
 		inode->i_mtime = fattr->mtime;
-	} else if (fattr_supported & NFS_ATTR_FATTR_MTIME) {
+	else if (fattr_supported & NFS_ATTR_FATTR_MTIME)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_MTIME;
-		cache_revalidated = false;
-	}
 
-	if (fattr->valid & NFS_ATTR_FATTR_CTIME) {
+	if (fattr->valid & NFS_ATTR_FATTR_CTIME)
 		inode->i_ctime = fattr->ctime;
-	} else if (fattr_supported & NFS_ATTR_FATTR_CTIME) {
+	else if (fattr_supported & NFS_ATTR_FATTR_CTIME)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_CTIME;
-		cache_revalidated = false;
-	}
 
 	/* Check if our cached file size is stale */
 	if (fattr->valid & NFS_ATTR_FATTR_SIZE) {
@@ -2111,19 +2109,15 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			fattr->du.nfs3.used = 0;
 			fattr->valid |= NFS_ATTR_FATTR_SPACE_USED;
 		}
-	} else {
+	} else
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_SIZE;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_ATIME)
 		inode->i_atime = fattr->atime;
-	else if (fattr_supported & NFS_ATTR_FATTR_ATIME) {
+	else if (fattr_supported & NFS_ATTR_FATTR_ATIME)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_ATIME;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_MODE) {
 		if ((inode->i_mode & S_IALLUGO) != (fattr->mode & S_IALLUGO)) {
@@ -2134,11 +2128,9 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 				| NFS_INO_INVALID_ACL;
 			attr_changed = true;
 		}
-	} else if (fattr_supported & NFS_ATTR_FATTR_MODE) {
+	} else if (fattr_supported & NFS_ATTR_FATTR_MODE)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_MODE;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_OWNER) {
 		if (!uid_eq(inode->i_uid, fattr->uid)) {
@@ -2147,11 +2139,9 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_uid = fattr->uid;
 			attr_changed = true;
 		}
-	} else if (fattr_supported & NFS_ATTR_FATTR_OWNER) {
+	} else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_OTHER;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_GROUP) {
 		if (!gid_eq(inode->i_gid, fattr->gid)) {
@@ -2160,11 +2150,9 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			inode->i_gid = fattr->gid;
 			attr_changed = true;
 		}
-	} else if (fattr_supported & NFS_ATTR_FATTR_GROUP) {
+	} else if (fattr_supported & NFS_ATTR_FATTR_GROUP)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_OTHER;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_NLINK) {
 		if (inode->i_nlink != fattr->nlink) {
@@ -2173,30 +2161,24 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 			attr_changed = true;
 		}
-	} else if (fattr_supported & NFS_ATTR_FATTR_NLINK) {
+	} else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_NLINK;
-		cache_revalidated = false;
-	}
 
 	if (fattr->valid & NFS_ATTR_FATTR_SPACE_USED) {
 		/*
 		 * report the blocks in 512byte units
 		 */
 		inode->i_blocks = nfs_calc_block_size(fattr->du.nfs3.used);
-	} else if (fattr_supported & NFS_ATTR_FATTR_SPACE_USED) {
+	} else if (fattr_supported & NFS_ATTR_FATTR_SPACE_USED)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_BLOCKS;
-		cache_revalidated = false;
-	}
 
-	if (fattr->valid & NFS_ATTR_FATTR_BLOCKS_USED) {
+	if (fattr->valid & NFS_ATTR_FATTR_BLOCKS_USED)
 		inode->i_blocks = fattr->du.nfs2.blocks;
-	} else if (fattr_supported & NFS_ATTR_FATTR_BLOCKS_USED) {
+	else if (fattr_supported & NFS_ATTR_FATTR_BLOCKS_USED)
 		nfsi->cache_validity |=
 			save_cache_validity & NFS_INO_INVALID_BLOCKS;
-		cache_revalidated = false;
-	}
 
 	/* Update attrtimeo value if we're out of the unstable period */
 	if (attr_changed) {
-- 
2.30.2



