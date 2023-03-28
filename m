Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4452C6CC4FA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjC1PLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjC1PLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F1EB59
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942FEB81D90
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04494C433D2;
        Tue, 28 Mar 2023 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016109;
        bh=xZ3LeRF2z73hdEbcpGLdhe9E+Aq2o5QZlc4EMcOm+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ08TYnVp5NJdkyiertwbssu16i2+T6hoUHTaJqE76h9bDxfWCY7xdZijhQKiJZd8
         KNzkeRPLRm9kAW6WUqH8bAb3UefbHUN41RdI6QTVSBQphN8sS4mnhFBWIUcKWzeW7j
         2Wt5tWR6zFOytYIhnpDh0cfvooFQ/ILepn1rgc7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/146] net/ps3_gelic_net: Fix RX sk_buff length
Date:   Tue, 28 Mar 2023 16:42:07 +0200
Message-Id: <20230328142604.289624356@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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

[ Upstream commit 19b3bb51c3bc288b3f2c6f8c4450b0f548320625 ]

The Gelic Ethernet device needs to have the RX sk_buffs aligned to
GELIC_NET_RXBUF_ALIGN, and also the length of the RX sk_buffs must
be a multiple of GELIC_NET_RXBUF_ALIGN.

The current Gelic Ethernet driver was not allocating sk_buffs large
enough to allow for this alignment.

Also, correct the maximum and minimum MTU sizes, and add a new
preprocessor macro for the maximum frame size, GELIC_NET_MAX_FRAME.

Fixes various randomly occurring runtime network errors.

Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 19 ++++++++++---------
 drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 55e652624bd76..bd1316db2d944 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -365,26 +365,27 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
+	static const unsigned int rx_skb_size =
+		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
+		GELIC_NET_RXBUF_ALIGN - 1;
 	int offset;
-	unsigned int bufsize;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	descr->skb = netdev_alloc_skb(*card->netdev, rx_skb_size);
 	if (!descr->skb) {
 		descr->buf_addr = 0; /* tell DMAC don't touch memory */
 		return -ENOMEM;
 	}
-	descr->buf_size = cpu_to_be32(bufsize);
+	descr->buf_size = cpu_to_be32(rx_skb_size);
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
@@ -397,7 +398,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	/* io-mmu-map the skb */
 	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
 						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
+						     GELIC_NET_MAX_FRAME,
 						     DMA_FROM_DEVICE));
 	if (!descr->buf_addr) {
 		dev_kfree_skb_any(descr->skb);
@@ -915,7 +916,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	data_error = be32_to_cpu(descr->data_error);
 	/* unmap skb buffer */
 	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
-			 GELIC_NET_MAX_MTU,
+			 GELIC_NET_MAX_FRAME,
 			 DMA_FROM_DEVICE);
 
 	skb_put(skb, be32_to_cpu(descr->valid_size)?
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 68f324ed4eaf0..0d98defb011ed 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,8 +19,9 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
-#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
+#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_MTU               2294
+#define GELIC_NET_MIN_MTU               64
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
-- 
2.39.2



