Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD02A03BD
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 12:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgJ3LKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 07:10:24 -0400
Received: from foss.arm.com ([217.140.110.172]:59974 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3LKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 07:10:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D298139F;
        Fri, 30 Oct 2020 04:10:23 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 497013F719;
        Fri, 30 Oct 2020 04:10:22 -0700 (PDT)
Subject: Re: [PATCH v2] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201030105336.764009-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ac3a8649-a7de-0eb0-0fb5-cbef9c710c76@arm.com>
Date:   Fri, 30 Oct 2020 11:10:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030105336.764009-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/10/2020 10:53, Boris Brezillon wrote:
> We've fixed many races in panfrost_job_timedout() but some remain.
> Instead of trying to fix it again, let's simplify the logic and move
> the reset bits to a separate work scheduled when one of the queue
> reports a timeout.
> 
> v2:
> - Use atomic_cmpxchg() to conditionally schedule the reset work (Steven Privce)
> 
> Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

LGTM!

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   drivers/gpu/drm/panfrost/panfrost_device.c |   1 -
>   drivers/gpu/drm/panfrost/panfrost_device.h |   6 +-
>   drivers/gpu/drm/panfrost/panfrost_job.c    | 127 ++++++++++++---------
>   3 files changed, 79 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
> index ea8d31863c50..a83b2ff5837a 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.c
> @@ -200,7 +200,6 @@ int panfrost_device_init(struct panfrost_device *pfdev)
>   	struct resource *res;
>   
>   	mutex_init(&pfdev->sched_lock);
> -	mutex_init(&pfdev->reset_lock);
>   	INIT_LIST_HEAD(&pfdev->scheduled_jobs);
>   	INIT_LIST_HEAD(&pfdev->as_lru_list);
>   
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
> index 140e004a3790..597cf1459b0a 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -106,7 +106,11 @@ struct panfrost_device {
>   	struct panfrost_perfcnt *perfcnt;
>   
>   	struct mutex sched_lock;
> -	struct mutex reset_lock;
> +
> +	struct {
> +		struct work_struct work;
> +		atomic_t pending;
> +	} reset;
>   
>   	struct mutex shrinker_lock;
>   	struct list_head shrinker_list;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 4902bc6624c8..14c11293791e 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -20,6 +20,8 @@
>   #include "panfrost_gpu.h"
>   #include "panfrost_mmu.h"
>   
> +#define JOB_TIMEOUT_MS 500
> +
>   #define job_write(dev, reg, data) writel(data, dev->iomem + (reg))
>   #define job_read(dev, reg) readl(dev->iomem + (reg))
>   
> @@ -382,19 +384,37 @@ static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
>   			drm_sched_increase_karma(bad);
>   		queue->stopped = true;
>   		stopped = true;
> +
> +		/*
> +		 * Set the timeout to max so the timer doesn't get started
> +		 * when we return from the timeout handler (restored in
> +		 * panfrost_scheduler_start()).
> +		 */
> +		queue->sched.timeout = MAX_SCHEDULE_TIMEOUT;
>   	}
>   	mutex_unlock(&queue->lock);
>   
>   	return stopped;
>   }
>   
> +static void panfrost_scheduler_start(struct panfrost_queue_state *queue)
> +{
> +	if (WARN_ON(!queue->stopped))
> +		return;
> +
> +	mutex_lock(&queue->lock);
> +	/* Restore the original timeout before starting the scheduler. */
> +	queue->sched.timeout = msecs_to_jiffies(JOB_TIMEOUT_MS);
> +	drm_sched_start(&queue->sched, true);
> +	queue->stopped = false;
> +	mutex_unlock(&queue->lock);
> +}
> +
>   static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>   {
>   	struct panfrost_job *job = to_panfrost_job(sched_job);
>   	struct panfrost_device *pfdev = job->pfdev;
>   	int js = panfrost_job_get_slot(job);
> -	unsigned long flags;
> -	int i;
>   
>   	/*
>   	 * If the GPU managed to complete this jobs fence, the timeout is
> @@ -415,56 +435,9 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>   	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
>   		return;
>   
> -	if (!mutex_trylock(&pfdev->reset_lock))
> -		return;
> -
> -	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> -		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
> -
> -		/*
> -		 * If the queue is still active, make sure we wait for any
> -		 * pending timeouts.
> -		 */
> -		if (!pfdev->js->queue[i].stopped)
> -			cancel_delayed_work_sync(&sched->work_tdr);
> -
> -		/*
> -		 * If the scheduler was not already stopped, there's a tiny
> -		 * chance a timeout has expired just before we stopped it, and
> -		 * drm_sched_stop() does not flush pending works. Let's flush
> -		 * them now so the timeout handler doesn't get called in the
> -		 * middle of a reset.
> -		 */
> -		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
> -			cancel_delayed_work_sync(&sched->work_tdr);
> -
> -		/*
> -		 * Now that we cancelled the pending timeouts, we can safely
> -		 * reset the stopped state.
> -		 */
> -		pfdev->js->queue[i].stopped = false;
> -	}
> -
> -	spin_lock_irqsave(&pfdev->js->job_lock, flags);
> -	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> -		if (pfdev->jobs[i]) {
> -			pm_runtime_put_noidle(pfdev->dev);
> -			panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
> -			pfdev->jobs[i] = NULL;
> -		}
> -	}
> -	spin_unlock_irqrestore(&pfdev->js->job_lock, flags);
> -
> -	panfrost_device_reset(pfdev);
> -
> -	for (i = 0; i < NUM_JOB_SLOTS; i++)
> -		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
> -
> -	mutex_unlock(&pfdev->reset_lock);
> -
> -	/* restart scheduler after GPU is usable again */
> -	for (i = 0; i < NUM_JOB_SLOTS; i++)
> -		drm_sched_start(&pfdev->js->queue[i].sched, true);
> +	/* Schedule a reset if there's no reset in progress. */
> +	if (!atomic_cmpxchg(&pfdev->reset.pending, 0, 1))
> +		schedule_work(&pfdev->reset.work);
>   }
>   
>   static const struct drm_sched_backend_ops panfrost_sched_ops = {
> @@ -531,11 +504,59 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>   	return IRQ_HANDLED;
>   }
>   
> +static void panfrost_reset(struct work_struct *work)
> +{
> +	struct panfrost_device *pfdev = container_of(work,
> +						     struct panfrost_device,
> +						     reset.work);
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> +		/*
> +		 * We want pending timeouts to be handled before we attempt
> +		 * to stop the scheduler. If we don't do that and the timeout
> +		 * handler is in flight, it might have removed the bad job
> +		 * from the list, and we'll lose this job if the reset handler
> +		 * enters the critical section in panfrost_scheduler_stop()
> +		 * before the timeout handler.
> +		 *
> +		 * Timeout is set to max to make sure the timer is not
> +		 * restarted after the cancellation.
> +		 */
> +		pfdev->js->queue[i].sched.timeout = MAX_SCHEDULE_TIMEOUT;
> +		cancel_delayed_work_sync(&pfdev->js->queue[i].sched.work_tdr);
> +		panfrost_scheduler_stop(&pfdev->js->queue[i], NULL);
> +	}
> +
> +	/* All timers have been stopped, we can safely reset the pending state. */
> +	atomic_set(&pfdev->reset.pending, 0);
> +
> +	spin_lock_irqsave(&pfdev->js->job_lock, flags);
> +	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> +		if (pfdev->jobs[i]) {
> +			pm_runtime_put_noidle(pfdev->dev);
> +			panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
> +			pfdev->jobs[i] = NULL;
> +		}
> +	}
> +	spin_unlock_irqrestore(&pfdev->js->job_lock, flags);
> +
> +	panfrost_device_reset(pfdev);
> +
> +	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> +		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
> +		panfrost_scheduler_start(&pfdev->js->queue[i]);
> +	}
> +}
> +
>   int panfrost_job_init(struct panfrost_device *pfdev)
>   {
>   	struct panfrost_job_slot *js;
>   	int ret, j, irq;
>   
> +	INIT_WORK(&pfdev->reset.work, panfrost_reset);
> +
>   	pfdev->js = js = devm_kzalloc(pfdev->dev, sizeof(*js), GFP_KERNEL);
>   	if (!js)
>   		return -ENOMEM;
> @@ -560,7 +581,7 @@ int panfrost_job_init(struct panfrost_device *pfdev)
>   
>   		ret = drm_sched_init(&js->queue[j].sched,
>   				     &panfrost_sched_ops,
> -				     1, 0, msecs_to_jiffies(500),
> +				     1, 0, msecs_to_jiffies(JOB_TIMEOUT_MS),
>   				     "pan_js");
>   		if (ret) {
>   			dev_err(pfdev->dev, "Failed to create scheduler: %d.", ret);
> 

