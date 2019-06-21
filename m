Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620384E851
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFUMxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 08:53:21 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57159 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUMxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 08:53:20 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mol@pengutronix.de>)
        id 1heJ2R-0002To-Qd; Fri, 21 Jun 2019 14:53:07 +0200
Received: from mol by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mol@pengutronix.de>)
        id 1heJ2P-0004TF-LK; Fri, 21 Jun 2019 14:53:05 +0200
Date:   Fri, 21 Jun 2019 14:53:05 +0200
From:   Michael Olbrich <m.olbrich@pengutronix.de>
To:     yibin.gong@nxp.com
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        vkoul@kernel.org, dan.j.williams@intel.com, thesven73@gmail.com,
        linux-imx@nxp.com, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
Message-ID: <20190621125305.jpmkrwfgruxs2yzt@pengutronix.de>
Mail-Followup-To: yibin.gong@nxp.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, vkoul@kernel.org,
        dan.j.williams@intel.com, thesven73@gmail.com, linux-imx@nxp.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, kernel@pengutronix.de
References: <20190621082306.34415-1-yibin.gong@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621082306.34415-1-yibin.gong@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:49:15 up 34 days, 19:07, 89 users,  load average: 0.03, 0.10,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mol@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 04:23:06PM +0800, yibin.gong@nxp.com wrote:
> From: Robin Gong <yibin.gong@nxp.com>
> 
> It is possible for an irq triggered by channel0 to be received later
> after clks are disabled once firmware loaded during sdma probe. If
> that happens then clearing them by writing to SDMA_H_INTR won't work
> and the kernel will hang processing infinite interrupts. Actually,
> don't need interrupt triggered on channel0 since it's pollling
> SDMA_H_STATSTOP to know channel0 done rather than interrupt in
> current code, just clear BD_INTR to disable channel0 interrupt to
> avoid the above case.
> This issue was brought by commit 1d069bfa3c78 ("dmaengine: imx-sdma:
> ack channel 0 IRQ in the interrupt handler") which didn't take care
> the above case.
> 
> Fixes: 1d069bfa3c78 ("dmaengine: imx-sdma: ack channel 0 IRQ in the interrupt handler")
> Cc: stable@vger.kernel.org #5.0+
> Signed-off-by: Robin Gong <yibin.gong@nxp.com>
> Reported-by: Sven Van Asbroeck <thesven73@gmail.com>
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com>

Reviewed-by: Michael Olbrich <m.olbrich@pengutronix.de>

> ---
>  drivers/dma/imx-sdma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index deea9aa..b5a1ee2 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -742,7 +742,7 @@ static int sdma_load_script(struct sdma_engine *sdma, void *buf, int size,
>  	spin_lock_irqsave(&sdma->channel_0_lock, flags);
>  
>  	bd0->mode.command = C0_SETPM;
> -	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
> +	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
>  	bd0->mode.count = size / 2;
>  	bd0->buffer_addr = buf_phys;
>  	bd0->ext_buffer_addr = address;
> @@ -1064,7 +1064,7 @@ static int sdma_load_context(struct sdma_channel *sdmac)
>  	context->gReg[7] = sdmac->watermark_level;
>  
>  	bd0->mode.command = C0_SETDM;
> -	bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
> +	bd0->mode.status = BD_DONE | BD_WRAP | BD_EXTD;
>  	bd0->mode.count = sizeof(*context) / 4;
>  	bd0->buffer_addr = sdma->context_phys;
>  	bd0->ext_buffer_addr = 2048 + (sizeof(*context) / 4) * channel;
> -- 
> 2.7.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
