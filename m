Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA97B10ACD3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 10:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfK0Jsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 04:48:38 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58147 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfK0Jsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 04:48:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C6112B82;
        Wed, 27 Nov 2019 04:48:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 04:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1WOJkE
        65EJn38uB87V0QgEbIfHHlY5zGuVojVo3ujis=; b=ydrDuZlXCn2/ztCRP1AW3b
        YyIkxgfjgIARwNiexl6HUKtYQJFyXtiaYzFKbcY/EeUywxLZ2ZMDbKG8R6QrEpXh
        SnxrmvZscCW36mG3DslZ9e+pdgkArqiMP+x3Y5MN6jc8pwScNe0/+R48rM1ElWjF
        KvCui4TEOA+EoC2hny8T3YPwft94HKrQ642lHn91FVKsTTOf7V1t7iaYzNNLoZe4
        q0f6/5oGOuLj1qkyr/ARLFtRmHTw7Vw8xYZK2KV5Hk+nVbhV0tJNT9uztQux7zlD
        B43LCGGyho1qphmZNrd4+nxciRi4mFIdkMUMRegr7ROX+/3FzbZxjRWalgIC48WQ
        ==
X-ME-Sender: <xms:dUbeXbv1fqC05vWt3UWYPlxWVyw08G1AdK0vdpun7rQP2UyiflxjBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpeefvddrshgsnecukfhppeekfedrkeeirdekledruddtjeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhs
    thgvrhfuihiivgepud
X-ME-Proxy: <xmx:dUbeXRr7QIClu7rzB40qspT17TT4FRCTI1ieEpk8mwoTSe224-B-uw>
    <xmx:dUbeXfUciaBUwxclS6vgZdPA7sPJxYq7hQhK3GVgLMFfWLIL05A-Yw>
    <xmx:dUbeXVFqs34w4XotILeohCpgzWfGj5VwmO72x8kYWPG4FFkO3YGevg>
    <xmx:dUbeXaxll4yDkb2ECgvoDWmCrdRWZQ_6fWtbn_AFaOGfgoLnMX6kwg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E90EC80059;
        Wed, 27 Nov 2019 04:48:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/entry/32: Fix NMI vs ESPFIX" failed to apply to 4.19-stable tree
To:     peterz@infradead.org, luto@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 10:48:35 +0100
Message-ID: <1574848115250193@kroah.com>
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

From 895429076512e9d1cf5428181076299c90713159 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 20 Nov 2019 15:02:26 +0100
Subject: [PATCH] x86/entry/32: Fix NMI vs ESPFIX

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

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 647e2a272d08..0b8c93136650 100644
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

