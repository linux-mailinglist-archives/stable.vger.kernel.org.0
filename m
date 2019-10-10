Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E276D2598
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387686AbfJJIli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfJJIlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17FBC21BE5;
        Thu, 10 Oct 2019 08:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696895;
        bh=GvEPbDgQxapmgW0q9BULFA69h7ReMstEhRs3fqcCj8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+Pe5nTX0oQj3bgt+YnxQKG+LgVc72dm+ZdhBilH9LsCfSaiVt9CylFKomwtibuZb
         gKHdjhQw7RdTV/T0KjhA/u6lsydAF8K+7s4pwIUPYD3faakLWCbhKcmRyeBMnG9V9X
         hNaJg3ExHpW/Cxg20L75HF1ueDmG6OpDJwcW7ppc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Dorfman <eli@vastdata.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 093/148] xprtrdma: Send Queue size grows after a reconnect
Date:   Thu, 10 Oct 2019 10:35:54 +0200
Message-Id: <20191010083616.942084770@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 98ef77d1aaa7a2f4e1b2a721faa084222021fda7 ]

Eli Dorfman reports that after a series of idle disconnects, an
RPC/RDMA transport becomes unusable (rdma_create_qp returns
-ENOMEM). Problem was tracked down to increasing Send Queue size
after each reconnect.

The rdma_create_qp() API does not promise to leave its @qp_init_attr
parameter unaltered. In fact, some drivers do modify one or more of
its fields. Thus our calls to rdma_create_qp must use a fresh copy
of ib_qp_init_attr each time.

This fix is appropriate for kernels dating back to late 2007, though
it will have to be adapted, as the connect code has changed over the
years.

Reported-by: Eli Dorfman <eli@vastdata.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 805b1f35e1caa..2bd9b4de0e325 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -605,10 +605,10 @@ void rpcrdma_ep_destroy(struct rpcrdma_xprt *r_xprt)
  * Unlike a normal reconnection, a fresh PD and a new set
  * of MRs and buffers is needed.
  */
-static int
-rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
-			 struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
+static int rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
+				    struct ib_qp_init_attr *qp_init_attr)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	int rc, err;
 
 	trace_xprtrdma_reinsert(r_xprt);
@@ -625,7 +625,7 @@ rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
 	}
 
 	rc = -ENETUNREACH;
-	err = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
+	err = rdma_create_qp(ia->ri_id, ia->ri_pd, qp_init_attr);
 	if (err) {
 		pr_err("rpcrdma: rdma_create_qp returned %d\n", err);
 		goto out3;
@@ -642,16 +642,16 @@ rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
 	return rc;
 }
 
-static int
-rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt, struct rpcrdma_ep *ep,
-		     struct rpcrdma_ia *ia)
+static int rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt,
+				struct ib_qp_init_attr *qp_init_attr)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rdma_cm_id *id, *old;
 	int err, rc;
 
 	trace_xprtrdma_reconnect(r_xprt);
 
-	rpcrdma_ep_disconnect(ep, ia);
+	rpcrdma_ep_disconnect(&r_xprt->rx_ep, ia);
 
 	rc = -EHOSTUNREACH;
 	id = rpcrdma_create_id(r_xprt, ia);
@@ -673,7 +673,7 @@ rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt, struct rpcrdma_ep *ep,
 		goto out_destroy;
 	}
 
-	err = rdma_create_qp(id, ia->ri_pd, &ep->rep_attr);
+	err = rdma_create_qp(id, ia->ri_pd, qp_init_attr);
 	if (err)
 		goto out_destroy;
 
@@ -698,25 +698,27 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 	struct rpcrdma_xprt *r_xprt = container_of(ia, struct rpcrdma_xprt,
 						   rx_ia);
 	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
+	struct ib_qp_init_attr qp_init_attr;
 	int rc;
 
 retry:
+	memcpy(&qp_init_attr, &ep->rep_attr, sizeof(qp_init_attr));
 	switch (ep->rep_connected) {
 	case 0:
 		dprintk("RPC:       %s: connecting...\n", __func__);
-		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
+		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &qp_init_attr);
 		if (rc) {
 			rc = -ENETUNREACH;
 			goto out_noupdate;
 		}
 		break;
 	case -ENODEV:
-		rc = rpcrdma_ep_recreate_xprt(r_xprt, ep, ia);
+		rc = rpcrdma_ep_recreate_xprt(r_xprt, &qp_init_attr);
 		if (rc)
 			goto out_noupdate;
 		break;
 	default:
-		rc = rpcrdma_ep_reconnect(r_xprt, ep, ia);
+		rc = rpcrdma_ep_reconnect(r_xprt, &qp_init_attr);
 		if (rc)
 			goto out;
 	}
-- 
2.20.1



