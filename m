Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A396F3C38EE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhGJX4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhGJXzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75CFE61412;
        Sat, 10 Jul 2021 23:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961122;
        bh=6IYPfWE+5IeR/dEkm7wv/Js5ccM0uPOpf+6BdWqZWuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9gzFWkg5CnYM42X/0FdRv7rCjf6/1gE1BPIbqQxfhh24BtECr68rLw0rQ6somRR5
         PuGuuX+erC1hbGFri29DUylq3EisjIfOiX9ohWjGdJsuSSQowhTmFrVVqHRcgLq4It
         4Kw3vW40J98QOf42n7ApDrfwe9iu+7h6r7WjHcRq9+9RHKTuZmRqeKmmPMTN5FevVZ
         hUlO1SF6mWGv17ws6DgexwM9TjpuVC3ugdncA+FcZbdc3a0FmSAe6c5xdLKFsfviL7
         CoMv5W1RI0P1YScmubb6gYGaLbjEM03QRAACn/yK8jNOUQsdYarutEGJBpsxtdCKLM
         LqLHVCND1BveA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/22] NFS: nfs_find_open_context() may only select open files
Date:   Sat, 10 Jul 2021 19:51:35 -0400
Message-Id: <20210710235143.3222129-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
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
index dc55ecc3bec4..2cdd8883b7c5 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1038,6 +1038,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -1057,6 +1058,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, struct rpc_c
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		break;
 	}
@@ -1071,6 +1074,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index a0831e9d19c9..0ff7dd2bf8a4 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -78,6 +78,7 @@ struct nfs_open_context {
 #define NFS_CONTEXT_RESEND_WRITES	(1)
 #define NFS_CONTEXT_BAD			(2)
 #define NFS_CONTEXT_UNLOCK	(3)
+#define NFS_CONTEXT_FILE_OPEN		(4)
 	int error;
 
 	struct list_head list;
-- 
2.30.2

