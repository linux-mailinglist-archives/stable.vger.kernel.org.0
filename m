Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8066B82A2
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 21:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCMUYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 16:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCMUYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 16:24:43 -0400
X-Greylist: delayed 445 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Mar 2023 13:24:42 PDT
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 168A9898CE;
        Mon, 13 Mar 2023 13:24:42 -0700 (PDT)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1678738614;
        bh=FWa13PF5vbICcpoMfkjNuXTywzZ+euoKLT6Vj7zNeRQ=;
        h=From:To:Cc:Subject:Date;
        b=rTtcAljwQti73nGRizwBDO90eMqSjAGAwdqkhKko9n7nJqLLVp16DTkFFn+rd2y0e
         FuuHBPGEwV9pEQK0eySbmDEjhszN1nhoV8WqIfNuyspNHk/gOE3+ENdqLamqWRMUOA
         oMj6kTjBRAu9iGHK6gr18hlbPqGZx+MgjGJjpZWc=
To:     johannes@sipsolutions.net
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Thomas Mann <rauchwolke@gmx.net>, stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Serialize calls to drv_wake_tx_queue()
Date:   Mon, 13 Mar 2023 21:15:42 +0100
Message-Id: <20230313201542.72325-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

drv_wake_tx_queue() has no protection against running concurrent
multiple times. It's normally executed within the task calling
ndo_start_xmit(). But wake_txqs_tasklet is also calling into it,
regardless if the function is already running on another CPU or not.

While drivers with native iTXQ support are able to handle that, calls to
ieee80211_handle_wake_tx_queue() - used by the drivers without
native iTXQ support - must be serialized. Otherwise drivers can get
unexpected overlapping drv_tx() calls from mac80211. Which causes issues
for at least rt2800usb.

To avoid what seems to be a not needed distinction between native and
drivers using ieee80211_handle_wake_tx_queue(), the serialization is
done for drv_wake_tx_queue() here.

The serialization works by detecting and blocking concurrent calls into
drv_wake_tx_queue() and - when needed - restarting all queues after the
wake_tx_queue ops returned from the driver.

This fix here is only required when a tree has 'c850e31f79f0 ("wifi:
mac80211: add internal handler for wake_tx_queue")', which introduced
the buggy code path in mac80211. Drivers were switched to it with
'a790cc3a4fad ("wifi: mac80211: add wake_tx_queue callback to
drivers")'. But only after fixing an independent bug with commit
'4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")'
problematic concurrent calls to drv_wake_tx_queue() really happened and
exposed the initial issue.

Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
Reported-by: Thomas Mann <rauchwolke@gmx.net>
Tested-by: Thomas Mann <rauchwolke@gmx.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217119
Link: https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.info/
CC: <stable@vger.kernel.org>
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

There are multiple variations how we can fix the issue.

But this fix has to go directly into 6.2 to solve an ongoing
regression.
I tried to prevent an outright redesign while still having a
full fix:

Most questionable decision here probably is, if we should fix it in
drv_wake_tx_queue() or only in ieee80211_handle_wake_tx_queue().
But the decision how to serialize - tasklet vs some kind of locking
- may also be an issue.

Personally, I did not like the overhead of checking all iTXQ for every
drv_wake_tx_queue(). These are happening per-packet AND can be easily
avoided when we are not using a tasklet. Most of the time.

I also assume that drivers don't *want* concurrent drv_wake_tx_queue()
calls and it's a benefit to all drivers to serialize it.

If we consider concurrent calls for drv_wake_tx_queue() to be a feature,
I would just move the code into ieee80211_handle_wake_tx_queue().

Which may also be the solution for the regression in 6.2:
Do it now for ieee80211_handle_wake_tx_queue() and apply this patch
to the development tree only.

We could probably also do it without the queue stops. But then
__ieee80211_wake_queue() needs more modifications.

Thus I ended up with the approach in this patch...

Alexander
---
 net/mac80211/driver-ops.h  | 21 +++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  9 +++++++++
 net/mac80211/util.c        |  3 ++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5d13a3dfd366..8bc4904c32e2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1192,6 +1192,16 @@ drv_tdls_recv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static void handle_aborted_drv_wake_tx_queue(struct ieee80211_hw *hw)
+{
+	ieee80211_stop_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SERIALIZE,
+					false);
+	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SERIALIZE,
+					false);
+}
+
 static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 				     struct txq_info *txq)
 {
@@ -1206,8 +1216,19 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return;
 
+	/* Serialize calls to wake_tx_queue */
+	if (test_and_set_bit(ITXQ_RUN_WAKE_TX_QUEUE_ACTIVE,
+			     &local->itxq_run_flags)) {
+		set_bit(ITXQ_RUN_WAKE_TX_QUEUE_NEEDED, &local->itxq_run_flags);
+		return;
+	}
 	trace_drv_wake_tx_queue(local, sdata, txq);
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
+	clear_bit(ITXQ_RUN_WAKE_TX_QUEUE_ACTIVE, &local->itxq_run_flags);
+
+	if (test_and_clear_bit(ITXQ_RUN_WAKE_TX_QUEUE_NEEDED,
+			       &local->itxq_run_flags))
+		handle_aborted_drv_wake_tx_queue(&local->hw);
 }
 
 static inline void schedule_and_wake_txq(struct ieee80211_local *local,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecc232eb1ee8..42cd32892186 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1197,6 +1197,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN,
 	IEEE80211_QUEUE_STOP_REASON_RESERVE_TID,
 	IEEE80211_QUEUE_STOP_REASON_IFTYPE_CHANGE,
+	IEEE80211_QUEUE_STOP_REASON_SERIALIZE,
 
 	IEEE80211_QUEUE_STOP_REASONS,
 };
@@ -1269,6 +1270,11 @@ enum mac80211_scan_state {
 
 DECLARE_STATIC_KEY_FALSE(aql_disable);
 
+enum itxq_run_flags {
+	ITXQ_RUN_WAKE_TX_QUEUE_ACTIVE,
+	ITXQ_RUN_WAKE_TX_QUEUE_NEEDED,
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
@@ -1284,6 +1290,9 @@ struct ieee80211_local {
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
 
+	/* Used to handle/prevent overlapping calls to drv_wake_tx_queue() */
+	unsigned long itxq_run_flags;
+
 	u16 airtime_flags;
 	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
 	u32 aql_txq_limit_high[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1a28fe5cb614..48483eed4826 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -474,7 +474,8 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	 * release someone's lock, but it is fine because all the callers of
 	 * __ieee80211_wake_queue call it right before releasing the lock.
 	 */
-	if (reason == IEEE80211_QUEUE_STOP_REASON_DRIVER)
+	if (reason == IEEE80211_QUEUE_STOP_REASON_DRIVER ||
+	    reason == IEEE80211_QUEUE_STOP_REASON_SERIALIZE)
 		tasklet_schedule(&local->wake_txqs_tasklet);
 	else
 		_ieee80211_wake_txqs(local, flags);
-- 
2.39.2

