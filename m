Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66710EA0D9
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfJ3Py6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbfJ3Py6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:58 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FD520656;
        Wed, 30 Oct 2019 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450897;
        bh=yyDxAlgn41+7DL22CfifjWjYAq8KV40/xCcwkHyz6u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcdG5B2vH/zGD3Xb/VtB2Ci62RYN42WHb7xtK0NQ7xjoxTW9+OA2eudoYDxSmjIZ7
         clUlCmQUYMWvSfePb6Gb6yCJ8euLTZ7d2pl1f9JxN/towBYHGvrANGYgcLVsrp1XhS
         qUUMSn9/LzYZm7xxytACkiqVA2E7gUrvFnnDRjow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 18/38] ARM: 8914/1: NOMMU: Fix exc_ret for XIP
Date:   Wed, 30 Oct 2019 11:53:46 -0400
Message-Id: <20191030155406.10109-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
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
index 997b02302c314..9328f2010bc19 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -72,7 +72,7 @@ ENDPROC(__vet_atags)
  * The following fragment of code is executed with the MMU on in MMU mode,
  * and uses absolute addresses; this is not position independent.
  *
- *  r0  = cp#15 control register
+ *  r0  = cp#15 control register (exc_ret for M-class)
  *  r1  = machine ID
  *  r2  = atags/dtb pointer
  *  r9  = processor ID
@@ -141,7 +141,8 @@ __mmap_switched_data:
 #ifdef CONFIG_CPU_CP15
 	.long	cr_alignment			@ r3
 #else
-	.long	0				@ r3
+M_CLASS(.long	exc_ret)			@ r3
+AR_CLASS(.long	0)				@ r3
 #endif
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index cab89479d15ef..326a97aa3ea0c 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -205,6 +205,8 @@ M_CLASS(streq	r3, [r12, #PMSAv8_MAIR1])
 	bic	r0, r0, #V7M_SCB_CCR_IC
 #endif
 	str	r0, [r12, V7M_SCB_CCR]
+	/* Pass exc_ret to __mmap_switched */
+	mov	r0, r10
 #endif /* CONFIG_CPU_CP15 elif CONFIG_CPU_V7M */
 	ret	lr
 ENDPROC(__after_proc_init)
diff --git a/arch/arm/mm/proc-v7m.S b/arch/arm/mm/proc-v7m.S
index 92e84181933ad..59d82864c134b 100644
--- a/arch/arm/mm/proc-v7m.S
+++ b/arch/arm/mm/proc-v7m.S
@@ -139,9 +139,8 @@ __v7m_setup_cont:
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

