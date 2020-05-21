Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99A1DDB7E
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgEUX6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgEUX6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9094FC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r18so7245912ybg.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fH4fwodxMJJdjIP2FDH20J+t5uLkw1tiH+QcSChEMJo=;
        b=iHahdduKyRJ2FG1IIxmX1N4i+z5Zyg5hZa7Jmp/X3d7RHvuNt7/NpGGqIaVih3dTj0
         0JK9uPBb4bdxbrQMaJzyM+YlkbwKRFEk/9HO1sX2V97zTSc3eusEjYHbrOa9C+drTUXa
         cxReHvVz8EMhswOWIfjp4tghVKInAqqVIj5oZEGv45lPkWiELarEz/7LrvLxV4CxaUIX
         Lwl+jyWNpVG4QCgm4hv/5TgADSq73YIBcwLB79b8ODK8BOdSogBM+JFXh5dcyDkI44ZO
         eKnv76MIikqvM67WV/bRDx66MKm7QP9UAHGTd4cwy/qY7G93zGH6h0H+eAjfEYq0QVTr
         n1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fH4fwodxMJJdjIP2FDH20J+t5uLkw1tiH+QcSChEMJo=;
        b=Y+E7nVNfKekwW8ILS2PQMTf32Qv1tfL1u0tN6jko1HW7z/CSX3CSzZ/LUBNzok8Eoz
         ledR0HB1iC4dWDO+e8PmqCXlfzLlt6cSs+nROs+g7S9ILNiOAU3t7H8lsU83Uj2JcNAF
         gvrZuSIntsBGGB787WZPcPji2Bm0Lo5fmo7ovsYFvwdxJOAHt3QizlkJdb+tMfPMU2qV
         HpPbmdPJJ969nlVDxWn9ExHYPb28oAOrb8s2usZafuejiy2QaIAXxWotAeDbsinO2wcV
         cTSD0OaHCJ5LaI9SEHSrdNZTplVLBgGO3SU3NIX9fhwntyi2e58BTVy/CltSDTrXIdyo
         V1dg==
X-Gm-Message-State: AOAM531/5LKqwan4iCxiEskMjp5+/jLlo9YE2TBlF/ixN05UgikdW758
        4TTz+8edXHVS4OZo1x3qYcbSzgBiTJ9/0A==
X-Google-Smtp-Source: ABdhPJyXk2k6LLA7ZuuYcEHwaWGy6Qtrlh2bEnZF3ayKtGni8Urp98VFlSm4hipiuIJpq/kW4vFxI6HqxLKYRg==
X-Received: by 2002:a25:20c4:: with SMTP id g187mr20579686ybg.385.1590105523833;
 Thu, 21 May 2020 16:58:43 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:37 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-25-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 24/27] l2tp: don't register sessions in l2tp_session_create()
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
index ba11e72a2365..0233c496fc51 100644
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
@@ -379,6 +383,7 @@ err_tlock:
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(l2tp_session_register);
 
 /* Lookup a tunnel by id
  */
@@ -1793,7 +1798,6 @@ EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
-	int err;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
 	if (session != NULL) {
@@ -1851,17 +1855,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
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
index 09cd58f03d89..57da0f1d62dd 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -262,6 +262,9 @@ struct l2tp_session *l2tp_session_create(int priv_size,
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
index ab6d2152eafb..750662de735e 100644
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
 
@@ -308,6 +316,7 @@ out_del_dev:
 	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
+	l2tp_session_dec_refcount(session);
 out:
 	return rc;
 }
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 377ef5f0f39a..ebb24a7120ca 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -737,6 +737,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -822,7 +830,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
 		error = -ENOENT;
-		goto out;
+		goto err;
 	}
 
 	/* Default MTU values. */
@@ -837,18 +845,21 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
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

