Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0593B1EC2C2
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 21:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFBTbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBTbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 15:31:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6031AC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 12:31:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f130so39510yba.9
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 12:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rclZP01j1InoS/3XtOg/bC1dGPlx80uQ6aMTFnGzZ2w=;
        b=lKTcFEgWzsBAVwkz4pKNgMxfzTA/rGF9JodhNthDiBoH7YkwDBV0kuC35tGrGmUPa7
         vigobAbCfGHSoCDBNiiNxGCo7ry+l11xNDbwclXy4FRbvLdz1Yv3eqb8rD4o311vIRV6
         NpmILM/4g7+ijufcHgNkg4AdMRRfwaUT1X0pS7DCnceJFn8bDOjsoNsZDYC6xv9nOuWg
         oBIKuuzUNJbFU0/tAlZtsBNYOjUnDAbe8I0Qxs1y2Ikzs3uN0bccFj+Iby/ZIT//ZKjR
         fgN+4PcwfA4n6RA2eU1K9QyQilXZEkUcXZqwz2AYKNfI6kQB0S/S7OhaqcgDbolreiHl
         ZAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rclZP01j1InoS/3XtOg/bC1dGPlx80uQ6aMTFnGzZ2w=;
        b=La84728nnTyJd6x8STbgHRCCv6qllLe2iOCIWikSMeTX+jIUAINUFTIVrysmHr0G7c
         /0mSDUH5rrQMdteqqMXPFidbnPXQf9OXL779zBgtDiC5cD1Zl00EOUVfFrQch2QSbTQN
         nj8U9MMbDVqJ5MHaINtuav4Fo+r5WNL5bQinsv1NUxr9sS1PWqeAqnGCmFd3AB7CWxDS
         Mo5ajOdWoPORiwW3xSHxi+Jr4STAI+TkwaxvXUchi9pZuayl1CUDrT73k3uLHM5ecU4o
         ow0caPtFTWUt9D4FxmmnorffLG0rF+7vOyxn9fvmYevu1cGDOlAaEao8uQ800gtsf0mp
         K73g==
X-Gm-Message-State: AOAM530Fr3dOtX5PRDijMZmQkNbzYlKwbpMTG1I3COHiKLWiFIj/fidp
        Xl5PLbVA5BwAZFuz+BqIxrSaHgn9uKbkdpQ=
X-Google-Smtp-Source: ABdhPJwx0Lnv0amOjqwgyGjnGBXNYRxRwJOaVB5GXUgExCVr3FTb91vVxXmRJ+HznOHa2zVWvNFKsvqcVfjrfhU=
X-Received: by 2002:a25:c186:: with SMTP id r128mr46983177ybf.92.1591126280496;
 Tue, 02 Jun 2020 12:31:20 -0700 (PDT)
Date:   Tue,  2 Jun 2020 12:30:59 -0700
In-Reply-To: <20200602132702.y3tjwvqdbww7oy5i@treble>
Message-Id: <20200602193100.229287-1-inglorion@google.com>
Mime-Version: 1.0
References: <20200602132702.y3tjwvqdbww7oy5i@treble>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v2] x86_64: fix jiffies ODR violation
From:   Bob Haarman <inglorion@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Bob Haarman <inglorion@google.com>, stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alistair Delva <adelva@google.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Kyung Min Park <kyung.min.park@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Ross Zwisler <zwisler@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

'jiffies' and 'jiffies_64' are meant to alias (two different symbols
that share the same address).  Most architectures make the symbols alias
to the same address via linker script assignment in their
arch/<arch>/kernel/vmlinux.lds.S:

jiffies = jiffies_64;

which is effectively a definition of jiffies.

jiffies and jiffies_64 are both forward declared for all arch's in:
include/linux/jiffies.h.

jiffies_64 is defined in kernel/time/timer.c for all arch's.

x86_64 was peculiar in that it wasn't doing the above linker script
assignment, but rather was:
1. defining jiffies in arch/x86/kernel/time.c instead via linker script.
2. overriding the symbol jiffies_64 from kernel/time/timer.c in
arch/x86/kernel/vmlinux.lds.s via 'jiffies_64 = jiffies;'.

As Fangrui notes:

  In LLD, symbol assignments in linker scripts override definitions in
  object files. GNU ld appears to have the same behavior. It would
  probably make sense for LLD to error "duplicate symbol" but GNU ld
  is unlikely to adopt for compatibility reasons.

So we have an ODR violation (UB), which we seem to have gotten away
with thus far. Where it becomes harmful is when we:

1. Use -fno-semantic-interposition.

As Fangrui notes:

  Clang after LLVM commit 5b22bcc2b70d
  ("[X86][ELF] Prefer to lower MC_GlobalAddress operands to .Lfoo$local")
  defaults to -fno-semantic-interposition similar semantics which help
  -fpic/-fPIC code avoid GOT/PLT when the referenced symbol is defined
  within the same translation unit. Unlike GCC
  -fno-semantic-interposition, Clang emits such relocations referencing
  local symbols for non-pic code as well.

This causes references to jiffies to refer to '.Ljiffies$local' when
jiffies is defined in the same translation unit. Likewise, references
to jiffies_64 become references to '.Ljiffies_64$local' in translation
units that define jiffies_64.  Because these differ from the names
used in the linker script, they will not be rewritten to alias one
another.

Combined with ...

2. Full LTO effectively treats all source files as one translation
unit, causing these local references to be produced everywhere.  When
the linker processes the linker script, there are no longer any
references to jiffies_64' anywhere to replace with 'jiffies'.  And
thus '.Ljiffies$local' and '.Ljiffies_64$local' no longer alias
at all.

In the process of porting patches enabling Full LTO from arm64 to
x86_64, we observe spooky bugs where the kernel appeared to boot, but
init doesn't get scheduled.

Instead, we can avoid the ODR violation by matching other arch's by
defining jiffies only by linker script.  For -fno-semantic-interposition
+ Full LTO, there is no longer a global definition of jiffies for the
compiler to produce a local symbol which the linker script won't ensure
aliases to jiffies_64.

Link: https://github.com/ClangBuiltLinux/linux/issues/852
Fixes: 40747ffa5aa8 ("asmlinkage: Make jiffies visible")
Cc: stable@vger.kernel.org
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Alistair Delva <adelva@google.com>
Suggested-by: Fangrui Song <maskray@google.com>
Debugged-by: Nick Desaulniers <ndesaulniers@google.com>
Debugged-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Bob Haarman <inglorion@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
v2:
* Changed commit message as requested by Josh Poimboeuf
  (no code change)

---
 arch/x86/kernel/time.c        | 4 ----
 arch/x86/kernel/vmlinux.lds.S | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 371a6b348e44..e42faa792c07 100644
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
index 1bf7e312361f..7c35556c7827 100644
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
-- 
2.27.0.rc2.251.g90737beb825-goog

