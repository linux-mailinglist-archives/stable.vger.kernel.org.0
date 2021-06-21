Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D1E3AEE7A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhFUQ3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231892AbhFUQ2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C467613B1;
        Mon, 21 Jun 2021 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292590;
        bh=Tyy6jEVdGZZjBAucuzuywBn8G+/KiDXxfkyZU26Lvvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qh/kwLCR4APhZrLjMmNCCVU9ZqSoUIg0TQSezO1MJSS2DJhwq7/kF0NJVtiJh5/Oy
         1APDyLy1JqeevFl0stK0bQIMTxWbMa4blrhNXhC3Uh+42j7TmUWtnHtTXr13o6RS51
         A9WMBE9sbHSD0Rw0waz6zCxCwTjfYlKX4VMNMxI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/146] lantiq: net: fix duplicated skb in rx descriptor ring
Date:   Mon, 21 Jun 2021 18:14:47 +0200
Message-Id: <20210621154914.175949075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 7ea6cd16f1599c1eac6018751eadbc5fc736b99a ]

The previous commit didn't fix the bug properly. By mistake, it replaces
the pointer of the next skb in the descriptor ring instead of the current
one. As a result, the two descriptors are assigned the same SKB. The error
is seen during the iperf test when skb_put tries to insert a second packet
and exceeds the available buffer.

Fixes: c7718ee96dbc ("net: lantiq: fix memory corruption in RX ring ")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_xrx200.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 3da494df72f3..072075bc60ee 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -154,6 +154,7 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
+	struct sk_buff *skb = ch->skb[ch->dma.desc];
 	dma_addr_t mapping;
 	int ret = 0;
 
@@ -168,6 +169,7 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 				 XRX200_DMA_DATA_LEN, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
+		ch->skb[ch->dma.desc] = skb;
 		ret = -ENOMEM;
 		goto skip;
 	}
@@ -198,7 +200,6 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	ch->dma.desc %= LTQ_DESC_NUM;
 
 	if (ret) {
-		ch->skb[ch->dma.desc] = skb;
 		net_dev->stats.rx_dropped++;
 		netdev_err(net_dev, "failed to allocate new rx buffer\n");
 		return ret;
-- 
2.30.2



