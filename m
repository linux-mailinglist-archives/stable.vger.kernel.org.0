Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425783B63F0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhF1PC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236581AbhF1PAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE69761D6C;
        Mon, 28 Jun 2021 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891252;
        bh=21gV05pCDisHvB5GmvFfLTpUbqjlPegoJs+6fmYqmOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPu4+9xMjzPkEE14GckdlI3pY5z2z+F5A7qfaNKPpBynvBPvFko5GczM9XnR3eH50
         3TY3gz47SJOqaVSGvVDftvppDcZBCq1hXVEtnDr/sLr+9/cTnDIWfmB+LIk2Nmyu5C
         VodCnSRYrk1bMUClXHwhWf8bEVIfONC0xYt/BmTYNYc93+Ed5ChGYVS3RKYrWUyEST
         qEVrQKodAUU7DQszLsvqGV1iXB1rOEO9lR0sJYC6IZRwi8qwj8cefQY9r/6MlvjHS+
         OGEqhIfvxuS1HFN/Ls1/Z4qqrSZyYh9PR5l+O+7D+aiJ1hK8c36w6IwlevtqBAHzAu
         NKqt/56P74uRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Aman Priyadarshi <apeureka@amazon.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 54/71] arm64: perf: Disable PMU while processing counter overflows
Date:   Mon, 28 Jun 2021 10:39:46 -0400
Message-Id: <20210628144003.34260-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 3cce50dfec4a5b0414c974190940f47dd32c6dee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/perf_event.c | 50 +++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 0770d6d1c37f..7f95d6ac2011 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -748,6 +748,28 @@ static void armv8pmu_disable_event(struct perf_event *event)
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
@@ -773,6 +795,11 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
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
@@ -797,6 +824,7 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
 		if (perf_event_overflow(event, &data, regs))
 			cpu_pmu->disable(event);
 	}
+	armv8pmu_start(cpu_pmu);
 
 	/*
 	 * Handle the pending perf events.
@@ -810,28 +838,6 @@ static irqreturn_t armv8pmu_handle_irq(int irq_num, void *dev)
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
2.30.2

