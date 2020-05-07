Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED3F1C825C
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgEGGSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 02:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEGGSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 02:18:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17FFC061A0F;
        Wed,  6 May 2020 23:18:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d7so891457ioq.5;
        Wed, 06 May 2020 23:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CbbcNQCWKC+HM8LWTSFFFe3Q9kOpsnt6b3jv45wzhig=;
        b=jcft2yzLVpaFO6z6XNF5KwroeR36ACU5JQ26qN0H5i4Q9FcIDPcv1EfFH3PBcmUgT7
         m/j3kgOhIGLTrFFSUUMqXipjturLnWfpJsO4DLf28KNdxM16joCqloZHmN4NkmflfCmM
         s6C2fvo4emh3ufyR7moq4CDm6Ond/TPcPsWIF8SV4u/V60A5y38ivr+Y8SfiZLNtNEJI
         Ghun2sA2AZoZdE6OEtPoHOiHP8xc6MsxEtrOrK1L1xfXtelvek6MlAxvVFofKwfmbRJ9
         BJCE5dhjOypfl9xvZ2ZJm6le6rEOs8F1BdNNJ3rkR/PMHO6kjosymWGdQNdjIWEMp66M
         M8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CbbcNQCWKC+HM8LWTSFFFe3Q9kOpsnt6b3jv45wzhig=;
        b=Oka2CLQwtCVF+qryvIe9RVEgfXcO7a8//9THc2/crixFTjwtu5gwXe2gwNtNcmN8l0
         4oiCpHoB5XmxyzSNE7w7K8yrE6rgCPw8BR3UtMEURgE49WQz6xPaUbcTZ+zUVr4cQslZ
         /EUkP/mMgqr20WlJ5uguNo5NoOgaN3rsUlGJ22cw9X9p4G1x/D1WVJfxVfbIbSnwC+PG
         Tw7C57zi8G+JrXbb5cYu4fqTvp9390UsF1ebCEviSXrOqOZBxb1DYctefkvOjVnNrKAe
         jlKK8/7y55Q1hsQkaYnQ93d86XMmMcM8euh1vtMP/zPJHsQHIGHtW0z1aTfelAnMnYHN
         qfxw==
X-Gm-Message-State: AGi0PuYQUEeixZbda4d1KFgU902qnTxa/PY8w9PwLTdZnx0R3y+Dz/ma
        YMEsxBzg719bO/YyY53n/g78UAHll5eabaMxXw==
X-Google-Smtp-Source: APiQypJE2yHAgbnPd3Eiw9LdqaNucanJcNRSmWEcH9Piz1DslLyBAxVQ1GDKNh4kmsF3IFCVR0sEZ0gpS3FTE9Q9r2Q=
X-Received: by 2002:a05:6602:1695:: with SMTP id s21mr12451651iow.40.1588832301009;
 Wed, 06 May 2020 23:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
In-Reply-To: <20200505174423.199985-1-ndesaulniers@google.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Thu, 7 May 2020 02:18:09 -0400
Message-ID: <CAMzpN2idWF2_4wtPebM2B2HVyksknr9hAqK8HJi_vjQ06bgu2g@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 5, 2020 at 1:47 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> From: Sedat Dilek <sedat.dilek@gmail.com>
>
> It turns out that if your config tickles __builtin_constant_p via
> differences in choices to inline or not, this now produces invalid
> assembly:
>
> $ cat foo.c
> long a(long b, long c) {
>   asm("orb\t%1, %0" : "+q"(c): "r"(b));
>   return c;
> }
> $ gcc foo.c
> foo.c: Assembler messages:
> foo.c:2: Error: `%rax' not allowed with `orb'
>
> The "q" constraint only has meanting on -m32 otherwise is treated as
> "r".
>
> This is easily reproducible via Clang+CONFIG_STAGING=y+CONFIG_VT6656=m,
> or Clang+allyesconfig.
>
> Keep the masking operation to appease sparse (`make C=1`), add back the
> cast in order to properly select the proper 8b register alias.
>
>  [Nick: reworded]
>
> Cc: stable@vger.kernel.org
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/961
> Link: https://lore.kernel.org/lkml/20200504193524.GA221287@google.com/
> Fixes: 1651e700664b4 ("x86: Fix bitops.h warning with a moved cast")
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Suggested-by: Ilie Halip <ilie.halip@gmail.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/x86/include/asm/bitops.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index b392571c1f1d..139122e5b25b 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
>         if (__builtin_constant_p(nr)) {
>                 asm volatile(LOCK_PREFIX "orb %1,%0"
>                         : CONST_MASK_ADDR(nr, addr)
> -                       : "iq" (CONST_MASK(nr) & 0xff)
> +                       : "iq" ((u8)(CONST_MASK(nr) & 0xff))

I think a better fix would be to make CONST_MASK() return a u8 value
rather than have to cast on every use.

Also I question the need for the "q" constraint.  It was added in
commit 437a0a54 as a workaround for GCC 3.4.4.  Now that the minimum
GCC version is 4.6, is this still necessary?

--
Brian Gerst
