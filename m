Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0C31E2EEE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389975AbgEZS4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389969AbgEZS4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3563C20849;
        Tue, 26 May 2020 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519413;
        bh=crvv17jn+EEJtvlxnc75CSE9keKgEs04g1jLqaXAKZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCfWcRMKzELa6iS5qdOfPqMIvTGHBw9ToBJt1LkLn1u8PeaIOqjaLA5W6Kf+Yp6F0
         T4S42y1TYvMQLcjqQN3/g1aZy7sRLcHrMPX9LHXQ0Qi6AQH6Y9s36uxCSS0CgoycWD
         5lEOg5SKMellPWjdhd8sBY+qjXONQGYHPaFf/lJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 60/65] l2tp: initialise PPP sessions before registering them
Date:   Tue, 26 May 2020 20:53:19 +0200
Message-Id: <20200526183928.236965206@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit f98be6c6359e7e4a61aaefb9964c1db31cb9ec0c upstream.

pppol2tp_connect() initialises L2TP sessions after they've been exposed
to the rest of the system by l2tp_session_register(). This puts
sessions into transient states that are the source of several races, in
particular with session's deletion path.

This patch centralises the initialisation code into
pppol2tp_session_init(), which is called before the registration phase.
The only field that can't be set before session registration is the
pppol2tp socket pointer, which has already been converted to RCU. So
pppol2tp_connect() should now be race-free.

The session's .session_close() callback is now set before registration.
Therefore, it's always called when l2tp_core deletes the session, even
if it was created by pppol2tp_session_create() and hasn't been plugged
to a pppol2tp socket yet. That'd prevent session free because the extra
reference taken by pppol2tp_session_close() wouldn't be dropped by the
socket's ->sk_destruct() callback (pppol2tp_session_destruct()).
We could set .session_close() only while connecting a session to its
pppol2tp socket, or teach pppol2tp_session_close() to avoid grabbing a
reference when the session isn't connected, but that'd require adding
some form of synchronisation to be race free.

Instead of that, we can just let the pppol2tp socket hold a reference
on the session as soon as it starts depending on it (that is, in
pppol2tp_connect()). Then we don't need to utilise
pppol2tp_session_close() to hold a reference at the last moment to
prevent l2tp_core from dropping it.

When releasing the socket, pppol2tp_release() now deletes the session
using the standard l2tp_session_delete() function, instead of merely
removing it from hash tables. l2tp_session_delete() drops the reference
the sessions holds on itself, but also makes sure it doesn't remove a
session twice. So it can safely be called, even if l2tp_core already
tried, or is concurrently trying, to remove the session.
Finally, pppol2tp_session_destruct() drops the reference held by the
socket.

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   69 ++++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -464,9 +464,6 @@ static void pppol2tp_session_close(struc
 			inet_shutdown(sk->sk_socket, SEND_SHUTDOWN);
 		sock_put(sk);
 	}
-
-	/* Don't let the session go away before our socket does */
-	l2tp_session_inc_refcount(session);
 }
 
 /* Really kill the session socket. (Called from sock_put() if
@@ -522,8 +519,7 @@ static int pppol2tp_release(struct socke
 	if (session != NULL) {
 		struct pppol2tp_session *ps;
 
-		__l2tp_session_unhash(session);
-		l2tp_session_queue_purge(session);
+		l2tp_session_delete(session);
 
 		ps = l2tp_session_priv(session);
 		mutex_lock(&ps->sk_lock);
@@ -615,6 +611,35 @@ static void pppol2tp_show(struct seq_fil
 }
 #endif
 
+static void pppol2tp_session_init(struct l2tp_session *session)
+{
+	struct pppol2tp_session *ps;
+	struct dst_entry *dst;
+
+	session->recv_skb = pppol2tp_recv;
+	session->session_close = pppol2tp_session_close;
+#if defined(CONFIG_L2TP_DEBUGFS) || defined(CONFIG_L2TP_DEBUGFS_MODULE)
+	session->show = pppol2tp_show;
+#endif
+
+	ps = l2tp_session_priv(session);
+	mutex_init(&ps->sk_lock);
+	ps->tunnel_sock = session->tunnel->sock;
+	ps->owner = current->pid;
+
+	/* If PMTU discovery was enabled, use the MTU that was discovered */
+	dst = sk_dst_get(session->tunnel->sock);
+	if (dst) {
+		u32 pmtu = dst_mtu(dst);
+
+		if (pmtu) {
+			session->mtu = pmtu - PPPOL2TP_HEADER_OVERHEAD;
+			session->mru = pmtu - PPPOL2TP_HEADER_OVERHEAD;
+		}
+		dst_release(dst);
+	}
+}
+
 /* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
  */
 static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
@@ -626,7 +651,6 @@ static int pppol2tp_connect(struct socke
 	struct l2tp_session *session = NULL;
 	struct l2tp_tunnel *tunnel;
 	struct pppol2tp_session *ps;
-	struct dst_entry *dst;
 	struct l2tp_session_cfg cfg = { 0, };
 	int error = 0;
 	u32 tunnel_id, peer_tunnel_id;
@@ -775,8 +799,8 @@ static int pppol2tp_connect(struct socke
 			goto end;
 		}
 
+		pppol2tp_session_init(session);
 		ps = l2tp_session_priv(session);
-		mutex_init(&ps->sk_lock);
 		l2tp_session_inc_refcount(session);
 
 		mutex_lock(&ps->sk_lock);
@@ -789,26 +813,6 @@ static int pppol2tp_connect(struct socke
 		drop_refcnt = true;
 	}
 
-	ps->owner	     = current->pid;
-	ps->tunnel_sock = tunnel->sock;
-
-	session->recv_skb	= pppol2tp_recv;
-	session->session_close	= pppol2tp_session_close;
-#if defined(CONFIG_L2TP_DEBUGFS) || defined(CONFIG_L2TP_DEBUGFS_MODULE)
-	session->show		= pppol2tp_show;
-#endif
-
-	/* If PMTU discovery was enabled, use the MTU that was discovered */
-	dst = sk_dst_get(tunnel->sock);
-	if (dst != NULL) {
-		u32 pmtu = dst_mtu(dst);
-
-		if (pmtu != 0)
-			session->mtu = session->mru = pmtu -
-				PPPOL2TP_HEADER_OVERHEAD;
-		dst_release(dst);
-	}
-
 	/* Special case: if source & dest session_id == 0x0000, this
 	 * socket is being created to manage the tunnel. Just set up
 	 * the internal context for use by ioctl() and sockopt()
@@ -842,6 +846,12 @@ out_no_ppp:
 	rcu_assign_pointer(ps->sk, sk);
 	mutex_unlock(&ps->sk_lock);
 
+	/* Keep the reference we've grabbed on the session: sk doesn't expect
+	 * the session to disappear. pppol2tp_session_destruct() is responsible
+	 * for dropping it.
+	 */
+	drop_refcnt = false;
+
 	sk->sk_state = PPPOX_CONNECTED;
 	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
@@ -863,7 +873,6 @@ static int pppol2tp_session_create(struc
 {
 	int error;
 	struct l2tp_session *session;
-	struct pppol2tp_session *ps;
 
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
@@ -886,9 +895,7 @@ static int pppol2tp_session_create(struc
 		goto err;
 	}
 
-	ps = l2tp_session_priv(session);
-	mutex_init(&ps->sk_lock);
-	ps->tunnel_sock = tunnel->sock;
+	pppol2tp_session_init(session);
 
 	error = l2tp_session_register(session, tunnel);
 	if (error < 0)


