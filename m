Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB31DDB31
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgEUXkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:23 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EB4C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:22 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b22so9624287qto.17
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NSiHD6xElKDF4dv65EwWyoA4/Jk5Hzf0tl3qj8sIlIg=;
        b=Ys0qk4vA1pzuyfm4E9PTpFoQAemPTjtwmMqBaBk3+K6iTRyPhLiLPo8pxbmUmpvU4n
         7ebAiyVOywz7n+q0oYhBILRI1TOD2JO6YT99W5G3xdXtndi5ajRQUyLW9S5iMAcCTWnm
         gXcnt80TcUvl6F0gglEpeljpCw5MpGIZYkBVqZF+IwD67P8kcIRiylQWTCZ8rRLi6ora
         uijrUXdFeAv6+Iv5p6Wmj4WB3yRQDk8JElmEWobcHOfz9//ghGORvXT+2gYnEIDKl24d
         p/Mu6sEDsZrJV33iRz262bqBOU8Z1iAVQ3m4hSaSOCgChs8VsMQYk5fIj8PZ772COq5Z
         jBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NSiHD6xElKDF4dv65EwWyoA4/Jk5Hzf0tl3qj8sIlIg=;
        b=J+DbfHNw9jtmdoskTlgLjocpI0DnqR+ESKeCo95C8/wlO1wLa5BzbaUIR2A5JLSleG
         xUG8av75gnuYlHe/xdcukJUTo7v/0Vs0ZBRc80RIfM/Nu95ed1wM/YJ+EUJsQ8lKIiRS
         eQ9rhn62q94HV2jNE82MuX0tHwe+17LC+nEPvw0SfKcXAFrsqigOEqcvFrK5B4FjJBWn
         4hA2ZocK0Vk2s7fnpxmxJTzUa/Zq8I9tXvPJOPTE2lJvWp7OGVKOhdoFZy6oSZsnpBdD
         oKLv6caJ/ASpi+9o9cjNtoHz2sG/vPxkqDGPtWvNfxlz29h1K72NiqMGodf0Sa2qr9yM
         6ftQ==
X-Gm-Message-State: AOAM533B3a5FFDXpPK+B0zk4BaH6Yo6V5OGbsjxFh7r52QmTXE57c613
        RLPwycLXdDUYHM+mnaOaw5vHU/WK/mOJ8g==
X-Google-Smtp-Source: ABdhPJxV3nx8fzsf8/XQDEYXwJ/jOu7NzXhGrkqpRw9BifR7XChX9KtoDEHzYfHwL28Ca9UxpynuJXY4OQTvIA==
X-Received: by 2002:a05:6214:122e:: with SMTP id p14mr1212237qvv.168.1590104421229;
 Thu, 21 May 2020 16:40:21 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:32 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-18-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 17/22] l2tp: pass tunnel pointer to ->session_create()
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

commit f026bc29a8e093edfbb2a77700454b285c97e8ad upstream.

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
2.27.0.rc0.183.gde8f92d652-goog

