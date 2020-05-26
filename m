Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5381E2A8C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389923AbgEZS4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389878AbgEZS4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A185208B8;
        Tue, 26 May 2020 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519400;
        bh=7DS2A0EJ3f3Yv130Cb7Cyt+yhkvkhU1eyAU4WfZqFhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVWHx3t+RcwLFX073ennJOgkzryQtEGYcS7LzOSFqZj8d6ncKzn3pxsTMQD7g0i1r
         9Ov6eqo9KyESjcWAs1xJxPQVbIb0BVi6R3tNAokUx6jjQeKR2Rh4aWB8/0ssY897CE
         9FSYu3+1FpuA6Z8a/AaJN4lyY2YDx66Vbb9LAt7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 55/65] l2tp: pass tunnel pointer to ->session_create()
Date:   Tue, 26 May 2020 20:53:14 +0200
Message-Id: <20200526183925.703349691@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.h    |    4 +++-
 net/l2tp/l2tp_eth.c     |   11 +++--------
 net/l2tp/l2tp_netlink.c |    8 ++++----
 net/l2tp/l2tp_ppp.c     |   19 +++++++------------
 4 files changed, 17 insertions(+), 25 deletions(-)

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
 
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -256,23 +256,18 @@ static void l2tp_eth_adjust_mtu(struct l
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
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -627,10 +627,10 @@ static int l2tp_nl_cmd_session_create(st
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


