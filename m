Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE916765BC
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjAUKes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 05:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjAUKeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 05:34:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDACE4AA4C
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 02:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2412A60B5A
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 10:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35291C433D2;
        Sat, 21 Jan 2023 10:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674297283;
        bh=z8FvEe2p5wYNfotB1LCgBRH8Z41SzIHkzxTJz0aYnfU=;
        h=Subject:To:Cc:From:Date:From;
        b=lIPzUiukWwuIV1L3lTerGZiLShpxJ7V1ERXC358i3xzuIk6uxE3UfqxPH8QRDy/p0
         r7V785uSJ6QN6/7T0nF6u5GyScV+x4fRHyKL92CVduB59tTc4Q4pO4lm+Wlzf+5vyN
         9n+114Ga4Z3e0g1Cjw0rq/Sd0O5pZwmg0EUlRdj0=
Subject: FAILED: patch "[PATCH] wifi: mac80211: Proper mark iTXQs for resumption" failed to apply to 6.1-stable tree
To:     alexander@wetzel-home.de, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 Jan 2023 11:26:34 +0100
Message-ID: <16742967949726@kroah.com>
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

4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")
107395f9cf44 ("wifi: mac80211: Drop support for TX push path")
dfd2d876b3fd ("Merge remote-tracking branch 'wireless/main' into wireless-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4444bc2116aecdcde87dce80373540adc8bd478b Mon Sep 17 00:00:00 2001
From: Alexander Wetzel <alexander@wetzel-home.de>
Date: Fri, 30 Dec 2022 13:18:49 +0100
Subject: [PATCH] wifi: mac80211: Proper mark iTXQs for resumption

When a running wake_tx_queue() call is aborted due to a hw queue stop
the corresponding iTXQ is not always correctly marked for resumption:
wake_tx_push_queue() can stops the queue run without setting
@IEEE80211_TXQ_STOP_NETIF_TX.

Without the @IEEE80211_TXQ_STOP_NETIF_TX flag __ieee80211_wake_txqs()
will not schedule a new queue run and remaining frames in the queue get
stuck till another frame is queued to it.

Fix the issue for all drivers - also the ones with custom wake_tx_queue
callbacks - by moving the logic into ieee80211_tx_dequeue() and drop the
redundant @txqs_stopped.

@IEEE80211_TXQ_STOP_NETIF_TX is also renamed to @IEEE80211_TXQ_DIRTY to
better describe the flag.

Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20221230121850.218810-1-alexander@wetzel-home.de
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 689da327ce2e..e3235b9c02c2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1832,8 +1832,6 @@ struct ieee80211_vif_cfg {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void \*).
  * @txq: the multicast data TX queue
- * @txqs_stopped: per AC flag to indicate that intermediate TXQs are stopped,
- *	protected by fq->lock.
  * @offload_flags: 802.3 -> 802.11 enapsulation offload flags, see
  *	&enum ieee80211_offload_flags.
  * @mbssid_tx_vif: Pointer to the transmitting interface if MBSSID is enabled.
@@ -1863,8 +1861,6 @@ struct ieee80211_vif {
 	bool probe_req_reg;
 	bool rx_mcast_action_reg;
 
-	bool txqs_stopped[IEEE80211_NUM_ACS];
-
 	struct ieee80211_vif *mbssid_tx_vif;
 
 	/* must be last */
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 7a3d7893e19d..f1914bf39f0e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -167,7 +167,7 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			continue;
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz + buf - p,
-			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s)\n",
+			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s%s)\n",
 			       txqi->txq.tid,
 			       txqi->txq.ac,
 			       txqi->tin.backlog_bytes,
@@ -182,7 +182,8 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 			       txqi->flags,
 			       test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ? "STOP" : "RUN",
 			       test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags) ? " AMPDU" : "",
-			       test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ? " NO-AMSDU" : "");
+			       test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ? " NO-AMSDU" : "",
+			       test_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ? " DIRTY" : "");
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 809bad53e15b..5d13a3dfd366 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1199,7 +1199,7 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 
 	/* In reconfig don't transmit now, but mark for waking later */
 	if (local->in_reconfig) {
-		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
+		set_bit(IEEE80211_TXQ_DIRTY, &txq->flags);
 		return;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 63ff0d2524b6..d16606e84e22 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -838,7 +838,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
-	IEEE80211_TXQ_STOP_NETIF_TX,
+	IEEE80211_TXQ_DIRTY,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2171cd1ca807..178043f84489 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3783,6 +3783,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	int q = vif->hw_queue[txq->ac];
+	bool q_stopped;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -3790,16 +3792,20 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		return NULL;
 
 begin:
-	spin_lock_bh(&fq->lock);
+	spin_lock(&local->queue_stop_reason_lock);
+	q_stopped = local->queue_stop_reasons[q];
+	spin_unlock(&local->queue_stop_reason_lock);
 
-	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ||
-	    test_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags))
-		goto out;
+	if (unlikely(q_stopped)) {
+		/* mark for waking later */
+		set_bit(IEEE80211_TXQ_DIRTY, &txqi->flags);
+		return NULL;
+	}
 
-	if (vif->txqs_stopped[txq->ac]) {
-		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags);
+	spin_lock_bh(&fq->lock);
+
+	if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
 		goto out;
-	}
 
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6f5407038459..261ac667887f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -292,22 +292,12 @@ static void wake_tx_push_queue(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_txq *queue)
 {
-	int q = sdata->vif.hw_queue[queue->ac];
 	struct ieee80211_tx_control control = {
 		.sta = queue->sta,
 	};
 	struct sk_buff *skb;
-	unsigned long flags;
-	bool q_stopped;
 
 	while (1) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		q_stopped = local->queue_stop_reasons[q];
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-
-		if (q_stopped)
-			break;
-
 		skb = ieee80211_tx_dequeue(&local->hw, queue);
 		if (!skb)
 			break;
@@ -347,8 +337,6 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	local_bh_disable();
 	spin_lock(&fq->lock);
 
-	sdata->vif.txqs_stopped[ac] = false;
-
 	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
 		goto out;
 
@@ -370,7 +358,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 			if (ac != txq->ac)
 				continue;
 
-			if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX,
+			if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY,
 						&txqi->flags))
 				continue;
 
@@ -385,7 +373,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 
 	txqi = to_txq_info(vif->txq);
 
-	if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags) ||
+	if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
 	    (ps && atomic_read(&ps->num_sta_ps)) || ac != vif->txq->ac)
 		goto out;
 
@@ -517,8 +505,6 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 				   bool refcounted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
-	int n_acs = IEEE80211_NUM_ACS;
 
 	trace_stop_queue(local, queue, reason);
 
@@ -530,29 +516,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	else
 		local->q_stop_reasons[queue][reason]++;
 
-	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
-		return;
-
-	if (local->hw.queues < IEEE80211_NUM_ACS)
-		n_acs = 1;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		int ac;
-
-		if (!sdata->dev)
-			continue;
-
-		for (ac = 0; ac < n_acs; ac++) {
-			if (sdata->vif.hw_queue[ac] == queue ||
-			    sdata->vif.cab_queue == queue) {
-				spin_lock(&local->fq.lock);
-				sdata->vif.txqs_stopped[ac] = true;
-				spin_unlock(&local->fq.lock);
-			}
-		}
-	}
-	rcu_read_unlock();
+	set_bit(reason, &local->queue_stop_reasons[queue]);
 }
 
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,

