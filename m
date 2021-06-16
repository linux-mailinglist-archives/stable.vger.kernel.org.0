Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202D03A9FAF
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhFPPkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235011AbhFPPjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DC73613D8;
        Wed, 16 Jun 2021 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857807;
        bh=Vspvsrwq+HMh5zo2lywXb+v0OGmxGRWtwUajJD+vy9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsFEB5Q0DQVUfSS02javytq81vT3Vq/7r1cA1YJJdadHss1tkS6/nGU71jj7DrFuV
         95cg3mOhKi57Y/lpATut4uIlU9652NAMpmqeEU5nmGPmaGzXSW7cf0p+5LrJoAY/Fw
         v/Ju1q7T6iQzpvK5TPc90pzNR4WdsliaI7vL2hno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 13/48] mt76: mt7921: fix max aggregation subframes setting
Date:   Wed, 16 Jun 2021 17:33:23 +0200
Message-Id: <20210616152837.079530322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94bb18b03d43f32e9440e8e350b7f533137c40f6 ]

The hardware can only handle 64 subframes in rx direction and 128 for tx.
Improves throughput with APs that can handle more than that

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210507100211.15709-2-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 89a13b4a74a4..c0001e38fcce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -74,8 +74,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	struct wiphy *wiphy = hw->wiphy;
 
 	hw->queues = 4;
-	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
-	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	hw->max_rx_aggregation_subframes = 64;
+	hw->max_tx_aggregation_subframes = 128;
 
 	phy->slottime = 9;
 
-- 
2.30.2



