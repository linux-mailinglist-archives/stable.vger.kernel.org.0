Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3ADB8569
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390183AbfISWUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394045AbfISWUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:20:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5487621907;
        Thu, 19 Sep 2019 22:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931649;
        bh=ZRhVAY8poZIYQ3cm+G/7kvP4iN1cLutesGG83mvRrbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAw7GchxMfuskaqOkw7QnfhxgJ+JNlY6egVRaiPyqi+gbAQd3rxLNcW89uCpUpymq
         S71XYpvu/Dq1+O4qb+mOW5P7F0SnNE2lMGJkaY1XUnLugvi4y9qRGL6Lvo/37GiO9i
         pdsJMRNLwoe256q0jAVbM7ZH/hzhHoRM/uTFb3Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, acme@kernel.org,
        Josh Hunt <johunt@akamai.com>, bpuranda@akamai.com,
        mingo@redhat.com, jolsa@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org, alexander.shishkin@linux.intel.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 63/74] perf/x86/intel: Restrict period on Nehalem
Date:   Fri, 20 Sep 2019 00:04:16 +0200
Message-Id: <20190919214810.717652529@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e98e238d37750..55e362f9dbfaa 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3075,6 +3075,11 @@ static u64 bdw_limit_period(struct perf_event *event, u64 left)
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
@@ -3734,6 +3739,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_nehalem_pebs_event_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+		x86_pmu.limit_period = nhm_limit_period;
 
 		x86_pmu.cpu_events = nhm_events_attrs;
 
-- 
2.20.1



