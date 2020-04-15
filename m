Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9701AA093
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369372AbgDOM2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409111AbgDOLpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB4920732;
        Wed, 15 Apr 2020 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951102;
        bh=YXatwA0IzgcsJ9gEYbMuYDXR5EsegBs5QetUF828Olk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8pOR6xPcOAKw45FutThlXPnIwxhKMEpTRrDEd5xrpc6YIwZ27K27q2n4FS8wSR2o
         VjOHk4qGvoaNVL77cCvSO36e6HTnUa3/s/id0L7qdT943llKG52U85fOiaD8QBuAR1
         mUCsuyZRpN/tryLZ+xDnFy8MjTrt5WGCfEhgLhq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/84] NFS: alloc_nfs_open_context() must use the file cred when available
Date:   Wed, 15 Apr 2020 07:43:34 -0400
Message-Id: <20200415114442.14166-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1d179d6bd67369a52edea8562154b31ee20be1cc ]

If we're creating a nfs_open_context() for a specific file pointer,
we must use the cred assigned to that file.

Fixes: a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 2a03bfeec10a4..3802c88e83720 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -959,16 +959,16 @@ struct nfs_open_context *alloc_nfs_open_context(struct dentry *dentry,
 						struct file *filp)
 {
 	struct nfs_open_context *ctx;
-	const struct cred *cred = get_current_cred();
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx) {
-		put_cred(cred);
+	if (!ctx)
 		return ERR_PTR(-ENOMEM);
-	}
 	nfs_sb_active(dentry->d_sb);
 	ctx->dentry = dget(dentry);
-	ctx->cred = cred;
+	if (filp)
+		ctx->cred = get_cred(filp->f_cred);
+	else
+		ctx->cred = get_current_cred();
 	ctx->ll_cred = NULL;
 	ctx->state = NULL;
 	ctx->mode = f_mode;
-- 
2.20.1

