Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95654396DD3
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhFAHSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:18:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60753 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAHSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:18:41 -0400
Received: from mail-wm1-f69.google.com ([209.85.128.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnye4-0002km-8Z
        for stable@vger.kernel.org; Tue, 01 Jun 2021 07:17:00 +0000
Received: by mail-wm1-f69.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso760569wml.6
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 00:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emyUtAWEgDmFnmhXG3HYQB6UCm32cWFuLm9kPRBLFac=;
        b=D2+hl9C1VxCzI1yUzoG3XCT0lnVPLFRlOo3vswYATFZd3mFilqZ1SCxhyV5yuIFGEg
         Vtq5plrburcywxYURZ/6Kd/iEt9xbE7wY1eipufvVujcd4gx4hWvX4bgm4k3oBT3iyWb
         RI5ymQE2VRliyKRi7Q4ErlFmaJrP0ja+APbVdqvLe3h+yjE00IwHTfRspqyW5luq8zor
         ADuWRb+F7UHsZADiXWS33/J9Ac4i9AuJe+55Y6YQX6Ip2UZl6MKIRcqpF+exJm944Ph5
         COF6NX8wohsDLHOmRZOlRjh5OtHhB5WRqR0Ud/IYV/adpkXjkHJRm6TXc37Q9MWrnLE/
         +yyw==
X-Gm-Message-State: AOAM533TweAZDO1tWbDrzdzaokBubLRozNA3FXvECYijCqgsdxq6mcmM
        8bpFsBNq0K9oxdrGY9nwURYheCQDT5Whag1Vgnj2QGuFuGxn3ubq/n6ksQhfPX+BizxMmPqU4LU
        A8hk4i8TPi69ORSGcrKIwqtw9gkCoEkxaDQ==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr24772772wri.24.1622531819761;
        Tue, 01 Jun 2021 00:16:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV6REufv9sxaOSiw58y5Vatl+jTKAcRUTHaP2brj73CCq0LAEG/KOOw1ZnU+ZvqyOQjub/2A==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr24772761wri.24.1622531819612;
        Tue, 01 Jun 2021 00:16:59 -0700 (PDT)
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
Subject: [PATCH v3 | stable v5.12 1/3] x86/kvm: Teardown PV features on boot CPU as well
Date:   Tue,  1 Jun 2021 09:16:42 +0200
Message-Id: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
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
---
 arch/x86/kernel/kvm.c | 57 +++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 78bb0fae3982..5ae57be19187 100644
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
@@ -587,31 +607,34 @@ static void __init kvm_smp_prepare_boot_cpu(void)
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
-- 
2.27.0

