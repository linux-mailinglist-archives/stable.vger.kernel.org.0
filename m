Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F9557ED6F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiGWJ5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbiGWJ44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC5C3FA0C;
        Sat, 23 Jul 2022 02:56:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0725611CD;
        Sat, 23 Jul 2022 09:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B865EC341C0;
        Sat, 23 Jul 2022 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570209;
        bh=A6uIYjf26dxGw4rLoh2QwKZAbV4FlEfHPIwrpmluWPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHAxwIr8d+A0p/XVYgjWfyf5BKuh0kU/UxWeOEDF7jeUGxsUKNzAPbeSoliEVWmbu
         nVkJ26mMLIuKCYOfJZSZbPLDKHk72u7mSAgys/o3rZm68h5eQ4FUEbzzwQqCeeQeTj
         xdtgqBFSIokFhB6Vox3UjmqkQi5MY/11JwG9xyhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 009/148] x86/xen: Support objtool validation in xen-asm.S
Date:   Sat, 23 Jul 2022 11:53:41 +0200
Message-Id: <20220723095227.051592198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit cde07a4e4434ddfb9b1616ac971edf6d66329804 upstream.

The OBJECT_FILES_NON_STANDARD annotation is used to tell objtool to
ignore a file.  File-level ignores won't work when validating vmlinux.o.

Tweak the ELF metadata and unwind hints to allow objtool to follow the
code.

Cc: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/8b042a09c69e8645f3b133ef6653ba28f896807d.1611263462.git.jpoimboe@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/Makefile  |    1 -
 arch/x86/xen/xen-asm.S |   29 +++++++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-OBJECT_FILES_NON_STANDARD_xen-asm.o := y
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -14,6 +14,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm.h>
 #include <asm/frame.h>
+#include <asm/unwind_hints.h>
 
 #include <xen/interface/xen.h>
 
@@ -147,6 +148,7 @@ SYM_FUNC_END(xen_read_cr2_direct);
 
 .macro xen_pv_trap name
 SYM_CODE_START(xen_\name)
+	UNWIND_HINT_EMPTY
 	pop %rcx
 	pop %r11
 	jmp  \name
@@ -186,6 +188,7 @@ xen_pv_trap asm_exc_xen_hypervisor_callb
 SYM_CODE_START(xen_early_idt_handler_array)
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
+	UNWIND_HINT_EMPTY
 	pop %rcx
 	pop %r11
 	jmp early_idt_handler_array + i*EARLY_IDT_HANDLER_SIZE
@@ -212,11 +215,13 @@ hypercall_iret = hypercall_page + __HYPE
  * rsp->rax		}
  */
 SYM_CODE_START(xen_iret)
+	UNWIND_HINT_EMPTY
 	pushq $0
 	jmp hypercall_iret
 SYM_CODE_END(xen_iret)
 
 SYM_CODE_START(xen_sysret64)
+	UNWIND_HINT_EMPTY
 	/*
 	 * We're already on the usermode stack at this point, but
 	 * still with the kernel gs, so we can easily switch back.
@@ -271,7 +276,8 @@ SYM_CODE_END(xenpv_restore_regs_and_retu
  */
 
 /* Normal 64-bit system call target */
-SYM_FUNC_START(xen_syscall_target)
+SYM_CODE_START(xen_syscall_target)
+	UNWIND_HINT_EMPTY
 	popq %rcx
 	popq %r11
 
@@ -284,12 +290,13 @@ SYM_FUNC_START(xen_syscall_target)
 	movq $__USER_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_64_after_hwframe
-SYM_FUNC_END(xen_syscall_target)
+SYM_CODE_END(xen_syscall_target)
 
 #ifdef CONFIG_IA32_EMULATION
 
 /* 32-bit compat syscall target */
-SYM_FUNC_START(xen_syscall32_target)
+SYM_CODE_START(xen_syscall32_target)
+	UNWIND_HINT_EMPTY
 	popq %rcx
 	popq %r11
 
@@ -302,10 +309,11 @@ SYM_FUNC_START(xen_syscall32_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSCALL_compat_after_hwframe
-SYM_FUNC_END(xen_syscall32_target)
+SYM_CODE_END(xen_syscall32_target)
 
 /* 32-bit compat sysenter target */
-SYM_FUNC_START(xen_sysenter_target)
+SYM_CODE_START(xen_sysenter_target)
+	UNWIND_HINT_EMPTY
 	/*
 	 * NB: Xen is polite and clears TF from EFLAGS for us.  This means
 	 * that we don't need to guard against single step exceptions here.
@@ -322,17 +330,18 @@ SYM_FUNC_START(xen_sysenter_target)
 	movq $__USER32_CS, 1*8(%rsp)
 
 	jmp entry_SYSENTER_compat_after_hwframe
-SYM_FUNC_END(xen_sysenter_target)
+SYM_CODE_END(xen_sysenter_target)
 
 #else /* !CONFIG_IA32_EMULATION */
 
-SYM_FUNC_START_ALIAS(xen_syscall32_target)
-SYM_FUNC_START(xen_sysenter_target)
+SYM_CODE_START(xen_syscall32_target)
+SYM_CODE_START(xen_sysenter_target)
+	UNWIND_HINT_EMPTY
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $0
 	jmp hypercall_iret
-SYM_FUNC_END(xen_sysenter_target)
-SYM_FUNC_END_ALIAS(xen_syscall32_target)
+SYM_CODE_END(xen_sysenter_target)
+SYM_CODE_END(xen_syscall32_target)
 
 #endif	/* CONFIG_IA32_EMULATION */


