Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CF84A8EA7
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354400AbiBCUiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355486AbiBCUfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:35:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB692C061344;
        Thu,  3 Feb 2022 12:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAA32B835A4;
        Thu,  3 Feb 2022 20:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A190BC340E8;
        Thu,  3 Feb 2022 20:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920489;
        bh=W4EpgHI5aiRq/XdM8vlrm5eeJ0BCq6ECQFJ2N5rUkCA=;
        h=From:To:Cc:Subject:Date:From;
        b=rcN/xd2YBegtZOZYtkTwTyIfI/SNSt+7EIdj+1K5BMQlNVJk+v/P7xpsDlNggvPsK
         3xoiSGKsOHtbsXhK8AilPT9MffT+ruCB/SMpSVGZwc6+ikl7TVh3DK1L5Ecprx6nlB
         4Xg2hWqjTHGR+2Tf86ketDo1p9d429AbMX6IWuwGk17jyiN9cSjEbZg0bU6aCb3w+Q
         pryi4jNMEaEOKxvJSV8j79LtVTpXq0ks+v1AyWEq8LU6uRLIPab4Xe3BEgL60IOkNB
         FLMWzKUuNC4WiclEQI4EcMUEcyftPyrmpQSDEYmmUkEBYNXm/f+zl6vDCSSv5vtXxB
         XeFhIJbo/0tNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/25] NFS: change nfs_access_get_cached to only report the mask
Date:   Thu,  3 Feb 2022 15:34:22 -0500
Message-Id: <20220203203447.3570-1-sashal@kernel.org>
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
index 8b963c72dd3b1..cc17d815abae6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2467,7 +2467,7 @@ static struct nfs_access_entry *nfs_access_search_rbtree(struct inode *inode, co
 	return NULL;
 }
 
-static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res, bool may_block)
+static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *cred, u32 *mask, bool may_block)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_access_entry *cache;
@@ -2497,8 +2497,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 		spin_lock(&inode->i_lock);
 		retry = false;
 	}
-	res->cred = cache->cred;
-	res->mask = cache->mask;
+	*mask = cache->mask;
 	list_move_tail(&cache->lru, &nfsi->access_cache_entry_lru);
 	err = 0;
 out:
@@ -2510,7 +2509,7 @@ static int nfs_access_get_cached_locked(struct inode *inode, const struct cred *
 	return -ENOENT;
 }
 
-static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, struct nfs_access_entry *res)
+static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cred, u32 *mask)
 {
 	/* Only check the most recently returned cache entry,
 	 * but do it without locking.
@@ -2532,22 +2531,21 @@ static int nfs_access_get_cached_rcu(struct inode *inode, const struct cred *cre
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
@@ -2668,7 +2666,7 @@ static int nfs_do_access(struct inode *inode, const struct cred *cred, int mask)
 
 	trace_nfs_access_enter(inode);
 
-	status = nfs_access_get_cached(inode, cred, &cache, may_block);
+	status = nfs_access_get_cached(inode, cred, &cache.mask, may_block);
 	if (status == 0)
 		goto out_cached;
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3106bd28b1132..d222a980164b7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7597,7 +7597,7 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 				    const char *key, const void *buf,
 				    size_t buflen, int flags)
 {
-	struct nfs_access_entry cache;
+	u32 mask;
 	int ret;
 
 	if (!nfs_server_capable(inode, NFS_CAP_XATTR))
@@ -7612,8 +7612,8 @@ static int nfs4_xattr_set_nfs4_user(const struct xattr_handler *handler,
 	 * do a cached access check for the XA* flags to possibly avoid
 	 * doing an RPC and getting EACCES back.
 	 */
-	if (!nfs_access_get_cached(inode, current_cred(), &cache, true)) {
-		if (!(cache.mask & NFS_ACCESS_XAWRITE))
+	if (!nfs_access_get_cached(inode, current_cred(), &mask, true)) {
+		if (!(mask & NFS_ACCESS_XAWRITE))
 			return -EACCES;
 	}
 
@@ -7634,14 +7634,14 @@ static int nfs4_xattr_get_nfs4_user(const struct xattr_handler *handler,
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
 
@@ -7666,13 +7666,13 @@ nfs4_listxattr_nfs4_user(struct inode *inode, char *list, size_t list_len)
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
index aff5cd382fef5..1e0a3497bdb46 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -501,8 +501,8 @@ extern int nfs_instantiate(struct dentry *dentry, struct nfs_fh *fh,
 			struct nfs_fattr *fattr, struct nfs4_label *label);
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

