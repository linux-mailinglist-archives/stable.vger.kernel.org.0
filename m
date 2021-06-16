Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667183AA459
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 21:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhFPTcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 15:32:11 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54918 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhFPTcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 15:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623871804; x=1655407804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ABu9I4P8IaOlAy1/GgHEnror4Vsx/Q1iq7c1EIYYafc=;
  b=lA9NeFx3ncwD81xxUBCjOJ8PVvy75HyMZGlki1lZVV9iqaKRxgkdj+kM
   H1PRsMx8NyZ4/qc20SxOJDVmUWu8wqKcPPReQof8MdMsrdhqtOiyN4X7j
   bIflE0SGmAZ/y4hD2wc9p70RvQvviEiXjqWtEZlMQI61UUFWEjMsmvwbT
   4=;
X-IronPort-AV: E=Sophos;i="5.83,278,1616457600"; 
   d="scan'208";a="938673791"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 16 Jun 2021 19:29:56 +0000
Received: from EX13D39EUC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 63CC0A1E1D;
        Wed, 16 Jun 2021 19:29:55 +0000 (UTC)
Received: from laptop.ant.amazon.com (10.43.162.147) by
 EX13D39EUC002.ant.amazon.com (10.43.164.187) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 16 Jun 2021 19:29:50 +0000
From:   Aman Priyadarshi <apeureka@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexander Graf <graf@amazon.de>,
        Mark Rutland <mark.rutland@arm.com>, <stable@vger.kernel.org>,
        Ali Saidi <alisaidi@amazon.com>
Subject: [PATCH] arm64: perf: Disable PMU while processing counter overflows
Date:   Wed, 16 Jun 2021 21:28:59 +0200
Message-ID: <20210616192859.21708-1-apeureka@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YMoQ1MZgsL2hF2EL@kroah.com>
References: <YMoQ1MZgsL2hF2EL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D39EUC002.ant.amazon.com (10.43.164.187)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 3cce50dfec4a5b0414c974190940f47dd32c6dee ]

The arm64 PMU updates the event counters and reprograms the
counters in the overflow IRQ handler without disabling the
PMU. This could potentially cause skews in for group counters,
where the overflowed counters may potentially loose some event
counts, while they are reprogrammed. To prevent this, disable
the PMU while we process the counter overflows and enable it
right back when we are done.

This patch also moves the PMU stop/start routines to avoid a
forward declaration.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Aman Priyadarshi <apeureka@amazon.de>
Cc: stable@vger.kernel.org
---
 arch/arm64/kernel/perf_event.c | 50 +++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 53df84b2a07f..4ee1228d29eb 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -670,6 +670,28 @@ static void armv8pmu_disable_event(struct perf_event *event)
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 
+static void armv8pmu_start(struct arm_pmu *cpu_pmu)
+{
+	unsigned long flags;
+	struct pmu_hw_events *events = this_cpu_ptr(cpu_pmu->hw_events);
+
+	raw_spin_lock_irqsave(&events->pmu_lock, flags);
+	/* Enable all counters */
+	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
+	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
+}
+
+static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
+{
+	unsigned long flags;
+	struct pmu_hw_events *events = this_cpu_ptr(cpu_pmu->hw_events);
+
+	raw_spin_lock_irqsave(&events->pmu_lock, flags);
+	/* Disable all counters */
+	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
+	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
+}
+
 static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
 {
 	u32 pmovsr;
@@ -695,6 +717,11 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
 	 */
 	regs = get_irq_regs();
 
+	/*
+	 * Stop the PMU while processing the counter overflows
+	 * to prevent skews in group events.
+	 */
+	armv8pmu_stop(cpu_pmu);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
@@ -719,6 +746,7 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
 		if (perf_event_overflow(event, &data, regs))
 			cpu_pmu->disable(event);
 	}
+	armv8pmu_start(cpu_pmu);
 
 	/*
 	 * Handle the pending perf events.
@@ -732,28 +760,6 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void armv8pmu_start(struct arm_pmu *cpu_pmu)
-{
-	unsigned long flags;
-	struct pmu_hw_events *events = this_cpu_ptr(cpu_pmu->hw_events);
-
-	raw_spin_lock_irqsave(&events->pmu_lock, flags);
-	/* Enable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
-	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
-}
-
-static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
-{
-	unsigned long flags;
-	struct pmu_hw_events *events = this_cpu_ptr(cpu_pmu->hw_events);
-
-	raw_spin_lock_irqsave(&events->pmu_lock, flags);
-	/* Disable all counters */
-	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
-	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
-}
-
 static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 				  struct perf_event *event)
 {
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



