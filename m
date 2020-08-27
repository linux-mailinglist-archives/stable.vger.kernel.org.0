Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1C253D17
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 07:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgH0FKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 01:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgH0FKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 01:10:53 -0400
Received: from localhost (unknown [122.171.38.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A55020639;
        Thu, 27 Aug 2020 05:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598505052;
        bh=tX7GZOO7LfjDunkhw2PIoOqNvJKif05ZX2TOPHyhupM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjjbDbdsYHnLDl0CQ5pU+jRifCcfbvDbCxZFXrsq6A7zq688yS/KXlrt6oLhr1nsU
         tmr9cfHpiy6ZjRuoYtpIHTEqzEBFIF0+9SEbtR7nACEMY8K+X3iAe8g3KYfYV2I89B
         xKmpPIPBuqOGBs91wRWxCAjUXtuv853Utx4BE1Ww=
Date:   Thu, 27 Aug 2020 10:40:48 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Gustavo Pimentel <Gustavo.Pimentel@synopsys.com>
Cc:     "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: dw-edma: Fix linked list physical address
 calculation on non-64 bits architectures
Message-ID: <20200827051048.GH2639@vkoul-mobl>
References: <9d92b3c0f9304e3f2892833a70c726b911b29fd8.1597327637.git.gustavo.pimentel@synopsys.com>
 <20200825110937.GI2639@vkoul-mobl>
 <DM5PR12MB127696E920BD51BA1788CDE0DA540@DM5PR12MB1276.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR12MB127696E920BD51BA1788CDE0DA540@DM5PR12MB1276.namprd12.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26-08-20, 12:31, Gustavo Pimentel wrote:
> On Tue, Aug 25, 2020 at 12:9:37, Vinod Koul <vkoul@kernel.org> wrote:
> 
> > On 13-08-20, 16:13, Gustavo Pimentel wrote:
> > > Fix linked list physical address calculation on non-64 bits architectures.
> > > 
> > > The paddr variable is phys_addr_t type, which can assume a different
> > > type (u64 or u32) depending on the conditional compilation flag
> > > CONFIG_PHYS_ADDR_T_64BIT.
> > > 
> > > Since this variable is used in with upper_32 bits() macro to get the
> > > value from 32 to 63 bits, on a non-64 bits architecture this variable
> > > will assume a u32 type, it can cause a compilation warning.
> > > 
> > > This issue was reported by a Coverity analysis.
> > > 
> > > Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")
> > > 
> > > Cc: Joao Pinto <jpinto@synopsys.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
> > > ---
> > >  drivers/dma/dw-edma/dw-edma-v0-core.c | 23 +++++++++++++++++------
> > >  1 file changed, 17 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
> > > index 692de47..cfabbf5 100644
> > > --- a/drivers/dma/dw-edma/dw-edma-v0-core.c
> > > +++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
> > > @@ -229,8 +229,13 @@ static void dw_edma_v0_core_write_chunk(struct dw_edma_chunk *chunk)
> > >  	/* Channel control */
> > >  	SET_LL(&llp->control, control);
> > >  	/* Linked list  - low, high */
> > > -	SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> > > -	SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> > > +	#ifdef CONFIG_PHYS_ADDR_T_64BIT
> > > +		SET_LL(&llp->llp_low, lower_32_bits(chunk->ll_region.paddr));
> > > +		SET_LL(&llp->llp_high, upper_32_bits(chunk->ll_region.paddr));
> > > +	#else /* CONFIG_PHYS_ADDR_T_64BIT */
> > > +		SET_LL(&llp->llp_low, chunk->ll_region.paddr);
> > > +		SET_LL(&llp->llp_high, 0x0);
> > 
> > Shouldn't upper_32_bits(chunk->ll_region.paddr) return zero for non
> > 64bit archs?
> 
> At the time when I made this patch, I got a compiler warning about the 
> u32 vs u64 type mixing (phys_addr_t) and the macro usage upper_32 bits() 
> on non-64 bits architectures. That's why I made this patch, but now I 
> don't see this warning anymore.
> 
> Vinod, please disregard this patch.

Ok dropped

-- 
~Vinod
