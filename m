Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67304F7D75
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfKKS5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbfKKS5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2B720659;
        Mon, 11 Nov 2019 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498620;
        bh=mYlaCVYg9rolJoPN4lknTJh4sLZ+CqjFaF0axUGNGzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8yNWncZbj/PVB+6GMAKiq4SXn/dJjpi+pruaj4Z93aVJ5ad78o4OOeLY5eHeZzf0
         GrpoddUXQ8h2bQw7qkSQHjHK/+Tv2CqFJhMww7G8+R7zjc7PnL7hRxo5rM8DWwk00f
         7ORmn92i80iC/c67vKAFwH563KVmTIoZnadzOY7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 172/193] SUNRPC: The RDMA back channel mustnt disappear while requests are outstanding
Date:   Mon, 11 Nov 2019 19:29:14 +0100
Message-Id: <20191111181513.812361342@linuxfoundation.org>
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

[ Upstream commit 9edb455e6797bb50aa38ef71e62668966065ede8 ]

If there are RDMA back channel requests being processed by the
server threads, then we should hold a reference to the transport
to ensure it doesn't get freed from underneath us.

Reported-by: Neil Brown <neilb@suse.de>
Fixes: 63cae47005af ("xprtrdma: Handle incoming backward direction RPC calls")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/backchannel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index 59e624b1d7a0d..7cccaab9a17ae 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -165,6 +165,7 @@ void xprt_rdma_bc_free_rqst(struct rpc_rqst *rqst)
 	spin_lock(&xprt->bc_pa_lock);
 	list_add_tail(&rqst->rq_bc_pa_list, &xprt->bc_pa_list);
 	spin_unlock(&xprt->bc_pa_lock);
+	xprt_put(xprt);
 }
 
 static struct rpc_rqst *rpcrdma_bc_rqst_get(struct rpcrdma_xprt *r_xprt)
@@ -261,6 +262,7 @@ void rpcrdma_bc_receive_call(struct rpcrdma_xprt *r_xprt,
 
 	/* Queue rqst for ULP's callback service */
 	bc_serv = xprt->bc_serv;
+	xprt_get(xprt);
 	spin_lock(&bc_serv->sv_cb_lock);
 	list_add(&rqst->rq_bc_list, &bc_serv->sv_cb_list);
 	spin_unlock(&bc_serv->sv_cb_lock);
-- 
2.20.1



