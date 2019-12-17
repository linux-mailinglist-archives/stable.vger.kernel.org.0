Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308C81236C3
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfLQUL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbfLQUL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:11:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39ED3206D7;
        Tue, 17 Dec 2019 20:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613486;
        bh=nIDUZ5x1ijafsIxuP8KiqpXw0WQNyP8PQqUybLP5dzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7923MAgEtg6Lz7u48/g6UnteMGqI8JVjOaZc9jEW2lefzyOmPXkIKTFZPC9u+dOo
         mW6oVCHHt5n0CAp9BH5PXgg2meiIzWEKTNnWnHnXiITJ14c28bXZbJA+f6DycLHYYt
         WrqWNlC4ZHCKfbASRk1dMca+R0u3TRAVBVxzO3Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 06/37] net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues
Date:   Tue, 17 Dec 2019 21:09:27 +0100
Message-Id: <20191217200723.958222874@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 2f23cd42e19c22c24ff0e221089b7b6123b117c5 ]

sch->q.len hasn't been set if the subqueue is a NOLOCK qdisc
 in mq_dump() and mqprio_dump().

Fixes: ce679e8df7ed ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_mq.c     |    1 +
 net/sched/sch_mqprio.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -153,6 +153,7 @@ static int mq_dump(struct Qdisc *sch, st
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -411,6 +411,7 @@ static int mqprio_dump(struct Qdisc *sch
 			__gnet_stats_copy_queue(&sch->qstats,
 						qdisc->cpu_qstats,
 						&qdisc->qstats, qlen);
+			sch->q.qlen		+= qlen;
 		} else {
 			sch->q.qlen		+= qdisc->q.qlen;
 			sch->bstats.bytes	+= qdisc->bstats.bytes;


