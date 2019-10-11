Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B025BD39AA
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 08:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfJKGws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 02:52:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48268 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726481AbfJKGws (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 02:52:48 -0400
X-Greylist: delayed 2317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2019 02:52:48 EDT
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iIoBk-00059L-0g
        for stable@vger.kernel.org; Fri, 11 Oct 2019 09:14:10 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Date:   Fri, 11 Oct 2019 09:14:01 +0300
Message-Id: <20191011061402.32107-1-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: [PATCH v5.2 1/2] iwlwifi: mvm: add a wrapper around rs_tx_status to handle locks
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit 23babdf06779482a65c5072a145d826a62979534 ]

iwl_mvm_rs_tx_status can be called from two places in the code, but the
mutex is taken only on one of the calls. Split it into a wrapper taking
locks and an internal __iwl_mvm_rs_tx_status function.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 28 ++++++++++++++-------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 01b032f18bc8..8a17b8e705e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1218,8 +1218,10 @@ void iwl_mvm_rs_init_wk(struct work_struct *wk)
 	rcu_read_unlock();
 }
 
-void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  int tid, struct ieee80211_tx_info *info, bool ndp)
+static void __iwl_mvm_rs_tx_status(struct iwl_mvm *mvm,
+				   struct ieee80211_sta *sta,
+				   int tid, struct ieee80211_tx_info *info,
+				   bool ndp)
 {
 	int legacy_success;
 	int retries;
@@ -1452,6 +1454,21 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		rs_rate_scale_perform(mvm, sta, lq_sta, tid, ndp);
 }
 
+void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  int tid, struct ieee80211_tx_info *info, bool ndp)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	/* If it's locked we are in middle of init flow
+	 * just wait for next tx status to update the lq_sta data
+	 */
+	if (!mutex_trylock(&mvmsta->lq_sta.rs_drv.mutex))
+		return;
+
+	__iwl_mvm_rs_tx_status(mvm, sta, tid, info, ndp);
+	mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
+}
+
 /*
  * mac80211 sends us Tx status
  */
@@ -1473,15 +1490,8 @@ static void rs_drv_mac80211_tx_status(void *mvm_r,
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
-	/* If it's locked we are in middle of init flow
-	 * just wait for next tx status to update the lq_sta data
-	 */
-	if (!mutex_trylock(&mvmsta->lq_sta.rs_drv.mutex))
-		return;
-
 	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info,
 			     ieee80211_is_qos_nullfunc(hdr->frame_control));
-	mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
 }
 
 /*
-- 
2.23.0

