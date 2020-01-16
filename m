Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF65013F1C0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbgAPRZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391950AbgAPRZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C9E246D7;
        Thu, 16 Jan 2020 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195526;
        bh=WCmaEDtXOxvCXlwoVJUqhNOHDoGgqCruE5qN0+T7Gk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdE1EycBPzoit5Q4OhZo5i+3YyHqw4ybMzXHHLF9JTCq/szGLUbjtRrVixIdv+eBc
         Bp1ATD9CObUF03VZ6rN2bd5p716PAeQmB5eF0RFBu01R2VojY0sBfGg/gu24BCM1Jk
         s6e5U8kY0ZejcwR9ywKexezued3hf9ZVkGe+suX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Nicolas Pitre <nico@linaro.org>,
        Anand Moon <linux.amoon@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 123/371] ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used
Date:   Thu, 16 Jan 2020 12:19:55 -0500
Message-Id: <20200116172403.18149-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index 2b913f17d50f..c24a55b0deac 100644
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
index 452bbdcbcc83..506314265c6f 100644
--- a/arch/arm/include/asm/suspend.h
+++ b/arch/arm/include/asm/suspend.h
@@ -10,6 +10,7 @@ struct sleep_save_sp {
 };
 
 extern void cpu_resume(void);
+extern void cpu_resume_no_hyp(void);
 extern void cpu_resume_arm(void);
 extern int cpu_suspend(unsigned long, int (*)(unsigned long));
 
diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index a8257fc9cf2a..5dc8b80bb693 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -120,6 +120,14 @@ ENDPROC(cpu_resume_after_mmu)
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
@@ -135,6 +143,7 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	bl	__hyp_stub_install_secondary
 #endif
 	safe_svcmode_maskall r1
+no_hyp:
 	mov	r1, #0
 	ALT_SMP(mrc p15, 0, r0, c0, c0, 5)
 	ALT_UP_B(1f)
@@ -163,6 +172,9 @@ ENDPROC(cpu_resume)
 
 #ifdef CONFIG_MMU
 ENDPROC(cpu_resume_arm)
+#endif
+#ifdef CONFIG_MCPM
+ENDPROC(cpu_resume_no_hyp)
 #endif
 
 	.align 2
-- 
2.20.1

