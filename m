Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60861DDB33
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEUXk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgEUXk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:26 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499D6C05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:26 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id p126so9196070qke.8
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ESpxO2pTQe64LrawuGtdBsFlDRbI89RVQivTHUFZEOc=;
        b=NTnfw2j06NOGqny8QvZkm2RwMbNmjWPwRyJVvQxOY1XoM8DIbz+U4QzZ5kclgDN46X
         So4yk2WeUtgg1oegYrM8d6TJM7CsmnsGHK74w5ADTBlDaV6u+DZFy791g6Ixm/uqlJBz
         8Jv2iNn6/yk5dOhDNAB24bpMUHknMuv9cy+ePH2KUHP8CoX1QlXYyM28Y5fZ3JQIQnW+
         NdYqCVwETbTlhc7poKvYCi1i+EFRcz+/q90Rp9yudD3hjuoCIVlgfD7fU8V7MSArgAti
         nrKdagzPDUkaYHOzMOCn+KzrHWv7FchZ7iuNrJhUAZINRAYQmqHg1/VesCgkKSYCe0Aj
         Mfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ESpxO2pTQe64LrawuGtdBsFlDRbI89RVQivTHUFZEOc=;
        b=oPC75eXGMm7ZPH/nwYHEOoQBkEpVR46rT3Wg7wRS6qRm5lNiYY1gdmF9HBNkpimYgE
         1S9McyZ0cT7o1mm0gM42JVltPayLadvJiw2JRBawariyifQzUlZwYUxxO/DJ5Ex+o8gS
         Zex10BzDig+GPtqcChU92PNMnxztx2qNpyfaSIE85c68mAbdE7EcZjEgUW0AG2jNBFfI
         zYG49IPKCzlefWnKJx6B57jTyYWVRxF/ieE4AvPfBrr/f6WoufnzkDgTxkMa9rWGTtVB
         PaX/QEmJsH/AEz9tAJRQ1IzbZu8/TfqHGsYoWJQ7e4lccAF6sZEU+cnvY09mKSILrT8r
         6BPg==
X-Gm-Message-State: AOAM533gV3fCGodPo9B8kk5wzjlNyTjNlC+BvwJ9ujcDtr/S1obQ/LTp
        rCADhD2zsCUQpH9UbUE+7G/JTzOsOffyxg==
X-Google-Smtp-Source: ABdhPJwz9sCPRsGzoba4+ajBUTm6ECAkSLl8utaO1JjjSgJekU48kGQVf3v74sgtFNTxY2/apesH2OlSgWRFjw==
X-Received: by 2002:ad4:588c:: with SMTP id dz12mr1226924qvb.196.1590104425416;
 Thu, 21 May 2020 16:40:25 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:34 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-20-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 19/22] l2tp: don't register sessions in l2tp_session_create()
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
---
 net/l2tp/l2tp_core.c | 21 +++++++--------------
 net/l2tp/l2tp_core.h |  3 +++
 net/l2tp/l2tp_eth.c  |  9 +++++++++
 net/l2tp/l2tp_ppp.c  | 23 +++++++++++++++++------
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3a7031426b46..36c7f616294a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -321,8 +321,8 @@ struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 }
 EXPORT_SYMBOL_GPL(l2tp_session_get_by_ifname);
 
-static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
-				      struct l2tp_session *session)
+int l2tp_session_register(struct l2tp_session *session,
+			  struct l2tp_tunnel *tunnel)
 {
 	struct l2tp_session *session_walk;
 	struct hlist_head *g_head;
@@ -370,6 +370,10 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 	hlist_add_head(&session->hlist, head);
 	write_unlock_bh(&tunnel->hlist_lock);
 
+	/* Ignore management session in session count value */
+	if (session->session_id != 0)
+		atomic_inc(&l2tp_session_count);
+
 	return 0;
 
 err_tlock_pnlock:
@@ -379,6 +383,7 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(l2tp_session_register);
 
 /* Lookup a tunnel by id
  */
@@ -1788,7 +1793,6 @@ EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
-	int err;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
 	if (session != NULL) {
@@ -1845,17 +1849,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
 		l2tp_session_inc_refcount(session);
 
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
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index fac92fda574d..2b9b6fb67ae9 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -259,6 +259,9 @@ struct l2tp_session *l2tp_session_create(int priv_size,
 					 struct l2tp_tunnel *tunnel,
 					 u32 session_id, u32 peer_session_id,
 					 struct l2tp_session_cfg *cfg);
+int l2tp_session_register(struct l2tp_session *session,
+			  struct l2tp_tunnel *tunnel);
+
 void __l2tp_session_unhash(struct l2tp_session *session);
 int l2tp_session_delete(struct l2tp_session *session);
 void l2tp_session_free(struct l2tp_session *session);
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index d22a39c0c486..5902d088b44f 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -267,6 +267,13 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 		goto out;
 	}
 
+	l2tp_session_inc_refcount(session);
+	rc = l2tp_session_register(session, tunnel);
+	if (rc < 0) {
+		kfree(session);
+		goto out;
+	}
+
 	dev = alloc_netdev(sizeof(*priv), name, NET_NAME_UNKNOWN,
 			   l2tp_eth_dev_setup);
 	if (!dev) {
@@ -298,6 +305,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	__module_get(THIS_MODULE);
 	/* Must be done after register_netdev() */
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
+	l2tp_session_dec_refcount(session);
 
 	dev_hold(dev);
 
@@ -308,6 +316,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
+	l2tp_session_dec_refcount(session);
 out:
 	return rc;
 }
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index c8f877bfb00f..e617993939d4 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -722,6 +722,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -807,7 +815,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
 		error = -ENOENT;
-		goto out;
+		goto err;
 	}
 
 	/* Default MTU values. */
@@ -822,18 +830,21 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
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
+	error = l2tp_session_register(session, tunnel);
+	if (error < 0)
+		goto err_sess;
 
-	error = 0;
+	return 0;
 
-out:
+err_sess:
+	kfree(session);
+err:
 	return error;
 }
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

