Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF349A3D7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368890AbiAYAA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846542AbiAXXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97816C08B4F4;
        Mon, 24 Jan 2022 11:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351A06153E;
        Mon, 24 Jan 2022 19:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F54C340E5;
        Mon, 24 Jan 2022 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053421;
        bh=PkwYfJNj13eKaScjRBJkbBJh0gjPuH/Z/VPnCw8A9+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGPeIYh1FI07cNbIQNE81Hbx2VCTbLRYCX6lBs8uW+aL09KHqKyxlG1y7u2qHOxI7
         TuIuiDEuGUhiNhPSVWuXBqh9ZiHcJjT2rRW5Ef0akwsGugL4MMJYpVpGGBkJDpq/Vc
         vEAFp6J25oAsALLbhx5iRLuX13AW3i9ylnV1mLn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/563] wcn36xx: Put DXE block into reset before freeing memory
Date:   Mon, 24 Jan 2022 19:37:04 +0100
Message-Id: <20220124184026.455111306@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit ed04ea76e69e7194f7489cebe23a32a68f39218d ]

When deiniting the DXE hardware we should reset the block to ensure there
is no spurious DMA write transaction from the downstream WCNSS to upstream
MSM at a skbuff address we will have released.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211105122152.1580542-4-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index b117d8a0f446f..6c62ffc799a2b 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -997,6 +997,8 @@ out_err_txh_ch:
 
 void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 {
+	int reg_data = 0;
+
 	/* Disable channel interrupts */
 	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_H);
 	wcn36xx_dxe_disable_ch_int(wcn, WCN36XX_INT_MASK_CHAN_RX_L);
@@ -1012,6 +1014,10 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 		wcn->tx_ack_skb = NULL;
 	}
 
+	/* Put the DXE block into reset before freeing memory */
+	reg_data = WCN36XX_DXE_REG_RESET;
+	wcn36xx_dxe_write_register(wcn, WCN36XX_DXE_REG_CSR_RESET, reg_data);
+
 	wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_l_ch);
 	wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_h_ch);
 
-- 
2.34.1



