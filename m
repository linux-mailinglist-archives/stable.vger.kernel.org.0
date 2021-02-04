Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3B830C129
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhBBOO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234172AbhBBOMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BBDC65049;
        Tue,  2 Feb 2021 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273973;
        bh=GpeAo1wwtd9mPJxDxqjR/ptVlKYLDNaeENjlxu1fy7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwB9UkpZSovz1zmNDCDpn8OzxuE9S6KVpmlye8v2B0+pvJEeuy5m1Cv4/uRs6poxa
         Beq7gilJmpjQeWgXFdZLEbbSEAablmi5s9459JrbPfSitFs9sWhpfXknBLTxq3076E
         JHopCJm4mFOX9MkaoCsZJt64zzyiiaqw/fTD415Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alistair Delva <adelva@google.com>
Subject: [PATCH 4.14 23/30] x86/entry/64/compat: Preserve r8-r11 in int $0x80
Date:   Tue,  2 Feb 2021 14:39:04 +0100
Message-Id: <20210202132943.093740424@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 8bb2610bc4967f19672444a7b0407367f1540028 upstream.

32-bit user code that uses int $80 doesn't care about r8-r11.  There is,
however, some 64-bit user code that intentionally uses int $0x80 to invoke
32-bit system calls.  From what I've seen, basically all such code assumes
that r8-r15 are all preserved, but the kernel clobbers r8-r11.  Since I
doubt that there's any code that depends on int $0x80 zeroing r8-r11,
change the kernel to preserve them.

I suspect that very little user code is broken by the old clobber, since
r8-r11 are only rarely allocated by gcc, and they're clobbered by function
calls, so they only way we'd see a problem is if the same function that
invokes int $0x80 also spills something important to one of these
registers.

The current behavior seems to date back to the historical commit
"[PATCH] x86-64 merge for 2.6.4".  Before that, all regs were
preserved.  I can't find any explanation of why this change was made.

Update the test_syscall_vdso_32 testcase as well to verify the new
behavior, and it strengthens the test to make sure that the kernel doesn't
accidentally permute r8..r15.

Suggested-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Link: https://lkml.kernel.org/r/d4c4d9985fbe64f8c9e19291886453914b48caee.1523975710.git.luto@kernel.org
Signed-off-by: Alistair Delva <adelva@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64_compat.S                |    8 ++---
 tools/testing/selftests/x86/test_syscall_vdso.c |   35 ++++++++++++++----------
 2 files changed, 25 insertions(+), 18 deletions(-)

--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -84,13 +84,13 @@ ENTRY(entry_SYSENTER_compat)
 	pushq	%rdx			/* pt_regs->dx */
 	pushq	%rcx			/* pt_regs->cx */
 	pushq	$-ENOSYS		/* pt_regs->ax */
-	pushq   $0			/* pt_regs->r8  = 0 */
+	pushq   %r8			/* pt_regs->r8 */
 	xorl	%r8d, %r8d		/* nospec   r8 */
-	pushq   $0			/* pt_regs->r9  = 0 */
+	pushq   %r9			/* pt_regs->r9 */
 	xorl	%r9d, %r9d		/* nospec   r9 */
-	pushq   $0			/* pt_regs->r10 = 0 */
+	pushq   %r10			/* pt_regs->r10 */
 	xorl	%r10d, %r10d		/* nospec   r10 */
-	pushq   $0			/* pt_regs->r11 = 0 */
+	pushq   %r11			/* pt_regs->r11 */
 	xorl	%r11d, %r11d		/* nospec   r11 */
 	pushq   %rbx                    /* pt_regs->rbx */
 	xorl	%ebx, %ebx		/* nospec   rbx */
--- a/tools/testing/selftests/x86/test_syscall_vdso.c
+++ b/tools/testing/selftests/x86/test_syscall_vdso.c
@@ -100,12 +100,19 @@ asm (
 	"	shl	$32, %r8\n"
 	"	orq	$0x7f7f7f7f, %r8\n"
 	"	movq	%r8, %r9\n"
-	"	movq	%r8, %r10\n"
-	"	movq	%r8, %r11\n"
-	"	movq	%r8, %r12\n"
-	"	movq	%r8, %r13\n"
-	"	movq	%r8, %r14\n"
-	"	movq	%r8, %r15\n"
+	"	incq	%r9\n"
+	"	movq	%r9, %r10\n"
+	"	incq	%r10\n"
+	"	movq	%r10, %r11\n"
+	"	incq	%r11\n"
+	"	movq	%r11, %r12\n"
+	"	incq	%r12\n"
+	"	movq	%r12, %r13\n"
+	"	incq	%r13\n"
+	"	movq	%r13, %r14\n"
+	"	incq	%r14\n"
+	"	movq	%r14, %r15\n"
+	"	incq	%r15\n"
 	"	ret\n"
 	"	.code32\n"
 	"	.popsection\n"
@@ -128,12 +135,13 @@ int check_regs64(void)
 	int err = 0;
 	int num = 8;
 	uint64_t *r64 = &regs64.r8;
+	uint64_t expected = 0x7f7f7f7f7f7f7f7fULL;
 
 	if (!kernel_is_64bit)
 		return 0;
 
 	do {
-		if (*r64 == 0x7f7f7f7f7f7f7f7fULL)
+		if (*r64 == expected++)
 			continue; /* register did not change */
 		if (syscall_addr != (long)&int80) {
 			/*
@@ -147,18 +155,17 @@ int check_regs64(void)
 				continue;
 			}
 		} else {
-			/* INT80 syscall entrypoint can be used by
+			/*
+			 * INT80 syscall entrypoint can be used by
 			 * 64-bit programs too, unlike SYSCALL/SYSENTER.
 			 * Therefore it must preserve R12+
 			 * (they are callee-saved registers in 64-bit C ABI).
 			 *
-			 * This was probably historically not intended,
-			 * but R8..11 are clobbered (cleared to 0).
-			 * IOW: they are the only registers which aren't
-			 * preserved across INT80 syscall.
+			 * Starting in Linux 4.17 (and any kernel that
+			 * backports the change), R8..11 are preserved.
+			 * Historically (and probably unintentionally), they
+			 * were clobbered or zeroed.
 			 */
-			if (*r64 == 0 && num <= 11)
-				continue;
 		}
 		printf("[FAIL]\tR%d has changed:%016llx\n", num, *r64);
 		err++;


