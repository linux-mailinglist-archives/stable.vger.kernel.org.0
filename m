Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3CC29C122
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751896AbgJ0Oy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773116AbgJ0OvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:51:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C4D206E5;
        Tue, 27 Oct 2020 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810282;
        bh=U5ZOqQ5IzGw2OMagudZRZimKNNLkAHYNzrMZVWHU5ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baD7SiV+5AFFfidxruD7J+H87GvvVoS8L+5/5jBg4xWfgxEDV7uxVHiItSyqFuVOa
         Ufd6AazeEHVP+AT4ezbjGrB5wvdjqfaT9KMPZdWi2QaCaUgH5E/PRQ+778U5sFdMEK
         xD6rNlKevsVcfSrBxy4pWxmyVcktgrthNG7AIrMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 085/633] perf/x86/intel/ds: Fix x86_pmu_stop warning for large PEBS
Date:   Tue, 27 Oct 2020 14:47:08 +0100
Message-Id: <20201027135526.678578859@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 35d1ce6bec133679ff16325d335217f108b84871 ]

A warning as below may be triggered when sampling with large PEBS.

[  410.411250] perf: interrupt took too long (72145 > 71975), lowering
kernel.perf_event_max_sample_rate to 2000
[  410.724923] ------------[ cut here ]------------
[  410.729822] WARNING: CPU: 0 PID: 16397 at arch/x86/events/core.c:1422
x86_pmu_stop+0x95/0xa0
[  410.933811]  x86_pmu_del+0x50/0x150
[  410.937304]  event_sched_out.isra.0+0xbc/0x210
[  410.941751]  group_sched_out.part.0+0x53/0xd0
[  410.946111]  ctx_sched_out+0x193/0x270
[  410.949862]  __perf_event_task_sched_out+0x32c/0x890
[  410.954827]  ? set_next_entity+0x98/0x2d0
[  410.958841]  __schedule+0x592/0x9c0
[  410.962332]  schedule+0x5f/0xd0
[  410.965477]  exit_to_usermode_loop+0x73/0x120
[  410.969837]  prepare_exit_to_usermode+0xcd/0xf0
[  410.974369]  ret_from_intr+0x2a/0x3a
[  410.977946] RIP: 0033:0x40123c
[  411.079661] ---[ end trace bc83adaea7bb664a ]---

In the non-overflow context, e.g., context switch, with large PEBS, perf
may stop an event twice. An example is below.

  //max_samples_per_tick is adjusted to 2
  //NMI is triggered
  intel_pmu_handle_irq()
     handle_pmi_common()
       drain_pebs()
         __intel_pmu_pebs_event()
           perf_event_overflow()
             __perf_event_account_interrupt()
               hwc->interrupts = 1
               return 0
  //A context switch happens right after the NMI.
  //In the same tick, the perf_throttled_seq is not changed.
  perf_event_task_sched_out()
     perf_pmu_sched_task()
       intel_pmu_drain_pebs_buffer()
         __intel_pmu_pebs_event()
           perf_event_overflow()
             __perf_event_account_interrupt()
               ++hwc->interrupts >= max_samples_per_tick
               return 1
           x86_pmu_stop();  # First stop
     perf_event_context_sched_out()
       task_ctx_sched_out()
         ctx_sched_out()
           event_sched_out()
             x86_pmu_del()
               x86_pmu_stop();  # Second stop and trigger the warning

Perf should only invoke the perf_event_overflow() in the overflow
context.

Current drain_pebs() is called from:
- handle_pmi_common()			-- overflow context
- intel_pmu_pebs_sched_task()		-- non-overflow context
- intel_pmu_pebs_disable()		-- non-overflow context
- intel_pmu_auto_reload_read()		-- possible overflow context
  With PERF_SAMPLE_READ + PERF_FORMAT_GROUP, the function may be
  invoked in the NMI handler. But, before calling the function, the
  PEBS buffer has already been drained. The __intel_pmu_pebs_event()
  will not be called in the possible overflow context.

To fix the issue, an indicator is required to distinguish between the
overflow context aka handle_pmi_common() and other cases.
The dummy regs pointer can be used as the indicator.

In the non-overflow context, perf should treat the last record the same
as other PEBS records, and doesn't invoke the generic overflow handler.

Fixes: 21509084f999 ("perf/x86/intel: Handle multiple records in the PEBS buffer")
Reported-by: Like Xu <like.xu@linux.intel.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Like Xu <like.xu@linux.intel.com>
Link: https://lkml.kernel.org/r/20200902210649.2743-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index dc43cc124e096..221d1766d6e6c 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -670,9 +670,7 @@ int intel_pmu_drain_bts_buffer(void)
 
 static inline void intel_pmu_drain_pebs_buffer(void)
 {
-	struct pt_regs regs;
-
-	x86_pmu.drain_pebs(&regs);
+	x86_pmu.drain_pebs(NULL);
 }
 
 /*
@@ -1737,6 +1735,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct x86_perf_regs perf_regs;
 	struct pt_regs *regs = &perf_regs.regs;
 	void *at = get_next_pebs_record_by_bit(base, top, bit);
+	struct pt_regs dummy_iregs;
 
 	if (hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) {
 		/*
@@ -1749,6 +1748,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	} else if (!intel_pmu_save_and_restart(event))
 		return;
 
+	if (!iregs)
+		iregs = &dummy_iregs;
+
 	while (count > 1) {
 		setup_sample(event, iregs, at, &data, regs);
 		perf_event_output(event, &data, regs);
@@ -1758,16 +1760,22 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	}
 
 	setup_sample(event, iregs, at, &data, regs);
-
-	/*
-	 * All but the last records are processed.
-	 * The last one is left to be able to call the overflow handler.
-	 */
-	if (perf_event_overflow(event, &data, regs)) {
-		x86_pmu_stop(event, 0);
-		return;
+	if (iregs == &dummy_iregs) {
+		/*
+		 * The PEBS records may be drained in the non-overflow context,
+		 * e.g., large PEBS + context switch. Perf should treat the
+		 * last record the same as other PEBS records, and doesn't
+		 * invoke the generic overflow handler.
+		 */
+		perf_event_output(event, &data, regs);
+	} else {
+		/*
+		 * All but the last records are processed.
+		 * The last one is left to be able to call the overflow handler.
+		 */
+		if (perf_event_overflow(event, &data, regs))
+			x86_pmu_stop(event, 0);
 	}
-
 }
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
-- 
2.25.1



