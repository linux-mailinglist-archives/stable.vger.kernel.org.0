Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F97A106A52
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfKVKdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfKVKdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:33:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8119520637;
        Fri, 22 Nov 2019 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418830;
        bh=0N8DX0y8dCSe0kBStWkG33SzAOU4gcchl4Dn0oGxglE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BqCnTV6mRlM314yhmAFw0/ToUPC778erMfCovVL9ZfRenizbToTotqUqjZ0siyZj
         BmOkH1QmY3L+K+CxfA29wf6h6iQmrdK3umZ1p/FN1EU84zSKWPc48QjaGPVikAnWDp
         q4lHUt+52bYNbWBYqOV0R2CJiqR4eeqU7nTjT5+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 065/159] net: toshiba: fix return type of ndo_start_xmit function
Date:   Fri, 22 Nov 2019 11:27:36 +0100
Message-Id: <20191122100755.045287457@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
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
index 79f0ec4e51ace..964df98b54ea1 100644
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
index 8505196be9f52..d123644bd720b 100644
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
 int gelic_net_change_mtu(struct net_device *netdev, int new_mtu);
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 3c54a2cae5dfd..8e53211aedd82 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -881,9 +881,9 @@ out:
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
index 868fb6306df02..3e33c165a4278 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -475,7 +475,8 @@ static void free_rxbuf_skb(struct pci_dev *hwdev, struct sk_buff *skb, dma_addr_
 /* Index to functions, as function prototypes. */
 
 static int	tc35815_open(struct net_device *dev);
-static int	tc35815_send_packet(struct sk_buff *skb, struct net_device *dev);
+static netdev_tx_t	tc35815_send_packet(struct sk_buff *skb,
+					    struct net_device *dev);
 static irqreturn_t	tc35815_interrupt(int irq, void *dev_id);
 static int	tc35815_rx(struct net_device *dev, int limit);
 static int	tc35815_poll(struct napi_struct *napi, int budget);
@@ -1279,7 +1280,8 @@ tc35815_open(struct net_device *dev)
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



