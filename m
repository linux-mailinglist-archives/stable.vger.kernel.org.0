Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB60C6433DE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbiLETkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiLETkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A80B2B188
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4545BB811EC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C27C433D6;
        Mon,  5 Dec 2022 19:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269030;
        bh=hXDY6D2mtza6ZDEo/C64AC34RWbcnJjNObdwrHry4AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hekDfAXPp5mR2voS1Zg8n7yXBi8EVJRSBvoCnmdNxKVRWDjPvpLje+3suyVYXr36r
         zkLQ9SZBdWHDUWhPZvo12zLmlTTYcBZunqoNSrKh8PcnZM0R55+0U0DjpZMdDksPiw
         pOLIeXx/KoJ++xeFf7r+3ApSj4k+nNwFliqMoOLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/120] riscv: kexec: Fixup crash_smp_send_stop without multi cores
Date:   Mon,  5 Dec 2022 20:10:39 +0100
Message-Id: <20221205190809.529470496@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 9b932aadfc47de5d70b53ea04b0d1b5f6c82945b ]

Current crash_smp_send_stop is the same as the generic one in
kernel/panic and misses crash_save_cpu in percpu. This patch is inspired
by 78fd584cdec0 ("arm64: kdump: implement machine_crash_shutdown()")
and adds the same mechanism for riscv.

Before this patch, test result:
crash> help -r
CPU 0: [OFFLINE]

CPU 1:
epc : ffffffff80009ff0 ra : ffffffff800b789a sp : ff2000001098bb40
 gp : ffffffff815fca60 tp : ff60000004680000 t0 : 6666666666663c5b
 t1 : 0000000000000000 t2 : 666666666666663c s0 : ff2000001098bc90
 s1 : ffffffff81600798 a0 : ff2000001098bb48 a1 : 0000000000000000
 a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
 a5 : ff60000004690800 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : ff2000001098bb48 s3 : ffffffff81093ec8 s4 : ffffffff816004ac
 s5 : 0000000000000000 s6 : 0000000000000007 s7 : ffffffff80e7f720
 s8 : 00fffffffffff3f0 s9 : 0000000000000007 s10: 00aaaaaaaab98700
 s11: 0000000000000001 t3 : ffffffff819a8097 t4 : ffffffff819a8097
 t5 : ffffffff819a8098 t6 : ff2000001098b9a8

CPU 2: [OFFLINE]

CPU 3: [OFFLINE]

After this patch, test result:
crash> help -r
CPU 0:
epc : ffffffff80003f34 ra : ffffffff808caa7c sp : ffffffff81403eb0
 gp : ffffffff815fcb48 tp : ffffffff81413400 t0 : 0000000000000000
 t1 : 0000000000000000 t2 : 0000000000000000 s0 : ffffffff81403ec0
 s1 : 0000000000000000 a0 : 0000000000000000 a1 : 0000000000000000
 a2 : 0000000000000000 a3 : 0000000000000000 a4 : 0000000000000000
 a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : ffffffff816001c8 s3 : ffffffff81600370 s4 : ffffffff80c32e18
 s5 : ffffffff819d3018 s6 : ffffffff810e2110 s7 : 0000000000000000
 s8 : 0000000000000000 s9 : 0000000080039eac s10: 0000000000000000
 s11: 0000000000000000 t3 : 0000000000000000 t4 : 0000000000000000
 t5 : 0000000000000000 t6 : 0000000000000000

CPU 1:
epc : ffffffff80003f34 ra : ffffffff808caa7c sp : ff2000000068bf30
 gp : ffffffff815fcb48 tp : ff6000000240d400 t0 : 0000000000000000
 t1 : 0000000000000000 t2 : 0000000000000000 s0 : ff2000000068bf40
 s1 : 0000000000000001 a0 : 0000000000000000 a1 : 0000000000000000
 a2 : 0000000000000000 a3 : 0000000000000000 a4 : 0000000000000000
 a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : ffffffff816001c8 s3 : ffffffff81600370 s4 : ffffffff80c32e18
 s5 : ffffffff819d3018 s6 : ffffffff810e2110 s7 : 0000000000000000
 s8 : 0000000000000000 s9 : 0000000080039ea8 s10: 0000000000000000
 s11: 0000000000000000 t3 : 0000000000000000 t4 : 0000000000000000
 t5 : 0000000000000000 t6 : 0000000000000000

