Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458641F3678
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgFIIyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbgFIIx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 04:53:56 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A14EC03E97C;
        Tue,  9 Jun 2020 01:53:55 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jia0y-0005c6-K2; Tue, 09 Jun 2020 10:53:48 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 376751C007F;
        Tue,  9 Jun 2020 10:53:48 +0200 (CEST)
Date:   Tue, 09 Jun 2020 08:53:48 -0000
From:   "tip-bot2 for Bob Haarman" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86_64: Fix jiffies ODR violation
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Fangrui Song <maskray@google.com>,
        Bob Haarman <inglorion@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200602193100.229287-1-inglorion@google.com>
References: <20200602193100.229287-1-inglorion@google.com>
MIME-Version: 1.0
Message-ID: <159169282801.17951.17795632339002464231.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     d8ad6d39c35d2b44b3d48b787df7f3359381dcbf
Gitweb:        https://git.kernel.org/tip/d8ad6d39c35d2b44b3d48b787df7f3359381dcbf
Author:        Bob Haarman <inglorion@google.com>
AuthorDate:    Tue, 02 Jun 2020 12:30:59 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 10:50:56 +02:00

x86_64: Fix jiffies ODR violation

'jiffies' and 'jiffies_64' are meant to alias (two different symbols that
share the same address).  Most architectures make the symbols alias to the
same address via a linker script assignment in their
arch/<arch>/kernel/vmlinux.lds.S:

jiffies = jiffies_64;

which is effectively a definition of jiffies.

jiffies and jiffies_64 are both forward declared for all architectures in
include/linux/jiffies.h. jiffies_64 is defined in kernel/time/timer.c.

x86_64 was peculiar in that it wasn't doing the above linker script
assignment, but rather was:
1. defining jiffies in arch/x86/kernel/time.c instead via the linker script.
2. overriding the symbol jiffies_64 from kernel/time/timer.c in
arch/x86/kernel/vmlinux.lds.s via 'jiffies_64 = jiffies;'.

As Fangrui notes:

  In LLD, symbol assignments in linker scripts override definitions in
  object files. GNU ld appears to have the same behavior. It would
  probably make sense for LLD to error "duplicate symbol" but GNU ld
  is unlikely to adopt for compatibility reasons.

This results in an ODR violation (UB), which seems to have survived
thus far. Where it becomes harmful is when;

1. -fno-semantic-interposition is used:

As Fangrui notes:

  Clang after LLVM commit 5b22bcc2b70d
  ("[X86][ELF] Prefer to lower MC_GlobalAddress operands to .Lfoo$local")
  defaults to -fno-semantic-interposition similar semantics which help
  -fpic/-fPIC code avoid GOT/PLT when the referenced symbol is defined
  within the same translation unit. Unlike GCC
  -fno-semantic-interposition, Clang emits such relocations referencing
  local symbols for non-pic code as well.

This causes references to jiffies to refer to '.Ljiffies$local' when
jiffies is defined in the same translation unit. Likewise, references to
jiffies_64 become references to '.Ljiffies_64$local' in translation units
that define jiffies_64.  Because these differ from the names used in the
linker script, they will not be rewritten to alias one another.

2. Full LTO

Full LTO effectively treats all source files as one translation
unit, causing these local references to be produced everywhere.  When
the linker processes the linker script, there are no longer any
references to jiffies_64' anywhere to replace with 'jiffies'.  And
thus '.Ljiffies$local' and '.Ljiffies_64$local' no longer alias
at all.

In the process of porting patches enabling Full LTO from arm64 to x86_64,
spooky bugs have been observed where the kernel appeared to boot, but init
doesn't get scheduled.

Avoid the ODR violation by matching other architectures and define jiffies
only by linker script.  For -fno-semantic-interposition + Full LTO, there
is no longer a global definition of jiffies for the compiler to produce a
local symbol which the linker script won't ensure aliases to jiffies_64.

Fixes: 40747ffa5aa8 ("asmlinkage: Make jiffies visible")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Alistair Delva <adelva@google.com>
Debugged-by: Nick Desaulniers <ndesaulniers@google.com>
Debugged-by: Sami Tolvanen <samitolvanen@google.com>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Bob Haarman <inglorion@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot on
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/852
Link: https://lkml.kernel.org/r/20200602193100.229287-1-inglorion@google.com
---
 arch/x86/kernel/time.c        | 4 ----
 arch/x86/kernel/vmlinux.lds.S | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 106e7f8..f395729 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -25,10 +25,6 @@
 #include <asm/hpet.h>
 #include <asm/time.h>
 
-#ifdef CONFIG_X86_64
-__visible volatile unsigned long jiffies __cacheline_aligned_in_smp = INITIAL_JIFFIES;
-#endif
-
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1bf7e31..7c35556 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -40,13 +40,13 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 #endif
 
+jiffies = jiffies_64;
+
 #if defined(CONFIG_X86_64)
 /*
  * On 64-bit, align RODATA to 2MB so we retain large page mappings for
