Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0BF39595A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhEaLCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:02:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36931 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhEaLCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 07:02:40 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnffI-0001LC-8C
        for stable@vger.kernel.org; Mon, 31 May 2021 11:01:00 +0000
Received: by mail-wr1-f69.google.com with SMTP id j33-20020adf91240000b029010e4009d2ffso3856717wrj.0
        for <stable@vger.kernel.org>; Mon, 31 May 2021 04:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kEoSYvTEjD0iUfvRsRgx66EC2X7g8N60VyX04WfcGw=;
        b=UwjKQeuj+nbw/PKd9x5lnwdrcnbTAFBMl2lFm20ZSLJUhUcP3bIkq6dDcqjiAzPc/r
         1m/5d/Nc6qBm6vP1DYt/n6E982HkwIl1erChwG/fmcMJU3DsDYBBrgQB8q8HjNMnug8T
         q+H+QHX6Vc8M5BEq9yT3jPRAkFwVYyvVF15v03QGv//2AbgAgR490ECWtgQTPqOJaFwO
         5ydKpC8C1I/aHKDwahSDTZVVyB8KSve4E0/M4nTQ+bxDkFMlvt8rtDaZuyyYBw7XnlSs
         7K6H6BhyVn2EjEUqHSO6UswwkkjnDp3fRu3v8iOphHET2yDfHyS8hDM6pjy0HmqIUHRl
         iV7w==
X-Gm-Message-State: AOAM530QSJXWZrZ+3Q21Infrw+NnFCeDe3CItkHR4QLCKmzAGki0+7kC
        SMfS6F8Ep19KRSOJ46Rof8GWCuuw/vHVMveamafRuv6XxpoEzQS4nJPHFLBz3qGQQIe3Ev+nYYH
        0+gWIo9mY8tmnSaZEaiBGkLwbAdV97HnuFg==
X-Received: by 2002:adf:e54f:: with SMTP id z15mr4406969wrm.141.1622458859590;
        Mon, 31 May 2021 04:00:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzNyCsQbPWnSyVe/WEDSCxJ47wRyVL8rzTiQTuPYdohoFFOBIC6GpjsWTyMKDe34jmqc5JXw==
X-Received: by 2002:adf:e54f:: with SMTP id z15mr4406959wrm.141.1622458859405;
        Mon, 31 May 2021 04:00:59 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id n20sm14608799wmk.12.2021.05.31.04.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 04:00:59 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v2 | stable v5.4+ 2/3] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Mon, 31 May 2021 13:00:52 +0200
Message-Id: <20210531110053.14640-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
References: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
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
index 6b906a651fb1..f535ba7714f8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -555,6 +555,7 @@ static void kvm_guest_cpu_offline(void)
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

