Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EDD1DD04F
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgEUOlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0219CC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:47 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 189so7617262qke.17
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qmzbFQOKe6k+Dn8Ylx363/a/muAJgl8NKg7fkxssOw4=;
        b=uqOXS9AHj0KYyj2wGK8hCRZ6bm5HOLFmKVrMo4f8yumpQjguKhgM3WbowjlsMBkznY
         GXpoOO02GzXqiP1W+kOwf5L7Oea8bzgazoSSeGxHlE1Rotspzm0fLeTtUG/baRQ4H/9K
         SMVDs514Ig4af45f3m1V7eBlnyJ3aMgRPM1s+2Wow5mgeHbESrljYirQTcsQgrw7Bfdc
         Fsjj2fd1q5QK0AYiuTpVoIYlwh3+Bz0IrG5EtACf0XwaQhzgkz4zDwrka0Hb3W+jSRAe
         K0qBEmDZcnRfgEKED0+VaMF4pPI16mGQAladmLof7PtFmD4KrtCpzA+MwFDFkjMCxqdI
         L97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qmzbFQOKe6k+Dn8Ylx363/a/muAJgl8NKg7fkxssOw4=;
        b=U2p/9X7pDFEXSvPT9KA1QbAuhLHIPUKNCvHv6E0Zd3SN98YmvfrpfwuFCTWspkfhai
         fMxAbdlflVYsGsV5kXPKRQxSa8fgPnuBs6PwysKTXlWjhC44f1H9/pxTQIxY+gJfiL09
         JkmFX2OVF//nWdr92mx09Hr3zTiAwHTGwU0H3dHogx+0mdBYF4ACOHNzF00sXFt01fXv
         qW81GYPgBCv1zl5w/H3KdcwqA7hEfrgzfjiv6/48BfjeeB4bXbWvJf6gTVwJikJpjG+y
         XWmf351OLM/BEkTlnjIkNTZloiM8A8J3Ps7rLnB8imoa2zRXZwrAO8IDzFEKq4eHhhg6
         fRYQ==
X-Gm-Message-State: AOAM533Cir4xZl7BRvL8sn3LhZwb+ejUe3BfqGtNVd/PjMcmr84axYXv
        xPfHiI/EN7RXsAtNOkOVHgA6iCDMlgJalQ==
X-Google-Smtp-Source: ABdhPJzwbWBN38Vafw14xAy6Vk+0+cs+7VIJBzqkcuM4cZ91sCCDfvOmZ3AUMgnHqikDkApmvYzRtswDW7qOEw==
X-Received: by 2002:ad4:47c8:: with SMTP id p8mr9986596qvw.93.1590072106214;
 Thu, 21 May 2020 07:41:46 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:55 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-18-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 17/22] l2tp: pass tunnel pointer to ->session_create()
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

commit f026bc29a8e093edfbb2a77700454b285c97e8ad uptream.

Using l2tp_tunnel_find() in pppol2tp_session_create() and
l2tp_eth_create() is racy, because no reference is held on the
returned session. These functions are only used to implement the
->session_create callback which is run by l2tp_nl_cmd_session_create().
Therefore searching for the parent tunnel isn't necessary because
l2tp_nl_cmd_session_create() already has a pointer to it and holds a
reference.

This patch modifies ->session_create()'s prototype to directly pass the
the parent tunnel as parameter, thus avoiding searching for it in
pppol2tp_session_create() and l2tp_eth_create().

Since we have to touch the ->session_create() call in
l2tp_nl_cmd_session_create(), let's also remove the useless conditional:
we know that ->session_create isn't NULL at this point because it's
already been checked earlier in this same function.

Finally, one might be tempted to think that the removed
l2tp_tunnel_find() calls were harmless because they would return the
same tunnel as the one held by l2tp_nl_cmd_session_create() anyway.
But that tunnel might be removed and a new one created with same tunnel
Id before the l2tp_tunnel_find() call. In this case l2tp_tunnel_find()
would return the new tunnel which wouldn't be protected by the
reference held by l2tp_nl_cmd_session_create().

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.h    |  4 +++-
 net/l2tp/l2tp_eth.c     | 11 +++--------
 net/l2tp/l2tp_netlink.c |  8 ++++----
 net/l2tp/l2tp_ppp.c     | 19 +++++++------------
 4 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 39a952962593..fac92fda574d 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -201,7 +201,9 @@ struct l2tp_tunnel {
 };
 
 struct l2tp_nl_cmd_ops {
-	int (*session_create)(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg);
+	int (*session_create)(struct net *net, struct l2tp_tunnel *tunnel,
+			      u32 session_id, u32 peer_session_id,
+			      struct l2tp_session_cfg *cfg);
 	int (*session_delete)(struct l2tp_session *session);
 };
 
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index f0efbf1e9a49..4c122494f022 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -256,23 +256,18 @@ static void l2tp_eth_adjust_mtu(struct l2tp_tunnel *tunnel,
 	dev->needed_headroom += session->hdr_len;
 }
 
-static int l2tp_eth_create(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
+static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
+			   u32 session_id, u32 peer_session_id,
+			   struct l2tp_session_cfg *cfg)
 {
 	struct net_device *dev;
 	char name[IFNAMSIZ];
-	struct l2tp_tunnel *tunnel;
 	struct l2tp_session *session;
 	struct l2tp_eth *priv;
 	struct l2tp_eth_sess *spriv;
 	int rc;
 	struct l2tp_eth_net *pn;
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (!tunnel) {
-		rc = -ENODEV;
-		goto out;
-	}
-
 	if (cfg->ifname) {
 		dev = dev_get_by_name(net, cfg->ifname);
 		if (dev) {
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 5ea5d3ffa309..47d7bdff8be8 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -632,10 +632,10 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		break;
 	}
 
-	ret = -EPROTONOSUPPORT;
-	if (l2tp_nl_cmd_ops[cfg.pw_type]->session_create)
-		ret = (*l2tp_nl_cmd_ops[cfg.pw_type]->session_create)(net, tunnel_id,
-			session_id, peer_session_id, &cfg);
+	ret = l2tp_nl_cmd_ops[cfg.pw_type]->session_create(net, tunnel,
+							   session_id,
+							   peer_session_id,
+							   &cfg);
 
 	if (ret >= 0) {
 		session = l2tp_session_get(net, tunnel, session_id, false);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 809606f2d54a..c8f877bfb00f 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -795,25 +795,20 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 
 #ifdef CONFIG_L2TP_V3
 
-/* Called when creating sessions via the netlink interface.
- */
-static int pppol2tp_session_create(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
+/* Called when creating sessions via the netlink interface. */
+static int pppol2tp_session_create(struct net *net, struct l2tp_tunnel *tunnel,
+				   u32 session_id, u32 peer_session_id,
+				   struct l2tp_session_cfg *cfg)
 {
 	int error;
-	struct l2tp_tunnel *tunnel;
 	struct l2tp_session *session;
 	struct pppol2tp_session *ps;
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-
-	/* Error if we can't find the tunnel */
-	error = -ENOENT;
-	if (tunnel == NULL)
-		goto out;
-
 	/* Error if tunnel socket is not prepped */
-	if (tunnel->sock == NULL)
+	if (!tunnel->sock) {
+		error = -ENOENT;
 		goto out;
+	}
 
 	/* Default MTU values. */
 	if (cfg->mtu == 0)
-- 
2.26.2.761.g0e0b3e54be-goog

