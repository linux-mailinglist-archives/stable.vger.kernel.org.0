Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BA245502
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 02:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHPATY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 20:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgHPATY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 20:19:24 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30845C061385
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 17:19:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so5743829plk.13
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 17:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GdNLwnlPFkQHFOd6Xy60wVgrBimGSKOXtSoP9QOa/Ns=;
        b=XQiMWXwGHmbC34v17SmqPih9NvHLjX68PR7xIbiyZM6UG++TmXKlFLA1xjihqHJ16y
         7yZvm2dN+S2b3RGXSiw4CT8n9xETzpC95wooaPCWTNIXp1qzBL0wAascCahjmRrm+HaR
         jprx3YKxQk+PX/vN2sIOw0J3ShvVuF0zOEyjXQPdnwdwGFP9r/vJd84k2wKAO/4g3EQy
         eyF2WkWoMmABhwtQQJj8xJAf9cLT1AvG+QWnyplTnmhg5L2xN0tAYSGMlzh2nbbGA3nQ
         /CsRFEXsTxhX2NeWWLfsHdn6r/SOBH6TLQLeakTDO+Gu0vSqAK6wTpeosnsbPRz4FkrS
         C17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GdNLwnlPFkQHFOd6Xy60wVgrBimGSKOXtSoP9QOa/Ns=;
        b=pb6MSD9OV+nXqH3t7LdxPaA2qbLEEnsogvFPm3CWjlpXzl5laz4GkM1XiNAld5Vf3v
         k73E2MjlU8OQETJkQ9IdvYJLfktZnjswZ2T/cmP0Jmct2ceWUQPavyDWSjPoUEDCriJk
         f8WXio0Hl8/leIFgVZyHWr3BivGsXtN8TRI0bbCF7I54gL9rAp6NGB3OU9OMIEIKqWsd
         dZw20s8YQPvoCX1chIn4bVOlVY4lxCA3pse908XykV3g95Oc2j9RacxdVC4BHoUgl1GZ
         Z46trigaOZDfiEZde5KS3cx69v3b5tOewOoJ8Na/8VQ8FZ9fpNZgtSyNnbzUVzDIv7l4
         fH8Q==
X-Gm-Message-State: AOAM530+b7391c70q5lNq19zG/EPsB2e6E4ZwDB9YfqHDLpgWKxvemEw
        h83vADRbYm5j7qt7Cw2d85Vv7A==
X-Google-Smtp-Source: ABdhPJxw2uMEic+JG/5VKDXnNzRKmfzkU29/IOf6VMaBx4mbWTUnI6WBx00akiJyQupuwQuLeuFiXw==
X-Received: by 2002:a17:902:7609:: with SMTP id k9mr6530697pll.187.1597537162547;
        Sat, 15 Aug 2020 17:19:22 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id b63sm13070308pfg.43.2020.08.15.17.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 17:19:21 -0700 (PDT)
Date:   Sat, 15 Aug 2020 17:19:17 -0700
From:   Fangrui Song <maskray@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Message-ID: <20200816001917.4krsnrik7hxxfqfm@google.com>
References: <20200815014006.GB99152@rani.riverdale.lan>
 <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook>
 <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
 <457a91183581509abfa00575d0392be543acbe07.camel@perches.com>
 <CAKwvOdk4PRi45MXCtg4kmeN6c1AK5w9EJ1XFBJ5GyUjwEtRj1g@mail.gmail.com>
 <ccacb2a860151fdd6ce95371f1e0cd7658a308d1.camel@perches.com>
 <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=QkpmdWHAvWVFtogsDom2z_fA4XmDF6aLqz1czjSgZbQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-15, 'Nick Desaulniers' via Clang Built Linux wrote:
>On Sat, Aug 15, 2020 at 2:31 PM Joe Perches <joe@perches.com> wrote:
>>
>> On Sat, 2020-08-15 at 14:28 -0700, Nick Desaulniers wrote:
>> > On Sat, Aug 15, 2020 at 2:24 PM Joe Perches <joe@perches.com> wrote:
>> > > On Sat, 2020-08-15 at 13:47 -0700, Nick Desaulniers wrote:
>> > > > On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:
>> > > > > On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
>> > > > > > LLVM implemented a recent "libcall optimization" that lowers calls to
>> > > > > > `sprintf(dest, "%s", str)` where the return value is used to
>> > > > > > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
>> > > > > > in parsing format strings.  Calling `sprintf` with overlapping arguments
>> > > > > > was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
>> > > > > >
>> > > > > > `stpcpy` is just like `strcpy` except it returns the pointer to the new
>> > > > > > tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
>> > > > > > one statement.
>> > > > >
>> > > > > O_O What?
>> > > > >
>> > > > > No; this is a _terrible_ API: there is no bounds checking, there are no
>> > > > > buffer sizes. Anything using the example sprintf() pattern is _already_
>> > > > > wrong and must be removed from the kernel. (Yes, I realize that the
>> > > > > kernel is *filled* with this bad assumption that "I'll never write more
>> > > > > than PAGE_SIZE bytes to this buffer", but that's both theoretically
>> > > > > wrong ("640k is enough for anybody") and has been known to be wrong in
>> > > > > practice too (e.g. when suddenly your writing routine is reachable by
>> > > > > splice(2) and you may not have a PAGE_SIZE buffer).
>> > > > >
>> > > > > But we cannot _add_ another dangerous string API. We're already in a
>> > > > > terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
>> > > > > needs to be addressed up by removing the unbounded sprintf() uses. (And
>> > > > > to do so without introducing bugs related to using snprintf() when
>> > > > > scnprintf() is expected[4].)
>> > > >
>> > > > Well, everything (-next, mainline, stable) is broken right now (with
>> > > > ToT Clang) without providing this symbol.  I'm not going to go clean
>> > > > the entire kernel's use of sprintf to get our CI back to being green.
>> > >
>> > > Maybe this should get place in compiler-clang.h so it isn't
>> > > generic and public.
>> >
>> > https://bugs.llvm.org/show_bug.cgi?id=47162#c7 and
>> > https://bugs.llvm.org/show_bug.cgi?id=47144
>> > Seem to imply that Clang is not the only compiler that can lower a
>> > sequence of libcalls to stpcpy.  Do we want to wait until we have a
>> > fire drill w/ GCC to move such an implementation from
>> > include/linux/compiler-clang.h back in to lib/string.c?
>>
>> My guess is yes, wait until gcc, if ever, needs it.
>
>The suggestion to use static inline doesn't even make sense. The
>compiler is lowering calls to other library routines; `stpcpy` isn't
>being explicitly called.  Even if it was, not sure we want it being
>inlined.  No symbol definition will be emitted; problem not solved.
>And I refuse to add any more code using `extern inline`.  Putting the
>definition in lib/string.c is the most straightforward and avoids
>revisiting this issue in the future for other toolchains.  I'll limit
>access by removing the declaration, and adding a comment to avoid its
>use.  But if you're going to use a gnu target triple without using
>-ffreestanding because you *want* libcall optimizations, then you have
>to provide symbols for all possible library routines!

Adding a definition without a declaration for stpcpy looks good.
Clang LTO will work.

(If the kernel does not want to provide these routines,
is http://git.kernel.org/linus/6edfba1b33c701108717f4e036320fc39abe1912
probably wrong? (why remove -ffreestanding from the main Makefile) )
