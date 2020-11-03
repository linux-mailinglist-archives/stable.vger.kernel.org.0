Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0422A592F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgKCUmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgKCUmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD15922226;
        Tue,  3 Nov 2020 20:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436138;
        bh=zWCLfp4h721j+VW/7uhVawdS9abHhVhI1Vy7IztB9dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zs+4jsvou4Yeu/L6fpy5MzDjCyTVrDbeT1aHEkSrIj/g3aZ787KeOP49C+AEfgLnz
         3E5o/bxEvX89KB3TV7xPnRn8jfmsXflAf5Cvv8E67/0eauyZMlNS8j4OSS299KX/3m
         oSb+3Fm3Ke6/LgI9RaMsoRx6MDR7r1W35aRGV6v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 119/391] SUNRPC: Mitigate cond_resched() in xprt_transmit()
Date:   Tue,  3 Nov 2020 21:32:50 +0100
Message-Id: <20201103203354.853516171@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index 5a8e47bbfb9f4..13fbc2dd4196a 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1520,10 +1520,13 @@ xprt_transmit(struct rpc_task *task)
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
@@ -1531,7 +1534,6 @@ xprt_transmit(struct rpc_task *task)
 		status = xprt_request_transmit(next, task);
 		if (status == -EBADMSG && next != req)
 			status = 0;
-		cond_resched();
 		spin_lock(&xprt->queue_lock);
 		xprt_unpin_rqst(next);
 		if (status == 0) {
-- 
2.27.0



