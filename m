Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DB63960A4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhEaOam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhEaO1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CAB861A46;
        Mon, 31 May 2021 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468835;
        bh=ps9DlDNrekP1h8c40R8JI437WVegLydQRC6coA+0inA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OWV4QbEPEP2S0JybLQVkf5DK00A7n5PtLQu0ynrXalfzbAw/lCbt4mXuvYWJEqCa
         V3Xcd5s3byqB9YgzetLBRO0/z7KRtVztv7Cb+38+iOFHPDhZATUUq91yS1F5kirdBa
         htSFo5DetDWhZZhv96O1eTc81ulNJlS3qK4/g1a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/177] net: sched: fix tx action rescheduling issue during deactivation
Date:   Mon, 31 May 2021 15:15:03 +0200
Message-Id: <20210531130652.974837697@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 102b55ee92f9fda4dde7a45d2b20538e6e3e3d1e ]

Currently qdisc_run() checks the STATE_DEACTIVATED of lockless
qdisc before calling __qdisc_run(), which ultimately clear the
STATE_MISSED when all the skb is dequeued. If STATE_DEACTIVATED
is set before clearing STATE_MISSED, there may be rescheduling
of net_tx_action() at the end of qdisc_run_end(), see below:

CPU0(net_tx_atcion)  CPU1(__dev_xmit_skb)  CPU2(dev_deactivate)
          .                   .                     .
          .            set STATE_MISSED             .
          .           __netif_schedule()            .
          .                   .           set STATE_DEACTIVATED
          .                   .                qdisc_reset()
          .                   .                     .
          .<---------------   .              synchronize_net()
clear __QDISC_STATE_SCHED  |  .                     .
          .                |  .                     .
          .                |  .            some_qdisc_is_busy()
          .                |  .               return *false*
          .                |  .                     .
  test STATE_DEACTIVATED   |  .                     .
__qdisc_run() *not* called |  .                     .
          .                |  .                     .
   test STATE_MISS         |  .                     .
 __netif_schedule()--------|  .                     .
          .                   .                     .
          .                   .                     .

__qdisc_run() is not called by net_tx_atcion() in CPU0 because
CPU2 has set STATE_DEACTIVATED flag during dev_deactivate(), and
STATE_MISSED is only cleared in __qdisc_run(), __netif_schedule
is called at the end of qdisc_run_end(), causing tx action
rescheduling problem.

qdisc_run() called by net_tx_action() runs in the softirq context,
which should has the same semantic as the qdisc_run() called by
__dev_xmit_skb() protected by rcu_read_lock_bh(). And there is a
synchronize_net() between STATE_DEACTIVATED flag being set and
qdisc_reset()/some_qdisc_is_busy in dev_deactivate(), we can safely
bail out for the deactived lockless qdisc in net_tx_action(), and
qdisc_reset() will reset all skb not dequeued yet.

So add the rcu_read_lock() explicitly to protect the qdisc_run()
and do the STATE_DEACTIVATED checking in net_tx_action() before
calling qdisc_run_begin(). Another option is to do the checking in
the qdisc_run_end(), but it will add unnecessary overhead for
non-tx_action case, because __dev_queue_xmit() will not see qdisc
with STATE_DEACTIVATED after synchronize_net(), the qdisc with
STATE_DEACTIVATED can only be seen by net_tx_action() because of
__netif_schedule().

The STATE_DEACTIVATED checking in qdisc_run() is to avoid race
between net_tx_action() and qdisc_reset(), see:
commit d518d2ed8640 ("net/sched: fix race between deactivation
and dequeue for NOLOCK qdisc"). As the bailout added above for
deactived lockless qdisc in net_tx_action() provides better
protection for the race without calling qdisc_run() at all, so
remove the STATE_DEACTIVATED checking in qdisc_run().

After qdisc_reset(), there is no skb in qdisc to be dequeued, so
clear the STATE_MISSED in dev_reset_queue() too.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
V8: Clearing STATE_MISSED before calling __netif_schedule() has
    avoid the endless rescheduling problem, but there may still
    be a unnecessary rescheduling, so adjust the commit log.
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h |  7 +------
 net/core/dev.c          | 26 ++++++++++++++++++++++----
 net/sched/sch_generic.c |  4 +++-
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index cee1c084e9f4..b16f9236de14 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -118,12 +118,7 @@ void __qdisc_run(struct Qdisc *q);
 static inline void qdisc_run(struct Qdisc *q)
 {
 	if (qdisc_run_begin(q)) {
-		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
-		 * to avoid racing with dev_qdisc_reset()
-		 */
-		if (!(q->flags & TCQ_F_NOLOCK) ||
-		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
-			__qdisc_run(q);
+		__qdisc_run(q);
 		qdisc_run_end(q);
 	}
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index a30878346f54..0e38b5b044b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4515,25 +4515,43 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 		sd->output_queue_tailp = &sd->output_queue;
 		local_irq_enable();
 
+		rcu_read_lock();
+
 		while (head) {
 			struct Qdisc *q = head;
 			spinlock_t *root_lock = NULL;
 
 			head = head->next_sched;
 
-			if (!(q->flags & TCQ_F_NOLOCK)) {
-				root_lock = qdisc_lock(q);
-				spin_lock(root_lock);
-			}
 			/* We need to make sure head->next_sched is read
 			 * before clearing __QDISC_STATE_SCHED
 			 */
 			smp_mb__before_atomic();
+
+			if (!(q->flags & TCQ_F_NOLOCK)) {
+				root_lock = qdisc_lock(q);
+				spin_lock(root_lock);
+			} else if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
+						     &q->state))) {
+				/* There is a synchronize_net() between
+				 * STATE_DEACTIVATED flag being set and
+				 * qdisc_reset()/some_qdisc_is_busy() in
+				 * dev_deactivate(), so we can safely bail out
+				 * early here to avoid data race between
+				 * qdisc_deactivate() and some_qdisc_is_busy()
+				 * for lockless qdisc.
+				 */
+				clear_bit(__QDISC_STATE_SCHED, &q->state);
+				continue;
+			}
+
 			clear_bit(__QDISC_STATE_SCHED, &q->state);
 			qdisc_run(q);
 			if (root_lock)
 				spin_unlock(root_lock);
 		}
+
+		rcu_read_unlock();
 	}
 
 	xfrm_dev_backlog(sd);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 0723e7858658..2b87617d023d 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1176,8 +1176,10 @@ static void dev_reset_queue(struct net_device *dev,
 	qdisc_reset(qdisc);
 
 	spin_unlock_bh(qdisc_lock(qdisc));
-	if (nolock)
+	if (nolock) {
+		clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
 		spin_unlock_bh(&qdisc->seqlock);
+	}
 }
 
 static bool some_qdisc_is_busy(struct net_device *dev)
-- 
2.30.2



