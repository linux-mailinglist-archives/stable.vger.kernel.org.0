Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366263DF97
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiK3Ss4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiK3Sso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62671A205
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65892B81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA2FC433D6;
        Wed, 30 Nov 2022 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834118;
        bh=xL0QLBhARx3V2fKRqnoxqZLf5A3hP+k6oYzYu2F/iYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POiN/2z6gVXl9E5I9FJbYFU9zAzXZ7gz5Rw7T8zSBP40fcJ1bvg/wgCCMvXvI6ZVg
         wYOVBY5C2Bj+CXyNK433CrG6yO9EWDpHM4fJBLxHZ8HLLZFckBPsVarS5evNB2Gn+a
         3jhBUpT4SN9cKVQL2jP/dxfcrwXM/6DcrrTHjczQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 135/289] net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
Date:   Wed, 30 Nov 2022 19:22:00 +0100
Message-Id: <20221130180547.198925844@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 3213f808ae21be3891885de2f3a775afafcda987 ]

When fail to dma_map_single() in mtk_rx_alloc(), it returns directly.
But the memory allocated for local variable data is not freed, and
local variabel data has not been attached to ring->data[i] yet, so the
memory allocated for local variable data will not be freed outside
mtk_rx_alloc() too. Thus memory leak would occur in this scenario.

Add skb_free_frag(data) when dma_map_single() failed.

Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Link: https://lore.kernel.org/r/20221120035405.1464341-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a75f5931f746..916b570bdbf4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2363,8 +2363,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 				data + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size, DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(eth->dma_dev,
-						       dma_addr)))
+						       dma_addr))) {
+				skb_free_frag(data);
 				return -ENOMEM;
+			}
 		}
 		rxd->rxd1 = (unsigned int)dma_addr;
 		ring->data[i] = data;
-- 
2.35.1



