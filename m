Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC111E2F13
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgEZS4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389692AbgEZS4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D228921531;
        Tue, 26 May 2020 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519360;
        bh=Lq89cpTv3sSw1MwZI64gGmvNy5zeoDnw9d7XelhkLBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMu+0FlbpB8eG1Qpmogq8M6r8BGgnvh9VuoXrx03fAfpOw566lmkNYiNa+1HkczkE
         +YqoNaF3UUVw0NWBJCo3PqogdKne9+Xc2lXHP30rtN8WMWrvv6WqO4xk0crFHq+YdC
         sIDQymVjwkq0Lan9BYFlu1Odd4axcJ/+X+Dmrw9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Amit Pundir <amit.pundir@linaro.org>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 37/65] l2tp: take a reference on sessions used in genetlink handlers
Date:   Tue, 26 May 2020 20:52:56 +0200
Message-Id: <20200526183918.883341173@linuxfoundation.org>
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

commit 2777e2ab5a9cf2b4524486c6db1517a6ded25261 upstream.

Callers of l2tp_nl_session_find() need to hold a reference on the
returned session since there's no guarantee that it isn't going to
disappear from under them.

Relying on the fact that no l2tp netlink message may be processed
concurrently isn't enough: sessions can be deleted by other means
(e.g. by closing the PPPOL2TP socket of a ppp pseudowire).

l2tp_nl_cmd_session_delete() is a bit special: it runs a callback
function that may require a previous call to session->ref(). In
particular, for ppp pseudowires, the callback is l2tp_session_delete(),
which then calls pppol2tp_session_close() and dereferences the PPPOL2TP
socket. The socket might already be gone at the moment
l2tp_session_delete() calls session->ref(), so we need to take a
reference during the session lookup. So we need to pass the do_ref
variable down to l2tp_session_get() and l2tp_session_get_by_ifname().

Since all callers have to be updated, l2tp_session_find_by_ifname() and
l2tp_nl_session_find() are renamed to reflect their new behaviour.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c    |    9 +++++++--
 net/l2tp/l2tp_core.h    |    3 ++-
 net/l2tp/l2tp_netlink.c |   39 ++++++++++++++++++++++++++-------------
 3 files changed, 35 insertions(+), 16 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -355,7 +355,8 @@ EXPORT_SYMBOL_GPL(l2tp_session_get_nth);
 /* Lookup a session by interface name.
  * This is very inefficient but is only used by management interfaces.
  */
-struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname)
+struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+						bool do_ref)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	int hash;
@@ -365,7 +366,11 @@ struct l2tp_session *l2tp_session_find_b
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++) {
 		hlist_for_each_entry_rcu(session, &pn->l2tp_session_hlist[hash], global_hlist) {
 			if (!strcmp(session->ifname, ifname)) {
+				l2tp_session_inc_refcount(session);
+				if (do_ref && session->ref)
+					session->ref(session);
 				rcu_read_unlock_bh();
+
 				return session;
 			}
 		}
@@ -375,7 +380,7 @@ struct l2tp_session *l2tp_session_find_b
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(l2tp_session_find_by_ifname);
+EXPORT_SYMBOL_GPL(l2tp_session_get_by_ifname);
 
 static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 				      struct l2tp_session *session)
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -252,7 +252,8 @@ struct l2tp_session *l2tp_session_find(s
 				       u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
-struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname);
+struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+						bool do_ref);
 struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
 
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -55,7 +55,8 @@ static int l2tp_nl_session_send(struct s
 /* Accessed under genl lock */
 static const struct l2tp_nl_cmd_ops *l2tp_nl_cmd_ops[__L2TP_PWTYPE_MAX];
 
-static struct l2tp_session *l2tp_nl_session_find(struct genl_info *info)
+static struct l2tp_session *l2tp_nl_session_get(struct genl_info *info,
+						bool do_ref)
 {
 	u32 tunnel_id;
 	u32 session_id;
@@ -66,14 +67,15 @@ static struct l2tp_session *l2tp_nl_sess
 
 	if (info->attrs[L2TP_ATTR_IFNAME]) {
 		ifname = nla_data(info->attrs[L2TP_ATTR_IFNAME]);
-		session = l2tp_session_find_by_ifname(net, ifname);
+		session = l2tp_session_get_by_ifname(net, ifname, do_ref);
 	} else if ((info->attrs[L2TP_ATTR_SESSION_ID]) &&
 		   (info->attrs[L2TP_ATTR_CONN_ID])) {
 		tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 		session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
 		tunnel = l2tp_tunnel_find(net, tunnel_id);
 		if (tunnel)
-			session = l2tp_session_find(net, tunnel, session_id);
+			session = l2tp_session_get(net, tunnel, session_id,
+						   do_ref);
 	}
 
 	return session;
@@ -644,7 +646,7 @@ static int l2tp_nl_cmd_session_delete(st
 	struct l2tp_session *session;
 	u16 pw_type;
 
-	session = l2tp_nl_session_find(info);
+	session = l2tp_nl_session_get(info, true);
 	if (session == NULL) {
 		ret = -ENODEV;
 		goto out;
@@ -658,6 +660,10 @@ static int l2tp_nl_cmd_session_delete(st
 		if (l2tp_nl_cmd_ops[pw_type] && l2tp_nl_cmd_ops[pw_type]->session_delete)
 			ret = (*l2tp_nl_cmd_ops[pw_type]->session_delete)(session);
 
+	if (session->deref)
+		session->deref(session);
+	l2tp_session_dec_refcount(session);
+
 out:
 	return ret;
 }
@@ -667,7 +673,7 @@ static int l2tp_nl_cmd_session_modify(st
 	int ret = 0;
 	struct l2tp_session *session;
 
-	session = l2tp_nl_session_find(info);
+	session = l2tp_nl_session_get(info, false);
 	if (session == NULL) {
 		ret = -ENODEV;
 		goto out;
@@ -702,6 +708,8 @@ static int l2tp_nl_cmd_session_modify(st
 	ret = l2tp_session_notify(&l2tp_nl_family, info,
 				  session, L2TP_CMD_SESSION_MODIFY);
 
+	l2tp_session_dec_refcount(session);
+
 out:
 	return ret;
 }
@@ -788,29 +796,34 @@ static int l2tp_nl_cmd_session_get(struc
 	struct sk_buff *msg;
 	int ret;
 
-	session = l2tp_nl_session_find(info);
+	session = l2tp_nl_session_get(info, false);
 	if (session == NULL) {
 		ret = -ENODEV;
-		goto out;
+		goto err;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_ref;
 	}
 
 	ret = l2tp_nl_session_send(msg, info->snd_portid, info->snd_seq,
 				   0, session, L2TP_CMD_SESSION_GET);
 	if (ret < 0)
-		goto err_out;
+		goto err_ref_msg;
 
-	return genlmsg_unicast(genl_info_net(info), msg, info->snd_portid);
+	ret = genlmsg_unicast(genl_info_net(info), msg, info->snd_portid);
 
-err_out:
-	nlmsg_free(msg);
+	l2tp_session_dec_refcount(session);
 
-out:
+	return ret;
+
+err_ref_msg:
+	nlmsg_free(msg);
+err_ref:
+	l2tp_session_dec_refcount(session);
+err:
 	return ret;
 }
 


