Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E19E2BFA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJXIVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 04:21:14 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:39342 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfJXIVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 04:21:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=zhangliguang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tg2DzuL_1571905262;
Received: from localhost(mailfrom:zhangliguang@linux.alibaba.com fp:SMTPD_---0Tg2DzuL_1571905262)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 16:21:10 +0800
From:   luanshi <zhangliguang@linux.alibaba.com>
To:     Xunlei Pang <xlpang@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     alikernel-developer@linux.alibaba.com, NeilBrown <neilb@suse.com>,
        stable@vger.kernel.org (v3.18+),
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        luanshi <zhangliguang@linux.alibaba.com>
Subject: [PATCH 7u 15/15] NFS: only invalidate dentrys that are clearly invalid.
Date:   Thu, 24 Oct 2019 16:20:02 +0800
Message-Id: <1571905202-28331-7-git-send-email-zhangliguang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571905202-28331-1-git-send-email-zhangliguang@linux.alibaba.com>
References: <1571905202-28331-1-git-send-email-zhangliguang@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

commit cc89684c9a265828ce061037f1f79f4a68ccd3f7 upstream

Since commit bafc9b754f75 ("vfs: More precise tests in d_invalidate")
in v3.18, a return of '0' from ->d_revalidate() will cause the dentry
to be invalidated even if it has filesystems mounted on or it or on a
descendant.  The mounted filesystem is unmounted.

This means we need to be careful not to return 0 unless the directory
referred to truly is invalid.  So -ESTALE or -ENOENT should invalidate
the directory.  Other errors such a -EPERM or -ERESTARTSYS should be
returned from ->d_revalidate() so they are propagated to the caller.

A particular problem can be demonstrated by:

1/ mount an NFS filesystem using NFSv3 on /mnt
2/ mount any other filesystem on /mnt/foo
3/ ls /mnt/foo
4/ turn off network, or otherwise make the server unable to respond
5/ ls /mnt/foo &
6/ cat /proc/$!/stack # note that nfs_lookup_revalidate is in the call stack
7/ kill -9 $! # this results in -ERESTARTSYS being returned
8/ observe that /mnt/foo has been unmounted.

This patch changes nfs_lookup_revalidate() to only treat
  -ESTALE from nfs_lookup_verify_inode() and
  -ESTALE or -ENOENT from ->lookup()
as indicating an invalid inode.  Other errors are returned.

Also nfs_check_inode_attributes() is changed to return -ESTALE rather
than -EIO.  This is consistent with the error returned in similar
circumstances from nfs_update_inode().

As this bug allows any user to unmount a filesystem mounted on an NFS
filesystem, this fix is suitable for stable kernels.

Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
Cc: stable@vger.kernel.org (v3.18+)
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: luanshi <zhangliguang@linux.alibaba.com>
---
 7u/fs/nfs/dir.c   | 12 ++++++++----
 7u/fs/nfs/inode.c |  4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/7u/fs/nfs/dir.c b/7u/fs/nfs/dir.c
index 4532d58..dae382a 100644
--- a/7u/fs/nfs/dir.c
+++ b/7u/fs/nfs/dir.c
@@ -1239,11 +1239,13 @@ static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 	/* Force a full look up iff the parent directory has changed */
 	if (!nfs_is_exclusive_create(dir, flags) &&
 	    nfs_check_verifier(dir, dentry, flags & LOOKUP_RCU)) {
-
-		if (nfs_lookup_verify_inode(inode, flags)) {
+		error = nfs_lookup_verify_inode(inode, flags);
+		if (error) {
 			if (flags & LOOKUP_RCU)
 				return -ECHILD;
-			goto out_zap_parent;
+			if (error == -ESTALE)
+				goto out_zap_parent;
+			goto out_error;
 		}
 		goto out_valid;
 	}
@@ -1267,8 +1269,10 @@ static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 	trace_nfs_lookup_revalidate_enter(dir, dentry, flags);
 	error = NFS_PROTO(dir)->lookup(dir, &dentry->d_name, fhandle, fattr, label);
 	trace_nfs_lookup_revalidate_exit(dir, dentry, flags, error);
-	if (error)
+	if (error == -ESTALE || error == -ENOENT)
 		goto out_bad;
+	if (error)
+		goto out_error;
 	if (nfs_compare_fh(NFS_FH(inode), fhandle))
 		goto out_bad;
 	if ((error = nfs_refresh_inode(inode, fattr)) != 0)
diff --git a/7u/fs/nfs/inode.c b/7u/fs/nfs/inode.c
index 010d0b9..b3a4a25 100644
--- a/7u/fs/nfs/inode.c
+++ b/7u/fs/nfs/inode.c
@@ -1214,9 +1214,9 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 		return 0;
 	/* Has the inode gone and changed behind our back? */
 	if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid)
-		return -EIO;
+		return -ESTALE;
 	if ((fattr->valid & NFS_ATTR_FATTR_TYPE) && (inode->i_mode & S_IFMT) != (fattr->mode & S_IFMT))
-		return -EIO;
+		return -ESTALE;
 
 	if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 &&
 			inode->i_version != fattr->change_attr)
-- 
1.8.3.1

