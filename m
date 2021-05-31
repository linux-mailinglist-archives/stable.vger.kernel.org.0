Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BB395F1A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhEaOHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40464 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhEaOFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:05:54 -0400
Received: from mail-wm1-f72.google.com ([209.85.128.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniWb-0001uB-I0
        for stable@vger.kernel.org; Mon, 31 May 2021 14:04:13 +0000
Received: by mail-wm1-f72.google.com with SMTP id n127-20020a1c27850000b02901717a27c785so4752593wmn.9
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lg3bqol7/ez1mPu5MpydCUzkHZ+OztXOvXYB2DFuDcs=;
        b=ZrannlXVHxx9NrUhjKuj0NbZYn3tlD9aHuD/1qJQ2YBdVL8Yil/3KMchoEYpOnEbzN
         JmdXo0/L7jKqPpD+J3LJNMbKySJWlTY2Yh+mQJXeWLgkT1ItaacO5Ba58/1rIGOlY7jh
         po2m1DON6ysFQOcYg7x60hJ+uCViuI3yYcIEw+dcYUVJjRztM+f9o+FA+CK//Jbcbxc8
         v5cJxRmp/79SmCUIjzKuUnA2IgV/BnqIDH5b0nawAYjT5R4gd+xe/z+AmBbbCiVeZCQI
         9SpR0ZhGIt4EkRFI9O97IPv9ZA2RWOOV0Vm3KVO2/7bND7gFBAsW44ciQJh7AukKu+Ye
         ttPw==
X-Gm-Message-State: AOAM531rIN111P5eFneIYXwForVjmhkKnAtcvJbfD6ZFNWcqS4fb1zHg
        rugNnO4AGP0B7N7gL0YeVQVljtQGsdN3/4O3j45wOgxT2l7fWezAhE+Qimjv95GrI3ebiOVDcK9
        NqGphKsC9NjDlY+GX5KxPOxEoozz6ihY4DA==
X-Received: by 2002:a5d:4d88:: with SMTP id b8mr15578259wru.178.1622469852946;
        Mon, 31 May 2021 07:04:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrQSnVHpor4LHepQchWqEMxUONa4xLbKQoJSOBg2/Cj2B8B/GWyILMEoMVix8udwnv1xZ3uA==
X-Received: by 2002:a5d:4d88:: with SMTP id b8mr15578233wru.178.1622469852785;
        Mon, 31 May 2021 07:04:12 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id b188sm13342971wmh.18.2021.05.31.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:04:12 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.4 1/3] x86/kvm: Teardown PV features on boot CPU as well
Date:   Mon, 31 May 2021 16:03:45 +0200
Message-Id: <20210531140347.42681-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
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
[krzysztof: Extend the commit message]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/x86/kernel/kvm.c | 57 +++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e820568ed4d5..82a2756e0ef8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -24,6 +24,7 @@
 #include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/syscore_ops.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -428,6 +429,25 @@ static void __init sev_map_percpu_data(void)
 	}
 }
 
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
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
 
@@ -547,31 +567,34 @@ static void __init kvm_smp_prepare_boot_cpu(void)
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
 
 static void __init kvm_apf_trap_init(void)
 {
@@ -649,6 +672,8 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+	register_syscore_ops(&kvm_syscore_ops);
+
 	/*
 	 * Hard lockup detection is enabled by default. Disable it, as guests
 	 * can get false positives too easily, for example if the host is
-- 
2.27.0

