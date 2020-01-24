Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EEA14801B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgAXLHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgAXLHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:44 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD192071A;
        Fri, 24 Jan 2020 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864064;
        bh=UfEvCiiD+9cXzac4mtmgjfBHVuD/JxIuJFD2LzNidPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wr4pQJW1aPA3S1gLr86f93ffK0iOBEo3bYf7JHsOGumAL+Uf3lDAmD2ikJ4H8AvPb
         OMb3nLTT6IOjAYQLgrxtUizQKDoEfSK1i5/6AclmP77BTGRUOhcUpk8g3KGbFlAd5W
         acipWIGO0iCNHhN22z8izhQDm7fvUEsj92UfuFjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/639] iwlwifi: mvm: avoid possible access out of array.
Date:   Fri, 24 Jan 2020 10:25:18 +0100
Message-Id: <20200124093105.760522533@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit b0d795a9ae558209656b18930c2b4def5f8fdfb8 ]

The value in txq_id can be out of array scope,
validate it before accessing the array.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e850aa504b608..69057701641e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2462,7 +2462,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	u16 normalized_ssn;
-	int txq_id;
+	u16 txq_id;
 	int ret;
 
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
@@ -2506,17 +2506,24 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
 	if (txq_id == IWL_MVM_INVALID_QUEUE) {
-		txq_id = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
-						 IWL_MVM_DQA_MIN_DATA_QUEUE,
-						 IWL_MVM_DQA_MAX_DATA_QUEUE);
-		if (txq_id < 0) {
-			ret = txq_id;
+		ret = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
+					      IWL_MVM_DQA_MIN_DATA_QUEUE,
+					      IWL_MVM_DQA_MAX_DATA_QUEUE);
+		if (ret < 0) {
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto release_locks;
 		}
 
+		txq_id = ret;
+
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
+	} else if (WARN_ON(txq_id >= IWL_MAX_HW_QUEUES)) {
+		ret = -ENXIO;
+		IWL_ERR(mvm, "tid_id %d out of range (0, %d)!\n",
+			tid, IWL_MAX_HW_QUEUES - 1);
+		goto out;
+
 	} else if (unlikely(mvm->queue_info[txq_id].status ==
 			    IWL_MVM_QUEUE_SHARED)) {
 		ret = -ENXIO;
-- 
2.20.1



