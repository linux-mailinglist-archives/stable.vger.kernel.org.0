Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7D38AF62
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242990AbhETNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 09:00:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37076 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbhETM6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:58:04 -0400
Received: from mail-qt1-f198.google.com ([209.85.160.198])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljiEC-0005Rd-20
        for stable@vger.kernel.org; Thu, 20 May 2021 12:56:40 +0000
Received: by mail-qt1-f198.google.com with SMTP id x9-20020ac84a090000b0290203194f1f86so4090715qtq.13
        for <stable@vger.kernel.org>; Thu, 20 May 2021 05:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ix+9S7l2HoS++pqHLCNeVtqEf/juK7qm0x6yekPwBs0=;
        b=F5+kkYUUr+jHRqkxNhcs4BwZMNKHOydaexCxbXBOw3Nb5vO63Uey35ubBkVTXWAPY0
         3PzeNKWN+3gKL0xtGQqL4EBxSdGo2x5RTs1EnBOzu7smoO87a+YDu65n5cScx5u4RUaN
         +IbZTL4BJI8aSSpmtFC0mPrRozPGh7rsjIsMiLuTW55qS+tUKb1KJz8Pcj53ELLfRkSs
         5xCd3KdNiiH5YXMcNB2BYuZNAxPZ51ybk9n9UGyFnucrH068zKnn96L+MCi2XoxKtAxJ
         t9rI1YJ+qSiaiFoDbq5PaHxNh6spYI5RWbORhXZsrw6zFwYQwVN/STnvZ5iR+nF8qIp8
         5Z2g==
X-Gm-Message-State: AOAM532Ved3/bkI6t+KH+Px2IBhRDnGLeGU4msyHa1dad9DsUImU1Kip
        6J27rqk9ZomWmJhGnuulqzoV/RN++IhijyqBmoWp8qn/nalkkk+USjPXolvjF4PknTNl+NRGcgG
        T+ZrFFAF7QGGor/3YKVB5H4grOvy8BZprzw==
X-Received: by 2002:a05:620a:4043:: with SMTP id i3mr4682722qko.380.1621515398832;
        Thu, 20 May 2021 05:56:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm/n2BiGZeZfEOGkmkK1CGLUei7QBh7JG88DJ4AXKJlU2HRpvkXRxaUcbhsiuqEhTSR196PQ==
X-Received: by 2002:a05:620a:4043:: with SMTP id i3mr4682690qko.380.1621515398588;
        Thu, 20 May 2021 05:56:38 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id g185sm1931471qkf.62.2021.05.20.05.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:56:38 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v5.4+ 3/3] x86/kvm: Disable all PV features on crash
Date:   Thu, 20 May 2021 08:56:25 -0400
Message-Id: <20210520125625.12566-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
References: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
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
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/x86/include/asm/kvm_para.h |  5 ----
 arch/x86/kernel/kvm.c           | 44 ++++++++++++++++++++++++---------
 arch/x86/kernel/kvmclock.c      | 21 ----------------
 3 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index a617fd360023..7ff8ad490a78 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -91,7 +91,6 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
-extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
@@ -126,10 +125,6 @@ static inline u32 kvm_read_and_reset_pf_reason(void)
 	return 0;
 }
 
-static inline void kvm_disable_steal_time(void)
-{
-	return;
-}
 #endif
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f535ba7714f8..bff25b8166b7 100644
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
@@ -548,13 +549,14 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	kvm_spinlock_init();
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
@@ -614,7 +616,7 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 
 static int kvm_suspend(void)
 {
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 
 	return 0;
 }
@@ -629,6 +631,20 @@ static struct syscore_ops kvm_syscore_ops = {
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
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -672,6 +688,10 @@ static void __init kvm_guest_init(void)
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

