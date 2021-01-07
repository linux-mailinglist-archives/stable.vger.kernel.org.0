Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBC52ECFB8
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 13:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbhAGMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 07:30:55 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:44469 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbhAGMaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 07:30:55 -0500
Date:   Thu, 07 Jan 2021 12:30:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610022611; bh=e3bnSwSnCE4VZ3KFWoriT36YdZpDmKtvitn1N44EPZE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=XCLeYds6RzSh90AdJ1CaF4KFV3CHWPyxMwMhTa83qQc7MJ+JXPWLc+/UvPMcxndVL
         UiIFs1v1aKyG7f+cHiMq0XOWCY5IprIKS53oJ8y2+6AGa6QfX0PBurvT/8qz+F9HHz
         bLFgEVtQ8WvHyC+JvYTUjZwDYrrr5WIa6smG/oVCwR3QsHqwrxRa26XWHEqYUStDnV
         vaImFwahpngARKQ2Tzzgva60b/NBSfy4khM8l8epRK6+VyShEk6i/Okcwx/sn8Ochk
         26aHQbFY5oF817lW77n3OgIvBrlf5MlXKDJd3khCX9vwmc5yS697cb+qX+xCRtr3Vs
         RQaI2SRl9GiOQ==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3 mips-next 0/7] MIPS: vmlinux.lds.S sections fixes & cleanup
Message-ID: <20210107122944.353565-1-alobakin@pm.me>
In-Reply-To: <20210107115120.281008-1-alobakin@pm.me>
References: <20210107115120.281008-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This series hunts the problems discovered after manual enabling of
> ARCH_WANT_LD_ORPHAN_WARN. Notably:
>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
>    placement (marked for stable);
>  - properly stops .eh_frame section generation.
>=20
> Compile and runtime tested on MIPS32R2 CPS board with no issues
> using two different toolkits:
>  - Binutils 2.35.1, GCC 10.2.0;
>  - LLVM stack 11.0.0.
>=20
> Since v2 [1]:
>  - stop discarding .eh_frame and just prevent it from generating
>    (Kees);
>  - drop redundant sections assertions (Fangrui);
>  - place GOT table in .text instead of asserting as it's not empty
>    when building with LLVM (Nathan);
>  - catch compound literals in generic definitions when building with
>    LD_DEAD_CODE_DATA_ELIMINATION (Kees);
>  - collect two Reviewed-bys (Kees).
>=20
> Since v1 [0]:
>  - catch .got entries too as LLD may produce it (Nathan);
>  - check for unwanted sections to be zero-sized instead of
>    discarding (Fangrui).
>=20
> [0] https://lore.kernel.org/linux-mips/20210104121729.46981-1-alobakin@pm=
.me
> [1] https://lore.kernel.org/linux-mips/20210106200713.31840-1-alobakin@pm=
.me
>=20
> Alexander Lobakin (7):
>   MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
>   MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
>   MIPS: properly stop .eh_frame generation

Well, GNU fails to build VDSO with this patch... Sorry, sending
v4 now.

>   MIPS: vmlinux.lds.S: catch bad .rel.dyn at link time
>   MIPS: vmlinux.lds.S: explicitly declare .got table
>   vmlinux.lds.h: catch compound literals into data and BSS
>   MIPS: select ARCH_WANT_LD_ORPHAN_WARN
>=20
>  arch/mips/Kconfig                 |  1 +
>  arch/mips/include/asm/asm.h       | 18 ++++++++++++++++++
>  arch/mips/kernel/vmlinux.lds.S    | 15 ++++++++++++++-
>  include/asm-generic/vmlinux.lds.h |  6 +++---
>  4 files changed, 36 insertions(+), 4 deletions(-)
>=20
> --
> 2.30.0

Al

