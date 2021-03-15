Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4120733BA4F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhCOOIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhCOODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048CA64DAD;
        Mon, 15 Mar 2021 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816988;
        bh=cZ83mKjCJXO+pr922AHWsqr7sJPYruQK8+WdF2VCpl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9X3FLhk34ppN3FQC7nLGht0YZOS0dpKf1Lj2wslumEmmLFomrdpljqbSMI/LxjVn
         Y4U4X7UgWXqvamkCDlzzDS2Ya9gEXYIcV+5LDWjbUQv2Kdd7FFfMXJgRvzLIy2Tp31
         1/+9aDpvZZ1dnBqJPOn85dEAuOQWvY8j9119uNEY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Jansen <gerardu@amazon.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 246/306] NFS: Dont revalidate the directory permissions on a lookup failure
Date:   Mon, 15 Mar 2021 14:55:09 +0100
Message-Id: <20210315135515.959029673@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 82e7ca1334ab16e2e04fafded1cab9dfcdc11b40 ]

There should be no reason to expect the directory permissions to change
just because the directory contents changed or a negative lookup timed
out. So let's avoid doing a full call to nfs_mark_for_revalidate() in
that case.
Furthermore, if this is a negative dentry, and we haven't actually done
a new lookup, then we have no reason yet to believe the directory has
changed at all. So let's remove the gratuitous directory inode
invalidation altogether when called from
nfs_lookup_revalidate_negative().

Reported-by: Geert Jansen <gerardu@amazon.com>
Fixes: 5ceb9d7fdaaf ("NFS: Refactor nfs_lookup_revalidate()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ef827ae193d2..7bcc6fcf1096 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1401,6 +1401,15 @@ int nfs_lookup_verify_inode(struct inode *inode, unsigned int flags)
 	goto out;
 }
 
+static void nfs_mark_dir_for_revalidate(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	spin_lock(&inode->i_lock);
+	nfsi->cache_validity |= NFS_INO_REVAL_PAGECACHE;
+	spin_unlock(&inode->i_lock);
+}
+
 /*
  * We judge how long we want to trust negative
  * dentries by looking at the parent inode mtime.
@@ -1435,7 +1444,6 @@ nfs_lookup_revalidate_done(struct inode *dir, struct dentry *dentry,
 			__func__, dentry);
 		return 1;
 	case 0:
-		nfs_mark_for_revalidate(dir);
 		if (inode && S_ISDIR(inode->i_mode)) {
 			/* Purge readdir caches. */
 			nfs_zap_caches(inode);
@@ -1525,6 +1533,13 @@ nfs_lookup_revalidate_dentry(struct inode *dir, struct dentry *dentry,
 	nfs_free_fattr(fattr);
 	nfs_free_fhandle(fhandle);
 	nfs4_label_free(label);
+
+	/*
+	 * If the lookup failed despite the dentry change attribute being
+	 * a match, then we should revalidate the directory cache.
+	 */
+	if (!ret && nfs_verify_change_attribute(dir, dentry->d_time))
+		nfs_mark_dir_for_revalidate(dir);
 	return nfs_lookup_revalidate_done(dir, dentry, inode, ret);
 }
 
@@ -1567,7 +1582,7 @@ nfs_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
 		error = nfs_lookup_verify_inode(inode, flags);
 		if (error) {
 			if (error == -ESTALE)
-				nfs_zap_caches(dir);
+				nfs_mark_dir_for_revalidate(dir);
 			goto out_bad;
 		}
 		nfs_advise_use_readdirplus(dir);
@@ -2064,7 +2079,6 @@ nfs_add_or_obtain(struct dentry *dentry, struct nfs_fh *fhandle,
 	dput(parent);
 	return d;
 out_error:
-	nfs_mark_for_revalidate(dir);
 	d = ERR_PTR(error);
 	goto out;
 }
-- 
2.30.1



