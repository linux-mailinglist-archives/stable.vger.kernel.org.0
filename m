Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49896CC3CA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjC1O5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjC1O5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:57:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB7AE05D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF59861804
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F3FC433EF;
        Tue, 28 Mar 2023 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015453;
        bh=oH/ztDFoV3GbW2qU2ue41OlGU3uKtbB6Jwp/hsPErYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S83sZWqs+RI4Wn2u85fDwP9zzOEsTJhgTABWnCgALehsa/FH8i9+a069WHAQmNcyk
         VZqh8jacWqGEhfrQy++ue6Prv8nxYX/EmGQ8O5QlB08DxuoPIlfel7l/su9QrugDgX
         IGDJ9FSVY90jOSjthjYc8u3xHirIogXKl3KpEnDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/224] net/ps3_gelic_net: Fix RX sk_buff length
Date:   Tue, 28 Mar 2023 16:40:51 +0200
Message-Id: <20230328142619.671889419@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index cf8de8a7a8a1e..dffd664e65f4e 100644
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



