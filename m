Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E70F106330
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfKVGIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbfKVGBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE8DD2070B;
        Fri, 22 Nov 2019 06:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402495;
        bh=bn7fpoGbsr5yYxne9+e9O//N48LFYLbM1CQiyWwEfes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmIfM/4BYSV6ivc/n8G7zKhe+pz3B/8YyABlnChdG/3LGtOtAx1LIsBd8MVMIUZ/S
         aahLMdYCu+f9oKNcuTM6uJw0r0Rc0ZhmIg/ATdRq4ODB/OwqxmlFVHL+xedHmotmaS
         lZqN9VJFsQQocIJEOUozY6+zowLWUXfaWqEMOc9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 06/91] arm64: mm: Prevent mismatched 52-bit VA support
Date:   Fri, 22 Nov 2019 01:00:04 -0500
Message-Id: <20191122060129.4239-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Capper <steve.capper@arm.com>

[ Upstream commit a96a33b1ca57dbea4285893dedf290aeb8eb090b ]

For cases where there is a mismatch in ARMv8.2-LVA support between CPUs
we have to be careful in allowing secondary CPUs to boot if 52-bit
virtual addresses have already been enabled on the boot CPU.

This patch adds code to the secondary startup path. If the boot CPU has
enabled 52-bit VAs then ID_AA64MMFR2_EL1 is checked to see if the
secondary can also enable 52-bit support. If not, the secondary is
prevented from booting and an error message is displayed indicating why.

Technically this patch could be implemented using the cpufeature code
when considering 52-bit userspace support. However, we employ low level
checks here as the cpufeature code won't be able to run if we have
mismatched 52-bit kernel va support.

Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/head.S | 26 ++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c  |  5 +++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index db6ff1944c412..3b10b93959607 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -686,6 +686,7 @@ secondary_startup:
 	/*
 	 * Common entry point for secondary CPUs.
 	 */
+	bl	__cpu_secondary_check52bitva
 	bl	__cpu_setup			// initialise processor
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
@@ -759,6 +760,31 @@ ENTRY(__enable_mmu)
 	ret
 ENDPROC(__enable_mmu)
 
+ENTRY(__cpu_secondary_check52bitva)
+#ifdef CONFIG_ARM64_52BIT_VA
+	ldr_l	x0, vabits_user
+	cmp	x0, #52
+	b.ne	2f
+
+	mrs_s	x0, SYS_ID_AA64MMFR2_EL1
+	and	x0, x0, #(0xf << ID_AA64MMFR2_LVA_SHIFT)
+	cbnz	x0, 2f
+
+	adr_l	x0, va52mismatch
+	mov	w1, #1
+	strb	w1, [x0]
+	dmb	sy
+	dc	ivac, x0	// Invalidate potentially stale cache line
+
+	update_early_cpu_boot_status CPU_STUCK_IN_KERNEL, x0, x1
+1:	wfe
+	wfi
+	b	1b
+
+#endif
+2:	ret
+ENDPROC(__cpu_secondary_check52bitva)
+
 __no_granule_support:
 	/* Indicate that this CPU can't boot and is stuck in the kernel */
 	update_early_cpu_boot_status CPU_STUCK_IN_KERNEL, x1, x2
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index cfd33f18f4378..f0c41524b052f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -136,6 +136,7 @@ static int boot_secondary(unsigned int cpu, struct task_struct *idle)
 }
 
 static DECLARE_COMPLETION(cpu_running);
+bool va52mismatch __ro_after_init;
 
 int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
@@ -164,6 +165,10 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 
 		if (!cpu_online(cpu)) {
 			pr_crit("CPU%u: failed to come online\n", cpu);
+
+			if (IS_ENABLED(CONFIG_ARM64_52BIT_VA) && va52mismatch)
+				pr_crit("CPU%u: does not support 52-bit VAs\n", cpu);
+
 			ret = -EIO;
 		}
 	} else {
-- 
2.20.1

