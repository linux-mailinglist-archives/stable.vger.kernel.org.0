Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82916A8E8
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBXO5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:57:22 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48125 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbgBXO5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 09:57:22 -0500
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j6FAe-0003ni-2e; Mon, 24 Feb 2020 15:57:20 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1j6FAc-00051T-CF; Mon, 24 Feb 2020 15:57:18 +0100
Date:   Mon, 24 Feb 2020 15:57:18 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Andreas Tobler <andreas.tobler@onway.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 160/344] dmaengine: imx-sdma: Fix memory leak
Message-ID: <20200224145718.GD3335@pengutronix.de>
References: <20200221072349.335551332@linuxfoundation.org>
 <20200221072403.369335694@linuxfoundation.org>
 <1429291b-77c5-41aa-8dee-8858eba6d138@onway.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429291b-77c5-41aa-8dee-8858eba6d138@onway.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:50:25 up 4 days, 22:20, 54 users,  load average: 2.13, 1.11, 0.58
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
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

This series should be applied as a whole or not, only 7/9 is optional.

It seems I have to avoid the trigger word "fix" in my commit messages or
make sure these patches won't apply without their dependencies :-/

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
