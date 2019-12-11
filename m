Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998B211B497
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbfLKPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732700AbfLKPZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB26B208C3;
        Wed, 11 Dec 2019 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077904;
        bh=XFY2YXT24AeENfZJ8m5GBF/ostWCmKVB4tDgj9c42Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HydYMX+Ee2R/XZdTUixf14EZAYzAL452zAJCobyjnl1rPsRev59iJYZzgvIY+fc44
         TKbmijdjGb6u9Ve6sEert7Ix1Ju+KUHFDYPJy4mwMHQbt3+77Aw2m4zaiCbPxoGGIn
         aqKff41WEfLyDLfe07QUd1b2ho8FlBdu9sgYiiUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Julien Floret <julien.floret@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 215/243] xfrm interface: fix management of phydev
Date:   Wed, 11 Dec 2019 16:06:17 +0100
Message-Id: <20191211150353.865115344@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 22d6552f827ef76ade3edf6bbb3f05048a0a7d8b upstream.

With the current implementation, phydev cannot be removed:

$ ip link add dummy type dummy
$ ip link add xfrm1 type xfrm dev dummy if_id 1
$ ip l d dummy
 kernel:[77938.465445] unregister_netdevice: waiting for dummy to become free. Usage count = 1

Manage it like in ip tunnels, ie just keep the ifindex. Not that the side
effect, is that the phydev is now optional.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/xfrm.h        |    1 -
 net/xfrm/xfrm_interface.c |   34 ++++++++++++++++++----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1062,7 +1062,6 @@ struct xfrm_if_parms {
 struct xfrm_if {
 	struct xfrm_if __rcu *next;	/* next interface in list */
 	struct net_device *dev;		/* virtual device associated with interface */
-	struct net_device *phydev;	/* physical device */
 	struct net *net;		/* netns for packet i/o */
 	struct xfrm_if_parms p;		/* interface parms */
 
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -177,7 +177,6 @@ static void xfrmi_dev_uninit(struct net_
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
 	xfrmi_unlink(xfrmn, xi);
-	dev_put(xi->phydev);
 	dev_put(dev);
 }
 
@@ -364,7 +363,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_
 		goto tx_err;
 	}
 
-	fl.flowi_oif = xi->phydev->ifindex;
+	fl.flowi_oif = xi->p.link;
 
 	ret = xfrmi_xmit2(skb, dev, &fl);
 	if (ret < 0)
@@ -553,7 +552,7 @@ static int xfrmi_get_iflink(const struct
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return xi->phydev->ifindex;
+	return xi->p.link;
 }
 
 
@@ -579,12 +578,14 @@ static void xfrmi_dev_setup(struct net_d
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= xfrmi_dev_free;
 	netif_keep_dst(dev);
+
+	eth_broadcast_addr(dev->broadcast);
 }
 
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
-	struct net_device *phydev = xi->phydev;
+	struct net_device *phydev = __dev_get_by_index(xi->net, xi->p.link);
 	int err;
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -599,13 +600,19 @@ static int xfrmi_dev_init(struct net_dev
 
 	dev->features |= NETIF_F_LLTX;
 
-	dev->needed_headroom = phydev->needed_headroom;
-	dev->needed_tailroom = phydev->needed_tailroom;
-
-	if (is_zero_ether_addr(dev->dev_addr))
-		eth_hw_addr_inherit(dev, phydev);
-	if (is_zero_ether_addr(dev->broadcast))
-		memcpy(dev->broadcast, phydev->broadcast, dev->addr_len);
+	if (phydev) {
+		dev->needed_headroom = phydev->needed_headroom;
+		dev->needed_tailroom = phydev->needed_tailroom;
+
+		if (is_zero_ether_addr(dev->dev_addr))
+			eth_hw_addr_inherit(dev, phydev);
+		if (is_zero_ether_addr(dev->broadcast))
+			memcpy(dev->broadcast, phydev->broadcast,
+			       dev->addr_len);
+	} else {
+		eth_hw_addr_random(dev);
+		eth_broadcast_addr(dev->broadcast);
+	}
 
 	return 0;
 }
@@ -655,13 +662,8 @@ static int xfrmi_newlink(struct net *src
 	xi->p = p;
 	xi->net = net;
 	xi->dev = dev;
-	xi->phydev = dev_get_by_index(net, p.link);
-	if (!xi->phydev)
-		return -ENODEV;
 
 	err = xfrmi_create(dev);
-	if (err < 0)
-		dev_put(xi->phydev);
 	return err;
 }
 


