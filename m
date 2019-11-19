Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9394E1016EB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbfKSFuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbfKSFuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:50:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B75218BA;
        Tue, 19 Nov 2019 05:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142635;
        bh=Eap8rfhue6jU+EgEdwwB97liRNCOi2OAWMuUbN01Agc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/Or2YJOhBl7/HS+bA8yLUSV1c/UyTagJeb7GyRGSmCAoYZtA0+nv+FwMwsahdhJo
         mGhVsCJc9KLktH44cm+XIoSszapfMzpJJgwRaM0GHgEZJy8ARy3lVruGfhwsH8jae6
         jPmXxQMikyRAvqTjIskSFYS+C08leDbHYbeiv6Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 148/239] net: toshiba: fix return type of ndo_start_xmit function
Date:   Tue, 19 Nov 2019 06:19:08 +0100
Message-Id: <20191119051332.476342720@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit bacade822524e02f662d88f784d2ae821a5546fb ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 4 ++--
 drivers/net/ethernet/toshiba/ps3_gelic_net.h | 2 +-
 drivers/net/ethernet/toshiba/spider_net.c    | 4 ++--
 drivers/net/ethernet/toshiba/tc35815.c       | 6 ++++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 88d74aef218a2..75237c81c63d6 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -845,9 +845,9 @@ static int gelic_card_kick_txdma(struct gelic_card *card,
  * @skb: packet to send out
  * @netdev: interface device structure
  *
- * returns 0 on success, <0 on failure
+ * returns NETDEV_TX_OK on success, NETDEV_TX_BUSY on failure
  */
-int gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
+netdev_tx_t gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct gelic_card *card = netdev_card(netdev);
 	struct gelic_descr *descr;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 003d0452d9cb1..fbbf9b54b173b 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -370,7 +370,7 @@ void gelic_card_up(struct gelic_card *card);
 void gelic_card_down(struct gelic_card *card);
 int gelic_net_open(struct net_device *netdev);
 int gelic_net_stop(struct net_device *netdev);
-int gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
+netdev_tx_t gelic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
 void gelic_net_set_multi(struct net_device *netdev);
 void gelic_net_tx_timeout(struct net_device *netdev);
 int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card);
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index cec9e70ab9955..da136b8843dd9 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -880,9 +880,9 @@ out:
  * @skb: packet to send out
  * @netdev: interface device structure
  *
- * returns 0 on success, !0 on failure
+ * returns NETDEV_TX_OK on success, NETDEV_TX_BUSY on failure
  */
-static int
+static netdev_tx_t
 spider_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	int cnt;
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 9146068979d2c..03afc4d8c3ec1 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -474,7 +474,8 @@ static void free_rxbuf_skb(struct pci_dev *hwdev, struct sk_buff *skb, dma_addr_
 /* Index to functions, as function prototypes. */
 
 static int	tc35815_open(struct net_device *dev);
-static int	tc35815_send_packet(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t	tc35815_send_packet(struct sk_buff *skb,
+					    struct net_device *dev);
 static irqreturn_t	tc35815_interrupt(int irq, void *dev_id);
 static int	tc35815_rx(struct net_device *dev, int limit);
 static int	tc35815_poll(struct napi_struct *napi, int budget);
@@ -1248,7 +1249,8 @@ tc35815_open(struct net_device *dev)
  * invariant will hold if you make sure that the netif_*_queue()
  * calls are done at the proper times.
  */
-static int tc35815_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t
+tc35815_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct tc35815_local *lp = netdev_priv(dev);
 	struct TxFD *txfd;
-- 
2.20.1



