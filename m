Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B3B528FF2
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiEPUIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350273AbiEPUBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596EC47051;
        Mon, 16 May 2022 12:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B66960FCB;
        Mon, 16 May 2022 19:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C54C385AA;
        Mon, 16 May 2022 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730910;
        bh=eQRs6X/wsdc8HSUP+ERuwxuixL7sQkysxP2yWh4xx9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktQCO1Z7POcSydQb1ETo4s0/92lBlbOx5lGKTlertR3d5rdWUL0wQjw3ndAoCx2Z6
         aAntJGXsb9phMFcnDt6qMIzvq/EBCGJqE9yug85vR4XjXMjbzoHTK/VuDCKsmlME+Z
         DExHgT6YfueLxQ0BGBBUZ0R+IPFKaPqwdNSGCQo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 005/114] net: rds: use maybe_get_net() when acquiring refcount on TCP sockets
Date:   Mon, 16 May 2022 21:35:39 +0200
Message-Id: <20220516193625.650118783@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 6997fbd7a3dafa754f81d541498ace35b43246d8 ]

Eric Dumazet is reporting addition on 0 problem at rds_tcp_tune(), for
delayed works queued in rds_wq might be invoked after a net namespace's
refcount already reached 0.

Since rds_tcp_exit_net() from cleanup_net() calls flush_workqueue(rds_wq),
it is guaranteed that we can instead use maybe_get_net() from delayed work
functions until rds_tcp_exit_net() returns.

Note that I'm not convinced that all works which might access a net
namespace are already queued in rds_wq by the moment rds_tcp_exit_net()
calls flush_workqueue(rds_wq). If some race is there, rds_tcp_exit_net()
will fail to wait for work functions, and kmem_cache_free() could be
called from net_free() before maybe_get_net() is called from
rds_tcp_tune().

Reported-by: Eric Dumazet <edumazet@google.com>
Fixes: 3a58f13a881ed351 ("net: rds: acquire refcount on TCP sockets")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/41d09faf-bc78-1a87-dfd1-c6d1b5984b61@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c         | 12 +++++++++---
 net/rds/tcp.h         |  2 +-
 net/rds/tcp_connect.c |  5 ++++-
 net/rds/tcp_listen.c  |  5 ++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 2f638f8b7b1e..73ee2771093d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -487,11 +487,11 @@ struct rds_tcp_net {
 /* All module specific customizations to the RDS-TCP socket should be done in
  * rds_tcp_tune() and applied after socket creation.
  */
-void rds_tcp_tune(struct socket *sock)
+bool rds_tcp_tune(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
-	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
+	struct rds_tcp_net *rtn;
 
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
@@ -499,10 +499,15 @@ void rds_tcp_tune(struct socket *sock)
 	 * a process which created this net namespace terminated.
 	 */
 	if (!sk->sk_net_refcnt) {
+		if (!maybe_get_net(net)) {
+			release_sock(sk);
+			return false;
+		}
 		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		netns_tracker_alloc(net, &sk->ns_tracker, GFP_KERNEL);
 		sock_inuse_add(net, 1);
 	}
+	rtn = net_generic(net, rds_tcp_netid);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
@@ -512,6 +517,7 @@ void rds_tcp_tune(struct socket *sock)
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);
+	return true;
 }
 
 static void rds_tcp_accept_worker(struct work_struct *work)
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index dc8d745d6857..f8b5930d7b34 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -49,7 +49,7 @@ struct rds_tcp_statistics {
 };
 
 /* tcp.c */
-void rds_tcp_tune(struct socket *sock);
+bool rds_tcp_tune(struct socket *sock);
 void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_reset_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_restore_callbacks(struct socket *sock,
diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index 5461d77fff4f..f0c477c5d1db 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -124,7 +124,10 @@ int rds_tcp_conn_path_connect(struct rds_conn_path *cp)
 	if (ret < 0)
 		goto out;
 
-	rds_tcp_tune(sock);
+	if (!rds_tcp_tune(sock)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if (isv6) {
 		sin6.sin6_family = AF_INET6;
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 09cadd556d1e..7edf2e69d3fe 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -133,7 +133,10 @@ int rds_tcp_accept_one(struct socket *sock)
 	__module_get(new_sock->ops->owner);
 
 	rds_tcp_keepalive(new_sock);
-	rds_tcp_tune(new_sock);
+	if (!rds_tcp_tune(new_sock)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	inet = inet_sk(new_sock->sk);
 
-- 
2.35.1



