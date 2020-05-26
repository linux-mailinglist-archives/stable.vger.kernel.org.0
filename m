Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494E01E2ACD
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390459AbgEZS7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389784AbgEZS7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A0820849;
        Tue, 26 May 2020 18:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519547;
        bh=wGa8lhz8vy2icnrSQLMC6eug40HlNJLvqQSg4zUf7Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7TpIbGO6QkUpGi1JR5K+9gY2RLHqVYVTm7SUoes5FlfLj4Gsxkvrs+DQHC+/Nt8Z
         fDAAkL7FE1GFCptG2FCxmLIaPgb6+5IXihP1M4MB6EY3A5NUh1cMimh16Mk/XXlIDM
         CKY3PBUSIn78iJ+/TIsLrHdWwXAt6z1FbQtkQ2tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 47/64] l2tp: protect sock pointer of struct pppol2tp_session with RCU
Date:   Tue, 26 May 2020 20:53:16 +0200
Message-Id: <20200526183929.167578998@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit ee40fb2e1eb5bc0ddd3f2f83c6e39a454ef5a741 upstream.

pppol2tp_session_create() registers sessions that can't have their
corresponding socket initialised. This socket has to be created by
userspace, then connected to the session by pppol2tp_connect().
Therefore, we need to protect the pppol2tp socket pointer of L2TP
sessions, so that it can safely be updated when userspace is connecting
or closing the socket. This will eventually allow pppol2tp_connect()
to avoid generating transient states while initialising its parts of the
session.

To this end, this patch protects the pppol2tp socket pointer using RCU.

The pppol2tp socket pointer is still set in pppol2tp_connect(), but
only once we know the function isn't going to fail. It's eventually
reset by pppol2tp_release(), which now has to wait for a grace period
to elapse before it can drop the last reference on the socket. This
ensures that pppol2tp_session_get_sock() can safely grab a reference
on the socket, even after ps->sk is reset to NULL but before this
operation actually gets visible from pppol2tp_session_get_sock().

The rest is standard RCU conversion: pppol2tp_recv(), which already
runs in atomic context, is simply enclosed by rcu_read_lock() and
rcu_read_unlock(), while other functions are converted to use
pppol2tp_session_get_sock() followed by sock_put().
pppol2tp_session_setsockopt() is a special case. It used to retrieve
the pppol2tp socket from the L2TP session, which itself was retrieved
from the pppol2tp socket. Therefore we can just avoid dereferencing
ps->sk and directly use the original socket pointer instead.

With all users of ps->sk now handling NULL and concurrent updates, the
L2TP ->ref() and ->deref() callbacks aren't needed anymore. Therefore,
rather than converting pppol2tp_session_sock_hold() and
pppol2tp_session_sock_put(), we can just drop them.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |  154 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 101 insertions(+), 53 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -122,8 +122,11 @@
 struct pppol2tp_session {
 	int			owner;		/* pid that opened the socket */
 
-	struct sock		*sock;		/* Pointer to the session
+	struct mutex		sk_lock;	/* Protects .sk */
+	struct sock __rcu	*sk;		/* Pointer to the session
 						 * PPPoX socket */
+	struct sock		*__sk;		/* Copy of .sk, for cleanup */
+	struct rcu_head		rcu;		/* For asynchronous release */
 	struct sock		*tunnel_sock;	/* Pointer to the tunnel UDP
 						 * socket */
 	int			flags;		/* accessed by PPPIOCGFLAGS.
@@ -138,6 +141,24 @@ static const struct ppp_channel_ops pppo
 
 static const struct proto_ops pppol2tp_ops;
 
+/* Retrieves the pppol2tp socket associated to a session.
+ * A reference is held on the returned socket, so this function must be paired
+ * with sock_put().
+ */
+static struct sock *pppol2tp_session_get_sock(struct l2tp_session *session)
+{
+	struct pppol2tp_session *ps = l2tp_session_priv(session);
+	struct sock *sk;
+
+	rcu_read_lock();
+	sk = rcu_dereference(ps->sk);
+	if (sk)
+		sock_hold(sk);
+	rcu_read_unlock();
+
+	return sk;
+}
+
 /* Helpers to obtain tunnel/session contexts from sockets.
  */
 static inline struct l2tp_session *pppol2tp_sock_to_session(struct sock *sk)
@@ -224,7 +245,8 @@ static void pppol2tp_recv(struct l2tp_se
 	/* If the socket is bound, send it in to PPP's input queue. Otherwise
 	 * queue it on the session socket.
 	 */
-	sk = ps->sock;
+	rcu_read_lock();
+	sk = rcu_dereference(ps->sk);
 	if (sk == NULL)
 		goto no_sock;
 
@@ -247,30 +269,16 @@ static void pppol2tp_recv(struct l2tp_se
 			kfree_skb(skb);
 		}
 	}
+	rcu_read_unlock();
 
 	return;
 
 no_sock:
+	rcu_read_unlock();
 	l2tp_info(session, L2TP_MSG_DATA, "%s: no socket\n", session->name);
 	kfree_skb(skb);
 }
 
