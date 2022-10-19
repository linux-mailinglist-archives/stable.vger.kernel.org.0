Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123DD604D85
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJSQip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 12:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJSQio (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 12:38:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57C107CEC;
        Wed, 19 Oct 2022 09:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0987BB8254E;
        Wed, 19 Oct 2022 16:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2530C433D6;
        Wed, 19 Oct 2022 16:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666197520;
        bh=hWAN4W/Rzw9KgPVsCE2gQRgnd0phSSxJxzE7lCGoioY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TawPkvlnwajRtpZUccEz/raJqSSEkR5n6viMazNe8WRK1EZffnexS4T5CIdsvoAEe
         x/5VQl89yoYkabEm8Mk+WJ+G5KE1F0WbZegeR9hsITqEVDpbW9rUvneSWhuIu1I7ac
         ULGMrHZZuWC8r8j383T1XKANGZAux+MS4ukBcLbQTETqdZG4RuPHw9T1LlQxpniLQk
         /Ur7U4WJCqC3agt1DVCKpCudcMPrTZKqR91AGl/bfluP6I4Ygl0Ao1jShKfB61+nR+
         K//B1z0ST1JoSA87k+xhjwl2azEl5XiFv5+BmlBBP2eH7RXegD34d3PWdIDdJFgBfh
         v5LwsnJpcfcgA==
Date:   Wed, 19 Oct 2022 22:08:36 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     peda@axentia.se, du@axentia.se, regressions@leemhuis.info,
        ludovic.desroches@microchip.com, maciej.sosnowski@intel.com,
        dan.j.williams@intel.com, nicolas.ferre@microchip.com,
        mripard@kernel.org, torfl6749@gmail.com,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tudor Ambarus <tudor.ambarus@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 07/33] dmaengine: at_hdmac: Fix at_lli struct definition
Message-ID: <Y1AoDDVoiWDJ2ae2@matsya>
References: <20220820125717.588722-1-tudor.ambarus@microchip.com>
 <20220820125717.588722-8-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820125717.588722-8-tudor.ambarus@microchip.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20-08-22, 15:56, Tudor Ambarus wrote:
> From: Tudor Ambarus <tudor.ambarus@gmail.com>
> 
> Those hardware registers are all of 32 bits, while dma_addr_t ca be of
> type u64 or u32 depending on CONFIG_ARCH_DMA_ADDR_T_64BIT. Force u32 to
> comply with what the hardware expects.
> 
> Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@gmail.com>
> Cc: stable@vger.kernel.org

Okay

> ---
>  drivers/dma/at_hdmac.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 91e53a590d5f..e89facf14fab 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -187,13 +187,13 @@
>  /* LLI == Linked List Item; aka DMA buffer descriptor */
>  struct at_lli {
>  	/* values that are not changed by hardware */
> -	dma_addr_t	saddr;
> -	dma_addr_t	daddr;
> +	u32 saddr;
> +	u32 daddr;

I think you should add fixes first in the series and then do header
move, that way we can backport this and other fixes to stable kernels...

>  	/* value that may get written back: */
> -	u32		ctrla;
> +	u32 ctrla;
>  	/* more values that are not changed by hardware */
> -	u32		ctrlb;
> -	dma_addr_t	dscr;	/* chain to next lli */
> +	u32 ctrlb;
> +	u32 dscr;	/* chain to next lli */
>  };
>  
>  /**
> -- 
> 2.25.1

-- 
~Vinod
