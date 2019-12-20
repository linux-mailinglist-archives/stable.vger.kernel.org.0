Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44350127B0C
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 13:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfLTMbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 07:31:41 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43997 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbfLTMbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 07:31:41 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so4870738pga.10;
        Fri, 20 Dec 2019 04:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=F6jV7dZGaKPpiJXhyz7QnNUY1p8ieWyHe/bumU+P16o=;
        b=Nci2QP5hnlRqvDSICDq96aLGd1YRB5cykPNWi2k0HLLq64ZwPlioYVl6tbgMvRzZh6
         o6JfGF1eaMA2adacHFkV8paU8h7gEMb+ZMUkbXrfPUJdu/oHfC7e3x3Y8et9CMKo6S3T
         1ZUrb8TVRDFnvnnSy5LSVSaZGupIg/optVZgTr7xxeCmUwkFgHJ9NGKXHBKfT0Sl1f9+
         z07S5ee2Mu3vOfmHTfgBlqsRyM6odQX60zQYeMJxLJzrpmsiNREBufBdZQHhjg0rdZ1R
         wvp+jgcWaRzB1wcTPwZ1i/AsATo4+HRmd8G4fYNpkWfHHBRg6oU5nzXtytyhSmknysmw
         m4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=F6jV7dZGaKPpiJXhyz7QnNUY1p8ieWyHe/bumU+P16o=;
        b=pBANtYR40kSFz5JPTTwr2cj9SglTL7p9T5wAITFgoGkIVr+QVe4eKHehIHcSUAwqVO
         7HxzpwDHm2QsOAG/BfYpzin0Jn/7BhE04k2XI+770xZDivJiuv/idhtmIp9oUYPaCZSE
         cashrlOtamZ3/YNKWxoFUjg7oQ2eRIh8m1TUOEdEspsyjz7ME/5u4UAxr+VztJaNaqUY
         4BWfpKDVKj/qY0q+gOe3lvt5YpKKUKFcwvzJNuFbC73yFfPDgprFIHigVljZCuoaQz3G
         C0sX8lSJYYbsvNpYfcX1J45Bom338S6eGSrWJQoJzB0KeO+q6lCHJp6y9qhdjx04J5YI
         ME7A==
X-Gm-Message-State: APjAAAWtxhBROh9NmjJRFy5P7P+C++6zIkgKcCyla4ZWQ+wHH8AZ5aEq
        0L1Ag+Y2aX5+3bcHgRqxMP8=
X-Google-Smtp-Source: APXvYqyib6eSuVyAIukktBCFzf3PpemWu3v1peg1kL61dxE/L2dWJkJ9GGkvXt3U+v0dOSPuhZhW4g==
X-Received: by 2002:a63:cc4f:: with SMTP id q15mr14825230pgi.159.1576845099944;
        Fri, 20 Dec 2019 04:31:39 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id t23sm13840813pfq.106.2019.12.20.04.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:31:39 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 127B440CB9; Fri, 20 Dec 2019 09:31:36 -0300 (-03)
Date:   Fri, 20 Dec 2019 09:31:36 -0300
To:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tools lib: Disable redundant-delcs error for strlcpy
Message-ID: <20191220123136.GD2032@kernel.org>
References: <20191208214607.20679-1-vt@altlinux.org>
 <20191217122331.4g5atx7in6njjlw4@altlinux.org>
 <20191217200420.GD7095@redhat.com>
 <20191220025236.kgu3v6yhjndr3zwb@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191220025236.kgu3v6yhjndr3zwb@altlinux.org>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Fri, Dec 20, 2019 at 05:52:36AM +0300, Vitaly Chikunov escreveu:
