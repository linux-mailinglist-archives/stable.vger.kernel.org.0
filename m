Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283B02F14F9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbhAKNdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732149AbhAKNOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE6FE2255F;
        Mon, 11 Jan 2021 13:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370839;
        bh=iNa7GbdT3nY5bwlyukN+McDmodXRZ4s+cIInWNUhKCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bD3ITKkyCZEb1BU7+mWFCfMyVX6eWOPqDYbiSk7K+XaVWQBUmJcKiAFFbeTGmAZwl
         5Z3zu4KPr2esVu6g18U8j2urO5KkwEScDto/WV+iDmhVryriiw8pNnsNKRnAqlxNss
         rADNzr9x1SW1T/1Z8V9pI7wosBVD4WENd8eER2kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH 5.10 003/145] net/sched: sch_taprio: ensure to reset/destroy all child qdiscs
Date:   Mon, 11 Jan 2021 14:00:27 +0100
Message-Id: <20210111130048.673546177@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 698285da79f5b0b099db15a37ac661ac408c80eb ]

taprio_graft() can insert a NULL element in the array of child qdiscs. As
a consquence, taprio_reset() might not reset child qdiscs completely, and
taprio_destroy() might leak resources. Fix it by ensuring that loops that
iterate over q->qdiscs[] don't end when they find the first NULL item.

Fixes: 44d4775ca518 ("net/sched: sch_taprio: reset child qdiscs before freeing them")
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/13edef6778fef03adc751582562fba4a13e06d6a.1608240532.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1604,8 +1604,9 @@ static void taprio_reset(struct Qdisc *s
 
 	hrtimer_cancel(&q->advance_timer);
 	if (q->qdiscs) {
-		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
-			qdisc_reset(q->qdiscs[i]);
+		for (i = 0; i < dev->num_tx_queues; i++)
+			if (q->qdiscs[i])
+				qdisc_reset(q->qdiscs[i]);
 	}
 	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
@@ -1625,7 +1626,7 @@ static void taprio_destroy(struct Qdisc
 	taprio_disable_offload(dev, q, NULL);
 
 	if (q->qdiscs) {
-		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
+		for (i = 0; i < dev->num_tx_queues; i++)
 			qdisc_put(q->qdiscs[i]);
 
 		kfree(q->qdiscs);


