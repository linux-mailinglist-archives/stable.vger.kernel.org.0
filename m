Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED9D250019
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 16:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHXOrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 10:47:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50209 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726225AbgHXOrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 10:47:51 -0400
Received: (qmail 331659 invoked by uid 1000); 24 Aug 2020 10:47:50 -0400
Date:   Mon, 24 Aug 2020 10:47:50 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200824144750.GC329866@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824030607.19357-1-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 23, 2020 at 08:06:07PM -0700, Bart Van Assche wrote:
> With the current implementation the following race can happen:
> * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
>   blk_mq_unfreeze_queue().
> * blk_queue_enter() calls blk_queue_pm_only() and that function returns
>   true.
> * blk_queue_enter() calls blk_pm_request_resume() and that function does
>   not call pm_request_resume() because the queue runtime status is
>   RPM_ACTIVE.
> * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> 
> Fix this race by changing the queue runtime status into RPM_SUSPENDING
> before switching q_usage_counter to atomic mode.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 986d413b7c15 ("blk-mq: Enable support for runtime power management")
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-pm.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-pm.c b/block/blk-pm.c
> index b85234d758f7..17bd020268d4 100644
> --- a/block/blk-pm.c
> +++ b/block/blk-pm.c
> @@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct request_queue *q)
>  
>  	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
>  
> +	spin_lock_irq(&q->queue_lock);
> +	q->rpm_status = RPM_SUSPENDING;
> +	spin_unlock_irq(&q->queue_lock);
> +
>  	/*
>  	 * Increase the pm_only counter before checking whether any
>  	 * non-PM blk_queue_enter() calls are in progress to avoid that any
> @@ -89,15 +93,14 @@ int blk_pre_runtime_suspend(struct request_queue *q)
>  	/* Switch q_usage_counter back to per-cpu mode. */
>  	blk_mq_unfreeze_queue(q);
>  
> -	spin_lock_irq(&q->queue_lock);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		spin_lock_irq(&q->queue_lock);
> +		q->rpm_status = RPM_ACTIVE;
>  		pm_runtime_mark_last_busy(q->dev);
> -	else
> -		q->rpm_status = RPM_SUSPENDING;
> -	spin_unlock_irq(&q->queue_lock);
> +		spin_unlock_irq(&q->queue_lock);
>  
> -	if (ret)
>  		blk_clear_pm_only(q);
> +	}
>  
>  	return ret;
>  }

Acked-by: Alan Stern <stern@rowland.harvard.edu>
