Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF6C3A33DE
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJTXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:23:42 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:38901 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFJTXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:23:42 -0400
Received: by mail-lj1-f179.google.com with SMTP id s22so6412708ljg.5
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TCR4wjdITK+kupOKjLE86TVEkMZcR5bv/LNyb8r3Nyc=;
        b=LL56kf5WNorUp6A/BtmQdId+ZgvFAEKdiDs120Ls5oqTDleh+FXwNezoG3o0xz3/qX
         tzp/Tfx6PsqR4ov6sucNa7m8+gshcxH0LmYKavfQPwjKFyKdaKiSxYpfcsPwM7mD9755
         GE2QRdjM3hpFMYUfu8UQ+W9K3wJJvRe2x67ACeH5hxm2QWlKs0BA3+A2nS+ZBWA70Vb6
         l8Qd3G55ifmzUzKGWWglKBZVhItqKzdGF9ufZ4xGiqOmNhcLMMTef6WmJGl8rTFMJEty
         r5GAHe1wLdD2VjyhpAbEH3Js0/66tRhnoRYvDj4q2t01eG/LQf9Pb/hTvnZ235m0nTBO
         9Gyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TCR4wjdITK+kupOKjLE86TVEkMZcR5bv/LNyb8r3Nyc=;
        b=c50EQHgPydG8NG3dmsXurpVDMNh7iHyExrBUhLkNxJlGhIGT12Mr2qcgdMQfMe6KM5
         IYVVWCCTAWBY0A0lJ6AJemkF6pF51sgRow8sAoWksLQLOf8i70LqPARhOLyfSpY07PSj
         BcPBbcav43UUfEJxZgboVPOvT+PSg2aT4hjRHRuAPLMvfG0yWuqc4fCCB+w1CdeS7A3O
         dt0CDxk08l7tcEZ3q4GHhKpR1toio4w9cVcUjg4sTge6RutkUGYHBXsZYamDRrPBLcxY
         X/bR/8rJh+aR0IgteWRg3/52OcO/DkARG5VO9xRoH977PNZ9YP+5o7pp5j9TsGaL1W6w
         5YcQ==
X-Gm-Message-State: AOAM533vwbes/ikjKnmGavu+HMe70PrOEbcGP4lt+YCem5zv37DzKPBB
        e2eSdGn04ezIV5colV0/JU0iT0zArM6rHBXE8jLAxQ==
X-Google-Smtp-Source: ABdhPJwYronnVnbnK1r+c0d0G/spznSfvXGbR2w+pI1zmGgTDYwtqcPNQtfMoPAVK7KUn572JWNGeJgWW+pvsbQQA3w=
X-Received: by 2002:a2e:b5b5:: with SMTP id f21mr79310ljn.479.1623352844553;
 Thu, 10 Jun 2021 12:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <214134496.67043.1623317284090@office.mailbox.org>
In-Reply-To: <214134496.67043.1623317284090@office.mailbox.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Jun 2021 12:20:33 -0700
Message-ID: <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD < 13.0.0
To:     Tor Vic <torvic9@mailbox.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 2:28 AM <torvic9@mailbox.org> wrote:
>
> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
> leading to the following error message when building a LTO kernel with
> Clang-13 and LLD-13:
>
>     ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
>     '-stack-alignment=8'.  Try 'ld.lld --help'
>     ld.lld: Did you mean '--stackrealign=8'?
>
> It also appears that the '-code-model' flag is not necessary anymore starting
> with LLVM-9 [2].
>
> Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.

Please include this additional context in v2:
```
These flags were necessary because these flags were not encoded in the
IR properly, so the link would restart optimizations without them. Now
there are properly encoded in the IR, and these flags exposing
implementation details are no longer necessary.
```
That way it doesn't sound like we're not using an 8B stack alignment
on x86; we very much are so; AMDGPU GPFs without it!

Cut the below paragraph out on v2.  Thanks for the patch and keep up
the good work!

>
> This is for linux-stable 5.12.
> Another patch will be submitted for 5.13 shortly (unless there are objections).
>
> Discussion: https://github.com/ClangBuiltLinux/linux/issues/1377
> [1]: https://reviews.llvm.org/D103048
> [2]: https://reviews.llvm.org/D52322
>
> Signed-off-by: Tor Vic <torvic9@mailbox.org>
> ---
>  arch/x86/Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 1f2e5bf..2855a1a 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -192,8 +192,9 @@ endif
>  KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
>
>  ifdef CONFIG_LTO_CLANG
> -KBUILD_LDFLAGS += -plugin-opt=-code-model=kernel \
> -                  -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
> +ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
> +KBUILD_LDFLAGS += -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
> +endif
>  endif
>
>  ifdef CONFIG_X86_NEED_RELOCS
> --
> 2.32.0



-- 
Thanks,
~Nick Desaulniers
