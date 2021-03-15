Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0F033C9D7
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhCOXUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhCOXT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 19:19:56 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC8C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 16:19:56 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id k68so25542676qke.2
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 16:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F6nYO3V+VuZGXayaevZL3OZZ8YDIZPahFyJ6m7t3CHo=;
        b=S1gNE/gl4uAg7JNLM/T0YGL0HhIGLSPihN/Ae5PTIPY0TGJG5fPY3YM1t18jhxxmq8
         j+knKG6QVF6CcyMjK/1XWPKfet0orPbcio06eRYgFE3G+NKBXWyw5iaVOdwtvpw8WGfw
         lB3piYMKYsdsZ31QWiRog1uEUzozm7VgvgU7EDW3CSPSrX4PA3ZFroVOg8Ds2XEMsRCr
         /LJdHk6yEJ2xsl5K8cIAwE0kKbq5BTbEQojDI9Olrk86RXyHIs+nF7yf8L9SNn+hM69A
         v0HOocsKPJ7l3WpV3MksG5X7JC6gI9gNi7fEcN9hgoky/FGmy10nOtH29mcRkt2CqnAe
         EbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F6nYO3V+VuZGXayaevZL3OZZ8YDIZPahFyJ6m7t3CHo=;
        b=dWR8S2di6LR0xTfBUnJgzEDRSCN7aOcBuTW8qgqDPiTaivfvsLvTyrQ7kR78VuBAPT
         80c8ENmNBInCRx4W5mtzgCuEdNbzzEFuKYD9zKeW8siRFVHWa8zV+/gwpO2O8pF63DBQ
         CTYFiJ4ujvzwA3LVERG39LUYzDmcwkqnn5nAkMsaDRi7QBgXTlXV0/1CWjGbmAGEz69h
         Buj3e+JsIyLJWRBtyIph1G7sCiysvJqLPph28zxeWiSfMJgxZwax5L25zYgb9+1Y9p4V
         IPxguZz58ywrfKBgSSYrMZEXNQvH0+gcQ/Z0hFqdAwq2zPcb5pVBg/+w9dSWrmKGTPFD
         yvVg==
X-Gm-Message-State: AOAM533y757mafiCjLxrwG/xu5S7OA6yztugAXFDEN/CBS4X6vTZsUF1
        yiaNiAubQh9se1AmxZt6/5O28EyfXwyDDRzT9ZM=
X-Google-Smtp-Source: ABdhPJxUbFRQhiM7/KqR4qlXFPdy/7CWDUh5bxbe8a79nZU/rAqy0HH/b6atCVSottt27g4UJ96Kct4PfaSzul4NbmM=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:5a8:abe7:9948:175e])
 (user=ndesaulniers job=sendgmr) by 2002:ad4:50c7:: with SMTP id
 e7mr13169796qvq.58.1615850395286; Mon, 15 Mar 2021 16:19:55 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:19:52 -0700
In-Reply-To: <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
Message-Id: <20210315231952.1482097-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAKwvOdm6FXWVu-9YkQNNyoYmw+hkj1a7MQrRbWyUxsO2vDcnQA@mail.gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 5.4.y] ARM: 9030/1: entry: omit FP emulation for UND
 exceptions taken in kernel mode
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     gregkh@linuxfoundation.org, ardb@kernel.org
Cc:     candle.sun@unisoc.com, catalin.marinas@arm.com,
        clang-built-linux@googlegroups.com, jiancai@google.com,
        llozano@google.com, maz@kernel.org, miles.chen@mediatek.com,
        samitolvanen@google.com, sashal@kernel.org, srhines@google.com,
        sspatil@google.com, stable@vger.kernel.org, stefan@agner.ch,
        Dmitry Osipenko <digetx@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit f77ac2e378be9dd61eb88728f0840642f045d9d1 upstream.

There are a couple of problems with the exception entry code that deals
with FP exceptions (which are reported as UND exceptions) when building
the kernel in Thumb2 mode:
- the conditional branch to vfp_kmode_exception in vfp_support_entry()
  may be out of range for its target, depending on how the linker decides
  to arrange the sections;
- when the UND exception is taken in kernel mode, the emulation handling
  logic is entered via the 'call_fpe' label, which means we end up using
  the wrong value/mask pairs to match and detect the NEON opcodes.

Since UND exceptions in kernel mode are unlikely to occur on a hot path
(as opposed to the user mode version which is invoked for VFP support
code and lazy restore), we can use the existing undef hook machinery for
any kernel mode instruction emulation that is needed, including calling
the existing vfp_kmode_exception() routine for unexpected cases. So drop
the call to call_fpe, and instead, install an undef hook that will get
called for NEON and VFP instructions that trigger an UND exception in
kernel mode.

