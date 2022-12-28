Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BA657F51
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiL1QDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiL1QD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C55193D3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4704B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0282DC433D2;
        Wed, 28 Dec 2022 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243405;
        bh=AUNv4Z887qHvzpEifxMftsN+gO1fimH5MRbEkobYItI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFBJE2pRyb+PZi4ULClvXjVVpFgnq8Z2l+IMDCESujk4g1eXVYdy05FyARk8lVFGn
         Z/6Bu0tXOLgaKDAAVFNpNo/wNAvkRfaJ0OcNh6w5WIvz4pvwEaVR7VpY/O6rKlGyUX
         LZZPmUU3prdHQkMsz9yF3gKMOLe/p7HQjNvhKMQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0526/1073] net: amd: lance: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:35:14 +0100
Message-Id: <20221228144342.332242390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6151d105dfce8c23edf30eed35e97f3d9b96a35c ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In these two cases, dev_kfree_skb() is called consume the xmited SKB,
so replace it with dev_consume_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/atarilance.c | 2 +-
 drivers/net/ethernet/amd/lance.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 27869164c6e6..ca12f9f48839 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -824,7 +824,7 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	lp->memcpy_f( PKTBUF_ADDR(head), (void *)skb->data, skb->len );
 	head->flag = TMD1_OWN_CHIP | TMD1_ENP | TMD1_STP;
 	dev->stats.tx_bytes += skb->len;
-	dev_kfree_skb( skb );
+	dev_consume_skb_irq(skb);
 	lp->cur_tx++;
 	while( lp->cur_tx >= TX_RING_SIZE && lp->dirty_tx >= TX_RING_SIZE ) {
 		lp->cur_tx -= TX_RING_SIZE;
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index 462016666752..e3b8de9fc728 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -1001,7 +1001,7 @@ static netdev_tx_t lance_start_xmit(struct sk_buff *skb,
 		skb_copy_from_linear_data(skb, &lp->tx_bounce_buffs[entry], skb->len);
 		lp->tx_ring[entry].base =
 			((u32)isa_virt_to_bus((lp->tx_bounce_buffs + entry)) & 0xffffff) | 0x83000000;
-		dev_kfree_skb(skb);
+		dev_consume_skb_irq(skb);
 	} else {
 		lp->tx_skbuff[entry] = skb;
 		lp->tx_ring[entry].base = ((u32)isa_virt_to_bus(skb->data) & 0xffffff) | 0x83000000;
-- 
2.35.1



