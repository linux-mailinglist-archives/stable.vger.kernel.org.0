Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72FB3B6375
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhF1O5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhF1OxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 376EF61CB2;
        Mon, 28 Jun 2021 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891050;
        bh=GB+9jH144PpKcUwCnM/eGiL5EfEWHZ/J6bbZxDPKUl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHq4g928D9jbB4G2f8PidyU+M/bzED/qN8gnuqTxcD5HlqThZ2sH8Qvn4yShuqe+K
         et6rmrzMhQpxNDcaCjY9/QPyEdfz6MQ5eTqVJO4LJwyDzadRGVimMpV/8WmQKkbGOW
         CTzJVjny2pg9Iyki8viBM3kUWtAfRLwMxZ4fovWkiLhsbY3zZBnpnSHy37OdIDJD2S
         Q2M8lmHduWbS8gmWtn30hWTO2Y3uPtb16YhY2uhZO1TbkfWlJmVcgIFH8t94NuL0ii
         oEbYDsPcsJioo7GcLI62yLn0SIOj96aMDFZNQ0NpcqfljXG/23YY2CFhTyHNzEqJau
         OWXlaN87ulntw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Aman Priyadarshi <apeureka@amazon.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 70/88] arm64: perf: Disable PMU while processing counter overflows
Date:   Mon, 28 Jun 2021 10:36:10 -0400
Message-Id: <20210628143628.33342-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
2.30.2

