Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F121DCEB3
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgEUN5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 09:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEUN5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 09:57:11 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01397C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:11 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z1so7200063qvd.23
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+OlTWOt1upQu3WGVQAUK7ml0jxpqsvEy1fyGPJs0s6U=;
        b=M+BBmy0dC5dhYj/Cquk4eDaHWis76oWzlxG5/qaV0VFgqLzhLMCoTWAyVKEr4qZV1v
         c/y2CziiGQ9I9MHS70TX78dSSpaXBmdnisELA3SV0ooRsoK96HiymM5BR7DNklzvLbZS
         5WCue15jrgeJ/xC26cREky3tJ2Tu+7zBJWn6qdrw/vNP5Zf7eD275/jRO2F3iTFK5KqK
         +m4sTKdmGMwPS0ZXyCos0TIBeUjwTp5/JsM60sbaANgmiRt3da11RhR/huCqgc6jw6Am
         ToWH5PqAv0nTUOlgI5WF/W2AF12eP7rWTNIHbYEezI/ZWJG86vQB1PXoY7uZihGKjP2D
         otzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+OlTWOt1upQu3WGVQAUK7ml0jxpqsvEy1fyGPJs0s6U=;
        b=jGG6J9E3abLxjRfjbx9wmp9NNU0obbZGCGn4809EKB6/xBFuDI9kHwnLvIRGyckSPo
         MQVM566BUBbR2noL+FpQQ3g0lQHTDZ9EIlGYdk5djHf3AL1FuUeMzT7BLlt6aO0hwAaD
         ZIuS3yeuTbwB5cHvmrwXn7WU/d/UziV4ai66aEGaNTP6RDpUKMI2wTfJrdfOuqHqTCUq
         Ap9upGXbzOZJO3gFvj459cDWC2nxdTfqmUTl5BW1QHM+9qVgChy67VHa5Gx+heMFFHhT
         nZ6HStB6hVpbEPDligRaILi5tvUlvlQptfBDf3kQQOcC9G9fDTYWsc9+fUTgUDLJidyz
         dBMA==
X-Gm-Message-State: AOAM532EUtaAmTr2eHu2CSgg+ao3AONb8m/UrqsuXFJXCUr7tmNipacS
        GYIx6g8Z3ue6T4n1eSYhAlF8r7Ye8pU4gA==
X-Google-Smtp-Source: ABdhPJzM672TKeRkCnnVAiF05DBNERJ6CkCnX3IBIFL4jvrOAucn9lxz1Oqe3FO6XQ5SBIRMBrZZY5t1GPtgNg==
X-Received: by 2002:a05:6214:1248:: with SMTP id q8mr9811713qvv.130.1590069430026;
 Thu, 21 May 2020 06:57:10 -0700 (PDT)
Date:   Thu, 21 May 2020 14:57:01 +0100
In-Reply-To: <20200521135704.109812-1-gprocida@google.com>
Message-Id: <20200521135704.109812-2-gprocida@google.com>
Mime-Version: 1.0
References: <20200521135704.109812-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 1/4] l2tp: don't register sessions in l2tp_session_create()
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
index b8c90f8d1a57..c3f8bac32584 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -328,8 +328,8 @@ struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 }
 EXPORT_SYMBOL_GPL(l2tp_session_get_by_ifname);
 
-static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
-				      struct l2tp_session *session)
+int l2tp_session_register(struct l2tp_session *session,
+			  struct l2tp_tunnel *tunnel)
 {
 	struct l2tp_session *session_walk;
 	struct hlist_head *g_head;
@@ -382,6 +382,10 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 	hlist_add_head(&session->hlist, head);
 	write_unlock_bh(&tunnel->hlist_lock);
 
+	/* Ignore management session in session count value */
+	if (session->session_id != 0)
+		atomic_inc(&l2tp_session_count);
+
 	return 0;
 
 err_tlock_pnlock:
@@ -391,6 +395,7 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(l2tp_session_register);
 
 /* Lookup a tunnel by id
  */
@@ -1791,7 +1796,6 @@ EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
-	int err;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
 	if (session != NULL) {
@@ -1848,17 +1852,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
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
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 62598ee7b2e7..e75748cdedb9 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -257,6 +257,9 @@ struct l2tp_session *l2tp_session_create(int priv_size,
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
index 014a7bc2a872..a7d76f5f31ff 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -271,6 +271,13 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
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
@@ -304,6 +311,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	__module_get(THIS_MODULE);
 	/* Must be done after register_netdev() */
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
+	l2tp_session_dec_refcount(session);
 
 	dev_hold(dev);
 
@@ -314,6 +322,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	spriv->dev = NULL;
 out_del_session:
 	l2tp_session_delete(session);
+	l2tp_session_dec_refcount(session);
 out:
 	return rc;
 }
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index a7fcf48e9087..7ed06c420150 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -725,6 +725,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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
@@ -812,7 +820,7 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
 	/* Error if tunnel socket is not prepped */
 	if (!tunnel->sock) {
 		error = -ENOENT;
-		goto out;
+		goto err;
 	}
 
 	/* Default MTU values. */
@@ -827,18 +835,21 @@ static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
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
2.26.2.761.g0e0b3e54be-goog

