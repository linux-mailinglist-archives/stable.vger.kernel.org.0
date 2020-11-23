Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D522C132F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgKWSbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 13:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgKWSbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 13:31:22 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230DC061A4D
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 10:31:21 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so15047641pgb.4
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 10:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GtsXyovkQ24MNl8aC+lmA/AQ0EZdim/KFPinJ6iekIY=;
        b=ZKdbyuYa3NBPgyJ1UvPCx1/DfKfQIPDzEMsww1gBhs33Y7LM2MaVu+kMOSGL9NeIaT
         E1s0lofMOrf8w7dImvZZD3BLwd79FgBiog3iAFkQqa2gaf1xqRCUHcZr/BTpsFvDs7yR
         2aOtqghWBYVte9Ao31KDGGcc3VGakr83xlRjHeoW3PoUyQnvWbG/HYSnZlRs9+Tfgk9r
         e+cUSyacpNaphIGv45qpxslMH0ybaqpdgtZKPA7AFSNpQCZAKn88ybuxMVNFbbT5r8q2
         AeN69oC2uknIGiMEweez6yyx0glSRV+wXM4Aixwp63DF7Lfki1AIbOLizMRXp52QCdm5
         cJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GtsXyovkQ24MNl8aC+lmA/AQ0EZdim/KFPinJ6iekIY=;
        b=nhd0QaY6k0Dx2xK3gGZTX0iTof/vQ0WJ6GOf3qbKEHSQc8PnUfLZEGbJWv5MLWDqrz
         8EcAOxkNi5WElMwFbiLfdfvbkN3f65033Y9T1MlYLTxardv2BxnVgoXZarIua9QUjHAS
         z3LnVH0fjE9HCXjlqtQlXMVhY6vXwfpyHKOss7v2i2uk5JZYtGCCnKjdVFuqjbL1oJAk
         5XJfD/3oM9g+ZSFgxbG/oHKN7BrBJhxfoQU5/z4Zd1TS5yihKzs0EGcuPmfrEtSAPggz
         F11xTcZkEKPx1FiWTyxJuYef5h2kRrIP8HwPRpmI2sSXl1fTdVBPmWlbw3Vhkd4E3xne
         eNkg==
X-Gm-Message-State: AOAM531gwnq594tlws9LtR4dskjoz75QL0D+6zp9Fcs6+u8Bkqzce0es
        W51ftcnL3nkXNJYvRtcbCZpHPm+zpZdeYqCQ9J6fNQC7j3x13w==
X-Google-Smtp-Source: ABdhPJwTCWlrGAoulcXiTu9f9xpkhjcWmeAyOr0brrz2ozaqFV4zsGrTrQA/z3rhWpl4PUtSr4PlcRnXVl/rFS8cvmc=
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id
 144-20020a6218960000b0290197491cbe38mr689584pfy.15.1606156281177; Mon, 23 Nov
 2020 10:31:21 -0800 (PST)
MIME-Version: 1.0
References: <20201123121819.943135899@linuxfoundation.org> <20201123121822.053682010@linuxfoundation.org>
In-Reply-To: <20201123121822.053682010@linuxfoundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Nov 2020 10:31:10 -0800
Message-ID: <CAKwvOdmX_M6wn-UUO39EqRZNbHCn22dsNND6sZ6q+Tzjyez=7A@mail.gmail.com>
Subject: Re: [PATCH 5.4 044/158] compiler.h: fix barrier_data() on clang
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Doesn't this depend on a v2 of
https://lore.kernel.org/lkml/fe040988-c076-8dec-8268-3fbaa8b39c0f@infradead.org/
? Oh, looks like v1 got picked up:
https://lore.kernel.org/lkml/mhng-8c56f671-512a-45e7-9c94-fa39a80451da@palmerdabbelt-glaptop1/.
Won't this break RISCV VDSO?

