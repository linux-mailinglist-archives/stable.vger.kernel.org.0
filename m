Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4703C4E3F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbhGLHRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243642AbhGLHQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE25613F3;
        Mon, 12 Jul 2021 07:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074031;
        bh=XC0RsIs1IJE42Vnic8o5wWM3MoxhreVSeEoEpbO35tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPu7wcG50fIVdZ+ewtTQorPVs7z9ea/VhQPgXpVkxwTuyUrnrsQ7Juz4ge5V300xg
         pI25NqEmOKGQXGnYPvI07hFapGMWbF9a2DWKCTIgYcWYADvcGNGY9x9QK0iNRzBAWR
         HNbRjqxR7BzVZn8TCJ3On//XowAXhqvpnlCXCJho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <yn.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 439/700] mt76: mt7921: fix OMAC idx usage
Date:   Mon, 12 Jul 2021 08:08:42 +0200
Message-Id: <20210712061023.190351237@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 213f87289ea01514acdbfeed9f65bcb5f12aef70 ]

OMAC idx have to be same with BSS idx according to firmware usage.

Fixes: e0f9fdda81bd ("mt76: mt7921: add ieee80211_ops")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 55 +------------------
 1 file changed, 1 insertion(+), 54 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 05ba9cdffb1a..1894ca6324d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -223,54 +223,6 @@ static void mt7921_stop(struct ieee80211_hw *hw)
 	mt7921_mutex_release(dev);
 }
 
-static inline int get_free_idx(u32 mask, u8 start, u8 end)
-{
-	return ffs(~mask & GENMASK(end, start));
-}
-
-static int get_omac_idx(enum nl80211_iftype type, u64 mask)
-{
-	int i;
-
-	switch (type) {
-	case NL80211_IFTYPE_STATION:
-		/* prefer hw bssid slot 1-3 */
-		i = get_free_idx(mask, HW_BSSID_1, HW_BSSID_3);
-		if (i)
-			return i - 1;
-
-		/* next, try to find a free repeater entry for the sta */
-		i = get_free_idx(mask >> REPEATER_BSSID_START, 0,
-				 REPEATER_BSSID_MAX - REPEATER_BSSID_START);
-		if (i)
-			return i + 32 - 1;
-
-		i = get_free_idx(mask, EXT_BSSID_1, EXT_BSSID_MAX);
-		if (i)
-			return i - 1;
-
-		if (~mask & BIT(HW_BSSID_0))
-			return HW_BSSID_0;
-
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		/* ap uses hw bssid 0 and ext bssid */
-		if (~mask & BIT(HW_BSSID_0))
-			return HW_BSSID_0;
-
-		i = get_free_idx(mask, EXT_BSSID_1, EXT_BSSID_MAX);
-		if (i)
-			return i - 1;
-
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	return -1;
-}
-
 static int mt7921_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif)
 {
@@ -292,12 +244,7 @@ static int mt7921_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	idx = get_omac_idx(vif->type, phy->omac_mask);
-	if (idx < 0) {
-		ret = -ENOSPC;
-		goto out;
-	}
-	mvif->mt76.omac_idx = idx;
+	mvif->mt76.omac_idx = mvif->mt76.idx;
 	mvif->phy = phy;
 	mvif->mt76.band_idx = 0;
 	mvif->mt76.wmm_idx = mvif->mt76.idx % MT7921_MAX_WMM_SETS;
-- 
2.30.2



