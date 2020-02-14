Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F6815F26F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392849AbgBNSJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbgBNPyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CBB12467E;
        Fri, 14 Feb 2020 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695644;
        bh=649NZDVYL+p8ThW/UiVi+KFQPMEzqzfn6phgBIZ5fOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps1HMwNoTxsnMd6eYJ+WCeFIsiamiv2MV5pVFac+0RRrkJBMQvI98K/oXOQz0teLT
         4nUinGzrAenTsOYAfWX4OUONA54C4uLSfx99abIzAc9k4QLT2vkbKTZlPhlR9yKbve
         TZAr+byuEisyKbQFQhl822WssZcWzZ8+RF1u72zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 238/542] nfsd: Clone should commit src file metadata too
Date:   Fri, 14 Feb 2020 10:43:50 -0500
Message-Id: <20200214154854.6746-238-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 57f64034966fb945fc958f95f0c51e47af590344 ]

vfs_clone_file_range() can modify the metadata on the source file too,
so we need to commit that to stable storage as well.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f0bca0e87d0c4..82cf80dde5c71 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -280,19 +280,25 @@ nfsd_lookup(struct svc_rqst *rqstp, struct svc_fh *fhp, const char *name,
  * Commit metadata changes to stable storage.
  */
 static int
-commit_metadata(struct svc_fh *fhp)
+commit_inode_metadata(struct inode *inode)
 {
-	struct inode *inode = d_inode(fhp->fh_dentry);
 	const struct export_operations *export_ops = inode->i_sb->s_export_op;
 
-	if (!EX_ISSYNC(fhp->fh_export))
-		return 0;
-
 	if (export_ops->commit_metadata)
 		return export_ops->commit_metadata(inode);
 	return sync_inode_metadata(inode, 1);
 }
 
+static int
+commit_metadata(struct svc_fh *fhp)
+{
+	struct inode *inode = d_inode(fhp->fh_dentry);
+
+	if (!EX_ISSYNC(fhp->fh_export))
+		return 0;
+	return commit_inode_metadata(inode);
+}
+
 /*
  * Go over the attributes and take care of the small differences between
  * NFS semantics and what Linux expects.
@@ -537,6 +543,9 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 	if (sync) {
 		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
 		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
+
+		if (!status)
+			status = commit_inode_metadata(file_inode(src));
 		if (status < 0)
 			return nfserrno(status);
 	}
-- 
2.20.1

