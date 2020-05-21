Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B667B1DDB7D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgEUX6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728537AbgEUX6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB5C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z5so2857073ybg.11
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dccCgo5ByLuHxM+i+BDrTROh9f/WX96/1AByl/fYA8Q=;
        b=GiAFc2oM0OdsFGhEcYBZGwFn5rmynZUTXkTuvautLRqAlwOdkKEgfjvlE5ZShMjjk9
         B+6/qk3BmkLwmmKTP28wqXhkOlvOvdFdCLHgS5f2iwq352jn3R0GOVxlABmlu7msBua6
         CgiwpeWajFZoQPb8Z5WF+9qjPUiNL89SvGxlOFZU87tFAZ8ZivdViRbVC+op9qyhprJQ
         qBIyBDc10j/qJ/wsZW11QZTzrZJ8HYhperlInezG9KEMbe/3WO3aVlBgWuri80nfM0Zs
         OIf+8jOuuKVHAAc6nDs1s3hSSRaHRyOHZ6tT9kABU6qobGW/VjmL+E6mb1s5FOiSLnFw
         DokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dccCgo5ByLuHxM+i+BDrTROh9f/WX96/1AByl/fYA8Q=;
        b=D36xpcNOmyvmlWZSDX1WjLD4MkG1OMIhEybLYCFI93EzWfZNAvz1KFO1RCMfi97DXL
         qi2zRGOakuBa2oeMsJytuVvVHISrae+XEHOQAelWwUwQZibZV4C8FiasWDEOdhfm62sF
         I4NLmnF7u1Hs+NnFAZjxTHIYbtp71Mcy4ngcsRgU1glfX4qY1uR+9YLFhALuY0On4Cx7
         mlopczFL02YpiGR4jfGnUdoCEx/jQOGZmEso1pysfXvm0gOpt5U9frXf216iXNM/0Jtw
         LgRGZwkiTEavgvd01F2eshVgt0MIz9/ZlWzsRlSskLXu9gbg7hGWy1J/ihYb+zAhtguP
         T5kw==
X-Gm-Message-State: AOAM530FSAWdyZGUZTCjBs9896XgkN4aU54Z0tZg06dSgbUlH7x8XbuD
        udj65Sk+dAt3WLETl2eFWTo9WmEO2Jx8NA==
X-Google-Smtp-Source: ABdhPJyQCr4SaPjVI5rv7iztfBSqjpJ6wz+/b9qniRcaEBwq78LjSUWFuhF1oktVDtdl5anlSt+i9/BJUI0aGQ==
X-Received: by 2002:a25:bb03:: with SMTP id z3mr18846119ybg.6.1590105521697;
 Thu, 21 May 2020 16:58:41 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:36 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-24-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 23/27] l2tp: fix l2tp_eth module loading
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
---
 net/l2tp/l2tp_eth.c | 51 ++-------------------------------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index c785308f630b..ab6d2152eafb 100644
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
@@ -84,12 +72,6 @@ static int l2tp_eth_dev_init(struct net_device *dev)
 
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
 
@@ -266,7 +248,6 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	struct l2tp_eth *priv;
 	struct l2tp_eth_sess *spriv;
 	int rc;
-	struct l2tp_eth_net *pn;
 
 	if (cfg->ifname) {
 		dev = dev_get_by_name(net, cfg->ifname);
@@ -299,7 +280,6 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	priv = netdev_priv(dev);
 	priv->dev = dev;
 	priv->session = session;
-	INIT_LIST_HEAD(&priv->list);
 
 	priv->tunnel_sock = tunnel->sock;
 	session->recv_skb = l2tp_eth_dev_recv;
@@ -320,10 +300,6 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
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
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

