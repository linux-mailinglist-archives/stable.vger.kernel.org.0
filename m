Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C5247F8D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHRHdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgHRHdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 03:33:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00D2B206B5;
        Tue, 18 Aug 2020 07:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597736024;
        bh=+l8ZIHYYdE8RD9Qj/I64++AlJvGHPOqSiV3mJ2HpmNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=adtLg8XGFdMJbAYwQ+USeWVHO6NJasnpN07UEjD5SyBJk/l55Cyn+jXV7Zsbuyfsf
         9swaGL4dFOyfw4m8JELBW45/YfY66lEL1n7z1a8qWfDnRwyNp8SVu/X/LOUKv+5Qnw
         kZSl+rMuFLYRfnbJywcZ11LdpXjqXbOoyo0hqsmA=
Date:   Tue, 18 Aug 2020 09:34:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
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
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
Message-ID: <20200818073408.GA12514@kroah.com>
References: <20200817220212.338670-1-ndesaulniers@google.com>
 <20200817220212.338670-2-ndesaulniers@google.com>
 <CAMj1kXH0gRCaoF0NziC870=eSEy0ghi8b0b6A+LMu8PMd58C0Q@mail.gmail.com>
 <20200818072531.GC9254@kroah.com>
 <CAMj1kXF_RhV7D8D8J_fwTruiKWbHapeGe-omwyBoR8t4gRv7QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF_RhV7D8D8J_fwTruiKWbHapeGe-omwyBoR8t4gRv7QA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 09:29:39AM +0200, Ard Biesheuvel wrote:
> On Tue, 18 Aug 2020 at 09:25, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 18, 2020 at 09:10:01AM +0200, Ard Biesheuvel wrote:
> > > On Tue, 18 Aug 2020 at 00:02, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > > >
> > > > LLVM implemented a recent "libcall optimization" that lowers calls to
> > > > `sprintf(dest, "%s", str)` where the return value is used to
> > > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > > > in parsing format strings. This optimization was introduced into
> > > > clang-12. Because the kernel does not provide an implementation of
> > > > stpcpy, we observe linkage failures for almost all targets when building
> > > > with ToT clang.
> > > >
> > > > The interface is unsafe as it does not perform any bounds checking.
> > > > Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
> > > >
> > > > Unlike
> > > > commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> > > > which cited failures with `-fno-builtin-*` flags being retained in LLVM
> > > > LTO, that bug seems to have been fixed by
> > > > https://reviews.llvm.org/D71193, so the above sha can now be reverted in
> > > > favor of `-fno-builtin-bcmp`.
> > > >
> > > > Cc: stable@vger.kernel.org # 4.4
> > >
> > > Why does a fix for Clang-12 have to be backported all the way to v4.4?
> > > How does that meet the requirements for stable patches?
> >
> > Because people like to build older kernels with new compliler versions.
> >
> > And those "people" include me, who doesn't want to keep around old
> > compilers just because my distro moved to the latest one...
> >
> > We've been doing this for the past 4+ years, for new versions of gcc,
> > keeping 4.4.y building properly with the bleeding edge of that compiler,
> > why is clang any different here?
> >
> 
> Fair enough. I am just struggling to match stable-kernel-rules.rst
> with the actual practices - perhaps it is time to update that
> document?

The rules are tiny and simple for 99% of the issues involved.  Stuff
like "add patches to fix build failures and warnings for newer compiler
versions" are so rare (they only happen every 2 years or so), it's not
worth it.

thanks,

greg k-h