CPU 2:
epc : ffffffff80003f34 ra : ffffffff808caa7c sp : ff20000000693f30
 gp : ffffffff815fcb48 tp : ff6000000240e900 t0 : 0000000000000000
 t1 : 0000000000000000 t2 : 0000000000000000 s0 : ff20000000693f40
 s1 : 0000000000000002 a0 : 0000000000000000 a1 : 0000000000000000
 a2 : 0000000000000000 a3 : 0000000000000000 a4 : 0000000000000000
 a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : ffffffff816001c8 s3 : ffffffff81600370 s4 : ffffffff80c32e18
 s5 : ffffffff819d3018 s6 : ffffffff810e2110 s7 : 0000000000000000
 s8 : 0000000000000000 s9 : 0000000080039eb0 s10: 0000000000000000
 s11: 0000000000000000 t3 : 0000000000000000 t4 : 0000000000000000
 t5 : 0000000000000000 t6 : 0000000000000000

CPU 3:
epc : ffffffff8000a1e4 ra : ffffffff800b7bba sp : ff200000109bbb40
 gp : ffffffff815fcb48 tp : ff6000000373aa00 t0 : 6666666666663c5b
 t1 : 0000000000000000 t2 : 666666666666663c s0 : ff200000109bbc90
 s1 : ffffffff816007a0 a0 : ff200000109bbb48 a1 : 0000000000000000
 a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
 a5 : ff60000002c61c00 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : ff200000109bbb48 s3 : ffffffff810941a8 s4 : ffffffff816004b4
 s5 : 0000000000000000 s6 : 0000000000000007 s7 : ffffffff80e7f7a0
 s8 : 00fffffffffff3f0 s9 : 0000000000000007 s10: 00aaaaaaaab98700
 s11: 0000000000000001 t3 : ffffffff819a8097 t4 : ffffffff819a8097
 t5 : ffffffff819a8098 t6 : ff200000109bb9a8

Fixes: ad943893d5f1 ("RISC-V: Fixup schedule out issue in machine_crash_shutdown()")
Reviewed-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Link: https://lore.kernel.org/r/20221020141603.2856206-3-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/smp.h      |  3 +
 arch/riscv/kernel/machine_kexec.c | 21 ++-----
 arch/riscv/kernel/smp.c           | 93 ++++++++++++++++++++++++++++++-
 3 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/riscv/include/asm/smp.h b/arch/riscv/include/asm/smp.h
index 62d0e6e61da8..b29f2a79b636 100644
--- a/arch/riscv/include/asm/smp.h
+++ b/arch/riscv/include/asm/smp.h
@@ -50,6 +50,9 @@ void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops);
 /* Clear IPI for current CPU */
 void riscv_clear_ipi(void);
 
+/* Check other CPUs stop or not */
+bool smp_crash_stop_failed(void);
+
 /* Secondary hart entry */
 asmlinkage void smp_callin(void);
 
diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index db41c676e5a2..2d139b724bc8 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -140,22 +140,6 @@ void machine_shutdown(void)
 #endif
 }
 
-/* Override the weak function in kernel/panic.c */
-void crash_smp_send_stop(void)
-{
-	static int cpus_stopped;
-
-	/*
-	 * This function can be called twice in panic path, but obviously
-	 * we execute this only once.
-	 */
-	if (cpus_stopped)
-		return;
-
-	smp_send_stop();
-	cpus_stopped = 1;
-}
-
 static void machine_kexec_mask_interrupts(void)
 {
 	unsigned int i;
@@ -230,6 +214,11 @@ machine_kexec(struct kimage *image)
 	void *control_code_buffer = page_address(image->control_code_page);
 	riscv_kexec_method kexec_method = NULL;
 
+#ifdef CONFIG_SMP
+	WARN(smp_crash_stop_failed(),
+		"Some CPUs may be stale, kdump will be unreliable.\n");
+#endif
+
 	if (image->type != KEXEC_TYPE_CRASH)
 		kexec_method = control_code_buffer;
 	else
diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index d0147294691d..3155387ca82d 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/kexec.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <linux/sched.h>
@@ -22,11 +23,13 @@
 #include <asm/sbi.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
+#include <asm/cpu_ops.h>
 
 enum ipi_message_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
 	IPI_CPU_STOP,
+	IPI_CPU_CRASH_STOP,
 	IPI_IRQ_WORK,
 	IPI_TIMER,
 	IPI_MAX
@@ -77,6 +80,32 @@ static void ipi_stop(void)
 		wait_for_interrupt();
 }
 
