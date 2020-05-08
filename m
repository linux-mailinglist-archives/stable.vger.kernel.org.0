Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BEE1CABA2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgEHMp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgEHMp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21424208D6;
        Fri,  8 May 2020 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941927;
        bh=k+uF28bM3EYqbE1z4cQO2hhX68Gskq36OmYNkk2t11E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okOnPnqOfuQbhA2nq9wqxpkxXFuS4zmW3KgLB8rYre3j+0uwz/uXZEzaLss189Ene
         djMsM8g9rDzeQ1jYslK9jviSiNzFrp37sWKVr7CxzjivwvQUHD2PHpFlxh1q14IS8t
         dKQr6fF4cTh7T8qw4J8bII5mybvFlDfLveHnTB60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 226/312] pkt_sched: fq: use proper locking in fq_dump_stats()
Date:   Fri,  8 May 2020 14:33:37 +0200
Message-Id: <20200508123140.348222796@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 695b4ec0f0a9cf29deabd3ac075911d58b31f42b upstream.

When fq is used on 32bit kernels, we need to lock the qdisc before
copying 64bit fields.

Otherwise "tc -s qdisc ..." might report bogus values.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_fq.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -830,20 +830,24 @@ nla_put_failure:
 static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
-	u64 now = ktime_get_ns();
-	struct tc_fq_qd_stats st = {
-		.gc_flows		= q->stat_gc_flows,
-		.highprio_packets	= q->stat_internal_packets,
-		.tcp_retrans		= q->stat_tcp_retrans,
-		.throttled		= q->stat_throttled,
-		.flows_plimit		= q->stat_flows_plimit,
-		.pkts_too_long		= q->stat_pkts_too_long,
-		.allocation_errors	= q->stat_allocation_errors,
-		.flows			= q->flows,
-		.inactive_flows		= q->inactive_flows,
-		.throttled_flows	= q->throttled_flows,
-		.time_next_delayed_flow	= q->time_next_delayed_flow - now,
-	};
+	struct tc_fq_qd_stats st;
+
+	sch_tree_lock(sch);
+
+	st.gc_flows		  = q->stat_gc_flows;
+	st.highprio_packets	  = q->stat_internal_packets;
+	st.tcp_retrans		  = q->stat_tcp_retrans;
+	st.throttled		  = q->stat_throttled;
+	st.flows_plimit		  = q->stat_flows_plimit;
+	st.pkts_too_long	  = q->stat_pkts_too_long;
+	st.allocation_errors	  = q->stat_allocation_errors;
+	st.time_next_delayed_flow = q->time_next_delayed_flow - ktime_get_ns();
+	st.flows		  = q->flows;
+	st.inactive_flows	  = q->inactive_flows;
+	st.throttled_flows	  = q->throttled_flows;
+	st.pad			  = 0;
+
+	sch_tree_unlock(sch);
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
 }


