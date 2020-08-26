Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D857A253569
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgHZQt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:49:59 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:21807 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgHZQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:49:58 -0400
X-Greylist: delayed 3009 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2020 12:49:57 EDT
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 07QGnetR014600;
        Thu, 27 Aug 2020 01:49:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 07QGnetR014600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1598460581;
        bh=qUxLw8h62gV6lNU8hR9gKg9F4mIeUNwWOgjmbG+A2no=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hAaAFdF3Uv8HXibs8fO1sgTne0mzPKrTDLQxx3rNOjXXrg3y2mojINLp84ANjrkYI
         Q71zmb4N9cP4a7hD/a81bbkU3SqBYXQjGXaqsLcrhKjmMRi/JUvUU7xpEGk2PtSh/q
         9CwmLoqmwjz2T3leTam8HT4cldLf0S4peudRwHDKr/WOZTkGcb/PFHDD8TlTc0/7F2
         4dh5Ald+/9RFBeJTqnhWTRlW+gxLJKmOLyaXdC0AZRzJb+Gg/Of+pR/CINFWFIBVJe
         L27w2LNub8WufKrz6fCj1ljR9dOGYkVB+cE+ZLh5Cjz8eqNLwHaYQl4RecJsb5ymVC
         nfc9ZCKlzoBMg==
X-Nifty-SrcIP: [209.85.214.173]
Received: by mail-pl1-f173.google.com with SMTP id q3so1158740pls.11;
        Wed, 26 Aug 2020 09:49:40 -0700 (PDT)
X-Gm-Message-State: AOAM531vlCthASNevgcpoVIHFtTrFJGyLUt1wPzRIBh/Kn/KRh0NfzcS
        Fi2iqX0sxqjvZeKonGvlKtaQaZf9ucB84cyHd5M=
X-Google-Smtp-Source: ABdhPJyZJsunhDhFPQuXquBSA5lbNs1cYEM/vJ29gPa1jTOEE3CUDN0gwYkzK2z3QlPBylPAg5quq9sZvkygbBaqic8=
X-Received: by 2002:a17:90a:fb53:: with SMTP id iq19mr6982654pjb.153.1598460579840;
 Wed, 26 Aug 2020 09:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200825135838.2938771-1-ndesaulniers@google.com>
In-Reply-To: <20200825135838.2938771-1-ndesaulniers@google.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 27 Aug 2020 01:49:03 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
Message-ID: <CAK7LNAQXo5-5W6hvNMEVPBPf3tRWaf-pQdSR-0OHyi4RCGhjsQ@mail.gmail.com>
Subject: Re: [PATCH v3] lib/string.c: implement stpcpy
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>, Andy Lavr <andy.lavr@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Yury Norov <yury.norov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 10:58 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  `stpcpy` is just like `strcpy` except it
> returns the pointer to the new tail of `dest`.  This optimization was
> introduced into clang-12.
>
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
>
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
>
> The kernel is somewhere between a "freestanding" environment (no full libc)
> and "hosted" environment (many symbols from libc exist with the same
> type, function signature, and semantics).
>
> As H. Peter Anvin notes, there's not really a great way to inform the
> compiler that you're targeting a freestanding environment but would like
> to opt-in to some libcall optimizations (see pr/47280 below), rather than
> opt-out.
>
> Arvind notes, -fno-builtin-* behaves slightly differently between GCC
> and Clang, and Clang is missing many __builtin_* definitions, which I
> consider a bug in Clang and am working on fixing.
>
> Masahiro summarizes the subtle distinction between compilers justly:
>   To prevent transformation from foo() into bar(), there are two ways in
>   Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
>   only one in GCC; -fno-buitin-foo.
>
> (Any difference in that behavior in Clang is likely a bug from a missing
> __builtin_* definition.)
>
> Masahiro also notes:
>   We want to disable optimization from foo() to bar(),
>   but we may still benefit from the optimization from
>   foo() into something else. If GCC implements the same transform, we
>   would run into a problem because it is not -fno-builtin-bar, but
>   -fno-builtin-foo that disables that optimization.
>
>   In this regard, -fno-builtin-foo would be more future-proof than
>   -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
>   may want to prevent calls from foo() being optimized into calls to
>   bar(), but we still may want other optimization on calls to foo().
>
> It seems that compilers today don't quite provide the fine grain control
> over which libcall optimizations pseudo-freestanding environments would
> prefer.
>
> Finally, Kees notes that this interface is unsafe, so we should not
> encourage its use.  As such, I've removed the declaration from any
> header, but it still needs to be exported to avoid linkage errors in
> modules.
>
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://bugs.llvm.org/show_bug.cgi?id=47280
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Changes V3:
> * Drop Sami's Tested by tag; newer patch.
> * Add EXPORT_SYMBOL as per Andy.
> * Rewrite commit message, rewrote part of what Masahiro said to be
>   generic in terms of foo() and bar().
> * Prefer %NUL-terminated to NULL terminated. NUL is the ASCII character
>   '\0', as per Arvind and Rasmus.
>
> Changes V2:
> * Added Sami's Tested by; though the patch changed implementation, the
>   missing symbol at link time was the problem Sami was observing.
> * Fix __restrict -> __restrict__ typo as per Joe.
> * Drop note about restrict from commit message as per Arvind.
> * Fix NULL -> NUL as per Arvind; NUL is ASCII '\0'. TIL
> * Fix off by one error as per Arvind; I had another off by one error in
>   my test program that was masking this.
>
>  lib/string.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/lib/string.c b/lib/string.c
> index 6012c385fb31..6bd0cf0fb009 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -272,6 +272,30 @@ ssize_t strscpy_pad(char *dest, const char *src, size_t count)
>  }
>  EXPORT_SYMBOL(strscpy_pad);
>
> +/**
> + * stpcpy - copy a string from src to dest returning a pointer to the new end
> + *          of dest, including src's %NUL-terminator. May overrun dest.
> + * @dest: pointer to end of string being copied into. Must be large enough
> + *        to receive copy.
> + * @src: pointer to the beginning of string being copied from. Must not overlap
> + *       dest.
> + *
> + * stpcpy differs from strcpy in a key way: the return value is the new
> + * %NUL-terminated character. (for strcpy, the return value is a pointer to
> + * src. This interface is considered unsafe as it doesn't perform bounds
> + * checking of the inputs. As such it's not recommended for usage. Instead,
> + * its definition is provided in case the compiler lowers other libcalls to
> + * stpcpy.


I do not have time to keep track of the discussion fully,
but could you give me a little more context why
the usage of stpcpy() is not recommended ?

The implementation of strcpy() is almost the same.
It is unclear to me what makes stpcpy() unsafe..



> + */
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src);
> +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
> +{
> +       while ((*dest++ = *src++) != '\0')
> +               /* nothing */;
> +       return --dest;
> +}
> +EXPORT_SYMBOL(stpcpy);
> +
>  #ifndef __HAVE_ARCH_STRCAT
>  /**
>   * strcat - Append one %NUL-terminated string to another
> --
> 2.28.0.297.g1956fa8f8d-goog
>


-- 
Best Regards
Masahiro Yamada
