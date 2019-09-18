Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF49B5D01
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfIRGaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbfIRGYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 413BD21920;
        Wed, 18 Sep 2019 06:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787858;
        bh=QX/ODPROnjlsW3TmwXUDdR+0VJvtH9gWlChsXjJEceg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asga7kpF6+EzMTm/etNTLuRky8/wegQbz1qb2UnSGTeikJIGTDdXlBa5govZnvcy6
         EIi/57elGMOdvPyY1JX+6TJmWxVujfyFmCcJBqJcD6uBwtYt21EwHo2pVHe3l9et1x
         HfrDWfMxqDz1oPk8Wy/ibrWyaPHeRgMM+Frle7gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 10/85] net: sched: fix reordering issues
Date:   Wed, 18 Sep 2019 08:18:28 +0200
Message-Id: <20190918061234.460383725@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b88dd52c62bb5c5d58f0963287f41fd084352c57 ]

Whenever MQ is not used on a multiqueue device, we experience
serious reordering problems. Bisection found the cited
commit.

The issue can be described this way :

- A single qdisc hierarchy is shared by all transmit queues.
  (eg : tc qdisc replace dev eth0 root fq_codel)

- When/if try_bulk_dequeue_skb_slow() dequeues a packet targetting
  a different transmit queue than the one used to build a packet train,
  we stop building the current list and save the 'bad' skb (P1) in a
  special queue. (bad_txq)

- When dequeue_skb() calls qdisc_dequeue_skb_bad_txq() and finds this
  skb (P1), it checks if the associated transmit queues is still in frozen
  state. If the queue is still blocked (by BQL or NIC tx ring full),
  we leave the skb in bad_txq and return NULL.

- dequeue_skb() calls q->dequeue() to get another packet (P2)

  The other packet can target the problematic queue (that we found
  in frozen state for the bad_txq packet), but another cpu just ran
  TX completion and made room in the txq that is now ready to accept
  new packets.

- Packet P2 is sent while P1 is still held in bad_txq, P1 might be sent
  at next round. In practice P2 is the lead of a big packet train
  (P2,P3,P4 ...) filling the BQL budget and delaying P1 by many packets :/

To solve this problem, we have to block the dequeue process as long
as the first packet in bad_txq can not be sent. Reordering issues
disappear and no side effects have been seen.

Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -46,6 +46,8 @@ EXPORT_SYMBOL(default_qdisc_ops);
  * - updates to tree and tree walking are only done under the rtnl mutex.
  */
 
+#define SKB_XOFF_MAGIC ((struct sk_buff *)1UL)
+
 static inline struct sk_buff *__skb_dequeue_bad_txq(struct Qdisc *q)
 {
 	const struct netdev_queue *txq = q->dev_queue;
@@ -71,7 +73,7 @@ static inline struct sk_buff *__skb_dequ
 				q->q.qlen--;
 			}
 		} else {
-			skb = NULL;
+			skb = SKB_XOFF_MAGIC;
 		}
 	}
 
@@ -253,8 +255,11 @@ validate:
 		return skb;
 
 	skb = qdisc_dequeue_skb_bad_txq(q);
-	if (unlikely(skb))
+	if (unlikely(skb)) {
+		if (skb == SKB_XOFF_MAGIC)
+			return NULL;
 		goto bulk;
+	}
 	skb = q->dequeue(q);
 	if (skb) {
 bulk:


