Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71983960A7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhEaOan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhEaO1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCAA61C18;
        Mon, 31 May 2021 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468837;
        bh=xs136Bg6mW6wicllv1AN7Mg78ftuu/ttk6nx0tFYyVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJPbQI6J59GYzSj8QvthFK4xvjIsi3DeDJ4yMP0MUQ/s2XNGAoVNUB41FH2qft+t1
         wKeziAt4RHuzh86jzDkXDNq7Fv3TaqJzcrLdwTVLVZ/XI1pei9KoBKDTBhR47rrSvG
         OavRk1Q984oOxFFSfZzIZwU/5W9ZUPEuz5dpsVig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/177] net: sched: fix tx action reschedule issue with stopped queue
Date:   Mon, 31 May 2021 15:15:04 +0200
Message-Id: <20210531130653.011426465@linuxfoundation.org>
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

[ Upstream commit dcad9ee9e0663d74a89b25b987f9c7be86432812 ]

The netdev qeueue might be stopped when byte queue limit has
reached or tx hw ring is full, net_tx_action() may still be
rescheduled if STATE_MISSED is set, which consumes unnecessary
cpu without dequeuing and transmiting any skb because the
netdev queue is stopped, see qdisc_run_end().

This patch fixes it by checking the netdev queue state before
calling qdisc_run() and clearing STATE_MISSED if netdev queue is
stopped during qdisc_run(), the net_tx_action() is rescheduled
again when netdev qeueue is restarted, see netif_tx_wake_queue().

As there is time window between netif_xmit_frozen_or_stopped()
checking and STATE_MISSED clearing, between which STATE_MISSED
may set by net_tx_action() scheduled by netif_tx_wake_queue(),
so set the STATE_MISSED again if netdev queue is restarted.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c          |  3 ++-
 net/sched/sch_generic.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0e38b5b044b6..e226f266da9e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3384,7 +3384,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 	if (q->flags & TCQ_F_NOLOCK) {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-		qdisc_run(q);
+		if (likely(!netif_xmit_frozen_or_stopped(txq)))
+			qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 2b87617d023d..9bc5cbe9809b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -35,6 +35,25 @@
 const struct Qdisc_ops *default_qdisc_ops = &pfifo_fast_ops;
 EXPORT_SYMBOL(default_qdisc_ops);
 
+static void qdisc_maybe_clear_missed(struct Qdisc *q,
+				     const struct netdev_queue *txq)
+{
+	clear_bit(__QDISC_STATE_MISSED, &q->state);
+
+	/* Make sure the below netif_xmit_frozen_or_stopped()
+	 * checking happens after clearing STATE_MISSED.
+	 */
+	smp_mb__after_atomic();
+
+	/* Checking netif_xmit_frozen_or_stopped() again to
+	 * make sure STATE_MISSED is set if the STATE_MISSED
+	 * set by netif_tx_wake_queue()'s rescheduling of
+	 * net_tx_action() is cleared by the above clear_bit().
+	 */
+	if (!netif_xmit_frozen_or_stopped(txq))
+		set_bit(__QDISC_STATE_MISSED, &q->state);
+}
+
 /* Main transmission queue. */
 
 /* Modifications to data participating in scheduling must be protected with
@@ -74,6 +93,7 @@ static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 			}
 		} else {
 			skb = SKB_XOFF_MAGIC;
+			qdisc_maybe_clear_missed(q, txq);
 		}
 	}
 
@@ -242,6 +262,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 			}
 		} else {
 			skb = NULL;
+			qdisc_maybe_clear_missed(q, txq);
 		}
 		if (lock)
 			spin_unlock(lock);
@@ -251,8 +272,10 @@ validate:
 	*validate = true;
 
 	if ((q->flags & TCQ_F_ONETXQUEUE) &&
-	    netif_xmit_frozen_or_stopped(txq))
+	    netif_xmit_frozen_or_stopped(txq)) {
+		qdisc_maybe_clear_missed(q, txq);
 		return skb;
+	}
 
 	skb = qdisc_dequeue_skb_bad_txq(q);
 	if (unlikely(skb)) {
@@ -311,6 +334,8 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		HARD_TX_LOCK(dev, txq, smp_processor_id());
 		if (!netif_xmit_frozen_or_stopped(txq))
 			skb = dev_hard_start_xmit(skb, dev, txq, &ret);
+		else
+			qdisc_maybe_clear_missed(q, txq);
 
 		HARD_TX_UNLOCK(dev, txq);
 	} else {
-- 
2.30.2



