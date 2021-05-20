Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5738A76B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhETKiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237928AbhETKgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47E4161C61;
        Thu, 20 May 2021 09:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504446;
        bh=rhsdsW/d5DhqRkV1tL++ZZ6PSY0b5/oYcXi0PA5NZYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Osmh4woknMTuBpAg3VQFDSSNoNnKWnwDtp8+29dtV2ZtFnAgDGNo+k1xIH1RjXZPy
         iG5L6cxqYBmFl6UjptXGkxB7DhdGZ8JYxULtP5UwzDcqSxP4tKtuveEPWrP/YzX1BN
         pva2kf+G8j0OD4Kq3IURjPwEIWS4z08z3R3MEsUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 250/323] powerpc/smp: Set numa node before updating mask
Date:   Thu, 20 May 2021 11:22:22 +0200
Message-Id: <20210520092128.767927643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit 6980d13f0dd189846887bbbfa43793d9a41768d3 ]

Geethika reported a trace when doing a dlpar CPU add.

------------[ cut here ]------------
WARNING: CPU: 152 PID: 1134 at kernel/sched/topology.c:2057
CPU: 152 PID: 1134 Comm: kworker/152:1 Not tainted 5.12.0-rc5-master #5
Workqueue: events cpuset_hotplug_workfn
NIP:  c0000000001cfc14 LR: c0000000001cfc10 CTR: c0000000007e3420
REGS: c0000034a08eb260 TRAP: 0700   Not tainted  (5.12.0-rc5-master+)
MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28828422  XER: 00000020
CFAR: c0000000001fd888 IRQMASK: 0 #012GPR00: c0000000001cfc10
c0000034a08eb500 c000000001f35400 0000000000000027 #012GPR04:
c0000035abaa8010 c0000035abb30a00 0000000000000027 c0000035abaa8018
#012GPR08: 0000000000000023 c0000035abaaef48 00000035aa540000
c0000035a49dffe8 #012GPR12: 0000000028828424 c0000035bf1a1c80
0000000000000497 0000000000000004 #012GPR16: c00000000347a258
0000000000000140 c00000000203d468 c000000001a1a490 #012GPR20:
c000000001f9c160 c0000034adf70920 c0000034aec9fd20 0000000100087bd3
#012GPR24: 0000000100087bd3 c0000035b3de09f8 0000000000000030
c0000035b3de09f8 #012GPR28: 0000000000000028 c00000000347a280
c0000034aefe0b00 c0000000010a2a68
NIP [c0000000001cfc14] build_sched_domains+0x6a4/0x1500
LR [c0000000001cfc10] build_sched_domains+0x6a0/0x1500
Call Trace:
[c0000034a08eb500] [c0000000001cfc10] build_sched_domains+0x6a0/0x1500 (unreliable)
[c0000034a08eb640] [c0000000001d1e6c] partition_sched_domains_locked+0x3ec/0x530
[c0000034a08eb6e0] [c0000000002936d4] rebuild_sched_domains_locked+0x524/0xbf0
[c0000034a08eb7e0] [c000000000296bb0] rebuild_sched_domains+0x40/0x70
[c0000034a08eb810] [c000000000296e74] cpuset_hotplug_workfn+0x294/0xe20
[c0000034a08ebc30] [c000000000178dd0] process_one_work+0x300/0x670
[c0000034a08ebd10] [c0000000001791b8] worker_thread+0x78/0x520
[c0000034a08ebda0] [c000000000185090] kthread+0x1a0/0x1b0
[c0000034a08ebe10] [c00000000000ccec] ret_from_kernel_thread+0x5c/0x70
Instruction dump:
7d2903a6 4e800421 e8410018 7f67db78 7fe6fb78 7f45d378 7f84e378 7c681b78
3c62ff1a 3863c6f8 4802dc35 60000000 <0fe00000> 3920fff4 f9210070 e86100a0
---[ end trace 532d9066d3d4d7ec ]---

Some of the per-CPU masks use cpu_cpu_mask as a filter to limit the search
for related CPUs. On a dlpar add of a CPU, update cpu_cpu_mask before
updating the per-CPU masks. This will ensure the cpu_cpu_mask is updated
correctly before its used in setting the masks. Setting the numa_node will
ensure that when cpu_cpu_mask() gets called, the correct node number is
used. This code movement helped fix the above call trace.

Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210401154200.150077-1-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index e0a4c1f82e25..7c7aa7c98ba3 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -985,6 +985,9 @@ void start_secondary(void *unused)
 
 	vdso_getcpu_init();
 #endif
+	set_numa_node(numa_cpu_lookup_table[cpu]);
+	set_numa_mem(local_memory_node(numa_cpu_lookup_table[cpu]));
+
 	/* Update topology CPU masks */
 	add_cpu_to_masks(cpu);
 
@@ -995,9 +998,6 @@ void start_secondary(void *unused)
 	if (!cpumask_equal(cpu_l2_cache_mask(cpu), cpu_sibling_mask(cpu)))
 		shared_caches = true;
 
-	set_numa_node(numa_cpu_lookup_table[cpu]);
-	set_numa_mem(local_memory_node(numa_cpu_lookup_table[cpu]));
-
 	smp_wmb();
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
-- 
2.30.2



