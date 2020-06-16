Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768741FB950
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgFPQC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbgFPPun (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:50:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 447F0207C4;
        Tue, 16 Jun 2020 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322642;
        bh=A2D6K0oos0DDXw1a6HDvkTrRQJbH9cUVN9kBOJHySpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxgoRerSgHCHV33r4zzzql/XtCEmUp1mohoF5XJl0Fs22fxSokHGmfUQ+Tv4swTDa
         MEUQyrat5ElrLGYMfgslGHvkyoVM9uBm2x+XEgd7F3ckvtwzR2LyA2Y6eHN+euyOPg
         VNGzuPh6NbKM/7aoSRS7DQmr77RjFoS8N9zsbWJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Fangrui Song <maskray@google.com>,
        Bob Haarman <inglorion@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.6 048/161] x86_64: Fix jiffies ODR violation
Date:   Tue, 16 Jun 2020 17:33:58 +0200
Message-Id: <20200616153108.664888702@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Haarman <inglorion@google.com>

commit d8ad6d39c35d2b44b3d48b787df7f3359381dcbf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/time.c        |    4 ----
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

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
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -39,13 +39,13 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT)
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


