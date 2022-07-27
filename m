Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2967582EE1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiG0RSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234942AbiG0RR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2268B7969C;
        Wed, 27 Jul 2022 09:43:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A87E1601C0;
        Wed, 27 Jul 2022 16:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5324C433B5;
        Wed, 27 Jul 2022 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940217;
        bh=Wb98pt5vbxzdyRZeVuY7M2SeMywrValO8GqXhGqdCnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzXDZLB20+/82n6gHRx3h6RvIGZ/wCJtDu3guT8/jqbXNyatPmJhFSAgmI5vDh2S1
         JAxdyg/AH3n7rv/50koem9rKEtj57ENUh5daGJBdwV+BqAVv880gLrh6FgKaabpxcw
         /L+pZR0ZJ3G60OOX0NVKCgI/ou7onjCKGzHtpEds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/201] x86/entry_32: Remove .fixup usage
Date:   Wed, 27 Jul 2022 18:10:51 +0200
Message-Id: <20220727161033.918279310@linuxfoundation.org>
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

[ Upstream commit aa93e2ad7464ffb90155a5ffdde963816f86d5dc ]

Where possible, push the .fixup into code, at the tail of functions.

This is hard for macros since they're used in multiple functions,
therefore introduce a new extable handler to pop zeros.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20211110101325.245184699@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_32.S                  | 28 +++++++---------------
 arch/x86/include/asm/extable_fixup_types.h |  2 ++
 arch/x86/mm/extable.c                      | 14 +++++++++++
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 5bd3baf36d87..2cba70f9753b 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -270,17 +270,9 @@
 3:	popl	%fs
 	addl	$(4 + \pop), %esp	/* pop the unused "gs" slot */
 	IRET_FRAME
-.pushsection .fixup, "ax"
-4:	movl	$0, (%esp)
-	jmp	1b
-5:	movl	$0, (%esp)
-	jmp	2b
-6:	movl	$0, (%esp)
-	jmp	3b
-.popsection
-	_ASM_EXTABLE(1b, 4b)
-	_ASM_EXTABLE(2b, 5b)
-	_ASM_EXTABLE(3b, 6b)
+	_ASM_EXTABLE_TYPE(1b, 1b, EX_TYPE_POP_ZERO)
+	_ASM_EXTABLE_TYPE(2b, 2b, EX_TYPE_POP_ZERO)
+	_ASM_EXTABLE_TYPE(3b, 3b, EX_TYPE_POP_ZERO)
 .endm
 
 .macro RESTORE_ALL_NMI cr3_reg:req pop=0
@@ -923,10 +915,8 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	sti
 	sysexit
 
-.pushsection .fixup, "ax"
-2:	movl	$0, PT_FS(%esp)
-	jmp	1b
-.popsection
+2:	movl    $0, PT_FS(%esp)
+	jmp     1b
 	_ASM_EXTABLE(1b, 2b)
 
 .Lsysenter_fix_flags:
@@ -994,8 +984,7 @@ restore_all_switch_stack:
 	 */
 	iret
 
-.section .fixup, "ax"
-SYM_CODE_START(asm_iret_error)
+.Lasm_iret_error:
 	pushl	$0				# no error code
 	pushl	$iret_error
 
@@ -1012,9 +1001,8 @@ SYM_CODE_START(asm_iret_error)
 #endif
 
 	jmp	handle_exception
-SYM_CODE_END(asm_iret_error)
-.previous
-	_ASM_EXTABLE(.Lirq_return, asm_iret_error)
+
+	_ASM_EXTABLE(.Lirq_return, .Lasm_iret_error)
 SYM_FUNC_END(entry_INT80_32)
 
 .macro FIXUP_ESPFIX_STACK
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
index 409524d5d2eb..4d709a2768bb 100644
--- a/arch/x86/include/asm/extable_fixup_types.h
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -19,4 +19,6 @@
 #define	EX_TYPE_DEFAULT_MCE_SAFE	12
 #define	EX_TYPE_FAULT_MCE_SAFE		13
 
+#define	EX_TYPE_POP_ZERO		14
+
 #endif
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index f37e290e6d0a..f59a4d017070 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -99,6 +99,18 @@ static bool ex_handler_clear_fs(const struct exception_table_entry *fixup,
 	return ex_handler_default(fixup, regs);
 }
 
+static bool ex_handler_pop_zero(const struct exception_table_entry *fixup,
+				struct pt_regs *regs)
+{
+	/*
+	 * Typically used for when "pop %seg" traps, in which case we'll clear
+	 * the stack slot and re-try the instruction, which will then succeed
+	 * to pop zero.
+	 */
+	*((unsigned long *)regs->sp) = 0;
+	return ex_handler_default(fixup, regs);
+}
+
 int ex_get_fixup_type(unsigned long ip)
 {
 	const struct exception_table_entry *e = search_exception_tables(ip);
@@ -156,6 +168,8 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	case EX_TYPE_WRMSR_IN_MCE:
 		ex_handler_msr_mce(regs, true);
 		break;
+	case EX_TYPE_POP_ZERO:
+		return ex_handler_pop_zero(e, regs);
 	}
 	BUG();
 }
-- 
2.35.1



