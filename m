Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF02A8A78
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbfIDP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732406AbfIDP7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD46720820;
        Wed,  4 Sep 2019 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612770;
        bh=48NONwleXv7yulCxjWwTzPAFeGowSucCtbVQ7QAI4IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRd5cN972KSn9W3FKD3GhycCxySPKWPDRLqSZU+1qLWXzLIE3dVGEcbXO06nDkF0F
         hQ2qwQbAPQ0jKN4saGzRWIImgqWBqx1x2IPBcawJJyg6FECb8Y3tSx25h2TApyBibe
         wmN+TMwZw2ZRqdG+7VwfoyDHNc1PShDNh12G5vUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Hunt <johunt@akamai.com>,
        Peter Zijlstra <peterz@infradead.org>, acme@kernel.org,
        bpuranda@akamai.com, mingo@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, namhyung@kernel.org,
        alexander.shishkin@linux.intel.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 71/94] perf/x86/intel: Restrict period on Nehalem
Date:   Wed,  4 Sep 2019 11:57:16 -0400
Message-Id: <20190904155739.2816-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>

[ Upstream commit 44d3bbb6f5e501b873218142fe08cdf62a4ac1f3 ]

We see our Nehalem machines reporting 'perfevents: irq loop stuck!' in
some cases when using perf:

perfevents: irq loop stuck!
WARNING: CPU: 0 PID: 3485 at arch/x86/events/intel/core.c:2282 intel_pmu_handle_irq+0x37b/0x530
...
RIP: 0010:intel_pmu_handle_irq+0x37b/0x530
...
Call Trace:
<NMI>
? perf_event_nmi_handler+0x2e/0x50
? intel_pmu_save_and_restart+0x50/0x50
perf_event_nmi_handler+0x2e/0x50
nmi_handle+0x6e/0x120
default_do_nmi+0x3e/0x100
do_nmi+0x102/0x160
end_repeat_nmi+0x16/0x50
...
? native_write_msr+0x6/0x20
? native_write_msr+0x6/0x20
</NMI>
intel_pmu_enable_event+0x1ce/0x1f0
x86_pmu_start+0x78/0xa0
x86_pmu_enable+0x252/0x310
__perf_event_task_sched_in+0x181/0x190
? __switch_to_asm+0x41/0x70
? __switch_to_asm+0x35/0x70
? __switch_to_asm+0x41/0x70
? __switch_to_asm+0x35/0x70
finish_task_switch+0x158/0x260
__schedule+0x2f6/0x840
? hrtimer_start_range_ns+0x153/0x210
schedule+0x32/0x80
schedule_hrtimeout_range_clock+0x8a/0x100
? hrtimer_init+0x120/0x120
ep_poll+0x2f7/0x3a0
? wake_up_q+0x60/0x60
do_epoll_wait+0xa9/0xc0
__x64_sys_epoll_wait+0x1a/0x20
do_syscall_64+0x4e/0x110
entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fdeb1e96c03
...
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: acme@kernel.org
Cc: Josh Hunt <johunt@akamai.com>
Cc: bpuranda@akamai.com
Cc: mingo@redhat.com
Cc: jolsa@redhat.com
Cc: tglx@linutronix.de
Cc: namhyung@kernel.org
Cc: alexander.shishkin@linux.intel.com
Link: https://lkml.kernel.org/r/1566256411-18820-1-git-send-email-johunt@akamai.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 6179be624f357..2369ea1a1db79 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3572,6 +3572,11 @@ static u64 bdw_limit_period(struct perf_event *event, u64 left)
 	return left;
 }
 
+static u64 nhm_limit_period(struct perf_event *event, u64 left)
+{
+	return max(left, 32ULL);
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -4550,6 +4555,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+		x86_pmu.limit_period = nhm_limit_period;
 
 		mem_attr = nhm_mem_events_attrs;
 
-- 
2.20.1

