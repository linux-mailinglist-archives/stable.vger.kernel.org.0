Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7588DB7
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHJUsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54840 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfHJUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDW-00053s-Qz; Sat, 10 Aug 2019 21:43:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003iS-PJ; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Borislav Petkov" <bp@alien8.de>,
        "Andy Lutomirski" <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Brian Gerst" <brgerst@gmail.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andy Lutomirski" <luto@amacapital.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.539176798@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 122/157] x86/asm/entry/64: Disentangle
 error_entry/exit gsbase/ebx/usermode code
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

commit 539f5113650068ba221197f190267ab727296ef5 upstream.

The error_entry/error_exit code to handle gsbase and whether we
return to user mdoe was a mess:

 - error_sti was misnamed.  In particular, it did not enable interrupts.

 - Error handling for gs_change was hopelessly tangled the normal
   usermode path.  Separate it out.  This saves a branch in normal
   entries from kernel mode.

 - The comments were bad.

Fix it up.  As a nice side effect, there's now a code path that
happens on error entries from user mode.  We'll use it soon.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/f1be898ab93360169fb845ab85185948832209ee.1433878454.git.luto@kernel.org
[ Prettified it, clarified comments some more. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 as dependency of commit 18ec54fdd6d1
 "x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations":
 - We do not use %ebx as a flag since we already have a backport of commit
   b3681dd548d0 "x86/entry/64: Remove %ebx handling from error_entry/exit",
   so don't add the comments about that
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1446,9 +1446,11 @@ ENTRY(error_entry)
 	SWITCH_KERNEL_CR3
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
-error_swapgs:
+
+	/* We entered from user mode */
 	SWAPGS
-error_sti:
+
+error_entry_done:
 	TRACE_IRQS_OFF
 	ret
 
@@ -1466,8 +1468,15 @@ error_kernelspace:
 	cmpq %rax,RIP+8(%rsp)
 	je bstep_iret
 	cmpq $gs_change,RIP+8(%rsp)
-	je error_swapgs
-	jmp error_sti
+	jne	error_entry_done
+
+	/*
+	 * hack: gs_change can fail with user gsbase.  If this happens, fix up
+	 * gsbase and proceed.  We'll fix up the exception and land in
+	 * gs_change's error handler with kernel gsbase.
+	 */
+	SWAPGS
+	jmp	error_entry_done
 
 bstep_iret:
 	/* Fix truncated RIP */
@@ -1475,11 +1484,20 @@ bstep_iret:
 	/* fall through */
 
 error_bad_iret:
+	/*
+	 * We came from an IRET to user mode, so we have user gsbase.
+	 * Switch to kernel gsbase:
+	 */
 	SWAPGS
+
+	/*
+	 * Pretend that the exception came from user mode: set up pt_regs
+	 * as if we faulted immediately after IRET.
+	 */
 	mov %rsp,%rdi
 	call fixup_bad_iret
 	mov %rax,%rsp
-	jmp error_sti
+	jmp	error_entry_done
 	CFI_ENDPROC
 END(error_entry)
 

