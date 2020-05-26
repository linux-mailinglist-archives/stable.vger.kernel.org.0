Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6F1E2EB4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbgEZS7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390454AbgEZS7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218B2208B3;
        Tue, 26 May 2020 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519540;
        bh=gchXIAdoirMRh2bLqUOL2GY67y6dfOel+FyHWesxrzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0SItl8QYMEhPPBfTOKEvaXodJKudpHzQ6TcaNnk+99ZjefyFqg45qlnRC45eAYuz
         lWsWUkzIJQ1dT02utsVW4rlzSp4mSBvzbWoCt2VEGDv4usaJ7DLqEb8C+dEnbNHmFp
         wlCIml9VpX9mRb0sZzi/UrvNB/5rBqEjbIqq4HmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 44/64] l2tp: fix l2tp_eth module loading
Date:   Tue, 26 May 2020 20:53:13 +0200
Message-Id: <20200526183928.350911945@linuxfoundation.org>
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
 
 static int l2tp_eth_dev_init(struct net_device *dev)
 {
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
 


