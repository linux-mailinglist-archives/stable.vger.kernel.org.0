Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A42800D7
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 16:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732339AbgJAODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 10:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732805AbgJAOCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 10:02:52 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67ADC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 07:02:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5F65129C5B5;
        Thu,  1 Oct 2020 15:02:51 +0100 (BST)
Date:   Thu, 1 Oct 2020 16:02:48 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] panfrost: Fix job timeout handling
Message-ID: <20201001160248.4c2e1fee@collabora.com>
In-Reply-To: <20201001140143.1058669-1-boris.brezillon@collabora.com>
References: <20201001140143.1058669-1-boris.brezillon@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oops, the prefix should be "drm/panfrost", will fix that in v2.

On Thu,  1 Oct 2020 16:01:43 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> If more than two or more jobs end up timeout-ing concurrently, only one
> of them (the one attached to the scheduler acquiring the lock) is fully
> handled. The other one remains in a dangling state where it's no longer
> part of the scheduling queue, but still blocks something in scheduler
> thus leading to repetitive timeouts when new jobs are queued.
> 
> Let's make sure all bad jobs are properly handled by the thread acquiring
> the lock.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/gpu/drm/panfrost/panfrost_job.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 30e7b7196dab..e87edca51d84 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -25,7 +25,7 @@
>  
>  struct panfrost_queue_state {
>  	struct drm_gpu_scheduler sched;
> -
> +	struct drm_sched_job *bad;
>  	u64 fence_context;
>  	u64 emit_seqno;
>  };
> @@ -392,19 +392,29 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>  		job_read(pfdev, JS_TAIL_LO(js)),
>  		sched_job);
>  
> +	/*
> +	 * Collect the bad job here so it can be processed by the thread
> +	 * acquiring the reset lock.
> +	 */
> +	pfdev->js->queue[js].bad = sched_job;
> +
>  	if (!mutex_trylock(&pfdev->reset_lock))
>  		return;
>  
>  	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>  		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
>  
> -		drm_sched_stop(sched, sched_job);
>  		if (js != i)
>  			/* Ensure any timeouts on other slots have finished */
>  			cancel_delayed_work_sync(&sched->work_tdr);
> -	}
>  
> -	drm_sched_increase_karma(sched_job);
> +		drm_sched_stop(sched, pfdev->js->queue[i].bad);
> +
> +		if (pfdev->js->queue[i].bad)
> +			drm_sched_increase_karma(pfdev->js->queue[i].bad);
> +
> +		pfdev->js->queue[i].bad = NULL;
> +	}
>  
>  	spin_lock_irqsave(&pfdev->js->job_lock, flags);
>  	for (i = 0; i < NUM_JOB_SLOTS; i++) {

