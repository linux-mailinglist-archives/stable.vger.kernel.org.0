Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2487F247F7F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHRH3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHRH3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 03:29:52 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86FC7208B3;
        Tue, 18 Aug 2020 07:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597735791;
        bh=dWTUC1fFQYcq9xj79KofFxMFTVMIj82URXFAR3kd498=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mebGcVMemOIARqitXyHsXvB1+ymMhvaDQ2dhbGfkbf2zo9fxLpInApPYAKZqjHbQ8
         wxZ3h2VTPF6CxlEa5dcZAnJyT5Tll3eynk2NFC5OuYypVx075W82G7bfmujqRWvZIY
         J2SrEWZ2+r6j5/YDP8iQfu7Eai61sCiVt1OzS92E=
Received: by mail-ot1-f51.google.com with SMTP id q9so15527515oth.5;
        Tue, 18 Aug 2020 00:29:51 -0700 (PDT)
X-Gm-Message-State: AOAM531Xm2+HmisYsLQ+SVKPdDuQumWOfJ6dexJdHv0FElfLLwKmKCBq
        wRf1oIaYT6MK5v0AFHgwha+Dt1UnWXVZb8YmIso=
X-Google-Smtp-Source: ABdhPJw5l/iLYjUWeYo8U/CoNBj00ngiBw9q35ZJ9OgGlkuBvd2jJgj8iBbTiT998ynF/uVt02W7p/SsFEST/JG26Y8=
X-Received: by 2002:a9d:774d:: with SMTP id t13mr13589334otl.108.1597735790648;
 Tue, 18 Aug 2020 00:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200817220212.338670-1-ndesaulniers@google.com>
 <20200817220212.338670-2-ndesaulniers@google.com> <CAMj1kXH0gRCaoF0NziC870=eSEy0ghi8b0b6A+LMu8PMd58C0Q@mail.gmail.com>
 <20200818072531.GC9254@kroah.com>
In-Reply-To: <20200818072531.GC9254@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Aug 2020 09:29:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF_RhV7D8D8J_fwTruiKWbHapeGe-omwyBoR8t4gRv7QA@mail.gmail.com>
Message-ID: <CAMj1kXF_RhV7D8D8J_fwTruiKWbHapeGe-omwyBoR8t4gRv7QA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, X86 ML <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Aug 2020 at 09:25, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 18, 2020 at 09:10:01AM +0200, Ard Biesheuvel wrote:
> > On Tue, 18 Aug 2020 at 00:02, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > LLVM implemented a recent "libcall optimization" that lowers calls to
> > > `sprintf(dest, "%s", str)` where the return value is used to
> > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > > in parsing format strings. This optimization was introduced into
> > > clang-12. Because the kernel does not provide an implementation of
> > > stpcpy, we observe linkage failures for almost all targets when building
> > > with ToT clang.
> > >
> > > The interface is unsafe as it does not perform any bounds checking.
> > > Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
> > >
> > > Unlike
> > > commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> > > which cited failures with `-fno-builtin-*` flags being retained in LLVM
> > > LTO, that bug seems to have been fixed by
> > > https://reviews.llvm.org/D71193, so the above sha can now be reverted in
> > > favor of `-fno-builtin-bcmp`.
> > >
> > > Cc: stable@vger.kernel.org # 4.4
> >
> > Why does a fix for Clang-12 have to be backported all the way to v4.4?
> > How does that meet the requirements for stable patches?
>
> Because people like to build older kernels with new compliler versions.
>
> And those "people" include me, who doesn't want to keep around old
> compilers just because my distro moved to the latest one...
>
> We've been doing this for the past 4+ years, for new versions of gcc,
> keeping 4.4.y building properly with the bleeding edge of that compiler,
> why is clang any different here?
>

Fair enough. I am just struggling to match stable-kernel-rules.rst
with the actual practices - perhaps it is time to update that
document?
