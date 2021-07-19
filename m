Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2F43CDFC0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345409AbhGSPLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345817AbhGSPJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CEF2613D2;
        Mon, 19 Jul 2021 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709761;
        bh=8EAEEwHzntHAjewmLlMUd5xDVbMCNag9jK8Gqcya/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYWYXyQCmCMMPccNcuvOHP0fTimi3pBTkgC8acTx5i5Tc9mC0wApN21J66GM6rK0Q
         mx0YJZY9cqXC/+GeyuiM2hK/wtkbNf1Mw7BaAAYLGLspE16GanfMgq3T/LHVNAdfCE
         ZU5ov1vqH+rQUt0zGMNtrhRkPw85SAHJ0r7OcNP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/149] NFS: nfs_find_open_context() may only select open files
Date:   Mon, 19 Jul 2021 16:53:14 +0200
Message-Id: <20210719144921.716600975@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8c0f916380c4..209263c0c537 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1048,6 +1048,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -1067,6 +1068,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, const struct
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		if (ctx)
 			break;
@@ -1082,6 +1085,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index ad09c0cc5464..978ef674f038 100644
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



