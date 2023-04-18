Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9B6E6402
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjDRMpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjDRMpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3206814F64
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28436338A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A3DC433EF;
        Tue, 18 Apr 2023 12:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821910;
        bh=3l5a76GquH+vwdO1zyT2Wr837bfO5e5wQGOwPjqJ4oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNKRjHsxZpPVjQ7ePks46AbnxI1DdD1oa9eDbU24NVJiA4CXizy9oDP1exG4adRCm
         S2temwmDf466RsB9ibvl+PyPU8HwzWP9RzXsoFhO4s534O2ZOkTH3IABtBoybTXzPY
         SiY6q4B3e3uCeS2dzWhIuuVO6To8zHPy7D2yy+oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/134] wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
Date:   Tue, 18 Apr 2023 14:22:24 +0200
Message-Id: <20230418120316.218777450@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b58e3d4311b54b6dd0e37165277965da0c9eb21d ]

This could race if the queue is redirected while full, then
the flushing internally would start it while it's not yet
usable again. Fix it by using two state bits instead of just
one.

Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Tested-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8464c9b7baf1f..23e1413ef4719 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -729,7 +729,10 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 
 	rcu_read_lock();
 	do {
-		while (likely(!mvmtxq->stopped &&
+		while (likely(!test_bit(IWL_MVM_TXQ_STATE_STOP_FULL,
+					&mvmtxq->state) &&
+			      !test_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT,
+					&mvmtxq->state) &&
 			      !test_bit(IWL_MVM_STATUS_IN_D3, &mvm->status))) {
 			skb = ieee80211_tx_dequeue(hw, txq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1ccb3cad7cdc1..b5089349ebb7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -729,7 +729,9 @@ struct iwl_mvm_txq {
 	struct list_head list;
 	u16 txq_id;
 	atomic_t tx_request;
-	bool stopped;
+#define IWL_MVM_TXQ_STATE_STOP_FULL	0
+#define IWL_MVM_TXQ_STATE_STOP_REDIRECT	1
+	unsigned long state;
 };
 
 static inline struct iwl_mvm_txq *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5b8e9a06f6d4a..79e151512fe73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1680,7 +1680,10 @@ static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 
 		txq = sta->txq[tid];
 		mvmtxq = iwl_mvm_txq_from_mac80211(txq);
-		mvmtxq->stopped = !start;
+		if (start)
+			clear_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
+		else
+			set_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
 
 		if (start && mvmsta->sta_state != IEEE80211_STA_NOTEXIST)
 			iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index cbd8053a9e35a..41b1b8b6c1e1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -692,7 +692,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
 	/* Stop the queue and wait for it to empty */
-	txq->stopped = true;
+	set_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
@@ -735,7 +735,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 
 out:
 	/* Continue using the queue */
-	txq->stopped = false;
+	clear_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	return ret;
 }
-- 
2.39.2



