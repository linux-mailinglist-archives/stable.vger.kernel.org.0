Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD025B67C
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIBWkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 18:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBWkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 18:40:15 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE71C061244
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 15:40:15 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g6so490972pjl.0
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Et/xc2YROl4qNYcn8Qs+aCkZEYKnAaIEsZ0/FKsLWP4=;
        b=rXWlyxq+7xy8HCIGDawd2y3Q9cNhx3h14WdEfZpVCnXHn/W7dIw0hrnqlfwn7/bxBc
         cX0HRuUSLpuKmOqUkj6PU74xgDN+yWwhqBtk4/xoZBLQ8kzJ8RHU0V6iVlTNzswd5BQ6
         MBBxZDsW7WasDh52zjB1XiYWf3KOM6m/Oq9dQ71MY8NM/UC8dGl7JyioqZQUhC5EB4bQ
         rBWuZbUeeYuVgTbc79XUAvzqwQcek7la+DjQwh1fiDuWW8Zg8nTFAKrcL/M8hcwCBCoL
         UN0d0QGbs2TXeYQ+PanIQTJ/SGk+IVboTQzAbP3iKk624k6HIzXLPUcktL55yHC28vGB
         /L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Et/xc2YROl4qNYcn8Qs+aCkZEYKnAaIEsZ0/FKsLWP4=;
        b=NYor+APROjrVWBPBIxnqAU5u27jyKR0vDLShO/KHgrkXvW0a5x0M8WBcZZAAZ80DLc
         GxMntse9Tm/Y0BqJFdwBmpEJSz2RQ/uwlYpzCL9jONb4Izn1oYf0BnJPRXWJOpy1v2NB
         h2m9Fqu8ETl3aTBZY5zhu9HYoZt8sM4WD/zT/rKD90+0qFY4Osa8a9S8NgLZxVn8CZTv
         qwmvfI3que2eR4NjhYyeIBG198LbC/bB8tis+OycDxHpy24WMaULKvVnt1DhR4wavLSU
         MbbJnjX7O2VFSZJqlNV5SgqHajOfLl7l3CeVsyw/Yo10gCMmG11HzN3vvDXhzmRdJ5KQ
         9jFQ==
X-Gm-Message-State: AOAM531XO3GotS857f9YBlOBxbpJV88/TVsSVDF+s+KElcSm7zVPP2nm
        U8vT35rEIVhaMrvd1rrWMI4He0DDO66ZvII5HiSJQlD5BLYQGg==
X-Google-Smtp-Source: ABdhPJxcdId1jw1ooHY4s038mjOk1feFDY5gNw9gtUjdobC0Ug+3mX37JstD4Yuuwen7SNvDFv06RaZUgSy6viXWt6A=
X-Received: by 2002:a17:90a:e517:: with SMTP id t23mr3922497pjy.25.1599086414557;
 Wed, 02 Sep 2020 15:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200820220955.3325555-1-ndesaulniers@google.com> <CAK7LNAQO9sKw=7RLPSnsChddrwNCc_si-XgSDQcGHTSxeq4_Pg@mail.gmail.com>
In-Reply-To: <CAK7LNAQO9sKw=7RLPSnsChddrwNCc_si-XgSDQcGHTSxeq4_Pg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 2 Sep 2020 15:40:03 -0700
Message-ID: <CAKwvOdnbdhkB=OG0Gec5jt5H4b4jRGPvKfgJ-JbZY+gym-u3_g@mail.gmail.com>
Subject: Re: [PATCH] Makefile: add -fuse-ld=lld to KBUILD_HOSTLDFLAGS when LLVM=1
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephen Hines <srhines@google.com>,
        Dan Albert <danalbert@google.com>,
        Fangrui Song <maskray@google.com>,
        Elliott Hughes <enh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 10:14 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Fri, Aug 21, 2020 at 7:10 AM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> >
