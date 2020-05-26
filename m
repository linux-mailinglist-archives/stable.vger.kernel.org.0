Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17731E2EA3
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgEZTAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389545AbgEZTAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCE28208B3;
        Tue, 26 May 2020 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519608;
        bh=GhOfn0vdFJuTF8cKtwsVeVBWJBrCxXFpqc+Hot9Cy6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWlhoFsj+u8FWOY+6vp7M4Of7ZjmKCNRVR0lE1lbFUhtG3NNeLTh1TYAKcawx7gRx
         sTgkD7tfSoHB3RiPOSOBg0ysB0WhlncDY0el2S9YBvICaFFKtNz3AH25F76IRfkY8s
         jKWZVzESG6avdcmDP7Ge0AfHmgBFwChCpo4LqdcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 42/64] l2tp: prevent creation of sessions on terminated tunnels
Date:   Tue, 26 May 2020 20:53:11 +0200
Message-Id: <20200526183927.768885483@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit f3c66d4e144a0904ea9b95d23ed9f8eb38c11bfb upstream.

l2tp_tunnel_destruct() sets tunnel->sock to NULL, then removes the
tunnel from the pernet list and finally closes all its sessions.
Therefore, it's possible to add a session to a tunnel that is still
reachable, but for which tunnel->sock has already been reset. This can
make l2tp_session_create() dereference a NULL pointer when calling
sock_hold(tunnel->sock).

This patch adds the .acpt_newsess field to struct l2tp_tunnel, which is
used by l2tp_tunnel_closeall() to prevent addition of new sessions to
tunnels. Resetting tunnel->sock is done after l2tp_tunnel_closeall()
returned, so that l2tp_session_add_to_tunnel() can safely take a
reference on it when .acpt_newsess is true.

The .acpt_newsess field is modified in l2tp_tunnel_closeall(), rather
than in l2tp_tunnel_destruct(), so that it benefits all tunnel removal
mechanisms. E.g. on UDP tunnels, a session could be added to a tunnel
after l2tp_udp_encap_destroy() proceeded. This would prevent the tunnel
from being removed because of the references held by this new session
on the tunnel and its socket. Even though the session could be removed
manually later on, this defeats the purpose of
commit 9980d001cec8 ("l2tp: add udp encap socket destroy handler").

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |   41 ++++++++++++++++++++++++++++-------------
 net/l2tp/l2tp_core.h |    4 ++++
 2 files changed, 32 insertions(+), 13 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -328,13 +328,21 @@ static int l2tp_session_add_to_tunnel(st
 	struct hlist_head *g_head;
 	struct hlist_head *head;
 	struct l2tp_net *pn;
+	int err;
 
 	head = l2tp_session_id_hash(tunnel, session->session_id);
 
 	write_lock_bh(&tunnel->hlist_lock);
+	if (!tunnel->acpt_newsess) {
+		err = -ENODEV;
+		goto err_tlock;
+	}
+
 	hlist_for_each_entry(session_walk, head, hlist)
-		if (session_walk->session_id == session->session_id)
-			goto exist;
+		if (session_walk->session_id == session->session_id) {
+			err = -EEXIST;
+			goto err_tlock;
+		}
 
 	if (tunnel->version == L2TP_HDR_VER_3) {
 		pn = l2tp_pernet(tunnel->l2tp_net);
@@ -342,12 +350,21 @@ static int l2tp_session_add_to_tunnel(st
 						session->session_id);
 
 		spin_lock_bh(&pn->l2tp_session_hlist_lock);
+
 		hlist_for_each_entry(session_walk, g_head, global_hlist)
-			if (session_walk->session_id == session->session_id)
-				goto exist_glob;
+			if (session_walk->session_id == session->session_id) {
+				err = -EEXIST;
+				goto err_tlock_pnlock;
+			}
 
+		l2tp_tunnel_inc_refcount(tunnel);
+		sock_hold(tunnel->sock);
 		hlist_add_head_rcu(&session->global_hlist, g_head);
+
 		spin_unlock_bh(&pn->l2tp_session_hlist_lock);
+	} else {
+		l2tp_tunnel_inc_refcount(tunnel);
+		sock_hold(tunnel->sock);
 	}
 
 	hlist_add_head(&session->hlist, head);
@@ -355,12 +372,12 @@ static int l2tp_session_add_to_tunnel(st
 
 	return 0;
 
-exist_glob:
+err_tlock_pnlock:
 	spin_unlock_bh(&pn->l2tp_session_hlist_lock);
-exist:
+err_tlock:
 	write_unlock_bh(&tunnel->hlist_lock);
 
-	return -EEXIST;
+	return err;
 }
 
 /* Lookup a tunnel by id
@@ -1246,7 +1263,6 @@ static void l2tp_tunnel_destruct(struct
 	/* Remove hooks into tunnel socket */
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
-	tunnel->sock = NULL;
 
 	/* Remove the tunnel struct from the tunnel list */
 	pn = l2tp_pernet(tunnel->l2tp_net);
@@ -1256,6 +1272,8 @@ static void l2tp_tunnel_destruct(struct
 	atomic_dec(&l2tp_tunnel_count);
 
 	l2tp_tunnel_closeall(tunnel);
+
+	tunnel->sock = NULL;
 	l2tp_tunnel_dec_refcount(tunnel);
 
 	/* Call the original destructor */
@@ -1280,6 +1298,7 @@ void l2tp_tunnel_closeall(struct l2tp_tu
 		  tunnel->name);
 
 	write_lock_bh(&tunnel->hlist_lock);
+	tunnel->acpt_newsess = false;
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
 again:
 		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
@@ -1583,6 +1602,7 @@ int l2tp_tunnel_create(struct net *net,
 	tunnel->magic = L2TP_TUNNEL_MAGIC;
 	sprintf(&tunnel->name[0], "tunl %u", tunnel_id);
 	rwlock_init(&tunnel->hlist_lock);
+	tunnel->acpt_newsess = true;
 
 	/* The net we belong to */
 	tunnel->l2tp_net = net;
@@ -1832,11 +1852,6 @@ struct l2tp_session *l2tp_session_create
 			return ERR_PTR(err);
 		}
 
-		l2tp_tunnel_inc_refcount(tunnel);
-
-		/* Ensure tunnel socket isn't deleted */
-		sock_hold(tunnel->sock);
-
 		/* Ignore management session in session count value */
 		if (session->session_id != 0)
 			atomic_inc(&l2tp_session_count);
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -162,6 +162,10 @@ struct l2tp_tunnel {
 
 	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
+	bool			acpt_newsess;	/* Indicates whether this
+						 * tunnel accepts new sessions.
+						 * Protected by hlist_lock.
+						 */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,
 						 * hashed by id */


