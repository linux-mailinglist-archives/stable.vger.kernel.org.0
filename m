Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB623498BCC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiAXTQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:16:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43854 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346734AbiAXTO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:14:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4631D60909;
        Mon, 24 Jan 2022 19:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125A4C340E5;
        Mon, 24 Jan 2022 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051667;
        bh=d23pXWXux0b/sd/FDTFAvhlEPzSEJl7kdCJKVQtmT4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bupGS98cprj20EDkHsJ9BIk7u05Cgi0EyP+V24EXQZLOZFGd5CeaTUMdj+EnYSo3f
         ++YtFKttyEMMrU3xfcB8AYAAx3KyWrSZ/hlLd3R7mqUbFuRomUVxc167fhzoBqrb6C
         c0zvrg+zVn6DLvbhgOcDJEKUNUrOnp46CG3UoZ74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/239] wcn36xx: Release DMA channel descriptor allocations
Date:   Mon, 24 Jan 2022 19:41:27 +0100
Message-Id: <20220124183944.697627697@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 3652096e5263ad67604b0323f71d133485f410e5 ]

When unloading the driver we are not releasing the DMA descriptors which we
previously allocated.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211105122152.1580542-3-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 657525988d1ee..38eef1579db2d 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -954,4 +954,9 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
 	wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_l_ch);
 	wcn36xx_dxe_ch_free_skbs(wcn, &wcn->dxe_rx_h_ch);
+
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_tx_l_ch);
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_tx_h_ch);
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_rx_l_ch);
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_rx_h_ch);
 }
-- 
2.34.1



