Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFC46B800
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 10:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfGQIRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 04:17:25 -0400
Received: from foss.arm.com ([217.140.110.172]:43922 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfGQIRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 04:17:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B03A1516;
        Wed, 17 Jul 2019 01:17:24 -0700 (PDT)
Received: from e112298-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6BBB63F71A;
        Wed, 17 Jul 2019 01:19:22 -0700 (PDT)
From:   Julien Thierry <julien.thierry@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     mark.rutland@arm.com, peterz@infradead.org, liwei391@huawei.com,
        will.deacon@arm.com, acme@kernel.org,
        alexander.shishkin@linux.intel.com, mingo@redhat.com,
        namhyung@kernel.org, jolsa@redhat.com, sthotton@marvell.com,
        Julien Thierry <julien.thierry@arm.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
Subject: [PATCH v4 3/9] arm: perf: save/resore pmsel
Date:   Wed, 17 Jul 2019 09:17:06 +0100
Message-Id: <1563351432-55652-4-git-send-email-julien.thierry@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1563351432-55652-1-git-send-email-julien.thierry@arm.com>
References: <1563351432-55652-1-git-send-email-julien.thierry@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The callback pmu->read() can be called with interrupts enabled.
Currently, on ARM, this can cause the following callchain:

armpmu_read() -> armpmu_event_update() -> armv7pmu_read_counter()

The last function might modify the counter selector register and then
read the target counter, without taking any lock. With interrupts
enabled, a PMU interrupt could occur and modify the selector register
as well, between the selection and read of the interrupted context.

Save and restore the value of the selector register in the PMU interrupt
handler, ensuring the interrupted context is left with the correct PMU
registers selected.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: stable@vger.kernel.org
---
 arch/arm/kernel/perf_event_v7.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index a4fb0f8..b7be2a3 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -736,10 +736,22 @@ static inline int armv7_pmnc_counter_has_overflowed(u32 pmnc, int idx)
 	return pmnc & BIT(ARMV7_IDX_TO_COUNTER(idx));
 }

-static inline void armv7_pmnc_select_counter(int idx)
+static inline u32 armv7_pmsel_read(void)
+{
+	u32 pmsel;
+
+	asm volatile("mrc p15, 0, %0, c9, c12, 5" : "=&r" (pmsel));
+	return pmsel;
+}
+
+static inline void armv7_pmsel_write(u32 counter)
 {
-	u32 counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c12, 5" : : "r" (counter));
+}
+
+static inline void armv7_pmnc_select_counter(int idx)
+{
+	armv7_pmsel_write(ARMV7_IDX_TO_COUNTER(idx));
 	isb();
 }

@@ -952,8 +964,15 @@ static irqreturn_t armv7pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
+	u32 pmsel;
 	int idx;

+
+	/*
+	 * Save pmsel in case the interrupted context was using it.
+	 */
+	pmsel = armv7_pmsel_read();
+
 	/*
 	 * Get and reset the IRQ flags
 	 */
@@ -1004,6 +1023,8 @@ static irqreturn_t armv7pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	 */
 	irq_work_run();

+	armv7_pmsel_write(pmsel);
+
 	return IRQ_HANDLED;
 }

--
1.9.1
