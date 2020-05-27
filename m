Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9911E4CA6
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 20:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgE0SDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729082AbgE0SDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 14:03:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F455C08C5C1
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:03:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 131so3787308pfv.13
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1i+2CYKnygDzk/GvSPMFnlsBZ+PDQAs0JHC2OCU8Rpg=;
        b=Juuy34H7e5clylfdiyvSvG4F1wyq9c8Gaj8QNysrOlDgGCGB7A08vEUvk3NP/Wn1H6
         Yog5pD+mXyHk+WVgoLhuHW3Omp5d+eepMRoD2hYNRRK5PkkUSlyxec51h45s6fdpYill
         lA4WHf6wyk335XsVHjeAc4Q2RIQDLyeAIKwrzDBommB66eFrjgaTrHUKh+YskoAupwbq
         eDWaNMQh5VN1aoa5wksCQ49WwMi1vHRhUDNMtMhCEclzc24PdY4Wv3QfxGMydNAOePYK
         xdcnU39N8S3XzdUmTP21oRzd9CrtlFniuJBnOhhkPr0/09QMJdtokXOxrAby+3nxwfjm
         aARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1i+2CYKnygDzk/GvSPMFnlsBZ+PDQAs0JHC2OCU8Rpg=;
        b=mEkbjYzE0MaSKhE+EKSvngSoDrBrUkdg1u1eLdruIJu98cGiU8f3+3CG3huFg9CQIH
         M1oulM8pxzZJ34ruV1OHIyTtdCtXou/549dRoAkKW+MHI1osMOYsthdPaXWHJVws+Sxg
         yiHyHSoNjGz/W9oXgON7MzcwQC+faD8Fn1ajTDTYJ+J4KkynhvGX0TzRXs/Yh6VIoJ3B
         sLBsWOyhRS4Gwb982mSEqzMVhbLCrBbmrE0u3FjN25J03ETbReGKkhxtLwoKaaOJDLNr
         0aIa0yH8+9LBa0OIc8M+Fz2xGb3bULF7z0tpo6twKreEIPpYsuMbUOmvoxaAcC8HG45y
         NLaw==
X-Gm-Message-State: AOAM532HHtVz6xBy/h27/E39S4dgGMvLy1uZ2ycURvXJqp9M/GJspe60
        ms7wACwJ9QTtpvibs3lp/eQVNowWqStZVB16zmmpZg==
X-Google-Smtp-Source: ABdhPJzzSTK199jYEXH1x++KGRbblCgHnTwlQdoA6pICLSVL6mQAiv7Qjw8mXRGdXDnysRpSmZq3n9RSuMqpypAtzOk=
X-Received: by 2002:aa7:8c44:: with SMTP id e4mr5128942pfd.108.1590602615524;
 Wed, 27 May 2020 11:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200527141435.1716510-1-arnd@arndb.de>
In-Reply-To: <20200527141435.1716510-1-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 27 May 2020 11:03:24 -0700
Message-ID: <CAKwvOdnNxj-MdKj3aWoefF2W9PPG-TSeNU4Ym-N8NODJB5Yw_w@mail.gmail.com>
Subject: Re: [PATCH] arm64: fix clang integrated assembler build
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Enrico Weigelt <info@metux.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Bill Wendling <morbo@google.com>,
        Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 7:14 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> clang and gas seem to interpret the symbols in memmove.S and
> memset.S differently, such that clang does not make them
> 'weak' as expected, which leads to a linker error, with both
> ld.bfd and ld.lld:
>
> ld.lld: error: duplicate symbol: memmove
> >>> defined at common.c
> >>>            kasan/common.o:(memmove) in archive mm/built-in.a
> >>> defined at memmove.o:(__memmove) in archive arch/arm64/lib/lib.a
>
> ld.lld: error: duplicate symbol: memset
> >>> defined at common.c
> >>>            kasan/common.o:(memset) in archive mm/built-in.a
> >>> defined at memset.o:(__memset) in archive arch/arm64/lib/lib.a
>
> Copy the exact way these are written in memcpy_64.S, which does
> not have the same problem.
>
> I don't know why this makes a difference, and it would be good
> to have someone with a better understanding of assembler internals
> review it.
>
> It might be either a bug in the kernel or a bug in the assembler,
> no idea which one. My patch makes it work with all versions of
> clang and gcc, which is probably helpful even if it's a workaround
> for a clang bug.

+ Bill, Fangrui, Jian
I think we saw this bug or a very similar bug internally around the
ordering of .weak to .global.

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> ---
>  arch/arm64/lib/memcpy.S  | 3 +--
>  arch/arm64/lib/memmove.S | 3 +--
>  arch/arm64/lib/memset.S  | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
> index e0bf83d556f2..dc8d2a216a6e 100644
> --- a/arch/arm64/lib/memcpy.S
> +++ b/arch/arm64/lib/memcpy.S
> @@ -56,9 +56,8 @@
>         stp \reg1, \reg2, [\ptr], \val
>         .endm
>
> -       .weak memcpy
>  SYM_FUNC_START_ALIAS(__memcpy)
> -SYM_FUNC_START_PI(memcpy)
> +SYM_FUNC_START_WEAK_PI(memcpy)
>  #include "copy_template.S"
>         ret
>  SYM_FUNC_END_PI(memcpy)
> diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
> index 02cda2e33bde..1035dce4bdaf 100644
> --- a/arch/arm64/lib/memmove.S
> +++ b/arch/arm64/lib/memmove.S
> @@ -45,9 +45,8 @@ C_h   .req    x12
>  D_l    .req    x13
>  D_h    .req    x14
>
> -       .weak memmove
>  SYM_FUNC_START_ALIAS(__memmove)
> -SYM_FUNC_START_PI(memmove)
> +SYM_FUNC_START_WEAK_PI(memmove)
>         cmp     dstin, src
>         b.lo    __memcpy
>         add     tmp1, src, count
> diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
> index 77c3c7ba0084..a9c1c9a01ea9 100644
> --- a/arch/arm64/lib/memset.S
> +++ b/arch/arm64/lib/memset.S
> @@ -42,9 +42,8 @@ dst           .req    x8
>  tmp3w          .req    w9
>  tmp3           .req    x9
>
> -       .weak memset
>  SYM_FUNC_START_ALIAS(__memset)
> -SYM_FUNC_START_PI(memset)
> +SYM_FUNC_START_WEAK_PI(memset)
>         mov     dst, dstin      /* Preserve return value.  */
>         and     A_lw, val, #255
>         orr     A_lw, A_lw, A_lw, lsl #8
> --
> 2.26.2

-- 
Thanks,
~Nick Desaulniers
