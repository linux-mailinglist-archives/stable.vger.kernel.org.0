Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57C5251721
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 13:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgHYLJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 07:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHYLJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 07:09:41 -0400
Received: from localhost (unknown [122.171.38.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF072071E;
        Tue, 25 Aug 2020 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598353780;
        bh=EyhNLMhYjTKXxCJb/bl789+CwNuXvCvkL94D4pZiThk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PPNAaW7eBqJW6f4/9VRCAoTbNbpQIdjf6tDEQ54zOHyaLytI8WJIoIdZAwleR0TnT
         n/p6h6CrKfFfarPhc1ET4tCGcmw8CM32/ezwR/asvVaMrLvjeunr+tdRm9JNI7eaoh
         5zOhAN4AIeEZDEjMGfyr/jc+knShwssb2WzqMJR0=
Date:   Tue, 25 Aug 2020 16:39:37 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
Cc:     dmaengine@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: dw-edma: Fix linked list physical address
 calculation on non-64 bits architectures
Message-ID: <20200825110937.GI2639@vkoul-mobl>
References: <9d92b3c0f9304e3f2892833a70c726b911b29fd8.1597327637.git.gustavo.pimentel@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d92b3c0f9304e3f2892833a70c726b911b29fd8.1597327637.git.gustavo.pimentel@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13-08-20, 16:13, Gustavo Pimentel wrote:
> Fix linked list physical address calculation on non-64 bits architectures.
> 
> The paddr variable is phys_addr_t type, which can assume a different
> type (u64 or u32) depending on the conditional compilation flag
> CONFIG_PHYS_ADDR_T_64BIT.
> 
> Since this variable is used in with upper_32 bits() macro to get the
> value from 32 to 63 bits, on a non-64 bits architecture this variable
> will assume a u32 type, it can cause a compilation warning.
> 
> This issue was reported by a Coverity analysis.
> 
> Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")
> 
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
> ---
>  drivers/dma/dw-edma/dw-edma-v0-core.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
> index 692de47..cfabbf5 100644
> --- a/drivers/dma/dw-edma/dw-edma-v0-core.c
> +++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
> @@ -229,8 +229,13 @@ static void dw_edma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
>  	/* Channel control */
>  	SET_LL(&llp->control, control);
>  	/* Linked list  - low, high */
> -	SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> -	SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> +	#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +		SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> +		SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> +	#else /* CONFIG_PHYS_ADDR_T_64BIT */
> +		SET_LL(&llp->llp_low, chunk->ll_region.paddr);
> +		SET_LL(&llp->llp_high, 0x0);

Shouldn't upper_32_bits(chunk->ll_region.paddr) return zero for non
64bit archs?

> +	#endif /* CONFIG_PHYS_ADDR_T_64BIT */
>  }
>  
>  void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
> @@ -257,10 +262,16 @@ void dw_edma_v0_core_start(struct dw_edma_chunk *chunk, bool first)
>  		SET_CH(dw, chan->dir, chan->id, ch_control1,
>  		       (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));
>  		/* Linked list - low, high */
> -		SET_CH(dw, chan->dir, chan->id, llp_low,
> -		       lower_32_bits(chunk->ll_region.paddr));
> -		SET_CH(dw, chan->dir, chan->id, llp_high,
> -		       upper_32_bits(chunk->ll_region.paddr));
> +		#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +			SET_CH(dw, chan->dir, chan->id, llp_low,
> +			       lower_32_bits(chunk->ll_region.paddr));
> +			SET_CH(dw, chan->dir, chan->id, llp_high,
> +			       upper_32_bits(chunk->ll_region.paddr));
> +		#else /* CONFIG_PHYS_ADDR_T_64BIT */
> +			SET_CH(dw, chan->dir, chan->id, llp_low,
> +			       chunk->ll_region.paddr);
> +			SET_CH(dw, chan->dir, chan->id, llp_high, 0x0);
> +		#endif /* CONFIG_PHYS_ADDR_T_64BIT*/
>  	}
>  	/* Doorbell */
>  	SET_RW(dw, chan->dir, doorbell,
> -- 
> 2.7.4

-- 
~Vinod
