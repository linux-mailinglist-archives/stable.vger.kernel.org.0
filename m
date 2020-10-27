Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25D529B1B7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898265AbgJ0Od0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902446AbgJ0OdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6181620773;
        Tue, 27 Oct 2020 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809203;
        bh=Tr6N2IkCJMlc0AaWaok7/YXeLhLpRWTy4bPbYc1K5Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLCWw/aN5LWAjit/PhFt67wOeu2hECxTI8inYVTgCHb6jKQs9fbd1rKR00uu6kVkt
         OgVKiOl+EI5UKR+l+Qn/PnFy4l9ONYe/O1+8Psek4RHxpQ+Rx2GsKuHW9R35TgsRGd
         6IeGIU77OE//gA2LQYCKgdoMAFIHXbW9DW5UL92o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/408] wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680
Date:   Tue, 27 Oct 2020 14:50:49 +0100
Message-Id: <20201027135500.244957361@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index ad051f34e65b2..46ae4ec4ad47d 100644
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



