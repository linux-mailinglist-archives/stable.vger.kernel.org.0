Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3D3A0269
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhFHTDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236121AbhFHTBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0182461451;
        Tue,  8 Jun 2021 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177868;
        bh=RnamPyzzLgDAjpmq5+G3y1v3oSxEB4jU6/3szJu2PRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdJXOHmFe/7hoO9FE5XgkQx/3FJx2e9j6ojtwI+d95826n+REzoDsAH8TcxgNVUQ4
         HOMXlG2ZjvqPXdBiEvT4xEh4y5M45Mh5tXDzDAmTSXgmcuVwm9VsXTALwKajrz7o0l
         tqjnucIl4SpM6vWG3cL3AuU+w4gAPCr+npKWKbnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.10 130/137] x86/kvm: Teardown PV features on boot CPU as well
Date:   Tue,  8 Jun 2021 20:27:50 +0200
Message-Id: <20210608175946.781960137@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 8b79feffeca28c5459458fe78676b081e87c93a4 upstream.

Various PV features (Async PF, PV EOI, steal time) work through memory
shared with hypervisor and when we restore from hibernation we must
properly teardown all these features to make sure hypervisor doesn't
write to stale locations after we jump to the previously hibernated kernel
(which can try to place anything there). For secondary CPUs the job is
already done by kvm_cpu_down_prepare(), register syscore ops to do
the same for boot CPU.

Krzysztof:
This fixes memory corruption visible after second resume from
hibernation:

  BUG: Bad page state in process dbus-daemon  pfn:18b01
  page:ffffea000062c040 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 compound_mapcount: -30591
  flags: 0xfffffc0078141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
  raw: 000fffffc0078141 dead0000000002d0 dead000000000100 0000000000000000
  raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
  bad because of flags: 0x78141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210414123544.1060604-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
[krzysztof: Extend the commit message, adjust for v5.10 context]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |   57 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 16 deletions(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -26,6 +26,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/syscore_ops.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -460,6 +461,25 @@ static bool pv_tlb_flush_supported(void)
 
 static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
 
+static void kvm_guest_cpu_offline(void)
+{
+	kvm_disable_steal_time();
+	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
+		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	kvm_pv_disable_apf();
+	apf_task_wake_all();
+}
+
+static int kvm_cpu_online(unsigned int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	kvm_guest_cpu_init();
+	local_irq_restore(flags);
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 
 static bool pv_ipi_supported(void)
@@ -587,31 +607,34 @@ static void __init kvm_smp_prepare_boot_
 	kvm_spinlock_init();
 }
 
-static void kvm_guest_cpu_offline(void)
+static int kvm_cpu_down_prepare(unsigned int cpu)
 {
-	kvm_disable_steal_time();
-	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
-	kvm_pv_disable_apf();
-	apf_task_wake_all();
-}
+	unsigned long flags;
 
-static int kvm_cpu_online(unsigned int cpu)
-{
-	local_irq_disable();
-	kvm_guest_cpu_init();
-	local_irq_enable();
+	local_irq_save(flags);
+	kvm_guest_cpu_offline();
+	local_irq_restore(flags);
 	return 0;
 }
 
-static int kvm_cpu_down_prepare(unsigned int cpu)
+#endif
+
+static int kvm_suspend(void)
 {
-	local_irq_disable();
 	kvm_guest_cpu_offline();
-	local_irq_enable();
+
 	return 0;
 }
-#endif
+
+static void kvm_resume(void)
+{
+	kvm_cpu_online(raw_smp_processor_id());
+}
+
+static struct syscore_ops kvm_syscore_ops = {
+	.suspend	= kvm_suspend,
+	.resume		= kvm_resume,
+};
 
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
@@ -681,6 +704,8 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+	register_syscore_ops(&kvm_syscore_ops);
+
 	/*
 	 * Hard lockup detection is enabled by default. Disable it, as guests
 	 * can get false positives too easily, for example if the host is


