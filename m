Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB5548638
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378539AbiFMNlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379206AbiFMNkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4D2B1E3;
        Mon, 13 Jun 2022 04:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A65561236;
        Mon, 13 Jun 2022 11:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25641C34114;
        Mon, 13 Jun 2022 11:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119799;
        bh=CKRcIDez5WDOdUkkMq0cmBGtJrYGSVOmbu328DuMck0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd2qknklA0RAG8gQp/W7KbE/KXsT5HBfwmRbyp7EPvaxeSEK1fZ51ilQva1G0TdRU
         SABRaYfOfkGo3u86nFu0aeXJtDSvwDUdwVLZHZ66mnKkR4GgsNlrWCmeY3478ygH3J
         lG5At3NrOJsGMpBLUP+Bp1VI9xauvg1uJR6Sw2Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fei Qin <fei.qin@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 144/339] nfp: remove padding in nfp_nfdk_tx_desc
Date:   Mon, 13 Jun 2022 12:09:29 +0200
Message-Id: <20220613094931.051031539@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

[ Upstream commit c6fbbf1eae8f35e10966826960e154c9596c86dc ]

NFDK firmware supports 48-bit dma addressing and
parses 16 high bits of dma addresses.

In nfp_nfdk_tx_desc, dma related structure and tso
related structure are union. When "mss" be filled
with nonzero value due to enable tso, the memory used
by "padding" may be also filled. Then, firmware may
parse wrong dma addresses which causes TX watchdog
timeout problem.

This patch removes padding and unifies the dma_addr_hi
bits with the one in firmware. nfp_nfdk_tx_desc_set_dma_addr
is also added to match this change.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220601083449.50556-1-simon.horman@corigine.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c   | 12 ++++++------
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h |  3 +--
 drivers/net/ethernet/netronome/nfp/nfp_net.h   | 11 ++++++++++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index e3da9ac20e57..e509d6dcba5c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -314,7 +314,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	/* starts at bit 0 */
 	BUILD_BUG_ON(!(NFDK_DESC_TX_DMA_LEN_HEAD & 1));
@@ -339,7 +339,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 			dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 
 			txd->dma_len_type = cpu_to_le16(dlen_type);
-			nfp_desc_set_dma_addr(txd, dma_addr);
+			nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 			dma_len -= dlen_type;
 			dma_addr += dlen_type + 1;
@@ -929,7 +929,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -940,7 +940,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_desc_set_dma_addr(txd, dma_addr);
+		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
@@ -1332,7 +1332,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -1343,7 +1343,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_desc_set_dma_addr(txd, dma_addr);
+		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index c41e0975eb73..0ea51d9f2325 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -46,8 +46,7 @@
 struct nfp_nfdk_tx_desc {
 	union {
 		struct {
-			u8 dma_addr_hi;  /* High bits of host buf address */
-			u8 padding;  /* Must be zero */
+			__le16 dma_addr_hi;  /* High bits of host buf address */
 			__le16 dma_len_type; /* Length to DMA for this desc */
 			__le32 dma_addr_lo;  /* Low 32bit of host buf addr */
 		};
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 428783b7018b..3dd3a92d2e7f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -117,13 +117,22 @@ struct nfp_nfdk_tx_buf;
 /* Convenience macro for writing dma address into RX/TX descriptors */
 #define nfp_desc_set_dma_addr(desc, dma_addr)				\
 	do {								\
-		__typeof(desc) __d = (desc);				\
+		__typeof__(desc) __d = (desc);				\
 		dma_addr_t __addr = (dma_addr);				\
 									\
 		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));	\
 		__d->dma_addr_hi = upper_32_bits(__addr) & 0xff;	\
 	} while (0)
 
+#define nfp_nfdk_tx_desc_set_dma_addr(desc, dma_addr)			       \
+	do {								       \
+		__typeof__(desc) __d = (desc);				       \
+		dma_addr_t __addr = (dma_addr);				       \
+									       \
+		__d->dma_addr_hi = cpu_to_le16(upper_32_bits(__addr) & 0xff);  \
+		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));         \
+	} while (0)
+
 /**
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
-- 
2.35.1



