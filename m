Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D02395959
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhEaLCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:02:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36926 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhEaLCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 07:02:39 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnffH-0001Kk-7p
        for stable@vger.kernel.org; Mon, 31 May 2021 11:00:59 +0000
Received: by mail-wm1-f71.google.com with SMTP id r15-20020a05600c35cfb029017cc4b1e9faso4613145wmq.8
        for <stable@vger.kernel.org>; Mon, 31 May 2021 04:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+DgiXoj6qTP+yF+xL8PSJDoMwK43wCJAZIyKl0RWBw=;
        b=AbOjaG3Z5tC0WZ7Bnp8lm2coVVuSTwGfs/+4m/NvhgmbyvkBSEKQjnXQP3i8+/f+kd
         KG2RSyiznAywzIeX6ounEUcGN7ozcltpmmuzAxbyXER6inDtId6gfz+yHdlcJZvqzcpV
         +VAtVSzoiq5SSr4PGz6Yw08QPAd0csSv1hgtwcr2re8OJMlEs394BsicrsbjeVhuWc0V
         4FxQ4bvnhaJ0a9jorOAdfY6zIsSo8rSIW5+QQwyA4x/YxHPei6dw0lXxkTAvV80wGDb3
         DfDkU9Ym0zh0Myo2fsJrDggYgT6PkY6XtSQxadpHMEFBsQu2Kj3+Bkpl9o0i+0W1Q9mF
         LLTw==
X-Gm-Message-State: AOAM532A8Vbds+RBBAb9BokpfndbXZrSzncnPeAHL8mFBLhiEq5z8UR7
        LsEbLgBwnIBFxhhMVvKFZS3OarKWgIUTjQQwc4yS4kyFA9AelQiiNZXYlsdx7EZZ7wUYZoWpvx5
        HXOC0ogf62B02fD206qVO6IwVBYgjwGY/IQ==
X-Received: by 2002:adf:f4ce:: with SMTP id h14mr21919998wrp.269.1622458858429;
        Mon, 31 May 2021 04:00:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCoAkWQ1XtzDhICKTKv1sCFak1muQsWdiGAljOSLUuVu8v1NZL23zoK2Gm3UZCf0Qg/KLjUA==
X-Received: by 2002:adf:f4ce:: with SMTP id h14mr21919982wrp.269.1622458858276;
        Mon, 31 May 2021 04:00:58 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id n20sm14608799wmk.12.2021.05.31.04.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 04:00:57 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v2 | stable v5.4+ 1/3] x86/kvm: Teardown PV features on boot CPU as well
Date:   Mon, 31 May 2021 13:00:51 +0200
Message-Id: <20210531110053.14640-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
References: <20210531110053.14640-1-krzysztof.kozlowski@canonical.com>
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

