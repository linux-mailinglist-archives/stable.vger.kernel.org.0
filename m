Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B487031D3F
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfFAN1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfFAN1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9121726D2A;
        Sat,  1 Jun 2019 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395658;
        bh=RzVdEbcgR3gqdeLqYWaRHctpGJEk+NWbLFfeHvZL7Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNaalJd9UOGkzT4pkKfeSpb9J3GjaZRPmBZJlNPBbz1yyYus53xazU78xN7aB9ASc
         TMyIcgSh61Cx36SA65X2ybqDdJl01psYBfLJD3sDCR4pbdhXdgYDkuVP2VYhh+dDWQ
         lFhP7Oj5LdOVkcn0fK6jw3vj/nrYRLE0T9se3XZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 56/56] ARM: exynos: Fix undefined instruction during Exynos5422 resume
Date:   Sat,  1 Jun 2019 09:26:00 -0400
Message-Id: <20190601132600.27427-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 4d8e3e951a856777720272ce27f2c738a3eeef8c ]

During early system resume on Exynos5422 with performance counters enabled
the following kernel oops happens:

    Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP ARM
    Modules linked in:
    CPU: 0 PID: 1433 Comm: bash Tainted: G        W         5.0.0-rc5-next-20190208-00023-gd5fb5a8a13e6-dirty #5480
    Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
    ...
    Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment none
    Control: 10c5387d  Table: 4451006a  DAC: 00000051
    Process bash (pid: 1433, stack limit = 0xb7e0e22f)
    ...
    (reset_ctrl_regs) from [<c0112ad0>] (dbg_cpu_pm_notify+0x1c/0x24)
    (dbg_cpu_pm_notify) from [<c014c840>] (notifier_call_chain+0x44/0x84)
    (notifier_call_chain) from [<c014cbc0>] (__atomic_notifier_call_chain+0x7c/0x128)
    (__atomic_notifier_call_chain) from [<c01ffaac>] (cpu_pm_notify+0x30/0x54)
    (cpu_pm_notify) from [<c055116c>] (syscore_resume+0x98/0x3f4)
    (syscore_resume) from [<c0189350>] (suspend_devices_and_enter+0x97c/0xe74)
    (suspend_devices_and_enter) from [<c0189fb8>] (pm_suspend+0x770/0xc04)
    (pm_suspend) from [<c0187740>] (state_store+0x6c/0xcc)
    (state_store) from [<c09fa698>] (kobj_attr_store+0x14/0x20)
    (kobj_attr_store) from [<c030159c>] (sysfs_kf_write+0x4c/0x50)
    (sysfs_kf_write) from [<c0300620>] (kernfs_fop_write+0xfc/0x1e0)
    (kernfs_fop_write) from [<c0282be8>] (__vfs_write+0x2c/0x160)
    (__vfs_write) from [<c0282ea4>] (vfs_write+0xa4/0x16c)
    (vfs_write) from [<c0283080>] (ksys_write+0x40/0x8c)
    (ksys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)

Undefined instruction is triggered during CP14 reset, because bits: #16
(Secure privileged invasive debug disabled) and #17 (Secure privileged
noninvasive debug disable) are set in DSCR. Those bits depend on SPNIDEN
and SPIDEN lines, which are provided by Secure JTAG hardware block. That
block in turn is powered from cluster 0 (big/Eagle), but the Exynos5422
boots on cluster 1 (LITTLE/KFC).

To fix this issue it is enough to turn on the power on the cluster 0 for
a while. This lets the Secure JTAG block to propagate the needed signals
to LITTLE/KFC cores and change their DSCR.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-exynos/suspend.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index e8adb428dddb4..2b19695f5f35f 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -508,8 +508,27 @@ static void exynos3250_pm_resume(void)
 
 static void exynos5420_prepare_pm_resume(void)
 {
+	unsigned int mpidr, cluster;
+
+	mpidr = read_cpuid_mpidr();
+	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
+
 	if (IS_ENABLED(CONFIG_EXYNOS5420_MCPM))
 		WARN_ON(mcpm_cpu_powered_up());
+
+	if (IS_ENABLED(CONFIG_HW_PERF_EVENTS) && cluster != 0) {
+		/*
+		 * When system is resumed on the LITTLE/KFC core (cluster 1),
+		 * the DSCR is not properly updated until the power is turned
+		 * on also for the cluster 0. Enable it for a while to
+		 * propagate the SPNIDEN and SPIDEN signals from Secure JTAG
+		 * block and avoid undefined instruction issue on CP14 reset.
+		 */
+		pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+				EXYNOS_COMMON_CONFIGURATION(0));
+		pmu_raw_writel(0,
+				EXYNOS_COMMON_CONFIGURATION(0));
+	}
 }
 
 static void exynos5420_pm_resume(void)
-- 
2.20.1

