Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BDDD39AB
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJKGwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:52:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726481AbfJKGwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 02:52:50 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iIoBm-00059L-8M
        for stable@vger.kernel.org; Fri, 11 Oct 2019 09:14:13 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Date:   Fri, 11 Oct 2019 09:14:02 +0300
Message-Id: <20191011061402.32107-2-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191011061402.32107-1-luca@coelho.fi>
References: <20191011061402.32107-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: [PATCH v5.2 2/2] iwlwifi: mvm: replace RS mutex with a spin_lock
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit f5d88fa334e6c8e2d840512ffbb30e3cb58d065b ]

The solution with the worker still had a bug, as in order
to get sta, rcu_read_lock should be used and thus no mutex
can be used inside iwl_mvm_rs_rate_init.

Also, spin_lock is a simpler solution, no need to spawn a
dedicated worker.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  | 530 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |   1 -
 4 files changed, 258 insertions(+), 285 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 8a17b8e705e8..ddfa43a226fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1197,278 +1197,6 @@ static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 	return tid;
 }
 
-void iwl_mvm_rs_init_wk(struct work_struct *wk)
-{
-	struct iwl_mvm_sta *mvmsta = container_of(wk, struct iwl_mvm_sta,
-						  rs_init_wk);
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
-	struct ieee80211_sta *sta;
-
-	rcu_read_lock();
-
-	sta = rcu_dereference(mvmvif->mvm->fw_id_to_mac_id[mvmsta->sta_id]);
-	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
-		rcu_read_unlock();
-		return;
-	}
-
-	iwl_mvm_rs_rate_init(mvmvif->mvm, sta, mvmvif->phy_ctxt->channel->band,
-			     true);
-
-	rcu_read_unlock();
-}
-
-static void __iwl_mvm_rs_tx_status(struct iwl_mvm *mvm,
-				   struct ieee80211_sta *sta,
-				   int tid, struct ieee80211_tx_info *info,
-				   bool ndp)
-{
-	int legacy_success;
-	int retries;
-	int i;
-	struct iwl_lq_cmd *table;
-	u32 lq_hwrate;
-	struct rs_rate lq_rate, tx_resp_rate;
-	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
-	u32 tlc_info = (uintptr_t)info->status.status_driver_data[0];
-	u8 reduced_txp = tlc_info & RS_DRV_DATA_TXP_MSK;
-	u8 lq_color = RS_DRV_DATA_LQ_COLOR_GET(tlc_info);
-	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta.rs_drv;
-
-	/* Treat uninitialized rate scaling data same as non-existing. */
-	if (!lq_sta) {
-		IWL_DEBUG_RATE(mvm, "Station rate scaling not created yet.\n");
-		return;
-	} else if (!lq_sta->pers.drv) {
-		IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
-		return;
-	}
-
-	/* This packet was aggregated but doesn't carry status info */
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
-	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
-		return;
-
-	if (rs_rate_from_ucode_rate(tx_resp_hwrate, info->band,
-				    &tx_resp_rate)) {
-		WARN_ON_ONCE(1);
-		return;
-	}
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/* Disable last tx check if we are debugging with fixed rate but
-	 * update tx stats */
-	if (lq_sta->pers.dbg_fixed_rate) {
-		int index = tx_resp_rate.index;
-		enum rs_column column;
-		int attempts, success;
-
-		column = rs_get_column_from_rate(&tx_resp_rate);
-		if (WARN_ONCE(column == RS_COLUMN_INVALID,
-			      "Can't map rate 0x%x to column",
-			      tx_resp_hwrate))
-			return;
-
-		if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-			attempts = info->status.ampdu_len;
-			success = info->status.ampdu_ack_len;
-		} else {
-			attempts = info->status.rates[0].count;
-			success = !!(info->flags & IEEE80211_TX_STAT_ACK);
-		}
-
-		lq_sta->pers.tx_stats[column][index].total += attempts;
-		lq_sta->pers.tx_stats[column][index].success += success;
-
-		IWL_DEBUG_RATE(mvm, "Fixed rate 0x%x success %d attempts %d\n",
-			       tx_resp_hwrate, success, attempts);
-		return;
-	}
-#endif
-
-	if (time_after(jiffies,
-		       (unsigned long)(lq_sta->last_tx +
-				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
-		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
-		schedule_work(&mvmsta->rs_init_wk);
-		return;
-	}
-	lq_sta->last_tx = jiffies;
-
-	/* Ignore this Tx frame response if its initial rate doesn't match
-	 * that of latest Link Quality command.  There may be stragglers
-	 * from a previous Link Quality command, but we're no longer interested
-	 * in those; they're either from the "active" mode while we're trying
-	 * to check "search" mode, or a prior "search" mode after we've moved
-	 * to a new "search" mode (which might become the new "active" mode).
-	 */
-	table = &lq_sta->lq;
-	lq_hwrate = le32_to_cpu(table->rs_table[0]);
-	if (rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate)) {
-		WARN_ON_ONCE(1);
-		return;
-	}
-
-	/* Here we actually compare this rate to the latest LQ command */
-	if (lq_color != LQ_FLAG_COLOR_GET(table->flags)) {
-		IWL_DEBUG_RATE(mvm,
-			       "tx resp color 0x%x does not match 0x%x\n",
-			       lq_color, LQ_FLAG_COLOR_GET(table->flags));
-
-		/*
-		 * Since rates mis-match, the last LQ command may have failed.
-		 * After IWL_MISSED_RATE_MAX mis-matches, resync the uCode with
-		 * ... driver.
-		 */
-		lq_sta->missed_rate_counter++;
-		if (lq_sta->missed_rate_counter > IWL_MVM_RS_MISSED_RATE_MAX) {
-			lq_sta->missed_rate_counter = 0;
-			IWL_DEBUG_RATE(mvm,
-				       "Too many rates mismatch. Send sync LQ. rs_state %d\n",
-				       lq_sta->rs_state);
-			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq);
-		}
-		/* Regardless, ignore this status info for outdated rate */
-		return;
-	} else
-		/* Rate did match, so reset the missed_rate_counter */
-		lq_sta->missed_rate_counter = 0;
-
-	if (!lq_sta->search_better_tbl) {
-		curr_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		other_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-	} else {
-		curr_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-		other_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	}
-
-	if (WARN_ON_ONCE(!rs_rate_column_match(&lq_rate, &curr_tbl->rate))) {
-		IWL_DEBUG_RATE(mvm,
-			       "Neither active nor search matches tx rate\n");
-		tmp_tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		rs_dump_rate(mvm, &tmp_tbl->rate, "ACTIVE");
-		tmp_tbl = &(lq_sta->lq_info[1 - lq_sta->active_tbl]);
-		rs_dump_rate(mvm, &tmp_tbl->rate, "SEARCH");
-		rs_dump_rate(mvm, &lq_rate, "ACTUAL");
-
-		/*
-		 * no matching table found, let's by-pass the data collection
-		 * and continue to perform rate scale to find the rate table
-		 */
-		rs_stay_in_table(lq_sta, true);
-		goto done;
-	}
-
-	/*
-	 * Updating the frame history depends on whether packets were
-	 * aggregated.
-	 *
-	 * For aggregation, all packets were transmitted at the same rate, the
-	 * first index into rate scale table.
-	 */
-	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-		rs_collect_tpc_data(mvm, lq_sta, curr_tbl, tx_resp_rate.index,
-				    info->status.ampdu_len,
-				    info->status.ampdu_ack_len,
-				    reduced_txp);
-
-		/* ampdu_ack_len = 0 marks no BA was received. For TLC, treat
-		 * it as a single frame loss as we don't want the success ratio
-		 * to dip too quickly because a BA wasn't received.
-		 * For TPC, there's no need for this optimisation since we want
-		 * to recover very quickly from a bad power reduction and,
-		 * therefore we'd like the success ratio to get an immediate hit
-		 * when failing to get a BA, so we'd switch back to a lower or
-		 * zero power reduction. When FW transmits agg with a rate
-		 * different from the initial rate, it will not use reduced txp
-		 * and will send BA notification twice (one empty with reduced
-		 * txp equal to the value from LQ and one with reduced txp 0).
-		 * We need to update counters for each txp level accordingly.
-		 */
-		if (info->status.ampdu_ack_len == 0)
-			info->status.ampdu_len = 1;
-
-		rs_collect_tlc_data(mvm, mvmsta, tid, curr_tbl,
-				    tx_resp_rate.index,
-				    info->status.ampdu_len,
-				    info->status.ampdu_ack_len);
-
-		/* Update success/fail counts if not searching for new mode */
-		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
-			lq_sta->total_success += info->status.ampdu_ack_len;
-			lq_sta->total_failed += (info->status.ampdu_len -
-					info->status.ampdu_ack_len);
-		}
-	} else {
-		/* For legacy, update frame history with for each Tx retry. */
-		retries = info->status.rates[0].count - 1;
-		/* HW doesn't send more than 15 retries */
-		retries = min(retries, 15);
-
-		/* The last transmission may have been successful */
-		legacy_success = !!(info->flags & IEEE80211_TX_STAT_ACK);
-		/* Collect data for each rate used during failed TX attempts */
-		for (i = 0; i <= retries; ++i) {
-			lq_hwrate = le32_to_cpu(table->rs_table[i]);
-			if (rs_rate_from_ucode_rate(lq_hwrate, info->band,
-						    &lq_rate)) {
-				WARN_ON_ONCE(1);
-				return;
-			}
-
-			/*
-			 * Only collect stats if retried rate is in the same RS
-			 * table as active/search.
-			 */
-			if (rs_rate_column_match(&lq_rate, &curr_tbl->rate))
-				tmp_tbl = curr_tbl;
-			else if (rs_rate_column_match(&lq_rate,
-						      &other_tbl->rate))
-				tmp_tbl = other_tbl;
-			else
-				continue;
-
-			rs_collect_tpc_data(mvm, lq_sta, tmp_tbl,
-					    tx_resp_rate.index, 1,
-					    i < retries ? 0 : legacy_success,
-					    reduced_txp);
-			rs_collect_tlc_data(mvm, mvmsta, tid, tmp_tbl,
-					    tx_resp_rate.index, 1,
-					    i < retries ? 0 : legacy_success);
-		}
-
-		/* Update success/fail counts if not searching for new mode */
-		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
-			lq_sta->total_success += legacy_success;
-			lq_sta->total_failed += retries + (1 - legacy_success);
-		}
-	}
-	/* The last TX rate is cached in lq_sta; it's set in if/else above */
-	lq_sta->last_rate_n_flags = lq_hwrate;
-	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
-done:
-	/* See if there's a better rate or modulation mode to try. */
-	if (sta->supp_rates[info->band])
-		rs_rate_scale_perform(mvm, sta, lq_sta, tid, ndp);
-}
-
-void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  int tid, struct ieee80211_tx_info *info, bool ndp)
-{
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-	/* If it's locked we are in middle of init flow
-	 * just wait for next tx status to update the lq_sta data
-	 */
-	if (!mutex_trylock(&mvmsta->lq_sta.rs_drv.mutex))
-		return;
-
-	__iwl_mvm_rs_tx_status(mvm, sta, tid, info, ndp);
-	mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
-}
-
 /*
  * mac80211 sends us Tx status
  */
