Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18E7395F42
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhEaOJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40502 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhEaOHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:07:20 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniXw-00021M-Db
        for stable@vger.kernel.org; Mon, 31 May 2021 14:05:36 +0000
Received: by mail-wr1-f69.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so3993958wrb.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qav1baKraoxbVglZQwKwrwkZpPVq0VwuywUHpQhyR/0=;
        b=KTNwu4avPpCNESPUc6eiDzkjp2aqD5TDiX0ga82PNTl104/Guy/qdmbiTF1t3VrkQ7
         44gR1uwzLKS682GKdLxAwDE5t2lAKHBhrHfwXsrYrkMU/97UI4W+BavghFLjnLag14IM
         scXMmkdeTxv386KD0/e77U8B5OsQ+NSp/L1nsU6a/kqrj8CMV5H5WLb/kiTQQ3pZozQS
         KPuJISLqrASSK/PztONRkbsZwQ9iTtq2dcePcwI0q5/8eg6D53HN4ofLwQKj1vg4EEFE
         t3T0rwqXxz0/3hX5ftZV2nY3sNyCkjFaokKTaVfssmeyHmC3wjyoroVwsULamsAcpiJr
         iuoQ==
X-Gm-Message-State: AOAM531cXdaWdFdHL0IbiX5GD4D8i91taQZH9DROMSRijY0w6kDcOZsO
        zxE5WhF0Yl26PrrRsFNrrzAYThzAeuUCjLwDcYTvcxqG/36ijL7/YXErwcUCJzp7LErS8yPfyvl
        MPc1WcqlImAZncUX9RR0thWwRzasYYg08iA==
X-Received: by 2002:a7b:cd98:: with SMTP id y24mr26689238wmj.4.1622469935904;
        Mon, 31 May 2021 07:05:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNUVy9S0IhYI9xyhAjIkudWKnsCDSv5mVwv2sUwB9qLwvujWRfrB0UcIm/c9EfXTLaUPm9cw==
X-Received: by 2002:a7b:cd98:: with SMTP id y24mr26689220wmj.4.1622469935706;
        Mon, 31 May 2021 07:05:35 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a3sm8858826wra.4.2021.05.31.07.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:05:34 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.10 3/3] x86/kvm: Disable all PV features on crash
Date:   Mon, 31 May 2021 16:05:26 +0200
Message-Id: <20210531140526.42932-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
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
index be1c42e663c6..7462b79c39de 100644
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
index 327a0de01066..c4ac26333bc4 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -20,7 +20,6 @@
 #include <asm/hypervisor.h>
 #include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
-#include <asm/reboot.h>
 #include <asm/kvmclock.h>
 
 static int kvmclock __initdata = 1;
@@ -204,23 +203,6 @@ static void kvm_setup_secondary_clock(void)
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
@@ -350,9 +332,6 @@ void __init kvmclock_init(void)
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

