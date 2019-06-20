Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10F94D89E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfFTSEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbfFTSEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE2B21479;
        Thu, 20 Jun 2019 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053863;
        bh=uw2YjC0mnEZxMDvsH/y76nxvmZ8uzs3CXmEfRZvTVU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrEcK0M3rVhMFXi5EKAf2mpBcCiDTZzzz0iuFTFCLorsrtWHMddLvDcUomtSH3wdx
         EwBL2rCwcjzlR3gCmvtHTodG7G0h7r/2YWGbpMaMlbIlput9PmgA0UJagG5t1MJZys
         8FXKDxRGjK8Cqz7Kbzijr4gotP3Onx7kfTUkt+Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/117] ARM: exynos: Fix undefined instruction during Exynos5422 resume
Date:   Thu, 20 Jun 2019 19:56:28 +0200
Message-Id: <20190620174355.718770692@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 81c935ce089b..b406c12077b9 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -500,8 +500,27 @@ early_wakeup:
 
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



