Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A54E9FF4
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfJ3PwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfJ3PwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:52:23 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D59B20656;
        Wed, 30 Oct 2019 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450742;
        bh=0d7wWg+diZb9HX31JDSpnY3FkUIPa/l/rQ1DGrZ1Jiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOD0CYKuLM3HMlWPcqzDo4dHx4/j4Va5Is74E1U9iI8I4TTvxhMJn05F2O1pUX6gp
         bK5pQdHMRTSPnlVp+V7r0Qp8mQe0Rm760fMK1qbpP7NamqKSxt/5si9XSPQvpLSJMV
         is5cx/fUx10q+lxG8GNL0GH0Xxy3h9vmsENFOhrM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 40/81] ARM: 8914/1: NOMMU: Fix exc_ret for XIP
Date:   Wed, 30 Oct 2019 11:48:46 -0400
Message-Id: <20191030154928.9432-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 4c0742f65b4ee466546fd24b71b56516cacd4613 ]

It was reported that 72cd4064fcca "NOMMU: Toggle only bits in
EXC_RETURN we are really care of" breaks NOMMU+XIP combination.
It happens because saved EXC_RETURN gets overwritten when data
section is relocated.

The fix is to propagate EXC_RETURN via register and let relocation
code to commit that value into memory.

Fixes: 72cd4064fcca ("ARM: 8830/1: NOMMU: Toggle only bits in EXC_RETURN we are really care of")
Reported-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Tested-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head-common.S | 5 +++--
 arch/arm/kernel/head-nommu.S  | 2 ++
 arch/arm/mm/proc-v7m.S        | 5 ++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index a7810be07da1c..4a3982812a401 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -68,7 +68,7 @@ ENDPROC(__vet_atags)
  * The following fragment of code is executed with the MMU on in MMU mode,
  * and uses absolute addresses; this is not position independent.
  *
- *  r0  = cp#15 control register
+ *  r0  = cp#15 control register (exc_ret for M-class)
  *  r1  = machine ID
  *  r2  = atags/dtb pointer
  *  r9  = processor ID
@@ -137,7 +137,8 @@ __mmap_switched_data:
 #ifdef CONFIG_CPU_CP15
 	.long	cr_alignment			@ r3
 #else
-	.long	0				@ r3
+M_CLASS(.long	exc_ret)			@ r3
+AR_CLASS(.long	0)				@ r3
 #endif
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index afa350f44dea3..0fc814bbc34b1 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -201,6 +201,8 @@ M_CLASS(streq	r3, [r12, #PMSAv8_MAIR1])
 	bic	r0, r0, #V7M_SCB_CCR_IC
 #endif
 	str	r0, [r12, V7M_SCB_CCR]
+	/* Pass exc_ret to __mmap_switched */
+	mov	r0, r10
 #endif /* CONFIG_CPU_CP15 elif CONFIG_CPU_V7M */
 	ret	lr
 ENDPROC(__after_proc_init)
diff --git a/arch/arm/mm/proc-v7m.S b/arch/arm/mm/proc-v7m.S
index 1448f144e7fb9..efebf4120a0c4 100644
--- a/arch/arm/mm/proc-v7m.S
+++ b/arch/arm/mm/proc-v7m.S
@@ -136,9 +136,8 @@ __v7m_setup_cont:
 	cpsie	i
 	svc	#0
 1:	cpsid	i
-	ldr	r0, =exc_ret
-	orr	lr, lr, #EXC_RET_THREADMODE_PROCESSSTACK
-	str	lr, [r0]
+	/* Calculate exc_ret */
+	orr	r10, lr, #EXC_RET_THREADMODE_PROCESSSTACK
 	ldmia	sp, {r0-r3, r12}
 	str	r5, [r12, #11 * 4]	@ restore the original SVC vector entry
 	mov	lr, r6			@ restore LR
-- 
2.20.1

