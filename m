Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8482DD95C
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 20:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgLQTa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 14:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQTa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 14:30:28 -0500
X-Gm-Message-State: AOAM531jhmcd5QMKEaZnxNxiAcD2kX0u3SAYaHxgGm+buQuwC7p9mMgX
        cy7GwwHOhkBCsIX0MoYFY9FxgWBDvR4BiObGM9Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608233387;
        bh=HRY8YeVLSHAvObD2gzi1HyscgTfOcaMV6u6OwjX/7Vo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tM3fpjtJciyI5a8jL4IU2Yi9/zPHcWryWiiJczOp7eL2q4Ygc3zJqn/a2+DUhntrJ
         BELyh8lz0GqKdx3emD/xgKVXlp/AQYf2KYJt/+74jcEk8kXHQ74S5G8MgabaLzYYYN
         zfTGYOmRAN45wSNaoTGJP1xOOyUI1yAg+gcMPsBV/vQVF190pPHUAb3Fv7EmXlLRSR
         Vfund6xxHGGiwurZ6MGcAWdOr4IGw/MBpiH36Tr7dlwKrxoMkylSOZjwc0DnbfxBDp
         ADmPcigMY+umWLN2ETAKhygS9rK8ezLQ/4zUysQzlFU+eLtIWfufHLPkR9DlIjYIHZ
         9OsGggSdj1UbA==
X-Google-Smtp-Source: ABdhPJw2VdBQyPZ697Di5+5hmP4B46nBT/YDOuvakmMna4r2mnr1HGQCYk9mcrj4BtUaYcvzpnxWhv9ew4Z4L6Yc41o=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr362030ote.108.1608233386622;
 Thu, 17 Dec 2020 11:29:46 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOdkP8vHidFPWczC24XwNHhQaXovQiQ43Yb6Csp_+kPR9XQ@mail.gmail.com>
 <20201217004051.1247544-1-ndesaulniers@google.com>
In-Reply-To: <20201217004051.1247544-1-ndesaulniers@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 17 Dec 2020 20:29:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHpVDmZqgULT5Jsjwbfd8a5a6D4ojZXwTUUxi-DWvAFOA@mail.gmail.com>
Message-ID: <CAMj1kXHpVDmZqgULT5Jsjwbfd8a5a6D4ojZXwTUUxi-DWvAFOA@mail.gmail.com>
Subject: Re: [PATCH] arm64: link with -z norelro for LLD or aarch64-elf
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        kernel-team <kernel-team@android.com>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        Alan Modra <amodra@gmail.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Dec 2020 at 01:41, Nick Desaulniers <ndesaulniers@google.com> wr=
ote:
>
> With newer GNU binutils, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
>
> BFD can produce this warning when the target emulation mode does not
> support RELRO relocation types, and -z relro or -z norelro is passed.
>

RELRO is not a relocation type, it is a type of program header which
we might simply ignore, if it weren't for the fact that it can only be
emitted if the layout of the sections adheres to certain rules (and
ours doesn't), and we get an error otherwise.

It amounts to implicit __ro_after_init annotations for statically
initialized const pointers, but given that we don't compile with
-fpie, those const pointers reside in .rodata already, so RELRO adds
no value for us.

> Alan Modra clarifies:
>   The default linker emulation for an aarch64-linux ld.bfd is
>   -maarch64linux, the default for an aarch64-elf linker is
>   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
>   you get an emulation that doesn't support -z relro.
>
> The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
> -maarch64linux based on the toolchain configuration.
>
> LLD will always create RELRO relocation types regardless of target
> emulation.
>

RELRO program header

> To avoid the above warning when linking with BFD, pass -z norelro only
> when linking with LLD or with -maarch64linux.
>
> Cc: Alan Modra <amodra@gmail.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
> Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RE=
LOCATABLE")
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Reported-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

With mentions of 'RELRO relocation types' fixed:

Acked-by: Ard Biesheuvel <ardb@kernel.org>



> ---
>  arch/arm64/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 6be9b3750250..90309208bb28 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -10,7 +10,7 @@
>  #
>  # Copyright (C) 1995-2001 by Russell King
>
> -LDFLAGS_vmlinux        :=3D--no-undefined -X -z norelro
> +LDFLAGS_vmlinux        :=3D--no-undefined -X
>
>  ifeq ($(CONFIG_RELOCATABLE), y)
>  # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
> @@ -115,16 +115,20 @@ KBUILD_CPPFLAGS   +=3D -mbig-endian
>  CHECKFLAGS     +=3D -D__AARCH64EB__
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
> +
>  CHECKFLAGS     +=3D -D__aarch64__
>
>  ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
> --
> 2.29.2.684.gfbc64c5ab5-goog
>
