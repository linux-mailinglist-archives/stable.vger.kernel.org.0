Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79621DD61B
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 04:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfJSCBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 22:01:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34002 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfJSCBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 22:01:21 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so9691348ion.1;
        Fri, 18 Oct 2019 19:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h2Om4jrmaYSV3RVSH6Bll8Mfy0zcDVPMDEzdsJPKN50=;
        b=FksOxxu2bx2/tUZaoTAY24KwqRmLnzOCbxsJfqC3PGiDIlTnw3uUj9yS9AuWW1p0Da
         ZkNFN+Jb19tYrz5Fk8sfz9tODFfrEffcIXoM8wOL59g1UC/RKyeSg+cLkUGI68r3y9i8
         0Yyr05+/soI+KJUIFx5xnhza82740QUvpaYgliHvIY1os+e5kneDust13D7HKewZfKhi
         hcxVhZzYX2aO0Dzll5SFA0ZxXmtgvF7P8+NMty4KSUbHWZAi2/pFdhOYjfEld5WVtiMN
         02Bhy9GPN40I3lpPpUBg7e0Q0fjlrAWjQpU9K48Py9d/4mk4NlQhH6zzcyZwOsjkvGNu
         QE5A==
X-Gm-Message-State: APjAAAXxim+o+rYrZd1kz46/nJ1PBhAMh95fFNrgx8S4YtlR5aDNwxp7
        FOXl7F7h29X+vHJSbB/s+BUVf/gpqYfO/JafGyE=
X-Google-Smtp-Source: APXvYqwHrQhnbWkOoQLJVQp2N+es0LAx2Wmn9w8QNgxiqk1apZzW4d5JGiFF1Io/cEidwgaS33xtQf1YEbr309wTW3I=
X-Received: by 2002:a6b:5c0f:: with SMTP id z15mr11805568ioh.173.1571450479050;
 Fri, 18 Oct 2019 19:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <1571367619-13573-1-git-send-email-chenhc@lemote.com> <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com>
In-Reply-To: <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Sat, 19 Oct 2019 10:06:42 +0800
Message-ID: <CAAhV-H6VkW5-hMOrzAQeyHT4pYGExZR6eTRbPHSPK50GAkigCw@mail.gmail.com>
Subject: Re: [PATCH] lib/vdso: Use __arch_use_vsyscall() to indicate fallback
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Andy,

On Fri, Oct 18, 2019 at 11:15 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Thu, Oct 17, 2019 at 7:57 PM Huacai Chen <chenhc@lemote.com> wrote:
> >
> > In do_hres(), we currently use whether the return value of __arch_get_
> > hw_counter() is negtive to indicate fallback, but this is not a good
> > idea. Because:
> >
> > 1, ARM64 returns ULL_MAX but MIPS returns 0 when clock_mode is invalid;
> > 2, For a 64bit counter, a "negtive" value of counter is actually valid.
>
> s/negtive/negative
>
> What's the actual bug?  Is it that MIPS is returning 0 but the check
> is < 0?  Sounds like MIPS should get fixed.
My original bug is what Vincenzo said, MIPS has a boot failure if no
valid clock_mode, and surely MIPS need to fix. However, when I try to
fix it, I found that clock_getres() has another problem, because
__cvdso_clock_getres_common() get vd[CS_HRES_COARSE].hrtimer_res, but
hrtimer_res is set in update_vdso_data() which relies on
__arch_use_vsyscall().

