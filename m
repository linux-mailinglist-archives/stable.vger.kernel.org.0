Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5901A1E2ACB
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390463AbgEZS7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390459AbgEZS7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F6E2086A;
        Tue, 26 May 2020 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519545;
        bh=vHzcqSXkwJZKPyb6OsRxFe+HGCMZtRggbpbxqXmTGqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4QsNYzJdYM1Xy4FRnDj7Nb+CLJhrOGNlvqi/fyCwTj5oGY3eQ9vhcpVJYXAUquD6
         a3RkJxJLjGYsdkdcxT+A2taIxqMORR25aqRYzlJONqSODqhwYXRqZPBvGCAk9UVK7U
         WD5iPb3Vy1adLACui6jV/g/YtUx7m1Wnpl8Rd1mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 46/64] l2tp: initialise l2tp_eth sessions before registering them
Date:   Tue, 26 May 2020 20:53:15 +0200
Message-Id: <20200526183928.875287541@linuxfoundation.org>
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

Backporting Notes

l2tp_eth.c: In l2tp_eth_create the "out" label was renamed to "err".
There was one extra occurrence of "goto out" to update.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_eth.c |  108 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 32 deletions(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -54,7 +54,7 @@ struct l2tp_eth {
 
 /* via l2tp_session_priv() */
 struct l2tp_eth_sess {
-	struct net_device	*dev;
+	struct net_device __rcu *dev;
 };
 
 
@@ -72,7 +72,14 @@ static int l2tp_eth_dev_init(struct net_
 
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
@@ -126,8 +133,8 @@ static void l2tp_eth_dev_setup(struct ne
 static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
 {
 	struct l2tp_eth_sess *spriv = l2tp_session_priv(session);
-	struct net_device *dev = spriv->dev;
-	struct l2tp_eth *priv = netdev_priv(dev);
+	struct net_device *dev;
+	struct l2tp_eth *priv;
 
 	if (session->debug & L2TP_MSG_DATA) {
 		unsigned int length;
@@ -151,16 +158,25 @@ static void l2tp_eth_dev_recv(struct l2t
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
 
@@ -171,11 +187,15 @@ static void l2tp_eth_delete(struct l2tp_
 
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
@@ -185,9 +205,20 @@ static void l2tp_eth_show(struct seq_fil
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
 
@@ -254,7 +285,7 @@ static int l2tp_eth_create(struct net *n
 		if (dev) {
 			dev_put(dev);
 			rc = -EEXIST;
-			goto out;
+			goto err;
 		}
 		strlcpy(name, cfg->ifname, IFNAMSIZ);
 	} else
@@ -264,21 +295,14 @@ static int l2tp_eth_create(struct net *n
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
@@ -296,28 +320,48 @@ static int l2tp_eth_create(struct net *n
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
 


