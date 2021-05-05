Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0D374794
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 20:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhEER7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:59:22 -0400
Received: from condef-03.nifty.com ([202.248.20.68]:43349 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbhEER6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 13:58:33 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2021 13:58:33 EDT
Received: from conssluserg-04.nifty.com ([10.126.8.83])by condef-03.nifty.com with ESMTP id 145Ho8Cq006910
        for <stable@vger.kernel.org>; Thu, 6 May 2021 02:50:08 +0900
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 145HmlZd022765;
        Thu, 6 May 2021 02:48:48 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 145HmlZd022765
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1620236928;
        bh=ir46Etvd5HEmsWvvFCQEwM57MdYnrHyoHbe/TY2pWzc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LNOr7+LT36L3hMmoIpQlw1KSWsGcQ8iTqxP+zvh4E3ASO2V0LSG7a84Hu40OLhWre
         p/EjMtKaS+GK6WMyyP/X9n/OMlTrMkXLA2DM0WECrVxW3/e5DPIuFHsEJz2yb/2WRQ
         xkPakWttikbI9V2YirUlPjaxi8bMhRS2QLBN0abxLrGTvGrUn3OJLyT9u7I8wRRutd
         JEakrqgfZjelHPPtCNosmDxAe7ecdzIcs0V0F0GnJLdHghh44Ts/huRp3QVSCzByAx
         tPRDFuJRP40tEBnYkNqj30U1NJuPpUCbKAhJN6g/r6rCaKCfwi3sXAuoLeGEX0rdIZ
         Eo46c3+uQpc5g==
X-Nifty-SrcIP: [209.85.210.181]
Received: by mail-pf1-f181.google.com with SMTP id k19so2559973pfu.5;
        Wed, 05 May 2021 10:48:48 -0700 (PDT)
X-Gm-Message-State: AOAM530DDvNWoh7d/VmROT8HBh7H92R1Ze6oyxcnprNuPu8DZN4Eh7d8
        6/A5SeeeQWpqmrOrxKtUwY3oukm4UMAsNKJPNvI=
X-Google-Smtp-Source: ABdhPJyCdBNyaOJiflaHdKR5PDKWCDLq+i4udJVtRFg/IF7IUqeC4W+j41RUQLwaR6bp40Gl4VrnSwz494BFHuJN31U=
X-Received: by 2002:a63:e044:: with SMTP id n4mr107487pgj.47.1620236927301;
 Wed, 05 May 2021 10:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210429012350.600951-1-nathan@kernel.org>
In-Reply-To: <20210429012350.600951-1-nathan@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 6 May 2021 02:48:09 +0900
X-Gmail-Original-Message-ID: <CAK7LNARJt9tx1_Uuw2S_RLcrqaueAOf2D2UdNH7XP4zRzdaJ3g@mail.gmail.com>
Message-ID: <CAK7LNARJt9tx1_Uuw2S_RLcrqaueAOf2D2UdNH7XP4zRzdaJ3g@mail.gmail.com>
Subject: Re: [PATCH] Makefile: Move -Wno-unused-but-set-variable out of GCC
 only block
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 10:24 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Currently, -Wunused-but-set-variable is only supported by GCC so it is
> disabled unconditionally in a GCC only block (it is enabled with W=1).
> clang currently has its implementation for this warning in review so
> preemptively move this statement out of the GCC only block and wrap it
> with cc-disable-warning so that both compilers function the same.
>
> Cc: stable@vger.kernel.org
> Link: https://reviews.llvm.org/D100581
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---


Applied to linux-kbuild. Thanks.


>  Makefile | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index f03888cdba4e..911d839cfea8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -775,16 +775,16 @@ KBUILD_CFLAGS += -Wno-gnu
>  KBUILD_CFLAGS += -mno-global-merge
>  else
>
> -# These warnings generated too much noise in a regular build.
> -# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
> -KBUILD_CFLAGS += -Wno-unused-but-set-variable
> -
>  # Warn about unmarked fall-throughs in switch statement.
>  # Disabled for clang while comment to attribute conversion happens and
>  # https://github.com/ClangBuiltLinux/linux/issues/636 is discussed.
>  KBUILD_CFLAGS += $(call cc-option,-Wimplicit-fallthrough,)
>  endif
>
> +# These warnings generated too much noise in a regular build.
> +# Use make W=1 to enable them (see scripts/Makefile.extrawarn)
> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
> +
>  KBUILD_CFLAGS += $(call cc-disable-warning, unused-const-variable)
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  += -fno-omit-frame-pointer -fno-optimize-sibling-calls
>
> base-commit: d8201efe75e13146ebde433745c7920e15593baf
> --
> 2.31.1.362.g311531c9de
>


-- 
Best Regards
Masahiro Yamada
