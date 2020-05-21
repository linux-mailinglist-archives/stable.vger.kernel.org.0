Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45F41DD054
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgEUOlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02112C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 186so5539778ybq.1
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XUJYQZW8tiMT8aPJTR+BnI3Bd7JmOMvS+nmIxviYXeU=;
        b=uVyzJG/FD6FfGuHvz/Ei20CBFbKBfc++ECXDP3Um0W2FrXr+zaqAUGE8U0aOUfznPH
         tGjFLG/LS5v+T7iw1jjBxE+1rLv0X+uzxNaJaeUWhuxFVRbR8Ry8WTHcBWRZ8MvsMknh
         uZvNMET8O5isY5YgJjRG+egbLBhbVNZ2XAcSmHI1RsgwNh9RWD44mcQhiklQnOfphVLa
         JcIU9QEb5DLcDydAGP0IN8xU0rSyLaifq+SmTDWwNNyT4ty/4qOa8tt/Vb6VDCsuXcWg
         Ffj8e5bqNN1oas8TMS7AQ17XfKCswfFYLlGfIrjaYUu1tSyq5MgmWZinC9EMG/uRQ6db
         plwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XUJYQZW8tiMT8aPJTR+BnI3Bd7JmOMvS+nmIxviYXeU=;
        b=XS9Gb8arT6zNhr1oSjODycKzU7pWSrqQdnqXXLWv95kC3fvqEPhHW5ft+rheqj62Pw
         dvkmhJldvd4xhn10hzhFLTONIgc3/+GKf9UOIN0rb6NVLXlNkivMK6UR+DIVZXA8BhMQ
         pqX/oCVMCRiXuJNBQ8gdSutAarUErSbKWiZDGr7pp/X08XPyecCpllW0sAPlgtcFyIO+
         JkZMhAr9akvZXoL1VFwgKUbEuIIauURGd0T6HWSggpDzHDQXdPM/0Y4Zjd384SeipKIh
         zMjKW9muaP9Jyg4VUdNzpiQqdwPezzJv4WRvnIx57Eju/RA4u3gQhAXnPCQr9XD45DDf
         EhfQ==
X-Gm-Message-State: AOAM532RV0rblBkJQM9qfxosfTT1Pf1SskRi+OsEN4DfDHFQxmKyxXCR
        EjcI4A99euXTO/uN2jdd89TUKXLBS87MRQ==
X-Google-Smtp-Source: ABdhPJwdMK9lHCG9YRVoHPdv3cv+MEPKRPT5LNnT/Bxr6ULWwrxWAWU6UULwAibyxIzugNVYhO3JmMe0STbPWw==
X-Received: by 2002:a25:11c4:: with SMTP id 187mr4118250ybr.248.1590072112230;
 Thu, 21 May 2020 07:41:52 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:58 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-21-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 20/22] l2tp: initialise l2tp_eth sessions before registering them
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

commit ee28de6bbd78c2e18111a0aef43ea746f28d2073 uptream.

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

Backporting Notes

l2tp_eth.c: In l2tp_eth_create the "out" label was renamed to "err".
There was one extra occurrence of "goto out" to update.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_eth.c | 108 +++++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 32 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 5902d088b44f..60764ac2ddea 100644
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
@@ -126,8 +133,8 @@ static void l2tp_eth_dev_setup(struct net_device *dev)
 static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
 {
 	struct l2tp_eth_sess *spriv = l2tp_session_priv(session);
-	struct net_device *dev = spriv->dev;
-	struct l2tp_eth *priv = netdev_priv(dev);
+	struct net_device *dev;
+	struct l2tp_eth *priv;
 
 	if (session->debug & L2TP_MSG_DATA) {
 		unsigned int length;
@@ -151,16 +158,25 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
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
 
@@ -171,11 +187,15 @@ static void l2tp_eth_delete(struct l2tp_session *session)
 
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
@@ -185,9 +205,20 @@ static void l2tp_eth_show(struct seq_file *m, void *arg)
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
 
@@ -254,7 +285,7 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 		if (dev) {
 			dev_put(dev);
 			rc = -EEXIST;
-			goto out;
+			goto err;
 		}
 		strlcpy(name, cfg->ifname, IFNAMSIZ);
 	} else
@@ -264,21 +295,14 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
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
 
 	dev = alloc_netdev(sizeof(*priv), name, NET_NAME_UNKNOWN,
 			   l2tp_eth_dev_setup);
 	if (!dev) {
 		rc = -ENOMEM;
-		goto out_del_session;
+		goto err_sess;
 	}
 
 	dev_net_set(dev, net);
@@ -296,28 +320,48 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
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

