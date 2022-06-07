Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD1E541C64
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382823AbiFGV7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382814AbiFGVv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97635192269;
        Tue,  7 Jun 2022 12:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF53B823B1;
        Tue,  7 Jun 2022 19:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5147BC385A5;
        Tue,  7 Jun 2022 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628978;
        bh=7JNySWG9G7almkc45VVzVriFrHF3dyFSg50wqEO2dSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehjKjeiIAH45gaBW9/rCgf8JhvUDR1VSGx5M7HmHsjZtPALgThTHI4HPXs+OrlqOl
         2CnTckDEB5Hj9PO5O5GV5akNY0GKgxvE0XdDAlsjYuQaOpHiPzz3jDbH/EaJVAH9M5
         s5+5SxrQF0hA7/0LDv6a6tpuKkj84+0EyHFt0cBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 525/879] dpaa2-eth: unmap the SGT buffer before accessing its contents
Date:   Tue,  7 Jun 2022 19:00:43 +0200
Message-Id: <20220607165018.113810611@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 0a09c5b8cb8f75344da7d90c771b84f7cdeaea04 ]

DMA unmap the Scatter/Gather table before going through the array to
unmap and free each of the header and data chunks. This is so we do not
touch the data between the dma_map and dma_unmap calls.

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f1f140277184..cd9ec80522e7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1136,6 +1136,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 			sgt = (struct dpaa2_sg_entry *)(buffer_start +
 							priv->tx_data_offset);
 
+			/* Unmap the SGT buffer */
+			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
+					 DMA_BIDIRECTIONAL);
+
 			/* Unmap and free the header */
 			tso_hdr = dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt));
 			dma_unmap_single(dev, dpaa2_sg_get_addr(sgt), TSO_HEADER_SIZE,
@@ -1147,10 +1151,6 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 				dma_unmap_single(dev, dpaa2_sg_get_addr(&sgt[i]),
 						 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
 
-			/* Unmap the SGT buffer */
-			dma_unmap_single(dev, fd_addr, swa->tso.sgt_size,
-					 DMA_BIDIRECTIONAL);
-
 			if (!swa->tso.is_last_fd)
 				should_free_skb = 0;
 		} else {
-- 
2.35.1



