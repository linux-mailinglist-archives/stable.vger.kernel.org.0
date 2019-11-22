Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB71106E09
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbfKVLFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbfKVLF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A862E20870;
        Fri, 22 Nov 2019 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420729;
        bh=UOl0yxohjGVB5kn0B0kvKXhbib289mdwk/+Id492Zgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7M8sJEwpa1hPmcWXFDGuqPILg2ugBCyiUsUdEgtX6F3j+DEQJLa9rH7mQD4ThX76
         hgcsivNGXn75I/2c7XN/NzliXr+CVCEFYAc2rDO5W+A0JJT7J0fvBBKg92LCy9oryD
         inB1xO9sm+BePCo87Og0OWL4L0NGQiyMpSH6T+44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/220] net: sched: avoid writing on noop_qdisc
Date:   Fri, 22 Nov 2019 11:29:30 +0100
Message-Id: <20191122100928.564216161@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f98ebd47fd0da1717267ce1583a105d8cc29a16a ]

While noop_qdisc.gso_skb and noop_qdisc.skb_bad_txq are not used
in other places, it seems not correct to overwrite their fields
in dev_init_scheduler_queue().

noop_qdisc is essentially a shared and read-only object, even if
it is not marked as const because of some implementation detail.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 30e32df5f84a7..8a4d01e427a22 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -577,6 +577,18 @@ struct Qdisc noop_qdisc = {
 	.dev_queue	=	&noop_netdev_queue,
 	.running	=	SEQCNT_ZERO(noop_qdisc.running),
 	.busylock	=	__SPIN_LOCK_UNLOCKED(noop_qdisc.busylock),
+	.gso_skb = {
+		.next = (struct sk_buff *)&noop_qdisc.gso_skb,
+		.prev = (struct sk_buff *)&noop_qdisc.gso_skb,
+		.qlen = 0,
+		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.gso_skb.lock),
+	},
+	.skb_bad_txq = {
+		.next = (struct sk_buff *)&noop_qdisc.skb_bad_txq,
+		.prev = (struct sk_buff *)&noop_qdisc.skb_bad_txq,
+		.qlen = 0,
+		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
+	},
 };
 EXPORT_SYMBOL(noop_qdisc);
 
@@ -1253,8 +1265,6 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 	rcu_assign_pointer(dev_queue->qdisc, qdisc);
 	dev_queue->qdisc_sleeping = qdisc;
-	__skb_queue_head_init(&qdisc->gso_skb);
-	__skb_queue_head_init(&qdisc->skb_bad_txq);
 }
 
 void dev_init_scheduler(struct net_device *dev)
-- 
2.20.1



