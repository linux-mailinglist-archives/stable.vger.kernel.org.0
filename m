Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBDE5F54B7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfKHSw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfKHSw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:52:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB35F214DB;
        Fri,  8 Nov 2019 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239147;
        bh=JxFXf/iL0Po+TwuDxjWfrvI5nmMzUx20GCYDtuU1Ewg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWnhhc+vxGKayDWoF7piaKVwzAn+YpvjdPalyK9pLWaEVS2HwnJqgz9oNYgHoVxr/
         1fxXe95aCK2MPxAHlbIYRAc62rcCBjuzWYMXH9pngz1ZH9PXWocPjqFY11/UBYycKT
         kJOafg+h9Ko+fjXADOcQHFfJ5rtSA+2D/saECvWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 16/75] net: hisilicon: Fix ping latency when deal with high throughput
Date:   Fri,  8 Nov 2019 19:49:33 +0100
Message-Id: <20191108174723.638254470@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
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
 		if (unlikely(!skb))
@@ -544,11 +544,13 @@ static int hip04_rx_poll(struct napi_str
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
@@ -633,6 +635,7 @@ static int hip04_mac_open(struct net_dev
 	int i;
 
 	priv->rx_head = 0;
+	priv->rx_cnt_remaining = 0;
 	priv->tx_head = 0;
 	priv->tx_tail = 0;
 	hip04_reset_ppe(priv);


