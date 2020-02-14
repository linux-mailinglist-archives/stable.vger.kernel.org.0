Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66B015DEEF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390392AbgBNQGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:06:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390386AbgBNQGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64042187F;
        Fri, 14 Feb 2020 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696379;
        bh=yBlDfK0Mudw/4zVvE2Xj4NPpTKUWG5OSwDqj4f9zWs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVLofO0E5D9EVGi3knAChFC/mcSIHtDDMSg62n3WjO6gikX2m23BmuonRpYpZv8iG
         be5CG4fx+8X7RYZFmZ0PyHlMdTuugPT09AKuAC9sBNbfTqNqktJ52DideX399RY+YY
         BuUPgFR4Vc6mDtbRAHnnljy7NKn+NLA6oX5ck3YI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 207/459] nfsd: Clone should commit src file metadata too
Date:   Fri, 14 Feb 2020 10:57:37 -0500
Message-Id: <20200214160149.11681-207-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index fc38b9fe45495..005d1802ab40e 100644
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

