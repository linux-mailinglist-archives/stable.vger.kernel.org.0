Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4586A18BB46
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 16:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCSPjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 11:39:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43564 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgCSPjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 11:39:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id f206so1617340pfa.10
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 08:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJgQNwFa53gC09TOaQbw283OU+sAvTexYYepz9mHTvk=;
        b=JCHznEO1d/dPI9KmbxT2UsYTSPVWGTO0JQFu8zE9Fku9PNaj9S2RVahq9q4azOe7TY
         DB3r4LVZshUvFI+JziN5cuQI/p09dpe9ivMspo3Iq1qRGmMi13twglOy9KFGWW26IvGI
         /SrsvEs0J7F7Iwd7E+0B9+XZvr4/3yL7Y77tgOn2DzNnZi1x5uxpDxHCv57yLv1CgMKR
         TlT9yP8UwkscK8hacTGD1u7xfMWgMcmX0NFv+5i29qpEHOxTINNISLyU0U+4pivtDMLi
         eBm6ksRB4i1fRQp4DTWW6Gx9kGvr03dHsByqHng7qkyKoYoQpWoneR7lMELh06kh7VvK
         Bk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJgQNwFa53gC09TOaQbw283OU+sAvTexYYepz9mHTvk=;
        b=TsdLHkNOhou54E6N/T4YAKJq5T+S+9k0O27kxkdr7WLmE3YDYksXA0r5+oAflmwuni
         pku9LEti7czzJrHkSzJ0p5jPRP4p5L/C93zKsBJvSXz61CJPnzmtDKLkMRNly2tYKMns
         0M/BgWUfBie9rLHyHutE/GcW0ezbr779PkUiUErOgtHm90RhL0kXomL2O6/M034uYQuz
         CN4FBlqmVpUmaosNpITNBtCaHaR6xNvA2m0Bznws+Qs6clNAP8BZE3PaR8LTh90ekSQm
         8RPYvxqyKdo4wQ/7VnSuBG1RzPE1YpOuc4PDYYDeKs6wndP0iUG06LRFHREpIDoAUGn5
         dayQ==
X-Gm-Message-State: ANhLgQ2SYOGye5eynu9c+FnFImXzk55jE6JkP7CINkyIgr1o+p7xgZDF
        HxTShjw47RO2QyhBpoS/o0qkUhGmXnmYE2+MfJSZBQ==
X-Google-Smtp-Source: ADFU+vvmDa2IbJuoRz7OqaXc97kIF7ReJt2HPcxDcSY6tuLJIrsnsTmzlMTMcc9bp5uVkabytdEutxv4gci9jRtn7xk=
X-Received: by 2002:aa7:8b54:: with SMTP id i20mr4577798pfd.39.1584632387767;
 Thu, 19 Mar 2020 08:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200319141138.19343-1-vincenzo.frascino@arm.com>
In-Reply-To: <20200319141138.19343-1-vincenzo.frascino@arm.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 19 Mar 2020 08:39:36 -0700
Message-ID: <CAKwvOdnnsE2FyqajP4_FrwpgekptfLJsr3J9EgB3Ac37NgZszQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 7:11 AM Vincenzo Frascino
<vincenzo.frascino@arm.com> wrote:
>
> The syscall number of compat_clock_getres was erroneously set to 247
> instead of 264. This causes the vDSO fallback of clock_getres to land
> on the wrong syscall.
>
> Address the issue fixing the syscall number of compat_clock_getres.
>
> Fixes: 53c489e1dfeb6 ("arm64: compat: Add missing syscall numbers")
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> ---
>  arch/arm64/include/asm/unistd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> index 1dd22da1c3a9..803039d504de 100644
> --- a/arch/arm64/include/asm/unistd.h
> +++ b/arch/arm64/include/asm/unistd.h
> @@ -25,8 +25,8 @@
>  #define __NR_compat_gettimeofday       78
>  #define __NR_compat_sigreturn          119
>  #define __NR_compat_rt_sigreturn       173
> -#define __NR_compat_clock_getres       247
>  #define __NR_compat_clock_gettime      263
> +#define __NR_compat_clock_getres       264

This seems to match up with the glibc sources:
https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/arm/arch-syscall.h;h=c6554a8a6a6e7fe3359f1272f619c3da7c90629b;hb=HEAD#l27
Here's bionic's headers for good measure:
https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/kernel/uapi/asm-arm/asm/unistd-common.h#240

I assume the _compat_ prefixes are the aarch32 syscall numbers?
Otherwise here's the list for aarch64:
https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/aarch64/arch-syscall.h;h=c8471947b9c209be6add1e528f892f1a6c54f966;hb=HEAD

Looks like 247 was __NR_io_cancel; that's a subtle bug I'm glad was noticed!

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>  #define __NR_compat_clock_gettime64    403
>  #define __NR_compat_clock_getres_time64        406
>
> --
> 2.25.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200319141138.19343-1-vincenzo.frascino%40arm.com.



-- 
Thanks,
~Nick Desaulniers
