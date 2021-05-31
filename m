Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4362395F1C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhEaOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40469 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhEaOFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:05:55 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniWc-0001ue-Qc
        for stable@vger.kernel.org; Mon, 31 May 2021 14:04:14 +0000
Received: by mail-wm1-f71.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso4757044wml.6
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tYp2U1QsmF0ysELNpqJ79RmF4UeWtDRVw3MPXUToa8g=;
        b=uUV6CjhKljMVXtpwEXtbdptp4xRzIeRaXNsjO0f4HXG3F/2yzOruWPI82PvESDOf3e
         LRBdhMHQB9KK7nbtWt0e3on5Rg1jUF1zRe1oURBSIYSBTmc7KMb+S9yPsgukeLPDBomC
         5NXH/K+Xtppgfu/lD0yYilp/+r5PAhd0FVNjb5+yzeOFCfvEYhZPZbXJKcMI24YA9sVD
         2kY5g7KnsQ3S5dcPrUAthALsnzXC57ZNmk1NFB4fYKGpewAmi0iqvqlorgO0zlFVcw5j
         /52TRZnlzbEeEUDAUs4ql/+7GJSlO8/7ghgM4jad8TlZNJqC5FNUs+vU7uvbmCzYW4ju
         aeBQ==
X-Gm-Message-State: AOAM530bqvOAwcObc1G286VoXdp4BEBXRoxWQlJutTIUK2YC5Qfpkb5s
        T5RvPRYZTJI2czd9HR0+4tNaFlXGnebxIeP2AkRpeaRjcCYjiJvEjNkvJpSE1x97v5J00NOzfZM
        8uU+nBC02p0xE6GHhOjGDo6Qp15mZFDjR5g==
X-Received: by 2002:a1c:e907:: with SMTP id q7mr26713890wmc.1.1622469854339;
        Mon, 31 May 2021 07:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB3gbVUbOSak/tYr7TeZZxwAMNLu/8QNdaRl4Iq3kBB5FS/U5OqRM4iwGXdYOBrrHfypfWlw==
X-Received: by 2002:a1c:e907:: with SMTP id q7mr26713866wmc.1.1622469854156;
        Mon, 31 May 2021 07:04:14 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm13342971wmh.18.2021.05.31.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:04:13 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.4 2/3] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Mon, 31 May 2021 16:03:46 +0200
Message-Id: <20210531140347.42681-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit c02027b5742b5aa804ef08a4a9db433295533046 upstream.

Currenly, we disable kvmclock from machine_shutdown() hook and this
only happens for boot CPU. We need to disable it for all CPUs to
guard against memory corruption e.g. on restore from hibernate.

Note, writing '0' to kvmclock MSR doesn't clear memory location, it
just prevents hypervisor from updating the location so for the short
while after write and while CPU is still alive, the clock remains usable
and correct so we don't need to switch to some other clocksource.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210414123544.1060604-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/x86/include/asm/kvm_para.h | 4 ++--
 arch/x86/kernel/kvm.c           | 1 +
 arch/x86/kernel/kvmclock.c      | 5 +----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..a617fd360023 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -6,8 +6,6 @@
 #include <asm/alternative.h>
 #include <uapi/asm/kvm_para.h>
 
-extern void kvmclock_init(void);
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_check_and_clear_guest_paused(void);
 #else
@@ -85,6 +83,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 }
 
 #ifdef CONFIG_KVM_GUEST
+void kvmclock_init(void);
+void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 82a2756e0ef8..d6f04d32dec0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -436,6 +436,7 @@ static void kvm_guest_cpu_offline(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
 	apf_task_wake_all();
+	kvmclock_disable();
 }
 
 static int kvm_cpu_online(unsigned int cpu)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 904494b924c1..bd3962953f78 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -214,11 +214,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-static void kvm_shutdown(void)
+void kvmclock_disable(void)
 {
 	native_write_msr(msr_kvm_system_time, 0, 0);
-	kvm_disable_steal_time();
-	native_machine_shutdown();
 }
 
 static void __init kvmclock_init_mem(void)
@@ -346,7 +344,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-	machine_ops.shutdown  = kvm_shutdown;
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
-- 
2.27.0

