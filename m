Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AC3CAA79
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbhGOTNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242580AbhGOTLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12515610C7;
        Thu, 15 Jul 2021 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376096;
        bh=MK168te3q4xrxilY5WfCGkfKnWLr9gBCl6UPtSuKADI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0jpXUnP0T/7YXFQUEY6fFl5n0ROSG7qyaUiXK7CF5qOwKOCy+ReZ4AtQ7lnQKY+C
         CjpeytN+u4pLhLm/uHmpQ3Or01K4/M+n6zXgOtOcJAxqf+1hcnMeRIb9hNeob1OR/m
         Os1qI4oLevEA3tLu6xy9uXOD/h7TyfYBRbfUjIlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 126/266] mt76: connac: fix the maximum interval schedule scan can support
Date:   Thu, 15 Jul 2021 20:38:01 +0200
Message-Id: <20210715182636.168023283@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit abded041a07467c2f3dfe10afd9ea10572c63cc9 ]

Maximum interval (in seconds) for schedule scan plan supported by
the offload firmware can be U16_MAX.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c     | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index d20f05a7717d..0d01fd3c77b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -362,7 +362,7 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	wiphy->reg_notifier = mt7615_regd_notifier;
 
 	wiphy->max_sched_scan_plan_interval =
-		MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL;
+		MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL;
 	wiphy->max_sched_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_sched_scan_ssids = MT76_CONNAC_MAX_SCHED_SCAN_SSID;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
index c26cfef425ed..75223b6e1c87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -7,7 +7,8 @@
 #include "mt76.h"
 
 #define MT76_CONNAC_SCAN_IE_LEN			600
-#define MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL	10
+#define MT76_CONNAC_MAX_NUM_SCHED_SCAN_INTERVAL	 10
+#define MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL U16_MAX
 #define MT76_CONNAC_MAX_SCHED_SCAN_SSID		10
 #define MT76_CONNAC_MAX_SCAN_MATCH		16
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0450d8c1c181..facebed1e301 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -770,7 +770,7 @@ struct mt76_connac_sched_scan_req {
 	u8 intervals_num;
 	u8 scan_func; /* MT7663: BIT(0) eable random mac address */
 	struct mt76_connac_mcu_scan_channel channels[64];
-	__le16 intervals[MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL];
+	__le16 intervals[MT76_CONNAC_MAX_NUM_SCHED_SCAN_INTERVAL];
 	union {
 		struct {
 			u8 random_mac[ETH_ALEN];
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 2cb0252e63b2..db7e436076b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -93,7 +93,7 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_sched_scan_plan_interval =
-		MT76_CONNAC_MAX_SCHED_SCAN_INTERVAL;
+		MT76_CONNAC_MAX_TIME_SCHED_SCAN_INTERVAL;
 	wiphy->max_sched_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 	wiphy->max_sched_scan_ssids = MT76_CONNAC_MAX_SCHED_SCAN_SSID;
 	wiphy->max_match_sets = MT76_CONNAC_MAX_SCAN_MATCH;
-- 
2.30.2



