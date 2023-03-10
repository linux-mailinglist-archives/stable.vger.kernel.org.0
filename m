Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EF96B47AE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjCJOx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbjCJOwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:52:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D5911F62C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 186F561733
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7DC433AA;
        Fri, 10 Mar 2023 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459723;
        bh=/975mxaUJ+cvf1otV1G8xttdvZLpBmvQPPvKYZ5xD4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyH+eDdIOhhP0tZysq9cKohWbg11Gu4lpvZ7KpJVBjr77KBbKmFuDH5sG0TXN0gzD
         F1FyI7Orb0wETQtJyFGYJvV6ArfZ+9dTXwSvWtUVWmm6IVuvgeMqJ+Z/zDQl1+WQTf
         JINaSZH6toISzuBIrki1OT3SanhMIoTcJQLLMFBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/529] x86/cpu: Init AP exception handling from cpu_init_secondary()
Date:   Fri, 10 Mar 2023 14:34:02 +0100
Message-Id: <20230310133809.561808918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit b1efd0ff4bd16e8bb8607ba566b03f2024a830bb ]

SEV-ES guests require properly setup task register with which the TSS
descriptor in the GDT can be located so that the IST-type #VC exception
handler which they need to function properly, can be executed.

This setup needs to happen before attempting to load microcode in
ucode_cpu_init() on secondary CPUs which can cause such #VC exceptions.

Simplify the machinery by running that exception setup from a new function
cpu_init_secondary() and explicitly call cpu_init_exception_handling() for
the boot CPU before cpu_init(). The latter prepares for fixing and
simplifying the exception/IST setup on the boot CPU.

There should be no functional changes resulting from this patch.

[ tglx: Reworked it so cpu_init_exception_handling() stays seperate ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lai Jiangshan <laijs@linux.alibaba.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/87k0o6gtvu.ffs@nanos.tec.linutronix.de
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 28 +++++++++++++++-------------
 arch/x86/kernel/smpboot.c        |  3 +--
 arch/x86/kernel/traps.c          |  4 +---
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d428d611a43a9..388541ec77aad 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -682,6 +682,7 @@ extern void load_direct_gdt(int);
 extern void load_fixmap_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
+extern void cpu_init_secondary(void);
 extern void cpu_init_exception_handling(void);
 extern void cr4_init(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 56573241d0293..4402589a1ee19 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2048,13 +2048,12 @@ void cpu_init_exception_handling(void)
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
+ * initialized (naturally) in the bootstrap process, such as the GDT.  We
+ * reload it nevertheless, this function acts as a 'CPU state barrier',
+ * nothing should get across.
  */
 void cpu_init(void)
 {
-	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
 	struct task_struct *cur = current;
 	int cpu = raw_smp_processor_id();
 
@@ -2067,8 +2066,6 @@ void cpu_init(void)
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
-	setup_getcpu(cpu);
-
 	pr_debug("Initializing CPU#%d\n", cpu);
 
 	if (IS_ENABLED(CONFIG_X86_64) || cpu_feature_enabled(X86_FEATURE_VME) ||
@@ -2080,7 +2077,6 @@ void cpu_init(void)
 	 * and set up the GDT descriptor:
 	 */
 	switch_to_new_gdt(cpu);
-	load_current_idt();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
 		loadsegment(fs, 0);
@@ -2100,12 +2096,6 @@ void cpu_init(void)
 	initialize_tlbstate_and_flush();
 	enter_lazy_tlb(&init_mm, cur);
 
-	/* Initialize the TSS. */
-	tss_setup_ist(tss);
-	tss_setup_io_bitmap(tss);
-	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
-
-	load_TR_desc();
 	/*
 	 * sp0 points to the entry trampoline stack regardless of what task
 	 * is running.
@@ -2127,6 +2117,18 @@ void cpu_init(void)
 	load_fixmap_gdt(cpu);
 }
 
+#ifdef CONFIG_SMP
+void cpu_init_secondary(void)
+{
+	/*
+	 * Relies on the BP having set-up the IDT tables, which are loaded
+	 * on this CPU in cpu_init_exception_handling().
+	 */
+	cpu_init_exception_handling();
+	cpu_init();
+}
+#endif
+
 /*
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e8e5515fb7e9c..bda89ecc7799f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -227,8 +227,7 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
-	cpu_init_exception_handling();
-	cpu_init();
+	cpu_init_secondary();
 	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 	smp_callin();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2a39a2df6f43e..3780c728345c3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1185,9 +1185,7 @@ void __init trap_init(void)
 
 	idt_setup_traps();
 
-	/*
-	 * Should be a barrier for any external CPU state:
-	 */
+	cpu_init_exception_handling();
 	cpu_init();
 
 	idt_setup_ist_traps();
-- 
2.39.2



