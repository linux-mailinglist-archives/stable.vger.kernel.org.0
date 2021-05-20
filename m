Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE538AF5E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhETNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 09:00:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37054 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243069AbhETM57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:57:59 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljiE7-0005QB-LR
        for stable@vger.kernel.org; Thu, 20 May 2021 12:56:35 +0000
Received: by mail-qk1-f199.google.com with SMTP id e8-20020a05620a2088b02903a5edeec4d6so2091843qka.11
        for <stable@vger.kernel.org>; Thu, 20 May 2021 05:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GTsCI7Ul4nDoQha4vSzhm2s0jP3aZ/M4QD8W/QCV/+0=;
        b=JdHXNRaZ+VB523BsWlciwtn9yZjzlkz7etdkz5z543V+dyzhUdknlOPX7+qnhs5QN/
         y6bcPfk2z0l/sntWsTg8pEldq/72TOB73/oW3k0zz+B6Qh7O5KMK/jZ9rpRtYCsUYp/z
         Ja3iV7PVVVj0UCZ1q4TkYIXbqVbCZ6QfDXCjRpnoXby23Yjo6YgLfakFdRtahZhdixfD
         4Eb4AyOMcb1CHIb3bJsid+qHTX//SfajfA8fYPnDheZUmQeAFGyJ7xltz0dxhu+BzZlM
         cGTlk84vVNyFWTBZuJjbmRBT5psT2FuwUOOj+hOz2+HOzB/rGDKVja8TMvG943d+u5T0
         C4ag==
X-Gm-Message-State: AOAM530SW2xvIYUJEGcwZnj1RuH1jfa/NxIl8lm3D485IMTkbKHkW0FP
        KvfH9J2hDanARYyOR0F+QPyYWz/mHXYqQwoJPuiPMkahFUXBVm2iiJO09ASkXuW2z+neY35N2bE
        efrDXOAwi/VnHwwOHxxUpYdWsrl+PJgc8kA==
X-Received: by 2002:a37:4697:: with SMTP id t145mr4889840qka.188.1621515394427;
        Thu, 20 May 2021 05:56:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVA/A4t3ep/bU/SXqDGZuuLc1tdq3g7fGuJjWd5nWI06K1ldK6khe556QlVnqNuNVK+VNUrA==
X-Received: by 2002:a37:4697:: with SMTP id t145mr4889807qka.188.1621515394226;
        Thu, 20 May 2021 05:56:34 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id g185sm1931471qkf.62.2021.05.20.05.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 05:56:33 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v5.4+ 1/3] x86/kvm: Teardown PV features on boot CPU as well
Date:   Thu, 20 May 2021 08:56:23 -0400
Message-Id: <20210520125625.12566-1-krzysztof.kozlowski@canonical.com>
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
[krzysztof: Extend the commit message]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---

Backport to v5.4 seems reasonable. Might have sense to earlier versions,
but this was not tested/investigated.

 arch/x86/kernel/kvm.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index e820568ed4d5..6b906a651fb1 100644
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
@@ -558,17 +559,21 @@ static void kvm_guest_cpu_offline(void)
 
 static int kvm_cpu_online(unsigned int cpu)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	kvm_guest_cpu_init();
-	local_irq_enable();
+	local_irq_restore(flags);
 	return 0;
 }
 
 static int kvm_cpu_down_prepare(unsigned int cpu)
 {
-	local_irq_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	kvm_guest_cpu_offline();
-	local_irq_enable();
+	local_irq_restore(flags);
 	return 0;
 }
 #endif
@@ -606,6 +611,23 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 	native_flush_tlb_others(flushmask, info);
 }
 
+static int kvm_suspend(void)
+{
+	kvm_guest_cpu_offline();
+
+	return 0;
+}
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
+
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -649,6 +671,8 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
+	register_syscore_ops(&kvm_syscore_ops);
+
 	/*
 	 * Hard lockup detection is enabled by default. Disable it, as guests
 	 * can get false positives too easily, for example if the host is
-- 
2.27.0

