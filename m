Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE303618EE
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 06:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbhDPEfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 00:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDPEfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 00:35:09 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE2C061574;
        Thu, 15 Apr 2021 21:34:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s16so21212373iog.9;
        Thu, 15 Apr 2021 21:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wj0LmQcX4T3RD/LCUSwlZuN9U0k4EZ8z0GPjE5eqJ+c=;
        b=SeofBIy31lvaGo4ip2O0oyx2LsxzePZb/9lOB5C9/D+k6qqrK4+LfDdJT4Mtoj5Rw9
         QPXKrV/lFBRuv/SJ5LnbvZBDIK6pm+jc6J4mvF8ccSsB6avWE0IHq6EbS2DvYJZXC/jm
         i0ta7IKIkkgq/MX5hpCxGaA7mixRoz0T2cZ8dMDtx5RrFgFSteRq5nns1W2HlOoVv2fG
         LB/cwCQ6SO0DLfWqoHzZbzqBqZwM5zF+snorjJSGY8KpJBvNQ+cni0oeEJRFHot9ovle
         tlVN1aCCYLMa49lJ3RxGzhSTGdpbFQmRearzZmcvCGKONJuOWN4MllJizUsi3PIGCLax
         i39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wj0LmQcX4T3RD/LCUSwlZuN9U0k4EZ8z0GPjE5eqJ+c=;
        b=K+jVVmVxfyp05eJleOor6B8jK2ktteBzMLamMu6L9QVW0R9jgAeWSyQqwVSi7syrFk
         ibgg8oJlZ6Q7zzdV8MS0/dh/7rqoRnkvMkgAqUfg/WU/wzbjPsbTGi9LZl6WBDGwEHR9
         20UId57Av2AXdG7lJzx815VvVJpBlew6RO98KSg92GR4gD9iWd4xtOw6BrCI8ym6nc+F
         tFsj+tIma00YyIHuwf8o9b2Q4B+3n2bnlyGrZcfwlA62U3pQgfYqz1y4tSH4qKO1qVve
         Va3ED4gjlfkHgaEDEszXi1pM5Fiz2Uic+NFBS4nj7T3kXogf7bQx5x+Rbe8+7hiJ6bkr
         Xx5g==
X-Gm-Message-State: AOAM530xj1FshBgqnlt7A2g8b6Qn7Ncb9XDMUi8P6+BvMnvnB59AX9Wj
        l68xtftIuXVWlb0OhAK1ZLZV2yNd5RNOH2qUySI=
X-Google-Smtp-Source: ABdhPJytOPUOKUWf/eTtPMePF5L6DxvqY6VglSQ6/SSxDKWH2L5q4cw/KTLhsa10kl+UaBOEIqA4+If5fE/i8rTFXOI=
X-Received: by 2002:a5d:8ad2:: with SMTP id e18mr2068967iot.51.1618547685088;
 Thu, 15 Apr 2021 21:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200917000757.1232850-1-Tony.Ambardar@gmail.com> <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
In-Reply-To: <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Thu, 15 Apr 2021 21:34:36 -0700
Message-ID: <CAPGftE-Q+Q479j7SikDBQLiM+VKbpXpRYnTeEJeAHeZrh_Ok2A@mail.gmail.com>
Subject: Re: [PATCH v3] powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Michael,

The latest version of this patch addressed all feedback I'm aware of
when submitted last September, and I've seen no further comments from
reviewers since then.

Could you please let me know where this stands and if anything further
is needed?

Kind regards,
Tony

On Thu, 17 Sept 2020 at 06:54, Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> A few archs like powerpc have different errno.h values for macros
> EDEADLOCK and EDEADLK. In code including both libc and linux versions of
> errno.h, this can result in multiple definitions of EDEADLOCK in the
> include chain. Definitions to the same value (e.g. seen with mips) do
> not raise warnings, but on powerpc there are redefinitions changing the
> value, which raise warnings and errors (if using "-Werror").
>
> Guard against these redefinitions to avoid build errors like the following,
> first seen cross-compiling libbpf v5.8.9 for powerpc using GCC 8.4.0 with
> musl 1.1.24:
>
>   In file included from ../../arch/powerpc/include/uapi/asm/errno.h:5,
>                    from ../../include/linux/err.h:8,
>                    from libbpf.c:29:
>   ../../include/uapi/asm-generic/errno.h:40: error: "EDEADLOCK" redefined [-Werror]
>    #define EDEADLOCK EDEADLK
>
>   In file included from toolchain-powerpc_8540_gcc-8.4.0_musl/include/errno.h:10,
>                    from libbpf.c:26:
>   toolchain-powerpc_8540_gcc-8.4.0_musl/include/bits/errno.h:58: note: this is the location of the previous definition
>    #define EDEADLOCK       58
>
>   cc1: all warnings being treated as errors
>
> CC: Stable <stable@vger.kernel.org>
> Reported-by: Rosen Penev <rosenp@gmail.com>
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
> v1 -> v2:
>  * clean up commit description formatting
>
> v2 -> v3: (per Michael Ellerman)
>  * drop indeterminate 'Fixes' tags, request stable backports instead
> ---
>  arch/powerpc/include/uapi/asm/errno.h       | 1 +
>  tools/arch/powerpc/include/uapi/asm/errno.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/powerpc/include/uapi/asm/errno.h b/arch/powerpc/include/uapi/asm/errno.h
> index cc79856896a1..4ba87de32be0 100644
> --- a/arch/powerpc/include/uapi/asm/errno.h
> +++ b/arch/powerpc/include/uapi/asm/errno.h
> @@ -2,6 +2,7 @@
>  #ifndef _ASM_POWERPC_ERRNO_H
>  #define _ASM_POWERPC_ERRNO_H
>
> +#undef EDEADLOCK
>  #include <asm-generic/errno.h>
>
>  #undef EDEADLOCK
> diff --git a/tools/arch/powerpc/include/uapi/asm/errno.h b/tools/arch/powerpc/include/uapi/asm/errno.h
> index cc79856896a1..4ba87de32be0 100644
> --- a/tools/arch/powerpc/include/uapi/asm/errno.h
> +++ b/tools/arch/powerpc/include/uapi/asm/errno.h
> @@ -2,6 +2,7 @@
>  #ifndef _ASM_POWERPC_ERRNO_H
>  #define _ASM_POWERPC_ERRNO_H
>
> +#undef EDEADLOCK
>  #include <asm-generic/errno.h>
>
>  #undef EDEADLOCK
> --
> 2.25.1
>
