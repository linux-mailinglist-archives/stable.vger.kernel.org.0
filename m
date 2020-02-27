Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C26171450
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgB0Jte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgB0Jte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 04:49:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3707C24672;
        Thu, 27 Feb 2020 09:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582796973;
        bh=/QdvraCnGtRxA0zvLjb/v7CRxk15JtrmgtQDCdnmk2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FLp2QdFBfpNl2eieCEkzjnZuIcQwrsi2OdOsn33NiEJRdovSaCrxdFz1ixr36oLwc
         g5R2mbC8i8vdOnTcpQgLlbiYr7994i/bJcUR6xs6J5Yn3jOGWrAOY59XlCK1Lhs4eU
         fYIT+t5uII1kz4RW265etZAdmIOl8mueveQUD2GI=
Date:   Thu, 27 Feb 2020 10:49:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andreas Tobler <andreas.tobler@onway.ch>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 160/344] dmaengine: imx-sdma: Fix memory leak
Message-ID: <20200227094931.GA579982@kroah.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <20200221072403.369335694@linuxfoundation.org>
 <1429291b-77c5-41aa-8dee-8858eba6d138@onway.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429291b-77c5-41aa-8dee-8858eba6d138@onway.ch>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 24, 2020 at 01:24:04PM +0000, Andreas Tobler wrote:
> Hi all,
> 
> On 21.02.20 08:39, Greg Kroah-Hartman wrote:
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > [ Upstream commit 02939cd167095f16328a1bd5cab5a90b550606df ]
> > 
> > The current descriptor is not on any list of the virtual DMA channel.
> > Once sdma_terminate_all() is called when a descriptor is currently
> > in flight then this one is forgotten to be freed. We have to call
> > vchan_terminate_vdesc() on this descriptor to re-add it to the lists.
> > Now that we also free the currently running descriptor we can (and
> > actually have to) remove the current descriptor from its list also
> > for the cyclic case.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Reviewed-by: Robin Gong <yibin.gong@nxp.com>
> > Tested-by: Robin Gong <yibin.gong@nxp.com>
> > Link: https://lore.kernel.org/r/20191216105328.15198-10-s.hauer@pengutronix.de
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/dma/imx-sdma.c | 19 +++++++++++--------
> >   1 file changed, 11 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index c27e206a764c3..66f1b2ac5cde4 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -760,12 +760,8 @@ static void sdma_start_desc(struct sdma_channel *sdmac)
> >   		return;
> >   	}
> >   	sdmac->desc = desc = to_sdma_desc(&vd->tx);
> > -	/*
> > -	 * Do not delete the node in desc_issued list in cyclic mode, otherwise
> > -	 * the desc allocated will never be freed in vchan_dma_desc_free_list
> > -	 */
> > -	if (!(sdmac->flags & IMX_DMA_SG_LOOP))
> > -		list_del(&vd->node);
> > +
> > +	list_del(&vd->node);
> >   
> >   	sdma->channel_control[channel].base_bd_ptr = desc->bd_phys;
> >   	sdma->channel_control[channel].current_bd_ptr = desc->bd_phys;
> > @@ -1071,7 +1067,6 @@ static void sdma_channel_terminate_work(struct work_struct *work)
> >   
> >   	spin_lock_irqsave(&sdmac->vc.lock, flags);
> >   	vchan_get_all_descriptors(&sdmac->vc, &head);
> > -	sdmac->desc = NULL;
> >   	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
> >   	vchan_dma_desc_free_list(&sdmac->vc, &head);
> >   	sdmac->context_loaded = false;
> > @@ -1080,11 +1075,19 @@ static void sdma_channel_terminate_work(struct work_struct *work)
> >   static int sdma_disable_channel_async(struct dma_chan *chan)
> >   {
> >   	struct sdma_channel *sdmac = to_sdma_chan(chan);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&sdmac->vc.lock, flags);
> >   
> >   	sdma_disable_channel(chan);
> >   
> > -	if (sdmac->desc)
> > +	if (sdmac->desc) {
> > +		vchan_terminate_vdesc(&sdmac->desc->vd);
> > +		sdmac->desc = NULL;
> >   		schedule_work(&sdmac->terminate_worker);
> > +	}
> > +
> > +	spin_unlock_irqrestore(&sdmac->vc.lock, flags);
> >   
> >   	return 0;
> >   }
> > 
> 
> This patch breaks our imx6 board with the attached trace.  Reverting the 
> patch makes it boot again.
> I tried also 5.6-rc3 and it booted too. A closer look into imx-sdma.c 
> from 5.6-rc3 showed me some details which might have to be backported as 
> well to make this patch work.
> I tried a1ff6a07f5a3951fcac84f064a76d1ad79c10e40 and was somehow 
> successful. I still have one trace but the board boots now.
> 
> Any insights from the experts?

I've now reverted it from all of the 3 stable trees it endeded up in.

thanks,

greg k-h
