Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C350E2DDA90
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 22:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgLQVIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 16:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgLQVIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 16:08:34 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1C6C061794
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 13:07:54 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2so171369pfq.5
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 13:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pn64gL1PFy3T6aEaSewOwhAXHuHI8RuWQ88aIPK+DJ0=;
        b=uyu8VTEGuSZJ0tQIowYFWiWOKwtj8ojCTOGEEPNHCr+oMko3vIj0fZovNXF+Nv1bTc
         FNlgWZ3tCl922WpnP24+KDKTMn4LfkkmC9Ns8nlTVkXZUpHszNhSKY2E5m5Ux608etcq
         hE4Yg4C8NzZRbwp9lKUgnt2nxh82PHB1jglyNUIy45lqWzNgoQ41DSKXLVkKYH0VPDE2
         byzdgK7duzdAd6HEfmhoGfzQs8HLXZYTV27g+zQjQfbUBnSnoiOqwUnwQdIuuQHrTj5H
         rlcMivKS17p8O4KTXR991kOqB/0W1Ksk+RXmVQZp9Bb5xacWLEFzhL9TeN4BrV3bpg4E
         C3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pn64gL1PFy3T6aEaSewOwhAXHuHI8RuWQ88aIPK+DJ0=;
        b=rd+tf/b+qH8UlvSOu5Z4h195h2FjPLn+KSdvIC2iM9jkPXWf85asVgJrIshC9/9Eoc
         fNdr/+GuCpLjNyI2MHz4CCOIf6YBqUiYjb+FCZHu3Zp07mNKb2ShaF5+XoPMaIebHAtq
         bhCGmtKaArEeQYq/VdH8jt7YDJduMTH+l1UReW9Uq/hj/LX6apxqGrcu3lpKbarDevfl
         O+zCj5NMisVhdeq2GerO5j84gXW9o2nOa696W7hp90cctt102QA9s1H7sNExrltkZ1Tw
         ckWEM2WGZyEZi3fEI7E6vR1Cz0iqQOZqU9Mdhr6Rtd8WSZRlvU7gO+9IelsxS23l6S9D
         b8ng==
X-Gm-Message-State: AOAM532eGvznn8GHsW2F/nO7gDZ67m7q+JFX/2FRutTyasETQbOWR7C5
        wZ+iT/iDYlapp0rY6Q7plWImeFrWpkaDGkkDnnO5Zg==
X-Google-Smtp-Source: ABdhPJz3jvfkQ9M2KieaKXlZ+y7+G09Fr99taIeBU736VGaEPEFeJG9VWWIeJZQyHK3N9mXp0nghhrT28HFDshpOaNY=
X-Received: by 2002:a63:1142:: with SMTP id 2mr1079220pgr.263.1608239273686;
 Thu, 17 Dec 2020 13:07:53 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
 <20201217004051.1247544-1-ndesaulniers@google.com> <20201217120118.GC17544@willie-the-truck>
In-Reply-To: <20201217120118.GC17544@willie-the-truck>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 17 Dec 2020 13:07:41 -0800
Message-ID: <CAKwvOd=LZHzR11kuhT2EjFnUdFwu5hQmxiwqeLB2sKC0hWFY=g@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro for LLD or aarch64-elf
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team <kernel-team@android.com>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        Alan Modra <amodra@gmail.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 4:01 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Dec 16, 2020 at 04:40:51PM -0800, Nick Desaulniers wrote:
> > With newer GNU binutils, linking with BFD produces warnings for vmlinux:
> > aarch64-linux-gnu-ld: warning: -z norelro ignored
> >
> Given that, prior to 3b92fa7485eb, we used to pass '-z norelro' if
> CONFIG_RELOCATABLE then was this already broken with the ELF toolchain?

Yes, though it would have been hard to foresee the change to BFD ~6
months later.

Specifically, binutils-gdb
commit 5fd104addfddb ("Emit a warning when -z relro is unsupported")
was committed Fri Jun 19 09:50:20 2020 +0930. The first git tag that
describes this commit was binutils-2_35 which was tagged Fri Jul 24
11:05:23 2020 +0100.

I noticed about a month ago that the version of
binutils-aarch64-linux-gnu installed on my gLinux workstation had auto
updated to version 2.35.1; I was authoring kernel patches for DWARF v5
support, which relied on 2.35 for DWARF v5 assembler support.  I
suspect Quentin's host was auto updated as well, at which point he
noticed and mentioned to me since I had touched `-z norelro` last.

But if we look at
commit 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in
linker script and options")
which was committed at Tue Dec 4 12:48:25 2018 +0000, it was not
possible to foresee that binutils-gdb would change to produce such a
warning for such an emulation mode.

So I'm not sure whether my patch should either:
- have a fixes tag for just the latest commit that touched anything
related to `-z norelro`, mine, 3b92fa7485eb.
- have an additional fixes tag for 3bbd3db86470 which first introduced
`-z norelro`.
- have no fixes tag

I'll respin a v2 folding in Ard's suggestions.  Meanwhile, I've filed:
- https://bugs.llvm.org/show_bug.cgi?id=48549 against LLD
- https://sourceware.org/bugzilla/show_bug.cgi?id=27093 against BFD
-- 
Thanks,
~Nick Desaulniers
