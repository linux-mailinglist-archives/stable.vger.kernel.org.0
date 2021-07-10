Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1183C3930
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhGJX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhGJX4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3840A6140A;
        Sat, 10 Jul 2021 23:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961149;
        bh=Frbua5mjATbdfTC7wpGkH32YHrqyla04y8rGKfbuAk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLG8UNSea2XjLtU4NB9t2Q4JwMNLZFm1hEO5JOMwa+BydzBXcNjxNxUa1P9eUr+bX
         Ovn01hWcTWXg1ZJPLDuRMgCV1n4YtzOmmI2T/9BpPnC6STCFwBn57fh2/5KiLuomnc
         Ww6b5n40WqP8GdtWTb2Q+WH7HsbemTewIewZ++pQcxspuwIZq+KFwuNF82EZipzWs6
         /T81eskWtcjGLTmb/EbanL68qhlKwx/9ta+5Flq0dYPi62sJ+WPrUnpxROtJiBfRX4
         tRiT0aLdNxlkh7zU+0CrI1uP4kPKoI9MFw9iCf8wpE4mCbmZjLwpTbjKSGRJdikt2N
         DgaK6JibLRwIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/21] NFS: nfs_find_open_context() may only select open files
Date:   Sat, 10 Jul 2021 19:52:04 -0400
Message-Id: <20210710235212.3222375-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
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
index 33cc69687792..ad01d4fb795e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -972,6 +972,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -991,6 +992,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, struct rpc_c
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		break;
 	}
@@ -1005,6 +1008,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f0015f801a78..e51292d9e1a2 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -77,6 +77,7 @@ struct nfs_open_context {
 #define NFS_CONTEXT_RESEND_WRITES	(1)
 #define NFS_CONTEXT_BAD			(2)
 #define NFS_CONTEXT_UNLOCK	(3)
+#define NFS_CONTEXT_FILE_OPEN		(4)
 	int error;
 
 	struct list_head list;
-- 
2.30.2

