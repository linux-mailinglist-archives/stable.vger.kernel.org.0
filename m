Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEE6AB02C
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCENxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCENxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CD5170B;
        Sun,  5 Mar 2023 05:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C33B80A7C;
        Sun,  5 Mar 2023 13:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A0BC433D2;
        Sun,  5 Mar 2023 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024372;
        bh=eqxstDj2RKk78tbsker8g6f47TRazawnJzWwGFh/v20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3Sh48VhTPgTkcrnW19HsWCRK5VEQBmDcYQ5CuQvfAFFLdar4gi35aGlJr71z4rFK
         w8o9/mMeWtB+Mr2LsfqqjNlzyPzX7pfvboYP2O6YHyma6daSnC0ATijnAd6Ejk2NI/
         Wzg1G9HLJ2PgYABS8QobIb2ovEI9JBhIo200hzWlnDD+YdjkcWUE9BaQPGeL0DwMTt
         Pb7/kqgmsvV54chCSBr0hPcbNeJyedCS5uHhV/2gjqDasQpk+ewKTEhiMrbgbGYit4
         i+0R2KsH7Ihb0pjCbZzJ3ksz55l1aQhny0vf+esWOuLG3Q0h2UX5m/0SFXEyEvj5yC
         x647CH+Tueh7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        ganeshgr@linux.ibm.com, nathanl@linux.ibm.com,
        yuehaibing@huawei.com, dja@axtens.net, laurent.dufour@fr.ibm.com,
        haren@linux.ibm.com, zhouzhouyi@gmail.com, ruscur@russell.cc,
        aneesh.kumar@linux.ibm.com, Jason@zx2c4.com,
        dmitry.osipenko@collabora.com, yury.norov@gmail.com,
        gpiccoli@igalia.com, pmladek@suse.com, mbenes@suse.cz,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.2 11/16] powerpc/64: Move paca allocation to early_setup()
Date:   Sun,  5 Mar 2023 08:52:02 -0500
Message-Id: <20230305135207.1793266-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit dc222fa7737212fe0da513e5b8937c156d02225d ]

The early paca and boot cpuid dance is complicated and currently does
not quite work as expected for boot cpuid != 0 cases.

early_init_devtree() currently allocates the paca_ptrs and boot cpuid
paca, but until that returns and early_setup() calls setup_paca(), this
thread is currently still executing with smp_processor_id() == 0.

One problem this causes is the paca_ptrs[smp_processor_id()] pointer is
poisoned, so valid_emergency_stack() (any backtrace) and any similar
users will crash.

Another is that the hardware id which is set here will not be returned
by get_hard_smp_processor_id(smp_processor_id()), but it would work
correctly for boot_cpuid == 0, which could lead to difficult to
reproduce or find bugs. The hard id does not seem to be used by the rest
of early_init_devtree(), it just looks like all this code might have
been put here to allocate somewhere to store boot CPU hardware id while
scanning the devtree.

Rearrange things so the hwid is put in a global variable like
boot_cpuid, and do all the paca allocation and boot paca setup in the
64-bit early_setup() after we have everything ready to go.

The paca_ptrs[0] re-poisoning code in early_setup does not seem to have
ever worked, because paca_ptrs[0] was never not-poisoned when boot_cpuid
is not 0.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Fix build error on 32-bit]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221216115930.2667772-4-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/paca.h    |  1 -
 arch/powerpc/include/asm/smp.h     |  1 +
 arch/powerpc/kernel/prom.c         | 12 +++---------
 arch/powerpc/kernel/setup-common.c |  4 ++++
 arch/powerpc/kernel/setup_64.c     | 11 +++++------
 5 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 09f1790d0ae16..0ab3511a47d77 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -295,7 +295,6 @@ extern void free_unused_pacas(void);
 
 #else /* CONFIG_PPC64 */
 
-static inline void allocate_paca_ptrs(void) { }
 static inline void allocate_paca(int cpu) { }
 static inline void free_unused_pacas(void) { }
 
diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index f63505d74932b..6c6cb53d70458 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -26,6 +26,7 @@
 #include <asm/percpu.h>
 
 extern int boot_cpuid;
+extern int boot_cpu_hwid; /* PPC64 only */
 extern int spinning_secondaries;
 extern u32 *cpu_to_phys_id;
 extern bool coregroup_enabled;
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4f1c920aa13ed..f318e8e1f3fe4 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -370,8 +370,8 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 	    be32_to_cpu(intserv[found_thread]));
 	boot_cpuid = found;
 
-	// Pass the boot CPU's hard CPU id back to our caller
-	*((u32 *)data) = be32_to_cpu(intserv[found_thread]);
+	if (IS_ENABLED(CONFIG_PPC64))
+		boot_cpu_hwid = be32_to_cpu(intserv[found_thread]);
 
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
@@ -755,7 +755,6 @@ static inline void save_fscr_to_task(void) {}
 
 void __init early_init_devtree(void *params)
 {
-	u32 boot_cpu_hwid;
 	phys_addr_t limit;
 
 	DBG(" -> early_init_devtree(%px)\n", params);
@@ -851,7 +850,7 @@ void __init early_init_devtree(void *params)
 	/* Retrieve CPU related informations from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
-	of_scan_flat_dt(early_init_dt_scan_cpus, &boot_cpu_hwid);
+	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
 	if (boot_cpuid < 0) {
 		printk("Failed to identify boot CPU !\n");
 		BUG();
@@ -868,11 +867,6 @@ void __init early_init_devtree(void *params)
 
 	mmu_early_init_devtree();
 
-	// NB. paca is not installed until later in early_setup()
-	allocate_paca_ptrs();
-	allocate_paca(boot_cpuid);
-	set_hard_smp_processor_id(boot_cpuid, boot_cpu_hwid);
-
 #ifdef CONFIG_PPC_POWERNV
 	/* Scan and build the list of machine check recoverable ranges */
 	of_scan_flat_dt(early_init_dt_scan_recoverable_ranges, NULL);
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 9b10e57040c6c..e77734e5a127f 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -87,6 +87,10 @@ EXPORT_SYMBOL(machine_id);
 int boot_cpuid = -1;
 EXPORT_SYMBOL_GPL(boot_cpuid);
 
+#ifdef CONFIG_PPC64
+int boot_cpu_hwid = -1;
+#endif
+
 /*
  * These are used in binfmt_elf.c to put aux entries on the stack
  * for each elf executable being started.
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index a43865e0fb4bf..b2e0d3ce4261c 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -385,15 +385,14 @@ void __init early_setup(unsigned long dt_ptr)
 	/*
 	 * Do early initialization using the flattened device
 	 * tree, such as retrieving the physical memory map or
-	 * calculating/retrieving the hash table size.
+	 * calculating/retrieving the hash table size, discover
+	 * boot_cpuid and boot_cpu_hwid.
 	 */
 	early_init_devtree(__va(dt_ptr));
 
-	/* Now we know the logical id of our boot cpu, setup the paca. */
-	if (boot_cpuid != 0) {
-		/* Poison paca_ptrs[0] again if it's not the boot cpu */
-		memset(&paca_ptrs[0], 0x88, sizeof(paca_ptrs[0]));
-	}
+	allocate_paca_ptrs();
+	allocate_paca(boot_cpuid);
+	set_hard_smp_processor_id(boot_cpuid, boot_cpu_hwid);
 	fixup_boot_paca(paca_ptrs[boot_cpuid]);
 	setup_paca(paca_ptrs[boot_cpuid]); /* install the paca into registers */
 	// smp_processor_id() now reports boot_cpuid
-- 
2.39.2

