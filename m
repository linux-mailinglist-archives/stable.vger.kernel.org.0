Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58A94FB784
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344414AbiDKJao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiDKJal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:30:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269F13FDB9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D21C2B810E0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2CAC385A3;
        Mon, 11 Apr 2022 09:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669305;
        bh=xLXBTGgZgPv8HmqFHIxwKPe2MrLolwXQK1AoxvNtt3Y=;
        h=Subject:To:Cc:From:Date:From;
        b=UIhTOnRE0UDwKGWLCkjpKkWJwwDBAvvjL54O8gIemNHe431urK1ywkX34jCFDIlo9
         E9jfeIbhUAsmlBsSNNfap89jz5a6+Msqj98MrA/nBGf+kreupz4MY0yKEL0RfDF40P
         onRUUJg4RYArlt1gvNxK6jbfe+c8JyP7WdaGn9XI=
Subject: FAILED: patch "[PATCH] SUNRPC: Don't call connect() more than once on a TCP socket" failed to apply to 5.15-stable tree
To:     trond.myklebust@hammerspace.com, enrico.scholz@sigma-chemnitz.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 11:28:23 +0200
Message-ID: <164966930340199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89f42494f92f448747bd8a7ab1ae8b5d5520577d Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Wed, 16 Mar 2022 19:10:43 -0400
Subject: [PATCH] SUNRPC: Don't call connect() more than once on a TCP socket

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 8c2a712cb242..689062afdd61 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -89,5 +89,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE	(5)
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
+#define XPRT_SOCK_CONNECT_SENT	(8)
 
 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7e39f87cde2d..8f8a03c3315a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2235,10 +2235,15 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 
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
@@ -2262,6 +2267,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		fallthrough;
 	case -EINPROGRESS:
 		/* SYN_SENT! */
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
 		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
 			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
 		fallthrough;
@@ -2323,13 +2329,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
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