@@ -3230,6 +2958,8 @@ static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband;
 	unsigned long supp; /* must be unsigned long for for_each_set_bit */
 
+	lockdep_assert_held(&mvmsta->lq_sta.rs_drv.pers.lock);
+
 	/* clear all non-persistent lq data */
 	memset(lq_sta, 0, offsetof(typeof(*lq_sta), pers));
 
@@ -3322,6 +3052,258 @@ static void rs_drv_rate_update(void *mvm_r,
 	iwl_mvm_rs_rate_init(mvm, sta, sband->band, true);
 }
 
+static void __iwl_mvm_rs_tx_status(struct iwl_mvm *mvm,
+				   struct ieee80211_sta *sta,
+				   int tid, struct ieee80211_tx_info *info,
+				   bool ndp)
+{
+	int legacy_success;
+	int retries;
+	int i;
+	struct iwl_lq_cmd *table;
+	u32 lq_hwrate;
+	struct rs_rate lq_rate, tx_resp_rate;
+	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
+	u32 tlc_info = (uintptr_t)info->status.status_driver_data[0];
+	u8 reduced_txp = tlc_info & RS_DRV_DATA_TXP_MSK;
+	u8 lq_color = RS_DRV_DATA_LQ_COLOR_GET(tlc_info);
+	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta.rs_drv;
+
+	/* Treat uninitialized rate scaling data same as non-existing. */
+	if (!lq_sta) {
+		IWL_DEBUG_RATE(mvm, "Station rate scaling not created yet.\n");
+		return;
+	} else if (!lq_sta->pers.drv) {
+		IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
+		return;
+	}
+
+	/* This packet was aggregated but doesn't carry status info */
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
+		return;
+
+	if (rs_rate_from_ucode_rate(tx_resp_hwrate, info->band,
+				    &tx_resp_rate)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* Disable last tx check if we are debugging with fixed rate but
+	 * update tx stats
+	 */
+	if (lq_sta->pers.dbg_fixed_rate) {
+		int index = tx_resp_rate.index;
+		enum rs_column column;
+		int attempts, success;
+
+		column = rs_get_column_from_rate(&tx_resp_rate);
+		if (WARN_ONCE(column == RS_COLUMN_INVALID,
+			      "Can't map rate 0x%x to column",
+			      tx_resp_hwrate))
+			return;
+
+		if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+			attempts = info->status.ampdu_len;
+			success = info->status.ampdu_ack_len;
+		} else {
+			attempts = info->status.rates[0].count;
+			success = !!(info->flags & IEEE80211_TX_STAT_ACK);
+		}
+
+		lq_sta->pers.tx_stats[column][index].total += attempts;
+		lq_sta->pers.tx_stats[column][index].success += success;
+
+		IWL_DEBUG_RATE(mvm, "Fixed rate 0x%x success %d attempts %d\n",
+			       tx_resp_hwrate, success, attempts);
+		return;
+	}
+#endif
+
+	if (time_after(jiffies,
+		       (unsigned long)(lq_sta->last_tx +
+				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
+		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
+		/* reach here only in case of driver RS, call directly
+		 * the unlocked version
+		 */
+		rs_drv_rate_init(mvm, sta, info->band);
+		return;
+	}
+	lq_sta->last_tx = jiffies;
+
+	/* Ignore this Tx frame response if its initial rate doesn't match
+	 * that of latest Link Quality command.  There may be stragglers
+	 * from a previous Link Quality command, but we're no longer interested
+	 * in those; they're either from the "active" mode while we're trying
+	 * to check "search" mode, or a prior "search" mode after we've moved
+	 * to a new "search" mode (which might become the new "active" mode).
+	 */
+	table = &lq_sta->lq;
+	lq_hwrate = le32_to_cpu(table->rs_table[0]);
+	if (rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	/* Here we actually compare this rate to the latest LQ command */
+	if (lq_color != LQ_FLAG_COLOR_GET(table->flags)) {
+		IWL_DEBUG_RATE(mvm,
+			       "tx resp color 0x%x does not match 0x%x\n",
+			       lq_color, LQ_FLAG_COLOR_GET(table->flags));
+
+		/* Since rates mis-match, the last LQ command may have failed.
+		 * After IWL_MISSED_RATE_MAX mis-matches, resync the uCode with
+		 * ... driver.
+		 */
+		lq_sta->missed_rate_counter++;
+		if (lq_sta->missed_rate_counter > IWL_MVM_RS_MISSED_RATE_MAX) {
+			lq_sta->missed_rate_counter = 0;
+			IWL_DEBUG_RATE(mvm,
+				       "Too many rates mismatch. Send sync LQ. rs_state %d\n",
+				       lq_sta->rs_state);
+			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq);
+		}
+		/* Regardless, ignore this status info for outdated rate */
+		return;
+	}
+
+	/* Rate did match, so reset the missed_rate_counter */
+	lq_sta->missed_rate_counter = 0;
+
+	if (!lq_sta->search_better_tbl) {
+		curr_tbl = &lq_sta->lq_info[lq_sta->active_tbl];
+		other_tbl = &lq_sta->lq_info[1 - lq_sta->active_tbl];
+	} else {
+		curr_tbl = &lq_sta->lq_info[1 - lq_sta->active_tbl];
+		other_tbl = &lq_sta->lq_info[lq_sta->active_tbl];
+	}
+
+	if (WARN_ON_ONCE(!rs_rate_column_match(&lq_rate, &curr_tbl->rate))) {
+		IWL_DEBUG_RATE(mvm,
+			       "Neither active nor search matches tx rate\n");
+		tmp_tbl = &lq_sta->lq_info[lq_sta->active_tbl];
+		rs_dump_rate(mvm, &tmp_tbl->rate, "ACTIVE");
+		tmp_tbl = &lq_sta->lq_info[1 - lq_sta->active_tbl];
+		rs_dump_rate(mvm, &tmp_tbl->rate, "SEARCH");
+		rs_dump_rate(mvm, &lq_rate, "ACTUAL");
+
+		/* no matching table found, let's by-pass the data collection
+		 * and continue to perform rate scale to find the rate table
+		 */
+		rs_stay_in_table(lq_sta, true);
+		goto done;
+	}
+
+	/* Updating the frame history depends on whether packets were
+	 * aggregated.
+	 *
+	 * For aggregation, all packets were transmitted at the same rate, the
+	 * first index into rate scale table.
+	 */
+	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
+		rs_collect_tpc_data(mvm, lq_sta, curr_tbl, tx_resp_rate.index,
+				    info->status.ampdu_len,
+				    info->status.ampdu_ack_len,
+				    reduced_txp);
+
+		/* ampdu_ack_len = 0 marks no BA was received. For TLC, treat
+		 * it as a single frame loss as we don't want the success ratio
+		 * to dip too quickly because a BA wasn't received.
+		 * For TPC, there's no need for this optimisation since we want
+		 * to recover very quickly from a bad power reduction and,
+		 * therefore we'd like the success ratio to get an immediate hit
+		 * when failing to get a BA, so we'd switch back to a lower or
+		 * zero power reduction. When FW transmits agg with a rate
+		 * different from the initial rate, it will not use reduced txp
+		 * and will send BA notification twice (one empty with reduced
+		 * txp equal to the value from LQ and one with reduced txp 0).
+		 * We need to update counters for each txp level accordingly.
+		 */
+		if (info->status.ampdu_ack_len == 0)
+			info->status.ampdu_len = 1;
+
+		rs_collect_tlc_data(mvm, mvmsta, tid, curr_tbl,
+				    tx_resp_rate.index,
+				    info->status.ampdu_len,
+				    info->status.ampdu_ack_len);
+
+		/* Update success/fail counts if not searching for new mode */
+		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
+			lq_sta->total_success += info->status.ampdu_ack_len;
+			lq_sta->total_failed += (info->status.ampdu_len -
+					info->status.ampdu_ack_len);
+		}
+	} else {
+		/* For legacy, update frame history with for each Tx retry. */
+		retries = info->status.rates[0].count - 1;
+		/* HW doesn't send more than 15 retries */
+		retries = min(retries, 15);
+
+		/* The last transmission may have been successful */
+		legacy_success = !!(info->flags & IEEE80211_TX_STAT_ACK);
+		/* Collect data for each rate used during failed TX attempts */
+		for (i = 0; i <= retries; ++i) {
+			lq_hwrate = le32_to_cpu(table->rs_table[i]);
+			if (rs_rate_from_ucode_rate(lq_hwrate, info->band,
+						    &lq_rate)) {
+				WARN_ON_ONCE(1);
+				return;
+			}
+
+			/* Only collect stats if retried rate is in the same RS
+			 * table as active/search.
+			 */
+			if (rs_rate_column_match(&lq_rate, &curr_tbl->rate))
+				tmp_tbl = curr_tbl;
+			else if (rs_rate_column_match(&lq_rate,
+						      &other_tbl->rate))
+				tmp_tbl = other_tbl;
+			else
+				continue;
+
+			rs_collect_tpc_data(mvm, lq_sta, tmp_tbl,
+					    tx_resp_rate.index, 1,
+					    i < retries ? 0 : legacy_success,
+					    reduced_txp);
+			rs_collect_tlc_data(mvm, mvmsta, tid, tmp_tbl,
+					    tx_resp_rate.index, 1,
+					    i < retries ? 0 : legacy_success);
+		}
+
+		/* Update success/fail counts if not searching for new mode */
+		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
+			lq_sta->total_success += legacy_success;
+			lq_sta->total_failed += retries + (1 - legacy_success);
+		}
+	}
+	/* The last TX rate is cached in lq_sta; it's set in if/else above */
+	lq_sta->last_rate_n_flags = lq_hwrate;
+	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
+done:
+	/* See if there's a better rate or modulation mode to try. */
+	if (sta->supp_rates[info->band])
+		rs_rate_scale_perform(mvm, sta, lq_sta, tid, ndp);
+}
+
+void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  int tid, struct ieee80211_tx_info *info, bool ndp)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	/* If it's locked we are in middle of init flow
+	 * just wait for next tx status to update the lq_sta data
+	 */
+	if (!spin_trylock(&mvmsta->lq_sta.rs_drv.pers.lock))
+		return;
+
+	__iwl_mvm_rs_tx_status(mvm, sta, tid, info, ndp);
+	spin_unlock(&mvmsta->lq_sta.rs_drv.pers.lock);
+}
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 					    struct iwl_lq_cmd *lq_cmd,
@@ -4181,9 +4163,9 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	} else {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-		mutex_lock(&mvmsta->lq_sta.rs_drv.mutex);
+		spin_lock(&mvmsta->lq_sta.rs_drv.pers.lock);
 		rs_drv_rate_init(mvm, sta, band);
-		mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
+		spin_unlock(&mvmsta->lq_sta.rs_drv.pers.lock);
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 086f47e2a4f0..428642e66658 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -376,9 +376,6 @@ struct iwl_lq_sta {
 	/* tx power reduce for this sta */
 	int tpc_reduce;
 
-	/* avoid races of reinit and update table from rx_tx */
-	struct mutex mutex;
-
 	/* persistent fields - initialized only once - keep last! */
 	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -393,6 +390,7 @@ struct iwl_lq_sta {
 		s8 last_rssi;
 		struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
 		struct iwl_mvm *drv;
+		spinlock_t lock; /* for races in reinit/update table */
 	} pers;
 };
 
@@ -443,8 +441,6 @@ struct iwl_mvm_sta;
 int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			  bool enable);
 
