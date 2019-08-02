Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AFB7F8A2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393537AbfHBNVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393531AbfHBNVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B5952173E;
        Fri,  2 Aug 2019 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752071;
        bh=gijZ38w2GHhnegH5FJ/NBBA0xopWh1T6sTAr9SKBQzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alemIp2yrPVhqs0Jy7y+VV896RVcHemiwGPGfflSjgeMF4rxDPRHTYYV9KUQntETC
         qYf7Kbf8BjMcGLMcwyFni4AEEFCU0mCuMuZQEThTJrDbZ7KxatszuMhyP6foAUGSYF
         1AlA5RxOUOx8Cy0G5qr7KOrZXiYSq78RVebcaKYc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 39/76] arm64: entry: SP Alignment Fault doesn't write to FAR_EL1
Date:   Fri,  2 Aug 2019 09:19:13 -0400
Message-Id: <20190802131951.11600-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 40ca0ce56d4bb889dc43b455c55398468115569a ]

Comparing the arm-arm's  pseudocode for AArch64.PCAlignmentFault() with
AArch64.SPAlignmentFault() shows that SP faults don't copy the faulty-SP
to FAR_EL1, but this is where we read from, and the address we provide
to user-space with the BUS_ADRALN signal.

For user-space this value will be UNKNOWN due to the previous ERET to
user-space. If the last value is preserved, on systems with KASLR or KPTI
this will be the user-space link-register left in FAR_EL1 by tramp_exit().
Fix this to retrieve the original sp_el0 value, and pass this to
do_sp_pc_fault().

SP alignment faults from EL1 will cause us to take the fault again when
trying to store the pt_regs. This eventually takes us to the overflow
stack. Remove the ESR_ELx_EC_SP_ALIGN check as we will never make it
this far.

Fixes: 60ffc30d5652 ("arm64: Exception handling")
Signed-off-by: James Morse <james.morse@arm.com>
[will: change label name and fleshed out comment]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 9cdc4592da3ef..320a30dbe35ef 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -586,10 +586,8 @@ el1_sync:
 	b.eq	el1_ia
 	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
 	b.eq	el1_undef
-	cmp	x24, #ESR_ELx_EC_SP_ALIGN	// stack alignment exception
-	b.eq	el1_sp_pc
 	cmp	x24, #ESR_ELx_EC_PC_ALIGN	// pc alignment exception
-	b.eq	el1_sp_pc
+	b.eq	el1_pc
 	cmp	x24, #ESR_ELx_EC_UNKNOWN	// unknown exception in EL1
 	b.eq	el1_undef
 	cmp	x24, #ESR_ELx_EC_BREAKPT_CUR	// debug exception in EL1
@@ -611,9 +609,11 @@ el1_da:
 	bl	do_mem_abort
 
 	kernel_exit 1
-el1_sp_pc:
+el1_pc:
 	/*
-	 * Stack or PC alignment exception handling
+	 * PC alignment exception handling. We don't handle SP alignment faults,
+	 * since we will have hit a recursive exception when trying to push the
+	 * initial pt_regs.
 	 */
 	mrs	x0, far_el1
 	inherit_daif	pstate=x23, tmp=x2
@@ -732,9 +732,9 @@ el0_sync:
 	ccmp	x24, #ESR_ELx_EC_WFx, #4, ne
 	b.eq	el0_sys
 	cmp	x24, #ESR_ELx_EC_SP_ALIGN	// stack alignment exception
-	b.eq	el0_sp_pc
+	b.eq	el0_sp
 	cmp	x24, #ESR_ELx_EC_PC_ALIGN	// pc alignment exception
-	b.eq	el0_sp_pc
+	b.eq	el0_pc
 	cmp	x24, #ESR_ELx_EC_UNKNOWN	// unknown exception in EL0
 	b.eq	el0_undef
 	cmp	x24, #ESR_ELx_EC_BREAKPT_LOW	// debug exception in EL0
@@ -758,7 +758,7 @@ el0_sync_compat:
 	cmp	x24, #ESR_ELx_EC_FP_EXC32	// FP/ASIMD exception
 	b.eq	el0_fpsimd_exc
 	cmp	x24, #ESR_ELx_EC_PC_ALIGN	// pc alignment exception
-	b.eq	el0_sp_pc
+	b.eq	el0_pc
 	cmp	x24, #ESR_ELx_EC_UNKNOWN	// unknown exception in EL0
 	b.eq	el0_undef
 	cmp	x24, #ESR_ELx_EC_CP15_32	// CP15 MRC/MCR trap
@@ -858,11 +858,15 @@ el0_fpsimd_exc:
 	mov	x1, sp
 	bl	do_fpsimd_exc
 	b	ret_to_user
+el0_sp:
+	ldr	x26, [sp, #S_SP]
+	b	el0_sp_pc
+el0_pc:
+	mrs	x26, far_el1
 el0_sp_pc:
 	/*
 	 * Stack or PC alignment exception handling
 	 */
-	mrs	x26, far_el1
 	gic_prio_kentry_setup tmp=x0
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
-- 
2.20.1

