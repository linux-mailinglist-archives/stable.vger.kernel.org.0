Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9824E592
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 07:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgHVFOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 01:14:39 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:53380 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgHVFOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 01:14:38 -0400
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 07M5EFXM021249;
        Sat, 22 Aug 2020 14:14:16 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 07M5EFXM021249
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1598073256;
        bh=4FjA6DiNrgZGC6Vw0nWpQF20KUNU2N4bk2zh75rtHw0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=abWVB3xa5jOHzBS5UTEgfM9975axbclzHit69E0DdZsttOiNYxICAw+jn+C6zZCg8
         tvmQBvTuj9o2M/K5P4mcrr9BJkJPQe4tAmMKHobrljbISuwm2ZrBH/IJSu2ih7gbVX
         yVNQAFyHz5ui8pamhpPIKLMCmMkDZsTvigVBqVkwokx4eR6jO8l0aJiGdX6b+MvCn3
         7gcVmjh4DcV1BwWwLwpYStq5FwVTFxqye+lqS9YM/92K8ytGy1phX6kmBgzuA6LV1s
         k+BBQoQVdZOCSA1INLtZG6UFYCWYB5FRBig0gzUCjtmWefwy+wUjFP1v/iS9sfYskh
         deRTZ9a0aF67A==
X-Nifty-SrcIP: [209.85.221.178]
Received: by mail-vk1-f178.google.com with SMTP id s81so886434vkb.3;
        Fri, 21 Aug 2020 22:14:16 -0700 (PDT)
X-Gm-Message-State: AOAM530abFoFobUGbAtwMflQMC1PpR9DlVz1FDSdFKPxwt8mN7aeW/4S
        7rGTIPt7uK83OaapsmPWAnjVyanevqUridJ31lw=
X-Google-Smtp-Source: ABdhPJzEUYgjZNj9Kt5YBK/Q6C4u/AK4jmBzy5Fg3fSDwg7ixaVTsnJThSpwhdZEajfjuMCpFNiPTwxef96YWVpf4GY=
X-Received: by 2002:a1f:8f52:: with SMTP id r79mr3870370vkd.96.1598073254960;
 Fri, 21 Aug 2020 22:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200820220955.3325555-1-ndesaulniers@google.com>
In-Reply-To: <20200820220955.3325555-1-ndesaulniers@google.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 22 Aug 2020 14:13:38 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQO9sKw=7RLPSnsChddrwNCc_si-XgSDQcGHTSxeq4_Pg@mail.gmail.com>
Message-ID: <CAK7LNAQO9sKw=7RLPSnsChddrwNCc_si-XgSDQcGHTSxeq4_Pg@mail.gmail.com>
Subject: Re: [PATCH] Makefile: add -fuse-ld=lld to KBUILD_HOSTLDFLAGS when LLVM=1
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 7:10 AM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> While moving Android kernels over to use LLVM=1, we observe the failure
> when building in a hermetic docker image:
>   HOSTCC  scripts/basic/fixdep
> clang: error: unable to execute command: Executable "ld" doesn't exist!
>
> The is because the build of the host utility fixdep builds the fixdep
> executable in one step by invoking the compiler as the driver, rather
> than individual compile then link steps.
>
> Clang when configured from source defaults to use the system's linker,
> and not LLVM's own LLD, unless the CMake config
> -DCLANG_DEFAULT_LINKER='lld' is set when configuring a build of clang
> itself.
>
> Don't rely on the compiler's implicit default linker; be explicit.


I do not understand this patch.

The host compiler should be able to link executables
without any additional settings.

So, can you link a hello world program
in your docker?

masahiro@zoe:~$ cat test.c
#include <stdio.h>
int main(void)
{
        printf("helloworld\n");
        return 0;
}
masahiro@zoe:~$ clang test.c


If this fails, your environment is broken.

Just do  -DCLANG_DEFAULT_LINKER='lld'
if you know GNU ld is missing in your docker environment.








> Cc: stable@vger.kernel.org
> Fixes: commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default tools to Clang/LLVM")
> Reported-by: Matthias Maennich <maennich@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Makefile b/Makefile
> index def590b743a9..b4e93b228a26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -436,6 +436,7 @@ OBJDUMP             = llvm-objdump
>  READELF                = llvm-readelf
>  OBJSIZE                = llvm-size
>  STRIP          = llvm-strip
> +KBUILD_HOSTLDFLAGS     += -fuse-ld=lld
>  else
>  CC             = $(CROSS_COMPILE)gcc
>  LD             = $(CROSS_COMPILE)ld
> --
> 2.28.0.297.g1956fa8f8d-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200820220955.3325555-1-ndesaulniers%40google.com.



-- 
Best Regards
Masahiro Yamada
