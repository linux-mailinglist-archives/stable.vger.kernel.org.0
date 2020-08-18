Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0B248E8B
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRTV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 15:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRTVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 15:21:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93323C061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:21:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x6so10192619pgx.12
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zqSUjfhetXa5IuRw9JeF+TW2/+QsT5+pQU8GGaPMx7M=;
        b=fdirQtS35bnk6l7y3oW8Lw0Cg/XmLySVy6zO41Bo0Jky1Yq7FjctMNf30HUh477Q0+
         k6bc/NwkvecrpTp319yOav2wSqUK7Y/7nyq8iWZrm1pDxIhDit1RZAWjuv/9EcNrcDYK
         Z8IwnKbdRyVfphkNX5Weqbt3bjg5GNhOj2mdI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zqSUjfhetXa5IuRw9JeF+TW2/+QsT5+pQU8GGaPMx7M=;
        b=P6Xda0R2dXwrenfxhAfMpl9POMGLTZdWDu+1OdrRwO+q15ZHa701ND+xqSDkpgZUL0
         HvvxW46x43HzYWJJ2yEcdl/6EwJjH/4dwc1MADM05YfVJjJlNb07Mx6CY0PSipWwAJ4m
         dpegVdZXKGqkhN89p5GjVx7PLMf1iJftGYgqGEnCH/nkMD3M/y/7rMvO3EhbPD8fVnpv
         QnK/lbAF0q7Nrpiq1l4OQdkHRJUZNS8/q1U9T6aAbB9QHV44k86B3/RL9GgsqX1Drdzr
         +dc1Co1ymzvekjh5j+8Icq/lpNYru3oJEFVK8FgqD7ErbSg2tozm1eKbg1KQhRCbkgyL
         ZJGA==
X-Gm-Message-State: AOAM531huFqzAqZCfc1cDAwyB7luZtu+IrFccbbtnxY55taJYxZIDlmy
        MCuIaZjpZGtpLou6a87GjH1zLA==
X-Google-Smtp-Source: ABdhPJzQiR6xAc8WKkbKdUhnnyT4rO2YXcWUvPMo/Nnf80Lz9eP5MKsknobJ4DFtPnQJPH3UbCvtvQ==
X-Received: by 2002:aa7:984e:: with SMTP id n14mr16437303pfq.272.1597778514020;
        Tue, 18 Aug 2020 12:21:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n26sm24981410pff.30.2020.08.18.12.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 12:21:52 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:21:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joe Perches <joe@perches.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>, x86@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Bruce Ashfield <bruce.ashfield@gmail.com>,
        Marco Elver <elver@google.com>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?D=E1vid_Bolvansk=FD?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 1/4] Makefile: add -fno-builtin-stpcpy
Message-ID: <202008181214.5C736E7@keescook>
References: <20200817220212.338670-1-ndesaulniers@google.com>
 <20200817220212.338670-2-ndesaulniers@google.com>
 <82bbeff7-acc3-410c-9bca-3644b141dc1a@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82bbeff7-acc3-410c-9bca-3644b141dc1a@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 03:31:26PM -0700, H. Peter Anvin wrote:
> On 2020-08-17 15:02, Nick Desaulniers wrote:
> > LLVM implemented a recent "libcall optimization" that lowers calls to
> > `sprintf(dest, "%s", str)` where the return value is used to
> > `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> > in parsing format strings. This optimization was introduced into
> > clang-12. Because the kernel does not provide an implementation of
> > stpcpy, we observe linkage failures for almost all targets when building
> > with ToT clang.
> > 
> > The interface is unsafe as it does not perform any bounds checking.
> > Disable this "libcall optimization" via `-fno-builtin-stpcpy`.
> > 
> > Unlike
> > commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> > which cited failures with `-fno-builtin-*` flags being retained in LLVM
> > LTO, that bug seems to have been fixed by
> > https://reviews.llvm.org/D71193, so the above sha can now be reverted in
> > favor of `-fno-builtin-bcmp`.
> > 
> 
> stpcpy() and (to a lesser degree) mempcpy() are fairly useful routines
> in general. Perhaps we *should* provide them?

As Nick mentioned, I really don't want to expand the already bad
interfaces from libc. We have enough messes to clean up already, and I
don't want to add more. The kernel already uses a subset of C, we have
(several) separate non-libc memory allocators, we're using strscpy() and
scnprintf() widely in favor of their buggy libc counterparts, etc. We
don't need to match the libc string interfaces especially when they're
arguably bug-prone foot-guns. :)

-- 
Kees Cook
