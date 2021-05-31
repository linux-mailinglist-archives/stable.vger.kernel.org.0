Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22D9395F3F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhEaOJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:09:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40496 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhEaOHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 10:07:20 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lniXu-00020q-6o
        for stable@vger.kernel.org; Mon, 31 May 2021 14:05:34 +0000
Received: by mail-wr1-f69.google.com with SMTP id m27-20020a056000025bb0290114d19822edso3266371wrz.21
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LSJTFlGpa5NUKQqBMPoCz4y9REuErscmwKb1OY8MtZ4=;
        b=pm+Ga2cgiMBe8cjRhSQ6RupVb9vzMlj06pos9RPiGxvkBPYBQIiFLBmcxqDo8RvZYD
         nwvsW/amoZlU0T0/lNzBiwCXNA4MNeNnpBvc6I/hBndbezHSaqkSnPOYo0Gh4pBaztHj
         qOZwpAjbwAKBgZ85Ah04K5ZFOJeixOxMxIy3VGcOtO2BYhe03Ot6afrPmw9z60xi10sF
         v/4AiBZYNd/jIFeX9Eae80n6s9rREbrDOlVWuGa8kfrs1NCBPkloGw4gi7SVTY6l8cPy
         gOoKuatkrMQst48DBSI49zGr0ops0Bp4kMrbDsk7hIPamd0A81LyxJrZ7u8SGzzdL/Z6
         SqHA==
X-Gm-Message-State: AOAM533y8CggvB9IrcN0NIG2UlxJ/JNJ8sqJfnQzuNsonoINpJKwwlsR
        BvYrkKqXyAVXoP30Cpu9CNQlGxLvlaR+RnVc6EIwlGtC/luG8VieX0SHK1Ltal93dibtcs/dqaT
        TiO+gOUypudisKELiVOXbx0N1cWzk0WQ0Nw==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr18419321wmb.80.1622469933492;
        Mon, 31 May 2021 07:05:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcnTc8HvJvREWtBrPyCBxvD+5UUggfuG2vcr791T/Tjf+jRkYfpkV2SwASyOi8lh5U1AtbGg==
X-Received: by 2002:a1c:1bd8:: with SMTP id b207mr18419314wmb.80.1622469933359;
        Mon, 31 May 2021 07:05:33 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a3sm8858826wra.4.2021.05.31.07.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:05:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 | stable v5.10 1/3] x86/kvm: Teardown PV features on boot CPU as well
Date:   Mon, 31 May 2021 16:05:24 +0200
Message-Id: <20210531140526.42932-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
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
index 7f57ede3cb8e..6af3f9c3956c 100644
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