> > While moving Android kernels over to use LLVM=1, we observe the failure
> > when building in a hermetic docker image:
> >   HOSTCC  scripts/basic/fixdep
> > clang: error: unable to execute command: Executable "ld" doesn't exist!
> >
> > The is because the build of the host utility fixdep builds the fixdep
> > executable in one step by invoking the compiler as the driver, rather
> > than individual compile then link steps.
> >
> > Clang when configured from source defaults to use the system's linker,
> > and not LLVM's own LLD, unless the CMake config
> > -DCLANG_DEFAULT_LINKER='lld' is set when configuring a build of clang
> > itself.
> >
> > Don't rely on the compiler's implicit default linker; be explicit.
>
>
> I do not understand this patch.
>
> The host compiler should be able to link executables
> without any additional settings.

Correct; there is no issue linking working executables. The issue is
which linker is used by default or implied when -fuse-ld=* is not
explicitly set.

>
> So, can you link a hello world program
> in your docker?
>
> masahiro@zoe:~$ cat test.c
> #include <stdio.h>
> int main(void)
> {
>         printf("helloworld\n");
>         return 0;
> }
> masahiro@zoe:~$ clang test.c

It will fail, because:
1. clang will implicitly default to ld.bfd on linux hosts and ld on
OSX hosts (idk about windows).
2. ld.bfd is not installed, and we *dont'* want to install it.
Instead, we *want* to use ld.lld in a hermetic environment.

> If this fails, your environment is broken.

Disagree.  The environment has unique constraints (cross compiling for
Android from OSX host, caring about builds being hermetic, etc.).

> Just do  -DCLANG_DEFAULT_LINKER='lld'
> if you know GNU ld is missing in your docker environment.

I understand your point. However, I have two reasons I still think
this patch should be upstream rather than downstream:

1. The build of clang that is distributed with Android, "AOSP LLVM"
[0], does not and cannot yet set `-DCLANG_DEFAULT_LINKER='lld'`.  See
the discussion in the comments of [1] where I'm trying to do that.
The reason is that AOSP LLVM is used to build Android userspace,
kernel, and is part of the NDK for developers to target Android from
Windows, OSX, and Linux.  If AOSP is used to build a "host binary" on
OSX, LLD will not work there for that quite yet.  OSX has its own
linker that is not LLD, and LLD support for mach-o binaries is a work
in progress.  NDK has their own timeline that's blocking that change.

You might think "that's Android problem" and that we should just carry
the patch downstream/out of tree since it is somewhat self-inflicted
but a very important second point why I think this should be upstream:

2. clang itself (upstream of AOSP LLVM) doesn't yet default to
-fuse-ld=lld (likely for similar reasons related to OSX).  That means
distributions of clang-10 from your distro package manager such as
Debian's apt won't be hermetic.  That means if you build clang from
source, and don't configure it with -DCLANG_DEFAULT_LINKER='lld', then
your kernel builds with LLVM=1 will not be hermetic.  That means we
have to document this somewhere for other people to know or find this.
That means I have to run around and tell all of the different Kernel
CI folks about this compiler configuration in order to test
hermetically.

...

Or, encouraged by the zen of Python, we can just be explicit about
what linker we want when using LLVM=1, which already signals that that
is what we want to do.

I think there are similar issues with other distros changing default
flags of GCC (like -fstack-protector) [2].  The kernel is already
explicit, so that differences in distro's changes to compiler defaults
don't matter for kernel builds (except where people accidentally wipe
out KBUILD_CFLAGS).  I'd argue my change is in the same bucket.
Please reconsider this patch.

(I should also probably add something like this for `make LD=ld.lld`
and `make LD=ld.bfd`, regardless of compiler, since everyone supports
`-fuse-ld=`)

[0] https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/
[1] https://android-review.googlesource.com/c/toolchain/llvm_android/+/1007826
[2] https://fedoraproject.org/wiki/Changes/HardenedCompiler#Detailed_Description
-- 
Thanks,
~Nick Desaulniers
