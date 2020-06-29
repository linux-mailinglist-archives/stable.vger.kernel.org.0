Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E120E2C9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390212AbgF2VIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbgF2TAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083F12551E;
        Mon, 29 Jun 2020 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446081;
        bh=WtHvaAkbfjrMfJ5jfP+E55n4gaI0gk2nzaQF1Y7dwEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odGTnDB9cII5l51UCUHyLyoB7akwQMJy7TAMQ/S5OxiBzYhPvminQafVwONScEjgM
         nxg275a0jiHIxw6O5cLEtcwqAV18YGGPGhHuBtHoAZwnxRiiV+PW2m/U2iMAezK6pB
         0uU8DVCXUC3QXOzKQ5u/Hum/+8DauGniPL6OXA3w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 077/135] net: Revert "pkt_sched: fq: use proper locking in fq_dump_stats()"
Date:   Mon, 29 Jun 2020 11:52:11 -0400
Message-Id: <20200629155309.2495516-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This reverts commit 191cf872190de28a92e1bd2b56d8860e37e07443 which is
commit 695b4ec0f0a9cf29deabd3ac075911d58b31f42b upstream.

That commit should never have been backported since it relies on a change in
locking semantics that was introduced in v4.8 and not backported. Because of
this, the backported commit to sch_fq leads to lockups because of the double
locking.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index f4aa2ab4713a2..eb814ffc09023 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -830,24 +830,20 @@ static int fq_dump(struct Qdisc *sch, struct sk_buff *skb)
 static int fq_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct fq_sched_data *q = qdisc_priv(sch);
-	struct tc_fq_qd_stats st;
-
-	sch_tree_lock(sch);
-
-	st.gc_flows		  = q->stat_gc_flows;
-	st.highprio_packets	  = q->stat_internal_packets;
-	st.tcp_retrans		  = q->stat_tcp_retrans;
-	st.throttled		  = q->stat_throttled;
-	st.flows_plimit		  = q->stat_flows_plimit;
-	st.pkts_too_long	  = q->stat_pkts_too_long;
-	st.allocation_errors	  = q->stat_allocation_errors;
-	st.time_next_delayed_flow = q->time_next_delayed_flow - ktime_get_ns();
-	st.flows		  = q->flows;
-	st.inactive_flows	  = q->inactive_flows;
-	st.throttled_flows	  = q->throttled_flows;
-	st.pad			  = 0;
-
-	sch_tree_unlock(sch);
+	u64 now = ktime_get_ns();
+	struct tc_fq_qd_stats st = {
+		.gc_flows		= q->stat_gc_flows,
+		.highprio_packets	= q->stat_internal_packets,
+		.tcp_retrans		= q->stat_tcp_retrans,
+		.throttled		= q->stat_throttled,
+		.flows_plimit		= q->stat_flows_plimit,
+		.pkts_too_long		= q->stat_pkts_too_long,
+		.allocation_errors	= q->stat_allocation_errors,
+		.flows			= q->flows,
+		.inactive_flows		= q->inactive_flows,
+		.throttled_flows	= q->throttled_flows,
+		.time_next_delayed_flow	= q->time_next_delayed_flow - now,
+	};
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
 }
-- 
2.25.1

