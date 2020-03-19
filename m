Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2902C18C269
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 22:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCSVlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 17:41:09 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56582 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgCSVlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 17:41:09 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JLf5Nb027532;
        Thu, 19 Mar 2020 16:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584654065;
        bh=A4QzO/U21N2waW1z3m3uzaszNEWry0vYk9u2ILeEemg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KCobcjehZDXIemtrJ73qPbnT9LG/MfkD5554KNrMP/26ZImbkIC3oJhHBOQk2QaI1
         qKzcFJHhjpBXRUdPCoh5tdVOqZvMJ17BYAjSkZiBfsuz3cSOkI9H5rFrXMJln7MgtK
         b0WIW3+ztW2bp/IHRaaZen1cmoC4EVzrNR8fmz7k=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JLf5fr072134
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 16:41:05 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 16:41:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 16:41:05 -0500
Received: from [10.250.87.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JLf4EM008852;
        Thu, 19 Mar 2020 16:41:05 -0500
Subject: Re: [PATCH v2 01/19] media: ti-vpe: cal: fix DMA memory corruption
To:     Dave Gerlach <d-gerlach@ti.com>
CC:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, <stable@vger.kernel.org>
References: <20200319075023.22151-1-tomi.valkeinen@ti.com>
 <20200319075023.22151-2-tomi.valkeinen@ti.com>
From:   Benoit Parrot <bparrot@ti.com>
Message-ID: <ef63d690-9e42-920d-545b-c2c0d35177b7@ti.com>
Date:   Thu, 19 Mar 2020 16:41:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319075023.22151-2-tomi.valkeinen@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the patch.

On 3/19/20 2:50 AM, Tomi Valkeinen wrote:
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
> index 6c8f3702eac0..9dd6de14189b 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -412,6 +412,8 @@ struct cal_ctx {
>  	struct cal_buffer	*cur_frm;
>  	/* Pointer pointing to next v4l2_buffer */
>  	struct cal_buffer	*next_frm;
> +
> +	bool dma_act;
>  };
>  
>  static const struct cal_fmt *find_format_by_pix(struct cal_ctx *ctx,
> @@ -942,6 +944,7 @@ static void csi2_lane_config(struct cal_ctx *ctx)
>  
>  static void csi2_ppi_enable(struct cal_ctx *ctx)
>  {
> +	reg_write(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port), BIT(3));
>  	reg_write_field(ctx->dev, CAL_CSI2_PPI_CTRL(ctx->csi2_port),
>  			CAL_GEN_ENABLE, CAL_CSI2_PPI_CTRL_IF_EN_MASK);
>  }
> @@ -1204,15 +1207,25 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
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

This totally wrong.

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
> @@ -1228,6 +1241,7 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
>  			dma_q = &ctx->vidq;
>  
>  			spin_lock(&ctx->slock);
> +			ctx->dma_act = true;
>  			if (!list_empty(&dma_q->active) &&
>  			    ctx->cur_frm == ctx->next_frm)
>  				cal_schedule_next_buffer(ctx);
> @@ -1239,6 +1253,7 @@ static irqreturn_t cal_irq(int irq_cal, void *data)
>  			dma_q = &ctx->vidq;
>  
>  			spin_lock(&ctx->slock);
> +			ctx->dma_act = true;
>  			if (!list_empty(&dma_q->active) &&
>  			    ctx->cur_frm == ctx->next_frm)
>  				cal_schedule_next_buffer(ctx);
> @@ -1711,10 +1726,27 @@ static void cal_stop_streaming(struct vb2_queue *vq)
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
> +
> +	if (dma_act)
> +		ctx_err(ctx, "failed to disable dma cleanly\n");
> +
>  	disable_irqs(ctx);
>  	csi2_phy_deinit(ctx);
>  
> 

Benoit
