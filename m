Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB22A52FB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbgKCUzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732671AbgKCUzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2EF8223BD;
        Tue,  3 Nov 2020 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436906;
        bh=4Jxw72oNKrHSViVlrye7VjWtEQ+cRo52KU5GDCZ1/bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCjNBCGXhUfrHl2/WEF47pFvUa/Gve1HscGZ89z9fja/K4ahBwHRsmIGs3XUhwWad
         3I2R55jPTwBvIumVlKGy9EyG4ZmgwL00HDOCPhhUBaopK2P+UUcUAL6vGys5WkwTRk
         2Ku3PMlYPdaG0jkngH8gPmTeYEvkk305qOPxPNz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/214] SUNRPC: Mitigate cond_resched() in xprt_transmit()
Date:   Tue,  3 Nov 2020 21:35:09 +0100
Message-Id: <20201103203256.087374718@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6f9f17287e78e5049931af2037b15b26d134a32a ]

The original purpose of this expensive call is to prevent a long
queue of requests from blocking other work.

The cond_resched() call is unnecessary after just a single send
operation.

For longer queues, instead of invoking the kernel scheduler, simply
release the transport send lock and return to the RPC scheduler.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 41df4c507193b..a6fee86f400ec 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1503,10 +1503,13 @@ xprt_transmit(struct rpc_task *task)
 {
 	struct rpc_rqst *next, *req = task->tk_rqstp;
 	struct rpc_xprt	*xprt = req->rq_xprt;
-	int status;
+	int counter, status;
 
 	spin_lock(&xprt->queue_lock);
+	counter = 0;
 	while (!list_empty(&xprt->xmit_queue)) {
+		if (++counter == 20)
+			break;
 		next = list_first_entry(&xprt->xmit_queue,
 				struct rpc_rqst, rq_xmit);
 		xprt_pin_rqst(next);
@@ -1514,7 +1517,6 @@ xprt_transmit(struct rpc_task *task)
 		status = xprt_request_transmit(next, task);
 		if (status == -EBADMSG && next != req)
 			status = 0;
-		cond_resched();
 		spin_lock(&xprt->queue_lock);
 		xprt_unpin_rqst(next);
 		if (status == 0) {
-- 
2.27.0



