Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4F84F2A0C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbiDEJbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245197AbiDEIyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B461825F1;
        Tue,  5 Apr 2022 01:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 516AF614E5;
        Tue,  5 Apr 2022 08:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B66C385A1;
        Tue,  5 Apr 2022 08:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148714;
        bh=pgtCG7ooDhzvfMoixbXxXQ6K0MvWSPBRQdkNanPRTmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YimBAZTm5/L7D6RrEDGAKBgRCD4na5gn3tLipx7SSxFv7DFkK7+Xao8+GT5CFNNUF
         md0yloRPPMAqfBeM/pgMXgBhphhgDx9pHfTSd1nr2S+3tW1pRef7yAQb9hMX11HUWD
         j1s9DkFn7q5uc2oDIksfvTzQYbZ83g+l+l44pSso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0455/1017] mt76: mt7921: set EDCA parameters with the MCU CE command
Date:   Tue,  5 Apr 2022 09:22:48 +0200
Message-Id: <20220405070407.804539519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 66ca1a7b2d5503f561b751abdd6ec6fa96343eb6 ]

The command MCU_EXT_CMD_EDCA_UPDATE is not fully supported by the MT7921
firmware, so we apply CE command MCU_CE_CMD_SET_EDCA_PARAMS instead which
is supported even in the oldest firmware to properly set up EDCA parameters
for each AC.

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 49 ++++++++-----------
 2 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 63fc331e98bd..43a8b3651dc2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -599,6 +599,7 @@ enum {
 	MCU_CE_CMD_SET_BSS_ABORT = 0x17,
 	MCU_CE_CMD_CANCEL_HW_SCAN = 0x1b,
 	MCU_CE_CMD_SET_ROC = 0x1c,
+	MCU_CE_CMD_SET_EDCA_PARMS = 0x1d,
 	MCU_CE_CMD_SET_P2P_OPPPS = 0x33,
 	MCU_CE_CMD_SET_RATE_TX_POWER = 0x5d,
 	MCU_CE_CMD_SCHED_SCAN_ENABLE = 0x61,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 4c6adbb96955..50c953b08ed0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -912,33 +912,28 @@ EXPORT_SYMBOL_GPL(mt7921_mcu_exit);
 
 int mt7921_mcu_set_tx(struct mt7921_dev *dev, struct ieee80211_vif *vif)
 {
-#define WMM_AIFS_SET		BIT(0)
-#define WMM_CW_MIN_SET		BIT(1)
-#define WMM_CW_MAX_SET		BIT(2)
-#define WMM_TXOP_SET		BIT(3)
-#define WMM_PARAM_SET		GENMASK(3, 0)
-#define TX_CMD_MODE		1
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+
 	struct edca {
-		u8 queue;
-		u8 set;
-		u8 aifs;
-		u8 cw_min;
+		__le16 cw_min;
 		__le16 cw_max;
 		__le16 txop;
-	};
+		__le16 aifs;
+		u8 guardtime;
+		u8 acm;
+	} __packed;
 	struct mt7921_mcu_tx {
-		u8 total;
-		u8 action;
-		u8 valid;
-		u8 mode;
-
 		struct edca edca[IEEE80211_NUM_ACS];
+		u8 bss_idx;
+		u8 qos;
+		u8 wmm_idx;
+		u8 pad;
 	} __packed req = {
-		.valid = true,
-		.mode = TX_CMD_MODE,
-		.total = IEEE80211_NUM_ACS,
+		.bss_idx = mvif->mt76.idx,
+		.qos = vif->bss_conf.qos,
+		.wmm_idx = mvif->mt76.wmm_idx,
 	};
-	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+
 	struct mu_edca {
 		u8 cw_min;
 		u8 cw_max;
@@ -962,30 +957,29 @@ int mt7921_mcu_set_tx(struct mt7921_dev *dev, struct ieee80211_vif *vif)
 		.qos = vif->bss_conf.qos,
 		.wmm_idx = mvif->mt76.wmm_idx,
 	};
+	int to_aci[] = {1, 0, 2, 3};
 	int ac, ret;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		struct ieee80211_tx_queue_params *q = &mvif->queue_params[ac];
-		struct edca *e = &req.edca[ac];
+		struct edca *e = &req.edca[to_aci[ac]];
 
-		e->set = WMM_PARAM_SET;
-		e->queue = ac + mvif->mt76.wmm_idx * MT7921_MAX_WMM_SETS;
 		e->aifs = q->aifs;
 		e->txop = cpu_to_le16(q->txop);
 
 		if (q->cw_min)
-			e->cw_min = fls(q->cw_min);
+			e->cw_min = cpu_to_le16(q->cw_min);
 		else
 			e->cw_min = 5;
 
 		if (q->cw_max)
-			e->cw_max = cpu_to_le16(fls(q->cw_max));
+			e->cw_max = cpu_to_le16(q->cw_max);
 		else
 			e->cw_max = cpu_to_le16(10);
 	}
 
-	ret = mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(EDCA_UPDATE),
-				&req, sizeof(req), true);
+	ret = mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_EDCA_PARMS), &req,
+				sizeof(req), false);
 	if (ret)
 		return ret;
 
@@ -995,7 +989,6 @@ int mt7921_mcu_set_tx(struct mt7921_dev *dev, struct ieee80211_vif *vif)
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		struct ieee80211_he_mu_edca_param_ac_rec *q;
 		struct mu_edca *e;
-		int to_aci[] = {1, 0, 2, 3};
 
 		if (!mvif->queue_params[ac].mu_edca)
 			break;
-- 
2.34.1



