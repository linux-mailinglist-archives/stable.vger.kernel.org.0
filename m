Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED0822686F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbgGTQMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbgGTQMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A8020684;
        Mon, 20 Jul 2020 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261522;
        bh=nHFcYKuESz6YGPy3IhjNj1H/CLmIVkZlIyzW7Y8HBHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJtRPLTiAjQmtW/695V/7V+XNetRNFC6r2vb1JRhSPxTFVjxbIHYDjWpmJncp5bz1
         8QH29NQ3HBQb2O/WpHU4ulCaDnRRZyz5Uk9B4aZF8zGvJXEaDqu+lkGMZU7EtW7wct
         5OHyHLpRGkk7uC+UaqcyJ7OUiO6wf3MhNDD+JJaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 105/244] xprtrdma: Fix return code from rpcrdma_xprt_connect()
Date:   Mon, 20 Jul 2020 17:36:16 +0200
Message-Id: <20200720152830.823401261@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dda9a951dd6dd6073bbaf2c8d3119da2f8fe2d5b ]

I noticed that when rpcrdma_xprt_connect() returns -ENOMEM,
instead of retrying the connect, the RPC client kills the
RPC task that requested the connection. We want a retry
here.

Fixes: cb586decbb88 ("xprtrdma: Make sendctx queue lifetime the same as connection lifetime")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 00ee62579137b..220c2d2eeb3e5 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -398,7 +398,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 
 	ep = kzalloc(sizeof(*ep), GFP_NOFS);
 	if (!ep)
-		return -EAGAIN;
+		return -ENOTCONN;
 	ep->re_xprt = &r_xprt->rx_xprt;
 	kref_init(&ep->re_kref);
 
@@ -534,10 +534,6 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 	rpcrdma_ep_get(ep);
 	rpcrdma_post_recvs(r_xprt, true);
 
-	rc = rpcrdma_sendctxs_create(r_xprt);
-	if (rc)
-		goto out;
-
 	rc = rdma_connect(ep->re_id, &ep->re_remote_cma);
 	if (rc)
 		goto out;
@@ -551,9 +547,17 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 		goto out;
 	}
 
+	rc = rpcrdma_sendctxs_create(r_xprt);
+	if (rc) {
+		rc = -ENOTCONN;
+		goto out;
+	}
+
 	rc = rpcrdma_reqs_setup(r_xprt);
-	if (rc)
+	if (rc) {
+		rc = -ENOTCONN;
 		goto out;
+	}
 	rpcrdma_mrs_create(r_xprt);
 
 out:
-- 
2.25.1



