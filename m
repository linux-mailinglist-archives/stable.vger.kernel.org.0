Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BA93A03C7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhFHTV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235204AbhFHTSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0495F6128E;
        Tue,  8 Jun 2021 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178306;
        bh=PNZXmBnJwBAjrcJFCMpwg/hNgGTXLtXniNDy/XPXtpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujdPluekSRUtAY+bb93VVmORZjYhCxPwPeqx+tu4rZ6b8T8Ao0eJCTg3WnVA+znB+
         pxVRUQkAQyVW8Zci7mlKjhH+m6MfJdJijIuQkIuqpV4+jR9MqkHeH/4AxtowxsuxXZ
         7uqeer33HVeJ7gqfvL1E/GLdjvyxsYnB+gzXpTo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.12 152/161] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Tue,  8 Jun 2021 20:28:02 +0200
Message-Id: <20210608175950.590711549@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_para.h |    4 ++--
 arch/x86/kernel/kvm.c           |    1 +
 arch/x86/kernel/kvmclock.c      |    5 +----
 3 files changed, 4 insertions(+), 6 deletions(-)

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
@@ -86,6 +84,8 @@ static inline long kvm_hypercall4(unsign
 }
 
 #ifdef CONFIG_KVM_GUEST
+void kvmclock_init(void);
+void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -468,6 +468,7 @@ static void kvm_guest_cpu_offline(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
 	apf_task_wake_all();
+	kvmclock_disable();
 }
 
 static int kvm_cpu_online(unsigned int cpu)
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -220,11 +220,9 @@ static void kvm_crash_shutdown(struct pt
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


