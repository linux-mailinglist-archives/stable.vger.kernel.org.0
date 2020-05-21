Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB99F1DCEB4
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgEUN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 09:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgEUN5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 09:57:13 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B85C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id o7so7279054qvm.15
        for <stable@vger.kernel.org>; Thu, 21 May 2020 06:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6B1UMeSK9FGrEuQv1dU2Zn0d2ykKlpaa9+DxkheO8ZI=;
        b=TFAjGPk8ZHUk/xulm8PgHcV/4uung0JcQgjwQ1ruCWqrhWYne8bbCk0X320E7uva16
         yGf42XS+8eXPrWvfrhU2qY04xJE2q8s2JJdwZb0FH03gVDeUQHyQ0Gf8vQkqD/liLC2o
         wiMV6nzOojOlNX22wY95XCbV2+oT2NlvuGJziWNs/ITLFib3qq3qfatjq2GtQ+WQN9Ki
         brc+nFWr3fwmdo3GTnmULpdnP5kfn80d3awPwppzQ9uQdz9iuF2rGIsjgmpba/41H87/
         ELmXtiejHX699bMvU8yJ3WlQJZ/npBJIiibiSooZSsYCgfUbQMH/bvAEQUUBcyNX++Uo
         FnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6B1UMeSK9FGrEuQv1dU2Zn0d2ykKlpaa9+DxkheO8ZI=;
        b=IcrgEXLESrxuWUYZL3Z+P6Kkjz9CmSDf46z2rR87bbx46VIUwx/X+0lMPwRkekpUZi
         1aGYMYzL2RuTmNGWkoAHRy5mp9nAxGwlMv1JboJ1Dh68r2A0074LAjnTOe6MGCgZqJzJ
         PyMzfqnnUD9YlEh2Bf8gRKlbajYisRkhmM4TgiBvT/JEZFcivLjgpCZA2KM0dn0jDjmj
         Vz8j+Jpr04yt+Vm15TiTjwfAjyuYzdW4cF0vGJEmzqkemmYcB708p6baU1DvYUUuSHSE
         F36th5YwLHZh9H4OsuKiyvRj/vJ32BMWED9t6PbPWOPV1WGvDYgEbo2QbZvHGBbH+h+m
         Hbug==
X-Gm-Message-State: AOAM532G+VArt8dtFh6lcrT9RNPPXdxKx4FgIvPCCibg56FfpudQ18qa
        1KwpFRVVBItKEfLf6yk5Bp5Pg9sgNJfLzw==
X-Google-Smtp-Source: ABdhPJxR1jYf6cr/AA33RFrBgF+4lMRxvP6/nfraWkDWvcXGevBoJLs6sq9t8rIdLy3+8Rnm4qXmC5Cihgq4iQ==
X-Received: by 2002:a0c:ec08:: with SMTP id y8mr9264449qvo.7.1590069432193;
 Thu, 21 May 2020 06:57:12 -0700 (PDT)
Date:   Thu, 21 May 2020 14:57:02 +0100
In-Reply-To: <20200521135704.109812-1-gprocida@google.com>
Message-Id: <20200521135704.109812-3-gprocida@google.com>
Mime-Version: 1.0
References: <20200521135704.109812-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 2/4] l2tp: initialise l2tp_eth sessions before registering them
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

commit ee28de6bbd78c2e18111a0aef43ea746f28d2073 upstream.

Sessions must be initialised before being made externally visible by
l2tp_session_register(). Otherwise the session may be concurrently
deleted before being initialised, which can confuse the deletion path
and eventually lead to kernel oops.

Therefore, we need to move l2tp_session_register() down in
l2tp_eth_create(), but also handle the intermediate step where only the
session or the netdevice has been registered.

We can't just call l2tp_session_register() in ->ndo_init() because
we'd have no way to properly undo this operation in ->ndo_uninit().
Instead, let's register the session and the netdevice in two different
steps and protect the session's device pointer with RCU.

