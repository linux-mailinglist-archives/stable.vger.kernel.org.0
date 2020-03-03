Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2556178201
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbgCCSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:08:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgCCRxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD860206D5;
        Tue,  3 Mar 2020 17:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258018;
        bh=RvQhxzX6sNPG//i4+vk6Vu4eK5JycpXVfhLLiIG7OWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V93xFb259SAflWIsGKUC0X7Mamk+uxuD74LhwVAfDb+zMP4rrNyTFzEtCLQzys2b+
         oqBl4WEe3fKjY/7spBbzppwi06UT9L3yaw4UzlaSPEst8TM407eQ6UxdCwxaxKc3AI
         By1biQoJQ9ISx+D+lmspuiFrSODsvJ30jLCJ/ymI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 012/152] Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"
Date:   Tue,  3 Mar 2020 18:41:50 +0100
Message-Id: <20200303174303.899277587@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 379349e9bc3b42b8b2f8f7a03f64a97623fff323 ]

This reverts commit ba27b4cdaaa66561aaedb2101876e563738d36fe

Ahmed reported ouf-of-order issues bisected to commit ba27b4cdaaa6
("net: dev: introduce support for sch BYPASS for lockless qdisc").
I can't find any working solution other than a plain revert.

This will introduce some minor performance regressions for
pfifo_fast qdisc. I plan to address them in net-next with more
indirect call wrapper boilerplate for qdiscs.

Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Fixes: ba27b4cdaaa6 ("net: dev: introduce support for sch BYPASS for lockless qdisc")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3386,26 +3386,8 @@ static inline int __dev_xmit_skb(struct
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
-		    qdisc_run_begin(q)) {
-			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
-					      &q->state))) {
-				__qdisc_drop(skb, &to_free);
-				rc = NET_XMIT_DROP;
-				goto end_run;
-			}
-			qdisc_bstats_cpu_update(q, skb);
-
-			rc = NET_XMIT_SUCCESS;
-			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
-				__qdisc_run(q);
-
-end_run:
-			qdisc_run_end(q);
-		} else {
-			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-			qdisc_run(q);
-		}
+		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);


