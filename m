Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD537C1F6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhELPGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhELPEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831276144C;
        Wed, 12 May 2021 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831567;
        bh=OVAeKp1M0pHvaIID2+91V0fs8aipXm+MRsc9uwx9BuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E69JFnKUO1SqHzKuSZUWihy+88arFLd5ULSj5KrGoHEXkB2tpkxB2v72vpG7bH/t0
         mEIMHB/AELrBcStrAl8y49f3Zu7/Z7GWnIbYebV+7/LNvNOpvCAsyvGXrGTsu1kmvA
         SCDZc0lFNaOUphrlUeERhMko27LFw9Dcd0kOijhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/244] net: lapbether: Prevent racing when checking whether the netif is running
Date:   Wed, 12 May 2021 16:49:03 +0200
Message-Id: <20210512144748.506650037@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 60f357d2f79f..4e42954d8cbf 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -51,6 +51,8 @@ struct lapbethdev {
 	struct list_head	node;
 	struct net_device	*ethdev;	/* link to ethernet device */
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
+	bool			up;
+	spinlock_t		up_lock;	/* Protects "up" */
 };
 
 static LIST_HEAD(lapbeth_devices);
@@ -98,8 +100,9 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
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
@@ -114,11 +117,14 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
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
@@ -148,13 +154,11 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
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
@@ -185,6 +189,7 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 		goto drop;
 	}
 out:
+	spin_unlock_bh(&lapbeth->up_lock);
 	return NETDEV_TX_OK;
 drop:
 	kfree_skb(skb);
@@ -276,6 +281,7 @@ static const struct lapb_register_struct lapbeth_callbacks = {
  */
 static int lapbeth_open(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
@@ -283,13 +289,22 @@ static int lapbeth_open(struct net_device *dev)
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
 
@@ -347,6 +362,9 @@ static int lapbeth_new_device(struct net_device *dev)
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



