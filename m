Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD505289CE
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbfEWTTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388977AbfEWTTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC722133D;
        Thu, 23 May 2019 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639155;
        bh=bRb71DgIwaKU9E1FlAcEhiJKsv7N3o3aG9uJBnOiaik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtsI00ZTJkcF/sT5KrRbHbBGbxUnmY4VFMMPIdGBde/sEb0PRucnOmSSeUGFQUcc0
         FiM47npwyjoSwnyY6IRvD18+PewZD2ZoLdrNh7mZdXgsk0isWL/hf9mL6oL1DRn5bF
         skz5NNVqTmmq4n9CWqYzP0kDHVYRkapVeZ4YkqtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
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
Subject: [PATCH 4.19 107/114] perf/x86/intel: Fix race in intel_pmu_disable_event()
Date:   Thu, 23 May 2019 21:06:46 +0200
Message-Id: <20190523181740.591800976@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a759e59990fbd..09c53bcbd497d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2074,15 +2074,19 @@ static void intel_pmu_disable_event(struct perf_event *event)
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



