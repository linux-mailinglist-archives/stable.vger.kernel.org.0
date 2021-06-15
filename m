Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8505D3A8503
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhFOPxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhFOPv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE67614A7;
        Tue, 15 Jun 2021 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772194;
        bh=CmVXgWpbCXJDFVwxhL9d3AEhblhMStXv9qLz1jRl/g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw6oJfw1BCEBmoijpYpzy9hOu2qbIG0ehmfbuShMqWLfC+TxsJ7/AIlB3dtUZyVvX
         6HWeg4HP0kCnpCf39rXBdcZhRiZz042rIelCB4vJ6SduY6yNOMVwjGUF8zIv33m6Zo
         TF4gqtkDoHB8Lq9YJkJUl/e+2p6XJd+BIQQvSiAmO7I07eCgKmjLwRQtJYpQd5LuYy
         xuaNmXIB+LCnfB3ja7e5h2q6Sr0P0qdMMPpKtgQMVDtjPRWQMCh5pWpkuaWxsZMXXG
         9lx3rcDIJIki4xyOZzW1cYP9vd5W1cLPPrcwqNUo1fs0QEmabGD63dmOgA6tj914ob
         GgTmFWRktrxZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/15] NFSv4: Fix second deadlock in nfs4_evict_inode()
Date:   Tue, 15 Jun 2021 11:49:37 -0400
Message-Id: <20210615154948.62711-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154948.62711-1-sashal@kernel.org>
References: <20210615154948.62711-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c3aba897c6e67fa464ec02b1f17911577d619713 ]

If the inode is being evicted but has to return a layout first, then
that too can cause a deadlock in the corner case where the server
reboots.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0b842b0d07c1..b7e5f2a6a4ce 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9340,15 +9340,20 @@ int nfs4_proc_layoutreturn(struct nfs4_layoutreturn *lrp, bool sync)
 			&task_setup_data.rpc_client, &msg);
 
 	dprintk("--> %s\n", __func__);
+	lrp->inode = nfs_igrab_and_active(lrp->args.inode);
 	if (!sync) {
-		lrp->inode = nfs_igrab_and_active(lrp->args.inode);
 		if (!lrp->inode) {
 			nfs4_layoutreturn_release(lrp);
 			return -EAGAIN;
 		}
 		task_setup_data.flags |= RPC_TASK_ASYNC;
 	}
-	nfs4_init_sequence(&lrp->args.seq_args, &lrp->res.seq_res, 1, 0);
+	if (!lrp->inode)
+		nfs4_init_sequence(&lrp->args.seq_args, &lrp->res.seq_res, 1,
+				   1);
+	else
+		nfs4_init_sequence(&lrp->args.seq_args, &lrp->res.seq_res, 1,
+				   0);
 	task = rpc_run_task(&task_setup_data);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
-- 
2.30.2

