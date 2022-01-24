Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1A499E5C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381768AbiAXWcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585397AbiAXWXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:23:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF54C054329;
        Mon, 24 Jan 2022 12:53:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA0B611F9;
        Mon, 24 Jan 2022 20:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C85C340E5;
        Mon, 24 Jan 2022 20:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057616;
        bh=+ZEnUcY7+RPgzxA8XBOKMNeE7kGEnqhjp3FKXau1vAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB0eJpnu0bsmX/mTqqlmEbihnH5WC8iHsY7kat/fuX2vItp1M+4Gj2iJfOjV1F6TV
         uk+2r8OMo5D27UbC9Axukv5Q9xNHPJ78FWGMVgpTIxYo/cWRMn5ZNiVBuLDpGDKCBc
         /n7oW/60R/Y+/0Ei+C+WbgvG2Ouy3fAHQg94w3go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        Anup Patel <anup.patel@wdc.com>,
        Sean Christopherson <seanjc@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0024/1039] RISC-V: Use common riscv_cpuid_to_hartid_mask() for both SMP=y and SMP=n
Date:   Mon, 24 Jan 2022 19:30:13 +0100
Message-Id: <20220124184125.950908186@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 869c70609248102f3a2e95a39b6233ff6ea2c932 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/smp.h |   10 ++--------
 arch/riscv/kernel/setup.c    |   10 ++++++++++
 arch/riscv/kernel/smp.c      |   10 ----------
 3 files changed, 12 insertions(+), 18 deletions(-)

--- a/arch/riscv/include/asm/smp.h
+++ b/arch/riscv/include/asm/smp.h
@@ -43,7 +43,6 @@ void arch_send_call_function_ipi_mask(st
 void arch_send_call_function_single_ipi(int cpu);
 
 int riscv_hartid_to_cpuid(int hartid);
-void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
 
 /* Set custom IPI operations */
 void riscv_set_ipi_ops(const struct riscv_ipi_ops *ops);
@@ -85,13 +84,6 @@ static inline unsigned long cpuid_to_har
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
@@ -102,6 +94,8 @@ static inline void riscv_clear_ipi(void)
 
 #endif /* CONFIG_SMP */
 
+void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out);
+
 #if defined(CONFIG_HOTPLUG_CPU) && (CONFIG_SMP)
 bool cpu_has_hotplug(unsigned int cpu);
 #else
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -59,6 +59,16 @@ atomic_t hart_lottery __section(".sdata"
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


