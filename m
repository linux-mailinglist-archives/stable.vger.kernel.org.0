Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540C8198F44
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgCaJB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbgCaJB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F09720787;
        Tue, 31 Mar 2020 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645318;
        bh=Z2eQWQQd09Y24ml54/ptlmTqM1M5MaTLo8/U7dsFmKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hh/L+sRinOYlhCRGjzYDq0aq9zJgsvjwoNHRZZKiIslKHhF6hq2myCqjdIOKtxC2s
         TZJFy9nUETb/YDAYSpjwJtBGqgcMJgbMIC3pJl4gN+4oWCaGSUJgVqv0Bu+vl6ZNCh
         KWHqBx6LCZpVO1ea4d4CCTvvmQGoBJKqLb/FIwN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zh-yuan Ye <ye.zh-yuan@socionext.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 017/170] net: cbs: Fix software cbs to consider packet sending time
Date:   Tue, 31 Mar 2020 10:57:11 +0200
Message-Id: <20200331085425.913405950@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zh-yuan Ye <ye.zh-yuan@socionext.com>

[ Upstream commit 961d0e5b32946703125964f9f5b6321d60f4d706 ]

Currently the software CBS does not consider the packet sending time
when depleting the credits. It caused the throughput to be
Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
is expected. In order to fix the issue above, this patch takes the time
when the packet sending completes into account by moving the anchor time
variable "last" ahead to the send completion time upon transmission and
adding wait when the next dequeue request comes before the send
completion time of the previous packet.

changelog:
V2->V3:
 - remove unnecessary whitespace cleanup
 - add the checks if port_rate is 0 before division

V1->V2:
 - combine variable "send_completed" into "last"
 - add the comment for estimate of the packet sending

Fixes: 585d763af09c ("net/sched: Introduce Credit Based Shaper (CBS) qdisc")
Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cbs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -181,6 +181,11 @@ static struct sk_buff *cbs_dequeue_soft(
 	s64 credits;
 	int len;
 
+	/* The previous packet is still being sent */
+	if (now < q->last) {
+		qdisc_watchdog_schedule_ns(&q->watchdog, q->last);
+		return NULL;
+	}
 	if (q->credits < 0) {
 		credits = timediff_to_credits(now - q->last, q->idleslope);
 
@@ -212,7 +217,12 @@ static struct sk_buff *cbs_dequeue_soft(
 	credits += q->credits;
 
 	q->credits = max_t(s64, credits, q->locredit);
-	q->last = now;
+	/* Estimate of the transmission of the last byte of the packet in ns */
+	if (unlikely(atomic64_read(&q->port_rate) == 0))
+		q->last = now;
+	else
+		q->last = now + div64_s64(len * NSEC_PER_SEC,
+					  atomic64_read(&q->port_rate));
 
 	return skb;
 }


