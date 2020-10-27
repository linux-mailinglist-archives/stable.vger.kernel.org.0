Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3428629B822
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797010AbgJ0PcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799584AbgJ0PcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA29320728;
        Tue, 27 Oct 2020 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812735;
        bh=1ObmjkWDMCeEt0kyPQ7yIVa7gmllwV9YT5qSow79xC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHqoF/S3zHHX14b0zsIze9Z/cXqmdmuhs8gavQqKwQ25simhzAJzbuH3t9Aml+Wom
         qEbkuYgp67ThNEa6Tx7df3lO7Z2oHi6V36c63zu7afxBiff+3yEUftf8kj/krTViM5
         mIemaBaGxXxHqfZ0hKhKe1nizSe7ZGFUe+pfJJyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 282/757] dmaengine: ti: k3-udma-glue: fix channel enable functions
Date:   Tue, 27 Oct 2020 14:48:52 +0100
Message-Id: <20201027135503.806351312@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 52c74d3d356b60f3c53dc69e5109752347e144e8 ]

Now the K3 UDMA glue layer enable functions perform RMW operation on UDMA
RX/TX RT_CTL registers to set EN bit and enable channel, which is
incorrect, because only EN bit has to be set in those registers to enable
channel (all other bits should be cleared 0).
More over, this causes issues when bootloader leaves UDMA channel RX/TX
RT_CTL registers in incorrect state - TDOWN bit set, for example. As
result, UDMA channel will just perform teardown right after it's enabled.

Hence, fix it by writing correct values (EN=1) directly in UDMA channel
RX/TX RT_CTL registers in k3_udma_glue_enable_tx/rx_chn() functions.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20200916120955.7963-1-grygorii.strashko@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-glue.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index 3a5d33ea5ebe7..42c8ad10d75eb 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -378,17 +378,11 @@ EXPORT_SYMBOL_GPL(k3_udma_glue_pop_tx_chn);
 
 int k3_udma_glue_enable_tx_chn(struct k3_udma_glue_tx_channel *tx_chn)
 {
-	u32 txrt_ctl;
-
-	txrt_ctl = UDMA_PEER_RT_EN_ENABLE;
 	xudma_tchanrt_write(tx_chn->udma_tchanx, UDMA_CHAN_RT_PEER_RT_EN_REG,
-			    txrt_ctl);
+			    UDMA_PEER_RT_EN_ENABLE);
 
-	txrt_ctl = xudma_tchanrt_read(tx_chn->udma_tchanx,
-				      UDMA_CHAN_RT_CTL_REG);
-	txrt_ctl |= UDMA_CHAN_RT_CTL_EN;
 	xudma_tchanrt_write(tx_chn->udma_tchanx, UDMA_CHAN_RT_CTL_REG,
-			    txrt_ctl);
+			    UDMA_CHAN_RT_CTL_EN);
 
 	k3_udma_glue_dump_tx_rt_chn(tx_chn, "txchn en");
 	return 0;
@@ -1058,19 +1052,14 @@ EXPORT_SYMBOL_GPL(k3_udma_glue_rx_flow_disable);
 
 int k3_udma_glue_enable_rx_chn(struct k3_udma_glue_rx_channel *rx_chn)
 {
-	u32 rxrt_ctl;
-
 	if (rx_chn->remote)
 		return -EINVAL;
 
 	if (rx_chn->flows_ready < rx_chn->flow_num)
 		return -EINVAL;
 
-	rxrt_ctl = xudma_rchanrt_read(rx_chn->udma_rchanx,
-				      UDMA_CHAN_RT_CTL_REG);
-	rxrt_ctl |= UDMA_CHAN_RT_CTL_EN;
 	xudma_rchanrt_write(rx_chn->udma_rchanx, UDMA_CHAN_RT_CTL_REG,
-			    rxrt_ctl);
+			    UDMA_CHAN_RT_CTL_EN);
 
 	xudma_rchanrt_write(rx_chn->udma_rchanx, UDMA_CHAN_RT_PEER_RT_EN_REG,
 			    UDMA_PEER_RT_EN_ENABLE);
-- 
2.25.1



