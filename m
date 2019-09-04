Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BD9A9139
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbfIDSON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390742AbfIDSOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7578E206BA;
        Wed,  4 Sep 2019 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620852;
        bh=auObbfFtxe1vAJIVlAJXLA+5R7odgXX5KYToodQnPi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=db6KvBD1B+wZJ9MaNQxZdv1QonuTlUsp4S4ZryxHJCjyQ6gPshZUMRnuhTY+HCrK1
         mAb0VwOMoqc0fMtN903t0+RCUS0693+l8/KkjGAskMQoHD4iSjXPhs5NP4J8a8PFvq
         P1O0p0x3Uk5sTJX+AwXMa3PpZHsqmWcciEkuuMO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 119/143] SUNRPC: Dont handle errors if the bind/connect succeeded
Date:   Wed,  4 Sep 2019 19:54:22 +0200
Message-Id: <20190904175319.054317713@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit bd736ed3e2d1088d9b4050f727342e1e619c3841 upstream.

Don't handle errors in call_bind_status()/call_connect_status()
if it turns out that a previous call caused it to succeed.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1893,6 +1893,7 @@ call_bind(struct rpc_task *task)
 static void
 call_bind_status(struct rpc_task *task)
 {
+	struct rpc_xprt *xprt = task->tk_rqstp->rq_xprt;
 	int status = -EIO;
 
 	if (rpc_task_transmitted(task)) {
@@ -1900,14 +1901,15 @@ call_bind_status(struct rpc_task *task)
 		return;
 	}
 
-	if (task->tk_status >= 0) {
-		dprint_status(task);
+	dprint_status(task);
+	trace_rpc_bind_status(task);
+	if (task->tk_status >= 0)
+		goto out_next;
+	if (xprt_bound(xprt)) {
 		task->tk_status = 0;
-		task->tk_action = call_connect;
-		return;
+		goto out_next;
 	}
 
-	trace_rpc_bind_status(task);
 	switch (task->tk_status) {
 	case -ENOMEM:
 		dprintk("RPC: %5u rpcbind out of memory\n", task->tk_pid);
@@ -1966,7 +1968,9 @@ call_bind_status(struct rpc_task *task)
 
 	rpc_call_rpcerror(task, status);
 	return;
-
+out_next:
+	task->tk_action = call_connect;
+	return;
 retry_timeout:
 	task->tk_status = 0;
 	task->tk_action = call_bind;
@@ -2013,6 +2017,7 @@ call_connect(struct rpc_task *task)
 static void
 call_connect_status(struct rpc_task *task)
 {
+	struct rpc_xprt *xprt = task->tk_rqstp->rq_xprt;
 	struct rpc_clnt *clnt = task->tk_client;
 	int status = task->tk_status;
 
@@ -2022,8 +2027,17 @@ call_connect_status(struct rpc_task *tas
 	}
 
 	dprint_status(task);
-
 	trace_rpc_connect_status(task);
+
+	if (task->tk_status == 0) {
+		clnt->cl_stats->netreconn++;
+		goto out_next;
+	}
+	if (xprt_connected(xprt)) {
+		task->tk_status = 0;
+		goto out_next;
+	}
+
 	task->tk_status = 0;
 	switch (status) {
 	case -ECONNREFUSED:
@@ -2054,13 +2068,12 @@ call_connect_status(struct rpc_task *tas
 	case -EAGAIN:
 	case -ETIMEDOUT:
 		goto out_retry;
-	case 0:
-		clnt->cl_stats->netreconn++;
-		task->tk_action = call_transmit;
-		return;
 	}
 	rpc_call_rpcerror(task, status);
 	return;
+out_next:
+	task->tk_action = call_transmit;
+	return;
 out_retry:
 	/* Check for timeouts before looping back to call_bind */
 	task->tk_action = call_bind;


