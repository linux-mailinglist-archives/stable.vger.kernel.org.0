Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCFC3A622B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhFNK45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhFNKyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:54:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F4D61421;
        Mon, 14 Jun 2021 10:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667233;
        bh=bfOx840UlMxdmMXX6b+SvDRfCUz5JLk4e5sCadeekFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3bPypBspYUUDguBFTuom/0zXmfA9cJLIy/rO45c/vPX0jJ4xGfAbNvGf1QBRQnY5
         pSmpND1GNsDrRdhlJOMk0sQjBMwgZbbV53XcZn6fEwIleaZxu4hWGWDWixWgQnsr6e
         rcn1lBrsWZMo8e/WGDTah/dF4zYU1Rc88E2N/kf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 77/84] NFSv4: Fix second deadlock in nfs4_evict_inode()
Date:   Mon, 14 Jun 2021 12:27:55 +0200
Message-Id: <20210614102648.987021905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
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
@@ -9342,15 +9342,20 @@ int nfs4_proc_layoutreturn(struct nfs4_l
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


