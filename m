Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2B2452A5
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgHOVxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbgHOVwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D7C06134F
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 19:00:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v5so2808704plo.4
        for <stable@vger.kernel.org>; Fri, 14 Aug 2020 19:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elMrilSLXI6b7aYlKVZpaKDCZnCipuhXfzdMESlljx4=;
        b=PeLFqURvd92pEiF6Mj5L1v1twm8KmHeCGT5FIUueuiePqXC/2SmG8X8wnJdCAvoIMF
         KBT1wvqHoqpL5j0WDX0ITEnjU+oLOV3CiB72ng3+Obta5Y7ld8+oYs4EO/mBUzjiyFvi
         z0uWLCjbBqWiMYG+AQi4Vw2rbLXCjmg86TOHvoZzdgZS2eHot7znULGD970HG2GgHWTS
         YHBgZCv60OtMpqCL+406elAO7tlZMekOZ3JwLSlD9NXsv9gftMbi/I41LKy7I7cZiloO
         iBZ3LenMuMHyqsmaKE3teY8bEw1j3TCBYD/bdFSe3gq1So0jmDCnm44iPKDgGjeqUfxb
         3ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elMrilSLXI6b7aYlKVZpaKDCZnCipuhXfzdMESlljx4=;
        b=RT00SO42GJe2Y9B2ckjOapU+t/mKXZbKehqO/GoHMOqxJG6mKaJQyQ6QDU8HX9oOUw
         edy8EkcF2laLjcVLrt4alC6H54rPi8h5VzL7pWhWVo1NFtX/dtKovcQpr7NKFkorAbIa
         7OdttWPwm1ac3cjy2qEWawFQyYljJfeldOAknIOBtZ3fII99rdxyTj9FkcdvRA4lfXcF
         LBjIGgeI5dWOtrKH9FDz2jJL7JkUdL1wklhctlu0nhQMPp/PbY4ofSYP4wp/ayrijGDL
         3DcVZb9wTG4n+tWmSowVViPBOpTYW6FxNCapt4aNAd05qdiJmoGCzg6aEaRbKL7OHrhu
         qigQ==
X-Gm-Message-State: AOAM530t8iaD+xXrnS/wOuVw5Kpae4JRWe2Wv6gx/7VRD3+89xwPx5yT
        2pP+WIx32VvxeDbHRbSs66Mn/Cm6bPvEmIs1dA3WeQ==
X-Google-Smtp-Source: ABdhPJwaOHL0rmpbix09Dt9ThyyA5ar4WG4bAXv4Vl84QpdBQ0LTKX4e8nB5NFzkcS+KwDHRsirpMdgZVcKrmcAqpxs=
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr3855029plb.179.1597456834421;
 Fri, 14 Aug 2020 19:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200815002417.1512973-1-ndesaulniers@google.com> <562003af51ca0b08f2108147b8d6e75cec18f3fd.camel@perches.com>
In-Reply-To: <562003af51ca0b08f2108147b8d6e75cec18f3fd.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 14 Aug 2020 19:00:22 -0700
Message-ID: <CAKwvOdn8PdK-3Xhm-JFG-=1djoPPEMcANjXarGpLUTkahJoFJw@mail.gmail.com>
Subject: Re: [PATCH] lib/string.c: implement stpcpy
To:     Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 5:52 PM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2020-08-14 at 17:24 -0700, Nick Desaulniers wrote:
> > LLVM implemented a recent "libcall optimization" that lowers calls to
> > `sprintf(dest, "%s", str)` where the return value is used to
> > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > in parsing format strings.
> []
> > diff --git a/include/linux/string.h b/include/linux/string.h
> []
> > @@ -31,6 +31,9 @@ size_t strlcpy(char *, const char *, size_t);
> >  #ifndef __HAVE_ARCH_STRSCPY
> >  ssize_t strscpy(char *, const char *, size_t);
> >  #endif
> > +#ifndef __HAVE_ARCH_STPCPY
> > +extern char *stpcpy(char *__restrict, const char *__restrict__);
>
> Why use two different forms for __restrict and __restrict__?
> Any real reason to use __restrict__ at all?

Bah, sorry, I recently enabled some setting in my ~/.vimrc to help me
find my cursor better:
" highlight cursor
set cursorline
set cursorcolumn

Turns out this makes it pretty difficult to see underscores, or the
lack thereof.  Will fix up.

>
> It's used nowhere else in the kernel.
>
> $ git grep -w -P '__restrict_{0,2}'
> scripts/genksyms/keywords.c:    // According to rth, c99 defines "_Bool", __restrict", __restrict__", "restrict".  KAO
> scripts/genksyms/keywords.c:    { "__restrict__", RESTRICT_KEYW },
>
>


-- 
Thanks,
~Nick Desaulniers