-static void pppol2tp_session_sock_hold(struct l2tp_session *session)
-{
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
-
-	if (ps->sock)
-		sock_hold(ps->sock);
-}
-
-static void pppol2tp_session_sock_put(struct l2tp_session *session)
-{
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
-
-	if (ps->sock)
-		sock_put(ps->sock);
-}
-
 /************************************************************************
  * Transmit handling
  ***********************************************************************/
@@ -431,14 +439,16 @@ abort:
  */
 static void pppol2tp_session_close(struct l2tp_session *session)
 {
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
-	struct sock *sk = ps->sock;
-	struct socket *sock = sk->sk_socket;
+	struct sock *sk;
 
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 
-	if (sock)
-		inet_shutdown(sock, SEND_SHUTDOWN);
+	sk = pppol2tp_session_get_sock(session);
+	if (sk) {
+		if (sk->sk_socket)
+			inet_shutdown(sk->sk_socket, SEND_SHUTDOWN);
+		sock_put(sk);
+	}
 
 	/* Don't let the session go away before our socket does */
 	l2tp_session_inc_refcount(session);
@@ -461,6 +471,14 @@ static void pppol2tp_session_destruct(st
 	}
 }
 
+static void pppol2tp_put_sk(struct rcu_head *head)
+{
+	struct pppol2tp_session *ps;
+
+	ps = container_of(head, typeof(*ps), rcu);
+	sock_put(ps->__sk);
+}
+
 /* Called when the PPPoX socket (session) is closed.
  */
 static int pppol2tp_release(struct socket *sock)
