Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9A1868FE
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgCPK2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 06:28:38 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:34910 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgCPK2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 06:28:38 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4A122A3B;
        Mon, 16 Mar 2020 11:28:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1584354515;
        bh=Gy0jFxAgSgBVXWYXnVTZRRzHj1Q2FLsea2SAuGyRbGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8JTeTh05Y0GLTow0DIEhbxtVkpE9BEPHTU/5KNs2CjbMiqPX0VPAoq51dGQ+j+hP
         qehXN8mIDk75CMTp83EPKtmZRees+AGWLOLumrTsBZE0OOKc8j9RhSTSDQmVMsZ874
         Ut2CfblNOTL3ehRYHadrV5R8r7Cwh7iy78DwrSas=
Date:   Mon, 16 Mar 2020 12:28:30 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: ti-vpe: cal: fix DMA memory corruption
Message-ID: <20200316102830.GT4732@pendragon.ideasonboard.com>
References: <20200313082639.7743-1-tomi.valkeinen@ti.com>
 <20200313140311.GF4751@pendragon.ideasonboard.com>
 <79e87213-6648-8056-1db5-718ed3963ed3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <79e87213-6648-8056-1db5-718ed3963ed3@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi,

On Fri, Mar 13, 2020 at 04:18:13PM +0200, Tomi Valkeinen wrote:
> On 13/03/2020 16:03, Laurent Pinchart wrote:
> 
> >> +	/* wait for stream and dma to finish */
> >> +	dma_act = true;
> >> +	timeout = jiffies + msecs_to_jiffies(500);
> >> +	while (dma_act && time_before(jiffies, timeout)) {
> >> +		msleep(50);
> >> +
> >> +		spin_lock_irqsave(&ctx->slock, flags);
> >> +		dma_act = ctx->dma_act;
> >> +		spin_unlock_irqrestore(&ctx->slock, flags);
> >> +	}
> > 
> > Waiting for the transfer to complete seems to be a good idea, but how
> > about using a wait queue instead of such a loop ? That would allow
> > better usage of CPU time and faster reaction time, and shouldn't be
> > difficult to implement. You may also want to replace dma_act with a
> > state if needed (in case you need to express running/stopping/stopped
> > states), and I would rename it to running if you just need a boolean.
> 
> Maybe, but I wasn't sure how to implement it safely.
> 
> So, when we call csi2_ppi_disable() (just above the wait code above), the HW will stop the DMA after 
> the next frame has ended.
> 
> But there's no way to know in the irq handler if the DMA transfer that just ended was the last one 
> or not. And I don't see how I could set a "disabling" flag before calling csi2_ppi_disable(), as I 
> think that would always be racy with the irq handler.
> 
> So I went with a safe way: call csi2_ppi_disable(), then wait a bit so that we are sure that either 
> 1) the last frame is on going 2) the last frame has finished (instead of the previous-to-last frame 
> is on going or finished). Then see if the DMA is active. If yes, we loop for it to end.
> 
> I think the loop could be replaced with a wait queue, but we still need the initial sleep to ensure 
> we don't end the wait when the previous-to-last frame DMA has been finished.

I think you can solve this by introducing a new enum state field with
RUNNING, STOPPING and STOPPED values, protected by a spinlock. Here's
what I have in the VSP1 driver for instance:

bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe)
{
	unsigned long flags;
	bool stopped;

	spin_lock_irqsave(&pipe->irqlock, flags);
	stopped = pipe->state == VSP1_PIPELINE_STOPPED;
	spin_unlock_irqrestore(&pipe->irqlock, flags);

	return stopped;
}

int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
{
	...
	spin_lock_irqsave(&pipe->irqlock, flags);
	if (pipe->state == VSP1_PIPELINE_RUNNING)
		pipe->state = VSP1_PIPELINE_STOPPING;
	spin_unlock_irqrestore(&pipe->irqlock, flags);

	ret = wait_event_timeout(pipe->wq, vsp1_pipeline_stopped(pipe),
				 msecs_to_jiffies(500));
	ret = ret == 0 ? -ETIMEDOUT : 0;
	...
}

and in the interrupt handler:

	state = pipe->state;
	pipe->state = VSP1_PIPELINE_STOPPED;

	/*
	 * If a stop has been requested, mark the pipeline as stopped and
	 * return. Otherwise restart the pipeline if ready.
	 */
	if (state == VSP1_PIPELINE_STOPPING)
		wake_up(&pipe->wq);
	else if (vsp1_pipeline_ready(pipe))
		vsp1_video_pipeline_run(pipe);

-- 
Regards,

Laurent Pinchart
