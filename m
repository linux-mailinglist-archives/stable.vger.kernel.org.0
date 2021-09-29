Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9026341BE99
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 07:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbhI2FPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 01:15:33 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:41166 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244207AbhI2FPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 01:15:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uq-OmY6_1632892430;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0Uq-OmY6_1632892430)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 13:13:50 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2] ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
Date:   Wed, 29 Sep 2021 13:13:49 +0800
Message-Id: <1632892429-101194-3-git-send-email-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
References: <1632892429-101194-1-git-send-email-zelin.deng@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If PTP_SYS_OFFSET_PRECISE ioctl is executed on vCPU >= 64, struct
pvclock_vcpu_time_info *src which is got by "src = &hv_clock[cpu].pvti"
could be wild/dangling pointer, as hv_clock arrary has only
HVC_BOOT_ARRAY_SIZE (64) elements.
Therefore let's change it to "this_cpu_pvti()"

Fixes: 95a3d4454bb1 ("Switch kvmclock data to a PER_CPU variable")
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 3dd519d..d0096cd 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -15,8 +15,6 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/ptp_kvm.h>
 
-struct pvclock_vsyscall_time_info *hv_clock;
-
 static phys_addr_t clock_pair_gpa;
 static struct kvm_clock_pairing clock_pair;
 
@@ -28,8 +26,7 @@ int kvm_arch_ptp_init(void)
 		return -ENODEV;
 
 	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	hv_clock = pvclock_get_pvti_cpu0_va();
-	if (!hv_clock)
+	if (!pvclock_get_pvti_cpu0_va())
 		return -ENODEV;
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
@@ -64,10 +61,8 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 	struct pvclock_vcpu_time_info *src;
 	unsigned int version;
 	long ret;
-	int cpu;
 
-	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
+	src = this_cpu_pvti();
 
 	do {
 		/*
-- 
1.8.3.1

