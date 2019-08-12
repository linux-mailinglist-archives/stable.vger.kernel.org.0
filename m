Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E278A4BD
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHLRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 13:36:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41225 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfHLRgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 13:36:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so39495221pgg.8
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 10:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oZi4p9sU++IMNyLOoMu4O4MSpldoBC3la4O/D+JmVeE=;
        b=RsNkwjciAZJFroOX5ILBuBvMy8TWcIT9hJzrTA5xuOZfMYJaav94/bNa1G1AZHA/sx
         IqeuX0m5wrq1olWYnCUFdWcRs4HHNmD+fSaxGCDngxV9gs9hEaGvpwiel6l6FYROI+wM
         b2h/J/0MtTn4wk+24P+lye5PvT7SR216V5ztbRz1yijbJD2TeXZKy39Wwf+AkV8DYbM0
         CP6fjXz/iairhkQqUorj+Ear31cpwrY8D8/ls28sODMfPbYKCYDBl2dAo83EtHCePTLH
         MGmTVzL/6+j8BOjr0vRr/sKO1HKHpXTj0Kqk+R5o3T3ezXSVTGqzUJFXtYU7FXUZdbq9
         iK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oZi4p9sU++IMNyLOoMu4O4MSpldoBC3la4O/D+JmVeE=;
        b=VrPlIDqgBj7VcqBkPZNhPa4lzAksthUTElJqJ00qyJbal581K9WOe2d+WeFe5cWE99
         CAJugBqaOQMBHjVPC5VhZfmu/Hq5N+UNcwJuN+7aNmD9cpHc/gVSgmL8i9Sc4cefvT/n
         MbS3fivVmgdi34nmdiVD2Mp1o7Om1+gcFaTKG9Nmr42MUtWJxq087n9RZIG2aUhGeLQA
         qvtpXxAEF9U/D0NQkznUc4HCV6kaZSzQkJ1bV60l/FtbR4gHuY8tolkNxX0c5HfxQhms
         lGoxWo+L+Ch8MIrnJHz2vMe/r7VFzhs2nGemfLIhbxzqfzt8smm7NJQFIHGNaO5tQ7sm
         e7Og==
X-Gm-Message-State: APjAAAW0rrap8Ylt82SebGa/C117x6QIG9DccZCpHlf9hxaHqG5Aac6M
        SOrq+qV6vyPecm/gfqP1M2Nq+QWSN/gHG+w0252xeA==
X-Google-Smtp-Source: APXvYqy2zouhlUGYS7Kh1lajVcXBTrIvaZyDmn96K5pB0TaQUQP3OryMKFONA/xS83RgDSxvOsb01vVyUXq5xlXLvmE=
X-Received: by 2002:a63:f94c:: with SMTP id q12mr30736518pgk.10.1565631367302;
 Mon, 12 Aug 2019 10:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190812023214.107817-1-natechancellor@gmail.com>
In-Reply-To: <20190812023214.107817-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 10:35:56 -0700
Message-ID: <CAKwvOd=RzY2bkOOYUrvNSxZxz6B2VPn2siXA8pRFc9EP-W77qQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 11, 2019 at 7:42 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
> setjmp is used") disabled -Wbuiltin-requires-header because of a warning
> about the setjmp and longjmp declarations.
>
> r367387 in clang added another diagnostic around this, complaining that
> there is no jmp_buf declaration.
>
> In file included from ../arch/powerpc/xmon/xmon.c:47:
> ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
> built-in function 'setjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern long setjmp(long *);
>             ^
> ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
> built-in function 'longjmp' requires the declaration of the 'jmp_buf'
> type, commonly provided in the header <setjmp.h>.
> [-Werror,-Wincomplete-setjmp-declaration]
> extern void longjmp(long *, long);
>             ^
> 2 errors generated.
>
> Take the same approach as the above commit by disabling the warning for
> the same reason, we provide our own longjmp/setjmp function.
>
> Cc: stable@vger.kernel.org # 4.19+
> Link: https://github.com/ClangBuiltLinux/linux/issues/625
> Link: https://github.com/llvm/llvm-project/commit/3be25e79477db2d31ac46493d97eca8c20592b07
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch, Nathan.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
> It may be worth using -fno-builtin-setjmp and -fno-builtin-longjmp
> instead as it makes it clear to clang that we are not using the builtin
> longjmp and setjmp functions, which I think is why these warnings are
> appearing (at least according to the commit that introduced this waring).
>
> Sample patch:
> https://github.com/ClangBuiltLinux/linux/issues/625#issuecomment-519251372
>
> However, this is the most conservative approach, as I have already had
> someone notice this error when building LLVM with PGO on tip of tree
> LLVM.
>
>  arch/powerpc/kernel/Makefile | 5 +++--
>  arch/powerpc/xmon/Makefile   | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index ea0c69236789..44e340ed4722 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -5,8 +5,9 @@
>
>  CFLAGS_ptrace.o                += -DUTS_MACHINE='"$(UTS_MACHINE)"'
>
> -# Disable clang warning for using setjmp without setjmp.h header
> -CFLAGS_crash.o         += $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
> +CFLAGS_crash.o         += $(call cc-disable-warning, builtin-requires-header) \
> +                          $(call cc-disable-warning, incomplete-setjmp-declaration)
>
>  ifdef CONFIG_PPC64
>  CFLAGS_prom_init.o     += $(NO_MINIMAL_TOC)
> diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
> index f142570ad860..53f341391210 100644
> --- a/arch/powerpc/xmon/Makefile
> +++ b/arch/powerpc/xmon/Makefile
> @@ -1,8 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for xmon
>
> -# Disable clang warning for using setjmp without setjmp.h header
> -subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header)
> +# Avoid clang warnings about longjmp and setjmp built-ins (inclusion of setjmp.h and declaration of jmp_buf type)
> +subdir-ccflags-y := $(call cc-disable-warning, builtin-requires-header) \
> +                   $(call cc-disable-warning, incomplete-setjmp-declaration)
>
>  GCOV_PROFILE := n
>  KCOV_INSTRUMENT := n
> --
> 2.23.0.rc2
>


-- 
Thanks,
~Nick Desaulniers
