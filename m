Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8564E1DCEB5
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 15:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbgEUN5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 09:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEUN5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 09:57:16 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE5AC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:15 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id i1so7133424qvo.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9Ar66iXFfZk8/urkTZhzdC4NCKXUrjD4ceofha+fOxc=;
        b=Nt9MVp4lcfXgt4b9CyJ95SGjfUpCNPyybyG8uMi3uyY8Watannw6UsXFEAA2l8rEJC
         2Evkn6qdNjhy7F2WaZTcIBU49s5doXHj5YhjM+zWsjIeioYDELmws5Sqp8p0oOLUQNpY
         yUb0zsAOjD6KO9T7FNNyicNUc0s/CZwbsDdNP6pEAfIzLtQM1aIgcn9/vVvUNPfkDsfd
         YlbfSa93Wp/ffH9n1964p3ZNaO420/9oqoVmJDDVP8oyPNiGv4L1v+mpbDpgFAUIt5Y1
         WxrraTTrcoExcpKZ4B+JJrTsjpdrqYULil8z/hgEqEcWR99R2kFilzwDqot3szKT9NiK
         oHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9Ar66iXFfZk8/urkTZhzdC4NCKXUrjD4ceofha+fOxc=;
        b=acSXvQ93mMwkygOrqnEtKKYDAMaK4umWufnnIsm1IBngrvERBSL6P5RZzzPKrd8gYF
         JiMRQFbhdAcZ1VFoj3Y5ofEquKpyBAXAHLnh9I+kX1iugiRYtvdtWBal7zLgCBsnXcef
         LUX3SbzGcu/UZ+czkerjGH6KR42Zpgb9s72JmblC+jP3UYaU1ABEetb1KozoWLwY9iDz
         vwdIJ4p/vVg6CEwPMt2jesh3lKMmkpr9x3g75CoXYNvRGYQIGFcvey+vIyEi0pdxK84s
         fqNDfIC8qO0Nt0u9nWZLA6WJSv/OUAQIsRVOBdPY73BXHmgZGmqmZpQg22LIsCiZpR2n
         7nmA==
X-Gm-Message-State: AOAM533CWRFMYiL23xs0/3Do3ewd7WciDQHQ2eZ3Bsh12qNPI4eoKedP
        0ga+UMlW2/mVq0hl3LMMhu3ENBh73rVknQ==
X-Google-Smtp-Source: ABdhPJzyo2esCWaWCTZZqYHzcg5xXVz2UusFEH85GvJ+eTO5iz8pxASLNGVypzP3aETpaMBj3V2LYdPJoW6iWQ==
X-Received: by 2002:a0c:fa8c:: with SMTP id o12mr8774899qvn.60.1590069434334;
 Thu, 21 May 2020 06:57:14 -0700 (PDT)
Date:   Thu, 21 May 2020 14:57:03 +0100
In-Reply-To: <20200521135704.109812-1-gprocida@google.com>
Message-Id: <20200521135704.109812-4-gprocida@google.com>
Mime-Version: 1.0
References: <20200521135704.109812-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 3/4] l2tp: protect sock pointer of struct pppol2tp_session
 with RCU
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
 net/l2tp/l2tp_ppp.c | 154 +++++++++++++++++++++++++++++---------------
 1 file changed, 101 insertions(+), 53 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 7ed06c420150..0d07ed8ec184 100644
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
@@ -138,6 +141,24 @@ static const struct ppp_channel_ops pppol2tp_chan_ops = {
 
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
@@ -224,7 +245,8 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 	/* If the socket is bound, send it in to PPP's input queue. Otherwise
 	 * queue it on the session socket.
 	 */
-	sk = ps->sock;
+	rcu_read_lock();
+	sk = rcu_dereference(ps->sk);
 	if (sk == NULL)
 		goto no_sock;
 
@@ -247,30 +269,16 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
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
@@ -431,14 +439,16 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
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
@@ -461,6 +471,14 @@ static void pppol2tp_session_destruct(struct sock *sk)
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
@@ -486,11 +504,24 @@ static int pppol2tp_release(struct socket *sock)
 
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
 
@@ -557,12 +588,14 @@ static int pppol2tp_create(struct net *net, struct socket *sock, int kern)
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
@@ -703,13 +736,17 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -726,19 +763,21 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -747,12 +786,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -786,12 +819,17 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -839,6 +877,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 	}
 
 	ps = l2tp_session_priv(session);
+	mutex_init(&ps->sk_lock);
 	ps->tunnel_sock = tunnel->sock;
 
 	error = l2tp_session_register(session, tunnel);
@@ -1010,12 +1049,10 @@ static int pppol2tp_session_ioctl(struct l2tp_session *session,
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
@@ -1291,7 +1328,6 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 				       int optname, int val)
 {
 	int err = 0;
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
 
 	switch (optname) {
 	case PPPOL2TP_SO_RECVSEQ:
@@ -1312,8 +1348,8 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 		}
 		session->send_seq = !!val;
 		{
-			struct sock *ssk      = ps->sock;
-			struct pppox_sock *po = pppox_sk(ssk);
+			struct pppox_sock *po = pppox_sk(sk);
+
 			po->chan.hdrlen = val ? PPPOL2TP_L2TP_HDR_SIZE_SEQ :
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
@@ -1652,8 +1688,9 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
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
 
@@ -1663,6 +1700,15 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
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
@@ -1670,9 +1716,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
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
@@ -1689,8 +1733,12 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
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
-- 
2.26.2.761.g0e0b3e54be-goog

