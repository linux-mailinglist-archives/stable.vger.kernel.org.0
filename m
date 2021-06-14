Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254013A6110
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhFNKmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhFNKkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5946141C;
        Mon, 14 Jun 2021 10:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666878;
        bh=SOUGqBQp3nV7DuXkoujlT2Q0GjI1fUhgMLBbG88LWCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rCIyUUC1aZNlUPt/R8uBrTGSTwlZeHl0miktFa7O3KDJmW5cvY1VqvRGDDUpPNNe
         x57kzfuXqhi/I0ZEP22fuOPFdCXZbvxIPq+Xpzza2k/Wovqp6ob49y9iX7xM8mNSHK
         h/kTVS+22mSeKv/O2r3qH3/RzEEbV6lXZIZB0OIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/67] RDS tcp loopback connection can hang
Date:   Mon, 14 Jun 2021 12:26:57 +0200
Message-Id: <20210614102644.258076824@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

[ Upstream commit aced3ce57cd37b5ca332bcacd370d01f5a8c5371 ]

When TCP is used as transport and a program on the
system connects to RDS port 16385, connection is
accepted but denied per the rules of RDS. However,
RDS connections object is left in the list. Next
loopback connection will select that connection
object as it is at the head of list. The connection
attempt will hang as the connection object is set
to connect over TCP which is not allowed

The issue can be reproduced easily, use rds-ping
to ping a local IP address. After that use any
program like ncat to connect to the same IP
address and port 16385. This will hang so ctrl-c out.
Now try rds-ping, it will hang.

To fix the issue this patch adds checks to disallow
the connection object creation and destroys the
connection object.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 23 +++++++++++++++++------
 net/rds/tcp.c        |  4 ++--
 net/rds/tcp.h        |  3 ++-
 net/rds/tcp_listen.c |  6 ++++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 3bd2f4a5a30d..ac3300b204a6 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -237,12 +237,23 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (loop_trans) {
 		rds_trans_put(loop_trans);
 		conn->c_loopback = 1;
-		if (is_outgoing && trans->t_prefer_loopback) {
-			/* "outgoing" connection - and the transport
-			 * says it wants the connection handled by the
-			 * loopback transport. This is what TCP does.
-			 */
-			trans = &rds_loop_transport;
+		if (trans->t_prefer_loopback) {
+			if (likely(is_outgoing)) {
+				/* "outgoing" connection to local address.
+				 * Protocol says it wants the connection
+				 * handled by the loopback transport.
+				 * This is what TCP does.
+				 */
+				trans = &rds_loop_transport;
+			} else {
+				/* No transport currently in use
+				 * should end up here, but if it
+				 * does, reset/destroy the connection.
+				 */
+				kmem_cache_free(rds_conn_slab, conn);
+				conn = ERR_PTR(-EOPNOTSUPP);
+				goto out;
+			}
 		}
 	}
 
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 18bb522df282..d0bce439198f 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -322,8 +322,8 @@ out:
 }
 #endif
 
-static int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
-			       __u32 scope_id)
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id)
 {
 	struct net_device *dev = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index 3c69361d21c7..4620549ecbeb 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -60,7 +60,8 @@ u32 rds_tcp_snd_una(struct rds_tcp_connection *tc);
 u64 rds_tcp_map_seq(struct rds_tcp_connection *tc, u32 seq);
 extern struct rds_transport rds_tcp_transport;
 void rds_tcp_accept_work(struct sock *sk);
-
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id);
 /* tcp_connect.c */
 int rds_tcp_conn_path_connect(struct rds_conn_path *cp);
 void rds_tcp_conn_path_shutdown(struct rds_conn_path *conn);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index c12203f646da..0d095d3f5fee 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -198,6 +198,12 @@ int rds_tcp_accept_one(struct socket *sock)
 	}
 #endif
 
+	if (!rds_tcp_laddr_check(sock_net(sock->sk), peer_addr, dev_if)) {
+		/* local address connection is only allowed via loopback */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	conn = rds_conn_create(sock_net(sock->sk),
 			       my_addr, peer_addr,
 			       &rds_tcp_transport, GFP_KERNEL, dev_if);
-- 
2.30.2



