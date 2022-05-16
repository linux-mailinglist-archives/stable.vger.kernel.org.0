Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73DB528F4D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245547AbiEPTxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbiEPTvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8423FD96;
        Mon, 16 May 2022 12:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93807B8160E;
        Mon, 16 May 2022 19:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0814CC385AA;
        Mon, 16 May 2022 19:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730427;
        bh=83GQTNq/tBaD7g1NIWDbJ9kE3GD7vyzp8ZZH6TRSWDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDK3Jf9GD6VCxhlD09KMyG7eC0sWRbjSgECpTfw0B3DzhHDy+w+t1dCTxSQSeMraj
         T3MEHL7qkonOcQlYYa3vadCDqbLtT/Nb2ux4YxGY8RJcwjOiye/2COEOubAscTLXmu
         dU8t10SmUPVFA1joRl89UVss3Zb7KhjRyuO2UJW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fu <foyjog@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Meena Shanmugam <meenashanmugam@google.com>
Subject: [PATCH 5.10 61/66] SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()
Date:   Mon, 16 May 2022 21:37:01 +0200
Message-Id: <20220516193621.174798907@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit f00432063db1a0db484e85193eccc6845435b80e upstream.

We must ensure that all sockets are closed before we call xprt_free()
and release the reference to the net namespace. The problem is that
calling fput() will defer closing the socket until delayed_fput() gets
called.
Let's fix the situation by allowing rpciod and the transport teardown
code (which runs on the system wq) to call __fput_sync(), and directly
close the socket.

Reported-by: Felix Fu <foyjog@gmail.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: a73881c96d73 ("SUNRPC: Fix an Oops in udp_poll()")
Cc: stable@vger.kernel.org # 5.1.x: 3be232f11a3c: SUNRPC: Prevent immediate close+reconnect
Cc: stable@vger.kernel.org # 5.1.x: 89f42494f92f: SUNRPC: Don't call connect() more than once on a TCP socket
Cc: stable@vger.kernel.org # 5.1.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file_table.c               |    1 +
 include/trace/events/sunrpc.h |    1 -
 net/sunrpc/xprt.c             |    7 +------
 net/sunrpc/xprtsock.c         |   16 +++++++++++++---
 4 files changed, 15 insertions(+), 10 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -376,6 +376,7 @@ void __fput_sync(struct file *file)
 }
 
 EXPORT_SYMBOL(fput);
+EXPORT_SYMBOL(__fput_sync);
 
 void __init files_init(void)
 {
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1006,7 +1006,6 @@ DEFINE_RPC_XPRT_LIFETIME_EVENT(connect);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_auto);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_done);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_force);
-DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_cleanup);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(destroy);
 
 DECLARE_EVENT_CLASS(rpc_xprt_event,
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -886,12 +886,7 @@ void xprt_connect(struct rpc_task *task)
 	if (!xprt_lock_write(xprt, task))
 		return;
 
-	if (test_and_clear_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
-		trace_xprt_disconnect_cleanup(xprt);
-		xprt->ops->close(xprt);
-	}
-
-	if (!xprt_connected(xprt)) {
+	if (!xprt_connected(xprt) && !test_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
 		task->tk_rqstp->rq_connect_cookie = xprt->connect_cookie;
 		rpc_sleep_on_timeout(&xprt->pending, task, NULL,
 				xprt_request_timeout(task->tk_rqstp));
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -871,7 +871,7 @@ static int xs_local_send_request(struct
 
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		return -ENOTCONN;
 	}
 
@@ -909,7 +909,7 @@ static int xs_local_send_request(struct
 			-status);
 		fallthrough;
 	case -EPIPE:
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		status = -ENOTCONN;
 	}
 
@@ -1191,6 +1191,16 @@ static void xs_reset_transport(struct so
 
 	if (sk == NULL)
 		return;
+	/*
+	 * Make sure we're calling this in a context from which it is safe
+	 * to call __fput_sync(). In practice that means rpciod and the
+	 * system workqueue.
+	 */
+	if (!(current->flags & PF_WQ_WORKER)) {
+		WARN_ON_ONCE(1);
+		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+		return;
+	}
 
 	if (atomic_read(&transport->xprt.swapper))
 		sk_clear_memalloc(sk);
@@ -1214,7 +1224,7 @@ static void xs_reset_transport(struct so
 	mutex_unlock(&transport->recv_mutex);
 
 	trace_rpc_socket_close(xprt, sock);
-	fput(filp);
+	__fput_sync(filp);
 
 	xprt_disconnect_done(xprt);
 }


