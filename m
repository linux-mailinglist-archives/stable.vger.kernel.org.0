Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2DF1DDB81
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgEUX6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730220AbgEUX6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:52 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0825FC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:51 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z1so8871786qvd.23
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ugzLe892SXPoBO8tP7FQU1e9aRzgn6EOtLNzYEx/YZc=;
        b=KY4gYaipWN7W9zab1qEBG7sdp8ypwsYusxNSIhiQD6h7MFEf6ycipgyJSnHQ6CQUK5
         246sU5+X1azWZRzkGqG8xE91ssyQc3ppyvwZYfDLviRZmj+OsdbAKWGNwNKG4AyRHqNB
         paDVKfmDNUASJw0TCuqgI374vD2Vonxuqm0t94kgwF3H//1qugTzdN2PsrsvpOJcji4x
         1SNgvWH0KMQIz/j55oFx0HV65LUkKght7AzuUxYdcMvfXZGULso4X9ha6PdovMsQXCAs
         IikIWW/8XP1oR1TcgejA6SGLEB9hpn64Y/GjV8H2bPKCMtfhhXXub1FpYaNz6P9Yk3RC
         5P7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ugzLe892SXPoBO8tP7FQU1e9aRzgn6EOtLNzYEx/YZc=;
        b=HBFwjG/qYkYOBA7gH7cstVoO3UzjqmSQ4E9MDsOzyIfsm6Zstp0nPOHeqHmETwS+7E
         zFjNCl94LdgF+PSV1qSi7LegixX9BofkieoyC+u/gaawl4kP0+pdYOsxrp8zCVgVOGu0
         CqOa7AIwRjoEIChAMdtyukiThk+3YuDeLmbQ0STqw5MOLnpKefKJNse+7oyV940IkNPf
         sQsE2/SNxPnsj3sZm8uOsO4HT7jLbmoGexyrQSGFGJkFeP7TBCS76YudOUmvFfGbraVY
         dVtZWM7m91A3Za5B8qqFlZVj/9FVacGYX5SYK8pzGXM/3SZ0kqWNShGJgLtHgedSmfxl
         6G/w==
X-Gm-Message-State: AOAM530tdGsx4+DlBHhunc5pwkhJQn9otZJsUbnViE7TaYCnls6MWwVp
        re9VJ/EDMnv77FRnWdrQjo3Q8Hhlckn7sQ==
X-Google-Smtp-Source: ABdhPJxC6s9APXuE4hS/YEN8UG7oF4GLfJ1pJPX2yY1EpVe1qbWCjtZFDeU/cGpYFklbgM0vCkb905x2shPQiw==
X-Received: by 2002:a0c:8c4f:: with SMTP id o15mr1221790qvb.201.1590105530217;
 Thu, 21 May 2020 16:58:50 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:40 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-28-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 27/27] l2tp: initialise PPP sessions before registering them
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
index 4ba4546051ed..8ff5352bb0e3 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -464,9 +464,6 @@ static void pppol2tp_session_close(struct l2tp_session *session)
 			inet_shutdown(sk->sk_socket, SEND_SHUTDOWN);
 		sock_put(sk);
 	}
-
-	/* Don't let the session go away before our socket does */
-	l2tp_session_inc_refcount(session);
 }
 
 /* Really kill the session socket. (Called from sock_put() if
@@ -522,8 +519,7 @@ static int pppol2tp_release(struct socket *sock)
 	if (session != NULL) {
 		struct pppol2tp_session *ps;
 
-		__l2tp_session_unhash(session);
-		l2tp_session_queue_purge(session);
+		l2tp_session_delete(session);
 
 		ps = l2tp_session_priv(session);
 		mutex_lock(&ps->sk_lock);
@@ -615,6 +611,35 @@ static void pppol2tp_show(struct seq_file *m, void *arg)
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
@@ -626,7 +651,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	struct l2tp_session *session = NULL;
 	struct l2tp_tunnel *tunnel;
 	struct pppol2tp_session *ps;
-	struct dst_entry *dst;
 	struct l2tp_session_cfg cfg = { 0, };
 	int error = 0;
 	u32 tunnel_id, peer_tunnel_id;
@@ -775,8 +799,8 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			goto end;
 		}
 
+		pppol2tp_session_init(session);
 		ps = l2tp_session_priv(session);
-		mutex_init(&ps->sk_lock);
 		l2tp_session_inc_refcount(session);
 
 		mutex_lock(&ps->sk_lock);
@@ -789,26 +813,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -863,7 +873,6 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 {
 	int error;
 	struct l2tp_session *session;
-	struct pppol2tp_session *ps;
 
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
@@ -886,9 +895,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
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

