Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1517919C819
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390038AbgDBRdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389989AbgDBRdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:33:07 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B181920737;
        Thu,  2 Apr 2020 17:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848786;
        bh=MGH1RTKGxlo3YlQSIXlfI3Sn+QwBD16rRnaJyouveNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp4m8gLYWtvnMrEg3MyurUKbDu7b5goEpZMwUftlDFUYosDm/6KkBhjCmurtxsxr1
         8vukdUQswU97C/lBZMwmFB1Ivv5V/JTZqyWqJmIj23MgWFL8R+UCm031u+HwEtsbAG
         bqTJxV5Ssa0q18sL9rmEmdAB4MlXWNzNL/h9SicY=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5/8] l2tp: fix duplicate session creation
Date:   Thu,  2 Apr 2020 18:32:47 +0100
Message-Id: <20200402173250.7858-6-will@kernel.org>
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

commit dbdbc73b44782e22b3b4b6e8b51e7a3d245f3086 upstream.

l2tp_session_create() relies on its caller for checking for duplicate
sessions. This is racy since a session can be concurrently inserted
after the caller's verification.

Fix this by letting l2tp_session_create() verify sessions uniqueness
upon insertion. Callers need to be adapted to check for
l2tp_session_create()'s return code instead of calling
l2tp_session_find().

pppol2tp_connect() is a bit special because it has to work on existing
sessions (if they're not connected) or to create a new session if none
is found. When acting on a preexisting session, a reference must be
held or it could go away on us. So we have to use l2tp_session_get()
instead of l2tp_session_find() and drop the reference before exiting.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
---
 net/l2tp/l2tp_core.c | 70 +++++++++++++++++++++++++++++++++-----------
 net/l2tp/l2tp_eth.c  | 10 ++-----
 net/l2tp/l2tp_ppp.c  | 60 ++++++++++++++++++-------------------
 3 files changed, 84 insertions(+), 56 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4d41fe40723d..03475b124841 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -377,6 +377,48 @@ struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname)
 }
 EXPORT_SYMBOL_GPL(l2tp_session_find_by_ifname);
 
+static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
+				      struct l2tp_session *session)
+{
+	struct l2tp_session *session_walk;
+	struct hlist_head *g_head;
+	struct hlist_head *head;
+	struct l2tp_net *pn;
+
+	head = l2tp_session_id_hash(tunnel, session->session_id);
+
+	write_lock_bh(&tunnel->hlist_lock);
+	hlist_for_each_entry(session_walk, head, hlist)
+		if (session_walk->session_id == session->session_id)
+			goto exist;
+
+	if (tunnel->version == L2TP_HDR_VER_3) {
+		pn = l2tp_pernet(tunnel->l2tp_net);
+		g_head = l2tp_session_id_hash_2(l2tp_pernet(tunnel->l2tp_net),
+						session->session_id);
+
+		spin_lock_bh(&pn->l2tp_session_hlist_lock);
+		hlist_for_each_entry(session_walk, g_head, global_hlist)
+			if (session_walk->session_id == session->session_id)
+				goto exist_glob;
+
+		hlist_add_head_rcu(&session->global_hlist, g_head);
+		spin_unlock_bh(&pn->l2tp_session_hlist_lock);
+	}
+
+	hlist_add_head(&session->hlist, head);
+	write_unlock_bh(&tunnel->hlist_lock);
+
+	return 0;
+
+exist_glob:
+	spin_unlock_bh(&pn->l2tp_session_hlist_lock);
+exist:
+	write_unlock_bh(&tunnel->hlist_lock);
+
+	return -EEXIST;
+}
+
 /* Lookup a tunnel by id
  */
 struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
@@ -1792,6 +1834,7 @@ EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
+	int err;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
 	if (session != NULL) {
@@ -1847,6 +1890,13 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
 		l2tp_session_set_header_len(session, tunnel->version);
 
+		err = l2tp_session_add_to_tunnel(tunnel, session);
+		if (err) {
+			kfree(session);
+
+			return ERR_PTR(err);
+		}
+
 		/* Bump the reference count. The session context is deleted
 		 * only when this drops to zero.
 		 */
@@ -1856,28 +1906,14 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 		/* Ensure tunnel socket isn't deleted */
 		sock_hold(tunnel->sock);
 
-		/* Add session to the tunnel's hash list */
-		write_lock_bh(&tunnel->hlist_lock);
-		hlist_add_head(&session->hlist,
-			       l2tp_session_id_hash(tunnel, session_id));
-		write_unlock_bh(&tunnel->hlist_lock);
-
-		/* And to the global session list if L2TPv3 */
-		if (tunnel->version != L2TP_HDR_VER_2) {
-			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
-
-			spin_lock_bh(&pn->l2tp_session_hlist_lock);
-			hlist_add_head_rcu(&session->global_hlist,
-					   l2tp_session_id_hash_2(pn, session_id));
-			spin_unlock_bh(&pn->l2tp_session_hlist_lock);
-		}
-
 		/* Ignore management session in session count value */
 		if (session->session_id != 0)
 			atomic_inc(&l2tp_session_count);
+
+		return session;
 	}
 
