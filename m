Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B27582F72
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242092AbiG0RZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242332AbiG0RYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8097C7D1E2;
        Wed, 27 Jul 2022 09:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 246AAB8200C;
        Wed, 27 Jul 2022 16:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878EFC433D6;
        Wed, 27 Jul 2022 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940374;
        bh=wNjRyq7KpwfqI2CRIrmBaDbajqCGVlD03RMmAjecJuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcfGaEdZBeBM9ANRFJc9QirKQMp1kbT+7Wx1XGh0ocBAWYMG5YK4ZJ7fKbHVaw2n0
         YtNbtarYOVFS6zdmsHTzor9IpOPOb+nwo91lTZ/a17JDUbc4kaLP/Bxn1PymIFhebB
         xGWD9hefAXcH33JKBnBDb8AMGjWz6MGxENRwXhnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 201/201] x86/entry_32: Fix segment exceptions
Date:   Wed, 27 Jul 2022 18:11:45 +0200
Message-Id: <20220727161036.135965948@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 9cdbeec4096804083944d05da96bbaf59a1eb4f9 upstream.

The LKP robot reported that commit in Fixes: caused a failure. Turns out
the ldt_gdt_32 selftest turns into an infinite loop trying to clear the
segment.

As discovered by Sean, what happens is that PARANOID_EXIT_TO_KERNEL_MODE
in the handle_exception_return path overwrites the entry stack data with
the task stack data, restoring the "bad" segment value.

Instead of having the exception retry the instruction, have it emulate
the full instruction. Replace EX_TYPE_POP_ZERO with EX_TYPE_POP_REG
which will do the equivalent of: POP %reg; MOV $imm, %reg.

In order to encode the segment registers, add them as registers 8-11 for
32-bit.

By setting regs->[defg]s the (nested) RESTORE_REGS will pop this value
at the end of the exception handler and by increasing regs->sp, it will
have skipped the stack slot.

This was debugged by Sean Christopherson <seanjc@google.com>.

 [ bp: Add EX_REG_GS too. ]

Fixes: aa93e2ad7464 ("x86/entry_32: Remove .fixup usage")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/Yd1l0gInc4zRcnt/@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S                  |   13 +++++++++----
 arch/x86/include/asm/extable_fixup_types.h |   11 ++++++++++-
 arch/x86/lib/insn-eval.c                   |    5 +++++
 arch/x86/mm/extable.c                      |   17 +++--------------
 4 files changed, 27 insertions(+), 19 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -268,11 +268,16 @@
 1:	popl	%ds
 2:	popl	%es
 3:	popl	%fs
-	addl	$(4 + \pop), %esp	/* pop the unused "gs" slot */
+4:	addl	$(4 + \pop), %esp	/* pop the unused "gs" slot */
 	IRET_FRAME
-	_ASM_EXTABLE_TYPE(1b, 1b, EX_TYPE_POP_ZERO)
-	_ASM_EXTABLE_TYPE(2b, 2b, EX_TYPE_POP_ZERO)
-	_ASM_EXTABLE_TYPE(3b, 3b, EX_TYPE_POP_ZERO)
+
+	/*
+	 * There is no _ASM_EXTABLE_TYPE_REG() for ASM, however since this is
+	 * ASM the registers are known and we can trivially hard-code them.
+	 */
+	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_POP_ZERO|EX_REG_DS)
+	_ASM_EXTABLE_TYPE(2b, 3b, EX_TYPE_POP_ZERO|EX_REG_ES)
+	_ASM_EXTABLE_TYPE(3b, 4b, EX_TYPE_POP_ZERO|EX_REG_FS)
 .endm
 
 .macro RESTORE_ALL_NMI cr3_reg:req pop=0
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -16,9 +16,16 @@
 #define EX_DATA_FLAG_SHIFT		12
 #define EX_DATA_IMM_SHIFT		16
 
+#define EX_DATA_REG(reg)		((reg) << EX_DATA_REG_SHIFT)
 #define EX_DATA_FLAG(flag)		((flag) << EX_DATA_FLAG_SHIFT)
 #define EX_DATA_IMM(imm)		((imm) << EX_DATA_IMM_SHIFT)
 
+/* segment regs */
+#define EX_REG_DS			EX_DATA_REG(8)
+#define EX_REG_ES			EX_DATA_REG(9)
+#define EX_REG_FS			EX_DATA_REG(10)
+#define EX_REG_GS			EX_DATA_REG(11)
+
 /* flags */
 #define EX_FLAG_CLEAR_AX		EX_DATA_FLAG(1)
 #define EX_FLAG_CLEAR_DX		EX_DATA_FLAG(2)
@@ -41,7 +48,9 @@
 #define	EX_TYPE_RDMSR_IN_MCE		13
 #define	EX_TYPE_DEFAULT_MCE_SAFE	14
 #define	EX_TYPE_FAULT_MCE_SAFE		15
-#define	EX_TYPE_POP_ZERO		16
+
+#define	EX_TYPE_POP_REG			16 /* sp += sizeof(long) */
+#define EX_TYPE_POP_ZERO		(EX_TYPE_POP_REG | EX_DATA_IMM(0))
 
 #define	EX_TYPE_IMM_REG			17 /* reg := (long)imm */
 #define	EX_TYPE_EFAULT_REG		(EX_TYPE_IMM_REG | EX_DATA_IMM(-EFAULT))
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -430,6 +430,11 @@ static const int pt_regoff[] = {
 	offsetof(struct pt_regs, r13),
 	offsetof(struct pt_regs, r14),
 	offsetof(struct pt_regs, r15),
+#else
+	offsetof(struct pt_regs, ds),
+	offsetof(struct pt_regs, es),
+	offsetof(struct pt_regs, fs),
+	offsetof(struct pt_regs, gs),
 #endif
 };
 
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -118,18 +118,6 @@ static bool ex_handler_clear_fs(const st
 	return ex_handler_default(fixup, regs);
 }
 
-static bool ex_handler_pop_zero(const struct exception_table_entry *fixup,
-				struct pt_regs *regs)
-{
-	/*
-	 * Typically used for when "pop %seg" traps, in which case we'll clear
-	 * the stack slot and re-try the instruction, which will then succeed
-	 * to pop zero.
-	 */
-	*((unsigned long *)regs->sp) = 0;
-	return ex_handler_default(fixup, regs);
-}
-
 static bool ex_handler_imm_reg(const struct exception_table_entry *fixup,
 			       struct pt_regs *regs, int reg, int imm)
 {
@@ -203,8 +191,9 @@ int fixup_exception(struct pt_regs *regs
 	case EX_TYPE_RDMSR_IN_MCE:
 		ex_handler_msr_mce(regs, false);
 		break;
-	case EX_TYPE_POP_ZERO:
-		return ex_handler_pop_zero(e, regs);
+	case EX_TYPE_POP_REG:
+		regs->sp += sizeof(long);
+		fallthrough;
 	case EX_TYPE_IMM_REG:
 		return ex_handler_imm_reg(e, regs, reg, imm);
 	}


