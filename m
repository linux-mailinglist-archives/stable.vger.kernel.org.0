Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16C4991CC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbiAXUO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349334AbiAXUNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5B0C061765;
        Mon, 24 Jan 2022 11:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BFB7614FC;
        Mon, 24 Jan 2022 19:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3356C340E5;
        Mon, 24 Jan 2022 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052956;
        bh=fqghv2tM9KQdZtwnpamw7ZoE6favq2oByT6WYmfaJKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4r6HlSDzXweTuTb2eNTILEfjgfGJ8oyVtGra3tkhSXsGLC8LjgIRcOMz6h2ZleiW
         LRGQY4JHBlJEnuhjMzAz840sYAtzOqt72h0laZf1eeYzrl9g5eFIHXIygXFG9uUIr2
         GlIUVcGNlxLSBurDZNUUh+lFvkpwpEMs14/2AYX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/320] powerpc/watchdog: Fix missed watchdog reset due to memory ordering race
Date:   Mon, 24 Jan 2022 19:43:32 +0100
Message-Id: <20220124184001.741509727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index af3c15a1d41eb..75b2a6c4db5a5 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -132,6 +132,10 @@ static void set_cpumask_stuck(const struct cpumask *cpumask, u64 tb)
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
@@ -217,13 +221,44 @@ static void wd_smp_clear_cpu_pending(int cpu, u64 tb)
 
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
@@ -314,8 +349,12 @@ void arch_touch_nmi_watchdog(void)
 {
 	unsigned long ticks = tb_ticks_per_usec * wd_timer_period_ms * 1000;
 	int cpu = smp_processor_id();
-	u64 tb = get_tb();
+	u64 tb;
 
+	if (!cpumask_test_cpu(cpu, &watchdog_cpumask))
+		return;
+
+	tb = get_tb();
 	if (tb - per_cpu(wd_timer_tb, cpu) >= ticks) {
 		per_cpu(wd_timer_tb, cpu) = tb;
 		wd_smp_clear_cpu_pending(cpu, tb);
-- 
2.34.1



