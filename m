Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2568F7D72
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfKKS46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730771AbfKKS45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD5D120659;
        Mon, 11 Nov 2019 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498616;
        bh=qJMV2D7zefnFIwYl4xthDJdFX921UiPywST2gBTbYnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxNxCNdMtXxV/d++hmA/eEL8V6ONBCqtm3slawpUX5jeIZTkBFJcYGLC9MztNbL3C
         IyoDllq4UGN6ddsh82wiHhpiiqyYiSu625/EhdqcsMFq1Y0x0r2pfviXmXQ3O/9vbt
         GfMpD4R05ZWC7n0Gw7idZb9AVWVR5FTsfmVZWLes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 171/193] SUNRPC: The TCP back channel mustnt disappear while requests are outstanding
Date:   Mon, 11 Nov 2019 19:29:13 +0100
Message-Id: <20191111181513.741817623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 875f0706accd6501c3209bb99df8573171fb5d75 ]

If there are TCP back channel requests being processed by the
server threads, then we should hold a reference to the transport
to ensure it doesn't get freed from underneath us.

Reported-by: Neil Brown <neilb@suse.de>
Fixes: 2ea24497a1b3 ("SUNRPC: RPC callbacks may be split across several..")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/backchannel_rqst.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 339e8c077c2db..7eb251372f947 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -307,8 +307,8 @@ void xprt_free_bc_rqst(struct rpc_rqst *req)
 		 */
 		dprintk("RPC:       Last session removed req=%p\n", req);
 		xprt_free_allocation(req);
-		return;
 	}
+	xprt_put(xprt);
 }
 
 /*
@@ -339,7 +339,7 @@ found:
 		spin_unlock(&xprt->bc_pa_lock);
 		if (new) {
 			if (req != new)
-				xprt_free_bc_rqst(new);
+				xprt_free_allocation(new);
 			break;
 		} else if (req)
 			break;
@@ -368,6 +368,7 @@ void xprt_complete_bc_request(struct rpc_rqst *req, uint32_t copied)
 	set_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state);
 
 	dprintk("RPC:       add callback request to list\n");
+	xprt_get(xprt);
 	spin_lock(&bc_serv->sv_cb_lock);
 	list_add(&req->rq_bc_list, &bc_serv->sv_cb_list);
 	wake_up(&bc_serv->sv_cb_waitq);
-- 
2.20.1



