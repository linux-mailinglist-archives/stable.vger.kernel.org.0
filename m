Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4D7AE55
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 18:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfG3Qqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 12:46:40 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:35658 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfG3Qqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 12:46:40 -0400
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x6UGkX0I027799;
        Wed, 31 Jul 2019 01:46:33 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x6UGkX0I027799
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564505194;
        bh=Ok/KGDQSrCYrPibwFAYS5ZsFlsGiUOUaXlIYe533dXI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jJkn+qz4pPyDFnecgUThOrH38LSRxJAyFa+PfoMyz6ByxmXp3cX4XE3z7AQbXHYR5
         iNvGBBSkGrGZNMY7HRfjMNwcUb+tugk2HDBvl7YEW9+weHXCZd1OdOPWaos4wndodV
         MeBkHwzsaAL92L1orFCrWmne9dVUp/f5W8DpUoa7copqyQaPMF0OL/TDlZ4PXD9yGT
         NnBKBGGRopv4c6LZkI1fTr+C2lWzLhzPsKKiA30YAu8aYf5ifVbxBVeC9Evtrr8DPd
         OwCxMzRRRLl5ntC0YEU6+AHVxivTOC3AxVif5e5/Jl1QeCK9FYetR1xnMl9RSh/0q1
         Kra+EgA3A+vyA==
X-Nifty-SrcIP: [209.85.221.179]
Received: by mail-vk1-f179.google.com with SMTP id w186so4499411vkd.11;
        Tue, 30 Jul 2019 09:46:33 -0700 (PDT)
X-Gm-Message-State: APjAAAWCyw+z+NHIXubVk8WNNH3g18R0R500Fd2hZ6vFzzaqw7NNcvtK
        62sLLfqiX2e0c8GaXYSB8N+CLUOPLkyB/OAD2Rk=
X-Google-Smtp-Source: APXvYqx8RzQy+2qahU1wwN55Nyx7msaGiaMPpcxVcU0QKaVemQtEEfS1n0Ok3MAL0+lRwW3X8r+CSvHOSJwia82VNjM=
X-Received: by 2002:a1f:ac1:: with SMTP id 184mr45919137vkk.0.1564505192554;
 Tue, 30 Jul 2019 09:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190729091517.5334-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190729091517.5334-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 31 Jul 2019 01:45:56 +0900
X-Gmail-Original-Message-ID: <CAK7LNASyjUbM1ij8E1tO3uD3Rpi_qC6-X4=LKR+ZKh5g6vvBnQ@mail.gmail.com>
Message-ID: <CAK7LNASyjUbM1ij8E1tO3uD3Rpi_qC6-X4=LKR+ZKh5g6vvBnQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: initialize CLANG_FLAGS correctly in the top Makefile
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Stephen Boyd <swboyd@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 6:16 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> CLANG_FLAGS is initialized by the following line:
>
>   CLANG_FLAGS     := --target=$(notdir $(CROSS_COMPILE:%-=%))
>
> ..., which is run only when CROSS_COMPILE is set.
>
> Some build targets (bindeb-pkg etc.) recurse to the top Makefile.
>
> When you build the kernel with Clang but without CROSS_COMPILE,
> the same compiler flags such as -no-integrated-as are accumulated
> into CLANG_FLAGS.
>
> If you run 'make CC=clang' and then 'make CC=clang bindeb-pkg',
> Kbuild will recompile everything needlessly due to the build command
> change.
>
> Fix this by correctly initializing CLANG_FLAGS.
>
> Fixes: 238bcbc4e07f ("kbuild: consolidate Clang compiler flags")
> Cc: <stable@vger.kernel.org> # v4.20+
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---

Applied to linux-kbuild.



>
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index fa0fbe7851ea..5ee6f6889869 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -472,6 +472,7 @@ KBUILD_CFLAGS_MODULE  := -DMODULE
>  KBUILD_LDFLAGS_MODULE := -T $(srctree)/scripts/module-common.lds
>  KBUILD_LDFLAGS :=
>  GCC_PLUGINS_CFLAGS :=
> +CLANG_FLAGS :=
>
>  export ARCH SRCARCH CONFIG_SHELL HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE AS LD CC
>  export CPP AR NM STRIP OBJCOPY OBJDUMP PAHOLE KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS
> @@ -519,7 +520,7 @@ endif
>
>  ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>  ifneq ($(CROSS_COMPILE),)
> -CLANG_FLAGS    := --target=$(notdir $(CROSS_COMPILE:%-=%))
> +CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
>  CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
>  GCC_TOOLCHAIN  := $(realpath $(GCC_TOOLCHAIN_DIR)/..)
> --
> 2.17.1
>


-- 
Best Regards
Masahiro Yamada
