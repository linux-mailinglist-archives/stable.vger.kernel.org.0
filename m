Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299E40B687
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhINSJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhINSI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:08:59 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08686C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:07:42 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x27so252359lfu.5
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3LcleCyQejxBVnL1gHK5Ml8Ct7D8qIRwQuOYhtFgac=;
        b=X71b0zQ2wGoAuVLzm8erz3OLJ3uPMMI+ndfU/ktAOFgGN+lzL6SzYMnqL9wjsgmpQ3
         0DyFMa2cfBC/F3LP/x5XVHq1nMkdyPtZ1MdXrqJVFTWdvqURK4C23eUUO+A09H01BKTf
         wVumGhHsryACyibjnzaHGmTSZcd5/YCZyH6g5V6MgBAFoLWVZpEIh19dIMsQKR0XlnN+
         7UmkkNl94fSfW17y98IOxfCDRmknEMzIXbM2uU7rJKTZtqW2xfwebbK+eG8l49z6DMYN
         99jJeENGIFhPCtvyFYqcZgr+NM10czBoma+Wb6l6oSIY4BTztRglsu6oTHVkdud73N0z
         +U6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3LcleCyQejxBVnL1gHK5Ml8Ct7D8qIRwQuOYhtFgac=;
        b=g7O5TCCPkBgkuuXjGJqGUsvt6uQ3qTVcyCnxMrVA2NhWe4aX/ZKhm/QUzizxbAWDiL
         TJY0BnRrOECpLT0tnjKPfjSvIwYwl4qgX/88i7RK1LkeNoIvWQFZpQxHOKOt708kshSC
         +JE67IW75Q5/Dbb7ZB8s5c9qQdzpT58pvu6jlViDzeJP4QvXX3SiRBmFCUCAe+w9uTHf
         rQfHpaI6cihA2L66Dxs9D5S+xWO09gzZmOZAobEiMzXhW7vnwRpfesauuAEqMJIc0+7k
         q653Y8ypB/UcZARJ6ybWAMNYxDOp9pZupfx67y0Jpb+OqKldP3r2oHVUfmG32lSzLJGm
         UYzg==
X-Gm-Message-State: AOAM5312kYZt1IJDcWmos1JeK/pq0iGvPbEHwZVjGeBLs3xCEfgT70GW
        sjBuVCgTbBgQ1HA2fgtgBzqCvy7yAQz/6u314UVjyg==
X-Google-Smtp-Source: ABdhPJxM2b+IX/1XgziSV6WmB6mAYV7QszQ/gKtVufEnGaNJI7CDLcX1S/ngTIFG5hspDHdKO8I0SPAbE875Ur52efM=
X-Received: by 2002:a05:6512:3b9e:: with SMTP id g30mr13789622lfv.651.1631642860162;
 Tue, 14 Sep 2021 11:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
 <20210914002318.2298583-1-ndesaulniers@google.com> <YUDaRwL7h6qJ+7/P@kroah.com>
