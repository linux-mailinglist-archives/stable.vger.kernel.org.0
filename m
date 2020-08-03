Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9E23A6D1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgHCMyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgHCMXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F30722076B;
        Mon,  3 Aug 2020 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457389;
        bh=cEtJnSUaGtbTxH18GKYsJEmTgJr5ZoxfZl79ZRBrVn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rtZLjAL9aJg2PqUwfYpt+eI0gAlcKgLqUNOBYHvVyx0xkVn6uRKr77t8MmBsHyrd
         9nQVsjtk2oXu/gNVWxIIvlktd5iI+sGYEn03qDt5k1HooDn+eEwsAYA+UfRq3+BHgr
         6v7uKUJ033KLB7n73w58pejHXo8W1NKH9ARuef7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 049/120] net: hns3: fix desc filling bug when skb is expanded or lineared
Date:   Mon,  3 Aug 2020 14:18:27 +0200
Message-Id: <20200803121905.192237001@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit cfdaeba5ddc98b303639a3265c2031ac5db249d6 ]

The linear and frag data part may be changed when the skb is expanded
or lineared in skb_cow_head() or skb_checksum_help(), which is called
by hns3_fill_skb_desc(), so the linear len return by skb_headlen()
before the calling of hns3_fill_skb_desc() is unreliable.

Move hns3_fill_skb_desc() before the calling of skb_headlen() to fix
this bug.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index df1cb0441183c..0b12425fa2845 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1098,16 +1098,8 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	int k, sizeoflast;
 	dma_addr_t dma;
 
-	if (type == DESC_TYPE_SKB) {
-		struct sk_buff *skb = (struct sk_buff *)priv;
-		int ret;
-
-		ret = hns3_fill_skb_desc(ring, skb, desc);
-		if (unlikely(ret < 0))
-			return ret;
-
-		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
-	} else if (type == DESC_TYPE_FRAGLIST_SKB) {
+	if (type == DESC_TYPE_FRAGLIST_SKB ||
+	    type == DESC_TYPE_SKB) {
 		struct sk_buff *skb = (struct sk_buff *)priv;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
@@ -1452,6 +1444,10 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	next_to_use_head = ring->next_to_use;
 
+	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use]);
+	if (unlikely(ret < 0))
+		goto fill_err;
+
 	ret = hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
 	if (unlikely(ret < 0))
 		goto fill_err;
-- 
2.25.1



