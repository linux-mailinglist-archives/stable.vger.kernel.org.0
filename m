Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9197A5936DE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiHOS6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245117AbiHOS4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3BF32B8B;
        Mon, 15 Aug 2022 11:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8818B81084;
        Mon, 15 Aug 2022 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CBDC43141;
        Mon, 15 Aug 2022 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588299;
        bh=VV8gink0WExPDdKn781lcIG6OPIv8hTyhv2dKHY8ToM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaRNJ83agi5rLMCstyZ2Ccmc/pX7WUfoY0yN9sWrZwHYmTD4jk8zZF9G+PysKvUiW
         cjWsXe3clLscc3+e5X6uSE9Jg6EPjyiMs9WEE57/ZVlSnKkMNeIu0qud90elWigvDD
         wv3Uq6jL0/zz12LRTDVg9C9JEGD4UIiB7NKQyMWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/779] ieee80211: add EHT 1K aggregation definitions
Date:   Mon, 15 Aug 2022 19:59:32 +0200
Message-Id: <20220815180351.314176311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 2a2c86f15e17c5013b9897b67d895e64a25ae3cb ]

We add the fields for parsing extended ADDBA request/respond,
and new max 1K aggregation for limit ADDBA request/respond.

Adjust drivers to use the proper macro, IEEE80211_MAX_AMPDU_BUF ->
IEEE80211_MAX_AMPDU_BUF_HE.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Link: https://lore.kernel.org/r/20220214173004.b8b447ce95b7.I0ee2554c94e89abc7a752b0f7cc7fd79c273efea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 4 ++--
 include/linux/ieee80211.h                        | 6 +++++-
 net/mac80211/agg-rx.c                            | 2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f85fd341557e..c7ee373a9d2c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6566,7 +6566,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ar->hw->queues = ATH11K_HW_MAX_QUEUES;
 	ar->hw->wiphy->tx_queue_len = ATH11K_QUEUE_LEN;
 	ar->hw->offchannel_tx_hw_queue = ATH11K_HW_MAX_QUEUES - 1;
-	ar->hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	ar->hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 
 	ar->hw->vif_data_size = sizeof(struct ath11k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath11k_sta);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index c77d98c88811..eeb81808db08 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -761,12 +761,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (!hw)
 		return NULL;
 
-	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 
 	if (cfg->max_tx_agg_size)
 		hw->max_tx_aggregation_subframes = cfg->max_tx_agg_size;
 	else
-		hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+		hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 
 	op_mode = hw->priv;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index b171027e0cfa..1ae42ef147c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -217,8 +217,8 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	struct wiphy *wiphy = hw->wiphy;
 
 	hw->queues = 4;
-	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
-	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
+	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->netdev_features = NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 694264503119..00ed7c17698d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1023,6 +1023,8 @@ struct ieee80211_tpc_report_ie {
 #define IEEE80211_ADDBA_EXT_FRAG_LEVEL_MASK	GENMASK(2, 1)
 #define IEEE80211_ADDBA_EXT_FRAG_LEVEL_SHIFT	1
 #define IEEE80211_ADDBA_EXT_NO_FRAG		BIT(0)
+#define IEEE80211_ADDBA_EXT_BUF_SIZE_MASK	GENMASK(7, 5)
+#define IEEE80211_ADDBA_EXT_BUF_SIZE_SHIFT	10
 
 struct ieee80211_addba_ext_ie {
 	u8 data;
@@ -1697,10 +1699,12 @@ struct ieee80211_ht_operation {
  * A-MPDU buffer sizes
  * According to HT size varies from 8 to 64 frames
  * HE adds the ability to have up to 256 frames.
+ * EHT adds the ability to have up to 1K frames.
  */
 #define IEEE80211_MIN_AMPDU_BUF		0x8
 #define IEEE80211_MAX_AMPDU_BUF_HT	0x40
-#define IEEE80211_MAX_AMPDU_BUF		0x100
+#define IEEE80211_MAX_AMPDU_BUF_HE	0x100
+#define IEEE80211_MAX_AMPDU_BUF_EHT	0x400
 
 
 /* Spatial Multiplexing Power Save Modes (for capability) */
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index ef729b1e39ea..e43176794149 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -310,7 +310,7 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 	}
 
 	if (sta->sta.he_cap.has_he)
-		max_buf_size = IEEE80211_MAX_AMPDU_BUF;
+		max_buf_size = IEEE80211_MAX_AMPDU_BUF_HE;
 	else
 		max_buf_size = IEEE80211_MAX_AMPDU_BUF_HT;
 
-- 
2.35.1