-void iwl_mvm_rs_init_wk(struct work_struct *wk);
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm);
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 22715cdb8317..946d4cd30694 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1685,9 +1685,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	if (iwl_mvm_has_tlc_offload(mvm))
 		iwl_mvm_rs_add_sta(mvm, mvm_sta);
 	else
-		mutex_init(&mvm_sta->lq_sta.rs_drv.mutex);
-
-	INIT_WORK(&mvm_sta->rs_init_wk, iwl_mvm_rs_init_wk);
+		spin_lock_init(&mvm_sta->lq_sta.rs_drv.pers.lock);
 
 	iwl_mvm_toggle_tx_ant(mvm, &mvm_sta->tx_ant);
 
@@ -1850,8 +1848,6 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	cancel_work_sync(&mvm_sta->rs_init_wk);
-
 	/* flush its queues here since we are freeing mvm_sta */
 	ret = iwl_mvm_flush_sta(mvm, mvm_sta, false, 0);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 6e93c30492b7..b4d4071b865d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -421,7 +421,6 @@ struct iwl_mvm_sta {
 		struct iwl_lq_sta_rs_fw rs_fw;
 		struct iwl_lq_sta rs_drv;
 	} lq_sta;
-	struct work_struct rs_init_wk;
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
-- 
2.23.0

