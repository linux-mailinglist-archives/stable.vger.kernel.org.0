Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F251E2B26
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391105AbgEZTCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390101AbgEZTCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:02:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB5820849;
        Tue, 26 May 2020 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519749;
        bh=odxiVlHKqrBVzskmWVnwdeoIqm6+/sYO0bcej3vVmf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHE5DIliDkdQ82aeor+PPBLIFgo/LsEqcbOZmOceYPa0Dw3xSDe6tJ7ylpZpJvYpl
         At1mVanRWitxOnnw7WVwnF8UjIDbq4hdF8S/14JJDkwaPQCfzCt8Ec0WKJZXe45itM
         /h4zgotMIFj4na/GRU2hNjbE3cGgvmw3CQ8hdt5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.14 31/59] l2tp: dont register sessions in l2tp_session_create()
Date:   Tue, 26 May 2020 20:53:16 +0200
Message-Id: <20200526183918.246637770@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 3953ae7b218df4d1e544b98a393666f9ae58a78c upstream.

Sessions created by l2tp_session_create() aren't fully initialised:
some pseudo-wire specific operations need to be done before making the
session usable. Therefore the PPP and Ethernet pseudo-wires continue
working on the returned l2tp session while it's already been exposed to
the rest of the system.
This can lead to various issues. In particular, the session may enter
the deletion process before having been fully initialised, which will
confuse the session removal code.

This patch moves session registration out of l2tp_session_create(), so
that callers can control when the session is exposed to the rest of the
system. This is done by the new l2tp_session_register() function.

Only pppol2tp_session_create() can be easily converted to avoid
modifying its session after registration (the debug message is dropped
in order to avoid the need for holding a reference on the session).

For pppol2tp_connect() and l2tp_eth_create()), more work is needed.
That'll be done in followup patches. For now, let's just register the
session right after its creation, like it was done before. The only
difference is that we can easily take a reference on the session before
registering it, so, at least, we're sure it's not going to be freed
while we're working on it.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_core.c |   21 +++++++--------------
 net/l2tp/l2tp_core.h |    3 +++
 net/l2tp/l2tp_eth.c  |    9 +++++++++
 net/l2tp/l2tp_ppp.c  |   27 +++++++++++++++++++--------
 4 files changed, 38 insertions(+), 22 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -328,8 +328,8 @@ struct l2tp_session *l2tp_session_get_by
 }
 EXPORT_SYMBOL_GPL(l2tp_session_get_by_ifname);
 
-static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
-				      struct l2tp_session *session)
+int l2tp_session_register(struct l2tp_session *session,
+			  struct l2tp_tunnel *tunnel)
 {
 	struct l2tp_session *session_walk;
 	struct hlist_head *g_head;
@@ -382,6 +382,10 @@ static int l2tp_session_add_to_tunnel(st
 	hlist_add_head(&session->hlist, head);
 	write_unlock_bh(&tunnel->hlist_lock);
 
+	/* Ignore management session in session count value */
+	if (session->session_id != 0)
+		atomic_inc(&l2tp_session_count);
+
 	return 0;
 
 err_tlock_pnlock:
@@ -391,6 +395,7 @@ err_tlock:
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(l2tp_session_register);
 
 /* Lookup a tunnel by id
  */
@@ -1791,7 +1796,6 @@ EXPORT_SYMBOL_GPL(l2tp_session_set_heade
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
-	int err;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
 	if (session != NULL) {
@@ -1848,17 +1852,6 @@ struct l2tp_session *l2tp_session_create
 
 		refcount_set(&session->ref_count, 1);
 
-		err = l2tp_session_add_to_tunnel(tunnel, session);
-		if (err) {
-			kfree(session);
-
-			return ERR_PTR(err);
-		}
-
-		/* Ignore management session in session count value */
-		if (session->session_id != 0)
-			atomic_inc(&l2tp_session_count);
-
 		return session;
 	}
 
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -257,6 +257,9 @@ struct l2tp_session *l2tp_session_create
 					 struct l2tp_tunnel *tunnel,
 					 u32 session_id, u32 peer_session_id,
 					 struct l2tp_session_cfg *cfg);
+int l2tp_session_register(struct l2tp_session *session,
+			  struct l2tp_tunnel *tunnel);
+
 void __l2tp_session_unhash(struct l2tp_session *session);
 int l2tp_session_delete(struct l2tp_session *session);
 void l2tp_session_free(struct l2tp_session *session);
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -271,6 +271,13 @@ static int l2tp_eth_create(struct net *n
 		goto out;
 	}
 
+	l2tp_session_inc_refcount(session);
+	rc = l2tp_session_register(session, tunnel);
+	if (rc < 0) {
+		kfree(session);
+		goto out;
+	}
+
 	dev = alloc_netdev(sizeof(*priv), name, name_assign_type,
 			   l2tp_eth_dev_setup);
 	if (!dev) {
@@ -304,6 +311,7 @@ static int l2tp_eth_create(struct net *n
 	__module_get(THIS_MODULE);
 	/* Must be done after register_netdev() */
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
+	l2tp_session_dec_refcount(session);
 
 	dev_hold(dev);
 
@@ -314,6 +322,7 @@ out_del_dev:
 	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
+	l2tp_session_dec_refcount(session);
 out:
 	return rc;
 }
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -725,6 +725,14 @@ static int pppol2tp_connect(struct socke
 			error = PTR_ERR(session);
 			goto end;
 		}
+
+		l2tp_session_inc_refcount(session);
+		error = l2tp_session_register(session, tunnel);
+		if (error < 0) {
+			kfree(session);
+			goto end;
+		}
+		drop_refcnt = true;
 	}
 
 	/* Associate session with its PPPoL2TP socket */
@@ -812,7 +820,7 @@ static int pppol2tp_session_create(struc
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
 		error = -ENOENT;
-		goto out;
+		goto err;
 	}
 
 	/* Default MTU values. */
@@ -827,18 +835,21 @@ static int pppol2tp_session_create(struc
 				      peer_session_id, cfg);
 	if (IS_ERR(session)) {
 		error = PTR_ERR(session);
-		goto out;
+		goto err;
 	}
 
 	ps = l2tp_session_priv(session);
 	ps->tunnel_sock = tunnel->sock;
 
-	l2tp_info(session, L2TP_MSG_CONTROL, "%s: created\n",
-		  session->name);
-
-	error = 0;
-
-out:
+	error = l2tp_session_register(session, tunnel);
+	if (error < 0)
+		goto err_sess;
+
+	return 0;
+
+err_sess:
+	kfree(session);
+err:
 	return error;
 }
 


