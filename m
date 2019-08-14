Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED68DB7F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfHNRZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfHNRFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCE42173B;
        Wed, 14 Aug 2019 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802332;
        bh=2HQjwaVMDMIgYTuzXW6A+YlByo/D1x2TfmII9Duz3NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clGseUUy2M8Zi8fzRiARJGG8BEHyRrCfnqQZDe6YCxJmTd1xEXZqopKxRg8NU9wQf
         0Jw/6u2sohyOmBbXkMil+0nLpyxGg19VoLaDrsdKNC5gBcFSy3Bu9YZ22ieRJELNsM
         GFwKvXqk7snlYqqo7bKI/PFjfE0kb3VDwxe2HLVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 084/144] arm64: entry: SP Alignment Fault doesnt write to FAR_EL1
Date:   Wed, 14 Aug 2019 19:00:40 +0200
Message-Id: <20190814165803.386114946@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



