Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A334C899
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhC2IX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233288AbhC2IVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28EFD6197F;
        Mon, 29 Mar 2021 08:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006106;
        bh=O0bTySistTYthnftyFZ0BGV7Ep+Wg2/RLcHRhUjE+o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1e79DuSDoiH2YUqkUabvwaWA/WVa+sj2qmVL5I9wI2I/IoV3i3nRVSqIbJPMsEpsd
         nPjGhWdElCAw1ftEKA7jD1olNn5EezZvDgumGXPwU28Uz4AWYM/wNzEy83Gw11ieHY
         dv5k1viGsMI6K72KU/pknJzfnsk11U5A1Kg7t07Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/221] net: hdlc_x25: Prevent racing between "x25_close" and "x25_xmit"/"x25_rx"
Date:   Mon, 29 Mar 2021 09:57:31 +0200
Message-Id: <20210329075633.211220543@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit bf0ffea336b493c0a8c8bc27b46683ecf1e8f294 ]

"x25_close" is called by "hdlc_close" in "hdlc.c", which is called by
hardware drivers' "ndo_stop" function.
"x25_xmit" is called by "hdlc_start_xmit" in "hdlc.c", which is hardware
drivers' "ndo_start_xmit" function.
"x25_rx" is called by "hdlc_rcv" in "hdlc.c", which receives HDLC frames
from "net/core/dev.c".

"x25_close" races with "x25_xmit" and "x25_rx" because their callers race.

However, we need to ensure that the LAPB APIs called in "x25_xmit" and
"x25_rx" are called before "lapb_unregister" is called in "x25_close".

This patch adds locking to ensure when "x25_xmit" and "x25_rx" are doing
their work, "lapb_unregister" is not yet called in "x25_close".

Reasons for not solving the racing between "x25_close" and "x25_xmit" by
calling "netif_tx_disable" in "x25_close":
1. We still need to solve the racing between "x25_close" and "x25_rx";
2. The design of the HDLC subsystem assumes the HDLC hardware drivers
have full control over the TX queue, and the HDLC protocol drivers (like
this driver) have no control. Controlling the queue here in the protocol
driver may interfere with hardware drivers' control of the queue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_x25.c | 42 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 34bc53facd11..6938cb3bdf4e 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -23,6 +23,8 @@
 
 struct x25_state {
 	x25_hdlc_proto settings;
+	bool up;
+	spinlock_t up_lock; /* Protects "up" */
 };
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
@@ -105,6 +107,8 @@ static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 
 static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 	int result;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
@@ -115,12 +119,20 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	spin_lock_bh(&x25st->up_lock);
+	if (!x25st->up) {
+		spin_unlock_bh(&x25st->up_lock);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
 		skb_reset_network_header(skb);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
+		spin_unlock_bh(&x25st->up_lock);
 		return NETDEV_TX_OK;
 
 	case X25_IFACE_CONNECT:
@@ -149,6 +161,7 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		break;
 	}
 
+	spin_unlock_bh(&x25st->up_lock);
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -166,6 +179,7 @@ static int x25_open(struct net_device *dev)
 		.data_transmit = x25_data_transmit,
 	};
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 	struct lapb_parms_struct params;
 	int result;
 
@@ -192,6 +206,10 @@ static int x25_open(struct net_device *dev)
 	if (result != LAPB_OK)
 		return -EINVAL;
 
+	spin_lock_bh(&x25st->up_lock);
+	x25st->up = true;
+	spin_unlock_bh(&x25st->up_lock);
+
 	return 0;
 }
 
@@ -199,6 +217,13 @@ static int x25_open(struct net_device *dev)
 
 static void x25_close(struct net_device *dev)
 {
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
+
+	spin_lock_bh(&x25st->up_lock);
+	x25st->up = false;
+	spin_unlock_bh(&x25st->up_lock);
+
 	lapb_unregister(dev);
 }
 
@@ -207,15 +232,28 @@ static void x25_close(struct net_device *dev)
 static int x25_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
 		dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
-	if (lapb_data_received(dev, skb) == LAPB_OK)
+	spin_lock_bh(&x25st->up_lock);
+	if (!x25st->up) {
+		spin_unlock_bh(&x25st->up_lock);
+		kfree_skb(skb);
+		dev->stats.rx_dropped++;
+		return NET_RX_DROP;
+	}
+
+	if (lapb_data_received(dev, skb) == LAPB_OK) {
+		spin_unlock_bh(&x25st->up_lock);
 		return NET_RX_SUCCESS;
+	}
 
+	spin_unlock_bh(&x25st->up_lock);
 	dev->stats.rx_errors++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
@@ -300,6 +338,8 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		state(hdlc)->up = false;
+		spin_lock_init(&state(hdlc)->up_lock);
 
 		/* There's no header_ops so hard_header_len should be 0. */
 		dev->hard_header_len = 0;
-- 
2.30.1



