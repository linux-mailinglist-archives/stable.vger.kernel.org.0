Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205BB767A9
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfGZNhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:37:47 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:34551 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfGZNhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 09:37:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D21345AC;
        Fri, 26 Jul 2019 09:37:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 09:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZhTxLl
        ZX+nH1Og4Kfxp4Xn2FFwtHFu9eLjPPLOHOSuc=; b=UzUkwYebQt7vujmtRl/ejp
        0mOqZQ73s7B0mMnGqXcZLdHczZdj0G2Fj12yKiWnbwL9G9NXP0n07krY0cIMlHRV
        a9uMsC1I7MvPjc4wqx3fzpQK0qyNSKTZUgoy3OBgQ/ViHJZnqM4wqvH/A4VIcW2J
        yXJulDwLzesQnHb5Kd2ORLjDb9aqPVrFboA9aVTaVYfO85WcsF1Xyn1Bq933/5RA
        4servVJoNY2PNbhs0PMC6xW5x/dIIm4e/EbqjPtDzv4fNZmJkx4lTf8yaVlPuIw6
        3uxcS+DfwSmlhvYaqqZOjRIkK6gHS6acmTJNNU1ZVT68r7f8OchM//YI1HmzmCHg
        ==
X-ME-Sender: <xms:KAI7XUE8yV2zZUn68U4glFzVzYj4dkmzDhMit33WiYFrrJY6Wj9Npg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:KQI7XeSL9eBRvhUj7hELlTuXtSTS_qK2gluROeoMbREQG8HsI8GTYg>
    <xmx:KQI7XedtGPF32q_JYJa-ad5WgWPT42QB5S55WMWrcsj7mvAQB1LUow>
    <xmx:KQI7XUgfmuoAHs8iOS-E7Ichoka8YkDsqVYa5dujLSNFw_IbTzp_Nw>
    <xmx:KQI7XRoo4l9SJBYfxtrWDQtpIk7zWaGPE0hkAWePTQAMohFOZ0NNQA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9990280063;
        Fri, 26 Jul 2019 09:37:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: stmmac: Re-work the queue selection for TSO packets" failed to apply to 4.14-stable tree
To:     Jose.Abreu@synopsys.com, ben@decadent.org.uk, davem@davemloft.net,
        joabreu@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jul 2019 15:37:43 +0200
Message-ID: <156414826318121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4993e5b37e8bcb55ac90f76eb6d2432647273747 Mon Sep 17 00:00:00 2001
From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 8 Jul 2019 14:26:28 +0200
Subject: [PATCH] net: stmmac: Re-work the queue selection for TSO packets

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

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06358fe5b245..11b6feb33b54 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3045,17 +3045,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
@@ -3872,6 +3863,22 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
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
@@ -4088,6 +4095,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_tx_timeout = stmmac_tx_timeout,
 	.ndo_do_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
+	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = stmmac_poll_controller,
 #endif

