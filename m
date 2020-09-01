Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADCB259466
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgIAPjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgIAPjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FEC7205F4;
        Tue,  1 Sep 2020 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974751;
        bh=RYwLB6hsXqUVuuWOGpN+7Mj6mlUmyTGE+toBtsZAumU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtAdOvbuJYcs/ZOrvOaunzAnQZW31ONZdibVE4TFu8m0lDzHsDDvi4w9TUtcN4q9a
         2L6ipzPhp/G7GYfkg6oldWgYZIlupeA3b7Rncdja7hJ4hRQlgQg9BDS/jsyL2BmFbZ
         u4/3pTBDnt+ItVOTLJlYcc/wtAG9a0VwIzzKKwd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 077/255] arm64: Fix __cpu_logical_map undefined issue
Date:   Tue,  1 Sep 2020 17:08:53 +0200
Message-Id: <20200901151004.422558958@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit eaecca9e7710281be7c31d892c9f447eafd7ddd9 ]

The __cpu_logical_map undefined issue occued when the new
tegra194-cpufreq drvier building as a module.

ERROR: modpost: "__cpu_logical_map" [drivers/cpufreq/tegra194-cpufreq.ko] undefined!

The driver using cpu_logical_map() macro which will expand to
__cpu_logical_map, we can't access it in a drvier. Let's turn
cpu_logical_map() into a C wrapper and export it to fix the
build issue.

Also create a function set_cpu_logical_map(cpu, hwid) when assign
a value to cpu_logical_map(cpu).

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/smp.h | 7 ++++++-
 arch/arm64/kernel/setup.c    | 8 +++++++-
 arch/arm64/kernel/smp.c      | 6 +++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index a0c8a0b652593..0eadbf933e359 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -46,7 +46,12 @@ DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
  * Logical CPU mapping.
  */
 extern u64 __cpu_logical_map[NR_CPUS];
-#define cpu_logical_map(cpu)    __cpu_logical_map[cpu]
+extern u64 cpu_logical_map(int cpu);
+
+static inline void set_cpu_logical_map(int cpu, u64 hwid)
+{
+	__cpu_logical_map[cpu] = hwid;
+}
 
 struct seq_file;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 93b3844cf4421..07b7940951e28 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -85,7 +85,7 @@ u64 __cacheline_aligned boot_args[4];
 void __init smp_setup_processor_id(void)
 {
 	u64 mpidr = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
-	cpu_logical_map(0) = mpidr;
+	set_cpu_logical_map(0, mpidr);
 
 	/*
 	 * clear __my_cpu_offset on boot CPU to avoid hang caused by
@@ -276,6 +276,12 @@ arch_initcall(reserve_memblock_reserved_regions);
 
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
+u64 cpu_logical_map(int cpu)
+{
+	return __cpu_logical_map[cpu];
+}
+EXPORT_SYMBOL_GPL(cpu_logical_map);
+
 void __init setup_arch(char **cmdline_p)
 {
 	init_mm.start_code = (unsigned long) _text;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index e43a8ff19f0f6..8cd6316a0d833 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -567,7 +567,7 @@ acpi_map_gic_cpu_interface(struct acpi_madt_generic_interrupt *processor)
 		return;
 
 	/* map the logical cpu id to cpu MPIDR */
-	cpu_logical_map(cpu_count) = hwid;
+	set_cpu_logical_map(cpu_count, hwid);
 
 	cpu_madt_gicc[cpu_count] = *processor;
 
@@ -681,7 +681,7 @@ static void __init of_parse_and_init_cpus(void)
 			goto next;
 
 		pr_debug("cpu logical map 0x%llx\n", hwid);
-		cpu_logical_map(cpu_count) = hwid;
+		set_cpu_logical_map(cpu_count, hwid);
 
 		early_map_cpu_to_node(cpu_count, of_node_to_nid(dn));
 next:
@@ -722,7 +722,7 @@ void __init smp_init_cpus(void)
 	for (i = 1; i < nr_cpu_ids; i++) {
 		if (cpu_logical_map(i) != INVALID_HWID) {
 			if (smp_cpu_setup(i))
-				cpu_logical_map(i) = INVALID_HWID;
+				set_cpu_logical_map(i, INVALID_HWID);
 		}
 	}
 }
-- 
2.25.1



