Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C49B395F1F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhEaOIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:08:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40475 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhEaOF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:05:56 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniWe-0001v9-57
        for stable@vger.kernel.org; Mon, 31 May 2021 14:04:16 +0000
Received: by mail-wm1-f72.google.com with SMTP id 18-20020a05600c0252b029019a0ce35d36so1848043wmj.4
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dhVr2BjHguVBPRs+H/VPLgJ0d003EJU1mgFRRtjIzg=;
        b=EQXNNJsi6OPr6qLGXIsgEBpL4bjjvFzJViw57bDj1tCmT95JrUvDM2Ph+oSp95ZTh4
         P7YMVa+XLVpt0yewW9blB3Ev023mICMvaXzwYokGN+g764vXxyp6Rqq0u0xIK8ovmLt0
         pTxooAkDwX8EhMli0Ii2tOs1uodFA14Ec/QYzWqN0hlYzSMkaresCIuGkIhcjvNvAjWb
         MYCfrXGI8v3n9jR1QdbNvuvY7cyvOd7gLFQ1PcQOCfRN0Facdl+wRv1IZ7d9ycZuhawW
         LU5TNzkdGXexxDS1lIk0S0KUxDhL8XpZL0JtIpg+mZuzHEnvwiEa0GP57VcZhV+rbmub
         MGRw==
X-Gm-Message-State: AOAM533eRqd8f7gA9lrsKMGYsCG4oEywbbmbn1c8Pt0c7oOrA/KiJxRL
        BKtWRayuHlatft3Yw0u6BAlntlRMhwd/xOxnwdhMHFne8LsdW7BdQCddGfm/ZZCn9CnmBh+Z3Fp
        Kc5/VH9MfyxHkn2+wj2iGQFSa++iwsb7MaQ==
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr22590936wru.68.1622469855478;
        Mon, 31 May 2021 07:04:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7CQZetPPu3biXfqGapmZn69IhIdt/HnNdoiV23WrmEbfjtFXKWccfwbUKXO0ncIsBJASPFg==
X-Received: by 2002:a5d:4e85:: with SMTP id e5mr22590922wru.68.1622469855338;
        Mon, 31 May 2021 07:04:15 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm13342971wmh.18.2021.05.31.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:04:14 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.4 3/3] x86/kvm: Disable all PV features on crash
Date:   Mon, 31 May 2021 16:03:47 +0200
Message-Id: <20210531140347.42681-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 3d6b84132d2a57b5a74100f6923a8feb679ac2ce upstream.

Crash shutdown handler only disables kvmclock and steal time, other PV
features remain active so we risk corrupting memory or getting some
side-effects in kdump kernel. Move crash handler to kvm.c and unify
with CPU offline.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210414123544.1060604-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/x86/include/asm/kvm_para.h |  6 -----
 arch/x86/kernel/kvm.c           | 44 ++++++++++++++++++++++++---------
 arch/x86/kernel/kvmclock.c      | 21 ----------------
 3 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index a617fd360023..f913f62eb6c3 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -91,7 +91,6 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
-extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
@@ -125,11 +124,6 @@ static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
 }
-
-static inline void kvm_disable_steal_time(void)
-{
-	return;
-}
 #endif
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d6f04d32dec0..6ff2c7cac4c4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,6 +34,7 @@
 #include <asm/apicdef.h>
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
+#include <asm/reboot.h>
 
 static int kvmapf = 1;
 
@@ -352,6 +353,14 @@ static void kvm_pv_disable_apf(void)
 	       smp_processor_id());
 }
 
+static void kvm_disable_steal_time(void)
+{
+	if (!has_steal_clock)
+		return;
+
+	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
+}
+
 static void kvm_pv_guest_cpu_reboot(void *unused)
 {
 	/*
@@ -394,14 +403,6 @@ static u64 kvm_steal_clock(int cpu)
 	return steal;
 }
 
-void kvm_disable_steal_time(void)
-{
-	if (!has_steal_clock)
-		return;
-
-	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
-}
-
 static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 {
 	early_set_memory_decrypted((unsigned long) ptr, size);
@@ -429,13 +430,14 @@ static void __init sev_map_percpu_data(void)
 	}
 }
 
-static void kvm_guest_cpu_offline(void)
+static void kvm_guest_cpu_offline(bool shutdown)
 {
 	kvm_disable_steal_time();
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
-	apf_task_wake_all();
+	if (!shutdown)
+		apf_task_wake_all();
 	kvmclock_disable();
 }
 
@@ -573,7 +575,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 	local_irq_restore(flags);
 	return 0;
 }
@@ -582,7 +584,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 
 static int kvm_suspend(void)
 {
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 
 	return 0;
 }
@@ -597,6 +599,20 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume		= kvm_resume,
 };
 
+/*
+ * After a PV feature is registered, the host will keep writing to the
+ * registered memory location. If the guest happens to shutdown, this memory
+ * won't be valid. In cases like kexec, in which you install a new kernel, this
+ * means a random memory location will be kept being written.
+ */
+#ifdef CONFIG_KEXEC_CORE
+static void kvm_crash_shutdown(struct pt_regs *regs)
+{
+	kvm_guest_cpu_offline(true);
+	native_machine_crash_shutdown(regs);
+}
+#endif
+
 static void __init kvm_apf_trap_init(void)
 {
 	update_intr_gate(X86_TRAP_PF, async_page_fault);
@@ -673,6 +689,10 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+#ifdef CONFIG_KEXEC_CORE
+	machine_ops.crash_shutdown = kvm_crash_shutdown;
+#endif
+
 	register_syscore_ops(&kvm_syscore_ops);
 
 	/*
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index bd3962953f78..4a0802af2e3e 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -20,7 +20,6 @@
 #include <asm/hypervisor.h>
 #include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
-#include <asm/reboot.h>
 #include <asm/kvmclock.h>
 
 static int kvmclock __initdata = 1;
@@ -197,23 +196,6 @@ static void kvm_setup_secondary_clock(void)
 }
 #endif
 
-/*
- * After the clock is registered, the host will keep writing to the
- * registered memory location. If the guest happens to shutdown, this memory
- * won't be valid. In cases like kexec, in which you install a new kernel, this
- * means a random memory location will be kept being written. So before any
- * kind of shutdown from our side, we unregister the clock by writing anything
- * that does not have the 'enable' bit set in the msr
- */
-#ifdef CONFIG_KEXEC_CORE
-static void kvm_crash_shutdown(struct pt_regs *regs)
-{
-	native_write_msr(msr_kvm_system_time, 0, 0);
-	kvm_disable_steal_time();
-	native_machine_crash_shutdown(regs);
-}
-#endif
-
 void kvmclock_disable(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
@@ -344,9 +326,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-#ifdef CONFIG_KEXEC_CORE
-	machine_ops.crash_shutdown  = kvm_crash_shutdown;
-#endif
 	kvm_get_preset_lpj();
 
 	/*
-- 
2.27.0

