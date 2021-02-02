Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B530C7D6
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhBBRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234173AbhBBOMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:12:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D61FC6504B;
        Tue,  2 Feb 2021 13:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273976;
        bh=c+qTeRHMe1EPvovcvQf69siH95zbSNHGz3mybK9UL0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXV+dm28mW3mZm6f23u6S0afPKBL0iFAPoU3xySmJtyWpwrmuXtRJNEMaXjUwzxV+
         3r6NavdP0HKylDeKsrTavPCQPWtpFy9Co41vRTZ+wcP+jYvVwweQzj9jI7doyhfbNB
         fGeE/lv8i3zearB4tRbOynz0JEHxpT+H6vdyXhZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhijianx.li@intel.com,
        Andy Lutomirski <luto@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Alistair Delva <adelva@google.com>
Subject: [PATCH 4.14 24/30] x86/entry/64/compat: Fix "x86/entry/64/compat: Preserve r8-r11 in int $0x80"
Date:   Tue,  2 Feb 2021 14:39:05 +0100
Message-Id: <20210202132943.127113115@linuxfoundation.org>
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

commit 22cd978e598618e82c3c3348d2069184f6884182 upstream.

Commit:

  8bb2610bc496 ("x86/entry/64/compat: Preserve r8-r11 in int $0x80")

was busted: my original patch had a minor conflict with
some of the nospec changes, but "git apply" is very clever
and silently accepted the patch by making the same changes
to a different function in the same file.  There was obviously
a huge offset, but "git apply" for some reason doesn't feel
any need to say so.

Move the changes to the correct function.  Now the
test_syscall_vdso_32 selftests passes.

If anyone cares to observe the original problem, try applying the
patch at:

  https://lore.kernel.org/lkml/d4c4d9985fbe64f8c9e19291886453914b48caee.1523975710.git.luto@kernel.org/raw

to the kernel at 316d097c4cd4e7f2ef50c40cff2db266593c4ec4:

 - "git am" and "git apply" accept the patch without any complaints at all
 - "patch -p1" at least prints out a message about the huge offset.

Reported-by: zhijianx.li@intel.com
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org #v4.17+
Fixes: 8bb2610bc496 ("x86/entry/64/compat: Preserve r8-r11 in int $0x80")
Link: http://lkml.kernel.org/r/6012b922485401bc42676e804171ded262fc2ef2.1530078306.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alistair Delva <adelva@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64_compat.S |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -84,13 +84,13 @@ ENTRY(entry_SYSENTER_compat)
 	pushq	%rdx			/* pt_regs->dx */
 	pushq	%rcx			/* pt_regs->cx */
 	pushq	$-ENOSYS		/* pt_regs->ax */
-	pushq   %r8			/* pt_regs->r8 */
+	pushq   $0			/* pt_regs->r8  = 0 */
 	xorl	%r8d, %r8d		/* nospec   r8 */
-	pushq   %r9			/* pt_regs->r9 */
+	pushq   $0			/* pt_regs->r9  = 0 */
 	xorl	%r9d, %r9d		/* nospec   r9 */
-	pushq   %r10			/* pt_regs->r10 */
+	pushq   $0			/* pt_regs->r10 = 0 */
 	xorl	%r10d, %r10d		/* nospec   r10 */
-	pushq   %r11			/* pt_regs->r11 */
+	pushq   $0			/* pt_regs->r11 = 0 */
 	xorl	%r11d, %r11d		/* nospec   r11 */
 	pushq   %rbx                    /* pt_regs->rbx */
 	xorl	%ebx, %ebx		/* nospec   rbx */
@@ -357,13 +357,13 @@ ENTRY(entry_INT80_compat)
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
+	pushq   %r10			/* pt_regs->r10*/
 	xorl	%r10d, %r10d		/* nospec   r10 */
-	pushq   $0			/* pt_regs->r11 = 0 */
+	pushq   %r11			/* pt_regs->r11 */
 	xorl	%r11d, %r11d		/* nospec   r11 */
 	pushq   %rbx                    /* pt_regs->rbx */
 	xorl	%ebx, %ebx		/* nospec   rbx */


