Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E19140B68F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhINSN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhINSN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 14:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F87610A6;
        Tue, 14 Sep 2021 18:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631643130;
        bh=QDQWMvgvvwlEnTcAZ1uergaH8i2/g/jkzW/HTyDMdyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CsNTOg31S8gj1Y+NZ5IEKuV9tNPl/kaysKwMS+imq6VYW+xguUdRq4k0f6XumaITJ
         wgJ/SzEaMXbyywBwD30Cssnf88Ke4jifc7fM61EeMk2+a3VL2BsK/g+0XRz1rDpVgJ
         cJ8yYen+Rr+KGP1qtIACAuMNMJ5KN+9g919g3cwg=
Date:   Tue, 14 Sep 2021 20:12:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] overflow.h: use new generic division helpers to avoid
 / operator
Message-ID: <YUDl9FOfqn116yqj@kroah.com>
References: <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk>
 <20210914002318.2298583-1-ndesaulniers@google.com>
 <YUDaRwL7h6qJ+7/P@kroah.com>
 <CAKwvOdmTuSPMQRHiCAs6a3i8V3CMdBDA72xH4SDXYDVArHRTvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmTuSPMQRHiCAs6a3i8V3CMdBDA72xH4SDXYDVArHRTvw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 11:07:28AM -0700, Nick Desaulniers wrote:
