Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA11DD048
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgEUOlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbgEUOlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8CBC061A0F
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i190so5517847ybg.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yRjGguM3Ef5m8nFpzA3mSpSmY0ImLOrvLfQQg0hoAck=;
        b=goB7ngbx/iv9rV/GtSMNlgiTOLqA2bZVtNkBcw46zY6wLJunK9/0XwTQfwLBLQDI03
         F+HbGa/2IVX17A4k4BH8hS1QzFKzs1OyAeRRZL+9XBbXGzsN148LfGs6GYPDpGpFpioB
         YpIbxbUdWF9XU04zq/pMpXpLunGksCx1HuUnEbcmpbjpkHlQ1fOu21l+85MZMnPGerry
         wo3S6LJr6wHVHKIOZ/sejBC9NZ/2So/hhvd2AvfJJxv4uTk/tA+xnm3/S+m8hwdi4N/S
         vK/A5YQXxiZ3noW5Lk3FKZERZemR39HjlLaD/T1K+Jyr1TBvirKnXcnxRh7VX8GL3jwe
         2KWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yRjGguM3Ef5m8nFpzA3mSpSmY0ImLOrvLfQQg0hoAck=;
        b=Y/cyieA3BcWgPt0BAomSYG9U1Bz57Zi+Xk96nAnzlBnBaWxMfJ2wKtPIBCrmco/dTP
         Qh8briw6sv4885kOlra2rYBk0TPtgoam1navAeja6R1KWdDa387f740NR1RuXvOlFZkU
         TSzMFOwCRqDA+8XxqKOTrALHjDaJnxz6dZ/SM5cW9qHv3T4mjY+L39HXGJhoLwqVYn/q
         ahE5QKIJ2IV+NX+oEntcvrptJkzgPWWujoS6YtJPJcz1ttHappG04NjOC2Gzak64uvZt
         mZ4vkCgIZD8erN1d6pAkvQC5nL3/TL0xiUaGQVJxVRjZ/B6T4lKD/LgSpra/3nRkZ9iz
         9/RA==
X-Gm-Message-State: AOAM53201P7qPDy5NBUu15900CGDiI8L+7QA11kntNqgMC6mBq0w5hjM
        XIIW+TgWfkHVA3eiHlHo8xhgzCDRMotAvw==
X-Google-Smtp-Source: ABdhPJzKxjOJgOe6FnJGIIAQv4i9jziTrp6hz2tnfzSGJmMyFPa0nV8i4TGQDQSkUwuI+TmhXHQ4y/fngYcNOw==
X-Received: by 2002:a25:5786:: with SMTP id l128mr15673764ybb.186.1590072093322;
 Thu, 21 May 2020 07:41:33 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:49 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-12-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 11/22] l2tp: hold tunnel while looking up sessions in l2tp_netlink
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

commit 54652eb12c1b72e9602d09cb2821d5760939190f uptream.

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
---
 net/l2tp/l2tp_core.c    | 66 +++++++++++++----------------------------
 net/l2tp/l2tp_core.h    | 13 ++++++++
 net/l2tp/l2tp_netlink.c |  6 ++--
 3 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7f72957405b8..5d1eb253a0b1 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -112,7 +112,6 @@ struct l2tp_net {
 	spinlock_t l2tp_session_hlist_lock;
 };
 
-static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel);
 
 static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
 {
@@ -126,39 +125,6 @@ static inline struct l2tp_net *l2tp_pernet(const struct net *net)
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
@@ -228,6 +194,27 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
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
@@ -1346,17 +1333,6 @@ static void l2tp_udp_encap_destroy(struct sock *sk)
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
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 2f9a09097e30..f747deaf6e09 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -231,6 +231,8 @@ static inline struct l2tp_tunnel *l2tp_sock_to_tunnel(struct sock *sk)
 	return tunnel;
 }
 
+struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id);
+
 struct l2tp_session *l2tp_session_get(const struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
@@ -269,6 +271,17 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
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
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 36651b60d776..0a27f7e976f3 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -72,10 +72,12 @@ static struct l2tp_session *l2tp_nl_session_get(struct genl_info *info,
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
-- 
2.26.2.761.g0e0b3e54be-goog

