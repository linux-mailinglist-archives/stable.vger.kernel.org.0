Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABC620BABF
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFZU4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 16:56:30 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:38071 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZU4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 16:56:30 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 69A9D20002;
        Fri, 26 Jun 2020 20:56:27 +0000 (UTC)
Date:   Fri, 26 Jun 2020 22:56:27 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 08/10] mfd: atmel-smc: Silence comparison of unsigned
 expression < 0 is always false warning (W=1)
Message-ID: <20200626205627.GU131826@piout.net>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-9-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200625064619.2775707-9-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 25/06/2020 07:46:17+0100, Lee Jones wrote:
> GENMASK and it's callees conduct checking to ensure the passed
> parameters are valid.  One of those checks is for '< 0'.  So if an
> unsigned value is passed, in an invalid comparison takes place.
> 
> Judging from the current code, it looks as though 'unsigned int'
> is the correct type to use, so simply cast these small values
> with no chance of being false negative to signed int for
> comparison/error checking purposes.
> 

I've been thinking about that one but shouldn't the proper fix be in
GENMASK? My understanding is that this happens because l is 0 and I
don't think GENMASK would ever expect negative number. What about simply
checking that h != l when l is 0?

> Squashes the following W=1 warnings:
> 
>  In file included from /home/lee/projects/linux/kernel/include/linux/bits.h:23,
>  from /home/lee/projects/linux/kernel/include/linux/bitops.h:5,
>  from /home/lee/projects/linux/kernel/include/linux/kernel.h:12,
>  from /home/lee/projects/linux/kernel/include/linux/mfd/syscon/atmel-smc.h:14,
>  from /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c:11:
>  /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c: In function ‘atmel_smc_cs_encode_ncycles’:
>  /home/lee/projects/linux/kernel/include/linux/bits.h:26:28: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>  26 | __builtin_constant_p((l) > (h)), (l) > (h), 0)))
>  | ^
>  /home/lee/projects/linux/kernel/include/linux/build_bug.h:16:62: note: in definition of macro ‘BUILD_BUG_ON_ZERO’
>  16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
>  | ^
>  /home/lee/projects/linux/kernel/include/linux/bits.h:39:3: note: in expansion of macro ‘GENMASK_INPUT_CHECK’
>  39 | (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>  | ^~~~~~~~~~~~~~~~~~~
>  /home/lee/projects/linux/kernel/drivers/mfd/atmel-smc.c:49:25: note: in expansion of macro ‘GENMASK’
>  49 | unsigned int lsbmask = GENMASK(msbpos - 1, 0);
>  | ^~~~~~~
>  /home/lee/projects/linux/kernel/include/linux/bits.h:26:40: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>  26 | __builtin_constant_p((l) > (h)), (l) > (h), 0)))
>  | ^
>  /home/lee/projects/linux/kernel/include/linux/build_bug.h:16:62: note: in definition of macro ‘BUILD_BUG_ON_ZERO’
>  16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e)); })))
>  | ^
>  /home/lee/projects/linux/kernel/include/linux/bits.h:39:3: note: in expansion of macro ‘GENMASK_INPUT_CHECK’
>  39 | (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
>  | ^~~~~~~~~~~~~~~~~~~
> 
> Cc: <stable@vger.kernel.org>
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/atmel-smc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/atmel-smc.c b/drivers/mfd/atmel-smc.c
> index 1fa2ec950e7df..17bbe9d1fa740 100644
> --- a/drivers/mfd/atmel-smc.c
> +++ b/drivers/mfd/atmel-smc.c
> @@ -46,8 +46,8 @@ static int atmel_smc_cs_encode_ncycles(unsigned int ncycles,
>  				       unsigned int msbfactor,
>  				       unsigned int *encodedval)
>  {
> -	unsigned int lsbmask = GENMASK(msbpos - 1, 0);
> -	unsigned int msbmask = GENMASK(msbwidth - 1, 0);
> +	unsigned int lsbmask = GENMASK((int)msbpos - 1, 0);
> +	unsigned int msbmask = GENMASK((int)msbwidth - 1, 0);
>  	unsigned int msb, lsb;
>  	int ret = 0;
>  
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