>   s On Tue, Sep 14, 2021 at 10:22 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Sep 13, 2021 at 05:23:18PM -0700, Nick Desaulniers wrote:
> > > commit fad7cd3310db ("nbd: add the check to prevent overflow in
> > > __nbd_ioctl()") raised an issue from the fallback helpers added in
> > > commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> > > add fallback code")
> > >
> > > ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!
> > >
> > > As Stephen Rothwell notes:
> > >   The added check_mul_overflow() call is being passed 64 bit values.
> > >   COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
> > >   include/linux/overflow.h).
> > >
> > > Specifically, the helpers for checking whether the results of a
> > > multiplication overflowed (__unsigned_mul_overflow,
> > > __signed_add_overflow) use the division operator when
> > > !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
> > > operands on 32b hosts.
> > >
> > > This was fixed upstream by
> > > commit 76ae847497bc ("Documentation: raise minimum supported version of
> > > GCC to 5.1")
> > > which is not suitable to be backported to stable; I didn't have this
> > > patch ready in time.
> > >
> > > Cc: stable@vger.kernel.org
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Suggested-by: Pavel Machek <pavel@ucw.cz>
> > > Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1438
> > > Fixes: f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> > > add fallback code")
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > > Changes v1 -> v2:
> > > * Change the BUILD_BUG_ON_MSG's to check the divisor! Not the dividend!
> > > * Change __builtin_choose_expr/__builtin_constant_p soup to _Generic as
> > >   per Linus.
> > > * Add Linus' Suggested-by.
> > > * use __ prefixes on new macros.
> > > * add parens around use of macro parameters.
> > > * realign trailing \.
> > >
> > > Note to Rasmus: I did not include comments on the usage. I don't think
> > > we really intend for folks to be using these, much less so in -stable.
> > >
> > >  include/linux/math64.h   | 37 +++++++++++++++++++++++++++++++++++++
> > >  include/linux/overflow.h |  8 ++++----
> > >  2 files changed, 41 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/linux/math64.h b/include/linux/math64.h
> > > index 66deb1fdc2ef..a1a6ad98b5ea 100644
> > > --- a/include/linux/math64.h
> > > +++ b/include/linux/math64.h
> > > @@ -10,6 +10,9 @@
> > >
> > >  #define div64_long(x, y) div64_s64((x), (y))
> > >  #define div64_ul(x, y)   div64_u64((x), (y))
> > > +#ifndef is_signed_type
> > > +#define is_signed_type(type)       (((type)(-1)) < (type)1)
> > > +#endif
> > >
> > >  /**
> > >   * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> > > @@ -111,6 +114,15 @@ extern s64 div64_s64(s64 dividend, s64 divisor);
> > >
> > >  #endif /* BITS_PER_LONG */
> > >
> > > +#define __div64_x64(dividend, divisor) ({            \
> > > +     BUILD_BUG_ON_MSG(sizeof(divisor) < sizeof(u64), \
> > > +                      "prefer __div_x64");           \
> > > +     __builtin_choose_expr(                          \
> > > +             is_signed_type(typeof(dividend)),       \
> > > +             div64_s64((dividend), (divisor)),       \
> > > +             div64_u64((dividend), (divisor)));      \
> > > +})
> > > +
> > >  /**
> > >   * div_u64 - unsigned 64bit divide with 32bit divisor
> > >   * @dividend: unsigned 64bit dividend
> > > @@ -141,6 +153,31 @@ static inline s64 div_s64(s64 dividend, s32 divisor)
> > >  }
> > >  #endif
> > >
> > > +#define __div_x64(dividend, divisor) ({                      \
> > > +     BUILD_BUG_ON_MSG(sizeof(divisor) > sizeof(u32), \
> > > +                      "prefer __div64_x64");         \
> > > +     __builtin_choose_expr(                          \
> > > +             is_signed_type(typeof(dividend)),       \
> > > +             div_s64((dividend), (divisor)),         \
> > > +             div_u64((dividend), (divisor)));        \
> > > +})
> > > +
> > > +#define __div_64(dividend, divisor)                  \
> > > +     _Generic((divisor),                             \
> > > +     s64: __div64_x64((dividend), (divisor)),        \
> > > +     u64: __div64_x64((dividend), (divisor)),        \
> > > +     default: __div_x64((dividend), (divisor)))
> > > +
> > > +#define div_64(dividend, divisor) ({                         \
> > > +     BUILD_BUG_ON_MSG(sizeof(dividend) > sizeof(u64) ||      \
> > > +                      sizeof(divisor) > sizeof(u64),         \
> > > +                      "128b div unsupported");               \
> > > +     _Generic((dividend),                                    \
> > > +     s64: __div_64((dividend), (divisor)),                   \
> > > +     u64: __div_64((dividend), (divisor)),                   \
> > > +     default: (dividend) / (divisor));                       \
> > > +})
> > > +
> > >  u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
> > >
> > >  #ifndef mul_u32_u32
> > > diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> > > index ef74051d5cfe..2ebdf220c184 100644
> > > --- a/include/linux/overflow.h
> > > +++ b/include/linux/overflow.h
> > > @@ -123,8 +123,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
> > >       (void) (&__a == __d);                           \
> > >       *__d = __a * __b;                               \
> > >       __builtin_constant_p(__b) ?                     \
> > > -       __b > 0 && __a > type_max(typeof(__a)) / __b : \
> > > -       __a > 0 && __b > type_max(typeof(__b)) / __a;  \
> > > +       __b > 0 && __a > div_64(type_max(typeof(__a)), __b) : \
> > > +       __a > 0 && __b > div_64(type_max(typeof(__b)), __a);  \
> > >  })
> > >
> > >  /*
> > > @@ -195,8 +195,8 @@ static inline bool __must_check __must_check_overflow(bool overflow)
> > >       (void) (&__a == &__b);                                          \
> > >       (void) (&__a == __d);                                           \
> > >       *__d = (u64)__a * (u64)__b;                                     \
> > > -     (__b > 0   && (__a > __tmax/__b || __a < __tmin/__b)) ||        \
> > > -     (__b < (typeof(__b))-1  && (__a > __tmin/__b || __a < __tmax/__b)) || \
> > > +     (__b > 0 && (__a > div_64(__tmax, __b) || __a < div_64(__tmin, __b))) ||                \
> > > +     (__b < (typeof(__b))-1 && (__a > div_64(__tmin, __b) || __a < div_64(__tmax, __b))) ||  \
> > >       (__b == (typeof(__b))-1 && __a == __tmin);                      \
> > >  })
> > >
> > >
> > > base-commit: cb83afdc0b865d7c8a74d2b2a1f7dd393e1d196d
> > > --
> > > 2.33.0.309.g3052b89438-goog
> > >
> >
> > Why is this needed in the 5.10.y tree?  I see that commit fad7cd3310db
> > ("nbd: add the check to prevent overflow in __nbd_ioctl()") is planned
> > to go into 5.14.y and 5.13.y, but no further back at the moment.
> 
> Ah, sorry, should I rebase this on 5.14.y to make it easier to apply?

Well I can't add patches to older kernels only if the same issue is in
newer ones :(

> 
> As to why fix this in earlier trees, the patch that introduced the
> issue technically is f0907827a8a9, which landed in v4.18-rc1.
> fad7cd3310db may have exposed it; without fad7cd3310db maybe there are
> no other problematic callers today, BUT there might be more in the
> future.  I'd rather fix this properly, so that we can fearlessly
> backport more patches in the future, and encourage the use of the
> check_mul_overflow() helpers further in the kernel.
> 
> 
> Also, the reason why I'm looking at this at all is that clang versions
> earlier than 14 actually do not have
> COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW. __builtin_mul_overflow() can't
> be used on 32b targets with 64b operands.  As you recall, this is
> causing a breakage for Android:
> https://android-review.googlesource.com/c/kernel/common/+/1820696.
> Here's the long thread tracking the issue
> https://github.com/ClangBuiltLinux/linux/issues/1438.
> 
> To fix this, I'd like to fix the underlying problem, then break up
> COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW to differentiate when
> __builtin_mul_overflow() can't be used. Or I need to add a missing
> symbol from compiler-rt to the kernel.  But first I need the fallback
> helpers for !COMPLER_HAS_GENERIC_BUILTIN_OVERFLOW to actually work
> (ie. link).
> 
> If the only caller today is 5.13.y and newer, then 5.13.y and 5.14.y
> are broken when compiling 32b targets with released versions of clang.
> Folks can work around it by disabling BLK_DEV_NBD, but it is possible
> to fix this.  This is just the Nth minus one yak to shave.

Ok, then it looks like I need patches for 4.19, 5.4, 5.10 and 5.14 for
this (5.13 if you really want, it's only going to be alive for a few
more days so maybe don't worry...)

thanks,

greg k-h
