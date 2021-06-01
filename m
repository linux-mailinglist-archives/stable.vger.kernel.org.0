Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BBD396DD4
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAHSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:18:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60759 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhFAHSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:18:42 -0400
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnye5-0002lO-80
        for stable@vger.kernel.org; Tue, 01 Jun 2021 07:17:01 +0000
Received: by mail-wm1-f70.google.com with SMTP id h18-20020a05600c3512b029018434eb1bd8so765987wmq.2
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 00:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3ONUsJUAquB6CIMKNSbBcjFZ7oTwCcRvLqLR9mB/5U=;
        b=aaccIB7qQwd7XzjXxqpxzL+ygIG5forvv59ezR4cbH85e2Be/DkLllVZBLtpLLpo8s
         vRVQtKd8fxdqdia9OSrMox8/Pptt076QnMxeMR8gBaL+8F4dB35Pfkg65IQ6IrrL5qcH
         32pi1I0aEFU3LogNjUzz4RTkQDwX8wFqQEbqzbKAOhrxn11gX7z9zO+ysTgvD28Usu9d
         AhBLV+eyxTtYDhFt1HuJ7h4DywnHbcHhz8ovh3ukoGtI2kl3K4+ix5iDXNAujVTnuAjb
         WOI9heNorKOULa/NJOTeJu2dbnDJ+fJO44oVu3srSmkm1Pfq9IzuyD0rz+yj8mmqAqbO
         PVCQ==
X-Gm-Message-State: AOAM530judKQuA6A5KMfPC6K30SNEFviM4McE+v6x3CGku8AlZzKYI2I
        BmkrYgjRhJVkTn9EPvoIeuTCSGns7eErvXHJ8Nz4+4Isj7y58sZIZsh5gKydL3Mnve9nQU8g4I6
        Ai/GRsKrXByr1fmWjBFVGRRYxbXy9hxHsfQ==
X-Received: by 2002:a05:600c:3786:: with SMTP id o6mr6162401wmr.170.1622531820538;
        Tue, 01 Jun 2021 00:17:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztb4xhX8L22FvmQkboW+Edf91JphzCzKMcqMjisVQqczE4SKPw0RMGKla/j7ayF/C9P6R6Pw==
X-Received: by 2002:a05:600c:3786:: with SMTP id o6mr6162389wmr.170.1622531820422;
        Tue, 01 Jun 2021 00:17:00 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm2083869wmh.18.2021.06.01.00.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 00:16:59 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.12 2/3] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Tue,  1 Jun 2021 09:16:43 +0200
Message-Id: <20210601071644.6055-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
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
index 338119852512..9c56e0defd45 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -7,8 +7,6 @@
 #include <linux/interrupt.h>
 #include <uapi/asm/kvm_para.h>
 
-extern void kvmclock_init(void);
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_check_and_clear_guest_paused(void);
 #else
@@ -86,6 +84,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 }
 
 #ifdef CONFIG_KVM_GUEST
+void kvmclock_init(void);
+void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5ae57be19187..2ebb93c34bc5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -468,6 +468,7 @@ static void kvm_guest_cpu_offline(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
 	apf_task_wake_all();
+	kvmclock_disable();
 }
 
 static int kvm_cpu_online(unsigned int cpu)
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1fc0962c89c0..cf869de98eec 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -220,11 +220,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
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
@@ -351,7 +349,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-	machine_ops.shutdown  = kvm_shutdown;
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
-- 
2.27.0

