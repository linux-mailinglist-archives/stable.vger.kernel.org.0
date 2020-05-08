Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D262C1CAB14
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgEHMjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgEHMji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBB324968;
        Fri,  8 May 2020 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941576;
        bh=wlCN9axulNxMg/Yu3yj1gSmio9/cExS96m3aaLrUHQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ax7GK2X/4QMEs3Ift5sSMQJ629NQjd93CPTybTShZfNHRqkEZdohF8heizHujWoI+
         T5+vArWj0t3DqibO92Gq5484wBQ17Gtid+zu5OfcfgbzxT+h9pMchwUQvY3OUm9Fl7
         5O1TVvO4yz9EI46V/dWHikqz9jPeJSD5SHFXILGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stas Nichiporovich <stasn77@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 087/312] net_sched: keep backlog updated with qlen
Date:   Fri,  8 May 2020 14:31:18 +0200
Message-Id: <20200508123130.664768720@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

commit a27758ffaf96f89002129eedb2cc172d254099f8 upstream.

For gso_skb we only update qlen, backlog should be updated too.

Note, it is correct to just update these stats at one layer,
because the gso_skb is cached there.

Reported-by: Stas Nichiporovich <stasn77@gmail.com>
Fixes: 2ccccf5fb43f ("net_sched: update hierarchical backlog too")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sch_generic.h |    5 ++++-
 net/sched/sch_generic.c   |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -674,9 +674,11 @@ static inline struct sk_buff *qdisc_peek
 	/* we can reuse ->gso_skb because peek isn't called for root qdiscs */
 	if (!sch->gso_skb) {
 		sch->gso_skb = sch->dequeue(sch);
-		if (sch->gso_skb)
+		if (sch->gso_skb) {
 			/* it's still part of the queue */
+			qdisc_qstats_backlog_inc(sch, sch->gso_skb);
 			sch->q.qlen++;
+		}
 	}
 
 	return sch->gso_skb;
@@ -689,6 +691,7 @@ static inline struct sk_buff *qdisc_dequ
 
 	if (skb) {
 		sch->gso_skb = NULL;
+		qdisc_qstats_backlog_dec(sch, skb);
 		sch->q.qlen--;
 	} else {
 		skb = sch->dequeue(sch);
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -49,6 +49,7 @@ static inline int dev_requeue_skb(struct
 {
 	q->gso_skb = skb;
 	q->qstats.requeues++;
+	qdisc_qstats_backlog_inc(q, skb);
 	q->q.qlen++;	/* it's still part of the queue */
 	__netif_schedule(q);
 
@@ -92,6 +93,7 @@ static struct sk_buff *dequeue_skb(struc
 		txq = skb_get_tx_queue(txq->dev, skb);
 		if (!netif_xmit_frozen_or_stopped(txq)) {
 			q->gso_skb = NULL;
+			qdisc_qstats_backlog_dec(q, skb);
 			q->q.qlen--;
 		} else
 			skb = NULL;


