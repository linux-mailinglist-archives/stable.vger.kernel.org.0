Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4A338EC2
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCLN17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:27:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:56991 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhCLN1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 08:27:37 -0500
IronPort-SDR: dGPVNBIuPmpETWoy4WzGizGiiYFrV+kYYWlb2hQCUqLZqT7KftnflLZrpTHRz/ZRmyTEVjkL1Q
 14bzabPhUtgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188925753"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="188925753"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:27:37 -0800
IronPort-SDR: i+3KB8FYhMLUI2Ye/5d04LmVyMyQvKK6fllupe43LD/2qmEewkF8lntYQODm/WpR49sFoQvnNk
 IZxHkZofr0Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="409848770"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2021 05:27:36 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vincent.weaver@maine.edu, eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] perf/x86/intel: Fix unchecked MSR access error caused by VLBR_EVENT
Date:   Fri, 12 Mar 2021 05:21:38 -0800
Message-Id: <1615555298-140216-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
References: <1615555298-140216-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

On a Haswell machine, the perf_fuzzer managed to trigger this message:

[117248.075892] unchecked MSR access error: WRMSR to 0x3f1 (tried to
write 0x0400000000000000) at rIP: 0xffffffff8106e4f4
(native_write_msr+0x4/0x20)
[117248.089957] Call Trace:
[117248.092685]  intel_pmu_pebs_enable_all+0x31/0x40
[117248.097737]  intel_pmu_enable_all+0xa/0x10
[117248.102210]  __perf_event_task_sched_in+0x2df/0x2f0
[117248.107511]  finish_task_switch.isra.0+0x15f/0x280
[117248.112765]  schedule_tail+0xc/0x40
[117248.116562]  ret_from_fork+0x8/0x30

A fake event called VLBR_EVENT may use the bit 58 of the PEBS_ENABLE, if
the precise_ip is set. The bit 58 is reserved by the HW. Accessing the
bit causes the unchecked MSR access error.

The fake event doesn't support PEBS. The case should be rejected.

Fixes: 097e4311cda9 ("perf/x86: Add constraint to create guest LBR event without hw counter")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 5bac48d..6789619 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3659,6 +3659,9 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		return ret;
 
 	if (event->attr.precise_ip) {
+		if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == INTEL_FIXED_VLBR_EVENT)
+			return -EINVAL;
+
 		if (!(event->attr.freq || (event->attr.wakeup_events && !event->attr.watermark))) {
 			event->hw.flags |= PERF_X86_EVENT_AUTO_RELOAD;
 			if (!(event->attr.sample_type &
-- 
2.7.4

