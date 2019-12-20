Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AF61280D1
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 17:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfLTQmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 11:42:01 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:40554 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLTQmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 11:42:00 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E93B472CCE9;
        Fri, 20 Dec 2019 19:41:56 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id B6D284A4AEF;
        Fri, 20 Dec 2019 19:41:56 +0300 (MSK)
Date:   Fri, 20 Dec 2019 19:41:56 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>, stable@vger.kernel.org,
        Vitaly Chikunov <vt@altlinux.org>
Subject: Re: [PATCH] tools lib: Disable redundant-delcs error for strlcpy
Message-ID: <20191220164155.3gxstkam3ctk7kji@altlinux.org>
Mail-Followup-To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>, stable@vger.kernel.org
References: <20191208214607.20679-1-vt@altlinux.org>
 <20191217122331.4g5atx7in6njjlw4@altlinux.org>
 <20191217200420.GD7095@redhat.com>
 <20191220025236.kgu3v6yhjndr3zwb@altlinux.org>
 <20191220123136.GD2032@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191220123136.GD2032@kernel.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arnaldo,

On Fri, Dec 20, 2019 at 09:31:36AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 20, 2019 at 05:52:36AM +0300, Vitaly Chikunov escreveu:
> > If this is acceptable I will resend v2 with this.
> 
> Go ahead, and please let me know if there is any container image for
> Altlinux, as I test with clang on all the distros I have container
> images for, and this hasn't appeared on my radar, i.e. clang + strlcpy
> warnings :-)

ALT Linux container micro how-to:

Docker: https://en.altlinux.org/Docker
  Quick start:
    # docker run -it alt:sisyphus
    [root@28fd15798968 /]# apt-get update
    [root@28fd15798968 /]# apt-get install clang rpm-build

  It will install clang-7.0.

systemd-nspawn:
   Images are at http://ftp.altlinux.org/pub/distributions/ALTLinux/images/Sisyphus/cloud/
   Quick start:
   # machinectl pull-tar --verify=no http://ftp.altlinux.org/pub/distributions/ALTLinux/images/Sisyphus/cloud/alt-sisyphus-rootfs-systemd-x86_64.tar.xz alttest
   # systemd-nspawn -M alttest
   [root@alttest ~]# apt-get update
   [root@alttest ~]# apt-get install clang rpm-build

There is also LXD support: https://en.altlinux.org/LXD

ps. If you going to use binary clang from http://releases.llvm.org/download.html#9.0.0
I would recommend version clang+llvm-9.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
and `ln -snf x86_64-alt-linux /usr/lib64/gcc/x86_64-unknown-linux` to
workaround `cannot find -lgcc` error.

Thanks,

> 
> - Arnaldo
>  
> > Thanks,
> > 
> > > 
> > > - Arnaldo
> > >  
> > > > 1. It seems that people putting strlcpy() into the tools was already aware of
> > > > the problems it causes and tried to solve them. Probably, that's why they put
> > > > `__weak` attribute on it (so it would be linkable in the presence of another
> > > > strlcpy). Then `#ifndef __UCLIBC__`ed and later `#if defined(__GLIBC__) &&
> > > > !defined(__UCLIBC__)` its declaration. But, solution was incomplete and could
> > > > be improved to make kernel buildable on more systems (where libc contains
> > > > strlcpy).
> > > > 
> > > > There is not need to make `redundant redeclaration` warning an error in
> > > > this case.
> > > > 
> > > > 2. `#pragma GCC diagnostic ignored` trick is already used multiple times
> > > > in the kernel:
> > > > 
> > > >   $ git grep  '#pragma GCC diagnostic ignored'
> > > >   arch/arm/lib/xor-neon.c:#pragma GCC diagnostic ignored "-Wunused-variable"
> > > >   tools/build/feature/test-gtk2-infobar.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > > >   tools/build/feature/test-gtk2.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > > >   tools/include/linux/string.h:#pragma GCC diagnostic ignored "-Wredundant-decls"
> > > >   tools/lib/bpf/libbpf.c:#pragma GCC diagnostic ignored "-Wformat-nonliteral"
> > > >   tools/perf/ui/gtk/gtk.h:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > > >   tools/testing/selftests/kvm/lib/assert.c:#pragma GCC diagnostic ignored "-Wunused-result"
> > > >   tools/usb/ffs-test.c:#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> > > > 
> > > > So the solution does not seem alien in the kernel and should be acceptable.
> > > > 
> > > > (I also send this to another of your emails in case I used wrong one before.)
> > > > 
> > > > Thanks,
> > > > 
> > > > 
> > > > On Mon, Dec 09, 2019 at 12:46:07AM +0300, Vitaly Chikunov wrote:
> > > > > Disable `redundant-decls' error for strlcpy declaration and solve build
> > > > > error allowing users to compile vanilla kernels.
> > > > > 
> > > > > When glibc have strlcpy (such as in ALT linux since 2004) objtool and
> > > > > perf build fails with something like:
> > > > > 
> > > > >   In file included from exec-cmd.c:3:
> > > > >   tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
> > > > >      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> > > > > 	|               ^~~~~~~
> > > > > 
> > > > > It's very hard to produce a perfect fix for that since it is a header
> > > > > file indirectly pulled from many sources from different Makefile builds.
> > > > > 
> > > > > Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
> > > > > Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
> > > > > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > > > > Cc: Dmitry V. Levin <ldv@altlinux.org>
> > > > > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > > Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  tools/include/linux/string.h | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
> > > > > index 980cb9266718..99ede7f5dfb8 100644
> > > > > --- a/tools/include/linux/string.h
> > > > > +++ b/tools/include/linux/string.h
> > > > > @@ -17,7 +17,10 @@ int strtobool(const char *s, bool *res);
> > > > >   * However uClibc headers also define __GLIBC__ hence the hack below
> > > > >   */
> > > > >  #if defined(__GLIBC__) && !defined(__UCLIBC__)
> > > > > +#pragma GCC diagnostic push
> > > > > +#pragma GCC diagnostic ignored "-Wredundant-decls"
> > > > >  extern size_t strlcpy(char *dest, const char *src, size_t size);
> > > > > +#pragma GCC diagnostic pop
> > > > >  #endif
> > > > >  
> > > > >  char *str_error_r(int errnum, char *buf, size_t buflen);
> > > 
> 
> -- 
> 
> - Arnaldo