>
> >
> > To solve this problem, we use U64_MAX as the only "invalid" return
> > value -- this is still not fully correct, but has no problem in most
> > cases.
>
> I'm sort of okay with that, but...
>
> > Moreover, all vdso time-related functions should rely on the
> > return value of __arch_use_vsyscall(), because update_vdso_data() and
> > update_vsyscall_tz() also rely on it. So, in the core functions of
> > __cvdso_gettimeofday(), __cvdso_clock_gettime() and __cvdso_clock_
> > getres(), if __arch_use_vsyscall() returns false, we use the fallback
> > functions directly.
>
> __arch_use_vsyscall() is not currently intended for use in the vDSO at all.
>
> >
> > Fixes: 00b26474c2f1613d7ab894c5 ("lib/vdso: Provide generic VDSO implementation")
> > Cc: stable@vger.kernel.org
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Paul Burton <paul.burton@mips.com>
> > Cc: linux-mips@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  arch/arm64/include/asm/vdso/vsyscall.h |  2 +-
> >  arch/mips/include/asm/vdso/vsyscall.h  |  2 +-
> >  include/asm-generic/vdso/vsyscall.h    |  2 +-
> >  lib/vdso/gettimeofday.c                | 12 +++++++++++-
> >  4 files changed, 14 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
> > index 0c731bf..406e6de 100644
> > --- a/arch/arm64/include/asm/vdso/vsyscall.h
> > +++ b/arch/arm64/include/asm/vdso/vsyscall.h
> > @@ -31,7 +31,7 @@ int __arm64_get_clock_mode(struct timekeeper *tk)
> >  #define __arch_get_clock_mode __arm64_get_clock_mode
> >
> >  static __always_inline
> > -int __arm64_use_vsyscall(struct vdso_data *vdata)
> > +int __arm64_use_vsyscall(const struct vdso_data *vdata)
> >  {
> >         return !vdata[CS_HRES_COARSE].clock_mode;
> >  }
> > diff --git a/arch/mips/include/asm/vdso/vsyscall.h b/arch/mips/include/asm/vdso/vsyscall.h
> > index 1953147..8b10dd7 100644
> > --- a/arch/mips/include/asm/vdso/vsyscall.h
> > +++ b/arch/mips/include/asm/vdso/vsyscall.h
> > @@ -29,7 +29,7 @@ int __mips_get_clock_mode(struct timekeeper *tk)
> >  #define __arch_get_clock_mode __mips_get_clock_mode
> >
> >  static __always_inline
> > -int __mips_use_vsyscall(struct vdso_data *vdata)
> > +int __mips_use_vsyscall(const struct vdso_data *vdata)
> >  {
> >         return (vdata[CS_HRES_COARSE].clock_mode != VDSO_CLOCK_NONE);
> >  }
> > diff --git a/include/asm-generic/vdso/vsyscall.h b/include/asm-generic/vdso/vsyscall.h
> > index e94b1978..ac05a625 100644
> > --- a/include/asm-generic/vdso/vsyscall.h
> > +++ b/include/asm-generic/vdso/vsyscall.h
> > @@ -26,7 +26,7 @@ static __always_inline int __arch_get_clock_mode(struct timekeeper *tk)
> >  #endif /* __arch_get_clock_mode */
> >
> >  #ifndef __arch_use_vsyscall
> > -static __always_inline int __arch_use_vsyscall(struct vdso_data *vdata)
> > +static __always_inline int __arch_use_vsyscall(const struct vdso_data *vdata)
> >  {
> >         return 1;
> >  }
> > diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
> > index e630e7f..4ad062e 100644
> > --- a/lib/vdso/gettimeofday.c
> > +++ b/lib/vdso/gettimeofday.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/hrtimer_defs.h>
> >  #include <vdso/datapage.h>
> >  #include <vdso/helpers.h>
> > +#include <vdso/vsyscall.h>
> >
> >  /*
> >   * The generic vDSO implementation requires that gettimeofday.h
> > @@ -50,7 +51,7 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
> >                 cycles = __arch_get_hw_counter(vd->clock_mode);
> >                 ns = vdso_ts->nsec;
> >                 last = vd->cycle_last;
> > -               if (unlikely((s64)cycles < 0))
> > +               if (unlikely(cycles == U64_MAX))
> >                         return -1;
>
> I would actually prefer:
>
> if (unlikely(cycles < last))
>
> or perhaps:
>
> if (unlikely((s64)(cycles-last) < 0))
>
> which would have the nice side effect of getting rid of the annoying
> x86 special case in vdso_calc_delta().  The former version is
> compatible with U64_MAX, whereas the latter version would need the
> error case to return last-1 or similar.  The benefit of the latter
> version is that it can survive wrap-around.
When you say if (unlikely(cycles < last)), do you means if
(unlikely(cycles <= last))? If __arch_get_hw_counter() return U64_MAX
every time, I don't think cycles can be less than last.

Huacai
>
> >
> >                 ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
> > @@ -91,6 +92,9 @@ __cvdso_clock_gettime_common(clockid_t clock, struct __kernel_timespec *ts)
> >         if (unlikely((u32) clock >= MAX_CLOCKS))
> >                 return -1;
> >
> > +       if (!__arch_use_vsyscall(vd))
> > +               return -1;
> > +
>
> NAK.  I don't think this is helpful or correct.  It doesn't appear to
> do anything valid, and it's racy.
>
> >         /*
> >          * Convert the clockid to a bitmask and use it to check which
> >          * clocks are handled in the VDSO directly.
> > @@ -145,6 +149,9 @@ __cvdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
> >  {
> >         const struct vdso_data *vd = __arch_get_vdso_data();
> >
> > +       if (!__arch_use_vsyscall(vd))
> > +               return gettimeofday_fallback(tv, tz);
> > +
>
> Ditto.
>
> >         if (likely(tv != NULL)) {
> >                 struct __kernel_timespec ts;
> >
> > @@ -189,6 +196,9 @@ int __cvdso_clock_getres_common(clockid_t clock, struct __kernel_timespec *res)
> >         if (unlikely((u32) clock >= MAX_CLOCKS))
> >                 return -1;
> >
> > +       if (!__arch_use_vsyscall(vd))
> > +               return -1;
> > +
>
> Ditto.
