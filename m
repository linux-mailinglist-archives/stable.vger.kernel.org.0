Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C58205CD
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEPLka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbfEPLk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A4E20881;
        Thu, 16 May 2019 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006828;
        bh=BZa2MtSV0BjEIvT7SpN4QCtsbc6tidXldnsZUPWjvQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPU4KWvnPoHKu7q4akdjqp2yM8REwoE1wKQdm0k4d/oGhhyvWKdhQWO3hbkMOOHb1
         nGkq6Rlep+Wbv1vLuWDvU0gNYToIqUKsXaFThl+pscWHpc27U9X/DCTKZvzJNdEdwD
         RJ/eJ+H8Z/bN+hvNaKH0/0plWewJERy6NGtEUfT8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Arcari <darcari@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Lendacky Thomas <Thomas.Lendacky@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 34/34] perf/x86/intel: Fix race in intel_pmu_disable_event()
Date:   Thu, 16 May 2019 07:39:31 -0400
Message-Id: <20190516113932.8348-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 6f55967ad9d9752813e36de6d5fdbd19741adfc7 ]

New race in x86_pmu_stop() was introduced by replacing the
atomic __test_and_clear_bit() of cpuc->active_mask by separate
test_bit() and __clear_bit() calls in the following commit:

  3966c3feca3f ("x86/perf/amd: Remove need to check "running" bit in NMI handler")

The race causes panic for PEBS events with enabled callchains:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
  ...
  RIP: 0010:perf_prepare_sample+0x8c/0x530
  Call Trace:
   <NMI>
   perf_event_output_forward+0x2a/0x80
   __perf_event_overflow+0x51/0xe0
   handle_pmi_common+0x19e/0x240
   intel_pmu_handle_irq+0xad/0x170
   perf_event_nmi_handler+0x2e/0x50
   nmi_handle+0x69/0x110
   default_do_nmi+0x3e/0x100
   do_nmi+0x11a/0x180
   end_repeat_nmi+0x16/0x1a
  RIP: 0010:native_write_msr+0x6/0x20
  ...
   </NMI>
   intel_pmu_disable_event+0x98/0xf0
   x86_pmu_stop+0x6e/0xb0
   x86_pmu_del+0x46/0x140
   event_sched_out.isra.97+0x7e/0x160
  ...

The event is configured to make samples from PEBS drain code,
but when it's disabled, we'll go through NMI path instead,
where data->callchain will not get allocated and we'll crash:

          x86_pmu_stop
            test_bit(hwc->idx, cpuc->active_mask)
            intel_pmu_disable_event(event)
            {
              ...
              intel_pmu_pebs_disable(event);
              ...

EVENT OVERFLOW ->  <NMI>
                     intel_pmu_handle_irq
                       handle_pmi_common
   TEST PASSES ->        test_bit(bit, cpuc->active_mask))
                           perf_event_overflow
                             perf_prepare_sample
                             {
                               ...
                               if (!(sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY))
                                     data->callchain = perf_callchain(event, regs);

         CRASH ->              size += data->callchain->nr;
                             }
                   </NMI>
              ...
              x86_pmu_disable_event(event)
            }

            __clear_bit(hwc->idx, cpuc->active_mask);

Fixing this by disabling the event itself before setting
off the PEBS bit.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Arcari <darcari@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Lendacky Thomas <Thomas.Lendacky@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 3966c3feca3f ("x86/perf/amd: Remove need to check "running" bit in NMI handler")
Link: http://lkml.kernel.org/r/20190504151556.31031-1-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 71fb8b7b29545..c87b06ad9f860 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2090,15 +2090,19 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
 
-	if (unlikely(event->attr.precise_ip))
-		intel_pmu_pebs_disable(event);
-
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc);
 		return;
 	}
 
 	x86_pmu_disable_event(event);
+
+	/*
+	 * Needs to be called after x86_pmu_disable_event,
+	 * so we don't trigger the event without PEBS bit set.
+	 */
+	if (unlikely(event->attr.precise_ip))
+		intel_pmu_pebs_disable(event);
 }
 
 static void intel_pmu_del_event(struct perf_event *event)
-- 
2.20.1

