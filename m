Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578BF29BFB5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816452AbgJ0RGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1787338AbgJ0PAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A05220714;
        Tue, 27 Oct 2020 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810801;
        bh=u0wQe6TgDCj75T6Wk00+nF4tb2AYYeLSD64yFhQleIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1hzEnLjFX6udo7oTppYfe2uyu06gTgBnnOhIRm7aX47AoN5vF3TtKU1ZQiHFcRdI
         k0IHethIASkba2DotRA3jzSuXMz407IjCtsRwrqRyXRPnE5ehp0EFMea5bXPXMx78h
         sbROoxjzOW/NsRLnvOAT5RkvoFFRzXw6AKy1nYTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 268/633] mt76: mt7915: fix possible memory leak in mt7915_mcu_add_beacon
Date:   Tue, 27 Oct 2020 14:50:11 +0100
Message-Id: <20201027135535.240054202@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 071c8ce8e92a86b8bf78678e78eb4b79fdc16768 ]

Release mcu message memory in case of failure in mt7915_mcu_add_beacon
routine

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 8fb8255650a7e..6969579e6b1dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2267,14 +2267,6 @@ int mt7915_mcu_add_beacon(struct ieee80211_hw *hw,
 	struct bss_info_bcn *bcn;
 	int len = MT7915_BEACON_UPDATE_SIZE + MAX_BEACON_SIZE;
 
-	rskb = mt7915_mcu_alloc_sta_req(dev, mvif, NULL, len);
-	if (IS_ERR(rskb))
-		return PTR_ERR(rskb);
-
-	tlv = mt7915_mcu_add_tlv(rskb, BSS_INFO_OFFLOAD, sizeof(*bcn));
-	bcn = (struct bss_info_bcn *)tlv;
-	bcn->enable = en;
-
 	skb = ieee80211_beacon_get_template(hw, vif, &offs);
 	if (!skb)
 		return -EINVAL;
@@ -2285,6 +2277,16 @@ int mt7915_mcu_add_beacon(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
+	rskb = mt7915_mcu_alloc_sta_req(dev, mvif, NULL, len);
+	if (IS_ERR(rskb)) {
+		dev_kfree_skb(skb);
+		return PTR_ERR(rskb);
+	}
+
+	tlv = mt7915_mcu_add_tlv(rskb, BSS_INFO_OFFLOAD, sizeof(*bcn));
+	bcn = (struct bss_info_bcn *)tlv;
+	bcn->enable = en;
+
 	if (mvif->band_idx) {
 		info = IEEE80211_SKB_CB(skb);
 		info->hw_queue |= MT_TX_HW_QUEUE_EXT_PHY;
-- 
2.25.1



