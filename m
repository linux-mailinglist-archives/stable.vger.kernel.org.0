Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015BD6AE8DD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCGRTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCGRSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:18:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0752F14497
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E6C7B819A8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E0C433EF;
        Tue,  7 Mar 2023 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209260;
        bh=bfoZgRb/7jxpqKI4Xsy7cYJwDapXyVcUVIK9GONhrgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/oiSIO/68fiQAxnp8K1D/bOIdfx31dZTbKkUSHF2DnRPqu2VEEL/7HkKNl8jbDfZ
         OJjWIjQ21xR47j2Ht8cY1fJmWhD4YIim4JzLpvNPusJYPeXVpM5B1NT6eBuzB973Oj
         yo4Lny4gnfT+8DKzEQcmFbgZahVCiZ6ELadDtZlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0162/1001] wifi: ipw2x00: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Tue,  7 Mar 2023 17:48:54 +0100
Message-Id: <20230307170029.052920460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index ca802af8cddcc..cc66fd92278e4 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3427,7 +3427,7 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
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



