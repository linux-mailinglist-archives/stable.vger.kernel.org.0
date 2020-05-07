Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4771C8D2C
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgEGOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgEGOA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 10:00:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2125EC05BD43;
        Thu,  7 May 2020 07:00:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 19so552928ioz.10;
        Thu, 07 May 2020 07:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qCROg/3G32jM70VIbenT2kiJn/D6JsTc3S4qZv2ZxH8=;
        b=JC3IYpfpubvJXlRItx/zmIvRRqwTzlqF/cOmXZ/39Q+O7RJzOJ9fvlLax/MlV9RWgK
         ObH+uqTxqr6B0vhElIBX7EN7KCL87xUdIED9r4OQpGaQ2bFe3i9FDcRoITmVgNM9cF4Y
         8+W2fjWtOs95m/giIJ7gjcdHVZz/rQKk68kY+Q23Q86w46tEPDRQE3SN/ekxvf6ybcah
         3QFwghREZ+vHDgQcWWdF4aou0SAS0BAckUOQ8anWppBNm04IJj6WyZECXA1JgwpwwyP3
         63GaU9YpWFw8BGqQd+4GJrNdKO8lf2dz/Xp9aDsC0CnDhhTZU8id5hr8JtCnr+uWIXmk
         jJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCROg/3G32jM70VIbenT2kiJn/D6JsTc3S4qZv2ZxH8=;
        b=PalSGVpu/MizOWSE4yQ+GwAw+39KysNPbpF5MUjr8Nq2mReHgSrND8EkSmSu221c2I
         AcBpN63jJwx0lMrAWYFIXAXtzB2ytL6bsVxVA/KsSRbUEFePiwHVU+sBQxK494w3BUwO
         YxatGr6+bkrb0nVY2tL+/3sqFbEDKhy7DupZ93Cw416IYY/ERoDvM2cE2aemLa2mFD6O
         hQGlMdLo6f6MWltTDku/jPW5lMj/4L0Na2a6R+aVskzTlFhv4fy+He2V6xZWTJBn0gpG
         MdiHbfOXcD5FZeLAAfma0+M7I4/51gqdVxtVLEgX3IznhvMzviHFXHUrE1xHlfnz1jRZ
         UdJA==
X-Gm-Message-State: AGi0PubJUIWRaAzcC7eQAOLEnNHVWpmSRM2Q4Ijs8PaWiKeCbj7o48xe
        WpIPMyEVLetzcyDId/2pez5BTAArhorQ5TmZEw==
X-Google-Smtp-Source: APiQypIddVNoTzv/ukfpHVvhlTFaZAP2vxu5rWiEOp+1F0cYyz3qV3uMxPi6BT0C/CHWNpnFHhfiorelfIVgCzsriyI=
X-Received: by 2002:a05:6638:f0f:: with SMTP id h15mr14465368jas.142.1588860027498;
 Thu, 07 May 2020 07:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
In-Reply-To: <20200507113422.GA3762@hirez.programming.kicks-ass.net>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Thu, 7 May 2020 10:00:16 -0400
Message-ID: <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
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

On Thu, May 7, 2020 at 7:38 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 05, 2020 at 11:07:24AM -0700, hpa@zytor.com wrote:
> > On May 5, 2020 10:44:22 AM PDT, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> > >@@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> > >     if (__builtin_constant_p(nr)) {
> > >             asm volatile(LOCK_PREFIX "orb %1,%0"
> > >                     : CONST_MASK_ADDR(nr, addr)
> > >-                    : "iq" (CONST_MASK(nr) & 0xff)
> > >+                    : "iq" ((u8)(CONST_MASK(nr) & 0xff))
> > >                     : "memory");
> > >     } else {
> > >             asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> > >@@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> > >     if (__builtin_constant_p(nr)) {
> > >             asm volatile(LOCK_PREFIX "andb %1,%0"
> > >                     : CONST_MASK_ADDR(nr, addr)
> > >-                    : "iq" (CONST_MASK(nr) ^ 0xff));
> > >+                    : "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> > >     } else {
> > >             asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> > >                     : : RLONG_ADDR(addr), "Ir" (nr) : "memory");
> >
> > Drop & 0xff and change ^ 0xff to ~.
>
> But then we're back to sparse being unhappy, no? The thing with ~ is
> that it will set high bits which will be truncated, which makes sparse
> sad.

This change will make sparse happy and allow these cleanups:
#define CONST_MASK(nr)                 ((u8)1 << ((nr) & 7))

Tested with GCC 9.3.1.

--
Brian Gerst
