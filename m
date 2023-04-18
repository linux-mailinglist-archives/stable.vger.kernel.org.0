Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C4B6E634B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDRMjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbjDRMjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420051385F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF34C632E9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A28C433EF;
        Tue, 18 Apr 2023 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821557;
        bh=kQy34DEL3CbeSrP9sGPT9ua3j4jiQy/DOa34hpftVfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgHERbeP5O2ST2p5yzoIEgxlhtlA1TO8fsCMYkL8Y08+TzaZ6K4XxWQ7gaXblQIv1
         oQ6JTtpQtk5Xk+zOGR8XYQTyUa1IcFdfS6ixJ975Go3ma+ci7Z5Rzj7JJD1XI8Dpdx
         mxlYA2J/RSqA7kxEFTuQMkYwSx5CmOlxq/tbRvtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/91] wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
Date:   Tue, 18 Apr 2023 14:21:51 +0200
Message-Id: <20230418120307.205856001@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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
index 56c7a68a6491c..fa7de3e47b8cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -820,7 +820,10 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 
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
index 46af8dd2dc930..6b59425dbdb19 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -727,7 +727,9 @@ struct iwl_mvm_txq {
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
index eeb81808db088..3ee4b3ecd0c82 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1304,7 +1304,10 @@ static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 
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
index 1bb456daff9e9..45dfee3ad8c60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -640,7 +640,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
 	/* Stop the queue and wait for it to empty */
-	txq->stopped = true;
+	set_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
@@ -683,7 +683,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 
 out:
 	/* Continue using the queue */
-	txq->stopped = false;
+	clear_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	return ret;
 }
-- 
2.39.2



