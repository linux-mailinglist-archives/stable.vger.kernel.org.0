Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63B1CAB1A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEHMjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgEHMjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ECFD20731;
        Fri,  8 May 2020 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941593;
        bh=pDBilO5BYbBjxdbM9aR4UMZzJhRiR6hKSFP+rpMXcv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJnMfgE1OrS0fr67zbKn5NbxVbXeC3CZiW0UsqFIiMn6wVkdRyKnDjJAlfBNODS4A
         6MUDHfISVFVhIurcvvhqIviWULKIZ7RrVv98uZOpGnI9xH6JnTnO44yn4aJZMfhGa5
         72hSKvbq/KcnZPfgr36UeInEqX7gdbVI7gslwWnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 093/312] sch_tbf: update backlog as well
Date:   Fri,  8 May 2020 14:31:24 +0200
Message-Id: <20200508123131.078649814@linuxfoundation.org>
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

commit 8d5958f424b62060a8696b12c17dad198d5d386f upstream.

Fixes: 2ccccf5fb43f ("net_sched: update hierarchical backlog too")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_tbf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -197,6 +197,7 @@ static int tbf_enqueue(struct sk_buff *s
 		return ret;
 	}
 
+	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 	return NET_XMIT_SUCCESS;
 }
@@ -207,6 +208,7 @@ static unsigned int tbf_drop(struct Qdis
 	unsigned int len = 0;
 
 	if (q->qdisc->ops->drop && (len = q->qdisc->ops->drop(q->qdisc)) != 0) {
+		sch->qstats.backlog -= len;
 		sch->q.qlen--;
 		qdisc_qstats_drop(sch);
 	}
@@ -253,6 +255,7 @@ static struct sk_buff *tbf_dequeue(struc
 			q->t_c = now;
 			q->tokens = toks;
 			q->ptokens = ptoks;
+			qdisc_qstats_backlog_dec(sch, skb);
 			sch->q.qlen--;
 			qdisc_unthrottled(sch);
 			qdisc_bstats_update(sch, skb);
@@ -284,6 +287,7 @@ static void tbf_reset(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
+	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 	q->t_c = ktime_get_ns();
 	q->tokens = q->buffer;


