Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58183C38A9
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhGJXzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233534AbhGJXyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D710613E3;
        Sat, 10 Jul 2021 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961090;
        bh=8EAEEwHzntHAjewmLlMUd5xDVbMCNag9jK8Gqcya/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOcEwAtqGb0FwEKFW89WJztK0VNroIhND4kFWfIe535uNoEDHlUYkVdznn9xB7j4W
         gS92Kq4dOd6mxq4hu9Mrbukp61EGg6I/OIZ1oTQopxp3PLzBinlvMeMVWniQ1v3Y3T
         2+J8uXoTD4N8ZAVw7roDSB7RS5gPtFkbknYxBjl6DW5xjfVQczg0rwaPwpYE5NsZTw
         vmM3QJ0OFnfYIAApzuO9n+k9GU2MKHQ4uIyWW59JjOq/9S/TqhaQYWW8DjqFQc92sJ
         Kzf0FjIRjuU2oRBgT+JFXLBMjhIm5RqfPbpmr1xe0Li64C/7rn1oGOgOy4auldVz/l
         X2e0ubWWPyuDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/28] NFS: nfs_find_open_context() may only select open files
Date:   Sat, 10 Jul 2021 19:50:57 -0400
Message-Id: <20210710235107.3221840-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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

