Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B287B13EC54
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405896AbgAPRoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:44:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405894AbgAPRoC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF5CC24744;
        Thu, 16 Jan 2020 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196642;
        bh=7Ib8Ng+ghXxuvkABsdz66tKXJ5t4d1VzFvS70GhBrfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NuWSwpdeOShvs5QGtSSvgL4P4XL0GLnRdX1u/p3Ith6TU4VaKZUlwwyltTzyfkJj
         bhqCyUVOWGYJQHejbQzs1QkIKUvGCQGoE48bxLoX+kU/1vHaiUgi7NrCLbfmZM//LJ
         27fD96f5Q9wsmD5u2i4J6WPhp6/6k/S1uApVu7Mo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Nicolas Pitre <nico@linaro.org>,
        Anand Moon <linux.amoon@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 053/174] ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used
Date:   Thu, 16 Jan 2020 12:40:50 -0500
Message-Id: <20200116174251.24326-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit ca70ea43f80c98582f5ffbbd1e6f4da2742da0c4 ]

MCPM does a soft reset of the CPUs and uses common cpu_resume() routine to
perform low-level platform initialization. This results in a try to install
HYP stubs for the second time for each CPU and results in false HYP/SVC
mode mismatch detection. The HYP stubs are already installed at the
beginning of the kernel initialization on the boot CPU (head.S) or in the
secondary_startup() for other CPUs. To fix this issue MCPM code should use
a cpu_resume() routine without HYP stubs installation.

This change fixes HYP/SVC mode mismatch on Samsung Exynos5422-based Odroid
XU3/XU4/HC1 boards.

Fixes: 3721924c8154 ("ARM: 8081/1: MCPM: provide infrastructure to allow for MCPM loopback")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Tested-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/common/mcpm_entry.c   |  2 +-
 arch/arm/include/asm/suspend.h |  1 +
 arch/arm/kernel/sleep.S        | 12 ++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/mcpm_entry.c b/arch/arm/common/mcpm_entry.c
index a923524d1040..8617323eb273 100644
--- a/arch/arm/common/mcpm_entry.c
+++ b/arch/arm/common/mcpm_entry.c
@@ -379,7 +379,7 @@ static int __init nocache_trampoline(unsigned long _arg)
 	unsigned int cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
 	phys_reset_t phys_reset;
 
-	mcpm_set_entry_vector(cpu, cluster, cpu_resume);
+	mcpm_set_entry_vector(cpu, cluster, cpu_resume_no_hyp);
 	setup_mm_for_reboot();
 
 	__mcpm_cpu_going_down(cpu, cluster);
diff --git a/arch/arm/include/asm/suspend.h b/arch/arm/include/asm/suspend.h
index 6c7182f32cef..e6c2f426f8c8 100644
--- a/arch/arm/include/asm/suspend.h
+++ b/arch/arm/include/asm/suspend.h
@@ -7,6 +7,7 @@ struct sleep_save_sp {
 };
 
 extern void cpu_resume(void);
+extern void cpu_resume_no_hyp(void);
 extern void cpu_resume_arm(void);
 extern int cpu_suspend(unsigned long, int (*)(unsigned long));
 
diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 0f6c1000582c..c8569390e7e7 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -119,6 +119,14 @@ ENDPROC(cpu_resume_after_mmu)
 	.text
 	.align
 
+#ifdef CONFIG_MCPM
+	.arm
+THUMB(	.thumb			)
+ENTRY(cpu_resume_no_hyp)
+ARM_BE8(setend be)			@ ensure we are in BE mode
+	b	no_hyp
+#endif
+
 #ifdef CONFIG_MMU
 	.arm
 ENTRY(cpu_resume_arm)
@@ -134,6 +142,7 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	bl	__hyp_stub_install_secondary
 #endif
 	safe_svcmode_maskall r1
+no_hyp:
 	mov	r1, #0
 	ALT_SMP(mrc p15, 0, r0, c0, c0, 5)
 	ALT_UP_B(1f)
@@ -162,6 +171,9 @@ ENDPROC(cpu_resume)
 
 #ifdef CONFIG_MMU
 ENDPROC(cpu_resume_arm)
+#endif
+#ifdef CONFIG_MCPM
+ENDPROC(cpu_resume_no_hyp)
 #endif
 
 	.align 2
-- 
2.20.1

