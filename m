Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1107453A00
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhKPTVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239914AbhKPTVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 14:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9727D6323F;
        Tue, 16 Nov 2021 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090286;
        bh=Z6Uu3/lxleToi8v48/ve0WJ0Gv6bbt8UPwTOOJiZvhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjfjhBM6DtkbH553H9TLMZ4xSpocXtT5l9teDh9LvffiweeMfl6lopbT6eTSLn2Au
         dH++3qz9IO3bEBLadui2+NVecFwjXxTr2zQHXD538lRFhagGKft4nfj246G0Md1sJ8
         /Q7+vMm1xwg1ibAxWyYYrbuyDAcL4o479+gWfJXYMHTsV/hK3sKJYvDa1lIqU4FAow
         XKDNUg+2Lt4Q7pXpeIZVuonV9AgJ3C0XcsiPrOnnEc0hCl/97POJiWjKjTTsWzy4Fo
         t8+Xw+0K5nyBOdATxB6KfqWxC8Nye5sWbVz8bBDpebt4fYG5PpT4HAPgdZ6NOFqpnh
         dFjiAI5YahKqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/65] NFS: Fix up nfs_ctx_key_to_expire()
Date:   Tue, 16 Nov 2021 14:16:50 -0500
Message-Id: <20211116191754.2419097-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ca05cbae2a0468e5d78e9b4605936a8bf5da328b ]

If the cached credential exists but doesn't have any expiration callback
then exit early.
Fix up atomicity issues when replacing the credential with a new one
since the existing code could lead to refcount leaks.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c         |  4 ++--
 fs/nfs/write.c         | 41 ++++++++++++++++++++++++++++-------------
 include/linux/nfs_fs.h |  2 +-
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 853213b3a2095..4f45281c47cfb 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1024,7 +1024,7 @@ struct nfs_open_context *alloc_nfs_open_context(struct dentry *dentry,
 		ctx->cred = get_cred(filp->f_cred);
 	else
 		ctx->cred = get_current_cred();
-	ctx->ll_cred = NULL;
+	rcu_assign_pointer(ctx->ll_cred, NULL);
 	ctx->state = NULL;
 	ctx->mode = f_mode;
 	ctx->flags = 0;
@@ -1063,7 +1063,7 @@ static void __put_nfs_open_context(struct nfs_open_context *ctx, int is_sync)
 	put_cred(ctx->cred);
 	dput(ctx->dentry);
 	nfs_sb_deactive(sb);
-	put_rpccred(ctx->ll_cred);
+	put_rpccred(rcu_dereference_protected(ctx->ll_cred, 1));
 	kfree(ctx->mdsthreshold);
 	kfree_rcu(ctx, rcu_head);
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index eae9bf1140417..773ea2c8504d6 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1246,7 +1246,7 @@ nfs_key_timeout_notify(struct file *filp, struct inode *inode)
 	struct nfs_open_context *ctx = nfs_file_open_context(filp);
 
 	if (nfs_ctx_key_to_expire(ctx, inode) &&
-	    !ctx->ll_cred)
+	    !rcu_access_pointer(ctx->ll_cred))
 		/* Already expired! */
 		return -EACCES;
 	return 0;
@@ -1258,23 +1258,38 @@ nfs_key_timeout_notify(struct file *filp, struct inode *inode)
 bool nfs_ctx_key_to_expire(struct nfs_open_context *ctx, struct inode *inode)
 {
 	struct rpc_auth *auth = NFS_SERVER(inode)->client->cl_auth;
-	struct rpc_cred *cred = ctx->ll_cred;
+	struct rpc_cred *cred, *new, *old = NULL;
 	struct auth_cred acred = {
 		.cred = ctx->cred,
 	};
+	bool ret = false;
 
-	if (cred && !cred->cr_ops->crmatch(&acred, cred, 0)) {
-		put_rpccred(cred);
-		ctx->ll_cred = NULL;
-		cred = NULL;
-	}
-	if (!cred)
-		cred = auth->au_ops->lookup_cred(auth, &acred, 0);
-	if (!cred || IS_ERR(cred))
+	rcu_read_lock();
+	cred = rcu_dereference(ctx->ll_cred);
+	if (cred && !(cred->cr_ops->crkey_timeout &&
+		      cred->cr_ops->crkey_timeout(cred)))
+		goto out;
+	rcu_read_unlock();
+
+	new = auth->au_ops->lookup_cred(auth, &acred, 0);
+	if (new == cred) {
+		put_rpccred(new);
 		return true;
-	ctx->ll_cred = cred;
-	return !!(cred->cr_ops->crkey_timeout &&
-		  cred->cr_ops->crkey_timeout(cred));
+	}
+	if (IS_ERR_OR_NULL(new)) {
+		new = NULL;
+		ret = true;
+	} else if (new->cr_ops->crkey_timeout &&
+		   new->cr_ops->crkey_timeout(new))
+		ret = true;
+
+	rcu_read_lock();
+	old = rcu_dereference_protected(xchg(&ctx->ll_cred,
+					     RCU_INITIALIZER(new)), 1);
+out:
+	rcu_read_unlock();
+	put_rpccred(old);
+	return ret;
 }
 
 /*
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index b9a8b925db430..9b75448ce0df8 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -81,7 +81,7 @@ struct nfs_open_context {
 	fl_owner_t flock_owner;
 	struct dentry *dentry;
 	const struct cred *cred;
-	struct rpc_cred *ll_cred;	/* low-level cred - use to check for expiry */
+	struct rpc_cred __rcu *ll_cred;	/* low-level cred - use to check for expiry */
 	struct nfs4_state *state;
 	fmode_t mode;
 
-- 
2.33.0

