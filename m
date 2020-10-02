Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364232810F5
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 13:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbgJBLIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 07:08:48 -0400
Received: from foss.arm.com ([217.140.110.172]:60778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgJBLIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 07:08:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA5171063;
        Fri,  2 Oct 2020 04:08:31 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1F3F3F73B;
        Fri,  2 Oct 2020 04:08:30 -0700 (PDT)
Subject: Re: [PATCH v2] drm/panfrost: Fix job timeout handling
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201002071032.1225267-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <3cd377c1-4456-eb60-8da5-d44e398697b7@arm.com>
Date:   Fri, 2 Oct 2020 12:08:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002071032.1225267-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/10/2020 08:10, Boris Brezillon wrote:
> If more than two jobs end up timeout-ing concurrently, only one of them
> (the one attached to the scheduler acquiring the lock) is fully handled.
> The other one remains in a dangling state where it's no longer part of
> the scheduling queue, but still blocks something in scheduler, leading
> to repetitive timeouts when new jobs are queued.
> 
> Let's make sure all bad jobs are properly handled by the thread
> acquiring the lock.
> 
> v2:
> - Fix the subject prefix
> - Stop the scheduler before returning from panfrost_job_timedout()
> - Call cancel_delayed_work_sync() after drm_sched_stop() to make sure
>    no timeout handlers are in flight when we reset the GPU (Steven Price)
> - Make sure we release the reset lock before restarting the
>    schedulers (Steven Price)
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>

LGTM!

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   drivers/gpu/drm/panfrost/panfrost_job.c | 64 +++++++++++++++++++++----
>   1 file changed, 55 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 30e7b7196dab..6e4bfb938fab 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -25,7 +25,8 @@
>   
>   struct panfrost_queue_state {
>   	struct drm_gpu_scheduler sched;
> -
> +	bool stopped;
> +	struct mutex lock;
>   	u64 fence_context;
>   	u64 emit_seqno;
>   };
> @@ -369,6 +370,24 @@ void panfrost_job_enable_interrupts(struct panfrost_device *pfdev)
>   	job_write(pfdev, JOB_INT_MASK, irq_mask);
>   }
>   
> +static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
> +				    struct drm_sched_job *bad)
> +{
> +	bool stopped = false;
> +
> +	mutex_lock(&queue->lock);
> +	if (!queue->stopped) {
> +		drm_sched_stop(&queue->sched, bad);
> +		if (bad)
> +			drm_sched_increase_karma(bad);
> +		queue->stopped = true;
> +		stopped = true;
> +	}
> +	mutex_unlock(&queue->lock);
> +
> +	return stopped;
> +}
> +
>   static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>   {
>   	struct panfrost_job *job = to_panfrost_job(sched_job);
> @@ -392,19 +411,41 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>   		job_read(pfdev, JS_TAIL_LO(js)),
>   		sched_job);
>   
> +	/* Scheduler is already stopped, nothing to do. */
> +	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
> +		return;
> +
>   	if (!mutex_trylock(&pfdev->reset_lock))
>   		return;
>   
> +	mutex_lock(&pfdev->sched_lock);
>   	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>   		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
>   
> -		drm_sched_stop(sched, sched_job);
> -		if (js != i)
> -			/* Ensure any timeouts on other slots have finished */
> +		/*
> +		 * If the queue is still active, make sure we wait for any
> +		 * pending timeouts.
> +		 */
> +		if (!pfdev->js->queue[i].stopped)
>   			cancel_delayed_work_sync(&sched->work_tdr);
> -	}
>   
> -	drm_sched_increase_karma(sched_job);
> +		/*
> +		 * If the scheduler was not already stopped, there's a tiny
> +		 * chance a timeout has expired just before we stopped it, and
> +		 * drm_sched_stop() does not flush pending works. Let's flush
> +		 * them now so the timeout handler doesn't get called in the
> +		 * middle of a reset.
> +		 */
> +		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
> +			cancel_delayed_work_sync(&sched->work_tdr);
> +
> +		/*
> +		 * Now that we cancelled the pending timeouts, we can safely
> +		 * reset the stopped state.
> +		 */
> +		pfdev->js->queue[i].stopped = false;
> +	}
> +	mutex_unlock(&pfdev->sched_lock);
>   
>   	spin_lock_irqsave(&pfdev->js->job_lock, flags);
>   	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> @@ -421,11 +462,11 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>   	for (i = 0; i < NUM_JOB_SLOTS; i++)
>   		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
>   
> +	mutex_unlock(&pfdev->reset_lock);
> +
>   	/* restart scheduler after GPU is usable again */
>   	for (i = 0; i < NUM_JOB_SLOTS; i++)
>   		drm_sched_start(&pfdev->js->queue[i].sched, true);
> -
> -	mutex_unlock(&pfdev->reset_lock);
>   }
>   
>   static const struct drm_sched_backend_ops panfrost_sched_ops = {
> @@ -558,6 +599,7 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
>   	int ret, i;
>   
>   	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> +		mutex_init(&js->queue[i].lock);
>   		sched = &js->queue[i].sched;
>   		ret = drm_sched_entity_init(&panfrost_priv->sched_entity[i],
>   					    DRM_SCHED_PRIORITY_NORMAL, &sched,
> @@ -570,10 +612,14 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
>   
>   void panfrost_job_close(struct panfrost_file_priv *panfrost_priv)
>   {
> +	struct panfrost_device *pfdev = panfrost_priv->pfdev;
> +	struct panfrost_job_slot *js = pfdev->js;
>   	int i;
>   
> -	for (i = 0; i < NUM_JOB_SLOTS; i++)
> +	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>   		drm_sched_entity_destroy(&panfrost_priv->sched_entity[i]);
> +		mutex_destroy(&js->queue[i].lock);
> +	}
>   }
>   
>   int panfrost_job_is_idle(struct panfrost_device *pfdev)
> 

