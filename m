Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759EF1C5FFD
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgEESW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730734AbgEESW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 14:22:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E1BC061A10
        for <stable@vger.kernel.org>; Tue,  5 May 2020 11:22:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l25so1383918pgc.5
        for <stable@vger.kernel.org>; Tue, 05 May 2020 11:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PToLYAimVAsZtUfzGzNopJPy83pb8+TOtuhkhnpZbnA=;
        b=FgWb0Sh5Z3EcYyUZhECJJ4WRLshOPMOgvqWT4p4cYa5YQjLsklzTMRTvb5M+xfPSaq
         AP4Q9ob81bvD5lM0lLBw+uwe6NU0cwHsVnzwLQSFvzGWmr4B57OvihqTiAVo0QfcKa1Z
         UrRJ7zJZxVHhkCnulxTEjmENj912FhPejNRtFSUsSuvXp9q2lKbmnlNtWwUqmdsHaGZG
         Gm5p6nRHe6U2Ci5+Kvq867p42119l09rmT5y7yCebPrkIb08GK0TWc8H4YHgKsfFbFqk
         dmld3WpkQQ6In9tPUXdekz5X35xkllzQL5IiUuh9PLUh2bWAf/JOhbO4sYPT2HB2V/UM
         G4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PToLYAimVAsZtUfzGzNopJPy83pb8+TOtuhkhnpZbnA=;
        b=nr2K29zadDgtpg+1XxbO3HN7MClZinsAHo4GaFBX6ZDVOhl4zgCdmSvZCzEYur3XpT
         lk4IJhLAAruSPA/zk+T3ZKJbLmxOXymT6j/22ZRFCQguVVhI7GxFUK/zwveTgfXyDn9j
         y68PCeRetWOesW48j+I/A/WNkQWyPlFLCxp+y2tpMeckEGVJMHAEETZrfdhpcCPSa0dK
         oGV2nhRydOLak2zlXoplbr9kA2i4TArOUKajzaSZWvohvX2gCUMUOErDpWVOKRYtGCJh
         u4zivhce4svms2oaG6yvtvci/hq1zrT2vbAF+NmW7+nzMi1teRA3kdm4StpSKb16Xwsr
         Y8qw==
X-Gm-Message-State: AGi0PuaeDjseRhkyd7MWINirvECxxKPMBUU13I7a08II+lbUO67g7KRw
        JOBVTPYJuQkTYEQ9YfzDjoJsHZpZxVItMUBo2GKwww==
X-Google-Smtp-Source: APiQypKSPWEyDKwJ3ovCYgt2orqxoiB29zoBVD6bokNDP4gPN8n1JHWythabwhZmSuTxa13QTc/5kNbanXXq98paRs0=
X-Received: by 2002:a63:6546:: with SMTP id z67mr3795479pgb.10.1588702977435;
 Tue, 05 May 2020 11:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com> <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
In-Reply-To: <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 5 May 2020 11:22:47 -0700
Message-ID: <CAKwvOdkcQwwpx5JMJpGg4cO3RLfoLtWvWjgnuXyzas1X3eyvWQ@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 5, 2020 at 11:07 AM <hpa@zytor.com> wrote:
>
> On May 5, 2020 10:44:22 AM PDT, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >From: Sedat Dilek <sedat.dilek@gmail.com>
> >
> >It turns out that if your config tickles __builtin_constant_p via
> >differences in choices to inline or not, this now produces invalid
> >assembly:
> >
> >$ cat foo.c
> >long a(long b, long c) {
> >  asm("orb\t%1, %0" : "+q"(c): "r"(b));
> >  return c;
> >}
> >$ gcc foo.c
> >foo.c: Assembler messages:
> >foo.c:2: Error: `%rax' not allowed with `orb'
> >
> >The "q" constraint only has meanting on -m32 otherwise is treated as
> >"r".
> >
> >This is easily reproducible via Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> >or Clang+allyesconfig.
> >
> >Keep the masking operation to appease sparse (`make C=1`), add back the
> >cast in order to properly select the proper 8b register alias.
> >
> > [Nick: reworded]
> >
> >Cc: stable@vger.kernel.org
> >Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >Link: https://github.com/ClangBuiltLinux/linux/issues/961
> >Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> >Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> >Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> >Reported-by: kernelci.org bot <bot@kernelci.org>
> >Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> >Suggested-by: Ilie Halip <ilie.halip@gmail.com>
> >Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> >Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >---
> > arch/x86/include/asm/bitops.h | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/bitops.h
> >b/arch/x86/include/asm/bitops.h
> >index b392571c1f1d..139122e5b25b 100644
> >--- a/arch/x86/include/asm/bitops.h
> >+++ b/arch/x86/include/asm/bitops.h
> >@@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> >       if (__builtin_constant_p(nr)) {
> >               asm volatile(LOCK_PREFIX "orb %1,%0"
> >                       : CONST_MASK_ADDR(nr, addr)
> >-                      : "iq" (CONST_MASK(nr) & 0xff)
> >+                      : "iq" ((u8)(CONST_MASK(nr) & 0xff))
> >                       : "memory");
> >       } else {
> >               asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> >@@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> >       if (__builtin_constant_p(nr)) {
> >               asm volatile(LOCK_PREFIX "andb %1,%0"
> >                       : CONST_MASK_ADDR(nr, addr)
> >-                      : "iq" (CONST_MASK(nr) ^ 0xff));
> >+                      : "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> >       } else {
> >               asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> >                       : : RLONG_ADDR(addr), "Ir" (nr) : "memory");
>
> Drop & 0xff and change ^ 0xff to ~.
>
> The redundancy is confusing.

Thanks for the review.  While I would also like to have less
redundancy, we have ourselves a catch-22 that that won't resolve.

Without the cast to u8, gcc and clang will not select low-8-bit
registers required for the `b` suffix on `orb` and `andb`, which
results in an assembler error.
Without the mask, sparse will warn about the upper bytes of the value
being truncated.
(I guess that would have been a more concise commit message).
-- 
Thanks,
~Nick Desaulniers
