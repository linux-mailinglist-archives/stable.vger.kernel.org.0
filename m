Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8B3F1955
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhHSMbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17050 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhHSMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gr3tn4WdWzbfwH;
        Thu, 19 Aug 2021 20:27:29 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:31:14 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:31:14 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 6/6] powerpc/perf: Invoke per-CPU variable access with disabled interrupts
Date:   Thu, 19 Aug 2021 20:19:12 +0800
Message-ID: <1629375552-51897-7-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit f66de7ac4849eb42a7b18e26b8ee49e08130fd27 upstream.

The power_pmu_event_init() callback access per-cpu variable
(cpu_hw_events) to check for event constraints and Branch Stack
(BHRB). Current usage is to disable preemption when accessing the
per-cpu variable, but this does not prevent timer callback from
interrupting event_init. Fix this by using 'local_irq_save/restore'
to make sure the code path is invoked with disabled interrupts.

This change is tested in mambo simulator to ensure that, if a timer
interrupt comes in during the per-cpu access in event_init, it will be
soft masked and replayed later. For testing purpose, introduced a
udelay() in power_pmu_event_init() to make sure a timer interrupt arrives
while in per-cpu variable access code between local_irq_save/resore.
As expected the timer interrupt was replayed later during local_irq_restore
called from power_pmu_event_init. This was confirmed by adding
breakpoint in mambo and checking the backtrace when timer_interrupt
was hit.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1606814880-1720-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 arch/powerpc/perf/core-book3s.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index ded4a3e..9145231 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1884,7 +1884,7 @@ static bool is_event_blacklisted(u64 ev)
 static int power_pmu_event_init(struct perf_event *event)
 {
 	u64 ev;
-	unsigned long flags;
+	unsigned long flags, irq_flags;
 	struct perf_event *ctrs[MAX_HWEVENTS];
 	u64 events[MAX_HWEVENTS];
 	unsigned int cflags[MAX_HWEVENTS];
@@ -1992,7 +1992,9 @@ static int power_pmu_event_init(struct perf_event *event)
 	if (check_excludes(ctrs, cflags, n, 1))
 		return -EINVAL;
 
-	cpuhw = &get_cpu_var(cpu_hw_events);
+	local_irq_save(irq_flags);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
+
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
@@ -2003,13 +2005,13 @@ static int power_pmu_event_init(struct perf_event *event)
 					event->attr.branch_sample_type);
 
 		if (bhrb_filter == -1) {
-			put_cpu_var(cpu_hw_events);
+			local_irq_restore(irq_flags);
 			return -EOPNOTSUPP;
 		}
 		cpuhw->bhrb_filter = bhrb_filter;
 	}
 
-	put_cpu_var(cpu_hw_events);
+	local_irq_restore(irq_flags);
 	if (err)
 		return -EINVAL;
 
-- 
1.7.12.4