> Arnaldo,
> 
> On Tue, Dec 17, 2019 at 05:04:20PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 17, 2019 at 03:23:32PM +0300, Vitaly Chikunov escreveu:
> > > Arnaldo,
> 
> (Btw, you didn't include me into the To: of your reply).
> 
> > > Ping. Can you accept or comment on this patch? There is further
> > > explanations of it:
> > 
> > Will this work when building with clang
> 
> Clang doesn't produce this warning:
> 
>   https://clang.llvm.org/docs/DiagnosticsReference.html#wredundant-decls
>   "-Wredundant-decls
>   This diagnostic flag exists for GCC compatibility, and has no effect
>   in Clang."
> 
> Thus, this change doesn't affect clang. (When building the kernel objtool
> compiles OK).
> 
> But, compilation with clang fails compiling perf with:
> 
>     CC       util/string.o
>   ../lib/string.c:99:8: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
>   size_t __weak strlcpy(char *dest, const char *src, size_t size)
>          ^
>   ../../tools/include/linux/compiler.h:66:34: note: expanded from macro '__weak'
>   # define __weak                 __attribute__((weak))
>                                                  ^
>   /usr/include/bits/string_fortified.h:151:8: note: previous definition is here
>   __NTH (strlcpy (char *__restrict __dest, const char *__restrict __src,
>          ^
>   1 error generated.
> 
> This warning could be disabled with this:
> 
> diff --git tools/lib/string.c tools/lib/string.c
> index f2ae1b87c719..65b569014446 100644
> --- tools/lib/string.c
> +++ tools/lib/string.c
> @@ -96,6 +96,8 @@ int strtobool(const char *s, bool *res)
>   * If libc has strlcpy() then that version will override this
>   * implementation:
>   */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wignored-attributes"
>  size_t __weak strlcpy(char *dest, const char *src, size_t size)
>  {
>         size_t ret = strlen(src);
> @@ -107,6 +109,7 @@ size_t __weak strlcpy(char *dest, const char *src, size_t size)
>         }
>         return ret;
>  }
> +#pragma GCC diagnostic pop
> 
>  /**
>   * skip_spaces - Removes leading whitespace from @str.
> 
> If this is acceptable I will resend v2 with this.

Go ahead, and please let me know if there is any container image for
Altlinux, as I test with clang on all the distros I have container
images for, and this hasn't appeared on my radar, i.e. clang + strlcpy
warnings :-)

- Arnaldo
 
> Thanks,
> 
> > 
> > - Arnaldo
> >  
> > > 1. It seems that people putting strlcpy() into the tools was already aware of
> > > the problems it causes and tried to solve them. Probably, that's why they put
> > > `__weak` attribute on it (so it would be linkable in the presence of another
> > > strlcpy). Then `#ifndef __UCLIBC__`ed and later `#if defined(__GLIBC__) &&
> > > !defined(__UCLIBC__)` its declaration. But, solution was incomplete and could
> > > be improved to make kernel buildable on more systems (where libc contains
> > > strlcpy).
> > > 
> > > There is not need to make `redundant redeclaration` warning an error in
> > > this case.
> > > 
> > > 2. `#pragma GCC diagnostic ignored` trick is already used multiple times
> > > in the kernel:
> > > 
> > >   $ git grep  '#pragma GCC diagnostic ignored'
> > >   arch/arm/lib/xor-neon.c:#pragma GCC diagnostic ignored "-Wunused-variable"
> > >   tools/build/feature/test-gtk2-infobar.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > >   tools/build/feature/test-gtk2.c:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > >   tools/include/linux/string.h:#pragma GCC diagnostic ignored "-Wredundant-decls"
> > >   tools/lib/bpf/libbpf.c:#pragma GCC diagnostic ignored "-Wformat-nonliteral"
> > >   tools/perf/ui/gtk/gtk.h:#pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > >   tools/testing/selftests/kvm/lib/assert.c:#pragma GCC diagnostic ignored "-Wunused-result"
> > >   tools/usb/ffs-test.c:#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
> > > 
> > > So the solution does not seem alien in the kernel and should be acceptable.
> > > 
> > > (I also send this to another of your emails in case I used wrong one before.)
> > > 
> > > Thanks,
> > > 
> > > 
> > > On Mon, Dec 09, 2019 at 12:46:07AM +0300, Vitaly Chikunov wrote:
> > > > Disable `redundant-decls' error for strlcpy declaration and solve build
> > > > error allowing users to compile vanilla kernels.
> > > > 
> > > > When glibc have strlcpy (such as in ALT linux since 2004) objtool and
> > > > perf build fails with something like:
> > > > 
> > > >   In file included from exec-cmd.c:3:
> > > >   tools/include/linux/string.h:20:15: error: redundant redeclaration of ‘strlcpy’ [-Werror=redundant-decls]
> > > >      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> > > > 	|               ^~~~~~~
> > > > 
> > > > It's very hard to produce a perfect fix for that since it is a header
> > > > file indirectly pulled from many sources from different Makefile builds.
> > > > 
> > > > Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string.c")
> > > > Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIBC__")
> > > > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > > > Cc: Dmitry V. Levin <ldv@altlinux.org>
> > > > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  tools/include/linux/string.h | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
> > > > index 980cb9266718..99ede7f5dfb8 100644
> > > > --- a/tools/include/linux/string.h
> > > > +++ b/tools/include/linux/string.h
> > > > @@ -17,7 +17,10 @@ int strtobool(const char *s, bool *res);
> > > >   * However uClibc headers also define __GLIBC__ hence the hack below
> > > >   */
> > > >  #if defined(__GLIBC__) && !defined(__UCLIBC__)
> > > > +#pragma GCC diagnostic push
> > > > +#pragma GCC diagnostic ignored "-Wredundant-decls"
> > > >  extern size_t strlcpy(char *dest, const char *src, size_t size);
> > > > +#pragma GCC diagnostic pop
> > > >  #endif
> > > >  
> > > >  char *str_error_r(int errnum, char *buf, size_t buflen);
> > 

-- 

- Arnaldo
