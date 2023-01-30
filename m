Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3B6681090
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbjA3OEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbjA3OEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490ED11142
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D925861036
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3CBC433EF;
        Mon, 30 Jan 2023 14:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087472;
        bh=U65pbiX9FuqiQ3xZZPTQyh4tMo1FHfGmx/7+n0LdAAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMkMD8GhaCSoPEB1sphGh8MVW0TMiMAuKiXENo1bj0d9n9y7aQ5Cwaisba7gIcIm1
         R7CHvnbKFseq+f5nKpSw5UHhmXLYHxPe3ztO7VFa5KwXhr0xhEvuDd8fA9SJNp2qDr
         lms8ksb7vQRnuCNUa8JsGrr+SzTWu2FCNkGwfRWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 202/313] wifi: mac80211: Proper mark iTXQs for resumption
Date:   Mon, 30 Jan 2023 14:50:37 +0100
Message-Id: <20230130134346.118629566@linuxfoundation.org>
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

commit 4444bc2116aecdcde87dce80373540adc8bd478b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mac80211.h     |    4 ----
 net/mac80211/debugfs_sta.c |    5 +++--
 net/mac80211/driver-ops.h  |    2 +-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/tx.c          |   23 +++++++++++++++--------
 net/mac80211/util.c        |   20 ++++++--------------
 6 files changed, 26 insertions(+), 30 deletions(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1827,8 +1827,6 @@ struct ieee80211_vif_cfg {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void \*).
  * @txq: the multicast data TX queue (if driver uses the TXQ abstraction)
- * @txqs_stopped: per AC flag to indicate that intermediate TXQs are stopped,
- *	protected by fq->lock.
  * @offload_flags: 802.3 -> 802.11 enapsulation offload flags, see
  *	&enum ieee80211_offload_flags.
  * @mbssid_tx_vif: Pointer to the transmitting interface if MBSSID is enabled.
@@ -1857,8 +1855,6 @@ struct ieee80211_vif {
 	bool probe_req_reg;
 	bool rx_mcast_action_reg;
 
-	bool txqs_stopped[IEEE80211_NUM_ACS];
-
 	struct ieee80211_vif *mbssid_tx_vif;
 
 	/* must be last */
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -167,7 +167,7 @@ static ssize_t sta_aqm_read(struct file
 			continue;
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz + buf - p,
-			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s)\n",
+			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s%s)\n",
 			       txqi->txq.tid,
 			       txqi->txq.ac,
 			       txqi->tin.backlog_bytes,
@@ -182,7 +182,8 @@ static ssize_t sta_aqm_read(struct file
 			       txqi->flags,
 			       test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ? "STOP" : "RUN",
 			       test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags) ? " AMPDU" : "",
-			       test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ? " NO-AMSDU" : "");
+			       test_bit(IEEE80211_TXQ_NO_AMSDU, &txqi->flags) ? " NO-AMSDU" : "",
+			       test_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ? " DIRTY" : "");
 	}
 
 	rcu_read_unlock();
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1183,7 +1183,7 @@ static inline void drv_wake_tx_queue(str
 
 	/* In reconfig don't transmit now, but mark for waking later */
 	if (local->in_reconfig) {
-		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
+		set_bit(IEEE80211_TXQ_DIRTY, &txq->flags);
 		return;
 	}
 
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -836,7 +836,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
-	IEEE80211_TXQ_STOP_NETIF_TX,
+	IEEE80211_TXQ_DIRTY,
 };
 
 /**
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3709,13 +3709,15 @@ struct sk_buff *ieee80211_tx_dequeue(str
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
 	struct ieee80211_hdr *hdr;
-	struct sk_buff *skb = NULL;
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_data tx;
+	struct sk_buff *skb;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	int q = vif->hw_queue[txq->ac];
+	bool q_stopped;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -3723,16 +3725,21 @@ struct sk_buff *ieee80211_tx_dequeue(str
 		return NULL;
 
 begin:
-	spin_lock_bh(&fq->lock);
+	skb = NULL;
+	spin_lock(&local->queue_stop_reason_lock);
+	q_stopped = local->queue_stop_reasons[q];
+	spin_unlock(&local->queue_stop_reason_lock);
+
+	if (unlikely(q_stopped)) {
+		/* mark for waking later */
+		set_bit(IEEE80211_TXQ_DIRTY, &txqi->flags);
+		return NULL;
+	}
 
-	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags) ||
-	    test_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags))
-		goto out;
+	spin_lock_bh(&fq->lock);
 
-	if (vif->txqs_stopped[txq->ac]) {
-		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags);
+	if (unlikely(test_bit(IEEE80211_TXQ_STOP, &txqi->flags)))
 		goto out;
-	}
 
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -301,8 +301,6 @@ static void __ieee80211_wake_txqs(struct
 	local_bh_disable();
 	spin_lock(&fq->lock);
 
-	sdata->vif.txqs_stopped[ac] = false;
-
 	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
 		goto out;
 
@@ -324,7 +322,7 @@ static void __ieee80211_wake_txqs(struct
 			if (ac != txq->ac)
 				continue;
 
-			if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX,
+			if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY,
 						&txqi->flags))
 				continue;
 
@@ -339,7 +337,7 @@ static void __ieee80211_wake_txqs(struct
 
 	txqi = to_txq_info(vif->txq);
 
-	if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags) ||
+	if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
 	    (ps && atomic_read(&ps->num_sta_ps)) || ac != vif->txq->ac)
 		goto out;
 
@@ -537,16 +535,10 @@ static void __ieee80211_stop_queue(struc
 			continue;
 
 		for (ac = 0; ac < n_acs; ac++) {
-			if (sdata->vif.hw_queue[ac] == queue ||
-			    sdata->vif.cab_queue == queue) {
-				if (!local->ops->wake_tx_queue) {
-					netif_stop_subqueue(sdata->dev, ac);
-					continue;
-				}
-				spin_lock(&local->fq.lock);
-				sdata->vif.txqs_stopped[ac] = true;
-				spin_unlock(&local->fq.lock);
-			}
+			if (!local->ops->wake_tx_queue &&
+			    (sdata->vif.hw_queue[ac] == queue ||
+			     sdata->vif.cab_queue == queue))
+				netif_stop_subqueue(sdata->dev, ac);
 		}
 	}
 	rcu_read_unlock();


