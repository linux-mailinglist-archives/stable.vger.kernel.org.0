Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F073C3838
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhGJXyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233376AbhGJXxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CC6A61360;
        Sat, 10 Jul 2021 23:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961050;
        bh=zajbBKPGpujZyJvo4+A/KkvmCO7W7Bjjtw+Zlqn4ezU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKKR4ZEDV4JW2IdjZ027LBTL0taLg3BxTNHAc6z3gmiVTIoorXdIPtDe765Cg6jGz
         52BGKyH8xR06+bkfOwjs4/X5ryyh/ZbYRTQAvcBcGC5D7/K/yx948vmQ8nbfxRQM/l
         QCo4JLbrCKwq+V5gvr/0po0gQtr7ROdWZ+xrt5EXpoyvQe8bTFyHqRZKlY8gJciMF3
         pt80aK4Tsb17zjoTh7Hsler/hbFyhRzjHH8cPHT/kPz+QnacQYSP5jj4pGc94fA24S
         foBICyqC7ewY+mbRKUzrmsj9zMbm02LfeBZzcM4WVvnuXBKUF0HwtGF5k9YnC0Qg7c
         xCEw9jS3bx/4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/37] NFS: nfs_find_open_context() may only select open files
Date:   Sat, 10 Jul 2021 19:50:03 -0400
Message-Id: <20210710235016.3221124-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e97bc66377bca097e1f3349ca18ca17f202ff659 ]

If a file has already been closed, then it should not be selected to
support further I/O.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[Trond: Fix an invalid pointer deref reported by Colin Ian King]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c         | 4 ++++
 include/linux/nfs_fs.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index dc2cbca98fb0..9811880470a0 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1064,6 +1064,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -1083,6 +1084,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, const struct
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		if (ctx)
 			break;
@@ -1098,6 +1101,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index a2c6455ea3fa..91a6525a98cb 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -79,6 +79,7 @@ struct nfs_open_context {
 #define NFS_CONTEXT_RESEND_WRITES	(1)
 #define NFS_CONTEXT_BAD			(2)
 #define NFS_CONTEXT_UNLOCK	(3)
+#define NFS_CONTEXT_FILE_OPEN		(4)
 	int error;
 
 	struct list_head list;
-- 
2.30.2

