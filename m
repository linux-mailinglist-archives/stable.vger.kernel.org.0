Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DB11A51E0
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgDKMKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgDKMKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F204920787;
        Sat, 11 Apr 2020 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607051;
        bh=QNO1WKpOXZo/Q7qmA3TyXg8AaV+g9GwGaqT0EOuniTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ed8+WG9Obc5U7Ea+yj/ChDD8+Vjr0LWGlO/eU0NCaU4sHtsEQLtdenAjNEiRHW+cL
         wOqmVUhZMhzTvZhdrYFvLVN4Q0XjsSBCrkOBCRFTyDXoxQRxhfoTwQhZqzrr8kC4cx
         Zo/0ZX46U/yvJqHesm7YreQxGQ8Ssl3xgLaKMRoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 07/29] l2tp: fix race in l2tp_recv_common()
Date:   Sat, 11 Apr 2020 14:08:37 +0200
Message-Id: <20200411115408.781906973@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 61b9a047729bb230978178bca6729689d0c50ca2 upstream.

Taking a reference on sessions in l2tp_recv_common() is racy; this
has to be done by the callers.

To this end, a new function is required (l2tp_session_get()) to
atomically lookup a session and take a reference on it. Callers then
have to manually drop this reference.

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |   73 +++++++++++++++++++++++++++++++++++++++++----------
 net/l2tp/l2tp_core.h |    3 ++
 net/l2tp/l2tp_ip.c   |   17 ++++++++---
 net/l2tp/l2tp_ip6.c  |   18 +++++++++---
 4 files changed, 88 insertions(+), 23 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -277,6 +277,55 @@ struct l2tp_session *l2tp_session_find(s
 }
 EXPORT_SYMBOL_GPL(l2tp_session_find);
 
