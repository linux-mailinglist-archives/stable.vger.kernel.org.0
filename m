Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C609141BE97
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 07:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244212AbhI2FPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 01:15:32 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33639 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244185AbhI2FPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 01:15:31 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uq-OmY-_1632892429;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0Uq-OmY-_1632892429)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 13:13:50 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] x86/kvmclock: Move this_cpu_pvti into kvmclock.h
Date:   Wed, 29 Sep 2021 13:13:48 +0800
Message-Id: <1632892429-101194-2-git-send-email-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
References: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There're other modules might use hv_clock_per_cpu variable like ptp_kvm,
so move it into kvmclock.h and export the symbol to make it visiable to
other modules.

Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/include/asm/kvmclock.h | 14 ++++++++++++++
 arch/x86/kernel/kvmclock.c      | 13 ++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index eceea92..fcd1ad6 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -2,6 +2,20 @@
 #ifndef _ASM_X86_KVM_CLOCK_H
 #define _ASM_X86_KVM_CLOCK_H
 
+#include <linux/percpu.h>
+
 extern struct clocksource kvm_clock;
 
+extern struct pvclock_vsyscall_time_info *hv_clock_per_cpu;
+
+static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
+{
+	return &this_cpu_read(hv_clock_per_cpu)->pvti;
+}
+
+static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
+{
+	return this_cpu_read(hv_clock_per_cpu);
+}
+
 #endif /* _ASM_X86_KVM_CLOCK_H */
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ad273e5..6c6b1b3 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -49,18 +49,9 @@ static int __init parse_no_kvmclock_vsyscall(char *arg)
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
-static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
-
-static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
-{
-	return &this_cpu_read(hv_clock_per_cpu)->pvti;
-}
-
-static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
-{
-	return this_cpu_read(hv_clock_per_cpu);
-}
+DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
+EXPORT_SYMBOL_GPL(hv_clock_per_cpu);
 
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
-- 
1.8.3.1

