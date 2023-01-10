Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53163664931
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbjAJSTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239220AbjAJSSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:18:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D4C17405
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E46261864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900DFC433D2;
        Tue, 10 Jan 2023 18:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374592;
        bh=Jzo1fSGFLtDH53nP91JViVFQCMgLGz9KkLEPfuwH8o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9brZnomzVE9e8wRAjGV1rVvhjBTjBZ/tCE+ltPNQ0mUS3ZXxrY+rvjwhnY/XY8CV
         1H4OwsPNL7H4rr9ri0pR+KgEf65W8k4R27FhsqMXOavhHqVqYdTfTeX7N2Hd+NJqu4
         LyEInzo8hzBU4PnEizaclySMzjpl/6D2Vd0IbYNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/159] bnxt_en: Fix first buffer size calculations for XDP multi-buffer
Date:   Tue, 10 Jan 2023 19:03:06 +0100
Message-Id: <20230110180019.528415152@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1abeacc1979fa4a756695f5030791d8f0fa934b9 ]

The size of the first buffer is always page size, and the useable
space is the page size minus the offset and the skb_shared_info size.
Make sure SKB and XDP buf sizes match so that the skb_shared_info
is at the same offset seen from the SKB and XDP_BUF.

build_skb() should be passed PAGE_SIZE.  xdp_init_buff() should
be passed PAGE_SIZE as well.  xdp_get_shared_info_from_buff() will
automatically deduct the skb_shared_info size if the XDP buffer
has frags.  There is no need to keep bp->xdp_has_frags.

Change BNXT_PAGE_MODE_BUF_SIZE to BNXT_MAX_PAGE_MODE_MTU_SBUF
since this constant is really the MTU with ethernet header size
subtracted.

Also fix the BNXT_MAX_PAGE_MODE_MTU macro with proper parentheses.

Fixes: 32861236190b ("bnxt: change receive ring space parameters")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  9 +++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 15 +++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  7 +------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a83d534a096a..b0c9c9813d23 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -988,8 +988,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
-	skb = build_skb(page_address(page), BNXT_PAGE_MODE_BUF_SIZE +
-					    bp->rx_dma_offset);
+	skb = build_skb(page_address(page), PAGE_SIZE);
 	if (!skb) {
 		__free_page(page);
 		return NULL;
@@ -3966,8 +3965,10 @@ void bnxt_set_ring_params(struct bnxt *bp)
 		bp->rx_agg_ring_mask = (bp->rx_agg_nr_pages * RX_DESC_CNT) - 1;
 
 		if (BNXT_RX_PAGE_MODE(bp)) {
-			rx_space = BNXT_PAGE_MODE_BUF_SIZE;
-			rx_size = BNXT_MAX_PAGE_MODE_MTU;
+			rx_space = PAGE_SIZE;
+			rx_size = PAGE_SIZE -
+				  ALIGN(max(NET_SKB_PAD, XDP_PACKET_HEADROOM), 8) -
+				  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		} else {
 			rx_size = SKB_DATA_ALIGN(BNXT_RX_COPY_THRESH + NET_IP_ALIGN);
 			rx_space = rx_size + NET_SKB_PAD +
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d5fa43cfe524..02741d499bf4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -591,12 +591,20 @@ struct nqe_cn {
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
 
 #define BNXT_MAX_MTU		9500
-#define BNXT_PAGE_MODE_BUF_SIZE \
+
+/* First RX buffer page in XDP multi-buf mode
+ *
+ * +-------------------------------------------------------------------------+
+ * | XDP_PACKET_HEADROOM | bp->rx_buf_use_size              | skb_shared_info|
+ * | (bp->rx_dma_offset) |                                  |                |
+ * +-------------------------------------------------------------------------+
+ */
+#define BNXT_MAX_PAGE_MODE_MTU_SBUF \
 	((unsigned int)PAGE_SIZE - VLAN_ETH_HLEN - NET_IP_ALIGN -	\
 	 XDP_PACKET_HEADROOM)
 #define BNXT_MAX_PAGE_MODE_MTU	\
-	BNXT_PAGE_MODE_BUF_SIZE - \
-	SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info))
+	(BNXT_MAX_PAGE_MODE_MTU_SBUF - \
+	 SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info)))
 
 #define BNXT_MIN_PKT_SIZE	52
 
@@ -2131,7 +2139,6 @@ struct bnxt {
 #define BNXT_DUMP_CRASH		1
 
 	struct bpf_prog		*xdp_prog;
-	u8			xdp_has_frags;
 
 	struct bnxt_ptp_cfg	*ptp_cfg;
 	u8			ptp_all_rx_tstamp;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 2ceeaa818c1c..36d5202c0aee 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -193,9 +193,6 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	mapping = rx_buf->mapping - bp->rx_dma_offset;
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, len, bp->rx_dir);
 
-	if (bp->xdp_has_frags)
-		buflen = BNXT_PAGE_MODE_BUF_SIZE + offset;
-
 	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
 	xdp_prepare_buff(xdp, data_ptr - offset, offset, len, false);
 }
@@ -404,10 +401,8 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
 		return -EOPNOTSUPP;
 	}
-	if (prog) {
+	if (prog)
 		tx_xdp = bp->rx_nr_rings;
-		bp->xdp_has_frags = prog->aux->xdp_has_frags;
-	}
 
 	tc = netdev_get_num_tc(dev);
 	if (!tc)
-- 
2.35.1



