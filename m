Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799F71DDB32
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgEUXk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:26 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EB5C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:25 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id g15so8832030qvx.6
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZXgZ+brIaUl1A0pe9JhfZ+jKgS6sfwUl5aYcN6q/uME=;
        b=UzLaUjuYikQ+SxsNAiI7p8zEMdgwXH0nmv7FkBNgkkcSXW6U6bNCJxH1w05ANdkN+h
         U6hpzD3vkqouI2WOrExcSFj06oJF7b2aEt9rHn874JkUwarwevSV4YRrSk/UWE4gQ73V
         NTGb5MbLbBBY1Goc+jg8KRgcEkam+qUNTr1AmNvCz/q7r+OvtGUpYUPq0A2fUzH9eF8/
         8KIjY5vV8kADhZT8mT4SL/4ZUt3/8m/337N9UiphPe2Cr9ZGZVfN/vKvEltRkQfmF4yx
         Xegnxkhc4d7azW4bdzw24MID34uTXPVDnhGA/6p1GYUqgF1ucNlVme4JBj1x2ysAXhUN
         IBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZXgZ+brIaUl1A0pe9JhfZ+jKgS6sfwUl5aYcN6q/uME=;
        b=HNiao98Xm/sKgWbmh/sEkYF9Y+IsPwsm6sHih4NcK2TakaKEP6NxEcnxAL3lp8XQoc
         Gyu4YyBVoAqYK6JZREPwJAXJP/GyVuflI+Obv4sLdzYdpi7YLDZOQ0qmcJtBxJY5J/k7
         nU40CiEB4Wu5iLaK/n+TsDfjD4HE8DrRzw/ZTgyPNc2n6Syz7T8heKn+bExBByWj6cJ5
         lvu/gmiYyBshUiGC61DJdnLF7bRnBr1Y0jLNqrroXc7wFBdETAZUCI1QvLIiOp7FvmJ5
         qr+/024rW+6SHW2MQ93ca/JU31AsnzVJ5Ycdd1zsYwolP0w35TQVYNiEcDQBKZzHyT2+
         pIdw==
X-Gm-Message-State: AOAM531bCJ57ufFjZIOBNLtk59u729CCpXgpG705s514d9ANxpel0RTs
        TU8LTmeEQX3O3kpSuMJHhukm9hUVk1YQ4w==
X-Google-Smtp-Source: ABdhPJzZgDgL6BsqGAECJjVTfGHuh8g2LRqmDMavWBTw5QIrRDpouvpvmvk8deqEowLzJLiDYmSfNLvYEqF+ng==
X-Received: by 2002:ad4:5843:: with SMTP id de3mr1233829qvb.195.1590104423239;
 Thu, 21 May 2020 16:40:23 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:33 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-19-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 18/22] l2tp: fix l2tp_eth module loading
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
index 4c122494f022..d22a39c0c486 100644
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
 
@@ -336,22 +312,6 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
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

