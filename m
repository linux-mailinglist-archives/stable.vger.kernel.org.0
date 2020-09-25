Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0074C278817
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgIYMvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgIYMvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51874206DB;
        Fri, 25 Sep 2020 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038310;
        bh=3SAjjLslOa7DhtpP/JutVXf5V3x4nqiaE7qFDJ8QnY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+XAC8Cka04gGP0b1CHpS14MfrCP7NIIw0WZqbnJWm4BO1GHBLmJg+NDJ0FKDu3Sp
         w7wI8XSLy49k552tCxBBpsELRSHpT8H1tzt/S/RbsBYpdhRLGZ+nvQesPZ9UFRUX1e
         MbOn+PQ5f4ynsVKA/R809tj7bItoDt2iVkFua8jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 23/43] net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc
Date:   Fri, 25 Sep 2020 14:48:35 +0200
Message-Id: <20200925124727.085293168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 2fb541c862c987d02dfdf28f1545016deecfa0d5 ]

Currently there is concurrent reset and enqueue operation for the
same lockless qdisc when there is no lock to synchronize the
q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
qdisc_deactivate() called by dev_deactivate_queue(), which may cause
out-of-bounds access for priv->ring[] in hns3 driver if user has
requested a smaller queue num when __dev_xmit_skb() still enqueue a
skb with a larger queue_mapping after the corresponding qdisc is
reset, and call hns3_nic_net_xmit() with that skb later.

Reused the existing synchronize_net() in dev_deactivate_many() to
make sure skb with larger queue_mapping enqueued to old qdisc(which
is saved in dev_queue->qdisc_sleeping) will always be reset when
dev_reset_queue() is called.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |   49 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1126,27 +1126,36 @@ static void dev_deactivate_queue(struct
 				 struct netdev_queue *dev_queue,
 				 void *_qdisc_default)
 {
-	struct Qdisc *qdisc_default = _qdisc_default;
-	struct Qdisc *qdisc;
+	struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc);
 
-	qdisc = rtnl_dereference(dev_queue->qdisc);
 	if (qdisc) {
-		bool nolock = qdisc->flags & TCQ_F_NOLOCK;
-
-		if (nolock)
-			spin_lock_bh(&qdisc->seqlock);
-		spin_lock_bh(qdisc_lock(qdisc));
-
 		if (!(qdisc->flags & TCQ_F_BUILTIN))
 			set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
+	}
+}
 
-		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		qdisc_reset(qdisc);
+static void dev_reset_queue(struct net_device *dev,
+			    struct netdev_queue *dev_queue,
+			    void *_unused)
+{
+	struct Qdisc *qdisc;
+	bool nolock;
 
-		spin_unlock_bh(qdisc_lock(qdisc));
-		if (nolock)
-			spin_unlock_bh(&qdisc->seqlock);
-	}
+	qdisc = dev_queue->qdisc_sleeping;
+	if (!qdisc)
+		return;
+
+	nolock = qdisc->flags & TCQ_F_NOLOCK;
+
+	if (nolock)
+		spin_lock_bh(&qdisc->seqlock);
+	spin_lock_bh(qdisc_lock(qdisc));
+
+	qdisc_reset(qdisc);
+
+	spin_unlock_bh(qdisc_lock(qdisc));
+	if (nolock)
+		spin_unlock_bh(&qdisc->seqlock);
 }
 
 static bool some_qdisc_is_busy(struct net_device *dev)
@@ -1207,12 +1216,20 @@ void dev_deactivate_many(struct list_hea
 		dev_watchdog_down(dev);
 	}
 
-	/* Wait for outstanding qdisc-less dev_queue_xmit calls.
+	/* Wait for outstanding qdisc-less dev_queue_xmit calls or
+	 * outstanding qdisc enqueuing calls.
 	 * This is avoided if all devices are in dismantle phase :
 	 * Caller will call synchronize_net() for us
 	 */
 	synchronize_net();
 
+	list_for_each_entry(dev, head, close_list) {
+		netdev_for_each_tx_queue(dev, dev_reset_queue, NULL);
+
+		if (dev_ingress_queue(dev))
+			dev_reset_queue(dev, dev_ingress_queue(dev), NULL);
+	}
+
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, close_list) {
 		while (some_qdisc_is_busy(dev))


