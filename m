Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342EF4FB783
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbiDKJaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344414AbiDKJaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411F1403C1
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B721C61014
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66A9C385A3;
        Mon, 11 Apr 2022 09:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669283;
        bh=8jX9FtXaqAnumF1CRIPY9Mt/yxvHZai/FrR652upGHg=;
        h=Subject:To:Cc:From:Date:From;
        b=EiJbiptNRLDQGF9sOpOIU6MX5q5iW4mb6wuXrSBlNDARVlr/SZ8dTe52VvmNkEnU8
         15aeheAk80OhRI1hD/UM1MtzOYRIdh4z6UF19KbCVI+ZpLbCKsaTpjeP5VCnhfGuX9
         28ABLwTmsZp5woIXm7Mvx7NXnwdsqN79WD5TsMwg=
Subject: FAILED: patch "[PATCH] SUNRPC: Ensure we flush any closed sockets before" failed to apply to 5.10-stable tree
To:     trond.myklebust@hammerspace.com, foyjog@gmail.com,
        viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 11:27:58 +0200
Message-ID: <16496692785214@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f00432063db1a0db484e85193eccc6845435b80e Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Sun, 3 Apr 2022 15:58:11 -0400
Subject: [PATCH] SUNRPC: Ensure we flush any closed sockets before
 xs_xprt_free()

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

diff --git a/fs/file_table.c b/fs/file_table.c
index 7d2e692b66a9..ada8fe814db9 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -412,6 +412,7 @@ void __fput_sync(struct file *file)
 }
 
 EXPORT_SYMBOL(fput);
+EXPORT_SYMBOL(__fput_sync);
 
 void __init files_init(void)
 {
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index ac33892da411..a4848c7bab80 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1004,7 +1004,6 @@ DEFINE_RPC_XPRT_LIFETIME_EVENT(connect);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_auto);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_done);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_force);
-DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_cleanup);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(destroy);
 
 DECLARE_EVENT_CLASS(rpc_xprt_event,
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 73344ffb2692..ad62eba540a4 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -930,12 +930,7 @@ void xprt_connect(struct rpc_task *task)
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
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9b75891b3cc0..c6a13893e308 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -879,7 +879,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		return -ENOTCONN;
 	}
 
@@ -915,7 +915,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 			-status);
 		fallthrough;
 	case -EPIPE:
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		status = -ENOTCONN;
 	}
 
@@ -1185,6 +1185,16 @@ static void xs_reset_transport(struct sock_xprt *transport)
 
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
@@ -1208,7 +1218,7 @@ static void xs_reset_transport(struct sock_xprt *transport)
 	mutex_unlock(&transport->recv_mutex);
 
 	trace_rpc_socket_close(xprt, sock);
-	fput(filp);
+	__fput_sync(filp);
 
 	xprt_disconnect_done(xprt);
 }

