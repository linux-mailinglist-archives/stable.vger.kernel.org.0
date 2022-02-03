Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B274A8D3B
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbiBCU3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:29:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiBCU3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:29:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 302E6B835A1;
        Thu,  3 Feb 2022 20:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAAEC340E8;
        Thu,  3 Feb 2022 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920190;
        bh=sc2F+0Jac5GAdnhjcuYPK4JBExq1fGnSC7VOV23wS68=;
        h=From:To:Cc:Subject:Date:From;
        b=iDkRWU6B+Gi6jn5B5klkqkoeJhrQ5yALCOxtXiUhLJVIexcliuSBk2G5vk3o97kMg
         vkJ1mQB6Knc31Odj8PUOfXxbNPnJVbrYvAj5U//WwyzUpdxTk39SuquNtXt95iq+ru
         fFjnp6IUsWr24dcvZP4KlnxOFEJLc0kkNM0/l3MWYnOuYf5fA6K67QDIakkuqcvkNE
         U6nBaBkwPknuv5g63eRGJEizzzZRmSA0Qqv3sptjdy7nYrKtaFEMZNFjpDFNyeVTb4
         ZaztsgHaAdN01xMNUIIbgzq0JowrNg1L2s90pTEAf0K+mt0SPzMkCz/iCdEtMnyQ0g
         roXUD4pXq7kOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 01/52] NFS: change nfs_access_get_cached to only report the mask
Date:   Thu,  3 Feb 2022 15:28:55 -0500
Message-Id: <20220203202947.2304-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit b5e7b59c3480f355910f9d2c6ece5857922a5e54 ]

Currently the nfs_access_get_cached family of functions report a
'struct nfs_access_entry' as the result, with both .mask and .cred set.
However the .cred is never used.  This is probably good and there is no
guarantee that it won't be freed before use.

Change to only report the 'mask' - as this is all that is used or needed.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c           | 20 +++++++++-----------
 fs/nfs/nfs4proc.c      | 18 +++++++++---------
 include/linux/nfs_fs.h |  4 ++--
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 731d31015b6aa..8487a6d691167 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2673,7 +2673,7 @@ static struct nfs_access_entry *nfs_access_search_rbtree(struct inode *inode, co
 	return NULL;
 }
 
-static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res, bool may_block)
+static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, u32 *mask, bool may_block)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_access_entry *cache;
@@ -2703,8 +2703,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 		spin_lock(&inode->i_lock);
 		retry = false;
 	}
-	res->cred = cache->cred;
-	res->mask = cache->mask;
+	*mask = cache->mask;
 	list_move_tail(&cache->lru, &nfsi->access_cache_entry_lru);
 	err = 0;
 out:
@@ -2716,7 +2715,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 	return -ENOENT;
 }
 
-static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res)
+static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, u32 *mask)
 {
 	/* Only check the most recently returned cache entry,
 	 * but do it without locking.
@@ -2738,22 +2737,21 @@ static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cre
 		goto out;
 	if (nfs_check_cache_invalid(inode, NFS_INO_INVALID_ACCESS))
 		goto out;
-	res->cred = cache->cred;
-	res->mask = cache->mask;
+	*mask = cache->mask;
 	err = 0;
 out:
 	rcu_read_unlock();
 	return err;
 }
 
-int nfs_access_get_cached(struct inode *inode, const struct cred *cred, struct
-nfs_access_entry *res, bool may_block)
+int nfs_access_get_cached(struct inode *inode, const struct cred *cred,
+			  u32 *mask, bool may_block)
 {
 	int status;
 
-	status = nfs_access_get_cached_rcu(inode, cred, res);
+	status = nfs_access_get_cached_rcu(inode, cred, mask);
 	if (status != 0)
-		status = nfs_access_get_cached_locked(inode, cred, res,
+		status = nfs_access_get_cached_locked(inode, cred, mask,
 		    may_block);
 
 	return status;
@@ -2874,7 +2872,7 @@ static int nfs_do_access(struct inode *inode, const struct cred *cred, int mask)
 
 	trace_nfs_access_enter(inode);
 
-	status = nfs_access_get_cached(inode, cred, &cache, may_block);
+	status = nfs_access_get_cached(inode, cred, &cache.mask, may_block);
 	if (status == 0)
 		goto out_cached;
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ee3bc79f6ca3a..322ff45ad15ca 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7611,7 +7611,7 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 				    const char *key, const void *buf,
 				    size_t buflen, int flags)
 {
-	struct nfs_access_entry cache;
+	u32 mask;
 	int ret;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
@@ -7626,8 +7626,8 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 	 * do a cached access check for the XA* flags to possibly avoid
 	 * doing an RPC and getting EACCES back.
 	 */
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XAWRITE))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XAWRITE))
 			return -EACCES;
 	}
 
@@ -7648,14 +7648,14 @@ static int nfs4_xattr_get_nfs4_user(const struct xattr_handler *handler,
 				    struct dentry *unused, struct inode *inode,
 				    const char *key, void *buf, size_t buflen)
 {
-	struct nfs_access_entry cache;
+	u32 mask;
 	ssize_t ret;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
 		return -EOPNOTSUPP;
 
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XAREAD))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XAREAD))
 			return -EACCES;
 	}
 
@@ -7680,13 +7680,13 @@ nfs4_listxattr_nfs4_user(struct inode *inode, char *list, size_t list_len)
 	ssize_t ret, size;
 	char *buf;
 	size_t buflen;
-	struct nfs_access_entry cache;
+	u32 mask;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
 		return 0;
 
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XALIST))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XALIST))
 			return 0;
 	}
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 05f249f20f55d..f33559acbcc28 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -533,8 +533,8 @@ extern int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fh,
 			struct nfs_fattr *fattr);
 extern int nfs_may_open(struct inode *inode, const struct cred *cred, int openflags);
 extern void nfs_access_zap_cache(struct inode *inode);
-extern int nfs_access_get_cached(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res,
-				 bool may_block);
+extern int nfs_access_get_cached(struct inode *inode, const struct cred *cred,
+				 u32 *mask, bool may_block);
 
 /*
  * linux/fs/nfs/symlink.c
-- 
2.34.1

