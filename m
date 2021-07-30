Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E143DC137
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhG3Wm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhG3Wm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 18:42:26 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337CBC061765
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:42:21 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id m9so14487133ljp.7
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvaRlaXK64PpiXVCxXFWPZrJ6CRVJKhlEggaPSUWrrw=;
        b=CamcDOtb4w32+Iwghtae/iPJ4AawESCpvZfWvezZMZ2GmChsXM+D5S/WHRuAsK/sol
         k/QhziJbAl+EIxdK2SdZbk3RdfRUppMIsuc5kTQMewaCPzJw4aKEI3Eu9wRyh11Drmrd
         FHMc6zK2PGlNcCN+FurZ+iWO7OY7901V6GveTFJszVCrRN+K7AfRjSRkqJDeDBdmVZSU
         raKAAS798S1kv0LiK803/HbxaTWfj5vPSmOpNDyid0UXwxTPdpQepcngNnOntz5HsaOY
         0piJrOFdPamO6NdoWP36W+lhaXKHPRPzIbxZjEHwznYdw4lSsxaaWgv8LKp2PquT/SOl
         OoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvaRlaXK64PpiXVCxXFWPZrJ6CRVJKhlEggaPSUWrrw=;
        b=Lc9o+m2fjYGBqXvcsZ4s4W6hiQAZSKgi66OGkgHuNMPPwGlBxwr9ohNxiodOIwopBm
         xP4fDmeElJ7LqrWyiIYxl3wJyCVzJRfnYONCAL65ptal73K1bOKoJLTTieHJKF0hkQvk
         gxDeSduAy7a5Ij/nGteYFsGndhdpl6uIP04FqldqWgrnhP7jf7hVhZoxoHEl6W99IBYk
         glkNNRRSh8uJhIVjiRNWKVBOSZQVM6P+jI9ggM4IGMdEsTavZ7HsDIX1vulpYsQ1Rv9D
         WPsuFp4oCK2/FZwHxkhM07GbTMEldyOJ2kso9uVQ4aaVDoxTkjou+aizK148ER3fNb5j
         IX4w==
X-Gm-Message-State: AOAM531KDOuk7ivfanFFCvDBJVzOZ10HDXHxAeMMdgUVslAMJxRLthn3
        rTU5EsRccXGjzeelLa4bVyRDjhKSYu8Use+4pCxLyg==
X-Google-Smtp-Source: ABdhPJyYcoAlBscQqMvEJrhnjGcd6z5rpKgZtxpVVf0dTcdK3fafeVwt6xvkwGgxYlTtM9T4m9li4Zp+sJzl9DmJwXA=
X-Received: by 2002:a2e:a911:: with SMTP id j17mr3212666ljq.341.1627684939283;
 Fri, 30 Jul 2021 15:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210730223815.1382706-1-nathan@kernel.org>
In-Reply-To: <20210730223815.1382706-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 30 Jul 2021 15:42:08 -0700
Message-ID: <CAKwvOdnJ9VMZfZrZprD6k0oWxVJVSNePUM7fbzFTJygXfO24Pw@mail.gmail.com>
Subject: Re: [PATCH] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Fangrui Song <maskray@google.com>,
        Marco Elver <elver@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 3:38 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> A recent change in LLVM causes module_{c,d}tor sections to appear when
> CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
> because these are not handled anywhere:
>
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'

^ .text.tsan.*

>
> Place them in the TEXT_TEXT section so that these technologies continue
> to work with the newer compiler versions. All of the KASAN and KCSAN
> KUnit tests continue to pass after this change.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1432
> Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  include/asm-generic/vmlinux.lds.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 17325416e2de..3b79b1e76556 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -586,6 +586,7 @@
>                 NOINSTR_TEXT                                            \
>                 *(.text..refcount)                                      \
>                 *(.ref.text)                                            \
> +               *(.text.asan .text.asan.*)                              \

Will this match .text.tsan.module_ctor?

Do we want to add these conditionally on
CONFIG_KASAN_GENERIC/CONFIG_KCSAN like we do for SANITIZER_DISCARDS?

>                 TEXT_CFI_JT                                             \
>         MEM_KEEP(init.text*)                                            \
>         MEM_KEEP(exit.text*)                                            \
>
> base-commit: 4669e13cd67f8532be12815ed3d37e775a9bdc16
> --


-- 
Thanks,
~Nick Desaulniers
