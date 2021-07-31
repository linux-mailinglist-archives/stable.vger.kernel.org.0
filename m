Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F903DC541
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhGaJJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 05:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGaJJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 05:09:13 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDEC0613CF
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 02:09:07 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 68-20020a9d0f4a0000b02904b1f1d7c5f4so12209633ott.9
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 02:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vaAWrkzE49kpA8JCIiCiOMwaEcjf5J0qZweefCaV6Js=;
        b=Gp8ddgcSsdz7JROBXknYU+v2p1kXvS2NTlufoSvXs2xSBqOzoSTqrTEoNNr4cvOn/L
         X2w8AjJPeuQf1ZWGpOsHKDhbvsTjlLuoiLUsck5u6sK+JfUFcHbrC9i3E4srckgJzSMm
         1mfA/Rq4fQZDS3lXE0loMMIOduFdV4+GHh1jTgbTsde8dy8dU3IZdLSppJh4fako4XRi
         KMVV9x2djecxSD9XfPH68Cb4xxfF5vTVTcasDIEWSDpbX3kJaxnIkVGmJTkxH4aXDlCq
         RhegliyZROtvGJM6wZva2mOMui6QylvPWju4wqUMZnoLHag3sA08TXGsfAVbRZZYAde6
         m3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vaAWrkzE49kpA8JCIiCiOMwaEcjf5J0qZweefCaV6Js=;
        b=UJzRee3Gvv3JgBbmPkvnh3v4HGlvKsjfQ2/pCDw8DEPwYhU7SJb6v+KO5fyFJPQh2Z
         Owjkx2I/un5D/1+ClAsECSR3GyBn4EwjkAOlMZcn9WuHHg4hAAYkeiuq5S84BLmeWhhj
         bvCJ604mMDFjlQsOe4wLDL5DB2LqNcoY9ZVYKfYNLoRWjr9A0CYpJIntyyf2qXt82e2h
         0PHxn6eGd/3QZEgk8F6jiYgbJAz6KVFRFjmLAirToBiJzwaMUS1ByG5zavjA8TfBb5Oa
         yEMxcqpiex/6zaF3fLqN9P9n5cZ7ACCSUU47h+mMLnTxcxv4uLrIu1P0ayN0onIZlDNz
         L7cg==
X-Gm-Message-State: AOAM5329gwydsxtEMVGxfjpsbwId2J3ivq+Ui2flOXGaSciRhbGaFttE
        Ec485b9WPCFQRviSp34OdUGXFv1Ed95bJb9XFYrNVA==
X-Google-Smtp-Source: ABdhPJx/tcoITFgW0uzDCxON4iQQbvCkCbi63apcAR8wygJH80IvZT0cpXasQBS7xAA4PgjdVvQHxHb1Gc114BkzJw4=
X-Received: by 2002:a05:6830:23a7:: with SMTP id m7mr5218486ots.17.1627722546365;
 Sat, 31 Jul 2021 02:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210730223815.1382706-1-nathan@kernel.org> <20210731023107.1932981-1-nathan@kernel.org>
In-Reply-To: <20210731023107.1932981-1-nathan@kernel.org>
From:   Marco Elver <elver@google.com>
Date:   Sat, 31 Jul 2021 11:08:54 +0200
Message-ID: <CANpmjNMJR7A5FyPLuK+mWLKjZ7z4qJfygXWFpsADxicYE=Kx=g@mail.gmail.com>
Subject: Re: [PATCH v2] vmlinux.lds.h: Handle clang's module.{c,d}tor sections
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 31 Jul 2021 at 04:33, Nathan Chancellor <nathan@kernel.org> wrote:
> A recent change in LLVM causes module_{c,d}tor sections to appear when
> CONFIG_K{A,C}SAN are enabled, which results in orphan section warnings
> because these are not handled anywhere:
>
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_ctor) is being placed in '.text.asan.module_ctor'
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.asan.module_dtor) is being placed in '.text.asan.module_dtor'
> ld.lld: warning: arch/x86/pci/built-in.a(legacy.o):(.text.tsan.module_ctor) is being placed in '.text.tsan.module_ctor'
>
> Fangrui explains: "the function asan.module_ctor has the SHF_GNU_RETAIN
> flag, so it is in a separate section even with -fno-function-sections
> (default)".
>
> Place them in the TEXT_TEXT section so that these technologies continue
> to work with the newer compiler versions. All of the KASAN and KCSAN
> KUnit tests continue to pass after this change.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1432
> Link: https://github.com/llvm/llvm-project/commit/7b789562244ee941b7bf2cefeb3fc08a59a01865
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Marco Elver <elver@google.com>

For KASAN module_ctors are very much required to support detecting
globals out-of-bounds: https://reviews.llvm.org/D81390
For KASAN the test would have revealed that at the latest.

KCSAN does not yet have much use for the module_ctors, but it may
change in future, so keeping them all was the right call.

Thanks,
-- Marco

> ---
>
> v1 -> v2:
>
> * Fix inclusion of .text.tsan.* (Nick)
>
> * Drop .text.asan as it does not exist plus it would be handled by a
>   different line (Fangrui)
>
> * Add Fangrui's explanation about why the LLVM commit caused these
>   sections to appear.
>
>  include/asm-generic/vmlinux.lds.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 17325416e2de..62669b36a772 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -586,6 +586,7 @@
>                 NOINSTR_TEXT                                            \
>                 *(.text..refcount)                                      \
>                 *(.ref.text)                                            \
> +               *(.text.asan.* .text.tsan.*)                            \
>                 TEXT_CFI_JT                                             \
>         MEM_KEEP(init.text*)                                            \
>         MEM_KEEP(exit.text*)                                            \
>
> base-commit: 4669e13cd67f8532be12815ed3d37e775a9bdc16
> --
> 2.32.0.264.g75ae10bc75
>
