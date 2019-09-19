Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4020B8766
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392724AbfISWgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405224AbfISWGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027E5218AF;
        Thu, 19 Sep 2019 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930792;
        bh=8r/Yy/UxO9+1oKh0xmMb8x+AQ9Z3hiF4R3vEXfzPGuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onhf8u/fletnk82XyaPqat0s8xi8Ezcahq9aoMmzp05l+54ZvU4orExNpa7hO6OEx
         GzZz3LDKXhXsVUgZj4Qlk48AaYIi1CGSZNlDa6xjHx9ca7ykbhiIUi3wu29wYdkXDW
         kSFvXLMMPt0Dah714CIT+W0yAvWf5FL9d7Hvljds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Shuang <shuali@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH 5.2 016/124] net/sched: fix race between deactivation and dequeue for NOLOCK qdisc
Date:   Fri, 20 Sep 2019 00:01:44 +0200
Message-Id: <20190919214819.711792062@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d518d2ed8640c1cbbbb6f63939e3e65471817367 ]

The test implemented by some_qdisc_is_busy() is somewhat loosy for
NOLOCK qdisc, as we may hit the following scenario:

CPU1						CPU2
// in net_tx_action()
clear_bit(__QDISC_STATE_SCHED...);
						// in some_qdisc_is_busy()
						val = (qdisc_is_running(q) ||
						       test_bit(__QDISC_STATE_SCHED,
								&q->state));
						// here val is 0 but...
qdisc_run(q)
// ... CPU1 is going to run the qdisc next

As a conseguence qdisc_run() in net_tx_action() can race with qdisc_reset()
in dev_qdisc_reset(). Such race is not possible for !NOLOCK qdisc as
both the above bit operations are under the root qdisc lock().

After commit 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue")
the race can cause use after free and/or null ptr dereference, but the root
cause is likely older.

This patch addresses the issue explicitly checking for deactivation under
the seqlock for NOLOCK qdisc, so that the qdisc_run() in the critical
scenario becomes a no-op.

Note that the enqueue() op can still execute concurrently with dev_qdisc_reset(),
but that is safe due to the skb_array() locking, and we can't avoid that
for NOLOCK qdiscs.

Fixes: 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue")
Reported-by: Li Shuang <shuali@redhat.com>
Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/pkt_sched.h |    7 ++++++-
 net/core/dev.c          |   16 ++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -118,7 +118,12 @@ void __qdisc_run(struct Qdisc *q);
 static inline void qdisc_run(struct Qdisc *q)
 {
 	if (qdisc_run_begin(q)) {
-		__qdisc_run(q);
+		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
+		 * to avoid racing with dev_qdisc_reset()
+		 */
+		if (!(q->flags & TCQ_F_NOLOCK) ||
+		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
+			__qdisc_run(q);
 		qdisc_run_end(q);
 	}
 }
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3475,18 +3475,22 @@ static inline int __dev_xmit_skb(struct
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
-			__qdisc_drop(skb, &to_free);
-			rc = NET_XMIT_DROP;
-		} else if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
-			   qdisc_run_begin(q)) {
+		if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
+		    qdisc_run_begin(q)) {
+			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
+					      &q->state))) {
+				__qdisc_drop(skb, &to_free);
+				rc = NET_XMIT_DROP;
+				goto end_run;
+			}
 			qdisc_bstats_cpu_update(q, skb);
 
+			rc = NET_XMIT_SUCCESS;
 			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
 				__qdisc_run(q);
 
+end_run:
 			qdisc_run_end(q);
-			rc = NET_XMIT_SUCCESS;
 		} else {
 			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 			qdisc_run(q);