@@ -486,11 +504,24 @@ static int pppol2tp_release(struct socke
 
 	session = pppol2tp_sock_to_session(sk);
 
-	/* Purge any queued data */
 	if (session != NULL) {
+		struct pppol2tp_session *ps;
+
 		__l2tp_session_unhash(session);
 		l2tp_session_queue_purge(session);
-		sock_put(sk);
+
+		ps = l2tp_session_priv(session);
+		mutex_lock(&ps->sk_lock);
+		ps->__sk = rcu_dereference_protected(ps->sk,
+						     lockdep_is_held(&ps->sk_lock));
+		RCU_INIT_POINTER(ps->sk, NULL);
+		mutex_unlock(&ps->sk_lock);
+		call_rcu(&ps->rcu, pppol2tp_put_sk);
+
+		/* Rely on the sock_put() call at the end of the function for
+		 * dropping the reference held by pppol2tp_sock_to_session().
+		 * The last reference will be dropped by pppol2tp_put_sk().
+		 */
 	}
 	release_sock(sk);
 
@@ -557,12 +588,14 @@ out:
 static void pppol2tp_show(struct seq_file *m, void *arg)
 {
 	struct l2tp_session *session = arg;
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
+	struct sock *sk;
+
+	sk = pppol2tp_session_get_sock(session);
+	if (sk) {
+		struct pppox_sock *po = pppox_sk(sk);
 
-	if (ps) {
-		struct pppox_sock *po = pppox_sk(ps->sock);
-		if (po)
-			seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
+		seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
+		sock_put(sk);
 	}
 }
 #endif
@@ -700,13 +733,17 @@ static int pppol2tp_connect(struct socke
 		/* Using a pre-existing session is fine as long as it hasn't
 		 * been connected yet.
 		 */
-		if (ps->sock) {
+		mutex_lock(&ps->sk_lock);
+		if (rcu_dereference_protected(ps->sk,
+					      lockdep_is_held(&ps->sk_lock))) {
+			mutex_unlock(&ps->sk_lock);
 			error = -EEXIST;
 			goto end;
 		}
 
 		/* consistency checks */
 		if (ps->tunnel_sock != tunnel->sock) {
+			mutex_unlock(&ps->sk_lock);
 			error = -EEXIST;
 			goto end;
 		}
@@ -723,19 +760,21 @@ static int pppol2tp_connect(struct socke
 			goto end;
 		}
 
+		ps = l2tp_session_priv(session);
+		mutex_init(&ps->sk_lock);
 		l2tp_session_inc_refcount(session);
+
+		mutex_lock(&ps->sk_lock);
 		error = l2tp_session_register(session, tunnel);
 		if (error < 0) {
+			mutex_unlock(&ps->sk_lock);
 			kfree(session);
 			goto end;
 		}
 		drop_refcnt = true;
 	}
 
-	/* Associate session with its PPPoL2TP socket */
-	ps = l2tp_session_priv(session);
 	ps->owner	     = current->pid;
-	ps->sock	     = sk;
 	ps->tunnel_sock = tunnel->sock;
 
 	session->recv_skb	= pppol2tp_recv;
@@ -744,12 +783,6 @@ static int pppol2tp_connect(struct socke
 	session->show		= pppol2tp_show;
 #endif
 
-	/* We need to know each time a skb is dropped from the reorder
-	 * queue.
-	 */
-	session->ref = pppol2tp_session_sock_hold;
-	session->deref = pppol2tp_session_sock_put;
-
 	/* If PMTU discovery was enabled, use the MTU that was discovered */
 	dst = sk_dst_get(tunnel->sock);
 	if (dst != NULL) {
@@ -783,12 +816,17 @@ static int pppol2tp_connect(struct socke
 	po->chan.mtu	 = session->mtu;
 
 	error = ppp_register_net_channel(sock_net(sk), &po->chan);
-	if (error)
+	if (error) {
+		mutex_unlock(&ps->sk_lock);
 		goto end;
+	}
 
 out_no_ppp:
 	/* This is how we get the session context from the socket. */
 	sk->sk_user_data = session;
+	rcu_assign_pointer(ps->sk, sk);
+	mutex_unlock(&ps->sk_lock);
+
 	sk->sk_state = PPPOX_CONNECTED;
 	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
 		  session->name);
@@ -834,6 +872,7 @@ static int pppol2tp_session_create(struc
 	}
 
 	ps = l2tp_session_priv(session);
+	mutex_init(&ps->sk_lock);
 	ps->tunnel_sock = tunnel->sock;
 
 	error = l2tp_session_register(session, tunnel);
@@ -1005,12 +1044,10 @@ static int pppol2tp_session_ioctl(struct
 		 "%s: pppol2tp_session_ioctl(cmd=%#x, arg=%#lx)\n",
 		 session->name, cmd, arg);
 
-	sk = ps->sock;
+	sk = pppol2tp_session_get_sock(session);
 	if (!sk)
 		return -EBADR;
 
-	sock_hold(sk);
-
 	switch (cmd) {
 	case SIOCGIFMTU:
 		err = -ENXIO;
@@ -1286,7 +1323,6 @@ static int pppol2tp_session_setsockopt(s
 				       int optname, int val)
 {
 	int err = 0;
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
 
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
@@ -1307,8 +1343,8 @@ static int pppol2tp_session_setsockopt(s
 		}
 		session->send_seq = val ? -1 : 0;
 		{
-			struct sock *ssk      = ps->sock;
-			struct pppox_sock *po = pppox_sk(ssk);
+			struct pppox_sock *po = pppox_sk(sk);
+
 			po->chan.hdrlen = val ? PPPOL2TP_L2TP_HDR_SIZE_SEQ :
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
@@ -1644,8 +1680,9 @@ static void pppol2tp_seq_session_show(st
 {
 	struct l2tp_session *session = v;
 	struct l2tp_tunnel *tunnel = session->tunnel;
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
-	struct pppox_sock *po = pppox_sk(ps->sock);
+	unsigned char state;
+	char user_data_ok;
+	struct sock *sk;
 	u32 ip = 0;
 	u16 port = 0;
 
@@ -1655,6 +1692,15 @@ static void pppol2tp_seq_session_show(st
 		port = ntohs(inet->inet_sport);
 	}
 
+	sk = pppol2tp_session_get_sock(session);
+	if (sk) {
+		state = sk->sk_state;
+		user_data_ok = (session == sk->sk_user_data) ? 'Y' : 'N';
+	} else {
+		state = 0;
+		user_data_ok = 'N';
+	}
+
 	seq_printf(m, "  SESSION '%s' %08X/%d %04X/%04X -> "
 		   "%04X/%04X %d %c\n",
 		   session->name, ip, port,
@@ -1662,9 +1708,7 @@ static void pppol2tp_seq_session_show(st
 		   session->session_id,
 		   tunnel->peer_tunnel_id,
 		   session->peer_session_id,
-		   ps->sock->sk_state,
-		   (session == ps->sock->sk_user_data) ?
-		   'Y' : 'N');
+		   state, user_data_ok);
 	seq_printf(m, "   %d/%d/%c/%c/%s %08x %u\n",
 		   session->mtu, session->mru,
 		   session->recv_seq ? 'R' : '-',
@@ -1681,8 +1725,12 @@ static void pppol2tp_seq_session_show(st
 		   atomic_long_read(&session->stats.rx_bytes),
 		   atomic_long_read(&session->stats.rx_errors));
 
-	if (po)
+	if (sk) {
+		struct pppox_sock *po = pppox_sk(sk);
+
 		seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
+		sock_put(sk);
+	}
 }
 
 static int pppol2tp_seq_show(struct seq_file *m, void *v)


