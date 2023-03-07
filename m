Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB5B6AF33F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjCGTCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjCGTCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:02:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0B2AF0DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A81C61539
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C34BC4339B;
        Tue,  7 Mar 2023 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214867;
        bh=gMPbaTDfJ1dvSoVqfAG5jDul9zjlycyet/arz3jMpKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRfCl6LjUYZmfJIOZltbq6JkvLiI+XSgl7Xm+2CY71C1+y7zQzXryYU960NG9BAV4
         RI6ndvOlqW31faenxO79YxmICcEMRl+RzNkAN88jtHXVTEWxOD9tGyOJK+AbVF9o9A
         +WSFZo3AY8e+XSR/NmVgMjb+x2Sb8FTGD1PSD5XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/567] wifi: ipw2x00: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Tue,  7 Mar 2023 17:56:51 +0100
Message-Id: <20230307165909.155922085@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 45fc6d7461f18df2f238caf0cbc5acc4163203d1 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called to free and drop the SKB when
it's reset, so replace it with dev_kfree_skb_irq(). Compile tested
only.

Fixes: 43f66a6ce8da ("Add ipw2200 wireless driver.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221208143826.2385218-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ada6ce32c1f19..df28e4a05e140 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3444,7 +3444,7 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 			dma_unmap_single(&priv->pci_dev->dev,
 					 rxq->pool[i].dma_addr,
 					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+			dev_kfree_skb_irq(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-- 
2.39.2



