Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E420F29C11E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368495AbgJ0Oyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775120AbgJ0OwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:52:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C416207DE;
        Tue, 27 Oct 2020 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810327;
        bh=iWxvczoaS3E9lVAnQ9TExVBF7O9/hvQdCk8yZgI+1oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aA65s8qJ8Baxsju4pLiGWDjo0Q0yLC9+9tqMkmQBJbSTALGroYEXiNOaT/c250/4a
         9oWBVYAJJzgjVd6PPehWuWDQJZQP2IF/yzUC3joffniwUlyhnkIQ/y/423AuEN07Ka
         fMaHenxpIMrKxo5NQIIpnEFpcr/uDDI3AC6PRQP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 100/633] perf/x86: Fix n_pair for cancelled txn
Date:   Tue, 27 Oct 2020 14:47:23 +0100
Message-Id: <20201027135527.396186300@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 871a93b0aad65a7f44ee25f2d17932ef6d559850 ]

Kan reported that n_metric gets corrupted for cancelled transactions;
a similar issue exists for n_pair for AMD's Large Increment thing.

The problem was confirmed and confirmed fixed by Kim using:

  sudo perf stat -e "{cycles,cycles,cycles,cycles}:D" -a sleep 10 &

  # should succeed:
  sudo perf stat -e "{fp_ret_sse_avx_ops.all}:D" -a workload

  # should fail:
  sudo perf stat -e "{fp_ret_sse_avx_ops.all,fp_ret_sse_avx_ops.all,cycles}:D" -a workload

  # previously failed, now succeeds with this patch:
  sudo perf stat -e "{fp_ret_sse_avx_ops.all}:D" -a workload

Fixes: 5738891229a2 ("perf/x86/amd: Add support for Large Increment per Cycle Events")
Reported-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lkml.kernel.org/r/20201005082516.GG2628@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c       | 6 +++++-
 arch/x86/events/perf_event.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 4103665c6e032..29640b4079af0 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1087,8 +1087,10 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 
 		cpuc->event_list[n] = event;
 		n++;
-		if (is_counter_pair(&event->hw))
+		if (is_counter_pair(&event->hw)) {
 			cpuc->n_pair++;
+			cpuc->n_txn_pair++;
+		}
 	}
 	return n;
 }
@@ -1953,6 +1955,7 @@ static void x86_pmu_start_txn(struct pmu *pmu, unsigned int txn_flags)
 
 	perf_pmu_disable(pmu);
 	__this_cpu_write(cpu_hw_events.n_txn, 0);
+	__this_cpu_write(cpu_hw_events.n_txn_pair, 0);
 }
 
 /*
@@ -1978,6 +1981,7 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 	 */
 	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
 	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
+	__this_cpu_sub(cpu_hw_events.n_pair, __this_cpu_read(cpu_hw_events.n_txn_pair));
 	perf_pmu_enable(pmu);
 }
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e17a3d8a47ede..d4d482d16fe18 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -198,6 +198,7 @@ struct cpu_hw_events {
 					     they've never been enabled yet */
 	int			n_txn;    /* the # last events in the below arrays;
 					     added in the current transaction */
+	int			n_txn_pair;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 
-- 
2.25.1



