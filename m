Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ACF2DCADC
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 03:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgLQCJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 21:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgLQCJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 21:09:35 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26BFC06179C
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 18:08:54 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b8so8258557plx.0
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 18:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8eLKwGSpN1CIyR4Kd4zybrisCdZPTB+phRfHVeIVRLo=;
        b=frhvB+UsVAgIo3+VjtHXq3C6F2Vh8NZWIdF3ZC34I1OxFyPOl/MK2gMUGOv9oZomu1
         7ASJMsObwn6jcuWWQYh6ijoJ9+XXN6zDo2lYrOTdt5vc9fQO+5pKh3shKDZuH1EQ81zy
         eXozjgzjw7fegMSzt/ljyYbMYrbXobtVX9SB1Fa4rdqfafl83gtN9QcJQtS2aHi0481Q
         PpV62IwtPAOV+h23GiNXAw5L3oBOrJZQLg23D5IDOeZLNzHccE7flF4aXp2TsKQYw+D7
         t4Sdl0vBPfrAhLf2A5THCQH3AufaOgLUZUumivRQKcyPNFbkIuvi74QJdy6Y6JYFynJW
         rv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8eLKwGSpN1CIyR4Kd4zybrisCdZPTB+phRfHVeIVRLo=;
        b=l5OTF9wPtDYKn/jOdmmqBwkL0ASOj8aEwQXaQD2x3n+J17futH9nEz7L2vLBAlMaew
         oAxcaYF9O3SV4Tj1NcF3VCPXptbz7awoPHQJi47FvHcIG1B5nDBMonLWhkPfvzWe0xVh
         /emsgzu3ujLtFc8dck/gW5Rzs4cuPTLauoW8MN6QE0QRHSp/hGDlrOXnwc5hJd7Ljbpd
         FbS/XiK+v7eGbTRKsx3CIHcsd5kORCe0OGYPgMCvX4ftGNv2MG6Ps8P3x9WEJmqDzRyc
         sroVccSE4QRIaL4X3B2mxsdglSksFE5jWThMwee0gk5E0RkQ7rqCT2Y0iV3g3K9HDRVN
         I/9g==
X-Gm-Message-State: AOAM5336k8/Dbq6AmTIP10Y0+oEm3RVUOgi/AykteMm/Ishl/3Acddfn
        r/gdZweF51YTEbcoyaGruAY58rR/JnQ9uv53ioEBlA==
X-Google-Smtp-Source: ABdhPJyYAa4dCGGScl3comwtcPFfhEQus9OAPRGfcjasKlqBX0Jp6tUhcrNwRqTvB0iifU/UajVHGA3HBFklASpZjJ0=
X-Received: by 2002:a17:902:ed14:b029:da:9da4:3091 with SMTP id
 b20-20020a170902ed14b02900da9da43091mr33856567pld.29.1608170934177; Wed, 16
 Dec 2020 18:08:54 -0800 (PST)
MIME-Version: 1.0
References: <20201216233956.280068-1-paul@crapouillou.net>
In-Reply-To: <20201216233956.280068-1-paul@crapouillou.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 16 Dec 2020 18:08:42 -0800
Message-ID: <CAKwvOdnmt7v=+QdZbVYw9fDTeAhhHn0X++aLBa3uQVp7Gp=New@mail.gmail.com>
Subject: Re: [PATCH] MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Nathan Chancellor <natechancellor@gmail.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 3:40 PM Paul Cercueil <paul@crapouillou.net> wrote:
>
> The compressed payload is not necesarily 4-byte aligned, at least when
> compiling with Clang. In that case, the 4-byte value appended to the
> compressed payload that corresponds to the uncompressed kernel image
> size must be read using get_unaligned_le().

Should it be get_unaligned_le32()?

>
> This fixes Clang-built kernels not booting on MIPS (tested on a Ingenic
> JZ4770 board).
>
> Fixes: b8f54f2cde78 ("MIPS: ZBOOT: copy appended dtb to the end of the kernel")
> Cc: <stable@vger.kernel.org> # v4.7
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Hi Paul, thanks for the patch (and for testing with Clang)!
Alternatively, we could re-align __image_end to the next 4B multiple
via:

diff --git a/arch/mips/boot/compressed/ld.script
b/arch/mips/boot/compressed/ld.script
index 0ebb667274d6..349919eff5fb 100644
--- a/arch/mips/boot/compressed/ld.script
+++ b/arch/mips/boot/compressed/ld.script
@@ -27,6 +27,7 @@ SECTIONS
                /* Put the compressed image here */
                __image_begin = .;
                *(.image)
+               . = ALIGN(4);
                __image_end = .;
                CONSTRUCTORS
                . = ALIGN(16);

The tradeoff being up to 3 wasted bytes of padding in the compressed
image, vs fetching one value slower (assuming unaligned loads are
slower than aligned loads MIPS, IDK).  I doubt decompress_kernel is
called repeatedly, so let's take the byte saving approach of yours by
using unaligned loads!

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/mips/boot/compressed/decompress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compressed/decompress.c
> index c61c641674e6..47c07990432b 100644
> --- a/arch/mips/boot/compressed/decompress.c
> +++ b/arch/mips/boot/compressed/decompress.c
> @@ -117,7 +117,7 @@ void decompress_kernel(unsigned long boot_heap_start)
>                 dtb_size = fdt_totalsize((void *)&__appended_dtb);
>
>                 /* last four bytes is always image size in little endian */
> -               image_size = le32_to_cpup((void *)&__image_end - 4);
> +               image_size = get_unaligned_le32((void *)&__image_end - 4);
>
>                 /* copy dtb to where the booted kernel will expect it */
>                 memcpy((void *)VMLINUX_LOAD_ADDRESS_ULL + image_size,
> --
> 2.29.2
>


-- 
Thanks,
~Nick Desaulniers
