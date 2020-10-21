Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502CC294885
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 08:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395254AbgJUG6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 02:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395250AbgJUG6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 02:58:47 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA82C222C8;
        Wed, 21 Oct 2020 06:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603263525;
        bh=HCDpOlkrYf0tu+Yw3iNnrhQSsyD2BzFg+xP/8bkolfQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0NQCd3AGi9iCQKjo3ZNpvM4mePupcTendX306htMlGVoSO78PvLm//8ebF4HVOfoI
         VyZUSFqB3SHW+rYz6BobqKyklsms3KNr/0tQ0+mDJDhHNaljIGDAX9/c5ukx6sMoKa
         ig0jO+m8JzyuCgxfjB6RhP+bS23mLuKYy36YhbYQ=
Received: by mail-ot1-f54.google.com with SMTP id m22so957323ots.4;
        Tue, 20 Oct 2020 23:58:45 -0700 (PDT)
X-Gm-Message-State: AOAM533eKB+XyGMLUJRewUwdR25CIsPcSbPlIbT0dV5SspsJo3DBLUs9
        JCNp6YQBQpottw84KFHPwx4rWool8X+Mww8r44M=
X-Google-Smtp-Source: ABdhPJz6uJtrb0cIGFFNcmG4KnX5jyMXa2EzIi1iD/nYWLK0PRV6ntqXzi8mQm+LdfoKfUWvF20/3xvaaE9KiQlEooI=
X-Received: by 2002:a9d:6c92:: with SMTP id c18mr1505523otr.108.1603263524916;
 Tue, 20 Oct 2020 23:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201016175339.2429280-1-ndesaulniers@google.com>
 <160319373854.2175971.17968938488121846972.b4-ty@kernel.org> <CAKwvOd=ZJjYOVubjHN6DFuopMP7jg9PAxGHhOPVu6KefPMNfkg@mail.gmail.com>
In-Reply-To: <CAKwvOd=ZJjYOVubjHN6DFuopMP7jg9PAxGHhOPVu6KefPMNfkg@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 21 Oct 2020 08:58:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF-PFjG7sfdgCsnW-u-bd5yg+j3EiZUO8jYHMnb7bDttw@mail.gmail.com>
Message-ID: <CAMj1kXF-PFjG7sfdgCsnW-u-bd5yg+j3EiZUO8jYHMnb7bDttw@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Will Deacon <will@kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Oct 2020 at 22:16, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Oct 20, 2020 at 10:57 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Fri, 16 Oct 2020 10:53:39 -0700, Nick Desaulniers wrote:
> > > With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
> > > CONFIG_RELOCATABLE=n, we observe the following failure when trying to
> > > link the kernel image with LD=ld.lld:
> > >
> > > error: section: .exit.data is not contiguous with other relro sections
> > >
> > > ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
> > > was previously fixed, but only for CONFIG_RELOCATABLE=y.
> >
> > Applied to arm64 (for-next/core), thanks!
> >
> > [1/1] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
> >       https://git.kernel.org/arm64/c/3b92fa7485eb
>
> IF we wanted to go further and remove `-z norelro`, or even enable `-z
> relro` for aarch64, then we would have to detangle some KASAN/GCOV
> generated section discard spaghetti.

Why on earth would we want that?

> Fangrui did some more digging
> and found that .fini_array.* sections were relro (read only after
> relocations, IIUC), so adding them to EXIT_DATA
> (include/asm-generic/vmlinux.lds.h) was causing them to get included
> in .exit.data (arch/arm64/kernel/vmlinux.lds.S) making that relro.
> There's some history here with commits:
>
> - e41f501d39126 ("vmlinux.lds: account for destructor sections")
> - 8dcf86caa1e3da ("vmlinux.lds.h: Fix incomplete .text.exit discards")
> - d812db78288d7 ("vmlinux.lds.h: Avoid KASAN and KCSAN's unwanted sections")
>
> It seems the following works for quite a few different
> configs/toolchains I played with, but the big IF is whether enabling
> `-z relro` is worthwhile?  If the kernel does respect that mapping,
> then I assume that's a yes, but I haven't checked yet whether relro is
> respected within the kernel (`grep -rn RELRO` turns up nothing
> interesting).  I also haven't checked yet whether all supported
> versions of GNU ld.bfd support -z relro (guessing not, since a quick
> test warns: `aarch64-linux-gnu-ld: warning: -z relro ignored` for
> v2.34.90.20200706, may be holding it wrong).
>

RELRO just moves statically initialized const pointers into a separate
section so we can place it in a way that allows us to easily map it
r/w during load, and switch it over to r/o once the relocations have
been applied.

On AArch64, we don't even use -fpic to build the kernel, and load time
relocations may appear everywhere in .text, .rodata etc etc, which is
absolutely fine given that we apply the relocations way before we
finalize the kernel mappings. This means that, in our case, statically
initialized const pointers will be mapped r/o already, and we don't
need RELRO.

In general, we should ensure that the 'relocatable bare metal' case
doesn't get snowed under, as toolchain development is [understandably]
very focused on hosted binaries that use shared libraries, where
things like CoW footprint, ELF symbol preemption, text relocations and
RELRO sections actually matter. For bare metal, it is quite the
opposite: text relocations are fine, there is no CoW so minimizing the
footprint of the .so pages that are modified due to relocations is
unnecessary, and symbols cannot be preempted either. So many of the
shared library tricks actually make things worse for us, because we
have to work around them while they have no benefit for us.

I have suggested this before, but perhaps we should have a
-mcmodel=kernel (like x86 does) that takes these things into account?
As a start, it could imply -cmodel=small (which we rely on today), but
with guarantees that the generated code is position independent, but
without GOT indirections, and that the resulting object code can be
linked with -pie (so that we have access to the load time relocations
in the bare metal binary itself). This is something we rely on today,
and happens to work in practice, but this could easily break in the
future.




> (Fangrui also filed https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97507
> in regards to GCOV+GCC)
>
> diff --git a/include/asm-generic/vmlinux.lds.h
> b/include/asm-generic/vmlinux.lds.h
> index cd14444bf600..64578c998e53 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -744,7 +744,6 @@
>
>  #define EXIT_DATA                                                      \
>         *(.exit.data .exit.data.*)                                      \
> -       *(.fini_array .fini_array.*)                                    \
>         *(.dtors .dtors.*)                                              \
>         MEM_DISCARD(exit.data*)                                         \
>         MEM_DISCARD(exit.rodata*)
> @@ -995,6 +994,7 @@
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KCSAN)
>  # ifdef CONFIG_CONSTRUCTORS
>  #  define SANITIZER_DISCARDS                                           \
> +       *(.fini_array .fini_array.*)                                    \
>         *(.eh_frame)
>  # else
>  #  define SANITIZER_DISCARDS                                           \
> @@ -1005,8 +1005,16 @@
>  # define SANITIZER_DISCARDS
>  #endif
>
> +#if defined(CONFIG_GCOV_KERNEL) && defined(CONFIG_CC_IS_GCC)
> +# define GCOV_DISCARDS                                                 \
> +       *(.fini_array .fini_array.*)
> +#else
> +# define GCOV_DISCARDS
> +#endif
> +
>  #define COMMON_DISCARDS
>          \
>         SANITIZER_DISCARDS                                              \
> +       GCOV_DISCARDS                                                   \
>         *(.discard)                                                     \
>         *(.discard.*)                                                   \
>         *(.modinfo)                                                     \
> --
> Thanks,
> ~Nick Desaulniers
