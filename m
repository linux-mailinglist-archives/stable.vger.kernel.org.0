Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DC63AADF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfFIQo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729560AbfFIQo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E452A2081C;
        Sun,  9 Jun 2019 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098697;
        bh=qs6Hsgma4ckw0XuaWznj8Z9t6P5Lb36QLSIfcXagW6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YflC12CMeWvoGPiRwBBldL09N+WldWcGbhYSAyBhFlVYJZZ98KOVjSzyR04G0+eof
         oztWUwz7L0Qrlzi8XSZp4IigYTog+UZas4Z62DyBigK8+KwWHOwrVOKVR+uYVMtaCN
         RlT19Z8EKu3LxPyyoYfizayv96bw18/XPWl5fLwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.1 28/70] SUNRPC: Fix a use after free when a server rejects the RPCSEC_GSS credential
Date:   Sun,  9 Jun 2019 18:41:39 +0200
Message-Id: <20190609164129.387769377@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 7987b694ade8cc465ce10fb3dceaa614f13ceaf3 upstream.

The addition of rpc_check_timeout() to call_decode causes an Oops
when the RPCSEC_GSS credential is rejected.
The reason is that rpc_decode_header() will call xprt_release() in
order to free task->tk_rqstp, which is needed by rpc_check_timeout()
to check whether or not we should exit due to a soft timeout.

The fix is to move the call to xprt_release() into call_decode() so
we can perform it after rpc_check_timeout().

Reported-by: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Reported-by: Nick Bowler <nbowler@draconx.ca>
Fixes: cea57789e408 ("SUNRPC: Clean up")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2387,17 +2387,21 @@ call_decode(struct rpc_task *task)
 		return;
 	case -EAGAIN:
 		task->tk_status = 0;
-		/* Note: rpc_decode_header() may have freed the RPC slot */
-		if (task->tk_rqstp == req) {
-			xdr_free_bvec(&req->rq_rcv_buf);
-			req->rq_reply_bytes_recvd = 0;
-			req->rq_rcv_buf.len = 0;
-			if (task->tk_client->cl_discrtry)
-				xprt_conditional_disconnect(req->rq_xprt,
-							    req->rq_connect_cookie);
-		}
+		xdr_free_bvec(&req->rq_rcv_buf);
+		req->rq_reply_bytes_recvd = 0;
+		req->rq_rcv_buf.len = 0;
+		if (task->tk_client->cl_discrtry)
+			xprt_conditional_disconnect(req->rq_xprt,
+						    req->rq_connect_cookie);
 		task->tk_action = call_encode;
 		rpc_check_timeout(task);
+		break;
+	case -EKEYREJECTED:
+		task->tk_action = call_reserve;
+		rpc_check_timeout(task);
+		rpcauth_invalcred(task);
+		/* Ensure we obtain a new XID if we retry! */
+		xprt_release(task);
 	}
 }
 
@@ -2533,11 +2537,7 @@ out_msg_denied:
 			break;
 		task->tk_cred_retry--;
 		trace_rpc__stale_creds(task);
-		rpcauth_invalcred(task);
-		/* Ensure we obtain a new XID! */
-		xprt_release(task);
-		task->tk_action = call_reserve;
-		return -EAGAIN;
+		return -EKEYREJECTED;
 	case rpc_autherr_badcred:
 	case rpc_autherr_badverf:
 		/* possibly garbled cred/verf? */


