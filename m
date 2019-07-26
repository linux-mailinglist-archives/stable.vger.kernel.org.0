Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F49B76DE6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbfGZPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbfGZPZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:25:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49FC422CC0;
        Fri, 26 Jul 2019 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154751;
        bh=gYT19168glcXg4J3GUDQbnky9Yoz1Ow4mQTbq1yzZG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQdzilaKUsD0MravRhJoD7YZQs76HblY7W/0/3Eiafu7YCwb1lhAfO5b+7fZOLLpX
         kqnQ4FWLnq6IXjy0rSXCNNqkdwG7OJhOfH6+vsXmV6qu5PJRHIYS6AAyWuzbrDEpY1
         +svxgt29xIlPAFvOIc+XYx4IhucuRfjwwjK9/Xuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 15/66] net: stmmac: Re-work the queue selection for TSO packets
Date:   Fri, 26 Jul 2019 17:24:14 +0200
Message-Id: <20190726152303.482512030@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 4993e5b37e8bcb55ac90f76eb6d2432647273747 ]

Ben Hutchings says:
	"This is the wrong place to change the queue mapping.
	stmmac_xmit() is called with a specific TX queue locked,
	and accessing a different TX queue results in a data race
	for all of that queue's state.

	I think this commit should be reverted upstream and in all
	stable branches.  Instead, the driver should implement the
	ndo_select_queue operation and override the queue mapping there."

Fixes: c5acdbee22a1 ("net: stmmac: Send TSO packets always from Queue 0")
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3048,17 +3048,8 @@ static netdev_tx_t stmmac_xmit(struct sk
 
 	/* Manage oversized TCP frames for GMAC4 device */
 	if (skb_is_gso(skb) && priv->tso) {
-		if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
-			/*
-			 * There is no way to determine the number of TSO
-			 * capable Queues. Let's use always the Queue 0
-			 * because if TSO is supported then at least this
-			 * one will be capable.
-			 */
-			skb_set_queue_mapping(skb, 0);
-
+		if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
 			return stmmac_tso_xmit(skb, dev);
-		}
 	}
 
 	if (unlikely(stmmac_tx_avail(priv, queue) < nfrags + 1)) {
@@ -3875,6 +3866,22 @@ static int stmmac_setup_tc(struct net_de
 	}
 }
 
+static u16 stmmac_select_queue(struct net_device *dev, struct sk_buff *skb,
+			       struct net_device *sb_dev)
+{
+	if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
+		/*
+		 * There is no way to determine the number of TSO
+		 * capable Queues. Let's use always the Queue 0
+		 * because if TSO is supported then at least this
+		 * one will be capable.
+		 */
+		return 0;
+	}
+
+	return netdev_pick_tx(dev, skb, NULL) % dev->real_num_tx_queues;
+}
+
 static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -4091,6 +4098,7 @@ static const struct net_device_ops stmma
 	.ndo_tx_timeout = stmmac_tx_timeout,
 	.ndo_do_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
+	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = stmmac_poll_controller,
 #endif