-	return session;
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(l2tp_session_create);
 
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index e253c26f31ac..c94160df71af 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -223,12 +223,6 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 p
 		goto out;
 	}
 
-	session = l2tp_session_find(net, tunnel, session_id);
-	if (session) {
-		rc = -EEXIST;
-		goto out;
-	}
-
 	if (cfg->ifname) {
 		dev = dev_get_by_name(net, cfg->ifname);
 		if (dev) {
@@ -242,8 +236,8 @@ static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 p
 
 	session = l2tp_session_create(sizeof(*spriv), tunnel, session_id,
 				      peer_session_id, cfg);
-	if (!session) {
-		rc = -ENOMEM;
+	if (IS_ERR(session)) {
+		rc = PTR_ERR(session);
 		goto out;
 	}
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 74b211312d4d..97155145c0c5 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -600,6 +600,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	int error = 0;
 	u32 tunnel_id, peer_tunnel_id;
 	u32 session_id, peer_session_id;
+	bool drop_refcnt = false;
 	int ver = 2;
 	int fd;
 
@@ -708,36 +709,36 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	if (tunnel->peer_tunnel_id == 0)
 		tunnel->peer_tunnel_id = peer_tunnel_id;
 
-	/* Create session if it doesn't already exist. We handle the
-	 * case where a session was previously created by the netlink
-	 * interface by checking that the session doesn't already have
-	 * a socket and its tunnel socket are what we expect. If any
-	 * of those checks fail, return EEXIST to the caller.
-	 */
-	session = l2tp_session_find(sock_net(sk), tunnel, session_id);
-	if (session == NULL) {
-		/* Default MTU must allow space for UDP/L2TP/PPP
-		 * headers.
+	session = l2tp_session_get(sock_net(sk), tunnel, session_id, false);
+	if (session) {
+		drop_refcnt = true;
+		ps = l2tp_session_priv(session);
+
+		/* Using a pre-existing session is fine as long as it hasn't
+		 * been connected yet.
 		 */
-		cfg.mtu = cfg.mru = 1500 - PPPOL2TP_HEADER_OVERHEAD;
+		if (ps->sock) {
+			error = -EEXIST;
+			goto end;
+		}
 
-		/* Allocate and initialize a new session context. */
-		session = l2tp_session_create(sizeof(struct pppol2tp_session),
-					      tunnel, session_id,
-					      peer_session_id, &cfg);
-		if (session == NULL) {
-			error = -ENOMEM;
+		/* consistency checks */
+		if (ps->tunnel_sock != tunnel->sock) {
+			error = -EEXIST;
 			goto end;
 		}
 	} else {
-		ps = l2tp_session_priv(session);
-		error = -EEXIST;
-		if (ps->sock != NULL)
-			goto end;
+		/* Default MTU must allow space for UDP/L2TP/PPP headers */
+		cfg.mtu = 1500 - PPPOL2TP_HEADER_OVERHEAD;
+		cfg.mru = cfg.mtu;
 
-		/* consistency checks */
-		if (ps->tunnel_sock != tunnel->sock)
+		session = l2tp_session_create(sizeof(struct pppol2tp_session),
+					      tunnel, session_id,
+					      peer_session_id, &cfg);
+		if (IS_ERR(session)) {
+			error = PTR_ERR(session);
 			goto end;
+		}
 	}
 
 	/* Associate session with its PPPoL2TP socket */
@@ -802,6 +803,8 @@ out_no_ppp:
 		  session->name);
 
 end:
+	if (drop_refcnt)
+		l2tp_session_dec_refcount(session);
 	release_sock(sk);
 
 	return error;
@@ -829,12 +832,6 @@ static int pppol2tp_session_create(struct net *net, u32 tunnel_id, u32 session_i
 	if (tunnel->sock == NULL)
 		goto out;
 
-	/* Check that this session doesn't already exist */
-	error = -EEXIST;
-	session = l2tp_session_find(net, tunnel, session_id);
-	if (session != NULL)
-		goto out;
-
 	/* Default MTU values. */
 	if (cfg->mtu == 0)
 		cfg->mtu = 1500 - PPPOL2TP_HEADER_OVERHEAD;
@@ -842,12 +839,13 @@ static int pppol2tp_session_create(struct net *net, u32 tunnel_id, u32 session_i
 		cfg->mru = cfg->mtu;
 
 	/* Allocate and initialize a new session context. */
-	error = -ENOMEM;
 	session = l2tp_session_create(sizeof(struct pppol2tp_session),
 				      tunnel, session_id,
 				      peer_session_id, cfg);
-	if (session == NULL)
+	if (IS_ERR(session)) {
+		error = PTR_ERR(session);
 		goto out;
+	}
 
 	ps = l2tp_session_priv(session);
 	ps->tunnel_sock = tunnel->sock;
-- 
2.26.0.rc2.310.g2932bb562d-goog

