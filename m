Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CA64A4505
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359524AbiAaLfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349840AbiAaLYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327E6C08E879;
        Mon, 31 Jan 2022 03:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C77B82A72;
        Mon, 31 Jan 2022 11:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368E9C340EF;
        Mon, 31 Jan 2022 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627700;
        bh=GjGO6KS8Wz7i9WHvfILtYVTbWhOHZcSOqBUaV99E+jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RDcbeYt4H/Qmu0LD29PWChUX8oCq2hWHrW1DlPvYSguXncz9COOlccY3Tki7/CfR
         E7XmywRZzxWBUo1k0HImarsTE38M9+09qPeNtAR6DqoZMT9xCYR55tDPVD4U1ytP/I
         8phobTVc9Lz3Q25aQO+TiGdUFHXpwrrqbj+LDHu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/171] powerpc/perf: Fix power_pmu_disable to call clear_pmi_irq_pending only if PMI is pending
Date:   Mon, 31 Jan 2022 11:56:41 +0100
Message-Id: <20220131105234.610987056@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit fb6433b48a178d4672cb26632454ee0b21056eaa ]

Running selftest with CONFIG_PPC_IRQ_SOFT_MASK_DEBUG enabled in kernel
triggered below warning:

[  172.851380] ------------[ cut here ]------------
[  172.851391] WARNING: CPU: 8 PID: 2901 at arch/powerpc/include/asm/hw_irq.h:246 power_pmu_disable+0x270/0x280
[  172.851402] Modules linked in: dm_mod bonding nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables rfkill nfnetlink sunrpc xfs libcrc32c pseries_rng xts vmx_crypto uio_pdrv_genirq uio sch_fq_codel ip_tables ext4 mbcache jbd2 sd_mod t10_pi sg ibmvscsi ibmveth scsi_transport_srp fuse
[  172.851442] CPU: 8 PID: 2901 Comm: lost_exception_ Not tainted 5.16.0-rc5-03218-g798527287598 #2
[  172.851451] NIP:  c00000000013d600 LR: c00000000013d5a4 CTR: c00000000013b180
[  172.851458] REGS: c000000017687860 TRAP: 0700   Not tainted  (5.16.0-rc5-03218-g798527287598)
[  172.851465] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 48004884  XER: 20040000
[  172.851482] CFAR: c00000000013d5b4 IRQMASK: 1
[  172.851482] GPR00: c00000000013d5a4 c000000017687b00 c000000002a10600 0000000000000004
[  172.851482] GPR04: 0000000082004000 c0000008ba08f0a8 0000000000000000 00000008b7ed0000
[  172.851482] GPR08: 00000000446194f6 0000000000008000 c00000000013b118 c000000000d58e68
[  172.851482] GPR12: c00000000013d390 c00000001ec54a80 0000000000000000 0000000000000000
[  172.851482] GPR16: 0000000000000000 0000000000000000 c000000015d5c708 c0000000025396d0
[  172.851482] GPR20: 0000000000000000 0000000000000000 c00000000a3bbf40 0000000000000003
[  172.851482] GPR24: 0000000000000000 c0000008ba097400 c0000000161e0d00 c00000000a3bb600
[  172.851482] GPR28: c000000015d5c700 0000000000000001 0000000082384090 c0000008ba0020d8
[  172.851549] NIP [c00000000013d600] power_pmu_disable+0x270/0x280
[  172.851557] LR [c00000000013d5a4] power_pmu_disable+0x214/0x280
[  172.851565] Call Trace:
[  172.851568] [c000000017687b00] [c00000000013d5a4] power_pmu_disable+0x214/0x280 (unreliable)
[  172.851579] [c000000017687b40] [c0000000003403ac] perf_pmu_disable+0x4c/0x60
[  172.851588] [c000000017687b60] [c0000000003445e4] __perf_event_task_sched_out+0x1d4/0x660
[  172.851596] [c000000017687c50] [c000000000d1175c] __schedule+0xbcc/0x12a0
[  172.851602] [c000000017687d60] [c000000000d11ea8] schedule+0x78/0x140
[  172.851608] [c000000017687d90] [c0000000001a8080] sys_sched_yield+0x20/0x40
[  172.851615] [c000000017687db0] [c0000000000334dc] system_call_exception+0x18c/0x380
[  172.851622] [c000000017687e10] [c00000000000c74c] system_call_common+0xec/0x268

The warning indicates that MSR_EE being set(interrupt enabled) when
there was an overflown PMC detected. This could happen in
power_pmu_disable since it runs under interrupt soft disable
condition ( local_irq_save ) and not with interrupts hard disabled.
commit 2c9ac51b850d ("powerpc/perf: Fix PMU callbacks to clear
pending PMI before resetting an overflown PMC") intended to clear
PMI pending bit in Paca when disabling the PMU. It could happen
that PMC gets overflown while code is in power_pmu_disable
callback function. Hence add a check to see if PMI pending bit
is set in Paca before clearing it via clear_pmi_pending.

Fixes: 2c9ac51b850d ("powerpc/perf: Fix PMU callbacks to clear pending PMI before resetting an overflown PMC")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220122033429.25395-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index bef6b1abce702..e78de70509472 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1326,9 +1326,20 @@ static void power_pmu_disable(struct pmu *pmu)
 		 * Otherwise provide a warning if there is PMI pending, but
 		 * no counter is found overflown.
 		 */
-		if (any_pmc_overflown(cpuhw))
-			clear_pmi_irq_pending();
-		else
+		if (any_pmc_overflown(cpuhw)) {
+			/*
+			 * Since power_pmu_disable runs under local_irq_save, it
+			 * could happen that code hits a PMC overflow without PMI
+			 * pending in paca. Hence only clear PMI pending if it was
+			 * set.
+			 *
+			 * If a PMI is pending, then MSR[EE] must be disabled (because
+			 * the masked PMI handler disabling EE). So it is safe to
+			 * call clear_pmi_irq_pending().
+			 */
+			if (pmi_irq_pending())
+				clear_pmi_irq_pending();
+		} else
 			WARN_ON(pmi_irq_pending());
 
 		val = mmcra = cpuhw->mmcr.mmcra;
-- 
2.34.1



