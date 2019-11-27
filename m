Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177AE10BB37
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbfK0VKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbfK0VKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444CF2176D;
        Wed, 27 Nov 2019 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889037;
        bh=JdTkV7/44ucTxykzjuJkfEkDyJYwgFjz7gDeCoZMK9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvkzFqjexPN92jZ7MngfKEblvs/1PBEjzwlPzIquk+kqae1YlN3PstZSuHXBdwkXa
         Ic806my3gdIor/HXZMHK+nKMgTi7X26Ervz47JlSEGluZUZ+h9Kv/VBqwrU1btsb4J
         xZYsLWeXMjr5Y7c5EUqRDYs+utSxYoUhelZ+q1QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.3 60/95] x86/entry/32: Unwind the ESPFIX stack earlier on exception entry
Date:   Wed, 27 Nov 2019 21:32:17 +0100
Message-Id: <20191127202927.235334004@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit a1a338e5b6fe9e0a39c57c232dc96c198bb53e47 upstream.

Right now, we do some fancy parts of the exception entry path while SS
might have a nonzero base: we fill in regs->ss and regs->sp, and we
consider switching to the kernel stack. This results in regs->ss and
regs->sp referring to a non-flat stack and it may result in
overflowing the entry stack. The former issue means that we can try to
call iret_exc on a non-flat stack, which doesn't work.

Tested with selftests/x86/sigreturn_32.

Fixes: 45d7b255747c ("x86/entry/32: Enter the kernel via trampoline stack")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -210,8 +210,6 @@
 	/*
 	 * The high bits of the CS dword (__csh) are used for CS_FROM_*.
 	 * Clear them in case hardware didn't do this for us.
-	 *
-	 * Be careful: we may have nonzero SS base due to ESPFIX.
 	 */
 	andl	$0x0000ffff, 4*4(%esp)
 
@@ -307,12 +305,21 @@
 .Lfinished_frame_\@:
 .endm
 
-.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0 skip_gs=0
+.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0 skip_gs=0 unwind_espfix=0
 	cld
 .if \skip_gs == 0
 	PUSH_GS
 .endif
 	pushl	%fs
+
+	pushl	%eax
+	movl	$(__KERNEL_PERCPU), %eax
+	movl	%eax, %fs
+.if \unwind_espfix > 0
+	UNWIND_ESPFIX_STACK
+.endif
+	popl	%eax
+
 	FIXUP_FRAME
 	pushl	%es
 	pushl	%ds
@@ -326,8 +333,6 @@
 	movl	$(__USER_DS), %edx
 	movl	%edx, %ds
 	movl	%edx, %es
-	movl	$(__KERNEL_PERCPU), %edx
-	movl	%edx, %fs
 .if \skip_gs == 0
 	SET_KERNEL_GS %edx
 .endif
@@ -1153,18 +1158,17 @@ ENDPROC(entry_INT80_32)
 	lss	(%esp), %esp			/* switch to the normal stack segment */
 #endif
 .endm
+
 .macro UNWIND_ESPFIX_STACK
+	/* It's safe to clobber %eax, all other regs need to be preserved */
 #ifdef CONFIG_X86_ESPFIX32
 	movl	%ss, %eax
 	/* see if on espfix stack */
 	cmpw	$__ESPFIX_SS, %ax
-	jne	27f
-	movl	$__KERNEL_DS, %eax
-	movl	%eax, %ds
-	movl	%eax, %es
+	jne	.Lno_fixup_\@
 	/* switch to normal stack */
 	FIXUP_ESPFIX_STACK
-27:
+.Lno_fixup_\@:
 #endif
 .endm
 
@@ -1458,10 +1462,9 @@ END(page_fault)
 
 common_exception_read_cr2:
 	/* the function address is in %gs's slot on the stack */
-	SAVE_ALL switch_stacks=1 skip_gs=1
+	SAVE_ALL switch_stacks=1 skip_gs=1 unwind_espfix=1
 
 	ENCODE_FRAME_POINTER
-	UNWIND_ESPFIX_STACK
 
 	/* fixup %gs */
 	GS_TO_REG %ecx
@@ -1483,9 +1486,8 @@ END(common_exception_read_cr2)
 
 common_exception:
 	/* the function address is in %gs's slot on the stack */
-	SAVE_ALL switch_stacks=1 skip_gs=1
+	SAVE_ALL switch_stacks=1 skip_gs=1 unwind_espfix=1
 	ENCODE_FRAME_POINTER
-	UNWIND_ESPFIX_STACK
 
 	/* fixup %gs */
 	GS_TO_REG %ecx


