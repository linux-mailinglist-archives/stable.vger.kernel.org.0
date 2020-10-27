Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7DC29B712
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902103AbgJ0P27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798208AbgJ0P0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB68D2064B;
        Tue, 27 Oct 2020 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812393;
        bh=0JBJlYcToSashEDa/XPQcIeVUKG24V/lqTNQKTNvfs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHMplscv3RDXc9NYb+a+WIoOyJnaE7eta8kUbMqyLKzmBu1Fn1gcs++3wiGU2Pvgj
         yDDkug61su5bNjFdyf2p+rwOtJMTLODz0mTVB94MCAhoXPJD9XGWqORKl5/J8Vs4rg
         EOImxruN2N0vEro4CBbNgLrerQ244+InE9COB5bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 193/757] wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680
Date:   Tue, 27 Oct 2020 14:47:23 +0100
Message-Id: <20201027135459.664947215@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 3b9fb6791e7113679b1eb472e6ce1659e80f5797 ]

Qualcomm's document "80-WL007-1 Rev. J" states that the highest rx rate for
the WCN3660 and WCN3680 on MCS 7 is 150 Mbps not the 72 Mbps stated here.

This patch fixes the data-rate declared in the 5GHz table.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
hardware")

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200802004824.1307124-1-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 702b689c06df3..f3ea629764fa8 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -163,7 +163,7 @@ static struct ieee80211_supported_band wcn_band_5ghz = {
 		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 		.mcs = {
 			.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
-			.rx_highest = cpu_to_le16(72),
+			.rx_highest = cpu_to_le16(150),
 			.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
 		}
 	}
-- 
2.25.1



