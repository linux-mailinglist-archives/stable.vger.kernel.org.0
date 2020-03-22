Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FBB18EBB8
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 19:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgCVS4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 14:56:43 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:59256 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVS4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 14:56:43 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Mar 2020 14:56:41 EDT
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 3B378C6B271;
        Sun, 22 Mar 2020 19:50:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1584903024;
        bh=Mmnkh4tIPhkmDVqzDTAxBITfEcPQAAHBwGY25ObTH98=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=R5zcCdz2BV4YcW5+v5CB5WJrATuiFow7KNrQAJKODRSY5cb0gvNEJ5/hsBWPJTNEV
         ZH1fr09d6nlMd+Cqo6kRhPd2cXRSrL11R8rzfhhxmqmMM3ogcTKiQGzeomnju7NSxA
         GuMqkMuUUJMJd2a3cSc2sLzOUFRJKvYTPTm/KuE8=
Date:   Sun, 22 Mar 2020 19:50:22 +0100
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     Rouven Czerwinski <r.czerwinski@pengutronix.de>
Cc:     s.hauer@pengutronix.de, shawnguo@kernel.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: imx: build v7_cpu_resume() unconditionally
Message-ID: <20200322185022.GA82867@workstation.tuxnet>
Reply-To: 20200116141849.73955-1-r.czerwinski@pengutronix.de
References: <20200116141849.73955-1-r.czerwinski@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116141849.73955-1-r.czerwinski@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jan 16, 2020 at 03:18:49PM +0100, Rouven Czerwinski wrote:
> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> This function is not only needed by the platform suspend code, but is also
> reused as the CPU resume function when the ARM cores can be powered down
> completely in deep idle, which is the case on i.MX6SX and i.MX6UL(L).
> 
> Providing the static inline stub whenever CONFIG_SUSPEND is disabled means
> that those platforms will hang on resume from cpuidle if suspend is disabled.
> 
> So there are two problems:
> 
>   - The static inline stub masks the linker error
>   - The function is not available where needed
> 
> Fix both by just building the function unconditionally, when
> CONFIG_SOC_IMX6 is enabled. The actual code is three instructions long,
> so it's arguably ok to just leave it in for all i.MX6 kernel configurations.
> 
> Fixes: 05136f0897b5 ("ARM: imx: support arm power off in cpuidle for i.mx6sx")
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
> ---
>  arch/arm/mach-imx/Makefile       |  2 ++
>  arch/arm/mach-imx/common.h       |  4 ++--
>  arch/arm/mach-imx/resume-imx6.S  | 24 ++++++++++++++++++++++++
>  arch/arm/mach-imx/suspend-imx6.S | 14 --------------
>  4 files changed, 28 insertions(+), 16 deletions(-)
>  create mode 100644 arch/arm/mach-imx/resume-imx6.S
> 
> diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
> index 35ff620537e6..03506ce46149 100644
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@ -91,6 +91,8 @@ AFLAGS_suspend-imx6.o :=-Wa,-march=armv7-a
>  obj-$(CONFIG_SOC_IMX6) += suspend-imx6.o
>  obj-$(CONFIG_SOC_IMX53) += suspend-imx53.o
>  endif
> +AFLAGS_resume-imx6.o :=-Wa,-march=armv7-a
> +obj-$(CONFIG_SOC_IMX6) += resume-imx6.o
>  obj-$(CONFIG_SOC_IMX6) += pm-imx6.o
>  
>  obj-$(CONFIG_SOC_IMX1) += mach-imx1.o
> diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
> index 912aeceb4ff8..5aa5796cff0e 100644
> --- a/arch/arm/mach-imx/common.h
> +++ b/arch/arm/mach-imx/common.h
> @@ -109,17 +109,17 @@ void imx_cpu_die(unsigned int cpu);
>  int imx_cpu_kill(unsigned int cpu);
>  
>  #ifdef CONFIG_SUSPEND
> -void v7_cpu_resume(void);
>  void imx53_suspend(void __iomem *ocram_vbase);
>  extern const u32 imx53_suspend_sz;
>  void imx6_suspend(void __iomem *ocram_vbase);
>  #else
> -static inline void v7_cpu_resume(void) {}
>  static inline void imx53_suspend(void __iomem *ocram_vbase) {}
>  static const u32 imx53_suspend_sz;
>  static inline void imx6_suspend(void __iomem *ocram_vbase) {}
>  #endif
>  
> +void v7_cpu_resume(void);
> +
>  void imx6_pm_ccm_init(const char *ccm_compat);
>  void imx6q_pm_init(void);
>  void imx6dl_pm_init(void);
> diff --git a/arch/arm/mach-imx/resume-imx6.S b/arch/arm/mach-imx/resume-imx6.S
> new file mode 100644
> index 000000000000..5bd1ba7ef15b
> --- /dev/null
> +++ b/arch/arm/mach-imx/resume-imx6.S
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright 2014 Freescale Semiconductor, Inc.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/hardware/cache-l2x0.h>
> +#include "hardware.h"
> +
> +/*
> + * The following code must assume it is running from physical address
> + * where absolute virtual addresses to the data section have to be
> + * turned into relative ones.
> + */
> +
> +ENTRY(v7_cpu_resume)
> +	bl	v7_invalidate_l1
> +#ifdef CONFIG_CACHE_L2X0
> +	bl	l2c310_early_resume
> +#endif
> +	b	cpu_resume
> +ENDPROC(v7_cpu_resume)
> diff --git a/arch/arm/mach-imx/suspend-imx6.S b/arch/arm/mach-imx/suspend-imx6.S
> index 062391ff13da..1eabf2d2834b 100644
> --- a/arch/arm/mach-imx/suspend-imx6.S
> +++ b/arch/arm/mach-imx/suspend-imx6.S
> @@ -327,17 +327,3 @@ resume:
>  
>  	ret	lr
>  ENDPROC(imx6_suspend)
> -
> -/*
> - * The following code must assume it is running from physical address
> - * where absolute virtual addresses to the data section have to be
> - * turned into relative ones.
> - */
> -
> -ENTRY(v7_cpu_resume)
> -	bl	v7_invalidate_l1
> -#ifdef CONFIG_CACHE_L2X0
> -	bl	l2c310_early_resume
> -#endif
> -	b	cpu_resume
> -ENDPROC(v7_cpu_resume)
> -- 
> 2.25.0

This patch broke the build for our i.MX6 kernel.

I am referring to commits 512a928aff in mainline and
7199cb65bb in linux-stable.

In our kernel, neither CONFIG_PM nor CONFIG_SUSPEND are set. Therefore,
ARM_CPU_SUSPEND is also unset, which means that sleep.S (containing
cpu_resume) is not built.

With this patch, ld reports the following error:
arch/arm/mach-imx/resume-imx6.o: in function `v7_cpu_resume':
(.text+0x8): undefined reference to `cpu_resume'

Best regards,
Clemens
