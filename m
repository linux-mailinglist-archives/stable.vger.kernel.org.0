Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4369E042
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbfH0IB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfH0IB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7220020828;
        Tue, 27 Aug 2019 08:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892915;
        bh=m5EKUYvB67Nnfw6kGBcrdXpbpPaMkMC88BrKl4ZhD3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19qxW5LpEvTMNhCsMTFvx+r6X7spUI0UwmKfrABLDjD4hvYwEWxD1vjZ4m7opTe9J
         EUe7B4DbsKp33Py9pcxbAfk38FM369zGONx4z3J3nlYBr/TOc1Mi5A7eEFo46jIoXY
         HpBypGC2IFjjDhGGrIE5JbiKFB+Q6GLIntLOqJyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 056/162] iwlwifi: mvm: avoid races in rate init and rate perform
Date:   Tue, 27 Aug 2019 09:49:44 +0200
Message-Id: <20190827072740.143145624@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0f8084cdc1f9d4a6693ef4168167febb0918c6f6 ]

Rate perform uses the lq_sta table to calculate the next rate to scale
while rate init resets the same table,

Rate perform is done in soft irq context in parallel to rate init
that can be called in case we are doing changes like AP changes BW
or moving state for auth to assoc.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  | 42 ++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h  |  7 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  6 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |  1 +
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 63fdb4e68e9d7..836541caa3167 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1197,6 +1197,27 @@ static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 	return tid;
 }
 
+void iwl_mvm_rs_init_wk(struct work_struct *wk)
+{
+	struct iwl_mvm_sta *mvmsta = container_of(wk, struct iwl_mvm_sta,
+						  rs_init_wk);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
+	struct ieee80211_sta *sta;
+
+	rcu_read_lock();
+
+	sta = rcu_dereference(mvmvif->mvm->fw_id_to_mac_id[mvmsta->sta_id]);
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
+		rcu_read_unlock();
+		return;
+	}
+
+	iwl_mvm_rs_rate_init(mvmvif->mvm, sta, mvmvif->phy_ctxt->channel->band,
+			     true);
+
+	rcu_read_unlock();
+}
+
 void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  int tid, struct ieee80211_tx_info *info, bool ndp)
 {
@@ -1269,7 +1290,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       (unsigned long)(lq_sta->last_tx +
 				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
 		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
-		iwl_mvm_rs_rate_init(mvm, sta, info->band, true);
+		schedule_work(&mvmsta->rs_init_wk);
 		return;
 	}
 	lq_sta->last_tx = jiffies;
@@ -1442,16 +1463,24 @@ static void rs_drv_mac80211_tx_status(void *mvm_r,
 	struct iwl_op_mode *op_mode = mvm_r;
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-	if (!iwl_mvm_sta_from_mac80211(sta)->vif)
+	if (!mvmsta->vif)
 		return;
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
+	/* If it's locked we are in middle of init flow
+	 * just wait for next tx status to update the lq_sta data
+	 */
+	if (!mutex_trylock(&mvmsta->lq_sta.rs_drv.mutex))
+		return;
+
 	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info,
 			     ieee80211_is_qos_nullfunc(hdr->frame_control));
+	mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
 }
 
 /*
@@ -4136,10 +4165,15 @@ static const struct rate_control_ops rs_mvm_ops_drv = {
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum nl80211_band band, bool update)
 {
-	if (iwl_mvm_has_tlc_offload(mvm))
+	if (iwl_mvm_has_tlc_offload(mvm)) {
 		rs_fw_rate_init(mvm, sta, band, update);
-	else
+	} else {
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		mutex_lock(&mvmsta->lq_sta.rs_drv.mutex);
 		rs_drv_rate_init(mvm, sta, band, update);
+		mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
+	}
 }
 
 int iwl_mvm_rate_control_register(void)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index f7eb60dbaf202..086f47e2a4f0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -4,7 +4,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * Contact Information:
  *  Intel Linux Wireless <linuxwifi@intel.com>
@@ -376,6 +376,9 @@ struct iwl_lq_sta {
 	/* tx power reduce for this sta */
 	int tpc_reduce;
 
+	/* avoid races of reinit and update table from rx_tx */
+	struct mutex mutex;
+
 	/* persistent fields - initialized only once - keep last! */
 	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -440,6 +443,8 @@ struct iwl_mvm_sta;
 int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			  bool enable);
 
+void iwl_mvm_rs_init_wk(struct work_struct *wk);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm);
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f545a737a92df..ac9bc65c4d156 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1684,6 +1684,10 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	 */
 	if (iwl_mvm_has_tlc_offload(mvm))
 		iwl_mvm_rs_add_sta(mvm, mvm_sta);
+	else
+		mutex_init(&mvm_sta->lq_sta.rs_drv.mutex);
+
+	INIT_WORK(&mvm_sta->rs_init_wk, iwl_mvm_rs_init_wk);
 
 	iwl_mvm_toggle_tx_ant(mvm, &mvm_sta->tx_ant);
 
@@ -1846,6 +1850,8 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
+	cancel_work_sync(&mvm_sta->rs_init_wk);
+
 	/* flush its queues here since we are freeing mvm_sta */
 	ret = iwl_mvm_flush_sta(mvm, mvm_sta, false, 0);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index b4d4071b865db..6e93c30492b78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -421,6 +421,7 @@ struct iwl_mvm_sta {
 		struct iwl_lq_sta_rs_fw rs_fw;
 		struct iwl_lq_sta rs_drv;
 	} lq_sta;
+	struct work_struct rs_init_wk;
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
-- 
2.20.1



