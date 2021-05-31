Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434E395F41
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhEaOJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40500 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhEaOHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:07:20 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniXv-000212-2s
        for stable@vger.kernel.org; Mon, 31 May 2021 14:05:35 +0000
Received: by mail-wr1-f71.google.com with SMTP id m27-20020a056000025bb0290114d19822edso3266385wrz.21
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a2jVZ1KgDiAQn6D+kEMc28pHNApYqYIPAo/+UMrBwJU=;
        b=opaJkOMKyilZ8vkV3Fg7mvdQ8goQ1c0vkQnE2xQJ0G3W44Oa5LVoA9QCi4d9KpFjyG
         OuekAGg5n5pOcWyUSpxo9OoaHORxm9VQX4oV9UVnR1T/ZcPrcqawY4DOcGZbzZL/O9bx
         lJE2IZ5h3ju58NA3FbOz2HMgrW+dD7ZTAvPIDLdNFLKfrvoKi15SVYX2rZHjqk6lWfuV
         pBIyW7NUR3vzGMknjIj+EwHrVlK8WByduoBZn/iqFnje7O3Xob+MRMK0Fevb2d4LZVAu
         viOMJ0rTQDaJIc6fJ4rdGbyU9+I+jyTAbtm9e80n+XH70IjfgbqOswzuF0NLGDLTNPDY
         cRoA==
X-Gm-Message-State: AOAM533V7ByCfgEodI6+xRH0QnRVzuGWxSW/Xb+0CmxhUz5nzt2IRh07
        q+eMWTWLLTi0LxqXhTJOwZYMukur3GF1/X4DnLeYTTOXf9ju/CXPlFWnj0Cyx7v8FfXFSon79yn
        isddUMgODB+A7QQv7htmDYmmpCcHbvY4zmQ==
X-Received: by 2002:a1c:4e11:: with SMTP id g17mr26843467wmh.185.1622469934589;
        Mon, 31 May 2021 07:05:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGtUxYN/nJYVyNLcM+GTrSUa3Tfj+jiQE+TPV5CgJnORj3IFlhGCgav/EhvBKLsZ5HqLiahw==
X-Received: by 2002:a1c:4e11:: with SMTP id g17mr26843454wmh.185.1622469934470;
        Mon, 31 May 2021 07:05:34 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a3sm8858826wra.4.2021.05.31.07.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:05:33 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.10 2/3] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Mon, 31 May 2021 16:05:25 +0200
Message-Id: <20210531140526.42932-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
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
index 6af3f9c3956c..be1c42e663c6 100644
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
index 5ee705b44560..327a0de01066 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -221,11 +221,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
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
@@ -352,7 +350,6 @@ void __init kvmclock_init(void)
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
 	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
-	machine_ops.shutdown  = kvm_shutdown;
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
-- 
2.27.0

