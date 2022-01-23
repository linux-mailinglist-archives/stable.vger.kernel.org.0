Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE64971E6
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbiAWOMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiAWOMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:12:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13731C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:12:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A72CF60C58
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93B5C340E2;
        Sun, 23 Jan 2022 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947150;
        bh=cczwKxz2hB5YrxAhTUhpstzBIA7U96yqXmEaVfvXAWs=;
        h=Subject:To:Cc:From:Date:From;
        b=LzR+jXEAS8dZ6R84OH2dAohSovlm/pkIU7E3AL0jViHqYP6X8/jPBgEjr4R/FO1Gp
         3j7aEHVJEgN/LLH66sQjmF7CfqHlv1NHvAlYpgG4DUncsz84Fb33weK22a461BS9VP
         78x1Ag3B1cRhWH2pj8lGlfzj0/wOqdz+6WOAQEZA=
Subject: FAILED: patch "[PATCH] RISC-V: Use common riscv_cpuid_to_hartid_mask() for both" failed to apply to 5.10-stable tree
To:     seanjc@google.com, anup.patel@wdc.com, kilobyte@angband.pl,
        palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:12:27 +0100
Message-ID: <1642947147172100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 869c70609248102f3a2e95a39b6233ff6ea2c932 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 29 Nov 2021 21:43:42 +0000
Subject: [PATCH] RISC-V: Use common riscv_cpuid_to_hartid_mask() for both
 SMP=y and SMP=n

Use what is currently the SMP=y version of riscv_cpuid_to_hartid_mask()
for both SMP=y and SMP=n to fix a build failure with KVM=m and SMP=n due
to boot_cpu_hartid not being exported.  This also fixes a second bug
where the SMP=n version assumes the sole CPU in the system is in the
incoming mask, which may not hold true in kvm_riscv_vcpu_sbi_ecall() if
the KVM guest VM has multiple vCPUs (on a SMP=n system).

Fixes: 1ef46c231df4 ("RISC-V: Implement new SBI v0.2 extensions")
Reported-by: Adam Borowski <kilobyte@angband.pl>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/include/asm/smp.h b/arch/riscv/include/asm/smp.h
index e2b0d6c40a6c..6ad749f42807 100644
--- a/arch/riscv/include/asm/smp.h
+++ b/arch/riscv/include/asm/smp.h
@@ -43,7 +43,6 @@ void arch_send_call_function_ipi_mask(struct cpumask *mask);
 void arch_send_call_function_single_ipi(int cpu);
 
 int riscv_hartid_to_cpuid(int hartid);
-void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
 
 /* Set custom IPI operations */
 void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops);
@@ -83,13 +82,6 @@ static inline unsigned long cpuid_to_hartid_map(int cpu)
 	return boot_cpu_hartid;
 }
 
-static inline void riscv_cpuid_to_hartid_mask(const struct cpumask *in,
-					      struct cpumask *out)
-{
-	cpumask_clear(out);
-	cpumask_set_cpu(boot_cpu_hartid, out);
-}
-
 static inline void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops)
 {
 }
@@ -100,6 +92,8 @@ static inline void riscv_clear_ipi(void)
 
 #endif /* CONFIG_SMP */
 
+void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
+
 #if defined(CONFIG_HOTPLUG_CPU) && (CONFIG_SMP)
 bool cpu_has_hotplug(unsigned int cpu);
 #else
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index b42bfdc67482..63241abe84eb 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -59,6 +59,16 @@ atomic_t hart_lottery __section(".sdata")
 unsigned long boot_cpu_hartid;
 static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
+void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
+{
+	int cpu;
+
+	cpumask_clear(out);
+	for_each_cpu(cpu, in)
+		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
+}
+EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
+
 /*
  * Place kernel memory regions on the resource tree so that
  * kexec-tools can retrieve them from /proc/iomem. While there
diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index 2f6da845c9ae..b5d30ea92292 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -59,16 +59,6 @@ int riscv_hartid_to_cpuid(int hartid)
 	return -ENOENT;
 }
 
-void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
-{
-	int cpu;
-
-	cpumask_clear(out);
-	for_each_cpu(cpu, in)
-		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
-}
-EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
-
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
 	return phys_id == cpuid_to_hartid_map(cpu);

