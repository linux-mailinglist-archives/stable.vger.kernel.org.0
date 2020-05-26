Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7CB1E2E9F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390583AbgEZS74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390595AbgEZS7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31502084C;
        Tue, 26 May 2020 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519593;
        bh=vCRsjhpwqn6isgh57L/1qx2eqX9y+PVPa4ydXf+VkRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LcqxtHOaqy35fMYdkGWdlvPs9RA44l9vBBlbou6fi+Gfv6/O3a8ANR32omgGnDVb
         TZO+6Cxi+MrUCIu4HGcaQrkSii1tQs7x/bpvAGKElr/Ow3Pr2KN6cU+W+Z9kL+eUmx
         iaxLDdRsLoWoY4haJmYLsaJtJsh+WkjmNqxqB/qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 37/64] l2tp: hold tunnel while looking up sessions in l2tp_netlink
Date:   Tue, 26 May 2020 20:53:06 +0200
Message-Id: <20200526183925.482465386@linuxfoundation.org>
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

commit 54652eb12c1b72e9602d09cb2821d5760939190f upstream.

l2tp_tunnel_find() doesn't take a reference on the returned tunnel.
Therefore, it's unsafe to use it because the returned tunnel can go
away on us anytime.

Fix this by defining l2tp_tunnel_get(), which works like
l2tp_tunnel_find(), but takes a reference on the returned tunnel.
Caller then has to drop this reference using l2tp_tunnel_dec_refcount().

As l2tp_tunnel_dec_refcount() needs to be moved to l2tp_core.h, let's
simplify the patch and not move the L2TP_REFCNT_DEBUG part. This code
has been broken (not even compiling) in May 2012 by
commit a4ca44fa578c ("net: l2tp: Standardize logging styles")
and fixed more than two years later by
commit 29abe2fda54f ("l2tp: fix missing line continuation"). So it
doesn't appear to be used by anyone.

Same thing for l2tp_tunnel_free(); instead of moving it to l2tp_core.h,
let's just simplify things and call kfree_rcu() directly in
l2tp_tunnel_dec_refcount(). Extra assertions and debugging code
provided by l2tp_tunnel_free() didn't help catching any of the
reference counting and socket handling issues found while working on
this series.

Backporting Notes

l2tp_core.c: This patch deletes some code / moves some code to
l2tp_core.h and follows the patch (not including in this series) that
switched from atomic to refcount_t. Moved code changed back to atomic.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c    |   66 +++++++++++++++---------------------------------
 net/l2tp/l2tp_core.h    |   13 +++++++++
 net/l2tp/l2tp_netlink.c |    6 ++--
 3 files changed, 38 insertions(+), 47 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -112,7 +112,6 @@ struct l2tp_net {
 	spinlock_t l2tp_session_hlist_lock;
 };
 
-static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel);
 
 static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
 {
@@ -126,39 +125,6 @@ static inline struct l2tp_net *l2tp_pern
 	return net_generic(net, l2tp_net_id);
 }
 
-/* Tunnel reference counts. Incremented per session that is added to
- * the tunnel.
- */
-static inline void l2tp_tunnel_inc_refcount_1(struct l2tp_tunnel *tunnel)
-{
-	atomic_inc(&tunnel->ref_count);
-}
-
-static inline void l2tp_tunnel_dec_refcount_1(struct l2tp_tunnel *tunnel)
-{
-	if (atomic_dec_and_test(&tunnel->ref_count))
-		l2tp_tunnel_free(tunnel);
-}
-#ifdef L2TP_REFCNT_DEBUG
-#define l2tp_tunnel_inc_refcount(_t)					\
-do {									\
-	pr_debug("l2tp_tunnel_inc_refcount: %s:%d %s: cnt=%d\n",	\
-		 __func__, __LINE__, (_t)->name,			\
-		 atomic_read(&_t->ref_count));				\
-	l2tp_tunnel_inc_refcount_1(_t);					\
-} while (0)
-#define l2tp_tunnel_dec_refcount(_t)					\
-do {									\
-	pr_debug("l2tp_tunnel_dec_refcount: %s:%d %s: cnt=%d\n",	\
-		 __func__, __LINE__, (_t)->name,			\
-		 atomic_read(&_t->ref_count));				\
-	l2tp_tunnel_dec_refcount_1(_t);					\
-} while (0)
-#else
-#define l2tp_tunnel_inc_refcount(t) l2tp_tunnel_inc_refcount_1(t)
-#define l2tp_tunnel_dec_refcount(t) l2tp_tunnel_dec_refcount_1(t)
-#endif
-
 /* Session hash global list for L2TPv3.
  * The session_id SHOULD be random according to RFC3931, but several
  * L2TP implementations use incrementing session_ids.  So we do a real
@@ -228,6 +194,27 @@ l2tp_session_id_hash(struct l2tp_tunnel
 	return &tunnel->session_hlist[hash_32(session_id, L2TP_HASH_BITS)];
 }
 
+/* Lookup a tunnel. A new reference is held on the returned tunnel. */
+struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
+{
+	const struct l2tp_net *pn = l2tp_pernet(net);
+	struct l2tp_tunnel *tunnel;
+
+	rcu_read_lock_bh();
+	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
+		if (tunnel->tunnel_id == tunnel_id) {
+			l2tp_tunnel_inc_refcount(tunnel);
+			rcu_read_unlock_bh();
+
+			return tunnel;
+		}
+	}
+	rcu_read_unlock_bh();
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
+
 /* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
@@ -1346,17 +1333,6 @@ static void l2tp_udp_encap_destroy(struc
 	}
 }
 
-/* Really kill the tunnel.
- * Come here only when all sessions have been cleared from the tunnel.
- */
-static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
-{
-	BUG_ON(atomic_read(&tunnel->ref_count) != 0);
-	BUG_ON(tunnel->sock != NULL);
-	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: free...\n", tunnel->name);
-	kfree_rcu(tunnel, rcu);
-}
-
 /* Workqueue tunnel deletion function */
 static void l2tp_tunnel_del_work(struct work_struct *work)
 {
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,6 +231,8 @@ out:
 	return tunnel;
 }
 
+struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id);
+
 struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
@@ -269,6 +271,17 @@ int l2tp_nl_register_ops(enum l2tp_pwtyp
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 
+static inline void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
+{
+	atomic_inc(&tunnel->ref_count);
+}
+
+static inline void l2tp_tunnel_dec_refcount(struct l2tp_tunnel *tunnel)
+{
+	if (atomic_dec_and_test(&tunnel->ref_count))
+		kfree_rcu(tunnel, rcu);
+}
+
 /* Session reference counts. Incremented when code obtains a reference
  * to a session.
  */
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -72,10 +72,12 @@ static struct l2tp_session *l2tp_nl_sess
 		   (info->attrs[L2TP_ATTR_CONN_ID])) {
 		tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 		session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
-		tunnel = l2tp_tunnel_find(net, tunnel_id);
-		if (tunnel)
+		tunnel = l2tp_tunnel_get(net, tunnel_id);
+		if (tunnel) {
 			session = l2tp_session_get(net, tunnel, session_id,
 						   do_ref);
+			l2tp_tunnel_dec_refcount(tunnel);
+		}
 	}
 
 	return session;


