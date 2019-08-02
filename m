Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB397F350
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406682AbfHBJ4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406675AbfHBJ4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822652064A;
        Fri,  2 Aug 2019 09:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739766;
        bh=TO/8nnFSSvjptpD6jOWFDtSTYx1GoMZAaSaBFpVcCNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTbDhJXIC3rs0GVEoV2afWeGRqNS1ikm8GC78GsnS5Bg6EYDmdaFF32kytPDgGZpE
         Kuz4GVDsNgdYCOekkdXy43JORGbJcce7vbnj7MzM2tIBJaaNFFR5TsWx9vrm11hYo+
         x/0VgpeSLhALYluj4Z7QaL4nFqhg8IDx3E0rWL04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 4.19 05/32] NFSv4: Fix lookup revalidate of regular files
Date:   Fri,  2 Aug 2019 11:39:39 +0200
Message-Id: <20190802092103.334825109@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c7944ebb9ce9461079659e9e6ec5baaf73724b3b upstream.

If we're revalidating an existing dentry in order to open a file, we need
to ensure that we check the directory has not changed before we optimise
away the lookup.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Qian Lu <luqia@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dir.c |   79 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1231,7 +1231,8 @@ out_bad:
 }
 
 static int
-nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+__nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags,
+			int (*reval)(struct inode *, struct dentry *, unsigned int))
 {
 	struct dentry *parent;
 	struct inode *dir;
@@ -1242,17 +1243,22 @@ nfs_lookup_revalidate(struct dentry *den
 		dir = d_inode_rcu(parent);
 		if (!dir)
 			return -ECHILD;
-		ret = nfs_do_lookup_revalidate(dir, dentry, flags);
+		ret = reval(dir, dentry, flags);
 		if (parent != READ_ONCE(dentry->d_parent))
 			return -ECHILD;
 	} else {
 		parent = dget_parent(dentry);
-		ret = nfs_do_lookup_revalidate(d_inode(parent), dentry, flags);
+		ret = reval(d_inode(parent), dentry, flags);
 		dput(parent);
 	}
 	return ret;
 }
 
+static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return __nfs_lookup_revalidate(dentry, flags, nfs_do_lookup_revalidate);
+}
+
 /*
  * A weaker form of d_revalidate for revalidating just the d_inode(dentry)
  * when we don't really care about the dentry name. This is called when a
@@ -1609,62 +1615,55 @@ no_open:
 }
 EXPORT_SYMBOL_GPL(nfs_atomic_open);
 
-static int nfs4_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+static int
+nfs4_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
+			  unsigned int flags)
 {
 	struct inode *inode;
-	int ret = 0;
 
 	if (!(flags & LOOKUP_OPEN) || (flags & LOOKUP_DIRECTORY))
-		goto no_open;
+		goto full_reval;
 	if (d_mountpoint(dentry))
-		goto no_open;
-	if (NFS_SB(dentry->d_sb)->caps & NFS_CAP_ATOMIC_OPEN_V1)
-		goto no_open;
+		goto full_reval;
 
 	inode = d_inode(dentry);
 
 	/* We can't create new files in nfs_open_revalidate(), so we
 	 * optimize away revalidation of negative dentries.
 	 */
-	if (inode == NULL) {
-		struct dentry *parent;
-		struct inode *dir;
-
-		if (flags & LOOKUP_RCU) {
-			parent = READ_ONCE(dentry->d_parent);
-			dir = d_inode_rcu(parent);
-			if (!dir)
-				return -ECHILD;
-		} else {
-			parent = dget_parent(dentry);
-			dir = d_inode(parent);
-		}
-		if (!nfs_neg_need_reval(dir, dentry, flags))
-			ret = 1;
-		else if (flags & LOOKUP_RCU)
-			ret = -ECHILD;
-		if (!(flags & LOOKUP_RCU))
-			dput(parent);
-		else if (parent != READ_ONCE(dentry->d_parent))
-			return -ECHILD;
-		goto out;
-	}
+	if (inode == NULL)
+		goto full_reval;
+
+	if (NFS_PROTO(dir)->have_delegation(inode, FMODE_READ))
+		return nfs_lookup_revalidate_delegated(dir, dentry, inode);
 
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
-		goto no_open;
+		goto full_reval;
+
 	/* We cannot do exclusive creation on a positive dentry */
-	if (flags & LOOKUP_EXCL)
-		goto no_open;
+	if (flags & (LOOKUP_EXCL | LOOKUP_REVAL))
+		goto reval_dentry;
+
+	/* Check if the directory changed */
+	if (!nfs_check_verifier(dir, dentry, flags & LOOKUP_RCU))
+		goto reval_dentry;
 
 	/* Let f_op->open() actually open (and revalidate) the file */
-	ret = 1;
+	return 1;
+reval_dentry:
+	if (flags & LOOKUP_RCU)
+		return -ECHILD;
+	return nfs_lookup_revalidate_dentry(dir, dentry, inode);;
 
-out:
-	return ret;
+full_reval:
+	return nfs_do_lookup_revalidate(dir, dentry, flags);
+}
 
-no_open:
-	return nfs_lookup_revalidate(dentry, flags);
+static int nfs4_lookup_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return __nfs_lookup_revalidate(dentry, flags,
+			nfs4_do_lookup_revalidate);
 }
 
 #endif /* CONFIG_NFSV4 */


