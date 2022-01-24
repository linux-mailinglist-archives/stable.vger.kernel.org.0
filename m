Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDF498F17
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244929AbiAXTuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:50:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33954 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355765AbiAXTnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:43:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0A85B811F3;
        Mon, 24 Jan 2022 19:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB43C340E5;
        Mon, 24 Jan 2022 19:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053418;
        bh=UO5roCH2zYZALs8rtmhmOHSCw7I+ibAjMZTVl8sl7RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqgrLfkLNZpQwpqjjZM4Pw4Sjyyxi62VA4XwUicpoowGk/776pC6Y2wAZEZh8pcmQ
         QqOmPUvBiq9iUtSIleu3TB6pQh0UKG8BQoSytzK3SW68Yck3Xefg6ug4VVgDOQwxAy
         aG7y1eSD9WaVVkeFqQPoCA61rINyYHGxixxa5Ox4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/563] wcn36xx: Release DMA channel descriptor allocations
Date:   Mon, 24 Jan 2022 19:37:03 +0100
Message-Id: <20220124184026.419341918@linuxfoundation.org>
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
index 0909d0c423cbb..b117d8a0f446f 100644
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



