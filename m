Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3618519C815
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbgDBRdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389964AbgDBRdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:33:03 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581D02080C;
        Thu,  2 Apr 2020 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848782;
        bh=1pIuzB4W0Eosq9gz9gNCtcL3U7BY3Gq0FE9pIv1cPok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+Uo6SzzDLKOrlGCAS3ZXF3JKsCb3RVvWXKvW2OlCRXsVIuz16KIE/FRZ7yoykS7x
         7drQxbcMfAu1myReOlQfgUEVg5luH6FSmhud8aUl0msibPYYBFKNzjdTIUIsRJwfsh
         1PN6kcM91lx+QGttCN49RCHplAi58nEHQaCyERHE=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 3/8] l2tp: fix race in l2tp_recv_common()
Date:   Thu,  2 Apr 2020 18:32:45 +0100
Message-Id: <20200402173250.7858-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
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
---
 net/l2tp/l2tp_core.c | 73 ++++++++++++++++++++++++++++++++++++--------
 net/l2tp/l2tp_core.h |  3 ++
 net/l2tp/l2tp_ip.c   | 17 ++++++++---
 net/l2tp/l2tp_ip6.c  | 18 ++++++++---
 4 files changed, 88 insertions(+), 23 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 429dbb064240..4d41fe40723d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -277,6 +277,55 @@ struct l2tp_session *l2tp_session_find(struct net *net, struct l2tp_tunnel *tunn
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
@@ -645,14 +697,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
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
@@ -803,8 +847,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
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
 
@@ -921,8 +961,14 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb,
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
@@ -935,6 +981,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb,
 		goto error;
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length, payload_hook);
+	l2tp_session_dec_refcount(session);
 
 	return 0;
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index fad47e9d74bc..705fbc63ddc2 100644
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
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 7efb3cadc152..58f87bdd12c7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -142,19 +142,19 @@ static int l2tp_ip_recv(struct sk_buff *skb)
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
@@ -167,6 +167,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
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
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 391dd9d8144f..af04a8a68269 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -154,19 +154,19 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
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
@@ -180,6 +180,8 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 
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
 
-- 
2.26.0.rc2.310.g2932bb562d-goog

