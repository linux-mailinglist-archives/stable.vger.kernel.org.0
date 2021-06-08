Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214183A015E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhFHSvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235678AbhFHSst (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CF0B61422;
        Tue,  8 Jun 2021 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177517;
        bh=KKSmZjpDI7LtApuy8fqZ8f4a2GjbXSNjayEcZICjsVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrWnKmWgcX2FmhFYbn9IBw3WvILZHjMbQCfPXb3icmJgwRGcsWkW2+2i4f/hdnNVl
         MEeRXYTkwfZDKFOUV86keusWyOv8gYAFEbMZSVbXZHP/LQgyKwthrsBzt3ROK9aGBI
         7vCBoxj7O8ECqrGppURqLyo3kQ0s1eiAND+4hjRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.4 73/78] x86/kvm: Disable kvmclock on all CPUs on shutdown
Date:   Tue,  8 Jun 2021 20:27:42 +0200
Message-Id: <20210608175937.728926756@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
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
@@ -6,8 +6,6 @@
 #include <asm/alternative.h>
 #include <uapi/asm/kvm_para.h>
 
-extern void kvmclock_init(void);
-
 #ifdef CONFIG_KVM_GUEST
 bool kvm_check_and_clear_guest_paused(void);
 #else
@@ -85,6 +83,8 @@ static inline long kvm_hypercall4(unsign
 }
 
 #ifdef CONFIG_KVM_GUEST
+void kvmclock_init(void);
+void kvmclock_disable(void);
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -436,6 +436,7 @@ static void kvm_guest_cpu_offline(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
 	kvm_pv_disable_apf();
 	apf_task_wake_all();
+	kvmclock_disable();
 }
 
 static int kvm_cpu_online(unsigned int cpu)
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -214,11 +214,9 @@ static void kvm_crash_shutdown(struct pt
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


