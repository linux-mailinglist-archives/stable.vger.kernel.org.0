Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32856769D1
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 23:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAUWjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 17:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjAUWjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 17:39:31 -0500
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBFCE23676
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 14:39:29 -0800 (PST)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674340441;
        bh=pzs29eIuub6nbHXQVqurtJ14IgF5t1bYsV6ci1wnBEs=;
        h=From:To:Cc:Subject:Date;
        b=jrNV7ywbjNXda7un65WZcWurm3hyyHOmZsP+H/aJY5S4k0K0jlB9l2XwqCh2mpDA3
         vfJQtYGY1E2bcc/BEjXFpvYj/uKMyRRhIRUrilwXMFYSgENN64E+M7GmHTZrsG3jG9
         8Y1Jyq7otys2oaIs+STyIoCHWnHTm0z78Njb70Ro=
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Alexander Wetzel <alexander@wetzel-home.de>,
        stable@vger.kernel.org
Subject: [stable v6.1 1/2] wifi: mac80211: Abort iTXQ runs on queue stop
Date:   Sat, 21 Jan 2023 23:33:29 +0100
Message-Id: <20230121223330.389255-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.39.0
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

This is a backport of 'commit 4444bc2116ae ("wifi: mac80211: Proper mark
iTXQs for resumption")' from linux 6.2.

If a hw queue is stopped ieee80211_tx_dequeue() should abort any
potential running iTXQ run and mark the queue for resumption later.

This also drops the redundant @txqs_stopped and
@IEEE80211_TXQ_STOP_NETIF_TX is renamed to @IEEE80211_TXQ_DIRTY to
better describe the flag.

Additionally this fixes an use-after-free caused by
ieee80211_tx_dequeue() potentially returning a pointer to a deleted skb.

The original 'commit 4444bc2116ae ("wifi: mac80211: Proper mark
iTXQs for resumption")' in 6.2 only fixed the issue only in combination
with 'commit 592234e941f1 ("wifi: mac80211: Fix iTXQ AMPDU fragmentation
handling")'

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/065cf0e5-2c64-56c6-ee66-a6b61be2dddf@roeck-us.net
Link: https://lore.kernel.org/r/20221230121850.218810-1-alexander@wetzel-home.de
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

The automatic backport for this and the next patch failed as expected:
https://lore.kernel.org/r/16742967949726@kroah.com
https://lore.kernel.org/r/167429677624186@kroah.com

Since these patches stack only I've put them into a mini series.
They fix different things but the logic overlaps.

In kernels < 6.2 we still support the old push path and since backporting
'commit 107395f9cf44 ("wifi: mac80211: Drop support for TX push path")'
to stable kernels is a clear no go some changes had to be done to these
patches.

Therefore here are quick manual ports, taking the old push path into
account.
I developed and verified basic functionality with both patches applied
to the v6.1 tree from
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

This versions should also work for kernels < 6.1 with no or minimal
changes.

A quick hostap hwsim test shows no regressions. (Single run, compared to
reference runs I use with wireless-testing kernel)

But it also happened to trigger the KASAN I repored here again:
https://lore.kernel.org/r/20230112173808.6205-1-alexander@wetzel-home.de
So that's indeed an issue in stable...
I'll try to give that another shot with your feedback, soon.

Alexander

---
 include/net/mac80211.h     |  4 ----
 net/mac80211/debugfs_sta.c |  5 +++--
 net/mac80211/driver-ops.h  |  2 +-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/tx.c          | 23 +++++++++++++++--------
 net/mac80211/util.c        | 20 ++++++--------------
 6 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2bad57933f..72b739dc6d53 100644
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
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index d3397c1248d3..b057253db28d 100644
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
index 81e40b0a3b16..e685c12757f4 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1183,7 +1183,7 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 
 	/* In reconfig don't transmit now, but mark for waking later */
 	if (local->in_reconfig) {
-		set_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txq->flags);
+		set_bit(IEEE80211_TXQ_DIRTY, &txq->flags);
 		return;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a842f2e1c230..9027c6354251 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -835,7 +835,7 @@ enum txq_info_flags {
 	IEEE80211_TXQ_STOP,
 	IEEE80211_TXQ_AMPDU,
 	IEEE80211_TXQ_NO_AMSDU,
-	IEEE80211_TXQ_STOP_NETIF_TX,
+	IEEE80211_TXQ_DIRTY,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 874f2a4d831d..3363e322cfd9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3709,13 +3709,15 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
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
 
@@ -3723,16 +3725,21 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
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
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b512cb37aafb..ed53c51bbc32 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -301,8 +301,6 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 	local_bh_disable();
 	spin_lock(&fq->lock);
 
-	sdata->vif.txqs_stopped[ac] = false;
-
 	if (!test_bit(SDATA_STATE_RUNNING, &sdata->state))
 		goto out;
 
@@ -324,7 +322,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 			if (ac != txq->ac)
 				continue;
 
-			if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX,
+			if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY,
 						&txqi->flags))
 				continue;
 
@@ -339,7 +337,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 
 	txqi = to_txq_info(vif->txq);
 
-	if (!test_and_clear_bit(IEEE80211_TXQ_STOP_NETIF_TX, &txqi->flags) ||
+	if (!test_and_clear_bit(IEEE80211_TXQ_DIRTY, &txqi->flags) ||
 	    (ps && atomic_read(&ps->num_sta_ps)) || ac != vif->txq->ac)
 		goto out;
 
@@ -537,16 +535,10 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
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
-- 
2.39.0

