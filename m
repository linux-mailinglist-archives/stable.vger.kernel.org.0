Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEB5939D0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245384AbiHOT2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344918AbiHOT12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D8E5B78C;
        Mon, 15 Aug 2022 11:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45524B81084;
        Mon, 15 Aug 2022 18:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE3AC433D6;
        Mon, 15 Aug 2022 18:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588995;
        bh=pJnMWDnMzy10rYH7E792Cl5WrTV1NQgSAUWHLyCQRbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpzEUYV63E6u7PDHNdQscTVoeo/bmVuc8Zd/4lLqqLgcaTiFC+seYeWQTJ8OMP2jz
         KUHOBxrUf1PAGAVnABD/Wsl0LodtBkgeK0fLezgKjetRH4WMSUHzW1qHamssASdGYI
         k272xNP9El/pgGLSOQ2SUtzC9yEJJswCnOWVAiAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/779] powerpc/perf: Optimize clearing the pending PMI and remove WARN_ON for PMI check in power_pmu_disable
Date:   Mon, 15 Aug 2022 20:03:44 +0200
Message-Id: <20220815180402.130977064@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 890005a7d98f7452cfe86dcfb2aeeb7df01132ce ]

commit 2c9ac51b850d ("powerpc/perf: Fix PMU callbacks to clear
pending PMI before resetting an overflown PMC") added a new
function "pmi_irq_pending" in hw_irq.h. This function is to check
if there is a PMI marked as pending in Paca (PACA_IRQ_PMI).This is
used in power_pmu_disable in a WARN_ON. The intention here is to
provide a warning if there is PMI pending, but no counter is found
overflown.

During some of the perf runs, below warning is hit:

WARNING: CPU: 36 PID: 0 at arch/powerpc/perf/core-book3s.c:1332 power_pmu_disable+0x25c/0x2c0
 Modules linked in:
 -----

 NIP [c000000000141c3c] power_pmu_disable+0x25c/0x2c0
 LR [c000000000141c8c] power_pmu_disable+0x2ac/0x2c0
 Call Trace:
 [c000000baffcfb90] [c000000000141c8c] power_pmu_disable+0x2ac/0x2c0 (unreliable)
 [c000000baffcfc10] [c0000000003e2f8c] perf_pmu_disable+0x4c/0x60
 [c000000baffcfc30] [c0000000003e3344] group_sched_out.part.124+0x44/0x100
 [c000000baffcfc80] [c0000000003e353c] __perf_event_disable+0x13c/0x240
 [c000000baffcfcd0] [c0000000003dd334] event_function+0xc4/0x140
 [c000000baffcfd20] [c0000000003d855c] remote_function+0x7c/0xa0
 [c000000baffcfd50] [c00000000026c394] flush_smp_call_function_queue+0xd4/0x300
 [c000000baffcfde0] [c000000000065b24] smp_ipi_demux_relaxed+0xa4/0x100
 [c000000baffcfe20] [c0000000000cb2b0] xive_muxed_ipi_action+0x20/0x40
 [c000000baffcfe40] [c000000000207c3c] __handle_irq_event_percpu+0x8c/0x250
 [c000000baffcfee0] [c000000000207e2c] handle_irq_event_percpu+0x2c/0xa0
 [c000000baffcff10] [c000000000210a04] handle_percpu_irq+0x84/0xc0
 [c000000baffcff40] [c000000000205f14] generic_handle_irq+0x54/0x80
 [c000000baffcff60] [c000000000015740] __do_irq+0x90/0x1d0
 [c000000baffcff90] [c000000000016990] __do_IRQ+0xc0/0x140
 [c0000009732f3940] [c000000bafceaca8] 0xc000000bafceaca8
 [c0000009732f39d0] [c000000000016b78] do_IRQ+0x168/0x1c0
 [c0000009732f3a00] [c0000000000090c8] hardware_interrupt_common_virt+0x218/0x220

This means that there is no PMC overflown among the active events
in the PMU, but there is a PMU pending in Paca. The function
"any_pmc_overflown" checks the PMCs on active events in
cpuhw->n_events. Code snippet:

<<>>
if (any_pmc_overflown(cpuhw))
 	clear_pmi_irq_pending();
 else
 	WARN_ON(pmi_irq_pending());
<<>>

Here the PMC overflown is not from active event. Example: When we do
perf record, default cycles and instructions will be running on PMC6
and PMC5 respectively. It could happen that overflowed event is currently
not active and pending PMI is for the inactive event. Debug logs from
trace_printk:

<<>>
any_pmc_overflown: idx is 5: pmc value is 0xd9a
power_pmu_disable: PMC1: 0x0, PMC2: 0x0, PMC3: 0x0, PMC4: 0x0, PMC5: 0xd9a, PMC6: 0x80002011
<<>>

Here active PMC (from idx) is PMC5 , but overflown PMC is PMC6(0x80002011).
When we handle PMI interrupt for such cases, if the PMC overflown is
from inactive event, it will be ignored. Reference commit:
commit bc09c219b2e6 ("powerpc/perf: Fix finding overflowed PMC in interrupt")

Patch addresses two changes:
1) Fix 1 : Removal of warning ( WARN_ON(pmi_irq_pending()); )
   We were printing warning if no PMC is found overflown among active PMU
   events, but PMI pending in PACA. But this could happen in cases where
   PMC overflown is not in active PMC. An inactive event could have caused
   the overflow. Hence the warning is not needed. To know pending PMI is
   from an inactive event, we need to loop through all PMC's which will
   cause more SPR reads via mfspr and increase in context switch. Also in
   existing function: perf_event_interrupt, already we ignore PMI's
   overflown when it is from an inactive PMC.

