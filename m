Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B104D526EA6
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiENFfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiENFfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1135E10C0
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d11b6259adso88844977b3.19
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sY49jKBF5FM4c+1hN6yD4uq5YLeIbMZrfN/k7lkxmlg=;
        b=hrYqYzFLV0JPwU996yxacxXAYwwMFxaPYG4ZYVnf5fjnQqaMCJW5MXQUS1S6mbtp3B
         DUKDSfPfK++ypMT615KGJ/Fz7p9vxAqLZhGJXijN0Pl8cRAWov7ySC1+jxX7jQgnWNKo
         yH8cnft0ArQmy3H3vl5KXa8NgnTEXHVmcb3jlPivIAeFkbNTo7NwhV7SyQSRyrJTL5Dn
         BZvfHt6LUiwZQLWSJXAWdGmNhlfLfX7X8vONu6SofMoB2FrITGrPZX7AvnLWpqIUjgP4
         MvhIuN+5Gg3p0HLFPmoh7rnxMFWULOfu0KKV8zCFO3mcJWzsFle97cIfl54eLq6jlXyW
         HueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sY49jKBF5FM4c+1hN6yD4uq5YLeIbMZrfN/k7lkxmlg=;
        b=0TMz3myBEIEu5l89CAFGATjoIhITbZ8KF/9gV7G1WDKicGGV0CmH13orWke7oF2/o5
         MKgiGpEKXoBz3oKG2Qazgvs/15nyiAqkcHUYgeblIKYWoZM2nv1W+qTwnHTZNjpIT9Bq
         hRlhG4/CVlwdFnt8eGhT7Mm6uufR0jwRRIib/k/17k84KWWOZK8srT52MkfwEbHae+EP
         ljBhkrpSk7gU/XLvoI0e2dPBMIlTcHrOrZjORYJMU9pIWtOMdP25OSYtedSO+qVwMuKy
         X7Cai2XMUAFURe37a657JNUdlh/Tr/rsaCB8FHJti0xsKxHNgRdmgUpB3hGrO663v5Mv
         c4Zw==
X-Gm-Message-State: AOAM530Cvh/q/D+Bxc8h2E1hdI1yXgeO9i5B65EBD/dcfiYMpyzW6M1O
        Xbl1s6/VLxevZqzV4sGn2RI89eYTZry130dafxl14A==
X-Google-Smtp-Source: ABdhPJw95Jgp6QuXznuZbY36iVG2TkrvwtYyVD0eJvNGwyjX/Rd9rHUHyfFx5fvG2GDcbgLjMI3ZTsC2v8PGAUuFGQl7gw==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a81:d16:0:b0:2f4:dd5d:9846 with
 SMTP id 22-20020a810d16000000b002f4dd5d9846mr9037146ywn.372.1652506513293;
 Fri, 13 May 2022 22:35:13 -0700 (PDT)
Date:   Sat, 14 May 2022 05:34:52 +0000
In-Reply-To: <20220514053453.3277330-1-meenashanmugam@google.com>
Message-Id: <20220514053453.3277330-4-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com> <20220514053453.3277330-1-meenashanmugam@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 3/4] SUNRPC: Don't call connect() more than once on a TCP socket
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     enrico.scholz@sigma-chemnitz.de, meenashanmugam@google.com,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com
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

commit 89f42494f92f448747bd8a7ab1ae8b5d5520577d upstream.

Avoid socket state races due to repeated calls to ->connect() using the
same socket. If connect() returns 0 due to the connection having
completed, but we are in fact in a closing state, then we may leave the
XPRT_CONNECTING flag set on the transport.

Reported-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Fixes: 3be232f11a3c ("SUNRPC: Prevent immediate close+reconnect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[meenashanmugam: Backported to 5.10: Fixed merge conflict in xs_tcp_setup_socket]
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

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
index 60c58eb9a456..33a81f9703b1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2260,10 +2260,14 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	struct rpc_xprt *xprt = &transport->xprt;
 	int status = -EIO;
 
-	if (!sock) {
-		sock = xs_create_sock(xprt, transport,
-				xs_addr(xprt)->sa_family, SOCK_STREAM,
-				IPPROTO_TCP, true);
+	if (xprt_connected(xprt))
+		goto out;
+	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
+			       &transport->sock_state) ||
+	    !sock) {
+		xs_reset_transport(transport);
+		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+				      SOCK_STREAM, IPPROTO_TCP, true);
 		if (IS_ERR(sock)) {
 			status = PTR_ERR(sock);
 			goto out;
@@ -2294,6 +2298,7 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 		break;
 	case 0:
 	case -EINPROGRESS:
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
 	case -EALREADY:
 		xprt_unlock_connect(xprt, transport);
 		return;
@@ -2345,13 +2350,9 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
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
2.36.0.550.gb090851708-goog

