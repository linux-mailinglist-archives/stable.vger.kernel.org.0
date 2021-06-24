Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FD03B36AD
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 21:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhFXTQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 15:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbhFXTQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 15:16:52 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80106C061574
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 12:14:31 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x24so12045565lfr.10
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 12:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03hcEW8lfe7Z9hBO2bPB7tVxzSQGqHblcGENsry3uQ0=;
        b=SbAv4Lr+3UXuFxrAQkqgfTGUpHQ/EwVvDlLkDpHFB1LBOWNXuceQ96F5OK1CpYvJOU
         CIldToUAzOm/XtcV5E9/TsdH5QdUeWrEFIfLKIv9WsPPjP0d13wHlbk3II6Ms+b0xMSd
         mDuvUNYG6Vw5IZhXvSE3vMFuIbymunj5obLFr8cHWCKYf4tXUciFNMVTYaOQV8R/SKnz
         MjSsLuh5et7RE+RdWkwqKwdf0b8CSGPW4aAisf1MJTC+azzr2P5RptBNVRmpNFZxU7bn
         Lth6hth1Q2KHn2sPyTchGc5p4YabvTZz9OJnMHtlToRWqGAfmKV8AKaAHiXBvuD9g80w
         CDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=03hcEW8lfe7Z9hBO2bPB7tVxzSQGqHblcGENsry3uQ0=;
        b=LFaBenRC/EskU3107ZMeuZos5o4FIXuywC2w2S/M2LpfYG+387HKkUWi3tWkOrmNvA
         02pSj5SvXxiMuoKk/qbBEwWI6LyZ//IER/OWMKwUmxQ6v5GXmSQ1M0Ddr0nfynbqG5z7
         a2OZXjDoTWslEt24Qkbj2ukqy9fNcz7oCUMuBda0JjqAw4EzLmb1KGhfCpnS6PBMP+1Z
         WwMKltcv5G4/xQO3RId/l0s7fvAUmKY4f0qsWxFmjI8UCykzIgCy1R/BlngGhYsoOQ7M
         N8E9xOeWV7+WgsOi8SG/XZyWWOcWsNh0w2tCKIrt+rWkcLm6ZBnF0NDwoMX4MmtzyHGG
         Bmfg==
X-Gm-Message-State: AOAM533r5JdFDlmpqzB+R/rI/8W+yUsiOeqrvC+uRO0YcoIS1fwnT3H4
        LS8Zb6Ae75I/v73l8MpDaJlP70sYpGBDlXyFyguYQg==
X-Google-Smtp-Source: ABdhPJyMoZ4LxR/kopXuwsvJkMvXe9wiMx9duN4ivrBtDI5EO0y/uYIFuXDZMEvH6OMLw2+/CGMalDMww7um8nKg5+M=
X-Received: by 2002:a05:6512:3884:: with SMTP id n4mr5003287lft.547.1624562069597;
 Thu, 24 Jun 2021 12:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210624170919.3d018a1a@xhacker.debian>
In-Reply-To: <20210624170919.3d018a1a@xhacker.debian>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 24 Jun 2021 12:14:14 -0700
Message-ID: <CAKwvOdnG42WY-7OdGZ2wVDLsjPS7uim0V2_8Z5_L-3yLmk+pqQ@mail.gmail.com>
Subject: Re: [PATCH stable v5.4] arm64: link with -z norelro for LLD or aarch64-elf
To:     Jisheng Zhang <jisheng.zhang@synaptics.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 24, 2021 at 2:09 AM Jisheng Zhang
<Jisheng.Zhang@synaptics.com> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
>
> commit 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 upstream.
>
> With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
>
> BFD can produce this warning when the target emulation mode does not
> support RELRO program headers, and -z relro or -z norelro is passed.
>
> Alan Modra clarifies:
>   The default linker emulation for an aarch64-linux ld.bfd is
>   -maarch64linux, the default for an aarch64-elf linker is
>   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
>   you get an emulation that doesn't support -z relro.
>
> The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
> -maarch64linux based on the toolchain configuration.
>
> LLD will always create RELRO program header regardless of target
> emulation.
>
> To avoid the above warning when linking with BFD, pass -z norelro only
> when linking with LLD or with -maarch64linux.
>
> Fixes: 3b92fa7485eb ("arm64: link with -z norelro thank you regardless of=
 CONFIG_RELOCATABLE")

^ exists in 5.4 as 57a88e44b512

> Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker s=
cript and options")

^ landed in v5.0-rc1

> Cc: <stable@vger.kernel.org> # 5.0.x-
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Reported-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Cc: Alan Modra <amodra@gmail.com>
> Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
> Link: https://lore.kernel.org/r/20201218002432.788499-1-ndesaulniers@goog=
le.com
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index cd8f3cdabfd0..d227cf87c48f 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -10,7 +10,7 @@
>  #
>  # Copyright (C) 1995-2001 by Russell King
>
> -LDFLAGS_vmlinux        :=3D--no-undefined -X -z norelro
> +LDFLAGS_vmlinux        :=3D--no-undefined -X
>  CPPFLAGS_vmlinux.lds =3D -DTEXT_OFFSET=3D$(TEXT_OFFSET)
>  GZFLAGS                :=3D-9
>
> @@ -82,17 +82,21 @@ CHECKFLAGS  +=3D -D__AARCH64EB__
>  AS             +=3D -EB
>  # Prefer the baremetal ELF build target, but not all toolchains include
>  # it so fall back to the standard linux version if needed.
> -KBUILD_LDFLAGS +=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb=
)
> +KBUILD_LDFLAGS +=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb=
 -z norelro)
>  UTS_MACHINE    :=3D aarch64_be
>  else
>  KBUILD_CPPFLAGS        +=3D -mlittle-endian
>  CHECKFLAGS     +=3D -D__AARCH64EL__
>  AS             +=3D -EL
>  # Same as above, prefer ELF but fall back to linux target if needed.
> -KBUILD_LDFLAGS +=3D -EL $(call ld-option, -maarch64elf, -maarch64linux)
> +KBUILD_LDFLAGS +=3D -EL $(call ld-option, -maarch64elf, -maarch64linux -=
z norelro)
>  UTS_MACHINE    :=3D aarch64
>  endif
>
> +ifeq ($(CONFIG_LD_IS_LLD), y)
> +KBUILD_LDFLAGS +=3D -z norelro
> +endif

^ ah but 5.4 doesn't have
commit b744b43f79cc ("kbuild: add CONFIG_LD_IS_LLD")
which landed in v5.8-rc1. So this patch will break LLD on 5.4. That
should be trivial to backport, but would you please send that first,
then this?

> +
>  CHECKFLAGS     +=3D -D__aarch64__
>
>  ifeq ($(CONFIG_ARM64_MODULE_PLTS),y)
> --
> 2.32.0
>


--
Thanks,
~Nick Desaulniers
