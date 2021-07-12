Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D15F3C48E6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhGLGlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236360AbhGLGjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F41D610A7;
        Mon, 12 Jul 2021 06:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071677;
        bh=gGOw+8XsQDqVJuy50QinE8HSs9Y4tJCXa75loxV40EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tlCUsusvkc1twgYiZj23n0R7OKQ5Jq+qMCb3jYnh+WsRt9Dt+2PvsW8AwoqL06hsm
         USGaqCi4mYT5K7PrxeT4WosZ5aHdBljKxIvjfCPAHsDmuY+300OPP0WMcoQCKe6sUE
         fZCWxXxFYTR7MGfBJ2DmT4eZLlV+8sgcMbJwhneE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/593] KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors
Date:   Mon, 12 Jul 2021 08:05:15 +0200
Message-Id: <20210712060900.093450241@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

[ Upstream commit 77bbbc0cf84834ed130838f7ac1988567f4d0288 ]

The POWER9 vCPU TLB management code assumes all threads in a core share
a TLB, and that TLBIEL execued by one thread will invalidate TLBs for
all threads. This is not the case for SMT8 capable POWER9 and POWER10
(big core) processors, where the TLB is split between groups of threads.
This results in TLB multi-hits, random data corruption, etc.

Fix this by introducing cpu_first_tlb_thread_sibling etc., to determine
which siblings share TLBs, and use that in the guest TLB flushing code.

[npiggin@gmail.com: add changelog and comment]

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210602040441.3984352-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cputhreads.h | 30 +++++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c          | 13 ++++++------
 arch/powerpc/kvm/book3s_hv_builtin.c  |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   |  2 +-
 4 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/cputhreads.h b/arch/powerpc/include/asm/cputhreads.h
index 98c8bd155bf9..b167186aaee4 100644
--- a/arch/powerpc/include/asm/cputhreads.h
+++ b/arch/powerpc/include/asm/cputhreads.h
@@ -98,6 +98,36 @@ static inline int cpu_last_thread_sibling(int cpu)
 	return cpu | (threads_per_core - 1);
 }
 
+/*
+ * tlb_thread_siblings are siblings which share a TLB. This is not
+ * architected, is not something a hypervisor could emulate and a future
+ * CPU may change behaviour even in compat mode, so this should only be
+ * used on PowerNV, and only with care.
+ */
+static inline int cpu_first_tlb_thread_sibling(int cpu)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return cpu & ~0x6;	/* Big Core */
+	else
+		return cpu_first_thread_sibling(cpu);
+}
+
+static inline int cpu_last_tlb_thread_sibling(int cpu)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return cpu | 0x6;	/* Big Core */
+	else
+		return cpu_last_thread_sibling(cpu);
+}
+
+static inline int cpu_tlb_thread_sibling_step(void)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return 2;		/* Big Core */
+	else
+		return 1;
+}
+
 static inline u32 get_tensr(void)
 {
 #ifdef	CONFIG_BOOKE
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 965b702208d8..2325b7a6e95f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2578,7 +2578,7 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 	cpumask_t *cpu_in_guest;
 	int i;
 
-	cpu = cpu_first_thread_sibling(cpu);
+	cpu = cpu_first_tlb_thread_sibling(cpu);
 	if (nested) {
 		cpumask_set_cpu(cpu, &nested->need_tlb_flush);
 		cpu_in_guest = &nested->cpu_in_guest;
@@ -2592,9 +2592,10 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 	 * the other side is the first smp_mb() in kvmppc_run_core().
 	 */
 	smp_mb();
-	for (i = 0; i < threads_per_core; ++i)
-		if (cpumask_test_cpu(cpu + i, cpu_in_guest))
-			smp_call_function_single(cpu + i, do_nothing, NULL, 1);
+	for (i = cpu; i <= cpu_last_tlb_thread_sibling(cpu);
+					i += cpu_tlb_thread_sibling_step())
+		if (cpumask_test_cpu(i, cpu_in_guest))
+			smp_call_function_single(i, do_nothing, NULL, 1);
 }
 
 static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
@@ -2625,8 +2626,8 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	 */
 	if (prev_cpu != pcpu) {
 		if (prev_cpu >= 0 &&
-		    cpu_first_thread_sibling(prev_cpu) !=
-		    cpu_first_thread_sibling(pcpu))
+		    cpu_first_tlb_thread_sibling(prev_cpu) !=
+		    cpu_first_tlb_thread_sibling(pcpu))
 			radix_flush_cpu(kvm, prev_cpu, vcpu);
 		if (nested)
 			nested->prev_cpu[vcpu->arch.nested_vcpu_id] = pcpu;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 8f58dd20b362..4621905bdd9e 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -893,7 +893,7 @@ void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
 	 * Thus we make all 4 threads use the same bit.
 	 */
 	if (cpu_has_feature(CPU_FTR_ARCH_300))
-		pcpu = cpu_first_thread_sibling(pcpu);
+		pcpu = cpu_first_tlb_thread_sibling(pcpu);
 
 	if (nested)
 		need_tlb_flush = &nested->need_tlb_flush;
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 88da2764c1bb..3ddc83d2e849 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -67,7 +67,7 @@ static int global_invalidates(struct kvm *kvm)
 		 * so use the bit for the first thread to represent the core.
 		 */
 		if (cpu_has_feature(CPU_FTR_ARCH_300))
-			cpu = cpu_first_thread_sibling(cpu);
+			cpu = cpu_first_tlb_thread_sibling(cpu);
 		cpumask_clear_cpu(cpu, &kvm->arch.need_tlb_flush);
 	}
 
-- 
2.30.2



