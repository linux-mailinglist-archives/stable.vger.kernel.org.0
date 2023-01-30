Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA69168109C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbjA3OFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbjA3OFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1801B13D5C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F97861026
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C51FC4339B;
        Mon, 30 Jan 2023 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087506;
        bh=o8Gh7NTXKb+nGnOzWOA0gXN2mSnZqAXiIsHFkMSsGY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLqSmOzP2NvTGnLyiQfLRSxcsxu+z5KNvoQImbQexchQWEYllHiAZ/Q3zUD5FPFxp
         jAJf7DHyTBMdRhOP/7w0SR+Xkav7ttQGOV8tagzNFzqSIP5SfXq8I9pS/y1FZLy+y9
         CfWcNSqjRlsSRPViDN09f/0yxE4ApZoWWb6Ma7BE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 203/313] wifi: mac80211: Fix iTXQ AMPDU fragmentation handling
Date:   Mon, 30 Jan 2023 14:50:38 +0100
Message-Id: <20230130134346.160692158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 592234e941f1addaa598601c9227e3b72d608625 upstream.

mac80211 must not enable aggregation wile transmitting a fragmented
MPDU. Enforce that for mac80211 internal TX queues (iTXQs).

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202301021738.7cd3e6ae-oliver.sang@intel.com
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/agg-tx.c |    2 --
 net/mac80211/ht.c     |   37 +++++++++++++++++++++++++++++++++++++
 net/mac80211/tx.c     |   13 +++++++------
 3 files changed, 44 insertions(+), 8 deletions(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -511,8 +511,6 @@ void ieee80211_tx_ba_session_handle_star
 	 */
 	clear_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
-	ieee80211_agg_stop_txq(sta, tid);
-
 	/*
 	 * Make sure no packets are being processed. This ensures that
 	 * we have a valid starting sequence number and that in-flight
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -391,6 +391,43 @@ void ieee80211_ba_session_work(struct wo
 
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
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1295,7 +1295,8 @@ ieee80211_tx_prepare(struct ieee80211_su
 	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
 		if (!(tx->flags & IEEE80211_TX_UNICAST) ||
 		    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
-		    info->flags & IEEE80211_TX_CTL_AMPDU)
+		    (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		     !local->ops->wake_tx_queue))
 			info->flags |= IEEE80211_TX_CTL_DONTFRAG;
 	}
 
@@ -3725,7 +3726,6 @@ struct sk_buff *ieee80211_tx_dequeue(str
 		return NULL;
 
 begin:
-	skb = NULL;
 	spin_lock(&local->queue_stop_reason_lock);
 	q_stopped = local->queue_stop_reasons[q];
 	spin_unlock(&local->queue_stop_reason_lock);
@@ -3738,9 +3738,6 @@ begin:
 
 	spin_lock_bh(&fq->lock);
 
-	if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
-		goto out;
-
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (unlikely(skb)) {
@@ -3750,6 +3747,9 @@ begin:
 		IEEE80211_SKB_CB(skb)->control.flags &=
 			~IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 	} else {
+		if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
+			goto out;
+
 		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	}
 
@@ -3800,7 +3800,8 @@ begin:
 	}
 
 	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
+		info->flags |= (IEEE80211_TX_CTL_AMPDU |
+				IEEE80211_TX_CTL_DONTFRAG);
 	else
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 


