Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397F53CA8A4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243325AbhGOTB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240761AbhGOTBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F47613F9;
        Thu, 15 Jul 2021 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375482;
        bh=PYndkoxT8VJSQCBBjAEcCYBPObdOP0m3A43bg4uEqJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEUVaqtkvH2D8yqpk2j+/ny/1gKjPGFb/+HS/qcDYLEPaKs/ll9U2g03JKfIJegl9
         2YX0G0+J65DO27gNnprG1yn7E48rzoIuMRR1GTGGTYzO3y8HXCmcLaGOqG3KtGnu/R
         bij60WKAxAMxMJTB1DF24KLgOapdlexx4aYr2eN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 105/242] mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode
Date:   Thu, 15 Jul 2021 20:37:47 +0200
Message-Id: <20210715182611.509246996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 2707ff4dd7b1479dbd44ebb3c74788084cc95245 ]

The value of station mode is always 0.

Fixed: 00b2e16e0063 ("mt76: mt7915: add TxBF capabilities")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index c7d4268d860a..5ab34606c021 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -452,6 +452,9 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
 	if (nss < 2)
 		return;
 
+	/* the maximum cap is 4 x 3, (Nr, Nc) = (3, 2) */
+	elem->phy_cap_info[7] |= min_t(int, nss - 1, 2) << 3;
+
 	if (vif != NL80211_IFTYPE_AP)
 		return;
 
@@ -465,9 +468,6 @@ mt7915_set_stream_he_txbf_caps(struct ieee80211_sta_he_cap *he_cap,
 	c = IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMER_FB |
 	    IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMER_FB;
 	elem->phy_cap_info[6] |= c;
-
-	/* the maximum cap is 4 x 3, (Nr, Nc) = (3, 2) */
-	elem->phy_cap_info[7] |= min_t(int, nss - 1, 2) << 3;
 }
 
 static void
-- 
2.30.2