2) Fix 2: optimization in clearing pending PMI.
   Currently we check for any active PMC overflown before clearing PMI
   pending in Paca. This is causing additional SPR read also. From point 1,
   we know that if PMI pending in Paca from inactive cases, that is going
   to be ignored during replay. Hence if there is pending PMI in Paca, just
   clear it irrespective of PMC overflown or not.

In summary, remove the any_pmc_overflown check entirely in
power_pmu_disable. ie If there is a pending PMI in Paca, clear it, since
we are in pmu_disable. There could be cases where PMI is pending because
of inactive PMC ( which later when replayed also will get ignored ), so
WARN_ON could give false warning. Hence removing it.

Fixes: 2c9ac51b850d ("powerpc/perf: Fix PMU callbacks to clear pending PMI before resetting an overflown PMC")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220522142256.24699-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 35 ++++++++++++++-------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index e78de7050947..1078784b74c9 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1320,27 +1320,22 @@ static void power_pmu_disable(struct pmu *pmu)
 		 * a PMI happens during interrupt replay and perf counter
 		 * values are cleared by PMU callbacks before replay.
 		 *
-		 * If any PMC corresponding to the active PMU events are
-		 * overflown, disable the interrupt by clearing the paca
-		 * bit for PMI since we are disabling the PMU now.
-		 * Otherwise provide a warning if there is PMI pending, but
-		 * no counter is found overflown.
+		 * Disable the interrupt by clearing the paca bit for PMI
+		 * since we are disabling the PMU now. Otherwise provide a
+		 * warning if there is PMI pending, but no counter is found
+		 * overflown.
+		 *
+		 * Since power_pmu_disable runs under local_irq_save, it
+		 * could happen that code hits a PMC overflow without PMI
+		 * pending in paca. Hence only clear PMI pending if it was
+		 * set.
+		 *
+		 * If a PMI is pending, then MSR[EE] must be disabled (because
+		 * the masked PMI handler disabling EE). So it is safe to
+		 * call clear_pmi_irq_pending().
 		 */
-		if (any_pmc_overflown(cpuhw)) {
-			/*
-			 * Since power_pmu_disable runs under local_irq_save, it
-			 * could happen that code hits a PMC overflow without PMI
-			 * pending in paca. Hence only clear PMI pending if it was
-			 * set.
-			 *
-			 * If a PMI is pending, then MSR[EE] must be disabled (because
-			 * the masked PMI handler disabling EE). So it is safe to
-			 * call clear_pmi_irq_pending().
-			 */
-			if (pmi_irq_pending())
-				clear_pmi_irq_pending();
-		} else
-			WARN_ON(pmi_irq_pending());
+		if (pmi_irq_pending())
+			clear_pmi_irq_pending();
 
 		val = mmcra = cpuhw->mmcr.mmcra;
 
-- 
2.35.1



