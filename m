Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A706310ACD0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 10:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfK0JsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 04:48:17 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47981 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726143AbfK0JsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 04:48:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6E1F6A3E;
        Wed, 27 Nov 2019 04:48:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 04:48:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s396rT
        F0oLewHt7NLplNHZ+kddTlxaKGdwglLQii7yg=; b=Tb26+UNNeEefBlDNlmCO/u
        eyD99KJd4jnoI8sfhxk0l4/bBtHKKNLloQICvRzEL7QbhZXNqbiwIDdc2uqE/fKz
        YlLf0LBNcFRcA3gvAT1VPLONF5jTfyIFnNyR7krmcDxM6Tshc9PkkcSVho7FYhrK
        Z6bEMDZZCThvL5nRP+pIXAOgqrbdyKeTpXKcnBRfb++J6O2emXCjcGOvEZVkjqPi
        V4BdUDofXyfckJZQboM4U7EGzftSsCLATTPEf2hMnZ9l9qoRiLNYodArcX7KSWoF
        i/r84ZDdv3qWSVvfJVPDL0DTbeaw7A+wb8zjhDjZZmy6u/p9y7hc2CIgYKwd9YIg
        ==
X-ME-Sender: <xms:X0beXRmC-iGGYMhQIAcGlSHJURE1UGu1sSmViekx_6cAM3kB3eX7zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpeefvddrshgsnecukfhppeekfedrkeeirdekledruddtjeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhs
    thgvrhfuihiivgeptd
X-ME-Proxy: <xmx:X0beXcIIwUbs64Fh0J_m37lCaUZ-5x6uq9UiOaJ9S8Q7lVH3TaA8dw>
    <xmx:X0beXenALxETtdwOd-HbltQXmsVicyDJD7rfhjM81HlbdEipSfSVGw>
    <xmx:X0beXc4-Fz0zFKdD3qqXW_FZ4WwcBqaBjiJ94ZSWnoPD_ohBvN8JsQ>
    <xmx:YEbeXTNT-3EQhQHREPVaJtZ-novX7VbYrdWCo00IpJSf69g54GjBug>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F96280069;
        Wed, 27 Nov 2019 04:48:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/entry/32: Unwind the ESPFIX stack earlier on exception" failed to apply to 4.19-stable tree
To:     luto@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 10:48:13 +0100
Message-ID: <157484809393212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a1a338e5b6fe9e0a39c57c232dc96c198bb53e47 Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 20 Nov 2019 10:10:49 +0100
Subject: [PATCH] x86/entry/32: Unwind the ESPFIX stack earlier on exception
 entry

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

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index d9f401995278..647e2a272d08 100644
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

