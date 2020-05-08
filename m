Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C41CAB17
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEHMjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgEHMjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FA1A21835;
        Fri,  8 May 2020 12:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941583;
        bh=PMOpUqmgYuZNrw4UaiF8VUB5+5bdL+4SDPEKi9FLarY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GykNHEuH7nuAGkT2HYKGulM30triL64gdasBf07r7PnBcauAN+r+MCGdTr7Fm77k3
         A58a7l2HVUaIk4vhR5IINHQVxUOahNx2SgLUOoXw8DDtc7xwCVo2u21eCI4dqjxOOn
         DF6rTmwGRCYk7ZMewFFy1+QOjs3keLvcH1Xri/kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stas Nichiporovich <stasn77@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 089/312] sch_hfsc: always keep backlog updated
Date:   Fri,  8 May 2020 14:31:20 +0200
Message-Id: <20200508123130.802038856@linuxfoundation.org>
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

commit 357cc9b4a8a7a0cd0e662537b76e6fa4670b6798 upstream.

hfsc updates backlog lazily, that is only when we
dump the stats. This is problematic after we begin to
update backlog in qdisc_tree_reduce_backlog().

Reported-by: Stas Nichiporovich <stasn77@gmail.com>
Tested-by: Stas Nichiporovich <stasn77@gmail.com>
Fixes: 2ccccf5fb43f ("net_sched: update hierarchical backlog too")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_hfsc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1529,6 +1529,7 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	q->eligible = RB_ROOT;
 	INIT_LIST_HEAD(&q->droplist);
 	qdisc_watchdog_cancel(&q->watchdog);
+	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 }
 
@@ -1559,14 +1560,6 @@ hfsc_dump_qdisc(struct Qdisc *sch, struc
 	struct hfsc_sched *q = qdisc_priv(sch);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_hfsc_qopt qopt;
-	struct hfsc_class *cl;
-	unsigned int i;
-
-	sch->qstats.backlog = 0;
-	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry(cl, &q->clhash.hash[i], cl_common.hnode)
-			sch->qstats.backlog += cl->qdisc->qstats.backlog;
-	}
 
 	qopt.defcls = q->defcls;
 	if (nla_put(skb, TCA_OPTIONS, sizeof(qopt), &qopt))
@@ -1604,6 +1597,7 @@ hfsc_enqueue(struct sk_buff *skb, struct
 	if (cl->qdisc->q.qlen == 1)
 		set_active(cl, qdisc_pkt_len(skb));
 
+	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
 	return NET_XMIT_SUCCESS;
@@ -1672,6 +1666,7 @@ hfsc_dequeue(struct Qdisc *sch)
 
 	qdisc_unthrottled(sch);
 	qdisc_bstats_update(sch, skb);
+	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;
 
 	return skb;
@@ -1695,6 +1690,7 @@ hfsc_drop(struct Qdisc *sch)
 			}
 			cl->qstats.drops++;
 			qdisc_qstats_drop(sch);
+			sch->qstats.backlog -= len;
 			sch->q.qlen--;
 			return len;
 		}


