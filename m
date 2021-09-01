Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC713FDB84
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbhIAMl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344974AbhIAMkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC09610CE;
        Wed,  1 Sep 2021 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499786;
        bh=vcUSTnaYK9xUm+aQ+qSPNWuE10+gFn0zLr5QUjeWSrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clEN4J3C2EFmJ/OUUigj5rdYzKzx0ZzYnEw7EL4PLseCS470knKd6xJDenu6+yR5S
         RGDfISVsCqLaxcKCsFwbfuCXQgd72KCEo16wFD+krZ1KdAOkbomXy95CFvWN3evHAm
         n4B4P9Rcb0/7oiR2xJyfd74GD9hTWCNCW+7JQn60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 085/103] powerpc/perf: Invoke per-CPU variable access with disabled interrupts
Date:   Wed,  1 Sep 2021 14:28:35 +0200
Message-Id: <20210901122303.407702613@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/core-book3s.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

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
@@ -1992,7 +1992,9 @@ static int power_pmu_event_init(struct p
 	if (check_excludes(ctrs, cflags, n, 1))
 		return -EINVAL;
 
-	cpuhw = &get_cpu_var(cpu_hw_events);
+	local_irq_save(irq_flags);
+	cpuhw = this_cpu_ptr(&cpu_hw_events);
+
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
@@ -2003,13 +2005,13 @@ static int power_pmu_event_init(struct p
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
 


