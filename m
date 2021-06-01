Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F6396DD5
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAHSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:18:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60766 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhFAHSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:18:47 -0400
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnye7-0002n6-2c
        for stable@vger.kernel.org; Tue, 01 Jun 2021 07:17:03 +0000
Received: by mail-wm1-f70.google.com with SMTP id 128-20020a1c04860000b0290196f3c0a927so763366wme.3
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 00:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=he9Z7jKEL7xWBcQIT6GeTQdygtNqBsNfzV0spRxTzdQ=;
        b=iHN5h/1IBWeCGvG6YlDO2atgvUPauprVHR7toiPfbEWPCBvM5Yw/Jx0mByb/r97Yw8
         fH1qDDY/JyNTdxzr7ZyzojMz63fX4OTWQ1s8BQaAXeZRB4NCdBZdrw8aW1jNJ4UPjwGc
         xCtSaX8ZZ/TEtV6wuZY5JXXYekFhRfDAi5nMUBJEwotc5d/WxJYU16xNCgwQ8eXnE8jy
         GgU99fKDLvzQhy6Ru1LF4MbkQoZXCcL8a8WCaiY5M5Hfp0f88K+5nTww+r+OBZWz5Zaj
         UvX3CEgWolDyjeT3bnd02frApb4zmmmfpANZUyThf440CGPhJPWUleCdKBPQl+nTH47m
         cf+Q==
X-Gm-Message-State: AOAM531VJeFqExuTFvPn8E5ElI/ZxH4jUCAUgh6FARMOXLeKxnT1X2w+
        pVHSRDUR16LXAKS2xfvTjYJzD1bXJDFepivSVIu6Hb9gNZ2UX3tPGdyn3ufrUk9J5sfLphQ0ZDv
        E3YpNnE6KDnwxHQt80Su7kcg+NuW1281sqA==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr24923185wmh.151.1622531821781;
        Tue, 01 Jun 2021 00:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYWL9fpi3tw8PcECQrgIM4VsfSESA2dQim2qQfZMPbtDHFNYnY68Np2p9PSlsS5i02YjmkfQ==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr24923168wmh.151.1622531821652;
        Tue, 01 Jun 2021 00:17:01 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm2083869wmh.18.2021.06.01.00.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 00:17:00 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.12 3/3] x86/kvm: Disable all PV features on crash
Date:   Tue,  1 Jun 2021 09:16:44 +0200
Message-Id: <20210601071644.6055-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
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
index 9c56e0defd45..69299878b200 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -92,7 +92,6 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait_schedule(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_apf_flags(void);
-void kvm_disable_steal_time(void);
 bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
 
 DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
@@ -137,11 +136,6 @@ static inline u32 kvm_read_and_reset_apf_flags(void)
 	return 0;
 }
 
-static inline void kvm_disable_steal_time(void)
-{
-	return;
-}
-
 static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
 	return false;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 2ebb93c34bc5..919411a0117d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -38,6 +38,7 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
+#include <asm/reboot.h>
 #include <asm/svm.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
@@ -375,6 +376,14 @@ static void kvm_pv_disable_apf(void)
 	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
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
@@ -417,14 +426,6 @@ static u64 kvm_steal_clock(int cpu)
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
@@ -461,13 +462,14 @@ static bool pv_tlb_flush_supported(void)
 
 static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
 
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
 
@@ -613,7 +615,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 	local_irq_restore(flags);
 	return 0;
 }
@@ -622,7 +624,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 
 static int kvm_suspend(void)
 {
-	kvm_guest_cpu_offline();
+	kvm_guest_cpu_offline(false);
 
 	return 0;
 }
@@ -637,6 +639,20 @@ static struct syscore_ops kvm_syscore_ops = {
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
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
 {
@@ -705,6 +721,10 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+#ifdef CONFIG_KEXEC_CORE
+	machine_ops.crash_shutdown = kvm_crash_shutdown;
+#endif
+
 	register_syscore_ops(&kvm_syscore_ops);
 
 	/*
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index cf869de98eec..b825c87c12ef 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -20,7 +20,6 @@
 #include <asm/hypervisor.h>
 #include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
-#include <asm/reboot.h>
 #include <asm/kvmclock.h>
 
 static int kvmclock __initdata = 1;
@@ -203,23 +202,6 @@ static void kvm_setup_secondary_clock(void)
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
@@ -349,9 +331,6 @@ void __init kvmclock_init(void)
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

