Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533BB38AB3B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbhETLVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241006AbhETLTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B479A6195C;
        Thu, 20 May 2021 10:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505448;
        bh=6rdUQUeVTP0airz7hksVZY3ye/GUxnnujGEhtTwlOR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+kL491nOok71kyOTezTrk3coe3+sL7mdlOhExk1i/SsmUq8wkZCjFuGNN8CJ0hIx
         T25DFPiI0U+ygUovgLbbsRTckYdHMMnY5PzXuUQRuw455MlJWiklTDPNf8XCddNXxN
         H5wQO5QilSAuXCqdKZ0N4TtqVP7JV5jHTIETDdo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 112/190] net: lapbether: Prevent racing when checking whether the netif is running
Date:   Thu, 20 May 2021 11:22:56 +0200
Message-Id: <20210520092105.895050162@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 5acd0cfbfbb5a688da1bfb1a2152b0c855115a35 ]

There are two "netif_running" checks in this driver. One is in
"lapbeth_xmit" and the other is in "lapbeth_rcv". They serve to make
sure that the LAPB APIs called in these functions are called before
"lapb_unregister" is called by the "ndo_stop" function.

However, these "netif_running" checks are unreliable, because it's
possible that immediately after "netif_running" returns true, "ndo_stop"
is called (which causes "lapb_unregister" to be called).

This patch adds locking to make sure "lapbeth_xmit" and "lapbeth_rcv" can
reliably check and ensure the netif is running while doing their work.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 666bbacb8cb4..24daa1d0e9c5 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -56,6 +56,8 @@ struct lapbethdev {
 	struct list_head	node;
 	struct net_device	*ethdev;	/* link to ethernet device */
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
+	bool			up;
+	spinlock_t		up_lock;	/* Protects "up" */
 };
 
 static LIST_HEAD(lapbeth_devices);
@@ -103,8 +105,9 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 	rcu_read_lock();
 	lapbeth = lapbeth_get_x25_dev(dev);
 	if (!lapbeth)
-		goto drop_unlock;
-	if (!netif_running(lapbeth->axdev))
+		goto drop_unlock_rcu;
+	spin_lock_bh(&lapbeth->up_lock);
+	if (!lapbeth->up)
 		goto drop_unlock;
 
 	len = skb->data[0] + skb->data[1] * 256;
@@ -119,11 +122,14 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 		goto drop_unlock;
 	}
 out:
+	spin_unlock_bh(&lapbeth->up_lock);
 	rcu_read_unlock();
 	return 0;
 drop_unlock:
 	kfree_skb(skb);
 	goto out;
+drop_unlock_rcu:
+	rcu_read_unlock();
 drop:
 	kfree_skb(skb);
 	return 0;
@@ -151,13 +157,11 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
-	/*
-	 * Just to be *really* sure not to send anything if the interface
-	 * is down, the ethernet device may have gone.
-	 */
-	if (!netif_running(dev))
+	spin_lock_bh(&lapbeth->up_lock);
+	if (!lapbeth->up)
 		goto drop;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
@@ -188,6 +192,7 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 		goto drop;
 	}
 out:
+	spin_unlock_bh(&lapbeth->up_lock);
 	return NETDEV_TX_OK;
 drop:
 	kfree_skb(skb);
@@ -279,6 +284,7 @@ static const struct lapb_register_struct lapbeth_callbacks = {
  */
 static int lapbeth_open(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
@@ -286,13 +292,22 @@ static int lapbeth_open(struct net_device *dev)
 		return -ENODEV;
 	}
 
+	spin_lock_bh(&lapbeth->up_lock);
+	lapbeth->up = true;
+	spin_unlock_bh(&lapbeth->up_lock);
+
 	return 0;
 }
 
 static int lapbeth_close(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
+	spin_lock_bh(&lapbeth->up_lock);
+	lapbeth->up = false;
+	spin_unlock_bh(&lapbeth->up_lock);
+
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
@@ -350,6 +365,9 @@ static int lapbeth_new_device(struct net_device *dev)
 	dev_hold(dev);
 	lapbeth->ethdev = dev;
 
+	lapbeth->up = false;
+	spin_lock_init(&lapbeth->up_lock);
+
 	rc = -EIO;
 	if (register_netdevice(ndev))
 		goto fail;
-- 
2.30.2



