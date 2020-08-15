Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465DE2453C9
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgHOWFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729953AbgHOWFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 18:05:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C1AC03D1C0
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 13:48:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r11so6196631pfl.11
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 13:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+4XEEilZNC5EnENDZHqsdd6uXJXrwqlhHae+qHfSvbQ=;
        b=wKBjH/2Z6uVBPL/Q1S6eaKmilGJG0PbMlbjM2/MHqqWiTs21fSTzY4rXhYSnH3T6R3
         bcw8+6W1xtjI5xk2hxjx1xp9GXG1nDZ701BjycbNt74xUwK8WLxd0lKsxfyHaDVPWo2B
         lfAny6hDAFCIRggQn00zshsuBUgS24gh21ZqDri5b7r+3SPd1WnXc7PzzS3M4QNSgGQS
         WFsrcnA7ymFtXIqXsGctsYc4f69y85l7lGB7o5a2IZr3Xj9f9Xs3aQh9k1hXZ2oYjvMZ
         hIEDLMd2UZ0Y40qW3rOnkhzg+TducUbrF5sxDLsYOPqEw7tA2YyBQZJFvmUdFKU/rYV7
         YNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+4XEEilZNC5EnENDZHqsdd6uXJXrwqlhHae+qHfSvbQ=;
        b=fmF0DLYAjVg9N5YCSS2ZPWjaw8yzRdgu3FcUqvh3Qy1Hlg1iemxpJ/UDU3LmUmflxN
         SbApFUokexZ9Z6GDfkoAo1MM4M3p4wFllfWfCdkwH0pBQ0IE443saho5MfJEp499dKHc
         xzdKJMbvFicebDmDlLiw+Yzqm5877JRuYpXUAzMXcjvf6Xki3M6wAgnXuYmDRRu1rVad
         hX1mNyrM5Rl4CUdxe35gyDd9t9yc55DzHUzNthaWMvppUmEuY5clxQFzZquiFsnvF/l0
         VTXm7AKnfe4lDUkhw6qlIOSHVULY/Bxrp3tu7CivBnfPTACieOi5pO3rDfPnq18sIcpj
         a//w==
X-Gm-Message-State: AOAM532rRqsE58p9MLONI3cFcWsK3Am1cp2B50kEvuuA1Lu1R6xLHV4p
        B7pfwCG2vyv9Smr1HUFqSzkDLodIfg2iDubAemYD3w==
X-Google-Smtp-Source: ABdhPJxC5zl4CYpaEzRIiscMTahyf+UsXZafZmLcVqQ1/a88Nf+JxHg2ypnINSncSvy7TGu9nZgRUog3SNaaq/hKkcg=
X-Received: by 2002:a63:7d8:: with SMTP id 207mr5716072pgh.263.1597524482737;
 Sat, 15 Aug 2020 13:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200815014006.GB99152@rani.riverdale.lan> <20200815020946.1538085-1-ndesaulniers@google.com>
 <202008150921.B70721A359@keescook>
In-Reply-To: <202008150921.B70721A359@keescook>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Sat, 15 Aug 2020 13:47:51 -0700
Message-ID: <CAKwvOdnyHfx6ayqEoOr3pb_ibKBAG9vj31LuKE+f712W=7LFKA@mail.gmail.com>
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 15, 2020 at 9:34 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:
> > LLVM implemented a recent "libcall optimization" that lowers calls to
> > `sprintf(dest, "%s", str)` where the return value is used to
> > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > in parsing format strings.  Calling `sprintf` with overlapping arguments
> > was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
> >
> > `stpcpy` is just like `strcpy` except it returns the pointer to the new
> > tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
> > one statement.
>
> O_O What?
>
> No; this is a _terrible_ API: there is no bounds checking, there are no
> buffer sizes. Anything using the example sprintf() pattern is _already_
> wrong and must be removed from the kernel. (Yes, I realize that the
> kernel is *filled* with this bad assumption that "I'll never write more
> than PAGE_SIZE bytes to this buffer", but that's both theoretically
> wrong ("640k is enough for anybody") and has been known to be wrong in
> practice too (e.g. when suddenly your writing routine is reachable by
> splice(2) and you may not have a PAGE_SIZE buffer).
>
> But we cannot _add_ another dangerous string API. We're already in a
> terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This
> needs to be addressed up by removing the unbounded sprintf() uses. (And
> to do so without introducing bugs related to using snprintf() when
> scnprintf() is expected[4].)

Well, everything (-next, mainline, stable) is broken right now (with
ToT Clang) without providing this symbol.  I'm not going to go clean
the entire kernel's use of sprintf to get our CI back to being green.

Thoughts on not exposing the declaration in the header, and changing
the comment to be to the effect of:
"Exists only for optimizing compilers to replace calls to sprintf
with; generally unsafe as bounds checks aren't performed, do not use."
It's still a worthwhile optimization to have, even if the use that
generated it didn't do any bounds checking.

>
> -Kees
>
> [1] https://github.com/KSPP/linux/issues/88
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://github.com/KSPP/linux/issues/90
> [4] https://lore.kernel.org/lkml/20200810092100.GA42813@2f5448a72a42/
>
> --
> Kees Cook



-- 
Thanks,
~Nick Desaulniers
