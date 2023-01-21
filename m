Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C796765BB
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 11:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjAUKeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 05:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjAUKep (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 05:34:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDD318A87
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 02:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AEFBB81FA4
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 10:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CE4C433EF;
        Sat, 21 Jan 2023 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674297280;
        bh=J7drozyreC/SiRNoCKm9ffONZoiUlICcbU1+cuyR2p4=;
        h=Subject:To:Cc:From:Date:From;
        b=PL+oW5SjHK6bvq4l0WhX12ncmj6jyvau2Nmipnr0QY1yG9oYrDMIqZ7nTXfwrRNW8
         sOGOB+C5iDCea7FnU1aH2RkWOQ0tnFsY+VsBfL4hh+exMyXd4JdSKGoNuNil6EQF4N
         ER61eDaDzlKljFfSaJwaBm6UH5G3Y0Fs57tJAycM=
Subject: FAILED: patch "[PATCH] wifi: mac80211: Fix iTXQ AMPDU fragmentation handling" failed to apply to 6.1-stable tree
To:     alexander@wetzel-home.de, johannes.berg@intel.com,
        oliver.sang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 Jan 2023 11:26:16 +0100
Message-ID: <167429677624186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

592234e941f1 ("wifi: mac80211: Fix iTXQ AMPDU fragmentation handling")
4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
7d360f6061db ("wifi: mac80211: add support for restricting netdev features per vif")
107395f9cf44 ("wifi: mac80211: Drop support for TX push path")
dfd2d876b3fd ("Merge remote-tracking branch 'wireless/main' into wireless-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 592234e941f1addaa598601c9227e3b72d608625 Mon Sep 17 00:00:00 2001
From: Alexander Wetzel <alexander@wetzel-home.de>
Date: Fri, 6 Jan 2023 23:31:41 +0100
Subject: [PATCH] wifi: mac80211: Fix iTXQ AMPDU fragmentation handling

mac80211 must not enable aggregation wile transmitting a fragmented
MPDU. Enforce that for mac80211 internal TX queues (iTXQs).

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202301021738.7cd3e6ae-oliver.sang@intel.com
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3dbb724d7dc4..f9514bacbd4a 100644
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
index 83bc41346ae7..5315ab750280 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -391,6 +391,37 @@ void ieee80211_ba_session_work(struct work_struct *work)
 
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
 		if (!blocked && tid_tx) {
+			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
+			struct ieee80211_sub_if_data *sdata =
+				vif_to_sdata(txqi->txq.vif);
+			struct fq *fq = &sdata->local->fq;
+
+			spin_lock_bh(&fq->lock);
+
+			/* Allow only frags to be dequeued */
+			set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+
+			if (!skb_queue_empty(&txqi->frags)) {
+				/* Fragmented Tx is ongoing, wait for it to
+				 * finish. Reschedule worker to retry later.
+				 */
+
+				spin_unlock_bh(&fq->lock);
+				spin_unlock_bh(&sta->lock);
+
+				/* Give the task working on the txq a chance
+				 * to send out the queued frags
+				 */
+				synchronize_net();
+
+				mutex_unlock(&sta->ampdu_mlme.mtx);
+
+				ieee80211_queue_work(&sdata->local->hw, work);
+				return;
+			}
+
+			spin_unlock_bh(&fq->lock);
+
 			/*
 			 * Assign it over to the normal tid_tx array
 			 * where it "goes live".
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 178043f84489..defe97a31724 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1129,7 +1129,6 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
 		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
@@ -1161,7 +1160,6 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
-			info->flags |= IEEE80211_TX_CTL_AMPDU;
 			reset_agg_timer = true;
 		} else {
 			queued = true;
@@ -3677,8 +3675,7 @@ static void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	info->band = fast_tx->band;
 	info->control.vif = &sdata->vif;
 	info->flags = IEEE80211_TX_CTL_FIRST_FRAGMENT |
-		      IEEE80211_TX_CTL_DONTFRAG |
-		      (ampdu ? IEEE80211_TX_CTL_AMPDU : 0);
+		      IEEE80211_TX_CTL_DONTFRAG;
 	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT |
 			      u32_encode_bits(IEEE80211_LINK_UNSPECIFIED,
 					      IEEE80211_TX_CTRL_MLO_LINK);
@@ -3804,9 +3801,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&fq->lock);
 
-	if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
-		goto out;
-
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (unlikely(skb)) {
@@ -3816,6 +3810,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		IEEE80211_SKB_CB(skb)->control.flags &=
 			~IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 	} else {
+		if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
+			goto out;
+
 		skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	}
 
@@ -3866,9 +3863,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
-	else
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+		info->flags |= (IEEE80211_TX_CTL_AMPDU |
+				IEEE80211_TX_CTL_DONTFRAG);
 
 	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
 		if (!ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
@@ -4602,8 +4598,6 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
-	if (tid_tx)
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
 
 	info->hw_queue = sdata->vif.hw_queue[queue];
 

