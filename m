Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E959111F0D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfLCWsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbfLCWsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E820520656;
        Tue,  3 Dec 2019 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413291;
        bh=o2FPNobaFbaYlgZPd/1WGtshSJiIG2vt/ILAAxZwP+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tfy8nwHWFkYU829p8yR3L9sF2T4AVv3kD5GfUs5eekcT3CjRwKbpSAkpCqasHOjDl
         I6MyVgYyywDDwJoSBVVmNAQFwBxvyJn0Ogh72zu0E23RcIFB/kJN7rRV9jXee8egXY
         JJAeiRnXYbnAQhopyhlPmHYP7UIz/fL1NV89oHJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/321] arm64: mm: Prevent mismatched 52-bit VA support
Date:   Tue,  3 Dec 2019 23:32:17 +0100
Message-Id: <20191203223430.859163803@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 77ca59598c8b1..06058fba5f86c 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -703,6 +703,7 @@ secondary_startup:
 	/*
 	 * Common entry point for secondary CPUs.
 	 */
+	bl	__cpu_secondary_check52bitva
 	bl	__cpu_setup			// initialise processor
 	bl	__enable_mmu
 	ldr	x8, =__secondary_switched
@@ -779,6 +780,31 @@ ENTRY(__enable_mmu)
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
index 25fcd22a4bb24..2c31d65bc541b 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -108,6 +108,7 @@ static int boot_secondary(unsigned int cpu, struct task_struct *idle)
 }
 
 static DECLARE_COMPLETION(cpu_running);
+bool va52mismatch __ro_after_init;
 
 int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
@@ -137,6 +138,10 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 
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



