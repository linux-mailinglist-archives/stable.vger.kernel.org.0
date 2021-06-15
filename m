Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845BC3A84C4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhFOPv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232128AbhFOPvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE39616ED;
        Tue, 15 Jun 2021 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772168;
        bh=RUHcFzP7JEmRgQ8Y5ojMdQlxqPAruhth2Tfc16/Sclc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfoqwkQU/bulmt85XFrnP3CmiOff9Wl6Ix8cOVOTG7hw3iq7VtV9MxtfEsVNelmZ4
         6KyBQuki13mCUawtAiiHnewU2NTU0Q6KX/69eP+pAsr1RYgp54bVbkClnluheBjTM9
         3sYwNFruBV/rdoo/6fmAvAWCYFytSe/fUfsa1GD7M+AmmWoRWRT/gGN49NufbxLj4r
         FHkRyd0JeTGBo/YVLXN31nxcEBTnL6saxZ392sVbB6rJuTPXVGquLOSqu/hiEmPwW0
         2THGcW/OdkqvZnzAtF/IMpv7ez2QRByBLxyLlC4n187d4B+zirrcp+b14LEUlzO9RP
         LPUhzfi3xpzUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/30] NFSv4: Fix second deadlock in nfs4_evict_inode()
Date:   Tue, 15 Jun 2021 11:48:53 -0400
Message-Id: <20210615154908.62388-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
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
index 0a0b7680ea85..f387b34bc5e5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9627,15 +9627,20 @@ int nfs4_proc_layoutreturn(struct nfs4_layoutreturn *lrp, bool sync)
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

