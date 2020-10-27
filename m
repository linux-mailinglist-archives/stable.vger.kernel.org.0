Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0075129B6B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797557AbgJ0PYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797553AbgJ0PYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC40A2076D;
        Tue, 27 Oct 2020 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812253;
        bh=EtXc800yDwp/VrsePCCRwRCBnP1AGikrAF3ru1DVMMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbhIRE8d56JMZXjd5huoTOPyqjXcRpBLTeJl6o2S19g00D/lD+113EyyqJDDtgdMu
         rGgoSk8GaETWkjDSQuqgmQZX4CQmgooMc2ZEgadK3zg5BNwWXLqyR/O7kxmpia8b0L
         tfezeqoj4vw+SvycnW25sl53SmAamDjUKmHyzaMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 113/757] perf/x86: Fix n_pair for cancelled txn
Date:   Tue, 27 Oct 2020 14:46:03 +0100
Message-Id: <20201027135455.870200974@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 1cbf57dc2ac89..11bbc6590f904 100644
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
@@ -1962,6 +1964,7 @@ static void x86_pmu_start_txn(struct pmu *pmu, unsigned int txn_flags)
 
 	perf_pmu_disable(pmu);
 	__this_cpu_write(cpu_hw_events.n_txn, 0);
+	__this_cpu_write(cpu_hw_events.n_txn_pair, 0);
 }
 
 /*
@@ -1987,6 +1990,7 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 	 */
 	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
 	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
+	__this_cpu_sub(cpu_hw_events.n_pair, __this_cpu_read(cpu_hw_events.n_txn_pair));
 	perf_pmu_enable(pmu);
 }
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 7b68ab5f19e76..0e74235cdac9e 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -210,6 +210,7 @@ struct cpu_hw_events {
 					     they've never been enabled yet */
 	int			n_txn;    /* the # last events in the below arrays;
 					     added in the current transaction */
+	int			n_txn_pair;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 
-- 
2.25.1



