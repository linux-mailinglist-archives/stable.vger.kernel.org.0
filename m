Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8842EA153
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 01:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhAEALB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 19:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhAEALB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 19:11:01 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37945C061793;
        Mon,  4 Jan 2021 16:10:19 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id i18so26677182ioa.1;
        Mon, 04 Jan 2021 16:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=LJZDZGduu6iANLcIXL/xcpeuMsOJEmvZp5eNkLssDnk=;
        b=HpvjmJGAbbbjlmCixc58dtpp8SNX8qEfhTnwTZWxulFdrU356kfpSdwfPuZbwKYS0E
         TlRyUV4Q34uyD7yBtcZcwWUcmz9Pn78hqSmC2jVUnzjJ71gaDuGmTQGxmAySlXM5FzLJ
         d4LnjMBnebjveWaN29ZBor+0zljSjWKqaaOJIBdECVy5fhCHICUXO3DzIGR2m5AnxR1S
         0GJNkROOsHMGxhLdVjdSne3M7WTrefpu7EukDu0z2kVL7ksbD9lzpjd0nVvkiWXVZzfc
         hrW63sRi85wNYkxY7Rss4m2RPXhwwboNZx4fhMILoWO7A3vAAo7L+7ShA1VmyY73PcQR
         Pnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=LJZDZGduu6iANLcIXL/xcpeuMsOJEmvZp5eNkLssDnk=;
        b=fm7Uo1EOm+Y/Vk0Fu8uKFEM6mdDoH4x4B916rFoVdzBVtOHrbN6QaZlmTsiHsmmO9Y
         htyYKNLWWi2kP5ubyBY1ZECN3Fep9tKOXs9Nd0cVXEOj0nLnM2bVXJz0rb+gCH26t0kT
         rp8mvinLxdC2E1DKdtGZePhIoyXpWfZcgQd8n8+FD+raNkcfBdPSkxMPFf+8DagkC50n
         +yn8xqQSRM3A5HxKvPZeE2eAkQ/b+PZspR8LqNO1MsK5UfuGltZ7CgYvoVfV/pQeGMK0
         rnOr23FEJGVO8qXCTbsP2hye6ROUwN+4rNuVvIXtu1vXubj5nW/OVf0qHpEsTWMc9DNu
         gQ8g==
X-Gm-Message-State: AOAM531sFiE4QH4fmjksvCsYreglt2MmFCnZbgnFfMnNQFfx/t34XMs8
        /Wm5J0t3J7mNdY0Z7gbLtmHLPYZWnwKV2nQL+rkPYQkbIVErfQ==
X-Google-Smtp-Source: ABdhPJzvhpXZ+mTh/umgp6WkZP62Ntun32b6redNm/1pnVmAWhULh8ucL85Bt6DEgUPmU3XQAf+D0zsIb/9O3Rubxgc=
X-Received: by 2002:a6b:92c4:: with SMTP id u187mr59442416iod.57.1609793731531;
 Mon, 04 Jan 2021 12:55:31 -0800 (PST)
MIME-Version: 1.0
References: <20210104204850.990966-1-natechancellor@gmail.com>
In-Reply-To: <20210104204850.990966-1-natechancellor@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 4 Jan 2021 21:55:20 +0100
Message-ID: <CA+icZUVe4AJoLWMqS3MEx700jcwDaJhw78tUgg8iD0dJvEmmYg@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Handle .text.{hot,unlikely}.* in linker script
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 9:49 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
> sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
> change [1].
>
> After another LLVM change [2], these sections are seen in some PowerPC
> builds, where there is a orphan section warning then build failure:
>

Looks like you forgot to add your references/links to [1] and [2].

Might be good to mention...?

With CONFIG_LD_ORPHAN_WARN=y is enabled

- Sedat

> $ make -skj"$(nproc)" \
>        ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out \
>        distclean powernv_defconfig zImage.epapr
> ld.lld: warning: kernel/built-in.a(panic.o):(.text.unlikely.) is being placed in '.text.unlikely.'
> ...
> ld.lld: warning: address (0xc000000000009314) of section .text is not a multiple of alignment (256)
> ...
> ERROR: start_text address is c000000000009400, should be c000000000008000
> ERROR: try to enable LD_HEAD_STUB_CATCH config option
> ERROR: see comments in arch/powerpc/tools/head_check.sh
> ...
>
> Explicitly handle these sections like in the main linker script so
> there is no more build failure.
>
> Cc: stable@vger.kernel.org
> Fixes: 83a092cf95f2 ("powerpc: Link warning for orphan sections")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1218
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  arch/powerpc/kernel/vmlinux.lds.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
> index 0318ba436f34..8e0b1298bf19 100644
> --- a/arch/powerpc/kernel/vmlinux.lds.S
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -85,7 +85,7 @@ SECTIONS
>                 ALIGN_FUNCTION();
>  #endif
>                 /* careful! __ftr_alt_* sections need to be close to .text */
> -               *(.text.hot TEXT_MAIN .text.fixup .text.unlikely .fixup __ftr_alt_* .ref.text);
> +               *(.text.hot .text.hot.* TEXT_MAIN .text.fixup .text.unlikely .text.unlikely.* .fixup __ftr_alt_* .ref.text);
>  #ifdef CONFIG_PPC64
>                 *(.tramp.ftrace.text);
>  #endif
>
> base-commit: d8a4f20584d5906093a8fc6aa06622102a501095
> --
> 2.30.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20210104204850.990966-1-natechancellor%40gmail.com.
