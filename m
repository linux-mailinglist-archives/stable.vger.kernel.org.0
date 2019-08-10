Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0AD88DC1
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfHJUsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053h-Iz; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003iX-QU; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Brian Gerst" <brgerst@gmail.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>, paulmck@linux.vnet.ibm.com,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Rik van Riel" <riel@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.917544612@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 123/157] x86/entry/64: Really create an
 error-entry-from-usermode code path
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

commit cb6f64ed5a04036eef07e70b57dd5dd78f2fbcef upstream.

In 539f51136500 ("x86/asm/entry/64: Disentangle error_entry/exit
gsbase/ebx/usermode code"), I arranged the code slightly wrong
-- IRET faults would skip the code path that was intended to
execute on all error entries from user mode.  Fix it up.

While we're at it, make all the labels in error_entry local.

This does not fix a bug, but we'll need it, and it slightly
shrinks the code.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/91e17891e49fa3d61357eadc451529ad48143ee1.1435952415.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 as dependency of commit 18ec54fdd6d1
 "x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations":
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/entry_64.S | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1445,12 +1445,17 @@ ENTRY(error_entry)
 	 */
 	SWITCH_KERNEL_CR3
 	testl $3,CS+8(%rsp)
-	je error_kernelspace
+	jz	.Lerror_kernelspace
 
-	/* We entered from user mode */
+.Lerror_entry_from_usermode_swapgs:
+	/*
+	 * We entered from user mode or we're pretending to have entered
+	 * from user mode due to an IRET fault.
+	 */
 	SWAPGS
 
-error_entry_done:
+.Lerror_entry_from_usermode_after_swapgs:
+.Lerror_entry_done:
 	TRACE_IRQS_OFF
 	ret
 
@@ -1460,30 +1465,29 @@ error_entry_done:
  * truncated RIP for IRET exceptions returning to compat mode. Check
  * for these here too.
  */
-error_kernelspace:
+.Lerror_kernelspace:
 	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
-	je error_bad_iret
+	je	.Lerror_bad_iret
 	movl %ecx,%eax	/* zero extend */
 	cmpq %rax,RIP+8(%rsp)
-	je bstep_iret
+	je	.Lbstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
-	jne	error_entry_done
+	jne	.Lerror_entry_done
 
 	/*
 	 * hack: gs_change can fail with user gsbase.  If this happens, fix up
 	 * gsbase and proceed.  We'll fix up the exception and land in
 	 * gs_change's error handler with kernel gsbase.
 	 */
-	SWAPGS
-	jmp	error_entry_done
+	jmp	.Lerror_entry_from_usermode_swapgs
 
-bstep_iret:
+.Lbstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
 	/* fall through */
 
-error_bad_iret:
+.Lerror_bad_iret:
 	/*
 	 * We came from an IRET to user mode, so we have user gsbase.
 	 * Switch to kernel gsbase:
@@ -1497,7 +1501,7 @@ error_bad_iret:
 	mov %rsp,%rdi
 	call fixup_bad_iret
 	mov %rax,%rsp
-	jmp	error_entry_done
+	jmp	.Lerror_entry_from_usermode_after_swapgs
 	CFI_ENDPROC
 END(error_entry)
 

