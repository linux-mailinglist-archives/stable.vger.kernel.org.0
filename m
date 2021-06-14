Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B755E3A649D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhFNL0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236362AbhFNLY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281A36141C;
        Mon, 14 Jun 2021 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668069;
        bh=YhkpJ+ytAKaid4pkJZf1IGfNJl1EVja33l+f2A5Vudg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkxXxZDowuIbAFy3SJAh0UXF6ttCAvpCVBAwwe364/Gx3N80wWtcqcronnam1ROmB
         SCqaUfYiobq2ih2BtJmx1eSUvmNTGRFnPtSIeqb1D37+ZU5P2bRin0qDgPYNTFE75t
         B4mCT7m/Fa/alWOKjJzfapcP0mwtcUlEdsWAcSsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.12 168/173] NFSv4: Fix second deadlock in nfs4_evict_inode()
Date:   Mon, 14 Jun 2021 12:28:20 +0200
Message-Id: <20210614102703.769620310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c3aba897c6e67fa464ec02b1f17911577d619713 upstream.

If the inode is being evicted but has to return a layout first, then
that too can cause a deadlock in the corner case where the server
reboots.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9630,15 +9630,20 @@ int nfs4_proc_layoutreturn(struct nfs4_l
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


