Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988C533BB6A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhCOOQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:16:33 -0400
Received: from mail-vk1-f177.google.com ([209.85.221.177]:37786 "EHLO
        mail-vk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhCOOPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 10:15:45 -0400
Received: by mail-vk1-f177.google.com with SMTP id s136so1545727vks.4;
        Mon, 15 Mar 2021 07:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aKLCBuGZMniFg5moYt9Hm8gsNSTP/txooq0ahWmluQ=;
        b=EKKnPOjl1EHqg6BY6lpKz8lOYXYImv2r7l2tiHrtHqK85MMHzDDZkRkK44ja7sMaed
         g+gKycPYm7v5/LV9x/QnME9GKrV3tcOcv34pQqEN1yCedzMy2rdokK5qch63kCX7gvXe
         7NBs7jFHSJEcIfNPIWGikpI6j/2ALJk2p2ImI9SYWkaSqA2gkrkSGx1J2qaR4wbeAiT9
         PKH/LQhdqGh7fgUeEw8BRdaeTovxIUXCrPcYoWL00Xyko67QPDFVC7Su3ZsIU5TDPM7W
         5gh+zv36w4u0sGJXZWYbEuL5FKPS7AVpzzrAKeBQ1Hmv8JjCabiDZbKT2eSwkQ9Xhbqj
         Le7g==
X-Gm-Message-State: AOAM530krQE2yE6RXlKP/q+wcI3oIuPnTg7fu4bXpeIIl9pgKHkpTTIM
        J4/hYUF+l8LtHrPm+j8jqBKLW6FNkpeD1XReBYY=
X-Google-Smtp-Source: ABdhPJx9KtGyjUnLEGxws7UagErvyUZVKtNEH1dNMlk/6f03LGwnZwXFco4kvfj8C6eDlYRNBm9qIrW9CelDBckxh2I=
X-Received: by 2002:a1f:2502:: with SMTP id l2mr4822067vkl.5.1615817744231;
 Mon, 15 Mar 2021 07:15:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135541.921894249@linuxfoundation.org> <20210315135551.044220754@linuxfoundation.org>
In-Reply-To: <20210315135551.044220754@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 15 Mar 2021 15:15:32 +0100
Message-ID: <CAMuHMdUqDX8NSGNsw4R=-pEk+nNRsBPBhXD91bq4qy-v1ybcJQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 267/290] powerpc: Fix missing declaration of [en/dis]able_kernel_vsx()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 3:04 PM <gregkh@linuxfoundation.org> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> From: Christophe Leroy <christophe.leroy@csgroup.eu>
>
> commit bd73758803c2eedc037c2268b65a19542a832594 upstream.
>
> Add stub instances of enable_kernel_vsx() and disable_kernel_vsx()
> when CONFIG_VSX is not set, to avoid following build failure.

Please note that this is not sufficient, and will just turn the build error
in another, different build error.
Waiting for the subsequent fix to enter v5.12-rc4...
https://lore.kernel.org/lkml/2c123f94-ceae-80c0-90e2-21909795eb76@csgroup.eu/

>
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o
>   In file included from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services_types.h:29,
>                    from ./drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services.h:37,
>                    from drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:27:
>   drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c: In function 'dcn_bw_apply_registry_override':
>   ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:64:3: error: implicit declaration of function 'enable_kernel_vsx'; did you mean 'enable_kernel_fp'? [-Werror=implicit-function-declaration]
>      64 |   enable_kernel_vsx(); \
>         |   ^~~~~~~~~~~~~~~~~
>   drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:640:2: note: in expansion of macro 'DC_FP_START'
>     640 |  DC_FP_START();
>         |  ^~~~~~~~~~~
>   ./drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:75:3: error: implicit declaration of function 'disable_kernel_vsx'; did you mean 'disable_kernel_fp'? [-Werror=implicit-function-declaration]
>      75 |   disable_kernel_vsx(); \
>         |   ^~~~~~~~~~~~~~~~~~
>   drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.c:676:2: note: in expansion of macro 'DC_FP_END'
>     676 |  DC_FP_END();
>         |  ^~~~~~~~~
>   cc1: some warnings being treated as errors
>   make[5]: *** [drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o] Error 1
>
> This works because the caller is checking if VSX is available using
> cpu_has_feature():
>
>   #define DC_FP_START() { \
>         if (cpu_has_feature(CPU_FTR_VSX_COMP)) { \
>                 preempt_disable(); \
>                 enable_kernel_vsx(); \
>         } else if (cpu_has_feature(CPU_FTR_ALTIVEC_COMP)) { \
>                 preempt_disable(); \
>                 enable_kernel_altivec(); \
>         } else if (!cpu_has_feature(CPU_FTR_FPU_UNAVAILABLE)) { \
>                 preempt_disable(); \
>                 enable_kernel_fp(); \
>         } \
>
> When CONFIG_VSX is not selected, cpu_has_feature(CPU_FTR_VSX_COMP)
> constant folds to 'false' so the call to enable_kernel_vsx() is
> discarded and the build succeeds.
>
> Fixes: 16a9dea110a6 ("amdgpu: Enable initial DCN support on POWER")
> Cc: stable@vger.kernel.org # v5.6+
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> [mpe: Incorporate some discussion comments into the change log]
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/8d7d285a027e9d21f5ff7f850fa71a2655b0c4af.1615279170.git.christophe.leroy@csgroup.eu
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/powerpc/include/asm/switch_to.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> --- a/arch/powerpc/include/asm/switch_to.h
> +++ b/arch/powerpc/include/asm/switch_to.h
> @@ -71,6 +71,16 @@ static inline void disable_kernel_vsx(vo
>  {
>         msr_check_and_clear(MSR_FP|MSR_VEC|MSR_VSX);
>  }
> +#else
> +static inline void enable_kernel_vsx(void)
> +{
> +       BUILD_BUG();
> +}
> +
> +static inline void disable_kernel_vsx(void)
> +{
> +       BUILD_BUG();
> +}
>  #endif
>
>  #ifdef CONFIG_SPE

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
