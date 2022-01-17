Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E97490EE2
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbiAQRMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244214AbiAQRLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:11:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A192AC0613F0;
        Mon, 17 Jan 2022 09:06:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32FDE61248;
        Mon, 17 Jan 2022 17:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EEDC36AE3;
        Mon, 17 Jan 2022 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439212;
        bh=1G5W5+597GyiCixdJ+b9k+vwhTT84W5MJH0OG6McupM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUardsG514zSL1BFbVeqRvDu8e6HIbGr678Y4VawFfZjnLQjdBi1oy2AozJj1xQRp
         8VEM7CZlZptX2TGCbRMUD13i4Reb8exJcD/0ZeRt4wC6I1li9FCh8At7/1WaK8ea7J
         iAPH9jh/9JD5rqUYoXYIZs4BmRtF8YmbCgU4dpCEIBvKd9281qIZkqxYneHsyy3ByZ
         4Jcid2uUEj3pur2IzoASaVLA5xUNZBeo6JdvVFGCYa486df5wjsdYp/VYx+36iny/W
         W98MyH8mP2IvjX88dnyRzn/LqK6MRVWY0OBAxl6Th+APGiebKNSYmc9AH8Ut5MXA3k
         SyngcFTdOM9ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pmladek@suse.com,
        john.ogness@linutronix.de, clg@kaod.org, sudeep.holla@arm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 06/16] powerpc/watchdog: Fix missed watchdog reset due to memory ordering race
Date:   Mon, 17 Jan 2022 12:06:28 -0500
Message-Id: <20220117170638.1472900-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170638.1472900-1-sashal@kernel.org>
References: <20220117170638.1472900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5dad4ba68a2483fc80d70b9dc90bbe16e1f27263 ]

It is possible for all CPUs to miss the pending cpumask becoming clear,
and then nobody resetting it, which will cause the lockup detector to
stop working. It will eventually expire, but watchdog_smp_panic will
avoid doing anything if the pending mask is clear and it will never be
reset.

Order the cpumask clear vs the subsequent test to close this race.

Add an extra check for an empty pending mask when the watchdog fires and
finds its bit still clear, to try to catch any other possible races or
bugs here and keep the watchdog working. The extra test in
arch_touch_nmi_watchdog is required to prevent the new warning from
firing off.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Debugged-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211110025056.2084347-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/watchdog.c | 41 +++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/watchdog.c b/arch/powerpc/kernel/watchdog.c
index ce848ff84eddf..1617767ebc9ae 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -106,6 +106,10 @@ static void set_cpumask_stuck(const struct cpumask *cpumask, u64 tb)
 {
 	cpumask_or(&wd_smp_cpus_stuck, &wd_smp_cpus_stuck, cpumask);
 	cpumask_andnot(&wd_smp_cpus_pending, &wd_smp_cpus_pending, cpumask);
+	/*
+	 * See wd_smp_clear_cpu_pending()
+	 */
+	smp_mb();
 	if (cpumask_empty(&wd_smp_cpus_pending)) {
 		wd_smp_last_reset_tb = tb;
 		cpumask_andnot(&wd_smp_cpus_pending,
@@ -177,13 +181,44 @@ static void wd_smp_clear_cpu_pending(int cpu, u64 tb)
 			wd_smp_lock(&flags);
 			cpumask_clear_cpu(cpu, &wd_smp_cpus_stuck);
 			wd_smp_unlock(&flags);
+		} else {
+			/*
+			 * The last CPU to clear pending should have reset the
+			 * watchdog so we generally should not find it empty
+			 * here if our CPU was clear. However it could happen
+			 * due to a rare race with another CPU taking the
+			 * last CPU out of the mask concurrently.
+			 *
+			 * We can't add a warning for it. But just in case
+			 * there is a problem with the watchdog that is causing
+			 * the mask to not be reset, try to kick it along here.
+			 */
+			if (unlikely(cpumask_empty(&wd_smp_cpus_pending)))
+				goto none_pending;
 		}
 		return;
 	}
+
 	cpumask_clear_cpu(cpu, &wd_smp_cpus_pending);
+
+	/*
+	 * Order the store to clear pending with the load(s) to check all
+	 * words in the pending mask to check they are all empty. This orders
+	 * with the same barrier on another CPU. This prevents two CPUs
+	 * clearing the last 2 pending bits, but neither seeing the other's
+	 * store when checking if the mask is empty, and missing an empty
+	 * mask, which ends with a false positive.
+	 */
+	smp_mb();
 	if (cpumask_empty(&wd_smp_cpus_pending)) {
 		unsigned long flags;
 
+none_pending:
+		/*
+		 * Double check under lock because more than one CPU could see
+		 * a clear mask with the lockless check after clearing their
+		 * pending bits.
+		 */
 		wd_smp_lock(&flags);
 		if (cpumask_empty(&wd_smp_cpus_pending)) {
 			wd_smp_last_reset_tb = tb;
@@ -276,8 +311,12 @@ void arch_touch_nmi_watchdog(void)
 {
 	unsigned long ticks = tb_ticks_per_usec * wd_timer_period_ms * 1000;
 	int cpu = smp_processor_id();
-	u64 tb = get_tb();
+	u64 tb;
+
+	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
+		return;
 
+	tb = get_tb();
 	if (tb - per_cpu(wd_timer_tb, cpu) >= ticks) {
 		per_cpu(wd_timer_tb, cpu) = tb;
 		wd_smp_clear_cpu_pending(cpu, tb);
-- 
2.34.1

