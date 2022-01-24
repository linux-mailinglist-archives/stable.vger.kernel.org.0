Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17601499F9C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841822AbiAXXAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835115AbiAXWfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:35:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBEAC097FB7;
        Mon, 24 Jan 2022 12:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDAAC61323;
        Mon, 24 Jan 2022 20:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B432CC340E5;
        Mon, 24 Jan 2022 20:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057890;
        bh=Y3/oFE/QPkDB9XzitazqTYGIxNmsbbIZuW60fHLZWPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H19cGVXO6mot1dtSql1EZVt9Tb1k2fCva0iePIA2DGusrVn2MUDLrd6aQ3dqyo04h
         DSvYQtzrHGEcWm/BkK8LO97Q1H9RZl8oIxX5Pa/ZsXui20ycSKc9D3MfoVujx8PQSe
         C8XmCJO501dPZKSrvBLxt2IrC3x1kzcQtaQpmmGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0112/1039] wcn36xx: Release DMA channel descriptor allocations
Date:   Mon, 24 Jan 2022 19:31:41 +0100
Message-Id: <20220124184128.898293990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 0c4f63f1312f8..017c7d78072ba 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -1014,4 +1014,9 @@ void wcn36xx_dxe_deinit(struct wcn36xx *wcn)
 
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



