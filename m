Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E735D2587
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388528AbfJJImV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbfJJImU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61CE2190F;
        Thu, 10 Oct 2019 08:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696939;
        bh=Y9uQYymY0eFnLevhi+Oh+Vqc/2hn+dwDMy63dOaerEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVSBX+7Z41l/GG5m4TpsawKvOJJmMaANGz0rDYp3jf03SZdRzUyxLC8G+7LqEUVnB
         rzIHriLEWNrlnvh1jUkTURh5vEBDQw/6keCxFoo4EM4jeqfaQwnQHcZfsBzIoO8pgq
         Cc9rHdsr8QmbW5U9450NYtSzxSxSJKXbIvckHuf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 108/148] SUNRPC: Dont try to parse incomplete RPC messages
Date:   Thu, 10 Oct 2019 10:36:09 +0200
Message-Id: <20191010083617.709024171@linuxfoundation.org>
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

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 9ba828861c56a21d211d5d10f5643774b1ea330d ]

If the copy of the RPC reply into our buffers did not complete, and
we could end up with a truncated message. In that case, just resend
the call.

Fixes: a0584ee9aed80 ("SUNRPC: Use struct xdr_stream when decoding...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e7fdc400506e8..f7f78566be463 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2482,6 +2482,7 @@ call_decode(struct rpc_task *task)
 	struct rpc_clnt	*clnt = task->tk_client;
 	struct rpc_rqst	*req = task->tk_rqstp;
 	struct xdr_stream xdr;
+	int err;
 
 	dprint_status(task);
 
@@ -2504,6 +2505,15 @@ call_decode(struct rpc_task *task)
 	 * before it changed req->rq_reply_bytes_recvd.
 	 */
 	smp_rmb();
+
+	/*
+	 * Did we ever call xprt_complete_rqst()? If not, we should assume
+	 * the message is incomplete.
+	 */
+	err = -EAGAIN;
+	if (!req->rq_reply_bytes_recvd)
+		goto out;
+
 	req->rq_rcv_buf.len = req->rq_private_buf.len;
 
 	/* Check that the softirq receive buffer is valid */
@@ -2512,7 +2522,9 @@ call_decode(struct rpc_task *task)
 
 	xdr_init_decode(&xdr, &req->rq_rcv_buf,
 			req->rq_rcv_buf.head[0].iov_base, req);
-	switch (rpc_decode_header(task, &xdr)) {
+	err = rpc_decode_header(task, &xdr);
+out:
+	switch (err) {
 	case 0:
 		task->tk_action = rpc_exit_task;
 		task->tk_status = rpcauth_unwrap_resp(task, &xdr);
-- 
2.20.1



