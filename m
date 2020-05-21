Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772991DD053
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgEUOlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:52 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9091C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:50 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id o16so7900329qto.12
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fAMl/JYEZs5WPss7fIYebJgPccZuoP00TyEPQD59DbQ=;
        b=Bki7bOwxJROi41z6qfYJe7ILSaBuXBHWkmMoDvIRZu4fkRRzmmEyzsjP3bWWtDtWqS
         R+rsUS0ehi2ccoGjMWW+kNY0oThsqtioVIyv0uDzzUIPI1lorimo/nDUiC0tuJCmja2G
         fjhHpTzgNK3VFB3Sua7OP7cWwY7a9PLQIdUMOHTXeDnBMAZz2Deo8yExnVlu948u9Tm1
         WDc4h4vjMX2zr6ckoKkJZAyXgZ3gMs+MoDqBWqlKAM8smROTwxkLMzpLK2RlELnfa8RN
         wlucBBpUyPm1762PEjK50Mg8U6rbCFYLm7VmmadRzYu+HRlFwPNyIy4wEWCny7o7aFww
         iVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fAMl/JYEZs5WPss7fIYebJgPccZuoP00TyEPQD59DbQ=;
        b=f9nf1wUnVusxFCQHu346u54zRe4MblBbMwzIxBI53xBJXqJI6AbTBWjq6EBcjejrIS
         d4u177CxtOwaTgAbUd+jxP/GYwXklBGQpHYdAvIr1LMfX3xbLwhsfwnsnr8fwyHKyumt
         aZRt0l6ZELiXIKYm9KjHRLve4LGOtFsd+v6/xo+OSHvIr1gugyHcHoky20pgk8+1DkwQ
         mTJfXlmVeo5Qm73ee/D64PzdPe6O/fNcIJ2r3N/z+UblzTyTUc9vwE6OANjHLMqFpcIj
         QGH8D0hjYG9txjkRkpqAwts8TAMwqrgQjxpIN7aInTu9wiTmGQhOjS8cSero3SgO7r3q
         h3iA==
X-Gm-Message-State: AOAM532AUWBleiD9ruq91XHGMIVdFCg8fC0MD8XSp/hWedpPbRrEbW/w
        LC6eyDuVo95RsnJCjMj1VSNr4m0jTImovg==
X-Google-Smtp-Source: ABdhPJxZGWIdeA18vqbB2RFoUm9VoDA3+M4edH+TnO8JaKWovzl4BXNLvbEEPXV9qvtqSr92yh9MF1U5Cs0XYw==
X-Received: by 2002:a0c:9009:: with SMTP id o9mr6912809qvo.178.1590072110150;
 Thu, 21 May 2020 07:41:50 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:57 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-20-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 19/22] l2tp: don't register sessions in l2tp_session_create()
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

commit 3953ae7b218df4d1e544b98a393666f9ae58a78c uptream.

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
2.26.2.761.g0e0b3e54be-goog

