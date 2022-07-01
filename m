Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADCB5636F1
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiGAPbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 11:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiGAPba (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 11:31:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88118D11D;
        Fri,  1 Jul 2022 08:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4ACDCE3403;
        Fri,  1 Jul 2022 15:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C23C3411E;
        Fri,  1 Jul 2022 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656689485;
        bh=rrJCf3vJgrQJ+YDVNbRHrGoO6qH/+gt0pSDAm3rT19g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXHcGY+Dr77BDpSoUIpjZp4rArDlJe/hjm8pDZgh5x1cHiDrbv5kz7bpN8pnCYXb4
         oyJ8vFNNdv0eeLJnQz8qKDx4LTXwQzB4QmQoEO0fRFbIm4kAFJzL3DmigVjQra44tM
         p+V6sNBTW3rVyrOlGdVTrRCZ3UseXfNZOZv2NAGgrKGLPQ8GOhlWDuPqGLaFr4XWLB
         C50zr7dNVZlnEldHuZqQukkvhQ2sbFvOaOGq0Z87GAYgSzNbuNLYngaFmRxkEdTnWA
         O6CegvVz8WGaBcPUE2h/4eKH6ZNmVdUNdwZqPoZn2CZhJAVQ5yQnuAxzCMVtGAQffp
         6mgP8o299Z8dg==
Date:   Fri, 1 Jul 2022 08:31:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5.15 02/28] clocksource/drivers/ixp4xx: remove __init
 from ixp4xx_timer_setup()
Message-ID: <Yr8TSxroBaL3oRDV@dev-arch.thelio-3990X>
References: <20220630133232.926711493@linuxfoundation.org>
 <20220630133233.000575254@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133233.000575254@linuxfoundation.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jun 30, 2022 at 03:46:58PM +0200, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ixp4xx_timer_setup is exported, and so can not be an __init function.
> Remove the __init marking as the build system is rightfully claiming
> this is an error in older kernels.
> 
> This is fixed "properly" in commit 41929c9f628b
> ("clocksource/drivers/ixp4xx: Drop boardfile probe path") but that can
> not be backported to older kernels as the reworking of the IXP4xx
> codebase is not suitable for stable releases.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This patch causes the following warnings with clang when building
ARCH=arm allmodconfig on 5.15, 5.10, and 5.4. I am surprised nobody else
saw them.

  WARNING: modpost: vmlinux.o(.text+0x1219ccc): Section mismatch in reference from the function ixp4xx_timer_register() to the function .init.text:sched_clock_register()
  The function ixp4xx_timer_register() references
  the function __init sched_clock_register().
  This is often because ixp4xx_timer_register lacks a __init
  annotation or the annotation of sched_clock_register is wrong.

  WARNING: modpost: vmlinux.o(.text+0x1219cf4): Section mismatch in reference from the function ixp4xx_timer_register() to the function .init.text:register_current_timer_delay()
  The function ixp4xx_timer_register() references
  the function __init register_current_timer_delay().
  This is often because ixp4xx_timer_register lacks a __init
  annotation or the annotation of register_current_timer_delay is wrong.

I think it would just be better to remove the export of
ixp4xx_timer_setup(), rather than removing __init, as it is only called
in arch/arm/mach-ixp4xx/common.c, which has to be built into the kernel
image as it is 'obj-y' in arch/arm/mach-ixp4xx/Makefile.

Cheers,
Nathan

> ---
>  drivers/clocksource/mmio.c                 |    2 +-
>  drivers/clocksource/timer-ixp4xx.c         |   10 ++++------
>  include/linux/platform_data/timer-ixp4xx.h |    5 ++---
>  3 files changed, 7 insertions(+), 10 deletions(-)
> 
> --- a/drivers/clocksource/mmio.c
> +++ b/drivers/clocksource/mmio.c
> @@ -46,7 +46,7 @@ u64 clocksource_mmio_readw_down(struct c
>   * @bits:	Number of valid bits
>   * @read:	One of clocksource_mmio_read*() above
>   */
> -int __init clocksource_mmio_init(void __iomem *base, const char *name,
> +int clocksource_mmio_init(void __iomem *base, const char *name,
>  	unsigned long hz, int rating, unsigned bits,
>  	u64 (*read)(struct clocksource *))
>  {
> --- a/drivers/clocksource/timer-ixp4xx.c
> +++ b/drivers/clocksource/timer-ixp4xx.c
> @@ -161,9 +161,8 @@ static int ixp4xx_resume(struct clock_ev
>   * We use OS timer1 on the CPU for the timer tick and the timestamp
>   * counter as a source of real clock ticks to account for missed jiffies.
>   */
> -static __init int ixp4xx_timer_register(void __iomem *base,
> -					int timer_irq,
> -					unsigned int timer_freq)
> +static int ixp4xx_timer_register(void __iomem *base, int timer_irq,
> +				 unsigned int timer_freq)
>  {
>  	struct ixp4xx_timer *tmr;
>  	int ret;
> @@ -269,9 +268,8 @@ builtin_platform_driver(ixp4xx_timer_dri
>   * @timer_irq: Linux IRQ number for the timer
>   * @timer_freq: Fixed frequency of the timer
>   */
> -void __init ixp4xx_timer_setup(resource_size_t timerbase,
> -			       int timer_irq,
> -			       unsigned int timer_freq)
> +void ixp4xx_timer_setup(resource_size_t timerbase, int timer_irq,
> +			unsigned int timer_freq)
>  {
>  	void __iomem *base;
>  
> --- a/include/linux/platform_data/timer-ixp4xx.h
> +++ b/include/linux/platform_data/timer-ixp4xx.h
> @@ -4,8 +4,7 @@
>  
>  #include <linux/ioport.h>
>  
> -void __init ixp4xx_timer_setup(resource_size_t timerbase,
> -			       int timer_irq,
> -			       unsigned int timer_freq);
> +void ixp4xx_timer_setup(resource_size_t timerbase, int timer_irq,
> +			unsigned int timer_freq);
>  
>  #endif
> 
> 
> 
