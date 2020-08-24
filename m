Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9A24F501
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgHXInj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgHXInf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270BC20FC3;
        Mon, 24 Aug 2020 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258613;
        bh=V/qnBjUrVKqGhq0notUnExub5T1VMCljPUy/iBSdNXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg4ud5DtCsRvOYqhp3KFc71xYT8YbpyCkImle/rQ34toNAqnphtexOxtvSInBBmus
         ekGnhwGzTTgP3pqJLEfxFam9DMoP9tf39OMCvTC18JKChMzZYCaVIjf0QVCYXpIAuT
         UCuxryE7GFypZHFQrMmUhh8X1Gcj0LJiWl4dorh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 109/124] powerpc/pseries/hotplug-cpu: wait indefinitely for vCPU death
Date:   Mon, 24 Aug 2020 10:30:43 +0200
Message-Id: <20200824082414.769766283@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Roth <mdroth@linux.vnet.ibm.com>

[ Upstream commit 801980f6497946048709b9b09771a1729551d705 ]

For a power9 KVM guest with XIVE enabled, running a test loop
where we hotplug 384 vcpus and then unplug them, the following traces
can be seen (generally within a few loops) either from the unplugged
vcpu:

  cpu 65 (hwid 65) Ready to die...
  Querying DEAD? cpu 66 (66) shows 2
  list_del corruption. next->prev should be c00a000002470208, but was c00a000002470048
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:56!
  Oops: Exception in kernel mode, sig: 5 [#1]
  LE SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in: fuse nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 ...
  CPU: 66 PID: 0 Comm: swapper/66 Kdump: loaded Not tainted 4.18.0-221.el8.ppc64le #1
  NIP:  c0000000007ab50c LR: c0000000007ab508 CTR: 00000000000003ac
  REGS: c0000009e5a17840 TRAP: 0700   Not tainted  (4.18.0-221.el8.ppc64le)
  MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28000842  XER: 20040000
  ...
  NIP __list_del_entry_valid+0xac/0x100
  LR  __list_del_entry_valid+0xa8/0x100
  Call Trace:
    __list_del_entry_valid+0xa8/0x100 (unreliable)
    free_pcppages_bulk+0x1f8/0x940
    free_unref_page+0xd0/0x100
    xive_spapr_cleanup_queue+0x148/0x1b0
    xive_teardown_cpu+0x1bc/0x240
    pseries_mach_cpu_die+0x78/0x2f0
    cpu_die+0x48/0x70
    arch_cpu_idle_dead+0x20/0x40
    do_idle+0x2f4/0x4c0
    cpu_startup_entry+0x38/0x40
    start_secondary+0x7bc/0x8f0
    start_secondary_prolog+0x10/0x14

or on the worker thread handling the unplug:

  pseries-hotplug-cpu: Attempting to remove CPU <NULL>, drc index: 1000013a
  Querying DEAD? cpu 314 (314) shows 2
  BUG: Bad page state in process kworker/u768:3  pfn:95de1
  cpu 314 (hwid 314) Ready to die...
  page:c00a000002577840 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0
  flags: 0x5ffffc00000000()
  raw: 005ffffc00000000 5deadbeef0000100 5deadbeef0000200 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffff7f 0000000000000000
  page dumped because: nonzero mapcount
  Modules linked in: kvm xt_CHECKSUM ipt_MASQUERADE xt_conntrack ...
  CPU: 0 PID: 548 Comm: kworker/u768:3 Kdump: loaded Not tainted 4.18.0-224.el8.bz1856588.ppc64le #1
  Workqueue: pseries hotplug workque pseries_hp_work_fn
  Call Trace:
    dump_stack+0xb0/0xf4 (unreliable)
    bad_page+0x12c/0x1b0
    free_pcppages_bulk+0x5bc/0x940
    page_alloc_cpu_dead+0x118/0x120
    cpuhp_invoke_callback.constprop.5+0xb8/0x760
    _cpu_down+0x188/0x340
    cpu_down+0x5c/0xa0
    cpu_subsys_offline+0x24/0x40
    device_offline+0xf0/0x130
    dlpar_offline_cpu+0x1c4/0x2a0
    dlpar_cpu_remove+0xb8/0x190
    dlpar_cpu_remove_by_index+0x12c/0x150
    dlpar_cpu+0x94/0x800
    pseries_hp_work_fn+0x128/0x1e0
    process_one_work+0x304/0x5d0
    worker_thread+0xcc/0x7a0
    kthread+0x1ac/0x1c0
    ret_from_kernel_thread+0x5c/0x80

The latter trace is due to the following sequence:

  page_alloc_cpu_dead
    drain_pages
      drain_pages_zone
        free_pcppages_bulk

where drain_pages() in this case is called under the assumption that
the unplugged cpu is no longer executing. To ensure that is the case,
and early call is made to __cpu_die()->pseries_cpu_die(), which runs a
loop that waits for the cpu to reach a halted state by polling its
status via query-cpu-stopped-state RTAS calls. It only polls for 25
iterations before giving up, however, and in the trace above this
results in the following being printed only .1 seconds after the
hotplug worker thread begins processing the unplug request:

  pseries-hotplug-cpu: Attempting to remove CPU <NULL>, drc index: 1000013a
  Querying DEAD? cpu 314 (314) shows 2

At that point the worker thread assumes the unplugged CPU is in some
unknown/dead state and procedes with the cleanup, causing the race
with the XIVE cleanup code executed by the unplugged CPU.

Fix this by waiting indefinitely, but also making an effort to avoid
spurious lockup messages by allowing for rescheduling after polling
the CPU status and printing a warning if we wait for longer than 120s.

Fixes: eac1e731b59ee ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>
Tested-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
[mpe: Trim oopses in change log slightly for readability]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200811161544.10513-1-mdroth@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 6d4ee03d476a9..ec04fc7f5a641 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -107,22 +107,28 @@ static int pseries_cpu_disable(void)
  */
 static void pseries_cpu_die(unsigned int cpu)
 {
-	int tries;
 	int cpu_status = 1;
 	unsigned int pcpu = get_hard_smp_processor_id(cpu);
+	unsigned long timeout = jiffies + msecs_to_jiffies(120000);
 
-	for (tries = 0; tries < 25; tries++) {
+	while (true) {
 		cpu_status = smp_query_cpu_stopped(pcpu);
 		if (cpu_status == QCSS_STOPPED ||
 		    cpu_status == QCSS_HARDWARE_ERROR)
 			break;
-		cpu_relax();
 
+		if (time_after(jiffies, timeout)) {
+			pr_warn("CPU %i (hwid %i) didn't die after 120 seconds\n",
+				cpu, pcpu);
+			timeout = jiffies + msecs_to_jiffies(120000);
+		}
+
+		cond_resched();
 	}
 
-	if (cpu_status != 0) {
-		printk("Querying DEAD? cpu %i (%i) shows %i\n",
-		       cpu, pcpu, cpu_status);
+	if (cpu_status == QCSS_HARDWARE_ERROR) {
+		pr_warn("CPU %i (hwid %i) reported error while dying\n",
+			cpu, pcpu);
 	}
 
 	/* Isolation and deallocation are definitely done by
-- 
2.25.1



