Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCED13803A
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgAKK1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgAKK1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:27:11 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C6B2082E;
        Sat, 11 Jan 2020 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738429;
        bh=mwqyoTpvLEDwEPow5Q3vEsE2nvTb/nf7aFQzJfPSppc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czVo5TgzlROMoOjxi9pjT8kkw1p1wKi2u7NeNmnUWdXqmhPih/6xzeZyvFTI1Gg1X
         eaD+Cp74LLX8YE5p50ldhcFWt7WjFAR5R+cWiqur8SIDSd4dHerDF4uMUZ0FcAVCJC
         REqHNe0OsxsqCqd6iuVLe9FXTNU/pE9QWkwFeGfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parth Shah <parth@linux.ibm.com>,
        Ihor Pasichnyk <Ihor.Pasichnyk@ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Waiman Long <longman@redhat.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Phil Auld <pauld@redhat.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 075/165] powerpc/vcpu: Assume dedicated processors as non-preempt
Date:   Sat, 11 Jan 2020 10:49:54 +0100
Message-Id: <20200111094927.461950065@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

commit 14c73bd344da60abaf7da3ea2e7733ddda35bbac upstream.

With commit 247f2f6f3c70 ("sched/core: Don't schedule threads on
pre-empted vCPUs"), the scheduler avoids preempted vCPUs to schedule
tasks on wakeup. This leads to wrong choice of CPU, which in-turn
leads to larger wakeup latencies. Eventually, it leads to performance
regression in latency sensitive benchmarks like soltp, schbench etc.

On Powerpc, vcpu_is_preempted() only looks at yield_count. If the
yield_count is odd, the vCPU is assumed to be preempted. However
yield_count is increased whenever the LPAR enters CEDE state (idle).
So any CPU that has entered CEDE state is assumed to be preempted.

Even if vCPU of dedicated LPAR is preempted/donated, it should have
right of first-use since they are supposed to own the vCPU.

On a Power9 System with 32 cores:
  # lscpu
  Architecture:        ppc64le
  Byte Order:          Little Endian
  CPU(s):              128
  On-line CPU(s) list: 0-127
  Thread(s) per core:  8
  Core(s) per socket:  1
  Socket(s):           16
  NUMA node(s):        2
  Model:               2.2 (pvr 004e 0202)
  Model name:          POWER9 (architected), altivec supported
  Hypervisor vendor:   pHyp
  Virtualization type: para
  L1d cache:           32K
  L1i cache:           32K
  L2 cache:            512K
  L3 cache:            10240K
  NUMA node0 CPU(s):   0-63
  NUMA node1 CPU(s):   64-127

  # perf stat -a -r 5 ./schbench
  v5.4                               v5.4 + patch
  Latency percentiles (usec)         Latency percentiles (usec)
        50.0000th: 45                      50.0th: 45
        75.0000th: 62                      75.0th: 63
        90.0000th: 71                      90.0th: 74
        95.0000th: 77                      95.0th: 78
        *99.0000th: 91                     *99.0th: 82
        99.5000th: 707                     99.5th: 83
        99.9000th: 6920                    99.9th: 86
        min=0, max=10048                   min=0, max=96
  Latency percentiles (usec)         Latency percentiles (usec)
        50.0000th: 45                      50.0th: 46
        75.0000th: 61                      75.0th: 64
        90.0000th: 72                      90.0th: 75
        95.0000th: 79                      95.0th: 79
        *99.0000th: 691                    *99.0th: 83
        99.5000th: 3972                    99.5th: 85
        99.9000th: 8368                    99.9th: 91
        min=0, max=16606                   min=0, max=117
  Latency percentiles (usec)         Latency percentiles (usec)
        50.0000th: 45                      50.0th: 46
        75.0000th: 61                      75.0th: 64
        90.0000th: 71                      90.0th: 75
        95.0000th: 77                      95.0th: 79
        *99.0000th: 106                    *99.0th: 83
        99.5000th: 2364                    99.5th: 84
        99.9000th: 7480                    99.9th: 90
        min=0, max=10001                   min=0, max=95
  Latency percentiles (usec)         Latency percentiles (usec)
        50.0000th: 45                      50.0th: 47
        75.0000th: 62                      75.0th: 65
        90.0000th: 72                      90.0th: 75
        95.0000th: 78                      95.0th: 79
        *99.0000th: 93                     *99.0th: 84
        99.5000th: 108                     99.5th: 85
        99.9000th: 6792                    99.9th: 90
        min=0, max=17681                   min=0, max=117
  Latency percentiles (usec)         Latency percentiles (usec)
        50.0000th: 46                      50.0th: 45
        75.0000th: 62                      75.0th: 64
        90.0000th: 73                      90.0th: 75
        95.0000th: 79                      95.0th: 79
        *99.0000th: 113                    *99.0th: 82
        99.5000th: 2724                    99.5th: 83
        99.9000th: 6184                    99.9th: 93
        min=0, max=9887                    min=0, max=111

   Performance counter stats for 'system wide' (5 runs):

  context-switches    43,373  ( +-  0.40% )   44,597 ( +-  0.55% )
  cpu-migrations       1,211  ( +-  5.04% )      220 ( +-  6.23% )
  page-faults         15,983  ( +-  5.21% )   15,360 ( +-  3.38% )

Waiman Long suggested using static_keys.

Fixes: 247f2f6f3c70 ("sched/core: Don't schedule threads on pre-empted vCPUs")
Cc: stable@vger.kernel.org # v4.18+
Reported-by: Parth Shah <parth@linux.ibm.com>
Reported-by: Ihor Pasichnyk <Ihor.Pasichnyk@ibm.com>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Tested-by: Parth Shah <parth@linux.ibm.com>
[mpe: Move the key and setting of the key to pseries/setup.c]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191213035036.6913-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/spinlock.h    |    4 +++-
 arch/powerpc/platforms/pseries/setup.c |    7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -36,10 +36,12 @@
 #endif
 
 #ifdef CONFIG_PPC_PSERIES
+DECLARE_STATIC_KEY_FALSE(shared_processor);
+
 #define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(int cpu)
 {
-	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
+	if (!static_branch_unlikely(&shared_processor))
 		return false;
 	return !!(be32_to_cpu(lppaca_of(cpu).yield_count) & 1);
 }
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -74,6 +74,9 @@
 #include "pseries.h"
 #include "../../../../drivers/pci/pci.h"
 
+DEFINE_STATIC_KEY_FALSE(shared_processor);
+EXPORT_SYMBOL_GPL(shared_processor);
+
 int CMO_PrPSP = -1;
 int CMO_SecPSP = -1;
 unsigned long CMO_PageSize = (ASM_CONST(1) << IOMMU_PAGE_SHIFT_4K);
@@ -758,6 +761,10 @@ static void __init pSeries_setup_arch(vo
 
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		vpa_init(boot_cpuid);
+
+		if (lppaca_shared_proc(get_lppaca()))
+			static_branch_enable(&shared_processor);
+
 		ppc_md.power_save = pseries_lpar_idle;
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
 #ifdef CONFIG_PCI_IOV


