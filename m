Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDA4524D3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245038AbhKPBph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241086AbhKOSSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B397633EB;
        Mon, 15 Nov 2021 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998641;
        bh=mz7YsXrxMiYpHCWK/p17nJV62Kqke7yWlDYRInUPdtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jukbf4X6BFMAjG7NT9c2T0t90hrv7TZtl6yl7Ogd4Bj/q7qUrYBSSdvvyQ2SO9h0g
         UH4V8SITl269ES9cz2Jfb1iWSWL06894IVbGOw2rFYFOgFlUCNAORyGBMWAiW67m9N
         YwuNerdc/36LN/j7ee9/8uIjMx0GomQD2lAjnLjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 575/575] SUNRPC: Partial revert of commit 6f9f17287e78
Date:   Mon, 15 Nov 2021 18:05:00 +0100
Message-Id: <20211115165403.587085577@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit ea7a1019d8baf8503ecd6e3ec8436dec283569e6 upstream.

The premise of commit 6f9f17287e78 ("SUNRPC: Mitigate cond_resched() in
xprt_transmit()") was that cond_resched() is expensive and unnecessary
when there has been just a single send.
The point of cond_resched() is to ensure that tasks that should pre-empt
this one get a chance to do so when it is safe to do so. The code prior
to commit 6f9f17287e78 failed to take into account that it was keeping a
rpc_task pinned for longer than it needed to, and so rather than doing a
full revert, let's just move the cond_resched.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprt.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1552,15 +1552,14 @@ xprt_transmit(struct rpc_task *task)
 {
 	struct rpc_rqst *next, *req = task->tk_rqstp;
 	struct rpc_xprt	*xprt = req->rq_xprt;
-	int counter, status;
+	int status;
 
 	spin_lock(&xprt->queue_lock);
-	counter = 0;
-	while (!list_empty(&xprt->xmit_queue)) {
-		if (++counter == 20)
+	for (;;) {
+		next = list_first_entry_or_null(&xprt->xmit_queue,
+						struct rpc_rqst, rq_xmit);
+		if (!next)
 			break;
-		next = list_first_entry(&xprt->xmit_queue,
-				struct rpc_rqst, rq_xmit);
 		xprt_pin_rqst(next);
 		spin_unlock(&xprt->queue_lock);
 		status = xprt_request_transmit(next, task);
@@ -1568,13 +1567,16 @@ xprt_transmit(struct rpc_task *task)
 			status = 0;
 		spin_lock(&xprt->queue_lock);
 		xprt_unpin_rqst(next);
-		if (status == 0) {
-			if (!xprt_request_data_received(task) ||
-			    test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
-				continue;
-		} else if (test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
-			task->tk_status = status;
-		break;
+		if (status < 0) {
+			if (test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
+				task->tk_status = status;
+			break;
+		}
+		/* Was @task transmitted, and has it received a reply? */
+		if (xprt_request_data_received(task) &&
+		    !test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
+			break;
+		cond_resched_lock(&xprt->queue_lock);
 	}
 	spin_unlock(&xprt->queue_lock);
 }


