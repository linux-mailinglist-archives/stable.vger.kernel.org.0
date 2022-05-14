Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675EF526F24
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiENFfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiENFfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB5E22F
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d4-20020a17090ac24400b001dcec51802cso7197560pjx.4
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VZAZAPHvT0TKLZ9jTfeA+9ROnhqNYTAn9rPhraV02Tc=;
        b=guaJG6PAb7tVgS9A6ACn480wa197Nv5Ec72AmOeYWkh7IN6IPAOOj/KhkAI3GHI6YU
         Ev64zmLOD+triu5APRxQoH8DAXj0SrZLa/VLoSMMgpNSRJxNfkY0Gu8KHrJyre9sYYz5
         fm4hDyGl6e4Wi3vjd+WSzFkbly0lIWL/4VHfHtcIu05jVuAFGnrQn+p1UtwMuacRWRlT
         a0QDi0nGxtviRoGlnTn+rLpZGO+Caw4Pw2U9ozvtXJBP0WQQWxHOXcTMLm4tQYui92sp
         PHZQcMHyvgjONC41MDWz30op4AYJXmhMA7KtY6kC0/NErfJsg+JyXsGr8YUj06REp9WX
         Ux4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VZAZAPHvT0TKLZ9jTfeA+9ROnhqNYTAn9rPhraV02Tc=;
        b=Dn/ELrf6eKE6apD6lbUyCXsS09Z+F+F+VPd1MaaoY+vU+COS39Q7N4fHvad8VpSnSM
         owa0f+podhNGsuom017gtTwFO7zNlJZ98D8XoCCt1F616+rFlw2FtUk3cnTiED6tZffF
         O0eTayfGAn9T7yPCrBjeHkvQRJGx80w7z9sSPqtWUcsPLLY77dQPdeAXiVZFwEj7UXU1
         2brcE1HT7ys0O+QjjmEnYxjyk071nDvDHvoeUS8x+ZslnMx+dRNJnnqbeF+90awAfdnL
         2d3nNNpMe8/5vPrWPCmUd1H/QnUNPwBlIIfNtCHLC/K4itI0ZMj0RdLtkoireGFRWNGu
         o9/A==
X-Gm-Message-State: AOAM530soj1GvZBDBjrwcX+xZxBr+pMkFgRddjfA5Ysg/pihNOduMMIq
        GvExOApteMSPT9HyXHdCvB6osVHQ9B7aeSRm7tfdNA==
X-Google-Smtp-Source: ABdhPJwBwFFj3BqXVwtsliLQS73P2lABbO7cLJWYyWCWemobldNbGv0dDxtvZ/rDd9yrpGci2Suq44pd52gLJBenxwUcSA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:903:230b:b0:15e:bc9c:18c7 with
 SMTP id d11-20020a170903230b00b0015ebc9c18c7mr7655695plh.29.1652506516304;
 Fri, 13 May 2022 22:35:16 -0700 (PDT)
Date:   Sat, 14 May 2022 05:34:53 +0000
In-Reply-To: <20220514053453.3277330-1-meenashanmugam@google.com>
Message-Id: <20220514053453.3277330-5-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com> <20220514053453.3277330-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 4/4] SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     enrico.scholz@sigma-chemnitz.de, meenashanmugam@google.com,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com,
        Felix Fu <foyjog@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 fs/file_table.c               |  1 +
 include/trace/events/sunrpc.h |  1 -
 net/sunrpc/xprt.c             |  7 +------
 net/sunrpc/xprtsock.c         | 16 +++++++++++++---
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index fbd45a1a0e7e..12aaa04ac5b7 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -377,6 +377,7 @@ void __fput_sync(struct file *file)
 }
 
 EXPORT_SYMBOL(fput);
+EXPORT_SYMBOL(__fput_sync);
 
 void __init files_init(void)
 {
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index ed1bbac004d5..8220369ee610 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1006,7 +1006,6 @@ DEFINE_RPC_XPRT_LIFETIME_EVENT(connect);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_auto);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_done);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_force);
-DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_cleanup);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(destroy);
 
 DECLARE_EVENT_CLASS(rpc_xprt_event,
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index af0159459c75..13d5323f8098 100644
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
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 33a81f9703b1..71c0ec9eaf0b 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -871,7 +871,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		return -ENOTCONN;
 	}
 
@@ -909,7 +909,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 			-status);
 		fallthrough;
 	case -EPIPE:
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		status = -ENOTCONN;
 	}
 
@@ -1191,6 +1191,16 @@ static void xs_reset_transport(struct sock_xprt *transport)
 
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
@@ -1214,7 +1224,7 @@ static void xs_reset_transport(struct sock_xprt *transport)
 	mutex_unlock(&transport->recv_mutex);
 
 	trace_rpc_socket_close(xprt, sock);
-	fput(filp);
+	__fput_sync(filp);
 
 	xprt_disconnect_done(xprt);
 }
-- 
2.36.0.550.gb090851708-goog

