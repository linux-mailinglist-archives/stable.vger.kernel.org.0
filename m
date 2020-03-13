Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3241848B6
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 15:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgCMODR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 10:03:17 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:48708 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgCMODR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 10:03:17 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7424D5F;
        Fri, 13 Mar 2020 15:03:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1584108194;
        bh=gPbT+x8g4idIbaikR9Dwjy5YbKNa0Oc/b944BUbYp8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t8hHE13nXX9VIWZinuqgdGWhyDAqrEY+0vA6raNkjindaw8wudaqfCinONqV11u76
         F4u3MRrL+CaxPUsld63J+lEA0Rj7cZLZA3pumQFCZesYvGk6MIzBFz4k3Pm0J5DT5E
         qzEHE4Ba7j3qjEfHNJFQPMabKaY6Pd9FMchsHCz8=
Date:   Fri, 13 Mar 2020 16:03:11 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: ti-vpe: cal: fix DMA memory corruption
Message-ID: <20200313140311.GF4751@pendragon.ideasonboard.com>
References: <20200313082639.7743-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200313082639.7743-1-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi,

Thank you for the patch.

On Fri, Mar 13, 2020 at 10:26:39AM +0200, Tomi Valkeinen wrote:
> When the CAL driver stops streaming, it will shut everything down
> without waiting for the current frame to finish. This leaves the CAL DMA
> in a slightly undefined state, and when CAL DMA is enabled when the
> stream is started the next time, the old DMA transfer will continue.
> 
> It is not clear if the old DMA transfer continues with the exact
> settings of the original transfer, or is it a mix of old and new
> settings, but in any case the end result is memory corruption as the
> destination memory address is no longer valid.
> 
> I could not find any way to ensure that any old DMA transfer would be
> discarded, except perhaps full CAL reset. But we cannot do a full reset
> when one port is getting enabled, as that would reset both ports.
> 
> This patch tries to make sure that the DMA transfer is finished properly
> when the stream is being stopped. I say "tries", as, as mentioned above,
> I don't see a way to force the DMA transfer to finish. I believe this
> fixes the corruptions for normal cases, but if for some reason the DMA
> of the final frame would stall a lot, resulting in timeout in the code
> waiting for the DMA to finish, we'll again end up with unfinished DMA
> transfer. However, I don't know what could cause such a timeout.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/platform/ti-vpe/cal.c | 32 +++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index be54806180a5..b857cab120ad 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -414,6 +414,8 @@ struct cal_ctx {
>  	struct cal_buffer	*cur_frm;
>  	/* Pointer pointing to next v4l2_buffer */
>  	struct cal_buffer	*next_frm;
> +
> +	bool dma_act;
>  };
>  
>  static const struct cal_fmt *find_format_by_pix(struct cal_ctx *ctx,
> @@ -944,6 +946,7 @@ static void csi2_lane_config(struct cal_ctx *ctx)
>  
>  static void csi2_ppi_enable(struct cal_ctx *ctx)
>  {
> +	reg_write(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port), BIT(3));
>  	reg_write_field(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port),
>  			CAL_GEN_ENABLE, CAL_CSI2_PPI_CTRL_IF_EN_MASK);
>  }
> @@ -1206,15 +1209,25 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
>  		if (isportirqset(irqst2, 1)) {
>  			ctx = dev->ctx[0];
>  
> +			spin_lock(&ctx->slock);
> +			ctx->dma_act = false;
> +
>  			if (ctx->cur_frm != ctx->next_frm)
>  				cal_process_buffer_complete(ctx);
> +
> +			spin_unlock(&ctx->slock);
>  		}
>  
>  		if (isportirqset(irqst2, 2)) {
>  			ctx = dev->ctx[1];
>  
> +			spin_lock(&ctx->slock);
> +			ctx->dma_act = false;
> +
>  			if (ctx->cur_frm != ctx->next_frm)
>  				cal_process_buffer_complete(ctx);
> +
> +			spin_unlock(&ctx->slock);
>  		}
>  	}
>  
> @@ -1230,6 +1243,7 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
>  			dma_q = &ctx->vidq;
>  
>  			spin_lock(&ctx->slock);
> +			ctx->dma_act = true;
>  			if (!list_empty(&dma_q->active) &&
>  			    ctx->cur_frm == ctx->next_frm)
>  				cal_schedule_next_buffer(ctx);
> @@ -1241,6 +1255,7 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
>  			dma_q = &ctx->vidq;
>  
>  			spin_lock(&ctx->slock);
> +			ctx->dma_act = true;
>  			if (!list_empty(&dma_q->active) &&
>  			    ctx->cur_frm == ctx->next_frm)
>  				cal_schedule_next_buffer(ctx);
> @@ -1713,10 +1728,27 @@ static void cal_stop_streaming(struct vb2_queue *vq)
>  	struct cal_ctx *ctx = vb2_get_drv_priv(vq);
>  	struct cal_dmaqueue *dma_q = &ctx->vidq;
>  	struct cal_buffer *buf, *tmp;
> +	unsigned long timeout;
>  	unsigned long flags;
>  	int ret;
> +	bool dma_act;
>  
>  	csi2_ppi_disable(ctx);
> +
> +	/* wait for stream and dma to finish */
> +	dma_act = true;
> +	timeout = jiffies + msecs_to_jiffies(500);
> +	while (dma_act && time_before(jiffies, timeout)) {
> +		msleep(50);
> +
> +		spin_lock_irqsave(&ctx->slock, flags);
> +		dma_act = ctx->dma_act;
> +		spin_unlock_irqrestore(&ctx->slock, flags);
> +	}

Waiting for the transfer to complete seems to be a good idea, but how
about using a wait queue instead of such a loop ? That would allow
better usage of CPU time and faster reaction time, and shouldn't be
difficult to implement. You may also want to replace dma_act with a
state if needed (in case you need to express running/stopping/stopped
states), and I would rename it to running if you just need a boolean.

> +
> +	if (dma_act)
> +		ctx_err(ctx, "failed to disable dma cleanly\n");
> +
>  	disable_irqs(ctx);
>  	csi2_phy_deinit(ctx);
>  

-- 
Regards,

Laurent Pinchart
