Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ED712179C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfLPSGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbfLPSF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5AA20733;
        Mon, 16 Dec 2019 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519558;
        bh=FRtwolZSfoLpput8mu1bah8CEizgvrjVeDj+1BvLqDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fprXEEh2RCbgCiX3AG+TBW1u15T0TYGYrB9YGz5JhctXFZWG4aDVMWKydqXNJDfHK
         nCyMhkiCRepC7yZVT5UqMwzYJRutekeqY6m8PcFkQPEjxT7OqvmUslqInyMcHEvgM1
         NUxLYQyPY3DGFEI/OiL/YO6/f4VWCU8M2HDmUWN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pete Heist <pete@heistp.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/140] sch_cake: Correctly update parent qlen when splitting GSO packets
Date:   Mon, 16 Dec 2019 18:49:43 +0100
Message-Id: <20191216174818.717932404@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 8c6c37fdc20ec9ffaa342f827a8e20afe736fb0c ]

To ensure parent qdiscs have the same notion of the number of enqueued
packets even after splitting a GSO packet, update the qdisc tree with the
number of packets that was added due to the split.

Reported-by: Pete Heist <pete@heistp.net>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 9fd37d91b5ed0..e4cf72b0675e1 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1666,7 +1666,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (skb_is_gso(skb) && q->rate_flags & CAKE_FLAG_SPLIT_GSO) {
 		struct sk_buff *segs, *nskb;
 		netdev_features_t features = netif_skb_features(skb);
-		unsigned int slen = 0;
+		unsigned int slen = 0, numsegs = 0;
 
 		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 		if (IS_ERR_OR_NULL(segs))
@@ -1682,6 +1682,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			flow_queue_add(flow, segs);
 
 			sch->q.qlen++;
+			numsegs++;
 			slen += segs->len;
 			q->buffer_used += segs->truesize;
 			b->packets++;
@@ -1695,7 +1696,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		sch->qstats.backlog += slen;
 		q->avg_window_bytes += slen;
 
-		qdisc_tree_reduce_backlog(sch, 1, len);
+		qdisc_tree_reduce_backlog(sch, 1-numsegs, len-slen);
 		consume_skb(skb);
 	} else {
 		/* not splitting */
-- 
2.20.1



