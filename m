Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788F66769D0
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 23:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjAUWjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 17:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjAUWja (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 17:39:30 -0500
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 Jan 2023 14:39:29 PST
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCC2223672
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 14:39:29 -0800 (PST)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674340441;
        bh=P6+ziXRyt9lSBTiYS6tf8C6lTLDbSMjShNMtBVlAcPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=g6pgw7l1LAYR63qDZ9f9hJ3tWzwJeXH1RbcCVNR5ZlhNVbZY0JIoDc2AMvBeFGJni
         U7CVe1R6mRRtxHsz474y1YTVemtIclKqV01NzR7c8pdXWjUgRHysErgBfZXUh3a2TF
         mn4bUUEYyDDwKjYdBALxohcjE9OEa1iaKUUhR4ac=
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org
Subject: [stable v6.1 2/2] wifi: mac80211: Fix iTXQ AMPDU fragmentation handling
Date:   Sat, 21 Jan 2023 23:33:30 +0100
Message-Id: <20230121223330.389255-2-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230121223330.389255-1-alexander@wetzel-home.de>
References: <20230121223330.389255-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of 'commit 592234e941f1 ("wifi: mac80211: Fix iTXQ
AMPDU fragmentation handling")' from linux 6.2.

mac80211 must not enable aggregation wile transmitting a fragmented
MPDU. Enforce that for mac80211 internal TX queues (iTXQs).

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/agg-tx.c |  2 --
 net/mac80211/ht.c     | 37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c     | 13 +++++++------
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 07c892aa8c73..e26a72f3a104 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -511,8 +511,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
-	ieee80211_agg_stop_txq(sta, tid);
-
 	/*
 	 * Make sure no packets are being processed. This ensures that
 	 * we have a valid starting sequence number and that in-flight
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 83bc41346ae7..ae42e956eff5 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -391,6 +391,43 @@ void ieee80211_ba_session_work(struct work_struct *work)
 
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
 		if (!blocked && tid_tx) {
+			struct ieee80211_sub_if_data *sdata = sta->sdata;
+			struct ieee80211_local *local = sdata->local;
+
+			if (local->ops->wake_tx_queue) {
+				struct txq_info *txqi =
+					to_txq_info(sta->sta.txq[tid]);
+				struct fq *fq = &local->fq;
+
+				spin_lock_bh(&fq->lock);
+
+				/* Allow only frags to be dequeued */
+				set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+
+				if (!skb_queue_empty(&txqi->frags)) {
+					/* Fragmented Tx is ongoing, wait for it
+					 * to finish. Reschedule worker to retry
+					 * later.
+					 */
+
+					spin_unlock_bh(&fq->lock);
+					spin_unlock_bh(&sta->lock);
+
+					/* Give the task working on the txq a
+					 * chance to send out the queued frags
+					 */
+					synchronize_net();
+
+					mutex_unlock(&sta->ampdu_mlme.mtx);
+
+					ieee80211_queue_work(&sdata->local->hw,
+							     work);
+					return;
+				}
+
+				spin_unlock_bh(&fq->lock);
+			}
+
 			/*
 			 * Assign it over to the normal tid_tx array
 			 * where it "goes live".
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3363e322cfd9..b114886c66de 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1295,7 +1295,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
 		if (!(tx->flags & IEEE80211_TX_UNICAST) ||
 		    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
-		    info->flags & IEEE80211_TX_CTL_AMPDU)
+		    (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		     !local->ops->wake_tx_queue))
 			info->flags |= IEEE80211_TX_CTL_DONTFRAG;
 	}
 
@@ -3725,7 +3726,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		return NULL;
 
 begin:
-	skb = NULL;
 	spin_lock(&local->queue_stop_reason_lock);
 	q_stopped = local->queue_stop_reasons[q];
 	spin_unlock(&local->queue_stop_reason_lock);
@@ -3738,9 +3738,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&fq->lock);
 
-	if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
-		goto out;
-
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (unlikely(skb)) {
@@ -3750,6 +3747,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		IEEE80211_SKB_CB(skb)->control.flags &=
 			~IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 	} else {
+		if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
+			goto out;
+
 		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	}
 
@@ -3800,7 +3800,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
+		info->flags |= (IEEE80211_TX_CTL_AMPDU |
+				IEEE80211_TX_CTL_DONTFRAG);
 	else
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 
-- 
2.39.0

