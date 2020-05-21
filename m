Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B431DD052
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgEUOlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:49 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3F0C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:48 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v6so7595940qkd.9
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zTtQ6CYoIBOTsWWPDTWbPUL/ggZGCENzx78XriOvSdQ=;
        b=lYazLPnW8FfZlcOSXQh6ve7KugymJ2NPH39vrbr1NJXS2x6i9HK/p8urb9MVMVhoiE
         gno+ds2w5W6yGVF4o/U9E8Z5KckIXMskJ0jtEillOhf5YLtCuKbrjV+nuKB4847nycX8
         B/5G3OQSSB1muFFV0VmJkwumXqnhp51HFPveA/cUba6H/3tHLR2rOzPtiNMxRkeOk8HA
         +P3wHmT6hL9f21x+5Tc7Z+DIDQOLGhjBnweaBgex5AbBTJ2ggL+BYPBta0PnuOY6eWHJ
         8WrkbRWMrE/W+khYHjN6NETPUNC4Qzv11iFG33328sOdD9YsnZB3UthOX6Hu+pL2V/z4
         Crqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zTtQ6CYoIBOTsWWPDTWbPUL/ggZGCENzx78XriOvSdQ=;
        b=ufMXYUWoiz5Rjroqtz2peezzkF8aLuS51sfcJ9s4bulrqFpDoHxC1pfpu/ZiKnc20p
         q7pSpz1s5g0PkMPdC4aAD8kkYturDzSZGkxigd0tQDK0aRbtix/Hvw0eluoXXMTAatMf
         SwYdYj7Z08JL5x9IMGkczENJ4J29iE+MHmL4zdb0e+XAWSM7qQQxdH+79AJw4eKXz0cA
         WzV6B+g72pm1cY3BcZhUuSyT7dj1d/zXzIL3Xf1UJ+Ln4A7D+HuuL7Pru8khW7OXn4nH
         uTknI0t0jb4rmezmGGop4CEdC3gyvi1wD4sDJBsELIuqrYLDe0Knm1UU1JINfTClA+X7
         0dUA==
X-Gm-Message-State: AOAM53292kLJthyA5murCu982qfyWIwBs/8+QIqQaX9BoBnT3Dll8bOk
        liBsRS9toKQy11XalRXAEbJCxSX6hKuLHw==
X-Google-Smtp-Source: ABdhPJyZwe91Ay8QVichHM0xMSFkGue0w1lx63wjQcZ7cK1BLxJCN5h+gHAPJmpdMZHDu9LC/ZjZ03IB9YySpQ==
X-Received: by 2002:ad4:4801:: with SMTP id g1mr10080144qvy.199.1590072108167;
 Thu, 21 May 2020 07:41:48 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:56 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-19-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 18/22] l2tp: fix l2tp_eth module loading
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

commit 9f775ead5e570e7e19015b9e4e2f3dd6e71a5935 uptream.

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
2.26.2.761.g0e0b3e54be-goog

