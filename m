Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1874DA24D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351032AbiCOSZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351021AbiCOSZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:25:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AF7F2983D
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4B381516;
        Tue, 15 Mar 2022 11:24:38 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44F803F73D;
        Tue, 15 Mar 2022 11:24:38 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 07/22] arm64: entry: Free up another register on kpti's tramp_exit path
Date:   Tue, 15 Mar 2022 18:24:00 +0000
Message-Id: <20220315182415.3900464-8-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315182415.3900464-1-james.morse@arm.com>
References: <20220315182415.3900464-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 03aff3a77a58b5b52a77e00537a42090ad57b80b upstream.

Kpti stashes x30 in far_el1 while it uses x30 for all its work.

Making the vectors a per-cpu data structure will require a second
register.

Allow tramp_exit two registers before it unmaps the kernel, by
leaving x30 on the stack, and stashing x29 in far_el1.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a6dcd68ce7de..7e52b6991bf1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -367,14 +367,16 @@ alternative_else_nop_endif
 	ldp	x24, x25, [sp, #16 * 12]
 	ldp	x26, x27, [sp, #16 * 13]
 	ldp	x28, x29, [sp, #16 * 14]
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #S_FRAME_SIZE		// restore sp
 
 	.if	\el == 0
-alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
+	eret
+alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	5f
-	msr	far_el1, x30
+	msr	far_el1, x29
 	tramp_alias	x30, tramp_exit_native
 	br	x30
 5:
@@ -382,6 +384,8 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	br	x30
 #endif
 	.else
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	.endif
 	sb
@@ -1092,10 +1096,12 @@ alternative_else_nop_endif
 	.macro tramp_exit, regsize = 64
 	adr	x30, tramp_vectors
 	msr	vbar_el1, x30
-	tramp_unmap_kernel	x30
+	ldr	lr, [sp, #S_LR]
+	tramp_unmap_kernel	x29
 	.if	\regsize == 64
-	mrs	x30, far_el1
+	mrs	x29, far_el1
 	.endif
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	sb
 	.endm
-- 
2.30.2

