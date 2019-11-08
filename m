Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E86F541A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfKHSyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732817AbfKHSyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 942CF21D82;
        Fri,  8 Nov 2019 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239252;
        bh=KaPdoENFKDZhKN0bLX0NXcGlAkPXtgUsd+ywwP28seg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSmaTcw8pEQX42JmhJFJ9tnlMj5y+Ffs4qUPXSqxhR7kqLY1Y+gazHkvj5oUXMECg
         kCympkfWIp2HKugMsEfPSPHv66oVOaTlhHzEvn8vphnSNYCg3N8SmbjRdr1xqmleSD
         3dw1jQxM8EZEOwyKSe+P91VLNw2NxxT/Xdp2vsHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 52/75] ARM: spectre-v1: fix syscall entry
Date:   Fri,  8 Nov 2019 19:50:09 +0100
Message-Id: <20191108174755.241299241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 10573ae547c85b2c61417ff1a106cffbfceada35 upstream.

Prevent speculation at the syscall table decoding by clamping the index
used to zero on invalid system call numbers, and using the csdb
speculative barrier.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/entry-common.S |   18 +++++++-----------
 arch/arm/kernel/entry-header.S |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 11 deletions(-)

--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -223,9 +223,7 @@ local_restart:
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
 	bne	__sys_trace
 
-	cmp	scno, #NR_syscalls		@ check upper syscall limit
-	badr	lr, ret_fast_syscall		@ return address
-	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
+	invoke_syscall tbl, scno, r10, ret_fast_syscall
 
 	add	r1, sp, #S_OFF
 2:	cmp	scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
@@ -258,14 +256,8 @@ __sys_trace:
 	mov	r1, scno
 	add	r0, sp, #S_OFF
 	bl	syscall_trace_enter
-
-	badr	lr, __sys_trace_return		@ return address
-	mov	scno, r0			@ syscall number (possibly new)
-	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
-	cmp	scno, #NR_syscalls		@ check upper syscall limit
-	ldmccia	r1, {r0 - r6}			@ have to reload r0 - r6
-	stmccia	sp, {r4, r5}			@ and update the stack args
-	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
+	mov	scno, r0
+	invoke_syscall tbl, scno, r10, __sys_trace_return, reload=1
 	cmp	scno, #-1			@ skip the syscall?
 	bne	2b
 	add	sp, sp, #S_OFF			@ restore stack
@@ -317,6 +309,10 @@ sys_syscall:
 		bic	scno, r0, #__NR_OABI_SYSCALL_BASE
 		cmp	scno, #__NR_syscall - __NR_SYSCALL_BASE
 		cmpne	scno, #NR_syscalls	@ check range
+#ifdef CONFIG_CPU_SPECTRE
+		movhs	scno, #0
+		csdb
+#endif
 		stmloia	sp, {r5, r6}		@ shuffle args
 		movlo	r0, r1
 		movlo	r1, r2
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -373,6 +373,31 @@
 #endif
 	.endm
 
+	.macro	invoke_syscall, table, nr, tmp, ret, reload=0
+#ifdef CONFIG_CPU_SPECTRE
+	mov	\tmp, \nr
+	cmp	\tmp, #NR_syscalls		@ check upper syscall limit
+	movcs	\tmp, #0
+	csdb
+	badr	lr, \ret			@ return address
+	.if	\reload
+	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
+	ldmccia	r1, {r0 - r6}			@ reload r0-r6
+	stmccia	sp, {r4, r5}			@ update stack arguments
+	.endif
+	ldrcc	pc, [\table, \tmp, lsl #2]	@ call sys_* routine
+#else
+	cmp	\nr, #NR_syscalls		@ check upper syscall limit
+	badr	lr, \ret			@ return address
+	.if	\reload
+	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
+	ldmccia	r1, {r0 - r6}			@ reload r0-r6
+	stmccia	sp, {r4, r5}			@ update stack arguments
+	.endif
+	ldrcc	pc, [\table, \nr, lsl #2]	@ call sys_* routine
+#endif
+	.endm
+
 /*
  * These are the registers used in the syscall handler, and allow us to
  * have in theory up to 7 arguments to a function - r0 to r6.


