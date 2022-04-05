Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFC4F3550
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350761AbiDEJ7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbiDEJSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0D349683;
        Tue,  5 Apr 2022 02:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0017161564;
        Tue,  5 Apr 2022 09:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099D7C385A0;
        Tue,  5 Apr 2022 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149541;
        bh=+HmpgAwitYAtX3vItdMTFYGz4EiR3MK7TjuXfzAqvNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yhMO/z87z2wOuAzM4GVYh5juh+h1TNvqIGfx7SSM4gUpiAPgJqzhHdfGzvTQJV1A
         dhq/LkbAkyI4dJa80xvAdp6mjdfKhPWPRNuE3Yh3vfN7/haMvBfPAxh3ayriyr9NsR
         BttgPdH0fa94zxLk42Ing/kahpY138Q020jOgefM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0715/1017] SUNRPC: Dont call connect() more than once on a TCP socket
Date:   Tue,  5 Apr 2022 09:27:08 +0200
Message-Id: <20220405070415.493509770@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d ]

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 3c1423ee74b4..fed813ffe7db 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -88,5 +88,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE	(5)
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
+#define XPRT_SOCK_CONNECT_SENT	(8)
 
 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 821eeea1c83b..37d961c1a5c9 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2257,10 +2257,15 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 
 	if (atomic_read(&xprt->swapper))
 		current->flags |= PF_MEMALLOC;
-	if (!sock) {
-		sock = xs_create_sock(xprt, transport,
-				xs_addr(xprt)->sa_family, SOCK_STREAM,
-				IPPROTO_TCP, true);
+
+	if (xprt_connected(xprt))
+		goto out;
+	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
+			       &transport->sock_state) ||
+	    !sock) {
+		xs_reset_transport(transport);
+		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+				      SOCK_STREAM, IPPROTO_TCP, true);
 		if (IS_ERR(sock)) {
 			xprt_wake_pending_tasks(xprt, PTR_ERR(sock));
 			goto out;
@@ -2284,6 +2289,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		fallthrough;
 	case -EINPROGRESS:
 		/* SYN_SENT! */
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
 		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
 			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
 		fallthrough;
@@ -2345,13 +2351,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL && !xprt_connecting(xprt)) {
+	if (transport->sock != NULL) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
-				"seconds\n",
-				xprt, xprt->reestablish_timeout / HZ);
-
-		/* Start by resetting any existing state */
-		xs_reset_transport(transport);
+			"seconds\n", xprt, xprt->reestablish_timeout / HZ);
 
 		delay = xprt_reconnect_delay(xprt);
 		xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
-- 
2.34.1



