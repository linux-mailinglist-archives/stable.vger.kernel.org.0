Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B7810BBEE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfK0VRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387451AbfK0VNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B92821789;
        Wed, 27 Nov 2019 21:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889189;
        bh=w+m6KjUIoZY/8hFdgusd84msZw06EQ08t3XBUtOWqvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKp9xfYeblF+DWH24uKSB71EkLxNuo0qfOHR9z42tqU0oD2/oHpEFONZjcBu3rg8t
         DLavyOUJcwUu1pY+N09zH/bGGTORXLWvCR5oiG0O+Ex9UjxhkSVW/Sqh4H2zdNRJx+
         P79mKeGkU9x5O6oHvTkN/dLJpqfGwkQcAR/csnTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>, stable@kernel.org
Subject: [PATCH 5.4 23/66] x86/entry/32: Fix NMI vs ESPFIX
Date:   Wed, 27 Nov 2019 21:32:18 +0100
Message-Id: <20191127202656.944643107@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 895429076512e9d1cf5428181076299c90713159 upstream.

When the NMI lands on an ESPFIX_SS, we are on the entry stack and must
swizzle, otherwise we'll run do_nmi() on the entry stack, which is
BAD.

Also, similar to the normal exception path, we need to correct the
ESPFIX magic before leaving the entry stack, otherwise pt_regs will
present a non-flat stack pointer.

Tested by running sigreturn_32 concurrent with perf-record.

Fixes: e5862d0515ad ("x86/entry/32: Leave the kernel via trampoline stack")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |   53 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 12 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -205,6 +205,7 @@
 #define CS_FROM_ENTRY_STACK	(1 << 31)
 #define CS_FROM_USER_CR3	(1 << 30)
 #define CS_FROM_KERNEL		(1 << 29)
+#define CS_FROM_ESPFIX		(1 << 28)
 
 .macro FIXUP_FRAME
 	/*
@@ -342,8 +343,8 @@
 .endif
 .endm
 
-.macro SAVE_ALL_NMI cr3_reg:req
-	SAVE_ALL
+.macro SAVE_ALL_NMI cr3_reg:req unwind_espfix=0
+	SAVE_ALL unwind_espfix=\unwind_espfix
 
 	BUG_IF_WRONG_CR3
 
@@ -1526,6 +1527,10 @@ ENTRY(nmi)
 	ASM_CLAC
 
 #ifdef CONFIG_X86_ESPFIX32
+	/*
+	 * ESPFIX_SS is only ever set on the return to user path
+	 * after we've switched to the entry stack.
+	 */
 	pushl	%eax
 	movl	%ss, %eax
 	cmpw	$__ESPFIX_SS, %ax
@@ -1561,6 +1566,11 @@ ENTRY(nmi)
 	movl	%ebx, %esp
 
 .Lnmi_return:
+#ifdef CONFIG_X86_ESPFIX32
+	testl	$CS_FROM_ESPFIX, PT_CS(%esp)
+	jnz	.Lnmi_from_espfix
+#endif
+
 	CHECK_AND_APPLY_ESPFIX
 	RESTORE_ALL_NMI cr3_reg=%edi pop=4
 	jmp	.Lirq_return
@@ -1568,23 +1578,42 @@ ENTRY(nmi)
 #ifdef CONFIG_X86_ESPFIX32
 .Lnmi_espfix_stack:
 	/*
-	 * create the pointer to lss back
+	 * Create the pointer to LSS back
 	 */
 	pushl	%ss
 	pushl	%esp
 	addl	$4, (%esp)
-	/* copy the iret frame of 12 bytes */
-	.rept 3
-	pushl	16(%esp)
-	.endr
-	pushl	%eax
-	SAVE_ALL_NMI cr3_reg=%edi
+
+	/* Copy the (short) IRET frame */
+	pushl	4*4(%esp)	# flags
+	pushl	4*4(%esp)	# cs
+	pushl	4*4(%esp)	# ip
+
+	pushl	%eax		# orig_ax
+
+	SAVE_ALL_NMI cr3_reg=%edi unwind_espfix=1
 	ENCODE_FRAME_POINTER
-	FIXUP_ESPFIX_STACK			# %eax == %esp
+
+	/* clear CS_FROM_KERNEL, set CS_FROM_ESPFIX */
+	xorl	$(CS_FROM_ESPFIX | CS_FROM_KERNEL), PT_CS(%esp)
+
 	xorl	%edx, %edx			# zero error code
-	call	do_nmi
+	movl	%esp, %eax			# pt_regs pointer
+	jmp	.Lnmi_from_sysenter_stack
+
+.Lnmi_from_espfix:
 	RESTORE_ALL_NMI cr3_reg=%edi
-	lss	12+4(%esp), %esp		# back to espfix stack
+	/*
+	 * Because we cleared CS_FROM_KERNEL, IRET_FRAME 'forgot' to
+	 * fix up the gap and long frame:
+	 *
+	 *  3 - original frame	(exception)
+	 *  2 - ESPFIX block	(above)
+	 *  6 - gap		(FIXUP_FRAME)
+	 *  5 - long frame	(FIXUP_FRAME)
+	 *  1 - orig_ax
+	 */
+	lss	(1+5+6)*4(%esp), %esp			# back to espfix stack
 	jmp	.Lirq_return
 #endif
 END(nmi)


