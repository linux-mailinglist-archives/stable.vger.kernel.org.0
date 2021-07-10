Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB45B3C37C5
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhGJXxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhGJXwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C71C61107;
        Sat, 10 Jul 2021 23:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960993;
        bh=tG28A/PNpdedarnCsHUd8/ebDWeETTHpF6R9CbgKNfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLat45rIC54iEBEIUZBvASAC+sbDKkPTlmz3nVu+jKmaR3JhHhIJa3RfIOJD5WFjo
         TkQ41ljxw5L9CmiInjSrX20/A+KSHmC4x3aHmp8qJJ5g3ZCIojhfRqj1+F+yybWfme
         nwwYvPRocuz58wXNcH1F0+CHhdp7SqYB08sTxU8KTtzhDg50IyjE+jDvt8UYHaIcMR
         UxXiniIgdxtnaQ71Tk9Fbv4gcNFT4k/mGOggHMO8W12skgxabG888V6xzo+aNi887I
         m+q/DpquokYqQHF5QzSyXJzvr7FjRLs6g/2fBHYnWpSpPWetVDZCyEUUsKP26RscOt
         csSvtLY4RD40Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 26/43] NFS: nfs_find_open_context() may only select open files
Date:   Sat, 10 Jul 2021 19:48:58 -0400
Message-Id: <20210710234915.3220342-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
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
index ae8bc84e39fb..6b1f2bf65bee 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1079,6 +1079,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -1098,6 +1099,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, const struct
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		if (ctx)
 			break;
@@ -1113,6 +1116,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index eadaabd18dc7..be9eadd23659 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -84,6 +84,7 @@ struct nfs_open_context {
 #define NFS_CONTEXT_RESEND_WRITES	(1)
 #define NFS_CONTEXT_BAD			(2)
 #define NFS_CONTEXT_UNLOCK	(3)
+#define NFS_CONTEXT_FILE_OPEN		(4)
 	int error;
 
 	struct list_head list;
-- 
2.30.2

