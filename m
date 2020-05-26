Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B21D1E2AA0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389312AbgEZS5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389284AbgEZS5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A327420849;
        Tue, 26 May 2020 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519449;
        bh=E5gepei49UVhAh6Fb77bky09GX64a6eEvd/goBsZUV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaPqnscfH9joBP5uPjRlXOKCTN2ySoi9C21k2i7I90QBCwHAhxDtJg2kBGQZAgPci
         jm8ghD3ofcq4h0tipp7TAdpAsV6aPDNelVDLPFXArB3y6LZYEiHgh6IVWvwvrpXsp+
         TROHYMGz6zY1asCCY+d6TG5H3WhDKEpmI3QRuUJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 45/65] l2tp: remove l2tp_session_find()
Date:   Tue, 26 May 2020 20:53:04 +0200
Message-Id: <20200526183921.591461247@linuxfoundation.org>
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

commit 55a3ce3b9d98f752df9e2cfb1cba7e715522428a upstream.

This function isn't used anymore.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |   51 +--------------------------------------------------
 net/l2tp/l2tp_core.h |    3 ---
 2 files changed, 1 insertion(+), 53 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -216,27 +216,6 @@ static void l2tp_tunnel_sock_put(struct
 	sock_put(sk);
 }
 
-/* Lookup a session by id in the global session list
- */
-static struct l2tp_session *l2tp_session_find_2(struct net *net, u32 session_id)
-{
-	struct l2tp_net *pn = l2tp_pernet(net);
-	struct hlist_head *session_list =
-		l2tp_session_id_hash_2(pn, session_id);
-	struct l2tp_session *session;
-
-	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu(session, session_list, global_hlist) {
-		if (session->session_id == session_id) {
-			rcu_read_unlock_bh();
-			return session;
-		}
-	}
-	rcu_read_unlock_bh();
-
-	return NULL;
-}
-
 /* Session hash list.
  * The session_id SHOULD be random according to RFC2661, but several
  * L2TP implementations (Cisco and Microsoft) use incrementing
@@ -249,35 +228,7 @@ l2tp_session_id_hash(struct l2tp_tunnel
 	return &tunnel->session_hlist[hash_32(session_id, L2TP_HASH_BITS)];
 }
 
-/* Lookup a session by id
- */
-struct l2tp_session *l2tp_session_find(struct net *net, struct l2tp_tunnel *tunnel, u32 session_id)
-{
-	struct hlist_head *session_list;
-	struct l2tp_session *session;
-
-	/* In L2TPv3, session_ids are unique over all tunnels and we
-	 * sometimes need to look them up before we know the
-	 * tunnel.
-	 */
-	if (tunnel == NULL)
-		return l2tp_session_find_2(net, session_id);
-
-	session_list = l2tp_session_id_hash(tunnel, session_id);
-	read_lock_bh(&tunnel->hlist_lock);
-	hlist_for_each_entry(session, session_list, hlist) {
-		if (session->session_id == session_id) {
-			read_unlock_bh(&tunnel->hlist_lock);
-			return session;
-		}
-	}
-	read_unlock_bh(&tunnel->hlist_lock);
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(l2tp_session_find);
-
-/* Like l2tp_session_find() but takes a reference on the returned session.
+/* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
 struct l2tp_session *l2tp_session_get(struct net *net,
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -237,9 +237,6 @@ out:
 struct l2tp_session *l2tp_session_get(struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
-struct l2tp_session *l2tp_session_find(struct net *net,
-				       struct l2tp_tunnel *tunnel,
-				       u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
 struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,