In-Reply-To: <YUDaRwL7h6qJ+7/P@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 14 Sep 2021 11:07:28 -0700
Message-ID: <CAKwvOdmTuSPMQRHiCAs6a3i8V3CMdBDA72xH4SDXYDVArHRTvw@mail.gmail.com>
Subject: Re: [PATCH v2] overflow.h: use new generic division helpers to avoid
 / operator
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  s On Tue, Sep 14, 2021 at 10:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 05:23:18PM -0700, Nick Desaulniers wrote:
> > commit fad7cd3310db ("nbd: add the check to prevent overflow in
> > __nbd_ioctl()") raised an issue from the fallback helpers added in
> > commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> > add fallback code")
> >
> > ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!
> >
> > As Stephen Rothwell notes:
> >   The added check_mul_overflow() call is being passed 64 bit values.
> >   COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
> >   include/linux/overflow.h).
> >
> > Specifically, the helpers for checking whether the results of a
> > multiplication overflowed (__unsigned_mul_overflow,
> > __signed_add_overflow) use the division operator when
> > !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
> > operands on 32b hosts.
> >
> > This was fixed upstream by
> > commit 76ae847497bc ("Documentation: raise minimum supported version of
> > GCC to 5.1")
> > which is not suitable to be backported to stable; I didn't have this
> > patch ready in time.
> >
> > Cc: stable@vger.kernel.org
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Pavel Machek <pavel@ucw.cz>
> > Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1438
> > Fixes: f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> > add fallback code")
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> > Changes v1 -> v2:
> > * Change the BUILD_BUG_ON_MSG's to check the divisor! Not the dividend!
> > * Change __builtin_choose_expr/__builtin_constant_p soup to _Generic as
> >   per Linus.
> > * Add Linus' Suggested-by.
> > * use __ prefixes on new macros.
> > * add parens around use of macro parameters.
> > * realign trailing \.
> >
> > Note to Rasmus: I did not include comments on the usage. I don't think
> > we really intend for folks to be using these, much less so in -stable.
> >
> >  include/linux/math64.h   | 37 +++++++++++++++++++++++++++++++++++++
> >  include/linux/overflow.h |  8 ++++----
> >  2 files changed, 41 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/math64.h b/include/linux/math64.h
> > index 66deb1fdc2ef..a1a6ad98b5ea 100644
> > --- a/include/linux/math64.h
> > +++ b/include/linux/math64.h
> > @@ -10,6 +10,9 @@
> >
> >  #define div64_long(x, y) div64_s64((x), (y))
> >  #define div64_ul(x, y)   div64_u64((x), (y))
> > +#ifndef is_signed_type
> > +#define is_signed_type(type)       (((type)(-1)) < (type)1)
> > +#endif
> >
> >  /**
> >   * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> > @@ -111,6 +114,15 @@ extern s64 div64_s64(s64 dividend, s64 divisor);
> >
> >  #endif /* BITS_PER_LONG */
> >
> > +#define __div64_x64(dividend, divisor) ({            \
> > +     BUILD_BUG_ON_MSG(sizeof(divisor) < sizeof(u64), \
> > +                      "prefer __div_x64");           \
> > +     __builtin_choose_expr(                          \
> > +             is_signed_type(typeof(dividend)),       \
> > +             div64_s64((dividend), (divisor)),       \
> > +             div64_u64((dividend), (divisor)));      \
> > +})
> > +
> >  /**
> >   * div_u64 - unsigned 64bit divide with 32bit divisor
> >   * @dividend: unsigned 64bit dividend
> > @@ -141,6 +153,31 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
> >  }
> >  #endif
> >
> > +#define __div_x64(dividend, divisor) ({                      \
> > +     BUILD_BUG_ON_MSG(sizeof(divisor) > sizeof(u32), \
> > +                      "prefer __div64_x64");         \
> > +     __builtin_choose_expr(                          \
> > +             is_signed_type(typeof(dividend)),       \
> > +             div_s64((dividend), (divisor)),         \
> > +             div_u64((dividend), (divisor)));        \
> > +})
> > +
> > +#define __div_64(dividend, divisor)                  \
> > +     _Generic((divisor),                             \
> > +     s64: __div64_x64((dividend), (divisor)),        \
> > +     u64: __div64_x64((dividend), (divisor)),        \
> > +     default: __div_x64((dividend), (divisor)))
> > +
> > +#define div_64(dividend, divisor) ({                         \
> > +     BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64) ||      \
> > +                      sizeof(divisor) > sizeof(u64),         \
> > +                      "128b div unsupported");               \
> > +     _Generic((dividend),                                    \
> > +     s64: __div_64((dividend), (divisor)),                   \
> > +     u64: __div_64((dividend), (divisor)),                   \
> > +     default: (dividend) / (divisor));                       \
> > +})
> > +
> >  u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
> >
> >  #ifndef mul_u32_u32
> > diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> > index ef74051d5cfe..2ebdf220c184 100644
> > --- a/include/linux/overflow.h
> > +++ b/include/linux/overflow.h
> > @@ -123,8 +123,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
> >       (void) (&__a == __d);                           \
> >       *__d = __a * __b;                               \
> >       __builtin_constant_p(__b) ?                     \
> > -       __b > 0 && __a > type_max(typeof(__a)) / __b : \
> > -       __a > 0 && __b > type_max(typeof(__b)) / __a;  \
> > +       __b > 0 && __a > div_64(type_max(typeof(__a)), __b) : \
> > +       __a > 0 && __b > div_64(type_max(typeof(__b)), __a);  \
> >  })
> >
> >  /*
> > @@ -195,8 +195,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
> >       (void) (&__a == &__b);                                          \
> >       (void) (&__a == __d);                                           \
> >       *__d = (u64)__a * (u64)__b;                                     \
> > -     (__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||        \
> > -     (__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
> > +     (__b > 0 && (__a > div_64(__tmax, __b) || __a < div_64(__tmin, __b))) ||                \
> > +     (__b < (typeof(__b))-1 && (__a > div_64(__tmin, __b) || __a < div_64(__tmax, __b))) ||  \
> >       (__b == (typeof(__b))-1 && __a == __tmin);                      \
> >  })
> >
> >
> > base-commit: cb83afdc0b865d7c8a74d2b2a1f7dd393e1d196d
> > --
> > 2.33.0.309.g3052b89438-goog
> >
>
> Why is this needed in the 5.10.y tree?  I see that commit fad7cd3310db
> ("nbd: add the check to prevent overflow in __nbd_ioctl()") is planned
> to go into 5.14.y and 5.13.y, but no further back at the moment.

Ah, sorry, should I rebase this on 5.14.y to make it easier to apply?

As to why fix this in earlier trees, the patch that introduced the
issue technically is f0907827a8a9, which landed in v4.18-rc1.
fad7cd3310db may have exposed it; without fad7cd3310db maybe there are
no other problematic callers today, BUT there might be more in the
future.  I'd rather fix this properly, so that we can fearlessly
backport more patches in the future, and encourage the use of the
check_mul_overflow() helpers further in the kernel.


Also, the reason why I'm looking at this at all is that clang versions
earlier than 14 actually do not have
COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW. __builtin_mul_overflow() can't
be used on 32b targets with 64b operands.  As you recall, this is
causing a breakage for Android:
https://android-review.googlesource.com/c/kernel/common/+/1820696.
Here's the long thread tracking the issue
https://github.com/ClangBuiltLinux/linux/issues/1438.

To fix this, I'd like to fix the underlying problem, then break up
COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW to differentiate when
__builtin_mul_overflow() can't be used. Or I need to add a missing
symbol from compiler-rt to the kernel.  But first I need the fallback
helpers for !COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW to actually work
(ie. link).

If the only caller today is 5.13.y and newer, then 5.13.y and 5.14.y
are broken when compiling 32b targets with released versions of clang.
Folks can work around it by disabling BLK_DEV_NBD, but it is possible
to fix this.  This is just the Nth minus one yak to shave.


Also, Rasmus asked me to test this, which I did and it LGTM (I think,
I don't know what self test failure looks like).
I downloaded arm-unknown-linux-gnueabi-gcc for gcc-4.9 from kernel.org:
https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.9.0/x86_64-gcc-4.9.0-nolibc_arm-unknown-linux-gnueabi.tar.xz

I enabled CONFIG_TEST_OVERFLOW. I comment out the `BITS_PER_LONG ==
64` guards. I hacked up scripts/dtc/libfdt/fdt.co that it could build.
I applied this patch to stable 5.10.y, then booted it in QEMU:
+ timeout --foreground 3m unbuffer qemu-system-arm -initrd
/android1/boot-utils/images/arm/rootfs.cpio -append 'console=ttyAMA0
earlycon' -machine virt -no-reboot -display none -kernel
/android0/kernel-stable/arch/arm/boot/zImage -m 512m -nodefaults
-serial mon:stdio
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.10.64-00001-g4cbdaa5112d2-dirty
(ndesaulniers@ndesaulniers1.mtv.corp.google.com)
(arm-unknown-linux-gnueabi-gcc (GCC) 4.9.0, GNU ld (GNU Binutils)
2.24) #5 SMP Tue Sep 14 10:44:57 PDT 2021
...
[    1.029997] test_overflow: u64: 17 arithmetic tests
[    1.030407] test_overflow: s64: 21 arithmetic tests
...
[    1.063222] test_overflow: all tests passed
...
-- 
Thanks,
~Nick Desaulniers
