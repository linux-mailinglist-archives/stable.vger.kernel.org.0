Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10C71E2A8B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389919AbgEZS4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389891AbgEZS4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A187020870;
        Tue, 26 May 2020 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519403;
        bh=pU//SPVCifYOce6iE258HT16Y6OK29L72f/WdWMVypA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPxDiTwQBetN2UG6YLl/MW4/1lWFhKD9rUWva/J6B3B5ug09eZ59rSq8qnZEQmEzA
         WYTRE3wwxK0ltqh6m0hoj7rzYntt9TXdC0z7kAwW0uXCUrnN6arHnaycGFn/uXIOk2
         kDbbJs9Ye1YU+irgjWQ30dwO856DHuE+ZqOsl1/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 56/65] l2tp: fix l2tp_eth module loading
Date:   Tue, 26 May 2020 20:53:15 +0200
Message-Id: <20200526183926.387988644@linuxfoundation.org>
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

commit 9f775ead5e570e7e19015b9e4e2f3dd6e71a5935 upstream.

The l2tp_eth module crashes if its netlink callbacks are run when the
pernet data aren't initialised.

We should normally register_pernet_device() before the genl callbacks.
However, the pernet data only maintain a list of l2tpeth interfaces,
and this list is never used. So let's just drop pernet handling
instead.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_eth.c |   51 ++-------------------------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -44,7 +44,6 @@ struct l2tp_eth {
 	struct net_device	*dev;
 	struct sock		*tunnel_sock;
 	struct l2tp_session	*session;
-	struct list_head	list;
 	atomic_long_t		tx_bytes;
 	atomic_long_t		tx_packets;
 	atomic_long_t		tx_dropped;
@@ -58,17 +57,6 @@ struct l2tp_eth_sess {
 	struct net_device	*dev;
 };
 
-/* per-net private data for this module */
-static unsigned int l2tp_eth_net_id;
-struct l2tp_eth_net {
-	struct list_head l2tp_eth_dev_list;
-	spinlock_t l2tp_eth_lock;
-};
-
-static inline struct l2tp_eth_net *l2tp_eth_pernet(struct net *net)
-{
-	return net_generic(net, l2tp_eth_net_id);
-}
 
 static struct lock_class_key l2tp_eth_tx_busylock;
 static int l2tp_eth_dev_init(struct net_device *dev)
@@ -84,12 +72,6 @@ static int l2tp_eth_dev_init(struct net_
 
 static void l2tp_eth_dev_uninit(struct net_device *dev)
 {
-	struct l2tp_eth *priv = netdev_priv(dev);
-	struct l2tp_eth_net *pn = l2tp_eth_pernet(dev_net(dev));
-
-	spin_lock(&pn->l2tp_eth_lock);
-	list_del_init(&priv->list);
-	spin_unlock(&pn->l2tp_eth_lock);
 	dev_put(dev);
 }
 
@@ -266,7 +248,6 @@ static int l2tp_eth_create(struct net *n
 	struct l2tp_eth *priv;
 	struct l2tp_eth_sess *spriv;
 	int rc;
-	struct l2tp_eth_net *pn;
 
 	if (cfg->ifname) {
 		dev = dev_get_by_name(net, cfg->ifname);
@@ -299,7 +280,6 @@ static int l2tp_eth_create(struct net *n
 	priv = netdev_priv(dev);
 	priv->dev = dev;
 	priv->session = session;
-	INIT_LIST_HEAD(&priv->list);
 
 	priv->tunnel_sock = tunnel->sock;
 	session->recv_skb = l2tp_eth_dev_recv;
@@ -320,10 +300,6 @@ static int l2tp_eth_create(struct net *n
 	strlcpy(session->ifname, dev->name, IFNAMSIZ);
 
 	dev_hold(dev);
-	pn = l2tp_eth_pernet(dev_net(dev));
-	spin_lock(&pn->l2tp_eth_lock);
-	list_add(&priv->list, &pn->l2tp_eth_dev_list);
-	spin_unlock(&pn->l2tp_eth_lock);
 
 	return 0;
 
@@ -336,22 +312,6 @@ out:
 	return rc;
 }
 
-static __net_init int l2tp_eth_init_net(struct net *net)
-{
-	struct l2tp_eth_net *pn = net_generic(net, l2tp_eth_net_id);
-
-	INIT_LIST_HEAD(&pn->l2tp_eth_dev_list);
-	spin_lock_init(&pn->l2tp_eth_lock);
-
-	return 0;
-}
-
-static struct pernet_operations l2tp_eth_net_ops = {
-	.init = l2tp_eth_init_net,
-	.id   = &l2tp_eth_net_id,
-	.size = sizeof(struct l2tp_eth_net),
-};
-
 
 static const struct l2tp_nl_cmd_ops l2tp_eth_nl_cmd_ops = {
 	.session_create	= l2tp_eth_create,
@@ -365,25 +325,18 @@ static int __init l2tp_eth_init(void)
 
 	err = l2tp_nl_register_ops(L2TP_PWTYPE_ETH, &l2tp_eth_nl_cmd_ops);
 	if (err)
-		goto out;
-
-	err = register_pernet_device(&l2tp_eth_net_ops);
-	if (err)
-		goto out_unreg;
+		goto err;
 
 	pr_info("L2TP ethernet pseudowire support (L2TPv3)\n");
 
 	return 0;
 
-out_unreg:
-	l2tp_nl_unregister_ops(L2TP_PWTYPE_ETH);
-out:
+err:
 	return err;
 }
 
 static void __exit l2tp_eth_exit(void)
 {
-	unregister_pernet_device(&l2tp_eth_net_ops);
 	l2tp_nl_unregister_ops(L2TP_PWTYPE_ETH);
 }
 


