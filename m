Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C8D6BBCF4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 20:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjCOTIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 15:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCOTIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 15:08:20 -0400
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42A74367D1;
        Wed, 15 Mar 2023 12:08:16 -0700 (PDT)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1678907294;
        bh=hboU3nCpAiJEYM8n0nMgo2TM2IaqZKNkdw2KypJ7a/U=;
        h=From:To:Cc:Subject:Date;
        b=yRCiylrSmeyfXMco2g8g2EzjKpXoD7INChjQK8LpdNxeEbBPVVvgJBStRUbN2n1CE
         ZLo0uoqf3ch6OkX1Z1r6I/8QOMfhvnk0PXt24SvVqSEttnKG4nRtFPrLKKkxiebw5J
         5u/2YyN2Dt0+S4EfBorNMOw1mpwB0VsA2aHbc/dg=
To:     johannes@sipsolutions.net
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org
Subject: [PATCH v2] wifi: mac80211: Serialize ieee80211_handle_wake_tx_queue()
Date:   Wed, 15 Mar 2023 20:07:31 +0100
Message-Id: <20230315190731.145997-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ieee80211_handle_wake_tx_queue must not run concurrent.
It calls ieee80211_txq_schedule_start() and the drivers migrated to iTXQ
do not expect overlapping drv_tx() calls.

This fixes commit c850e31f79f0 ("wifi: mac80211: add internal handler
for wake_tx_queue"), which introduced ieee80211_handle_wake_tx_queue().
Drivers started to use it with commit a790cc3a4fad ("wifi: mac80211: add
wake_tx_queue callback to drivers").
But only after fixing an independent bug with commit 4444bc2116ae
("wifi: mac80211: Proper mark iTXQs for resumption") problematic
concurrent calls really happened and exposed the initial issue.

Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
Reported-by: Thomas Mann <rauchwolke@gmx.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217119
Link: https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.info/
Link: https://lore.kernel.org/r/b7445607128a6b9ed7c17fcdcf3679bfaf4aaea.camel@sipsolutions.net>
CC: <stable@vger.kernel.org>
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

V1..V2
Added the missing spinlock Felix pointed out and fixed the commit
references with the feedback from Kalle.
---
 net/mac80211/ieee80211_i.h | 3 +++
 net/mac80211/main.c        | 1 +
 net/mac80211/util.c        | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecc232eb1ee8..e082582e0aa2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1284,6 +1284,9 @@ struct ieee80211_local {
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
 
+	/* serializes ieee80211_handle_wake_tx_queue */
+	spinlock_t handle_wake_tx_queue_lock;
+
 	u16 airtime_flags;
 	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
 	u32 aql_txq_limit_high[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 846528850612..3b622f2b787b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -788,6 +788,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
+	spin_lock_init(&local->handle_wake_tx_queue_lock);
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		INIT_LIST_HEAD(&local->active_txqs[i]);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1a28fe5cb614..3aceb3b731bf 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -314,6 +314,8 @@ void ieee80211_handle_wake_tx_queue(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
 	struct ieee80211_txq *queue;
 
+	spin_lock(&local->handle_wake_tx_queue_lock);
+
 	/* Use ieee80211_next_txq() for airtime fairness accounting */
 	ieee80211_txq_schedule_start(hw, txq->ac);
 	while ((queue = ieee80211_next_txq(hw, txq->ac))) {
@@ -321,6 +323,7 @@ void ieee80211_handle_wake_tx_queue(struct ieee80211_hw *hw,
 		ieee80211_return_txq(hw, queue, false);
 	}
 	ieee80211_txq_schedule_end(hw, txq->ac);
+	spin_unlock(&local->handle_wake_tx_queue_lock);
 }
 EXPORT_SYMBOL(ieee80211_handle_wake_tx_queue);
 
-- 
2.39.2

