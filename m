Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06142A7FAC
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgKEN1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 08:27:14 -0500
Received: from foss.arm.com ([217.140.110.172]:60864 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbgKEN1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 08:27:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1697214BF;
        Thu,  5 Nov 2020 05:27:12 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF97C3F719;
        Thu,  5 Nov 2020 05:27:10 -0800 (PST)
Subject: Re: [PATCH v4] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
References: <20201104170729.1828212-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <d59e4750-ad1a-5573-16db-ad9b57b6eec5@arm.com>
Date:   Thu, 5 Nov 2020 13:27:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201104170729.1828212-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/11/2020 17:07, Boris Brezillon wrote:
> We've fixed many races in panfrost_job_timedout() but some remain.
> Instead of trying to fix it again, let's simplify the logic and move
> the reset bits to a separate work scheduled when one of the queue
> reports a timeout.
> 
> v4:
> - Rework the logic to prevent a race between drm_sched_start()
>    (reset work) and drm_sched_job_timedout() (timeout work)
> - Drop Steven's R-b
> - Add dma_fence annotation to the panfrost_reset() function (Daniel Vetter)
> 
> v3:
> - Replace the atomic_cmpxchg() by an atomic_xchg() (Robin Murphy)
> - Add Steven's R-b
> 
> v2:
> - Use atomic_cmpxchg() to conditionally schedule the reset work (Steven Price)
> 
> Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Hi Boris,

A couple of nits below, but otherwise looks good.

> ---
>   drivers/gpu/drm/panfrost/panfrost_device.c |   1 -
>   drivers/gpu/drm/panfrost/panfrost_device.h |   6 +-
>   drivers/gpu/drm/panfrost/panfrost_job.c    | 190 ++++++++++++++-------
>   3 files changed, 133 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
> index 1daf9322954a..fbcf5edbe367 100644
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
> index e75b7d2192f7..643d26854b46 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -20,12 +20,21 @@
>   #include "panfrost_gpu.h"
>   #include "panfrost_mmu.h"
>   
> +#define JOB_TIMEOUT_MS 500
> +
>   #define job_write(dev, reg, data) writel(data, dev->iomem + (reg))
>   #define job_read(dev, reg) readl(dev->iomem + (reg))
>   
> +enum panfrost_queue_status {
> +	PANFROST_QUEUE_STATUS_ACTIVE,
> +	PANFROST_QUEUE_STATUS_STOPPED,
> +	PANFROST_QUEUE_STATUS_STARTING,
> +	PANFROST_QUEUE_STATUS_FAULT_PENDING,
> +};
> +
>   struct panfrost_queue_state {
>   	struct drm_gpu_scheduler sched;
> -	bool stopped;
> +	atomic_t status;
>   	struct mutex lock;
>   	u64 fence_context;
>   	u64 emit_seqno;
> @@ -373,28 +382,64 @@ void panfrost_job_enable_interrupts(struct panfrost_device *pfdev)
>   static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
>   				    struct drm_sched_job *bad)
>   {
> +	enum panfrost_queue_status old_status;
>   	bool stopped = false;
>   
>   	mutex_lock(&queue->lock);
> -	if (!queue->stopped) {
> -		drm_sched_stop(&queue->sched, bad);
> -		if (bad)
> -			drm_sched_increase_karma(bad);
> -		queue->stopped = true;
> -		stopped = true;
> -	}
> +	old_status = atomic_xchg(&queue->status,
> +				 PANFROST_QUEUE_STATUS_STOPPED);
> +	WARN_ON(old_status != PANFROST_QUEUE_STATUS_ACTIVE &&
> +		old_status != PANFROST_QUEUE_STATUS_STOPPED);
> +	if (old_status == PANFROST_QUEUE_STATUS_STOPPED)
> +		goto out;

NIT: It's slightly cleaner if you swap the above lines, i.e.:

	if (old_status == PANFROST_QUEUE_STATUS_STOPPED)
		goto out;
	WARN_ON(old_status != PANFROST_QUEUE_STATUS_ACTIVE);

> +
> +	drm_sched_stop(&queue->sched, bad);
> +	if (bad)
> +		drm_sched_increase_karma(bad);
> +
> +	stopped = true;
> +
> +	/*
> +	 * Set the timeout to max so the timer doesn't get started
> +	 * when we return from the timeout handler (restored in
> +	 * panfrost_scheduler_start()).
> +	 */
> +	queue->sched.timeout = MAX_SCHEDULE_TIMEOUT;
> +
> +out:
>   	mutex_unlock(&queue->lock);
>   
>   	return stopped;
>   }
>   
> +static void panfrost_scheduler_start(struct panfrost_queue_state *queue)
> +{
> +	enum panfrost_queue_status old_status;
> +
> +	mutex_lock(&queue->lock);
> +	old_status = atomic_xchg(&queue->status,
> +				 PANFROST_QUEUE_STATUS_STARTING);
> +	if (WARN_ON(old_status != PANFROST_QUEUE_STATUS_STOPPED))
> +		goto out;

The error handling isn't great here - in this case the queue status is 
left in _STATUS_STARTING, which at best would lead to another WARN_ON 
being hit, but also has the effect of ignoring job faults. Probably the 
timeout would eventually get things back to normal.

Obviously this situation will never occur™, but we can do better either 
by continuing with the normal logic below, or even better replacing 
atomic_xchg() with an atomic_cmpxchg() (so leave the status alone if not 
_STOPPED). Both seem like better error recovery options to me. But keep 
the WARN_ON because something has clearly gone wrong if this happens.

Thanks,

Steve

> +
> +	/* Restore the original timeout before starting the scheduler. */
> +	queue->sched.timeout = msecs_to_jiffies(JOB_TIMEOUT_MS);
> +	drm_sched_resubmit_jobs(&queue->sched);
> +	drm_sched_start(&queue->sched, true);
> +	old_status = atomic_xchg(&queue->status,
> +				 PANFROST_QUEUE_STATUS_ACTIVE);
> +	if (old_status == PANFROST_QUEUE_STATUS_FAULT_PENDING)
> +		drm_sched_fault(&queue->sched);
> +
> +out:
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
> @@ -415,56 +460,9 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
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
> +	if (!atomic_xchg(&pfdev->reset.pending, 1))
> +		schedule_work(&pfdev->reset.work);
>   }
>   
>   static const struct drm_sched_backend_ops panfrost_sched_ops = {
> @@ -496,6 +494,8 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>   		job_write(pfdev, JOB_INT_CLEAR, mask);
>   
>   		if (status & JOB_INT_MASK_ERR(j)) {
> +			enum panfrost_queue_status old_status;
> +
>   			job_write(pfdev, JS_COMMAND_NEXT(j), JS_COMMAND_NOP);
>   
>   			dev_err(pfdev->dev, "js fault, js=%d, status=%s, head=0x%x, tail=0x%x",
> @@ -504,7 +504,18 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>   				job_read(pfdev, JS_HEAD_LO(j)),
>   				job_read(pfdev, JS_TAIL_LO(j)));
>   
> -			drm_sched_fault(&pfdev->js->queue[j].sched);
> +			/*
> +			 * When the queue is being restarted we don't report
> +			 * faults directly to avoid races between the timeout
> +			 * and reset handlers. panfrost_scheduler_start() will
> +			 * call drm_sched_fault() after the queue has been
> +			 * started if status == FAULT_PENDING.
> +			 */
> +			old_status = atomic_cmpxchg(&pfdev->js->queue[j].status,
> +						    PANFROST_QUEUE_STATUS_STARTING,
> +						    PANFROST_QUEUE_STATUS_FAULT_PENDING);
> +			if (old_status == PANFROST_QUEUE_STATUS_ACTIVE)
> +				drm_sched_fault(&pfdev->js->queue[j].sched);
>   		}
>   
>   		if (status & JOB_INT_MASK_DONE(j)) {
> @@ -531,11 +542,66 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
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
> +	bool cookie;
> +
> +	cookie = dma_fence_begin_signalling();
> +	for (i = 0; i < NUM_JOB_SLOTS; i++) {
> +		/*
> +		 * We want pending timeouts to be handled before we attempt
> +		 * to stop the scheduler. If we don't do that and the timeout
> +		 * handler is in flight, it might have removed the bad job
> +		 * from the list, and we'll lose this job if the reset handler
> +		 * enters the critical section in panfrost_scheduler_stop()
> +		 * before the timeout handler.
> +		 *
> +		 * Timeout is set to MAX_SCHEDULE_TIMEOUT - 1 because we need
> +		 * something big enough to make sure the timer will not expire
> +		 * before we manage to stop the scheduler, but we can't use
> +		 * MAX_SCHEDULE_TIMEOUT because drm_sched_get_cleanup_job()
> +		 * considers that as 'timer is not running' and will dequeue
> +		 * the job without making sure the timeout handler is not
> +		 * running.
> +		 */
> +		pfdev->js->queue[i].sched.timeout = MAX_SCHEDULE_TIMEOUT - 1;
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
> +	for (i = 0; i < NUM_JOB_SLOTS; i++)
> +		panfrost_scheduler_start(&pfdev->js->queue[i]);
> +
> +	dma_fence_end_signalling(cookie);
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
> @@ -560,7 +626,7 @@ int panfrost_job_init(struct panfrost_device *pfdev)
>   
>   		ret = drm_sched_init(&js->queue[j].sched,
>   				     &panfrost_sched_ops,
> -				     1, 0, msecs_to_jiffies(500),
> +				     1, 0, msecs_to_jiffies(JOB_TIMEOUT_MS),
>   				     "pan_js");
>   		if (ret) {
>   			dev_err(pfdev->dev, "Failed to create scheduler: %d.", ret);
> 

