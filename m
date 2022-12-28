Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BE7657A83
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiL1PMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiL1PMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6228313E93
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B6BAB8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007BCC433F1;
        Wed, 28 Dec 2022 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240311;
        bh=5firCHvF1oSB1w73TP9eW8wZdKRn5T4g/bjy2shhvO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayMd1AEThSsCjOBri4XL2XhFmVQ28QIWTnQXgz2ps0EcxguAGe2SdxFSEIsy71JM7
         yb56Jp7MWiJQ006ZZazj1vcR3796xKtJ7DfjeKMaKxNU/9xI6sIFvLSN/MmNKnDnOJ
         Y0Q5NHpwoKFeXNII2zUBOW6s7KeUZwtGBQLKnrxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/731] hamradio: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:37:22 +0100
Message-Id: <20221228144306.279818463@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 3727f742915f04f6fc550b80cf406999bd4e90d0 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In scc_discard_buffers(), dev_kfree_skb() is called to discard the SKBs,
so replace it with dev_kfree_skb_irq().

In scc_net_tx(), dev_kfree_skb() is called to drop the SKB that exceed
queue length, so replace it with dev_kfree_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/scc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index e0bb131a33d7..39db3cae4dd1 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -301,12 +301,12 @@ static inline void scc_discard_buffers(struct scc_channel *scc)
 	spin_lock_irqsave(&scc->lock, flags);	
 	if (scc->tx_buff != NULL)
 	{
-		dev_kfree_skb(scc->tx_buff);
+		dev_kfree_skb_irq(scc->tx_buff);
 		scc->tx_buff = NULL;
 	}
 	
 	while (!skb_queue_empty(&scc->tx_queue))
-		dev_kfree_skb(skb_dequeue(&scc->tx_queue));
+		dev_kfree_skb_irq(skb_dequeue(&scc->tx_queue));
 
 	spin_unlock_irqrestore(&scc->lock, flags);
 }
@@ -1668,7 +1668,7 @@ static netdev_tx_t scc_net_tx(struct sk_buff *skb, struct net_device *dev)
 	if (skb_queue_len(&scc->tx_queue) > scc->dev->tx_queue_len) {
 		struct sk_buff *skb_del;
 		skb_del = skb_dequeue(&scc->tx_queue);
-		dev_kfree_skb(skb_del);
+		dev_kfree_skb_irq(skb_del);
 	}
 	skb_queue_tail(&scc->tx_queue, skb);
 	netif_trans_update(dev);
-- 
2.35.1



