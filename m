Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A3E1DDB37
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgEUXkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgEUXkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:33 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB78C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:32 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u38so9737287qtc.0
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JxUsZsY3L0hlh6GRW2QVi6uhWWxMQNzq918OueBPU88=;
        b=cGNaJXZK2VPg/rnv2CBoGx3tCPabAU5X7kkDlj8LZIKnc/StrMzSglQnDd9zsqOtVK
         3TDlwDD9MiRyhhQt58Dxp2kB4qZgQ4OmJFl5AtcyiizNZD6QQkNRN65YcF7KDk5x3BCh
         u4+KoOcHlUOvHVYGK6CekbfAw3Ze11dmncQqbusYo4pPW2OskN4ZhF63sv1sTWT/X2cc
         tPFKKq3BTNhaiz6u7ThtK/2YWB0DAhsAEiOriwSlQYyfjPHq1Im1/it+wnyiYWtNHlZ6
         GARHtmy3WkKhlU7iJTfNHxuOZ8yaHseKKgrhHUbSgX1AG8olZlYC1pkKDX4CV5nh60W9
         q4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JxUsZsY3L0hlh6GRW2QVi6uhWWxMQNzq918OueBPU88=;
        b=GzTrvdx6EBWZ02hnqaLLV2Od8PfQArZbEHvnvfKTl8q2zcvapnfJN3ITjyulf8Kg3m
         JSqKpHVxMTh5RyDAffOkvC4x85wU0rHN4nSDheKGfHwhuu7l/MpkzJymZM9HxuVA7SgO
         9mqcNtuJOm9vj6YPEGAPgeGjBwQxiXAEtOWYm4EjR3T1l/SPJStMihZ9eVfizTBiAe/4
         GQchjpxB73w/54wlTyVCjVW33Mzq2ANg7QN8UF/309XzitgY2CZb//NCOuziyYrl173F
         B3NsFaY0kIlWb2pMvtdHHjNE045/+x8sjyC7KRy/FbIrbAINRbdOSmH5LoyQxo8EqEoO
         nhpQ==
X-Gm-Message-State: AOAM532Izm+P70FspqTpYNIOWrsHGvDuBeTvAl0ApsGHIPzbWCVCIuM+
        Nvmi/6ItpTdKR1CZs5oDY7I3HsgeNMA4uQ==
X-Google-Smtp-Source: ABdhPJzGcWA6rvJWln9fv/Z55RUDYZXyNHyZTIU847OS1fCryPyNClJD/OcKaLxZ6qtidzMxRpvNK++76mI6cw==
X-Received: by 2002:a0c:be88:: with SMTP id n8mr1201547qvi.134.1590104431785;
 Thu, 21 May 2020 16:40:31 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:37 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-23-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 22/22] l2tp: initialise PPP sessions before registering them
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
---
 net/l2tp/l2tp_ppp.c | 69 +++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 9eb07c1a993e..979fa868a4f1 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -449,9 +449,6 @@ static void pppol2tp_session_close(struct l2tp_session *session)
 			inet_shutdown(sk->sk_socket, SEND_SHUTDOWN);
 		sock_put(sk);
 	}
-
-	/* Don't let the session go away before our socket does */
-	l2tp_session_inc_refcount(session);
 }
 
 /* Really kill the session socket. (Called from sock_put() if
@@ -507,8 +504,7 @@ static int pppol2tp_release(struct socket *sock)
 	if (session != NULL) {
 		struct pppol2tp_session *ps;
 
-		__l2tp_session_unhash(session);
-		l2tp_session_queue_purge(session);
+		l2tp_session_delete(session);
 
 		ps = l2tp_session_priv(session);
 		mutex_lock(&ps->sk_lock);
@@ -600,6 +596,35 @@ static void pppol2tp_show(struct seq_file *m, void *arg)
 }
 #endif
 
+static void pppol2tp_session_init(struct l2tp_session *session)
+{
+	struct pppol2tp_session *ps;
+	struct dst_entry *dst;
+
+	session->recv_skb = pppol2tp_recv;
+	session->session_close = pppol2tp_session_close;
+#if IS_ENABLED(CONFIG_L2TP_DEBUGFS)
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
@@ -611,7 +636,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	struct l2tp_session *session = NULL;
 	struct l2tp_tunnel *tunnel;
 	struct pppol2tp_session *ps;
-	struct dst_entry *dst;
 	struct l2tp_session_cfg cfg = { 0, };
 	int error = 0;
 	u32 tunnel_id, peer_tunnel_id;
@@ -760,8 +784,8 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			goto end;
 		}
 
+		pppol2tp_session_init(session);
 		ps = l2tp_session_priv(session);
-		mutex_init(&ps->sk_lock);
 		l2tp_session_inc_refcount(session);
 
 		mutex_lock(&ps->sk_lock);
@@ -774,26 +798,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 		drop_refcnt = true;
 	}
 
-	ps->owner	     = current->pid;
-	ps->tunnel_sock = tunnel->sock;
-
-	session->recv_skb	= pppol2tp_recv;
-	session->session_close	= pppol2tp_session_close;
-#if IS_ENABLED(CONFIG_L2TP_DEBUGFS)
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
@@ -827,6 +831,12 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -848,7 +858,6 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 {
 	int error;
 	struct l2tp_session *session;
-	struct pppol2tp_session *ps;
 
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
@@ -871,9 +880,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 		goto err;
 	}
 
-	ps = l2tp_session_priv(session);
-	mutex_init(&ps->sk_lock);
-	ps->tunnel_sock = tunnel->sock;
+	pppol2tp_session_init(session);
 
 	error = l2tp_session_register(session, tunnel);
 	if (error < 0)
-- 
2.27.0.rc0.183.gde8f92d652-goog

