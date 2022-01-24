Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF249922D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349322AbiAXURx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41546 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355694AbiAXUOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:14:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A0E6091A;
        Mon, 24 Jan 2022 20:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05341C340E7;
        Mon, 24 Jan 2022 20:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055279;
        bh=87EGaLCvwwvOqdzfY5gZL3MVLBoAuuQp2zJygvRpI54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCn8ceXirsgetcJY+Q2ppnUjlY5Zp+UExLD6dUT/9Poz+ujoo4e1qAPxfsS1vZ8/u
         P+8RlUU8jzoWclIhuaOpy5MSvdzalvH9lamVV1C8ECWZ+/D3Sxje/QcgoTsjkVJbW9
         SfZxNraw4wJevmU+eXTDmuu6oE4gBhXcsAoHn0R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/846] wcn36xx: Fix DMA channel enable/disable cycle
Date:   Mon, 24 Jan 2022 19:33:36 +0100
Message-Id: <20220124184104.406710679@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 89dcb1da611d9b3ff0728502d58372fdaae9ebff ]

Right now we have a broken sequence where we enable DMA channel interrupts
which can be left enabled and never disabled if we hit an error path.

Worse still when we unload the driver, the DMA channel interrupt bits are
left intact. About the only saving grace here is that we do remember to
disable the wcnss interrupt when unload the driver.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211105122152.1580542-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 38 ++++++++++++++++++--------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index aff04ef662663..0c4f63f1312f8 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -272,6 +272,21 @@ static int wcn36xx_dxe_enable_ch_int(struct wcn36xx *wcn, u16 wcn_ch)
 	return 0;
 }
 
+static void wcn36xx_dxe_disable_ch_int(struct wcn36xx *wcn, u16 wcn_ch)
+{
+	int reg_data = 0;
+
+	wcn36xx_dxe_read_register(wcn,
+				  WCN36XX_DXE_INT_MASK_REG,
+				  &reg_data);
+
+	reg_data &= ~wcn_ch;
+
+	wcn36xx_dxe_write_register(wcn,
+				   WCN36XX_DXE_INT_MASK_REG,
+				   (int)reg_data);
+}
+
 static int wcn36xx_dxe_fill_skb(struct device *dev,
 				struct wcn36xx_dxe_ctl *ctl,
 				gfp_t gfp)
@@ -869,7 +884,6 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 		WCN36XX_DXE_WQ_TX_L);
 
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
-	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_L);
 
 	/***************************************/
 	/* Init descriptors for TX HIGH channel */
@@ -893,9 +907,6 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
 
-	/* Enable channel interrupts */
-	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_H);
-
 	/***************************************/
 	/* Init descriptors for RX LOW channel */
 	/***************************************/
@@ -905,7 +916,6 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 		goto out_err_rxl_ch;
 	}
 
-
 	/* For RX we need to preallocated buffers */
 	wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_l_ch);
 
@@ -928,9 +938,6 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 		WCN36XX_DXE_REG_CTL_RX_L,
 		WCN36XX_DXE_CH_DEFAULT_CTL_RX_L);
 
-	/* Enable channel interrupts */
-	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_L);
-
 	/***************************************/
 	/* Init descriptors for RX HIGH channel */
 	/***************************************/
@@ -962,15 +969,18 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 		WCN36XX_DXE_REG_CTL_RX_H,
 		WCN36XX_DXE_CH_DEFAULT_CTL_RX_H);
 
-	/* Enable channel interrupts */
-	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_H);
-
 	ret = wcn36xx_dxe_request_irqs(wcn);
 	if (ret < 0)
 		goto out_err_irq;
 
 	timer_setup(&wcn->tx_ack_timer, wcn36xx_dxe_tx_timer, 0);
 
+	/* Enable channel interrupts */
+	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_L);
+	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_H);
+	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_L);
+	wcn36xx_dxe_enable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_H);
+
 	return 0;
 
 out_err_irq:
@@ -987,6 +997,12 @@ out_err_txh_ch:
 
 void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 {
+	/* Disable channel interrupts */
+	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_H);
+	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_L);
+	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_H);
+	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_TX_L);
+
 	free_irq(wcn->tx_irq, wcn);
 	free_irq(wcn->rx_irq, wcn);
 	del_timer(&wcn->tx_ack_timer);
-- 
2.34.1



