Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3915268E5
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 20:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382772AbiEMSAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378971AbiEMSAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 14:00:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC9F53B6E
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:00:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s25-20020a656459000000b003c6086e82f2so4518326pgv.8
        for <stable@vger.kernel.org>; Fri, 13 May 2022 11:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sJDDjQPfXxH/KwunThpteMwBMb1LnkMVrpUXdqH1qOk=;
        b=bBd8tsDQpxF9YWvQuVfiDrJf+dCgYGElFdY8NAc5FMFM30ciAeaiwzqWicy3PwJ8Nx
         J7c8EUt3qBQxwTpoYF8I195JEZhksf5Jd/7iejhEGcWnv533uJWkbA7DDpTPR6GTjfbH
         bKJb3VVKjverwnDKF/+JvqAu2YF3PcOz9fMcozWzuMUOm7qBfpIUCH+drOGJYDJBmF1H
         JmGZj4H+ryi8znSntvNt6VxVlj0mtMz7ShV4Fldqq1YLsZJEyY6nTIccTW+X7JgtVpNl
         1/CAvPrIlkP/cqvrWj1ilrxnlkXF1ARLypceVaHY1vqZVTya2ejfHrGVzOn2NJ4geER9
         ljhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sJDDjQPfXxH/KwunThpteMwBMb1LnkMVrpUXdqH1qOk=;
        b=nuWwCzAlKeYFBHhTTO3Q7mHfH374t1okKHGosPC6IP23H78Abt5N/x0/o4ojDdicE8
         /QOqxcnE0EiJTzHH7gKAn9baoCekKpfSgllhlc61+VMVCXcRFvbyKbLVD1LMRiXi1ht7
         9ce41433xusuIuo6bvTOwTHYZJl4ZcYFAzQIfLXweveou81M13wev81wIbYcpTmS+aSV
         lUEfkjdkeqz4k/dZl3JNvulY+qTgmPDHSaLHVVue5uLR7Cr0aNZ2zMHSKLg2P6lIEesV
         nvNmIaVuOm9EYkuBhvkH0qZuvYrXfDs6TUbeiqS2zYjv02t3BnI2jq+N+uxUW29W2919
         T1YQ==
X-Gm-Message-State: AOAM5325KOuRD+11RVG5hzVFx4aLIC/GtDkO3uXqvOKkxVzKWY3d2r+2
        NvXshlhNG95l622O87afys8PG+NnhVyNWFhG1EMamQ==
X-Google-Smtp-Source: ABdhPJxmNF+5c3a8PWTrQ7HI7phq+dIMX6FstOzGQy12DVlJ6a2g6zu8OEwM6jW5xS35HQSZnsr42UtZ1mz3pNE9tmL9YA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a63:8b42:0:b0:3c6:2f31:2dfc with
 SMTP id j63-20020a638b42000000b003c62f312dfcmr4804243pge.285.1652464807925;
 Fri, 13 May 2022 11:00:07 -0700 (PDT)
Date:   Fri, 13 May 2022 17:59:59 +0000
In-Reply-To: <Yn4V4HdJFyHARf1b@kroah.com>
Message-Id: <20220513175959.3179701-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn4V4HdJFyHARf1b@kroah.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH] SUNRPC: Don't call connect() more than once on a TCP socket
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     meenashanmugam@google.com, stable@vger.kernel.org,
        trond.myklebust@hammerspace.com,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
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
2.36.0.512.ge40c2bad7a-goog

