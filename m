Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F91DDB7C
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgEUX6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgEUX6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:39 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39854C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:38 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x30so9700717qte.14
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XH1iAglOv1m7EVSKJ2OkdN1HZe4j0CthK4kt3SM+F/8=;
        b=dk4rLFoJcQGj7jxY96B9Wbn/yE9FDitDpnW9++RLaqq+FjUdcjMRnw6dZWNgoKaNAI
         FwNcXg7BQc0WKrw4hNjOE9UPLUJhIr0h0OTaiCLwS554EoXXxNXT0zEAXe2iV/Lt3tZc
         B7/VTOpngyVgYGM572GKbi6ZYpyrAgtGF2/ccD8kQtpIEFXo+ObUMncnELY5C0Dc394Y
         aZFu38ytgm4kyUitFVrgdoRKy4bA+aMNZJviyV545aOgpSNQ6aiig+PdUKY0FuECRrSg
         bTGsicA7wuqxQkP9dPp2sCVrbN8qC9XgIc9I+oVUG7AKvymXgcvuJkFk+nP+a3hevkY3
         u4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XH1iAglOv1m7EVSKJ2OkdN1HZe4j0CthK4kt3SM+F/8=;
        b=D4L3M7CW1w01+s2ze2XWODLRQK/NrGUNiMcRhkRxuL/tdJlew7Zz6zdJUBmWsBQGQo
         zOyBSR/SoRR1stz0utP14RwC3JRB+5A12nF939opsjhp2CDwbH3MP5UKqvA9FySuJ5ub
         +u9AlXF96/WnU8a/JdYTu5eLMlmMpmq5kqlkwOBC4/pp/Ri9sD4u5HJh2rfARMg5J1oa
         FH2RO0BVEkxYhYxV9OOwGVQ+afAMSprOli/lz7et0KvLwmVKi0zZrrOX8Uzje302sYIg
         MPptURrRF3yOhkSnWFLDBFS6TFHdSl91qBM7qsfOeHeD/45nnuXCoa++IPR9cLyN0Nmt
         44XQ==
X-Gm-Message-State: AOAM530gV90N+lvElLDxkJx4xdoHR5KQdqmfybDd0KlvSwMCw+YWBRWy
        K1rSCOmk4IZk+WtIh8v8/C2H9FU8E4e1ZQ==
X-Google-Smtp-Source: ABdhPJxfvvnCzymdlUrFM6OU3XrcFD3yx+Qai2Idb5/h5fUJ2CSnbOYYsZ9j4IRBSAMhOP1z7q9izxNfoc1f6g==
X-Received: by 2002:a0c:b25b:: with SMTP id k27mr1169389qve.155.1590105517350;
 Thu, 21 May 2020 16:58:37 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:34 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-22-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 21/27] l2tp: prevent creation of sessions on terminated tunnels
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
---
 net/l2tp/l2tp_core.c | 41 ++++++++++++++++++++++++++++-------------
 net/l2tp/l2tp_core.h |  4 ++++
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e5210cf8cb59..ba11e72a2365 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -328,13 +328,21 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
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
@@ -342,12 +350,21 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
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
@@ -355,12 +372,12 @@ static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 
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
@@ -1251,7 +1268,6 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	/* Remove hooks into tunnel socket */
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
-	tunnel->sock = NULL;
 
 	/* Remove the tunnel struct from the tunnel list */
 	pn = l2tp_pernet(tunnel->l2tp_net);
@@ -1261,6 +1277,8 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	atomic_dec(&l2tp_tunnel_count);
 
 	l2tp_tunnel_closeall(tunnel);
+
+	tunnel->sock = NULL;
 	l2tp_tunnel_dec_refcount(tunnel);
 
 	/* Call the original destructor */
@@ -1285,6 +1303,7 @@ void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 		  tunnel->name);
 
 	write_lock_bh(&tunnel->hlist_lock);
+	tunnel->acpt_newsess = false;
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
 again:
 		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
@@ -1588,6 +1607,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	tunnel->magic = L2TP_TUNNEL_MAGIC;
 	sprintf(&tunnel->name[0], "tunl %u", tunnel_id);
 	rwlock_init(&tunnel->hlist_lock);
+	tunnel->acpt_newsess = true;
 
 	/* The net we belong to */
 	tunnel->l2tp_net = net;
@@ -1838,11 +1858,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
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
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 0d4590b25592..8a5d51cff2f3 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -165,6 +165,10 @@ struct l2tp_tunnel {
 
 	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
+	bool			acpt_newsess;	/* Indicates whether this
+						 * tunnel accepts new sessions.
+						 * Protected by hlist_lock.
+						 */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
 						/* hashed list of sessions,
 						 * hashed by id */
-- 
2.27.0.rc0.183.gde8f92d652-goog

