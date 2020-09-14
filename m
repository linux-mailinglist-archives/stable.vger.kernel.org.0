Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9D7269138
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINQPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 12:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgINQOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 12:14:17 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587FBC061788
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 09:14:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q4so58246pjh.5
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JtLqKIqxK7wc9FLa1pAfxW1qizIDuJ12ED71Joxln3w=;
        b=nDk1vkg2ksSv79eO346Zawe7Qui+QvmmSjYNyW1T/U9xLLgjgvLqkeGnSjNPc8zV0h
         Ypjxt9hZf1dSy1XAR8u8tgFTmg/NasgxxMhGwoVOBjfIuAIPVO9Tb8x9KIdgG2sVC1wH
         w85WYgNRbx0GMMh16uTAMpzrb95cMXRFkdRkmgN4jrrs+x9MeS8hTiMYta/yvoEEUkN7
         nO4tXsUT/gyvqQ+Aj+K7kRFT++aF1qTY95WfFWWJVXMKjjLXrryHziLOxFM5p/6FBr53
         JjROWiDmpPPNA6s310ap1GQ1Qd9E3E08got/meIkfC/5h6TunXEe4+pZo8vNWd1GHRnu
         muUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JtLqKIqxK7wc9FLa1pAfxW1qizIDuJ12ED71Joxln3w=;
        b=cdzmaUyVc2So1H2k+/4Qd5f6NQv4Ua7wEp36sS8FT+klJgCVlQrbZyLgkuiq46yVr1
         daWuivqir3twvGhRs1hDHUwhVliiowTTSh+GLT/SX62AXqTL2FShv7Zw4I7JZlxpxJKo
         1MfBGP5KpF9zjgH1sUozlhsCVPqlyuxtODSNLCpgPwesm8PjnAWb7WRR55LlHf+p5PXD
         7+VRLzYteuvEAla/RABVUQoGyNnoCuQuXsMtlCXQvf6PTwk0n4qPGu0XThUtPozYQb68
         Z4NiC4SUnY/QIj/gW+yp3QD5LtcbbBjUagO9r1gj0sjEJyprzOVA0i8qp2/mn6oick7q
         RHag==
X-Gm-Message-State: AOAM532CM8cMRvOO/mryrKB45jXXajDgQNgfK5/3pqGAeR+Ixa0B8jGB
        0Pt/rOXjzeyXgNvpoXEMRlplHLFDOwzANZl1bY3UWg==
X-Google-Smtp-Source: ABdhPJyX96XmrrBKOtPkCawoH6WCN1fmRQ+2sSY3qHhmnO5EFJlpdvBHzl3xnDKV42eDwJUmuWCB/4KmAxv3gmp9qtE=
X-Received: by 2002:a17:90b:889:: with SMTP id bj9mr101969pjb.101.1600100054525;
 Mon, 14 Sep 2020 09:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200914160958.889694-1-ndesaulniers@google.com>
In-Reply-To: <20200914160958.889694-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 14 Sep 2020 09:14:03 -0700
Message-ID: <CAKwvOdno19XHTEUAjUDkNCdRpX_BywOFbdsNV5+7SspMMn487g@mail.gmail.com>
Subject: Re: [PATCH v4] lib/string.c: implement stpcpy
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andy Lavr <andy.lavr@gmail.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 9:10 AM Nick Desaulniers
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
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> Link: https://bugs.llvm.org/show_bug.cgi?id=47162
> Link: https://bugs.llvm.org/show_bug.cgi?id=47280
> Link: https://github.com/ClangBuiltLinux/linux/issues/1126
> Link: https://man7.org/linux/man-pages/man3/stpcpy.3.html
> Link: https://pubs.opengroup.org/onlinepubs/9699919799/functions/stpcpy.html
> Link: https://reviews.llvm.org/D85963
> ---
> Changes V4:
> * Roll up Kees' comment fixup from
>   https://lore.kernel.org/lkml/202009060302.4574D8D0E0@keescook/#t.
> * Keep Nathan's tested by tag.
> * Add Kees' reviewed by tag from
>   https://lore.kernel.org/lkml/202009031446.3865FE82B@keescook/.
>
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
>  lib/string.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/lib/string.c b/lib/string.c
> index 6012c385fb31..b6b8847218b5 100644
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
> + * stpcpy differs from strcpy in a key way: the return value is a pointer
> + * to the new %NUL-terminating character in @dest. (For strcpy, the return
> + * value is a pointer to the start of @dest. This interface is considered

And, I forgot the stupid close parens...I will resend a v5...

> + * unsafe as it doesn't perform bounds checking of the inputs. As such it's
> + * not recommended for usage. Instead, its definition is provided in case
> + * the compiler lowers other libcalls to stpcpy.
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
> 2.28.0.618.gf4bc123cb7-goog
>


-- 
Thanks,
~Nick Desaulniers
