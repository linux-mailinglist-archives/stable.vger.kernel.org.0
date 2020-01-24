Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC8147ACB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgAXJiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgAXJiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:21 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD2C2070A;
        Fri, 24 Jan 2020 09:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858701;
        bh=QgoDpK1NoP633Jig+gN784oyjinE8a2DFmhizhaghgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szs5zZ/G7FKjDqVZpeVpSPu88CnDO/12YBCd2a6tgAIxuT368rQvoHXIAv7RlGWzJ
         9CujdeZv7WGLvrYgf3bh1Sjh3Hj4HnwvKgPLLFFabshxv2Hc6pTwCCk40lc1pFgvRo
         U2SHvU/SKySCSFi9E8tdOQPTi+hXdJG9olp7wQSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 018/102] SUNRPC: Fix backchannel latency metrics
Date:   Fri, 24 Jan 2020 10:30:19 +0100
Message-Id: <20200124092808.921441399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 8729aaba74626c4ebce3abf1b9e96bb62d2958ca upstream.

I noticed that for callback requests, the reported backlog latency
is always zero, and the rtt value is crazy big. The problem was that
rqst->rq_xtime is never set for backchannel requests.

Fixes: 78215759e20d ("SUNRPC: Make RTT measurement more ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    1 +
 net/sunrpc/xprtsock.c                      |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -195,6 +195,7 @@ rpcrdma_bc_send_request(struct svcxprt_r
 	pr_info("%s: %*ph\n", __func__, 64, rqst->rq_buffer);
 #endif
 
+	rqst->rq_xtime = ktime_get();
 	rc = svc_rdma_bc_sendto(rdma, rqst, ctxt);
 	if (rc) {
 		svc_rdma_send_ctxt_put(rdma, ctxt);
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2659,6 +2659,8 @@ static int bc_sendto(struct rpc_rqst *re
 		.iov_len	= sizeof(marker),
 	};
 
+	req->rq_xtime = ktime_get();
+
 	len = kernel_sendmsg(transport->sock, &msg, &iov, 1, iov.iov_len);
 	if (len != iov.iov_len)
 		return -EAGAIN;
@@ -2684,7 +2686,6 @@ static int bc_send_request(struct rpc_rq
 	struct svc_xprt	*xprt;
 	int len;
 
-	dprintk("sending request with xid: %08x\n", ntohl(req->rq_xid));
 	/*
 	 * Get the server socket associated with this callback xprt
 	 */


