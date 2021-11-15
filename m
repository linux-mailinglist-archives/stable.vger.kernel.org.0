Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A77045137F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348311AbhKOTwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343641AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E679E63371;
        Mon, 15 Nov 2021 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001823;
        bh=1k0gv9Wcor99mfqtxXAZwav4mIHUEoA90z9MjLacn/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eij+Ioq62rn74RZzTchwstf7WZJzAvcuJXF/aIDxsnZEpv4xmMhSfFTSUPyAR/O9q
         SieNDdcOzI2k1wrlZpTQfikez6AXdwDB2lkNkhzyoG1i3H/VRWMY6HlfrCV5Q4RIXL
         wlrIrdYcLGB3KdlrLjP4NKuld1ZWNhY9cDgmJs6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/917] Revert "wcn36xx: Enable firmware link monitoring"
Date:   Mon, 15 Nov 2021 17:56:42 +0100
Message-Id: <20211115165439.168472317@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 43ea9bd84f27d06482cc823d9749cc9dd2993bc8 ]

Firmware link offload monitoring can be made to work in 3/4 cases by
switching on firmware feature bit WLANACTIVE_OFFLOAD

- Secure power-save on
- Secure power-save off
- Open power-save on

However, with an open AP if we switch off power-saving - thus never
entering Beacon Mode Power Save - BMPS, firmware never forwards loss
of beacon upwards.

We had hoped that WLANACTIVE_OFFLOAD and some fixes for sequence numbers
would unblock this but, it hasn't and further investigation is required.

Its possible to have a complete set of Secure power-save on/off and Open
power-save on/off provided we use Linux' link monitoring mechanism.

While we debug the Open AP failure we need to fix upstream.

This reverts commit c973fdad79f6eaf247d48b5fc77733e989eb01e1.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211025093037.3966022-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 39d86e3031bd7..28d6251ad77a6 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1341,7 +1341,6 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 	ieee80211_hw_set(wcn->hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(wcn->hw, SINGLE_SCAN_ON_ALL_BANDS);
 	ieee80211_hw_set(wcn->hw, REPORTS_TX_ACK_STATUS);
-	ieee80211_hw_set(wcn->hw, CONNECTION_MONITOR);
 
 	wcn->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_AP) |
-- 
2.33.0



