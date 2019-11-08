Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF29F556C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732905AbfKHTCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390501AbfKHTCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9DC214DB;
        Fri,  8 Nov 2019 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239740;
        bh=52b2NPQwj3xM9cq/tc1U2aDYddp76xptCa/1BAeQLrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzSmcaktHGGqgCsU7i6CGSVq1mLx2TykeuslYng1Mr5agOGNKx45UQMc8MkZvACEv
         lWZdweLJJH45KxyN9V2C5hF4ureiuwzamA2Ad7jHCdh4GjIdxsBg5QRMt2mraNXTAk
         BjF+8mnJ3nq9FAHmdDk2FfjySipzLSB6ZB2m9Xts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 46/79] net: hisilicon: Fix ping latency when deal with high throughput
Date:   Fri,  8 Nov 2019 19:50:26 +0100
Message-Id: <20191108174812.636370033@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit e56bd641ca61beb92b135298d5046905f920b734 ]

This is due to error in over budget processing.
When dealing with high throughput, the used buffers
that exceeds the budget is not cleaned up. In addition,
it takes a lot of cycles to clean up the used buffer,
and then the buffer where the valid data is located can take effect.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -174,6 +174,7 @@ struct hip04_priv {
 	dma_addr_t rx_phys[RX_DESC_NUM];
 	unsigned int rx_head;
 	unsigned int rx_buf_size;
+	unsigned int rx_cnt_remaining;
 
 	struct device_node *phy_node;
 	struct phy_device *phy;
@@ -487,7 +488,6 @@ static int hip04_rx_poll(struct napi_str
 	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
 	struct net_device *ndev = priv->ndev;
 	struct net_device_stats *stats = &ndev->stats;
-	unsigned int cnt = hip04_recv_cnt(priv);
 	struct rx_desc *desc;
 	struct sk_buff *skb;
 	unsigned char *buf;
@@ -500,8 +500,8 @@ static int hip04_rx_poll(struct napi_str
 
 	/* clean up tx descriptors */
 	tx_remaining = hip04_tx_reclaim(ndev, false);
-
-	while (cnt && !last) {
+	priv->rx_cnt_remaining += hip04_recv_cnt(priv);
+	while (priv->rx_cnt_remaining && !last) {
 		buf = priv->rx_buf[priv->rx_head];
 		skb = build_skb(buf, priv->rx_buf_size);
 		if (unlikely(!skb)) {
@@ -547,11 +547,13 @@ refill:
 		hip04_set_recv_desc(priv, phys);
 
 		priv->rx_head = RX_NEXT(priv->rx_head);
-		if (rx >= budget)
+		if (rx >= budget) {
+			--priv->rx_cnt_remaining;
 			goto done;
+		}
 
-		if (--cnt == 0)
-			cnt = hip04_recv_cnt(priv);
+		if (--priv->rx_cnt_remaining == 0)
+			priv->rx_cnt_remaining += hip04_recv_cnt(priv);
 	}
 
 	if (!(priv->reg_inten & RCV_INT)) {
@@ -636,6 +638,7 @@ static int hip04_mac_open(struct net_dev
 	int i;
 
 	priv->rx_head = 0;
+	priv->rx_cnt_remaining = 0;
 	priv->tx_head = 0;
 	priv->tx_tail = 0;
 	hip04_reset_ppe(priv);