And now that we allow the session's .dev field to be NULL, we don't
need to prevent the netdevice from being removed anymore. So we can
drop the dev_hold() and dev_put() calls in l2tp_eth_create() and
l2tp_eth_dev_uninit().

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_eth.c | 106 +++++++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 31 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index a7d76f5f31ff..d29bfee291cb 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -54,7 +54,7 @@ struct l2tp_eth {
 
 /* via l2tp_session_priv() */
 struct l2tp_eth_sess {
-	struct net_device	*dev;
+	struct net_device __rcu *dev;
 };
 
 
@@ -72,7 +72,14 @@ static int l2tp_eth_dev_init(struct net_device *dev)
 
 static void l2tp_eth_dev_uninit(struct net_device *dev)
 {
-	dev_put(dev);
+	struct l2tp_eth *priv = netdev_priv(dev);
+	struct l2tp_eth_sess *spriv;
+
+	spriv = l2tp_session_priv(priv->session);
+	RCU_INIT_POINTER(spriv->dev, NULL);
+	/* No need for synchronize_net() here. We're called by
+	 * unregister_netdev*(), which does the synchronisation for us.
+	 */
 }
 
 static int l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -130,8 +137,8 @@ static void l2tp_eth_dev_setup(struct net_device *dev)
 static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
 {
 	struct l2tp_eth_sess *spriv = l2tp_session_priv(session);
-	struct net_device *dev = spriv->dev;
-	struct l2tp_eth *priv = netdev_priv(dev);
+	struct net_device *dev;
+	struct l2tp_eth *priv;
 
 	if (session->debug & L2TP_MSG_DATA) {
 		unsigned int length;
@@ -155,16 +162,25 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	skb_dst_drop(skb);
 	nf_reset(skb);
 
+	rcu_read_lock();
+	dev = rcu_dereference(spriv->dev);
+	if (!dev)
+		goto error_rcu;
+
+	priv = netdev_priv(dev);
 	if (dev_forward_skb(dev, skb) == NET_RX_SUCCESS) {
 		atomic_long_inc(&priv->rx_packets);
 		atomic_long_add(data_len, &priv->rx_bytes);
 	} else {
 		atomic_long_inc(&priv->rx_errors);
 	}
+	rcu_read_unlock();
+
 	return;
 
+error_rcu:
+	rcu_read_unlock();
 error:
-	atomic_long_inc(&priv->rx_errors);
 	kfree_skb(skb);
 }
 
@@ -175,11 +191,15 @@ static void l2tp_eth_delete(struct l2tp_session *session)
 
 	if (session) {
 		spriv = l2tp_session_priv(session);
-		dev = spriv->dev;
+
+		rtnl_lock();
+		dev = rtnl_dereference(spriv->dev);
 		if (dev) {
-			unregister_netdev(dev);
-			spriv->dev = NULL;
+			unregister_netdevice(dev);
+			rtnl_unlock();
 			module_put(THIS_MODULE);
+		} else {
+			rtnl_unlock();
 		}
 	}
 }
@@ -189,9 +209,20 @@ static void l2tp_eth_show(struct seq_file *m, void *arg)
 {
 	struct l2tp_session *session = arg;
 	struct l2tp_eth_sess *spriv = l2tp_session_priv(session);
-	struct net_device *dev = spriv->dev;
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(spriv->dev);
+	if (!dev) {
+		rcu_read_unlock();
+		return;
+	}
+	dev_hold(dev);
+	rcu_read_unlock();
 
 	seq_printf(m, "   interface %s\n", dev->name);
+
+	dev_put(dev);
 }
 #endif
 
@@ -268,21 +299,14 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 				      peer_session_id, cfg);
 	if (IS_ERR(session)) {
 		rc = PTR_ERR(session);
-		goto out;
-	}
-
-	l2tp_session_inc_refcount(session);
-	rc = l2tp_session_register(session, tunnel);
-	if (rc < 0) {
-		kfree(session);
-		goto out;
+		goto err;
 	}
 
 	dev = alloc_netdev(sizeof(*priv), name, name_assign_type,
 			   l2tp_eth_dev_setup);
 	if (!dev) {
 		rc = -ENOMEM;
-		goto out_del_session;
+		goto err_sess;
 	}
 
 	dev_net_set(dev, net);
@@ -302,28 +326,48 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 #endif
 
 	spriv = l2tp_session_priv(session);
-	spriv->dev = dev;
 
-	rc = register_netdev(dev);
-	if (rc < 0)
-		goto out_del_dev;
+	l2tp_session_inc_refcount(session);
+
+	rtnl_lock();
+
+	/* Register both device and session while holding the rtnl lock. This
+	 * ensures that l2tp_eth_delete() will see that there's a device to
+	 * unregister, even if it happened to run before we assign spriv->dev.
+	 */
+	rc = l2tp_session_register(session, tunnel);
+	if (rc < 0) {
+		rtnl_unlock();
+		goto err_sess_dev;
+	}
+
+	rc = register_netdevice(dev);
+	if (rc < 0) {
+		rtnl_unlock();
+		l2tp_session_delete(session);
+		l2tp_session_dec_refcount(session);
+		free_netdev(dev);
+
+		return rc;
+	}
 
-	__module_get(THIS_MODULE);
-	/* Must be done after register_netdev() */
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
+	rcu_assign_pointer(spriv->dev, dev);
+
+	rtnl_unlock();
+
 	l2tp_session_dec_refcount(session);
 
-	dev_hold(dev);
+	__module_get(THIS_MODULE);
 
 	return 0;
 
-out_del_dev:
-	free_netdev(dev);
-	spriv->dev = NULL;
-out_del_session:
-	l2tp_session_delete(session);
+err_sess_dev:
 	l2tp_session_dec_refcount(session);
-out:
+	free_netdev(dev);
+err_sess:
+	kfree(session);
+err:
 	return rc;
 }
 
-- 
2.26.2.761.g0e0b3e54be-goog

