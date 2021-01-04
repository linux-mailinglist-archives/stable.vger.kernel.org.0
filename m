Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3489B2E9A4B
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbhADQIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbhADQBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1630722517;
        Mon,  4 Jan 2021 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776071;
        bh=6ZFO6dNUvqzzSNhreWV5/PZn8CZ3Sn0s8x1yn0pqgQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VPuEt7q4e26r0hosDX6Xa7FBvlInC1iLZLA40RBoMaFjWeoqRunAx1lMbmm07KjT
         L/uBNAwDCYMJ1scZB2KEB1VUciy2DyLjadHi71IeYino5pwN+VRbyPcWjK1Iy2xnR4
         q7qncBT3qIWYSFAftmeeG0ZUa88NPhxgDI2zdeAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com,
        Davide Caratti <dcaratti@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 01/63] net/sched: sch_taprio: reset child qdiscs before freeing them
Date:   Mon,  4 Jan 2021 16:56:54 +0100
Message-Id: <20210104155708.875695855@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 44d4775ca51805b376a8db5b34f650434a08e556 ]

syzkaller shows that packets can still be dequeued while taprio_destroy()
is running. Let sch_taprio use the reset() function to cancel the advance
timer and drop all skbs from the child qdiscs.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Link: https://syzkaller.appspot.com/bug?id=f362872379bf8f0017fb667c1ab158f2d1e764ae
Reported-by: syzbot+8971da381fb5a31f542d@syzkaller.appspotmail.com
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1596,6 +1596,21 @@ free_sched:
 	return err;
 }
 
+static void taprio_reset(struct Qdisc *sch)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int i;
+
+	hrtimer_cancel(&q->advance_timer);
+	if (q->qdiscs) {
+		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
+			qdisc_reset(q->qdiscs[i]);
+	}
+	sch->qstats.backlog = 0;
+	sch->q.qlen = 0;
+}
+
 static void taprio_destroy(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1606,7 +1621,6 @@ static void taprio_destroy(struct Qdisc
 	list_del(&q->taprio_list);
 	spin_unlock(&taprio_list_lock);
 
-	hrtimer_cancel(&q->advance_timer);
 
 	taprio_disable_offload(dev, q, NULL);
 
@@ -1953,6 +1967,7 @@ static struct Qdisc_ops taprio_qdisc_ops
 	.init		= taprio_init,
 	.change		= taprio_change,
 	.destroy	= taprio_destroy,
+	.reset		= taprio_reset,
 	.peek		= taprio_peek,
 	.dequeue	= taprio_dequeue,
 	.enqueue	= taprio_enqueue,


