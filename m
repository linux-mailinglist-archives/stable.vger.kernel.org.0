Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60513D2359
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfJJIle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388366AbfJJIld (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E892054F;
        Thu, 10 Oct 2019 08:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696892;
        bh=Hi/MFaaJ5GWhVSa+IqBly6KzXkJMtUWh1MbotqnxbIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaTr99hNFC+k42qmaqCPZt+PeStcD/bDJGyZEhLeAcNNjWZIslves+PswKLCUDoTr
         +aXelasMQy60mlrJSqklRKXJhluprUh0T5uA9/Bl/qvZO2bd69sE4oZHe3FDXIxH91
         Zi2vkZ8z/zqu4BrRMNYrxa5B5UTsscWmDJIs5Qm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 092/148] xprtrdma: Toggle XPRT_CONGESTED in xprtrdmas slot methods
Date:   Thu, 10 Oct 2019 10:35:53 +0200
Message-Id: <20191010083616.889035683@linuxfoundation.org>
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

[ Upstream commit 395790566eec37706dedeb94779045adc3a7581e ]

Commit 48be539dd44a ("xprtrdma: Introduce ->alloc_slot call-out for
xprtrdma") added a separate alloc_slot and free_slot to the RPC/RDMA
transport. Later, commit 75891f502f5f ("SUNRPC: Support for
congestion control when queuing is enabled") modified the generic
alloc/free_slot methods, but neglected the methods in xprtrdma.

Found via code review.

Fixes: 75891f502f5f ("SUNRPC: Support for congestion control ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 2ec349ed47702..f4763e8a67617 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -571,6 +571,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
+	set_bit(XPRT_CONGESTED, &xprt->state);
 	rpc_sleep_on(&xprt->backlog, task, NULL);
 	task->tk_status = -EAGAIN;
 }
@@ -589,7 +590,8 @@ xprt_rdma_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *rqst)
 
 	memset(rqst, 0, sizeof(*rqst));
 	rpcrdma_buffer_put(&r_xprt->rx_buf, rpcr_to_rdmar(rqst));
-	rpc_wake_up_next(&xprt->backlog);
+	if (unlikely(!rpc_wake_up_next(&xprt->backlog)))
+		clear_bit(XPRT_CONGESTED, &xprt->state);
 }
 
 static bool rpcrdma_check_regbuf(struct rpcrdma_xprt *r_xprt,
-- 
2.20.1



