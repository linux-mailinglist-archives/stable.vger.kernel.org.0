Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D298E1D3A45
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgENSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbgENSzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106F9207F9;
        Thu, 14 May 2020 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482512;
        bh=qulwPbZkzE4NFTAAUi2Qdb36dRGHKbHi3E8aGXOWyBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eokYUBXCwqkjaCYLg/aGwj5LkQC4qV8Kp91O7oAjDwKI1/MGiamWUDlAbJrg2k2Gz
         ue6Ds34gIg83Vn8AvcjqrK7wz4GY4dO9FR5Svvo4M7snz1vU0NfSYB945JTYY0kCus
         IlviC8oXAJHCSaeQ12modxq+wkIa3rvYcg61P3Yc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 11/39] x86/entry/64: Fix unwind hints in register clearing code
Date:   Thu, 14 May 2020 14:54:28 -0400
Message-Id: <20200514185456.21060-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 06a9750edcffa808494d56da939085c35904e618 ]

The PUSH_AND_CLEAR_REGS macro zeroes each register immediately after
pushing it.  If an NMI or exception hits after a register is cleared,
but before the UNWIND_HINT_REGS annotation, the ORC unwinder will
wrongly think the previous value of the register was zero.  This can
confuse the unwinding process and cause it to exit early.

Because ORC is simpler than DWARF, there are a limited number of unwind
annotation states, so it's not possible to add an individual unwind hint
after each push/clear combination.  Instead, the register clearing
instructions need to be consolidated and moved to after the
UNWIND_HINT_REGS annotation.

Fixes: 3f01daecd545 ("x86/entry/64: Introduce the PUSH_AND_CLEAN_REGS macro")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/68fd3d0bc92ae2d62ff7879d15d3684217d51f08.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/calling.h | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 557c1bdda311b..1dbc62a96b859 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -98,13 +98,6 @@ For 32-bit we have the following conventions - kernel is built with
 #define SIZEOF_PTREGS	21*8
 
 .macro PUSH_AND_CLEAR_REGS rdx=%rdx rax=%rax save_ret=0
-	/*
-	 * Push registers and sanitize registers of values that a
-	 * speculation attack might otherwise want to exploit. The
-	 * lower registers are likely clobbered well before they
-	 * could be put to use in a speculative execution gadget.
-	 * Interleave XOR with PUSH for better uop scheduling:
-	 */
 	.if \save_ret
 	pushq	%rsi		/* pt_regs->si */
 	movq	8(%rsp), %rsi	/* temporarily store the return address in %rsi */
@@ -117,29 +110,40 @@ For 32-bit we have the following conventions - kernel is built with
 	pushq   %rcx		/* pt_regs->cx */
 	pushq   \rax		/* pt_regs->ax */
 	pushq   %r8		/* pt_regs->r8 */
-	xorl	%r8d, %r8d	/* nospec   r8 */
 	pushq   %r9		/* pt_regs->r9 */
-	xorl	%r9d, %r9d	/* nospec   r9 */
 	pushq   %r10		/* pt_regs->r10 */
-	xorl	%r10d, %r10d	/* nospec   r10 */
 	pushq   %r11		/* pt_regs->r11 */
-	xorl	%r11d, %r11d	/* nospec   r11*/
 	pushq	%rbx		/* pt_regs->rbx */
-	xorl    %ebx, %ebx	/* nospec   rbx*/
 	pushq	%rbp		/* pt_regs->rbp */
-	xorl    %ebp, %ebp	/* nospec   rbp*/
 	pushq	%r12		/* pt_regs->r12 */
-	xorl	%r12d, %r12d	/* nospec   r12*/
 	pushq	%r13		/* pt_regs->r13 */
-	xorl	%r13d, %r13d	/* nospec   r13*/
 	pushq	%r14		/* pt_regs->r14 */
-	xorl	%r14d, %r14d	/* nospec   r14*/
 	pushq	%r15		/* pt_regs->r15 */
-	xorl	%r15d, %r15d	/* nospec   r15*/
 	UNWIND_HINT_REGS
+
 	.if \save_ret
 	pushq	%rsi		/* return address on top of stack */
 	.endif
+
+	/*
+	 * Sanitize registers of values that a speculation attack might
+	 * otherwise want to exploit. The lower registers are likely clobbered
+	 * well before they could be put to use in a speculative execution
+	 * gadget.
+	 */
+	xorl	%edx,  %edx	/* nospec dx  */
+	xorl	%ecx,  %ecx	/* nospec cx  */
+	xorl	%r8d,  %r8d	/* nospec r8  */
+	xorl	%r9d,  %r9d	/* nospec r9  */
+	xorl	%r10d, %r10d	/* nospec r10 */
+	xorl	%r11d, %r11d	/* nospec r11 */
+	xorl	%ebx,  %ebx	/* nospec rbx */
+	xorl	%ebp,  %ebp	/* nospec rbp */
+	xorl	%r12d, %r12d	/* nospec r12 */
+	xorl	%r13d, %r13d	/* nospec r13 */
+	xorl	%r14d, %r14d	/* nospec r14 */
+	xorl	%r15d, %r15d	/* nospec r15 */
+
 .endm
 
 .macro POP_REGS pop_rdi=1 skip_r11rcx=0
-- 
2.20.1

