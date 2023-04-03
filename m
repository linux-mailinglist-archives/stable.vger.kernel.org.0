Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E116D4748
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjDCOS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjDCOSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E6A2CAE9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15517B81BA4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C8C433D2;
        Mon,  3 Apr 2023 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531530;
        bh=I3CygEvkAfk/GYomKRWwVNyKvkx3rG2+EFlJeLGmp+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOL/GPnhcYjlQqiZiJQb5hWrESGq1z8V7QTSUO0wGCB2+1cpjz6Ki/LsDJHyn4yQU
         99qXO/9fzeej94HsAGxGT5/pbBle3PmA4qDMXMRA4OlHbECUEku5b2BIHdWLxn43FM
         DMBIuVARKSsJ2WO66iABsxQvf3h01NNHjJJuN8SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Duyck <alexanderduyck@fb.com>,
        Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/104] net/ps3_gelic_net: Use dma_mapping_error
Date:   Mon,  3 Apr 2023 16:08:06 +0200
Message-Id: <20230403140404.737352242@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>

[ Upstream commit bebe933d35a63d4f042fbf4dce4f22e689ba0fcd ]

The current Gelic Etherenet driver was checking the return value of its
dma_map_single call, and not using the dma_mapping_error() routine.

Fixes runtime problems like these:

  DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
  WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 24 +++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index c3e3477081e48..4e6c71da9f21f 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -317,15 +317,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -375,6 +377,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	static const unsigned int rx_skb_size =
 		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
 		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
@@ -398,11 +401,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_FRAME,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -782,7 +784,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
-- 
2.39.2



