Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D532E91D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCEMal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232223AbhCEMaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B206502C;
        Fri,  5 Mar 2021 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947419;
        bh=PPkQjDDB81gbch0//TF5n+DiAQwOKJ92GEcKxpowgK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVNb5j7odjjqK81/IWi0bcp16MUszUXmJEfJLDJFnQm/jVPdgGqLM+7CY3gWK/fB0
         vtsg6n5zrEGe21g6PKA5L6wIM2F9ge5Trf1Gt72HunWvZXL6lZH7PXAJWZRFVOdlqN
         f0Fcwzch7DJIOhvdBAB/4xoS1z57B4bERz+oHc4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/102] fs: make unlazy_walk() error handling consistent
Date:   Fri,  5 Mar 2021 13:21:18 +0100
Message-Id: <20210305120906.184092495@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e36cffed20a324e116f329a94061ae30dd26fb51 ]

Most callers check for non-zero return, and assume it's -ECHILD (which
it always will be). One caller uses the actual error return. Clean this
up and make it fully consistent, by having unlazy_walk() return a bool
instead. Rename it to try_to_unlazy() and return true on success, and
failure on error. That's easier to read.

No functional changes in this patch.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d4a6dd772303..7af66d5a0c1b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -669,17 +669,17 @@ static bool legitimize_root(struct nameidata *nd)
  */
 
 /**
- * unlazy_walk - try to switch to ref-walk mode.
+ * try_to_unlazy - try to switch to ref-walk mode.
  * @nd: nameidata pathwalk data
- * Returns: 0 on success, -ECHILD on failure
+ * Returns: true on success, false on failure
  *
- * unlazy_walk attempts to legitimize the current nd->path and nd->root
+ * try_to_unlazy attempts to legitimize the current nd->path and nd->root
  * for ref-walk mode.
  * Must be called from rcu-walk context.
- * Nothing should touch nameidata between unlazy_walk() failure and
+ * Nothing should touch nameidata between try_to_unlazy() failure and
  * terminate_walk().
  */
-static int unlazy_walk(struct nameidata *nd)
+static bool try_to_unlazy(struct nameidata *nd)
 {
 	struct dentry *parent = nd->path.dentry;
 
@@ -694,14 +694,14 @@ static int unlazy_walk(struct nameidata *nd)
 		goto out;
 	rcu_read_unlock();
 	BUG_ON(nd->inode != parent->d_inode);
-	return 0;
+	return true;
 
 out1:
 	nd->path.mnt = NULL;
 	nd->path.dentry = NULL;
 out:
 	rcu_read_unlock();
-	return -ECHILD;
+	return false;
 }
 
 /**
@@ -792,7 +792,7 @@ static int complete_walk(struct nameidata *nd)
 		 */
 		if (!(nd->flags & (LOOKUP_ROOT | LOOKUP_IS_SCOPED)))
 			nd->root.mnt = NULL;
-		if (unlikely(unlazy_walk(nd)))
+		if (!try_to_unlazy(nd))
 			return -ECHILD;
 	}
 
@@ -1466,7 +1466,7 @@ static struct dentry *lookup_fast(struct nameidata *nd,
 		unsigned seq;
 		dentry = __d_lookup_rcu(parent, &nd->last, &seq);
 		if (unlikely(!dentry)) {
-			if (unlazy_walk(nd))
+			if (!try_to_unlazy(nd))
 				return ERR_PTR(-ECHILD);
 			return NULL;
 		}
@@ -1567,10 +1567,8 @@ static inline int may_lookup(struct nameidata *nd)
 {
 	if (nd->flags & LOOKUP_RCU) {
 		int err = inode_permission(nd->inode, MAY_EXEC|MAY_NOT_BLOCK);
-		if (err != -ECHILD)
+		if (err != -ECHILD || !try_to_unlazy(nd))
 			return err;
-		if (unlazy_walk(nd))
-			return -ECHILD;
 	}
 	return inode_permission(nd->inode, MAY_EXEC);
 }
@@ -1592,7 +1590,7 @@ static int reserve_stack(struct nameidata *nd, struct path *link, unsigned seq)
 		// unlazy even if we fail to grab the link - cleanup needs it
 		bool grabbed_link = legitimize_path(nd, link, seq);
 
-		if (unlazy_walk(nd) != 0 || !grabbed_link)
+		if (!try_to_unlazy(nd) != 0 || !grabbed_link)
 			return -ECHILD;
 
 		if (nd_alloc_stack(nd))
@@ -1634,7 +1632,7 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 		touch_atime(&last->link);
 		cond_resched();
 	} else if (atime_needs_update(&last->link, inode)) {
-		if (unlikely(unlazy_walk(nd)))
+		if (!try_to_unlazy(nd))
 			return ERR_PTR(-ECHILD);
 		touch_atime(&last->link);
 	}
@@ -1651,11 +1649,8 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 		get = inode->i_op->get_link;
 		if (nd->flags & LOOKUP_RCU) {
 			res = get(NULL, inode, &last->done);
-			if (res == ERR_PTR(-ECHILD)) {
-				if (unlikely(unlazy_walk(nd)))
-					return ERR_PTR(-ECHILD);
+			if (res == ERR_PTR(-ECHILD) && try_to_unlazy(nd))
 				res = get(link->dentry, inode, &last->done);
-			}
 		} else {
 			res = get(link->dentry, inode, &last->done);
 		}
@@ -2193,7 +2188,7 @@ OK:
 		}
 		if (unlikely(!d_can_lookup(nd->path.dentry))) {
 			if (nd->flags & LOOKUP_RCU) {
-				if (unlazy_walk(nd))
+				if (!try_to_unlazy(nd))
 					return -ECHILD;
 			}
 			return -ENOTDIR;
@@ -3127,7 +3122,6 @@ static const char *open_last_lookups(struct nameidata *nd,
 	struct inode *inode;
 	struct dentry *dentry;
 	const char *res;
-	int error;
 
 	nd->flags |= op->intent;
 
@@ -3151,9 +3145,8 @@ static const char *open_last_lookups(struct nameidata *nd,
 	} else {
 		/* create side of things */
 		if (nd->flags & LOOKUP_RCU) {
-			error = unlazy_walk(nd);
-			if (unlikely(error))
-				return ERR_PTR(error);
+			if (!try_to_unlazy(nd))
+				return ERR_PTR(-ECHILD);
 		}
 		audit_inode(nd->name, dir, AUDIT_INODE_PARENT);
 		/* trailing slashes? */
@@ -3162,9 +3155,7 @@ static const char *open_last_lookups(struct nameidata *nd,
 	}
 
 	if (open_flag & (O_CREAT | O_TRUNC | O_WRONLY | O_RDWR)) {
-		error = mnt_want_write(nd->path.mnt);
-		if (!error)
-			got_write = true;
+		got_write = !mnt_want_write(nd->path.mnt);
 		/*
 		 * do _not_ fail yet - we might not need that or fail with
 		 * a different error; let lookup_open() decide; we'll be
-- 
2.30.1