On Mon, Nov 23, 2020 at 4:35 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Arvind Sankar <nivedita@alum.mit.edu>
>
> [ Upstream commit 3347acc6fcd4ee71ad18a9ff9d9dac176b517329 ]
>
> Commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
> mutually exclusive") neglected to copy barrier_data() from
> compiler-gcc.h into compiler-clang.h.
>
> The definition in compiler-gcc.h was really to work around clang's more
> aggressive optimization, so this broke barrier_data() on clang, and
> consequently memzero_explicit() as well.
>
> For example, this results in at least the memzero_explicit() call in
> lib/crypto/sha256.c:sha256_transform() being optimized away by clang.
>
> Fix this by moving the definition of barrier_data() into compiler.h.
>
> Also move the gcc/clang definition of barrier() into compiler.h,
> __memory_barrier() is icc-specific (and barrier() is already defined
> using it in compiler-intel.h) and doesn't belong in compiler.h.
>
> [rdunlap@infradead.org: fix ALPHA builds when SMP is not enabled]
>
> Link: https://lkml.kernel.org/r/20201101231835.4589-1-rdunlap@infradead.org
> Fixes: 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/20201014212631.207844-1-nivedita@alum.mit.edu
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/compiler-clang.h |  5 -----
>  include/linux/compiler-gcc.h   | 19 -------------------
>  include/linux/compiler.h       | 18 ++++++++++++++++--
>  3 files changed, 16 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index 333a6695a918c..9b89141604ed0 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -37,8 +37,3 @@
>  #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>  #endif
>
> -/* The following are for compatibility with GCC, from compiler-gcc.h,
> - * and may be redefined here because they should not be shared with other
> - * compilers, like ICC.
> - */
> -#define barrier() __asm__ __volatile__("" : : : "memory")
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index e8579412ad214..d8fab3ecf5120 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -14,25 +14,6 @@
>  # error Sorry, your compiler is too old - please upgrade it.
>  #endif
>
> -/* Optimization barrier */
> -
> -/* The "volatile" is due to gcc bugs */
> -#define barrier() __asm__ __volatile__("": : :"memory")
> -/*
> - * This version is i.e. to prevent dead stores elimination on @ptr
> - * where gcc and llvm may behave differently when otherwise using
> - * normal barrier(): while gcc behavior gets along with a normal
> - * barrier(), llvm needs an explicit input variable to be assumed
> - * clobbered. The issue is as follows: while the inline asm might
> - * access any memory it wants, the compiler could have fit all of
> - * @ptr into memory registers instead, and since @ptr never escaped
> - * from that, it proved that the inline asm wasn't touching any of
> - * it. This version works well with both compilers, i.e. we're telling
> - * the compiler that the inline asm absolutely may see the contents
> - * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
> - */
> -#define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
> -
>  /*
>   * This macro obfuscates arithmetic on a variable address so that gcc
>   * shouldn't recognize the original var, and make assumptions about it.
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 448c91bf543b7..f164a9b12813f 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -80,11 +80,25 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>
>  /* Optimization barrier */
>  #ifndef barrier
> -# define barrier() __memory_barrier()
> +/* The "volatile" is due to gcc bugs */
> +# define barrier() __asm__ __volatile__("": : :"memory")
>  #endif
>
>  #ifndef barrier_data
> -# define barrier_data(ptr) barrier()
> +/*
> + * This version is i.e. to prevent dead stores elimination on @ptr
> + * where gcc and llvm may behave differently when otherwise using
> + * normal barrier(): while gcc behavior gets along with a normal
> + * barrier(), llvm needs an explicit input variable to be assumed
> + * clobbered. The issue is as follows: while the inline asm might
> + * access any memory it wants, the compiler could have fit all of
> + * @ptr into memory registers instead, and since @ptr never escaped
> + * from that, it proved that the inline asm wasn't touching any of
> + * it. This version works well with both compilers, i.e. we're telling
> + * the compiler that the inline asm absolutely may see the contents
> + * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
> + */
> +# define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
>  #endif
>
>  /* workaround for GCC PR82365 if needed */
> --
> 2.27.0
>
>
>


-- 
Thanks,
~Nick Desaulniers
