Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241FC228BDF
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgGUWP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 18:15:56 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:64746 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGUWP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 18:15:56 -0400
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 06LMFG4v024349;
        Wed, 22 Jul 2020 07:15:17 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 06LMFG4v024349
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1595369718;
        bh=vR1Y8P9QQm4CTezIGezqaKkPlD5HSAJvtH4tLGcsSBI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Eac1OkjRpXczpVkoHps5q00SjaAGdrQ3pmDGHflV2eWLHwS9LUnXYJosQBVz0UOFJ
         atSqHwrjAyEqKhhMCDEp8gwAke30wrqbqvvi4lNmMa7gumSCpmUVL/vLMchR8jjKyq
         xbDGV9JH2i3/zqvStgXRklaXyKjGDbNGh3yQ9HK03urpCmxPAhwXQdZ4eou/4l+Esb
         Vqij88PKHqQRSj9ZyeZiCqK8drr6KjJKQsZWrvfWZLE4cVET/n6SYbK9Va4ZDFNiP5
         KCPX+0qwTVEPdYdDJVfO2+1vCzS/ra4OaFB36trWx5dGdyr6f2GQJDUL8eWZZzbjnY
         RQ3dTkGUPMDYg==
X-Nifty-SrcIP: [209.85.222.45]
Received: by mail-ua1-f45.google.com with SMTP id o25so2610uar.1;
        Tue, 21 Jul 2020 15:15:17 -0700 (PDT)
X-Gm-Message-State: AOAM530IRbG3+lOvgD6rulQC2H99mTIThdfVnrbgoQQHaaNDc1HgkrWH
        J/CFyn1P1aUdWOesoDNxGKsM+c88iGicZCAbpy4=
X-Google-Smtp-Source: ABdhPJyfvusDeLSk02B9TNvScFemIglbaRo6s+sUXc0hUvfsW+NlwIYAiHd3h/00MalC6DXvqL7qEYtSs9IWJGdOHqk=
X-Received: by 2002:ab0:48:: with SMTP id 66mr22845681uai.40.1595369716204;
 Tue, 21 Jul 2020 15:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200721173125.1273884-1-maskray@google.com>
In-Reply-To: <20200721173125.1273884-1-maskray@google.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 22 Jul 2020 07:14:39 +0900
X-Gmail-Original-Message-ID: <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
Message-ID: <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
Subject: Re: [PATCH v3] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation
To:     Fangrui Song <maskray@google.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        stable <stable@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 2:31 AM 'Fangrui Song' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> /usr/bin/ and Clang as of 11 will search for both
> $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
>
> GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
>
> To better model how GCC's -B/--prefix takes in effect in practice, newer
> Clang (since
> https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> instead of /usr/bin/aarch64-linux-gnu-as.
>
> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> appropriate cross compiling GNU as (when -no-integrated-as is in
> effect).
>
> Cc: stable@vger.kernel.org
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> ---
> Changes in v2:
> * Updated description to add tags and the llvm-project commit link.
> * Fixed a typo.
>
> Changes in v3:
> * Add Cc: stable@vger.kernel.org
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 0b5f8538bde5..3ac83e375b61 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>  ifneq ($(CROSS_COMPILE),)
>  CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
> -CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
> +CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)



CROSS_COMPILE may contain the directory path
to the cross toolchains.


For example, I use aarch64-linux-gnu-*
installed in
/home/masahiro/tools/aarch64-linaro-7.5/bin



Basically, there are two ways to use it.

[1]
PATH=$PATH:/home/masahiro/tools/aarch64-linaro-7.5/bin
CROSS_COMPILE=aarch64-linux-gnu-


[2]
Without setting PATH,
CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-



I usually do [2] (and so does intel's 0day bot).



This patch works for the use-case [1]
but if I do [2], --prefix is set to a strange path:

--prefix=/home/masahiro/tools/aarch64-linaro-7.5/bin//home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-



Interestingly, the build is still successful.
Presumably Clang searches for more paths
when $(prefix)$needle is not found ?



I applied your patch and added -v option
to see which assembler was internally invoked:

 "/home/masahiro/tools/aarch64-linaro-7.5/lib/gcc/aarch64-linux-gnu/7.5.0/../../../../aarch64-linux-gnu/bin/as"
-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
./include -I ./arch/arm64/include/uapi -I
./arch/arm64/include/generated/uapi -I ./include/uapi -I
./include/generated/uapi -o kernel/smp.o /tmp/smp-2ec2c7.s


Ok, it looks like Clang found an alternative path
to the correct 'as'.




But, to keep the original behavior for both [1] and [2],
how about this?

CLANG_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))



Then, I can get this:

 "/home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-as"
-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
./include -I ./arch/arm64/include/uapi -I
./arch/arm64/include/generated/uapi -I ./include/uapi -I
./include/generated/uapi -o kernel/smp.o /tmp/smp-16d76f.s





>  GCC_TOOLCHAIN  := $(realpath $(GCC_TOOLCHAIN_DIR)/..)
>  endif
>  ifneq ($(GCC_TOOLCHAIN),)
> --
> 2.28.0.rc0.105.gf9edc3c819-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200721173125.1273884-1-maskray%40google.com.



--
Best Regards
Masahiro Yamada
