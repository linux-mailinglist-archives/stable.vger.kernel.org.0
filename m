Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C457D451F51
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356045AbhKPAiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344001AbhKOTXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4C863312;
        Mon, 15 Nov 2021 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002194;
        bh=Qeyx0YVCwR6rX9/M5y0c+7zqXyGyt5uNMJFJMWFWJmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax1I04qIAbHtMU/tjSB2hLVNQrLIsN9F20XAKG0m3H6wUW9tZvQ+jpQui5xM+22go
         f0xJnVXf/W9Vvgi7+xPWqMuJFb6UzfojXhFkBZBMdR4ao+zVOZUwnbtdupsWLyoMAA
         EKueXt36q1Tt0v6ywWaFXwVuwGY05Ea9wdStqHeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Emele <jemele@chromium.org>,
        YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/917] mt76: mt7921: fix firmware usage of RA info using legacy rates
Date:   Mon, 15 Nov 2021 17:59:28 +0100
Message-Id: <20211115165444.820081709@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 99b8e195994d9d77de3bfe0cb403c44a57c2cf79 ]

According to the firmware usage, OFDM rates should fill out bit 6 - 13
while CCK rates should fill out bit 0 - 3 in legacy field of RA info to
make the rate adaption runs propertly. Otherwise, a unicast frame might be
picking up the unsupported rate to send out.

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Reported-by: Joshua Emele <jemele@chromium.org>
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 11 ++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index f57f047fce99c..98d233e24afcc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -719,6 +719,7 @@ void mt76_connac_mcu_sta_tlv(struct mt76_phy *mphy, struct sk_buff *skb,
 	struct sta_rec_state *state;
 	struct sta_rec_phy *phy;
 	struct tlv *tlv;
+	u16 supp_rates;
 
 	/* starec ht */
 	if (sta->ht_cap.ht_supported) {
@@ -767,7 +768,15 @@ void mt76_connac_mcu_sta_tlv(struct mt76_phy *mphy, struct sk_buff *skb,
 
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_RA, sizeof(*ra_info));
 	ra_info = (struct sta_rec_ra_info *)tlv;
-	ra_info->legacy = cpu_to_le16((u16)sta->supp_rates[band]);
+
+	supp_rates = sta->supp_rates[band];
+	if (band == NL80211_BAND_2GHZ)
+		supp_rates = FIELD_PREP(RA_LEGACY_OFDM, supp_rates >> 4) |
+			     FIELD_PREP(RA_LEGACY_CCK, supp_rates & 0xf);
+	else
+		supp_rates = FIELD_PREP(RA_LEGACY_OFDM, supp_rates);
+
+	ra_info->legacy = cpu_to_le16(supp_rates);
 
 	if (sta->ht_cap.ht_supported)
 		memcpy(ra_info->rx_mcs_bitmask, sta->ht_cap.mcs.rx_mask,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 4bcd728ff97c5..77d4435e4581e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -124,6 +124,8 @@ struct sta_rec_state {
 	u8 rsv[1];
 } __packed;
 
+#define RA_LEGACY_OFDM GENMASK(13, 6)
+#define RA_LEGACY_CCK  GENMASK(3, 0)
 #define HT_MCS_MASK_NUM 10
 struct sta_rec_ra_info {
 	__le16 tag;
-- 
2.33.0



