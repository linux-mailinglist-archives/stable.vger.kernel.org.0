Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94C66E6403
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjDRMp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjDRMpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F9F14F7C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ADFB63391
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D279C4339B;
        Tue, 18 Apr 2023 12:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821912;
        bh=Micv8UCLoHTeZlIXZHFzJHgODij7r9AWXwuOqRxLMKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWNdBq0KjyPHoJmRydmeOBIsx1bHXHMpvoG+xCYvlf9zG7EAe0JnKBxo/uyFYI9Ib
         mpHJ5RihWRs2W3F3rjxUU81Oi6lhZYtiTh30vjFcKPPfFg7VGCHUwDLaBHb14ri5YJ
         DW4/z+igiz1nIOVjdnZdLrr4KpLF6uIDGSBWK3wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/134] wifi: iwlwifi: mvm: protect TXQ list manipulation
Date:   Tue, 18 Apr 2023 14:22:25 +0200
Message-Id: <20230418120316.267898159@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 923bf981eb6ecc027227716e30701bdcc1845fbf ]

Some recent upstream debugging uncovered the fact that in
iwlwifi, the TXQ list manipulation is racy.

Introduce a new state bit for when the TXQ is completely
ready and can be used without locking, and if that's not
set yet acquire the lock to check everything correctly.

Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Tested-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 45 ++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 25 +++++++++--
 4 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 23e1413ef4719..a841268e0709f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -757,42 +757,25 @@ static void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
 
-	/*
-	 * Please note that racing is handled very carefully here:
-	 * mvmtxq->txq_id is updated during allocation, and mvmtxq->list is
-	 * deleted afterwards.
-	 * This means that if:
-	 * mvmtxq->txq_id != INVALID_QUEUE && list_empty(&mvmtxq->list):
-	 *	queue is allocated and we can TX.
-	 * mvmtxq->txq_id != INVALID_QUEUE && !list_empty(&mvmtxq->list):
-	 *	a race, should defer the frame.
-	 * mvmtxq->txq_id == INVALID_QUEUE && list_empty(&mvmtxq->list):
-	 *	need to allocate the queue and defer the frame.
-	 * mvmtxq->txq_id == INVALID_QUEUE && !list_empty(&mvmtxq->list):
-	 *	queue is already scheduled for allocation, no need to allocate,
-	 *	should defer the frame.
-	 */
-
-	/* If the queue is allocated TX and return. */
-	if (!txq->sta || mvmtxq->txq_id != IWL_MVM_INVALID_QUEUE) {
-		/*
-		 * Check that list is empty to avoid a race where txq_id is
-		 * already updated, but the queue allocation work wasn't
-		 * finished
-		 */
-		if (unlikely(txq->sta && !list_empty(&mvmtxq->list)))
-			return;
-
+	if (likely(test_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state)) ||
+	    !txq->sta) {
 		iwl_mvm_mac_itxq_xmit(hw, txq);
 		return;
 	}
 
-	/* The list is being deleted only after the queue is fully allocated. */
-	if (!list_empty(&mvmtxq->list))
-		return;
+	/* iwl_mvm_mac_itxq_xmit() will later be called by the worker
+	 * to handle any packets we leave on the txq now
+	 */
 
-	list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
-	schedule_work(&mvm->add_stream_wk);
+	spin_lock_bh(&mvm->add_stream_lock);
+	/* The list is being deleted only after the queue is fully allocated. */
+	if (list_empty(&mvmtxq->list) &&
+	    /* recheck under lock */
+	    !test_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state)) {
+		list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
+		schedule_work(&mvm->add_stream_wk);
+	}
+	spin_unlock_bh(&mvm->add_stream_lock);
 }
 
 #define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)		\
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b5089349ebb7a..f5c921c41be56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -731,6 +731,7 @@ struct iwl_mvm_txq {
 	atomic_t tx_request;
 #define IWL_MVM_TXQ_STATE_STOP_FULL	0
 #define IWL_MVM_TXQ_STATE_STOP_REDIRECT	1
+#define IWL_MVM_TXQ_STATE_READY		2
 	unsigned long state;
 };
 
@@ -829,6 +830,7 @@ struct iwl_mvm {
 		struct iwl_mvm_tvqm_txq_info tvqm_info[IWL_MAX_TVQM_QUEUES];
 	};
 	struct work_struct add_stream_wk; /* To add streams to queues */
+	spinlock_t add_stream_lock;
 
 	const char *nvm_file_name;
 	struct iwl_nvm_data *nvm_data;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 79e151512fe73..994f597a7102a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1184,6 +1184,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
 	INIT_LIST_HEAD(&mvm->add_stream_txqs);
+	spin_lock_init(&mvm->add_stream_lock);
 
 	init_waitqueue_head(&mvm->rx_sync_waitq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 41b1b8b6c1e1d..013aca70c3d3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -383,8 +383,11 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		struct iwl_mvm_txq *mvmtxq =
 			iwl_mvm_txq_from_tid(sta, tid);
 
-		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_lock_bh(&mvm->add_stream_lock);
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 
 	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
@@ -478,8 +481,11 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 			disable_agg_tids |= BIT(tid);
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 
-		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_lock_bh(&mvm->add_stream_lock);
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 
 	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
@@ -1443,12 +1449,22 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 		 * a queue in the function itself.
 		 */
 		if (iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, tid)) {
+			spin_lock_bh(&mvm->add_stream_lock);
 			list_del_init(&mvmtxq->list);
+			spin_unlock_bh(&mvm->add_stream_lock);
 			continue;
 		}
 
-		list_del_init(&mvmtxq->list);
+		/* now we're ready, any remaining races/concurrency will be
+		 * handled in iwl_mvm_mac_itxq_xmit()
+		 */
+		set_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+
 		local_bh_disable();
+		spin_lock(&mvm->add_stream_lock);
+		list_del_init(&mvmtxq->list);
+		spin_unlock(&mvm->add_stream_lock);
+
 		iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
 		local_bh_enable();
 	}
@@ -1862,8 +1878,11 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 		struct iwl_mvm_txq *mvmtxq =
 			iwl_mvm_txq_from_mac80211(sta->txq[i]);
 
+		spin_lock_bh(&mvm->add_stream_lock);
 		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 }
 
-- 
2.39.2