+#ifdef CONFIG_KEXEC_CORE
+static atomic_t waiting_for_crash_ipi = ATOMIC_INIT(0);
+
+static inline void ipi_cpu_crash_stop(unsigned int cpu, struct pt_regs *regs)
+{
+	crash_save_cpu(regs, cpu);
+
+	atomic_dec(&waiting_for_crash_ipi);
+
+	local_irq_disable();
+
+#ifdef CONFIG_HOTPLUG_CPU
+	if (cpu_has_hotplug(cpu))
+		cpu_ops[cpu]->cpu_stop();
+#endif
+
+	for(;;)
+		wait_for_interrupt();
+}
+#else
+static inline void ipi_cpu_crash_stop(unsigned int cpu, struct pt_regs *regs)
+{
+	unreachable();
+}
+#endif
+
 static const struct riscv_ipi_ops *ipi_ops __ro_after_init;
 
 void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops)
@@ -130,7 +159,6 @@ void arch_irq_work_raise(void)
 
 void handle_IPI(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
 	unsigned long *stats = ipi_data[smp_processor_id()].stats;
 
@@ -163,6 +191,10 @@ void handle_IPI(struct pt_regs *regs)
 			ipi_stop();
 		}
 
+		if (ops & (1 << IPI_CPU_CRASH_STOP)) {
+			ipi_cpu_crash_stop(cpu, get_irq_regs());
+		}
+
 		if (ops & (1 << IPI_IRQ_WORK)) {
 			stats[IPI_IRQ_WORK]++;
 			irq_work_run();
@@ -189,6 +221,7 @@ static const char * const ipi_names[] = {
 	[IPI_RESCHEDULE]	= "Rescheduling interrupts",
 	[IPI_CALL_FUNC]		= "Function call interrupts",
 	[IPI_CPU_STOP]		= "CPU stop interrupts",
+	[IPI_CPU_CRASH_STOP]	= "CPU stop (for crash dump) interrupts",
 	[IPI_IRQ_WORK]		= "IRQ work interrupts",
 	[IPI_TIMER]		= "Timer broadcast interrupts",
 };
@@ -248,6 +281,64 @@ void smp_send_stop(void)
 			   cpumask_pr_args(cpu_online_mask));
 }
 
+#ifdef CONFIG_KEXEC_CORE
+/*
+ * The number of CPUs online, not counting this CPU (which may not be
+ * fully online and so not counted in num_online_cpus()).
+ */
+static inline unsigned int num_other_online_cpus(void)
+{
+	unsigned int this_cpu_online = cpu_online(smp_processor_id());
+
+	return num_online_cpus() - this_cpu_online;
+}
+
+void crash_smp_send_stop(void)
+{
+	static int cpus_stopped;
+	cpumask_t mask;
+	unsigned long timeout;
+
+	/*
+	 * This function can be called twice in panic path, but obviously
+	 * we execute this only once.
+	 */
+	if (cpus_stopped)
+		return;
+
+	cpus_stopped = 1;
+
+	/*
+	 * If this cpu is the only one alive at this point in time, online or
+	 * not, there are no stop messages to be sent around, so just back out.
+	 */
+	if (num_other_online_cpus() == 0)
+		return;
+
+	cpumask_copy(&mask, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
+
+	atomic_set(&waiting_for_crash_ipi, num_other_online_cpus());
+
+	pr_crit("SMP: stopping secondary CPUs\n");
+	send_ipi_mask(&mask, IPI_CPU_CRASH_STOP);
+
+	/* Wait up to one second for other CPUs to stop */
+	timeout = USEC_PER_SEC;
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && timeout--)
+		udelay(1);
+
+	if (atomic_read(&waiting_for_crash_ipi) > 0)
+		pr_warn("SMP: failed to stop secondary CPUs %*pbl\n",
+			cpumask_pr_args(&mask));
+}
+
+bool smp_crash_stop_failed(void)
+{
+	return (atomic_read(&waiting_for_crash_ipi) > 0);
+}
+#endif
+
 void smp_send_reschedule(int cpu)
 {
 	send_ipi_single(cpu, IPI_RESCHEDULE);
-- 
2.35.1



