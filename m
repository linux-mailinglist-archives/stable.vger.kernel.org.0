Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1059C1C8C69
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 15:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEGNci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 09:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgEGNch (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 09:32:37 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7A2C05BD43;
        Thu,  7 May 2020 06:32:37 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 19so454755ioz.10;
        Thu, 07 May 2020 06:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IWNT0grjCY4sGAusEiDjhM/Qhpke9FBN+ida4mrV6O0=;
        b=cK5Jj4DLgzKQcXk2KuajxjCOogoztYExUvzMIIBEZmHQsdfJxe0mhLJuderGZR8ucu
         JfAHoC1OoXxpuWwsy5afVZB/dLh92gN01aasrHoRyJJ1ZmD8+3Q3JnLkqtNzjoduOrEv
         Wk6lkpBhKTthGUcxXcYO6RvwKBQ3bQdK7Uhthl9D1/9ClA2VbzmALiQS77JEqxKARK+H
         MjQBY6v1Ic8GyMLPbUQcD0UYzroJgI9rpUkERaZZhADvtEKKcBXo6cpZhMCmNMVKEqEH
         x26OyvQlgvDDdt77/bfWT8ZQW7e3PMC3EKSFa5MgSaa606Kb3hyrIoWxapnxqGwh3OaM
         s7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IWNT0grjCY4sGAusEiDjhM/Qhpke9FBN+ida4mrV6O0=;
        b=iwqaREHAmU1XdmsjthOJacxeb+AmUktYOiVyQKIdIvpSWoQNtu5rIwLG0/w1i4R5LU
         tD6wi9mYkuSLN8nmzUoMJ2rKVgf122P5eR/eA4drtkZh9GMaGkkzBbxDEMFZoTUMWh5Q
         /MaqLOZmPEUQhhNJu7tqoLv4qNESrvAHPGFZyeviai4yvpV9/ennGuQxVut4lZ3Emzp+
         tb8JubdkNPD8pHO4k9Y+pj1PloDiVC/PwcSAsAdvO4z6jbqhzT3aI8oA1xVW92WIYgVJ
         7VFu88dB3eChTQaQlnOWH2qeUk/H5aaUXBHPJfOkO1FriOWHItAPiW4VgnvXCnzKWigR
         dYBQ==
X-Gm-Message-State: AGi0PuaDd8PNShVFECH1/ywM10ivBGK9DP0U8qeyYFTHOGlhK69/xaCr
        W1c5ySgWvUNTkv5YL1sop2Ab//hBhJPwMKOq7g==
X-Google-Smtp-Source: APiQypJhkcqztWnOBj46QXVCRxQvm/I8L1W+CisoDNHysHqgOJRcDYbzVE/PTx5OmxqWs5cCPu5ghWvZZ+ikI0Qywf0=
X-Received: by 2002:a05:6638:f0f:: with SMTP id h15mr14334812jas.142.1588858355459;
 Thu, 07 May 2020 06:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com> <6A99766A-59FB-42DF-9350-80EA671A42B0@zytor.com>
In-Reply-To: <6A99766A-59FB-42DF-9350-80EA671A42B0@zytor.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Thu, 7 May 2020 09:32:24 -0400
Message-ID: <CAMzpN2iCgr0rb=MCYPGMx8tcfLq2qdzv0h7YnX5hkzBB+O7JJQ@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 3:02 AM <hpa@zytor.com> wrote:
>
> On May 6, 2020 11:18:09 PM PDT, Brian Gerst <brgerst@gmail.com> wrote:
> >On Tue, May 5, 2020 at 1:47 PM Nick Desaulniers
> ><ndesaulniers@google.com> wrote:
> >>
> >> From: Sedat Dilek <sedat.dilek@gmail.com>
> >>
> >> It turns out that if your config tickles __builtin_constant_p via
> >> differences in choices to inline or not, this now produces invalid
> >> assembly:
> >>
> >> $ cat foo.c
> >> long a(long b, long c) {
> >>   asm("orb\t%1, %0" : "+q"(c): "r"(b));
> >>   return c;
> >> }
> >> $ gcc foo.c
> >> foo.c: Assembler messages:
> >> foo.c:2: Error: `%rax' not allowed with `orb'
> >>
> >> The "q" constraint only has meanting on -m32 otherwise is treated as
> >> "r".
> >>
> >> This is easily reproducible via
> >Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> >> or Clang+allyesconfig.
> >>
> >> Keep the masking operation to appease sparse (`make C=1`), add back
> >the
> >> cast in order to properly select the proper 8b register alias.
> >>
> >>  [Nick: reworded]
> >>
> >> Cc: stable@vger.kernel.org
> >> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/961
> >> Link:
> >https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> >> Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> >> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> Reported-by: kernelci.org bot <bot@kernelci.org>
> >> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> >> Suggested-by: Ilie Halip <ilie.halip@gmail.com>
> >> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> >> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >> ---
> >>  arch/x86/include/asm/bitops.h | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/bitops.h
> >b/arch/x86/include/asm/bitops.h
> >> index b392571c1f1d..139122e5b25b 100644
> >> --- a/arch/x86/include/asm/bitops.h
> >> +++ b/arch/x86/include/asm/bitops.h
> >> @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> >>         if (__builtin_constant_p(nr)) {
> >>                 asm volatile(LOCK_PREFIX "orb %1,%0"
> >>                         : CONST_MASK_ADDR(nr, addr)
> >> -                       : "iq" (CONST_MASK(nr) & 0xff)
> >> +                       : "iq" ((u8)(CONST_MASK(nr) & 0xff))
> >
> >I think a better fix would be to make CONST_MASK() return a u8 value
> >rather than have to cast on every use.
> >
> >Also I question the need for the "q" constraint.  It was added in
> >commit 437a0a54 as a workaround for GCC 3.4.4.  Now that the minimum
> >GCC version is 4.6, is this still necessary?
> >
> >--
> >Brian Gerst
>
> Yes, "q" is needed on i386.

I think the bug this worked around was that the compiler didn't detect
that CONST_MASK(nr) was also constant and doesn't need to be put into
a register.  The question is does that bug still exist on compiler
versions we care about?

--
Brian Gerst
