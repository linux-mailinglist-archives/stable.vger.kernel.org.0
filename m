Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C688C4FD044
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350515AbiDLGpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350976AbiDLGnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:43:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A4838D9E;
        Mon, 11 Apr 2022 23:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6815961926;
        Tue, 12 Apr 2022 06:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F33C385A1;
        Tue, 12 Apr 2022 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745425;
        bh=cKn535A51R0MiQP2Msgn8lf3YvNM3Es0diIzmpkbrj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bnl/a8R8YwHrsHMV0FAVgM+CmK1aqH5cKmTDBi5Vad8N5Z6z1MPS9GDsQJYU6QAZo
         BntKOAs+SRe8BH3DVEFh35LimU0rVjwQpU5VCYE1d6+Zb2g2wb5bJBUR9Xj9TP3ysR
         o9VGUePraP2onqCFyHGdUvAb+QPbYL4SlW81HDG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/171] SUNRPC: Fix socket waits for write buffer space
Date:   Tue, 12 Apr 2022 08:29:42 +0200
Message-Id: <20220412062930.519276193@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 7496b59f588dd52886fdbac7633608097543a0a5 ]

The socket layer requires that we use the socket lock to protect changes
to the sock->sk_write_pending field and others.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 54 +++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 16c7758e7bf3..bd123f1d0923 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -754,12 +754,12 @@ xs_stream_start_connect(struct sock_xprt *transport)
 /**
  * xs_nospace - handle transmit was incomplete
  * @req: pointer to RPC request
+ * @transport: pointer to struct sock_xprt
  *
  */
-static int xs_nospace(struct rpc_rqst *req)
+static int xs_nospace(struct rpc_rqst *req, struct sock_xprt *transport)
 {
-	struct rpc_xprt *xprt = req->rq_xprt;
-	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	struct rpc_xprt *xprt = &transport->xprt;
 	struct sock *sk = transport->inet;
 	int ret = -EAGAIN;
 
@@ -770,25 +770,49 @@ static int xs_nospace(struct rpc_rqst *req)
 
 	/* Don't race with disconnect */
 	if (xprt_connected(xprt)) {
+		struct socket_wq *wq;
+
+		rcu_read_lock();
+		wq = rcu_dereference(sk->sk_wq);
+		set_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags);
+		rcu_read_unlock();
+
 		/* wait for more buffer space */
+		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
 		xprt_wait_for_buffer_space(xprt);
 	} else
 		ret = -ENOTCONN;
 
 	spin_unlock(&xprt->transport_lock);
+	return ret;
+}
 
-	/* Race breaker in case memory is freed before above code is called */
-	if (ret == -EAGAIN) {
-		struct socket_wq *wq;
+static int xs_sock_nospace(struct rpc_rqst *req)
+{
+	struct sock_xprt *transport =
+		container_of(req->rq_xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
+	int ret = -EAGAIN;
 
-		rcu_read_lock();
-		wq = rcu_dereference(sk->sk_wq);
-		set_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags);
-		rcu_read_unlock();
+	lock_sock(sk);
+	if (!sock_writeable(sk))
+		ret = xs_nospace(req, transport);
+	release_sock(sk);
+	return ret;
+}
 
-		sk->sk_write_space(sk);
-	}
+static int xs_stream_nospace(struct rpc_rqst *req)
+{
+	struct sock_xprt *transport =
+		container_of(req->rq_xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
+	int ret = -EAGAIN;
+
+	lock_sock(sk);
+	if (!sk_stream_memory_free(sk))
+		ret = xs_nospace(req, transport);
+	release_sock(sk);
 	return ret;
 }
 
@@ -878,7 +902,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	case -ENOBUFS:
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_stream_nospace(req);
 		break;
 	default:
 		dprintk("RPC:       sendmsg returned unrecognized error %d\n",
@@ -954,7 +978,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 		/* Should we call xs_close() here? */
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_sock_nospace(req);
 		break;
 	case -ENETUNREACH:
 	case -ENOBUFS:
@@ -1069,7 +1093,7 @@ static int xs_tcp_send_request(struct rpc_rqst *req)
 		/* Should we call xs_close() here? */
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_stream_nospace(req);
 		break;
 	case -ECONNRESET:
 	case -ECONNREFUSED:
-- 
2.35.1