While at it, make sure that the PC correction is accurate for the
execution mode where the exception was taken, by checking the PSR
Thumb bit.

Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Fixes: eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[nd: fix conflict in arch/arm/vfp/vfphw.S due to missing
     commit 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if
     available")]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
This should have been sent along with
https://lore.kernel.org/stable/20210113185758.GA571703@ubuntu-m3-large-x86/
it's my fault I missed it.

 arch/arm/kernel/entry-armv.S | 25 ++----------------
 arch/arm/vfp/vfphw.S         |  5 ----
 arch/arm/vfp/vfpmodule.c     | 49 ++++++++++++++++++++++++++++++++++--
 3 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a874b753397e..b62d74a2c73a 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -252,31 +252,10 @@ __und_svc:
 #else
 	svc_entry
 #endif
-	@
-	@ call emulation code, which returns using r9 if it has emulated
-	@ the instruction, or the more conventional lr if we are to treat
-	@ this as a real undefined instruction
-	@
-	@  r0 - instruction
-	@
-#ifndef CONFIG_THUMB2_KERNEL
-	ldr	r0, [r4, #-4]
-#else
-	mov	r1, #2
-	ldrh	r0, [r4, #-2]			@ Thumb instruction at LR - 2
-	cmp	r0, #0xe800			@ 32-bit instruction if xx >= 0
-	blo	__und_svc_fault
-	ldrh	r9, [r4]			@ bottom 16 bits
-	add	r4, r4, #2
-	str	r4, [sp, #S_PC]
-	orr	r0, r9, r0, lsl #16
-#endif
-	badr	r9, __und_svc_finish
-	mov	r2, r4
-	bl	call_fpe
 
 	mov	r1, #4				@ PC correction to apply
-__und_svc_fault:
+ THUMB(	tst	r5, #PSR_T_BIT		)	@ exception taken in Thumb mode?
+ THUMB(	movne	r1, #2			)	@ if so, fix up PC correction
 	mov	r0, sp				@ struct pt_regs *regs
 	bl	__und_fault
 
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index b2e560290860..b530db8f2c6c 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -78,11 +78,6 @@
 ENTRY(vfp_support_entry)
 	DBGSTR3	"instr %08x pc %08x state %p", r0, r2, r10
 
-	ldr	r3, [sp, #S_PSR]	@ Neither lazy restore nor FP exceptions
-	and	r3, r3, #MODE_MASK	@ are supported in kernel mode
-	teq	r3, #USR_MODE
-	bne	vfp_kmode_exception	@ Returns through lr
-
 	VFPFMRX	r1, FPEXC		@ Is the VFP enabled?
 	DBGSTR1	"fpexc %08x", r1
 	tst	r1, #FPEXC_EN
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8c9e7f9f0277..c3b6451c18bd 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -23,6 +23,7 @@
 #include <asm/cputype.h>
 #include <asm/system_info.h>
 #include <asm/thread_notify.h>
+#include <asm/traps.h>
 #include <asm/vfp.h>
 
 #include "vfpinstr.h"
@@ -642,7 +643,9 @@ static int vfp_starting_cpu(unsigned int unused)
 	return 0;
 }
 
-void vfp_kmode_exception(void)
+#ifdef CONFIG_KERNEL_MODE_NEON
+
+static int vfp_kmode_exception(struct pt_regs *regs, unsigned int instr)
 {
 	/*
 	 * If we reach this point, a floating point exception has been raised
@@ -660,9 +663,51 @@ void vfp_kmode_exception(void)
 		pr_crit("BUG: unsupported FP instruction in kernel mode\n");
 	else
 		pr_crit("BUG: FP instruction issued in kernel mode with FP unit disabled\n");
+	pr_crit("FPEXC == 0x%08x\n", fmrx(FPEXC));
+	return 1;
 }
 
-#ifdef CONFIG_KERNEL_MODE_NEON
+static struct undef_hook vfp_kmode_exception_hook[] = {{
+	.instr_mask	= 0xfe000000,
+	.instr_val	= 0xf2000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xff100000,
+	.instr_val	= 0xf4000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xef000000,
+	.instr_val	= 0xef000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE | PSR_T_BIT,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0xff100000,
+	.instr_val	= 0xf9000000,
+	.cpsr_mask	= MODE_MASK | PSR_T_BIT,
+	.cpsr_val	= SVC_MODE | PSR_T_BIT,
+	.fn		= vfp_kmode_exception,
+}, {
+	.instr_mask	= 0x0c000e00,
+	.instr_val	= 0x0c000a00,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= SVC_MODE,
+	.fn		= vfp_kmode_exception,
+}};
+
+static int __init vfp_kmode_exception_hook_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vfp_kmode_exception_hook); i++)
+		register_undef_hook(&vfp_kmode_exception_hook[i]);
+	return 0;
+}
+core_initcall(vfp_kmode_exception_hook_init);
 
 /*
  * Kernel-side NEON support functions
-- 
2.31.0.rc2.261.g7f71774620-goog

