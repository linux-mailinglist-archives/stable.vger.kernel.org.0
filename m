Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C473B3A853B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFOPyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhFOPwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9343161919;
        Tue, 15 Jun 2021 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772214;
        bh=EcbJQsvnORwJMP0Yx4pWP10TLcJG/R30oqcGJrTVRSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHw5H1WJKWRbrEOptdbJo8bXkUmCyZPOx3Dw6a1C6yHGKDtrNwuPaKr6ywUAE5Izd
         BL1qAvPGt4AGygOcqed5quX9EyvfVgqBgHrXNbMjqsNd8IyeRGGgN3g5O7YDH36O/U
         8MuGmOscoNYD0GIeK4PdbhdFV9zQgN4r8c5dGjajNuUxNofQe1jAYmHerYF7kwOtQo
         84FNBPKY+lOXYmBbQD5z/pWJl39+mtClQzftP99kE6qOOSo4qW8c1UjKFYT2GCC8i3
         /m2mN7SxuUGmFlMfqiNVMW0YwXEAcCbj2K6ZLa69opN/byaW94F+Tx0llP7ijGawT4
         tFixdan0LdokQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/12] NFSv4: Fix second deadlock in nfs4_evict_inode()
Date:   Tue, 15 Jun 2021 11:50:00 -0400
Message-Id: <20210615155009.62894-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155009.62894-1-sashal@kernel.org>
References: <20210615155009.62894-1-sashal@kernel.org>
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
index c0b314e0a9e5..6acfa1ecf3b4 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9065,15 +9065,20 @@ int nfs4_proc_layoutreturn(struct nfs4_layoutreturn *lrp, bool sync)
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