+/* Like l2tp_session_find() but takes a reference on the returned session.
+ * Optionally calls session->ref() too if do_ref is true.
+ */
+struct l2tp_session *l2tp_session_get(struct net *net,
+				      struct l2tp_tunnel *tunnel,
+				      u32 session_id, bool do_ref)
+{
+	struct hlist_head *session_list;
+	struct l2tp_session *session;
+
+	if (!tunnel) {
+		struct l2tp_net *pn = l2tp_pernet(net);
+
+		session_list = l2tp_session_id_hash_2(pn, session_id);
+
+		rcu_read_lock_bh();
+		hlist_for_each_entry_rcu(session, session_list, global_hlist) {
+			if (session->session_id == session_id) {
+				l2tp_session_inc_refcount(session);
+				if (do_ref && session->ref)
+					session->ref(session);
+				rcu_read_unlock_bh();
+
+				return session;
+			}
+		}
+		rcu_read_unlock_bh();
+
+		return NULL;
+	}
+
+	session_list = l2tp_session_id_hash(tunnel, session_id);
+	read_lock_bh(&tunnel->hlist_lock);
+	hlist_for_each_entry(session, session_list, hlist) {
+		if (session->session_id == session_id) {
+			l2tp_session_inc_refcount(session);
+			if (do_ref && session->ref)
+				session->ref(session);
+			read_unlock_bh(&tunnel->hlist_lock);
+
+			return session;
+		}
+	}
+	read_unlock_bh(&tunnel->hlist_lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(l2tp_session_get);
+
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref)
 {
@@ -636,6 +685,9 @@ discard:
  * a data (not control) frame before coming here. Fields up to the
  * session-id have already been parsed and ptr points to the data
  * after the session-id.
+ *
+ * session->ref() must have been called prior to l2tp_recv_common().
+ * session->deref() will be called automatically after skb is processed.
  */
 void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      unsigned char *ptr, unsigned char *optr, u16 hdrflags,
@@ -645,14 +697,6 @@ void l2tp_recv_common(struct l2tp_sessio
 	int offset;
 	u32 ns, nr;
 
-	/* The ref count is increased since we now hold a pointer to
-	 * the session. Take care to decrement the refcnt when exiting
-	 * this function from now on...
-	 */
-	l2tp_session_inc_refcount(session);
-	if (session->ref)
-		(*session->ref)(session);
-
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
 		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
@@ -803,8 +847,6 @@ void l2tp_recv_common(struct l2tp_sessio
 	/* Try to dequeue as many skbs from reorder_q as we can. */
 	l2tp_recv_dequeue(session);
 
-	l2tp_session_dec_refcount(session);
-
 	return;
 
 discard:
@@ -813,8 +855,6 @@ discard:
 
 	if (session->deref)
 		(*session->deref)(session);
-
-	l2tp_session_dec_refcount(session);
 }
 EXPORT_SYMBOL(l2tp_recv_common);
 
@@ -921,8 +961,14 @@ static int l2tp_udp_recv_core(struct l2t
 	}
 
 	/* Find the session context */
-	session = l2tp_session_find(tunnel->l2tp_net, tunnel, session_id);
+	session = l2tp_session_get(tunnel->l2tp_net, tunnel, session_id, true);
 	if (!session || !session->recv_skb) {
+		if (session) {
+			if (session->deref)
+				session->deref(session);
+			l2tp_session_dec_refcount(session);
+		}
+
 		/* Not found? Pass to userspace to deal with */
 		l2tp_info(tunnel, L2TP_MSG_DATA,
 			  "%s: no session found (%u/%u). Passing up.\n",
@@ -935,6 +981,7 @@ static int l2tp_udp_recv_core(struct l2t
 		goto error;
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length, payload_hook);
+	l2tp_session_dec_refcount(session);
 
 	return 0;
 
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -243,6 +243,9 @@ out:
 	return tunnel;
 }
 
+struct l2tp_session *l2tp_session_get(struct net *net,
+				      struct l2tp_tunnel *tunnel,
+				      u32 session_id, bool do_ref);
 struct l2tp_session *l2tp_session_find(struct net *net,
 				       struct l2tp_tunnel *tunnel,
 				       u32 session_id);
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -142,19 +142,19 @@ static int l2tp_ip_recv(struct sk_buff *
 	}
 
 	/* Ok, this is a data packet. Lookup the session. */
-	session = l2tp_session_find(net, NULL, session_id);
-	if (session == NULL)
+	session = l2tp_session_get(net, NULL, session_id, true);
+	if (!session)
 		goto discard;
 
 	tunnel = session->tunnel;
-	if (tunnel == NULL)
-		goto discard;
+	if (!tunnel)
+		goto discard_sess;
 
 	/* Trace packet contents, if enabled */
 	if (tunnel->debug & L2TP_MSG_DATA) {
 		length = min(32u, skb->len);
 		if (!pskb_may_pull(skb, length))
-			goto discard;
+			goto discard_sess;
 
 		/* Point to L2TP header */
 		optr = ptr = skb->data;
@@ -167,6 +167,7 @@ static int l2tp_ip_recv(struct sk_buff *
 		goto discard;
 
 	l2tp_recv_common(session, skb, ptr, optr, 0, skb->len, tunnel->recv_payload_hook);
+	l2tp_session_dec_refcount(session);
 
 	return 0;
 
@@ -204,6 +205,12 @@ pass_up:
 
 	return sk_receive_skb(sk, skb, 1);
 
+discard_sess:
+	if (session->deref)
+		session->deref(session);
+	l2tp_session_dec_refcount(session);
+	goto discard;
+
 discard_put:
 	sock_put(sk);
 
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -154,19 +154,19 @@ static int l2tp_ip6_recv(struct sk_buff
 	}
 
 	/* Ok, this is a data packet. Lookup the session. */
-	session = l2tp_session_find(net, NULL, session_id);
-	if (session == NULL)
+	session = l2tp_session_get(net, NULL, session_id, true);
+	if (!session)
 		goto discard;
 
 	tunnel = session->tunnel;
-	if (tunnel == NULL)
-		goto discard;
+	if (!tunnel)
+		goto discard_sess;
 
 	/* Trace packet contents, if enabled */
 	if (tunnel->debug & L2TP_MSG_DATA) {
 		length = min(32u, skb->len);
 		if (!pskb_may_pull(skb, length))
-			goto discard;
+			goto discard_sess;
 
 		/* Point to L2TP header */
 		optr = ptr = skb->data;
@@ -180,6 +180,8 @@ static int l2tp_ip6_recv(struct sk_buff
 
 	l2tp_recv_common(session, skb, ptr, optr, 0, skb->len,
 			 tunnel->recv_payload_hook);
+	l2tp_session_dec_refcount(session);
+
 	return 0;
 
 pass_up:
@@ -217,6 +219,12 @@ pass_up:
 
 	return sk_receive_skb(sk, skb, 1);
 
+discard_sess:
+	if (session->deref)
+		session->deref(session);
+	l2tp_session_dec_refcount(session);
+	goto discard;
+
 discard_put:
 	sock_put(sk);
 


