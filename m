Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6159450121D
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343554AbiDNOIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347360AbiDNN6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B6D12AE3;
        Thu, 14 Apr 2022 06:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3682B61D93;
        Thu, 14 Apr 2022 13:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C3DC385A1;
        Thu, 14 Apr 2022 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944170;
        bh=1cnlC7HUjUl564h+SOgUVa4Y28A45oWnsLw+WqGOJE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuIx9/HfqEtSxjc6Vy2d59ClSSrCO8zuiuBwXN727rr6KWYmnxbTTcLw/BEOuUKDe
         w7srcenzPlr7a0tEdvlF0ZLW6QB1GuJLh8J9TYV28KXUYW9pqXcvuXeLxexHR34f7a
         2d8i9xILK0dXgi2G4xSN6i9D8Dnfq2lNuomctc90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 419/475] SUNRPC: Fix socket waits for write buffer space
Date:   Thu, 14 Apr 2022 15:13:24 +0200
Message-Id: <20220414110906.787165610@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 8ffc54b6661f..480e879e74ae 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -872,12 +872,12 @@ static int xs_sendpages(struct socket *sock, struct sockaddr *addr, int addrlen,
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
 
@@ -891,25 +891,49 @@ static int xs_nospace(struct rpc_rqst *req)
 
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
 
@@ -996,7 +1020,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	case -ENOBUFS:
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_stream_nospace(req);
 		break;
 	default:
 		dprintk("RPC:       sendmsg returned unrecognized error %d\n",
@@ -1068,7 +1092,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 		/* Should we call xs_close() here? */
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_sock_nospace(req);
 		break;
 	case -ENETUNREACH:
 	case -ENOBUFS:
@@ -1181,7 +1205,7 @@ static int xs_tcp_send_request(struct rpc_rqst *req)
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



