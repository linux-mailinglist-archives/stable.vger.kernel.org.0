Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9961DDB68
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgEUX6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:03 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C2C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:02 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 19so9724616qtp.8
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u8BsiLHGbnr6qNBb/40NisernE87Qwe3ZNVZcglRiqc=;
        b=W/ieHzZrN/gIQ/OCUaH6vrHX/b9LXHc1NR8YaNUq5Dq6+j/gkYPOYQrh5fTHb8mGhh
         7XCpIL0PAuBeqFjx8E/VTihS1iiov5LgCnMkn+soIZdFMSFJF75ZfC9GOfbwdH/yCogi
         xjo9gbooZs+hrztCj21YQAjJPqS4amQ9WcYjK/OqFfrOzvJ3kvTkTJyv74k9LazVlmZM
         Q0lm7hAoxZ+qx51ODhtE0S5FxNootIX6RkS+uB7WJIKNd/6314tbPwTiBFMCyKHQo07x
         hKuObTVTx8cVlURv0fNr9wpSd4N/tkbei/nc/aACIOXEySHOi7N8utnLCcRAnW85hr+x
         Q7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u8BsiLHGbnr6qNBb/40NisernE87Qwe3ZNVZcglRiqc=;
        b=uBApKQAexKRnuTbsHMHiyLJrS1VIG+RF4cbos6bcqy9jOlyjGtkDxeYXjppdedcM5g
         oGZ8jTI8600DboAqWyO7G4s34DjYux9pqtY8Gc4Twkz4HZN5aCUhq5I/oWZwwR0cIHUO
         b3ir8hrZ+0RBusGJMG4Q68gueZ6SwVg6e1Z3VxUszNCPLcr5bSqG9rSCQWnnXeai+Pz1
         lL8t35JkmtvpeytH5m0GHbFQA93MeLd9TxB7dSDT2x26+9y+43Scevx6iYwvIuPTYsbn
         ncDZMpwx4DbJSuNw2PYq73x1Uk1KHp0SNQIEDDcbzIME0caq0julvdXkeQhbD//G0ixX
         Uc/w==
X-Gm-Message-State: AOAM531lBCDBhdV27g1u1/1sl1Qf6/5RpU4DeQX6OLxJxDSShgWR4lrR
        IKMfzZ3fu5I/fERKjr8RcajD+SzfnA12Gg==
X-Google-Smtp-Source: ABdhPJy/bskxtCcytRl9t5J1y7IyBBIlxs2O1il1fFbdhe3pi8gp+EFlLJBRGSmOWD821HnuzZrxkwBLPGe4mg==
X-Received: by 2002:a0c:dd90:: with SMTP id v16mr1285033qvk.43.1590105481401;
 Thu, 21 May 2020 16:58:01 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:17 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-5-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 04/27] l2tp: take a reference on sessions used in genetlink handlers
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Amit Pundir <amit.pundir@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
 net/l2tp/l2tp_core.c    |  9 +++++++--
 net/l2tp/l2tp_core.h    |  3 ++-
 net/l2tp/l2tp_netlink.c | 39 ++++++++++++++++++++++++++-------------
 3 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 8cbccddc0b1e..08377af93552 100644
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
@@ -365,7 +366,11 @@ struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname)
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
@@ -375,7 +380,7 @@ struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname)
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(l2tp_session_find_by_ifname);
+EXPORT_SYMBOL_GPL(l2tp_session_get_by_ifname);
 
 static int l2tp_session_add_to_tunnel(struct l2tp_tunnel *tunnel,
 				      struct l2tp_session *session)
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 06323a12d62c..ee59d9961d1f 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -252,7 +252,8 @@ struct l2tp_session *l2tp_session_find(struct net *net,
 				       u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
-struct l2tp_session *l2tp_session_find_by_ifname(struct net *net, char *ifname);
+struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
+						bool do_ref);
 struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
 
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 43f0af1c4697..63a2430ff40a 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -55,7 +55,8 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq,
 /* Accessed under genl lock */
 static const struct l2tp_nl_cmd_ops *l2tp_nl_cmd_ops[__L2TP_PWTYPE_MAX];
 
-static struct l2tp_session *l2tp_nl_session_find(struct genl_info *info)
+static struct l2tp_session *l2tp_nl_session_get(struct genl_info *info,
+						bool do_ref)
 {
 	u32 tunnel_id;
 	u32 session_id;
@@ -66,14 +67,15 @@ static struct l2tp_session *l2tp_nl_session_find(struct genl_info *info)
 
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
@@ -644,7 +646,7 @@ static int l2tp_nl_cmd_session_delete(struct sk_buff *skb, struct genl_info *inf
 	struct l2tp_session *session;
 	u16 pw_type;
 
-	session = l2tp_nl_session_find(info);
+	session = l2tp_nl_session_get(info, true);
 	if (session == NULL) {
 		ret = -ENODEV;
 		goto out;
@@ -658,6 +660,10 @@ static int l2tp_nl_cmd_session_delete(struct sk_buff *skb, struct genl_info *inf
 		if (l2tp_nl_cmd_ops[pw_type] && l2tp_nl_cmd_ops[pw_type]->session_delete)
 			ret = (*l2tp_nl_cmd_ops[pw_type]->session_delete)(session);
 
+	if (session->deref)
+		session->deref(session);
+	l2tp_session_dec_refcount(session);
+
 out:
 	return ret;
 }
@@ -667,7 +673,7 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 	int ret = 0;
 	struct l2tp_session *session;
 
-	session = l2tp_nl_session_find(info);
+	session = l2tp_nl_session_get(info, false);
 	if (session == NULL) {
 		ret = -ENODEV;
 		goto out;
@@ -702,6 +708,8 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 	ret = l2tp_session_notify(&l2tp_nl_family, info,
 				  session, L2TP_CMD_SESSION_MODIFY);
 
+	l2tp_session_dec_refcount(session);
+
 out:
 	return ret;
 }
@@ -788,29 +796,34 @@ static int l2tp_nl_cmd_session_get(struct sk_buff *skb, struct genl_info *info)
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
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

