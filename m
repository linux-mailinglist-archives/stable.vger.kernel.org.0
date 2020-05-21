Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12D71DDB7B
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgEUX6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbgEUX6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:40 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E876C05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:40 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h15so8936050qvk.0
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QDgtCb9a9owBuS0HO+mapYsH9adPvP1qbcIoo2x/Qxc=;
        b=hDKsM/npM5omY06NFCEdrfB42eaVDrnIgeFip1NSc6sifvQQSgvkzjJRZ/t199mk7V
         igiesAAPiQtUhu5V4tq/AtIkZsfBacGG4dBma55pWJHGzM0XBdEoJRSRiNst6HI9bsTy
         jE+c866QEompHmB8mTtJO4hHzXlz44M8LXrkKgoJ9ROhvt0xMDyVZwbvK+2jIakTtyfz
         1403C5jtNlZz2b9aT47nx8SvNqQ1l7d1ddXV06gUDQxE56mDIkYdmlfLMZhbjrVJLrfL
         R1sOj90ou1u/Nj4piFjY3y1rcftmruE0By9Mx3kv1Ws/5IY5mrvtg9Jwg19RMDA2Onkv
         9q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QDgtCb9a9owBuS0HO+mapYsH9adPvP1qbcIoo2x/Qxc=;
        b=XiiFlYIrrRdHtdXvToqCqe85Ca8PyM5tku9S0iInY6IWL5WBlqW3BonvWktrAHApCL
         OgLDnpfDO/wSxO0d0F+6c5uOVnC2jDgfYQS813gMwIN2XWmsSbiem7BXLu1nAqLW9ulI
         rmkNOlVlICzy3DlZOSFUmphFI8anJ5vyH6eF/shBYDo0laKkcztgkpeNV1052Q4mJTXQ
         1Yqr9LT/P9m9juJO61VToBp38lSpUE0LfkuWTEMBZuxvI95sQlPyrRdYWdoDwTQ1HPvr
         l5B9yiINVzAZnixMpmEhog5RgSQvIfK4EnCPm3nFxw5SgkdbGeCtPRwwcdq/Vm9xx3go
         I1fQ==
X-Gm-Message-State: AOAM532tl+J31ZqFclId+x9nGVjLK02ZdfSed9JoxPb7iej3+YCg4zbC
        e55k2BKSoh1yamFfvBTAgIChcFxKWbL+kA==
X-Google-Smtp-Source: ABdhPJzu9vWuN0FWxLaXyZUqd6RZ+iBskM/IQM9QsxVjkzdoYDkcdqdD5VBk0wPCu4Nqvd1V7sRL1QkAbfS3bA==
X-Received: by 2002:a0c:b258:: with SMTP id k24mr1265920qve.198.1590105519580;
 Thu, 21 May 2020 16:58:39 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:35 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-23-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 22/27] l2tp: pass tunnel pointer to ->session_create()
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
index 8a5d51cff2f3..09cd58f03d89 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -204,7 +204,9 @@ struct l2tp_tunnel {
 };
 
 struct l2tp_nl_cmd_ops {
-	int (*session_create)(struct net *net, u32 tunnel_id, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg);
+	int (*session_create)(struct net *net, struct l2tp_tunnel *tunnel,
+			      u32 session_id, u32 peer_session_id,
+			      struct l2tp_session_cfg *cfg);
 	int (*session_delete)(struct l2tp_session *session);
 };
 
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index cef312da3422..c785308f630b 100644
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
index 22917e751edf..d3a84a181348 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -627,10 +627,10 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
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
index 5738456b3b58..377ef5f0f39a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -810,25 +810,20 @@ end:
 
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

