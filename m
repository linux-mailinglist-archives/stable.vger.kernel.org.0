Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C362A039A
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 12:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgJ3LCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 07:02:41 -0400
Received: from foss.arm.com ([217.140.110.172]:59828 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgJ3LCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 07:02:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B43E139F;
        Fri, 30 Oct 2020 04:02:39 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D2B23F719;
        Fri, 30 Oct 2020 04:02:38 -0700 (PDT)
Subject: Re: [PATCH] drm/panfrost: Move the GPU reset bits outside the timeout
 handler
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201030070826.582969-1-boris.brezillon@collabora.com>
 <8185209b-b943-c1b8-90d8-fee894f6f829@arm.com>
 <20201030112826.1b182709@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <83cc9b88-18ae-ee38-670e-505d3103b64d@arm.com>
Date:   Fri, 30 Oct 2020 11:02:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030112826.1b182709@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/10/2020 10:28, Boris Brezillon wrote:
> On Fri, 30 Oct 2020 10:00:07 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 30/10/2020 07:08, Boris Brezillon wrote:
>>> We've fixed many races in panfrost_job_timedout() but some remain.
>>> Instead of trying to fix it again, let's simplify the logic and move
>>> the reset bits to a separate work scheduled when one of the queue
>>> reports a timeout.
>>>
>>> Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
>>> ---
>>>    drivers/gpu/drm/panfrost/panfrost_device.c |   1 -
>>>    drivers/gpu/drm/panfrost/panfrost_device.h |   6 +-
>>>    drivers/gpu/drm/panfrost/panfrost_job.c    | 130 ++++++++++++---------
>>>    3 files changed, 82 insertions(+), 55 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
>>> index ea8d31863c50..a83b2ff5837a 100644
>>> --- a/drivers/gpu/drm/panfrost/panfrost_device.c
>>> +++ b/drivers/gpu/drm/panfrost/panfrost_device.c
>>> @@ -200,7 +200,6 @@ int panfrost_device_init(struct panfrost_device *pfdev)
>>>    	struct resource *res;
>>>    
>>>    	mutex_init(&pfdev->sched_lock);
>>> -	mutex_init(&pfdev->reset_lock);
>>>    	INIT_LIST_HEAD(&pfdev->scheduled_jobs);
>>>    	INIT_LIST_HEAD(&pfdev->as_lru_list);
>>>    
>>> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
>>> index 2e9cbd1c4a58..67f9f66904be 100644
>>> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
>>> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
>>> @@ -105,7 +105,11 @@ struct panfrost_device {
>>>    	struct panfrost_perfcnt *perfcnt;
>>>    
>>>    	struct mutex sched_lock;
>>> -	struct mutex reset_lock;
>>> +
>>> +	struct {
>>> +		struct work_struct work;
>>> +		atomic_t pending;
>>> +	} reset;
>>>    
>>>    	struct mutex shrinker_lock;
>>>    	struct list_head shrinker_list;
>>> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
>>> index d0469e944143..745ee9563a54 100644
>>> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
>>> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
>>> @@ -20,6 +20,8 @@
>>>    #include "panfrost_gpu.h"
>>>    #include "panfrost_mmu.h"
>>>    
>>> +#define JOB_TIMEOUT_MS 500
>>> +
>>>    #define job_write(dev, reg, data) writel(data, dev->iomem + (reg))
>>>    #define job_read(dev, reg) readl(dev->iomem + (reg))
>>>    
>>> @@ -382,19 +384,37 @@ static bool panfrost_scheduler_stop(struct panfrost_queue_state *queue,
>>>    			drm_sched_increase_karma(bad);
>>>    		queue->stopped = true;
>>>    		stopped = true;
>>> +
>>> +		/*
>>> +		 * Set the timeout to max so the timer doesn't get started
>>> +		 * when we return from the timeout handler (restored in
>>> +		 * panfrost_scheduler_start()).
>>> +		 */
>>> +		queue->sched.timeout = MAX_SCHEDULE_TIMEOUT;
>>>    	}
>>>    	mutex_unlock(&queue->lock);
>>>    
>>>    	return stopped;
>>>    }
>>>    
>>> +static void panfrost_scheduler_start(struct panfrost_queue_state *queue)
>>> +{
>>> +	if (WARN_ON(!queue->stopped))
>>> +		return;
>>> +
>>> +	mutex_lock(&queue->lock);
>>> +	/* Restore the original timeout before starting the scheduler. */
>>> +	queue->sched.timeout = msecs_to_jiffies(JOB_TIMEOUT_MS);
>>> +	drm_sched_start(&queue->sched, true);
>>> +	queue->stopped = false;
>>> +	mutex_unlock(&queue->lock);
>>> +}
>>> +
>>>    static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>>>    {
>>>    	struct panfrost_job *job = to_panfrost_job(sched_job);
>>>    	struct panfrost_device *pfdev = job->pfdev;
>>>    	int js = panfrost_job_get_slot(job);
>>> -	unsigned long flags;
>>> -	int i;
>>>    
>>>    	/*
>>>    	 * If the GPU managed to complete this jobs fence, the timeout is
>>> @@ -415,56 +435,9 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>>>    	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
>>>    		return;
>>>    
>>> -	if (!mutex_trylock(&pfdev->reset_lock))
>>> -		return;
>>> -
>>> -	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>>> -		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
>>> -
>>> -		/*
>>> -		 * If the queue is still active, make sure we wait for any
>>> -		 * pending timeouts.
>>> -		 */
>>> -		if (!pfdev->js->queue[i].stopped)
>>> -			cancel_delayed_work_sync(&sched->work_tdr);
>>> -
>>> -		/*
>>> -		 * If the scheduler was not already stopped, there's a tiny
>>> -		 * chance a timeout has expired just before we stopped it, and
>>> -		 * drm_sched_stop() does not flush pending works. Let's flush
>>> -		 * them now so the timeout handler doesn't get called in the
>>> -		 * middle of a reset.
>>> -		 */
>>> -		if (panfrost_scheduler_stop(&pfdev->js->queue[i], NULL))
>>> -			cancel_delayed_work_sync(&sched->work_tdr);
>>> -
>>> -		/*
>>> -		 * Now that we cancelled the pending timeouts, we can safely
>>> -		 * reset the stopped state.
>>> -		 */
>>> -		pfdev->js->queue[i].stopped = false;
>>> -	}
>>> -
>>> -	spin_lock_irqsave(&pfdev->js->job_lock, flags);
>>> -	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>>> -		if (pfdev->jobs[i]) {
>>> -			pm_runtime_put_noidle(pfdev->dev);
>>> -			panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
>>> -			pfdev->jobs[i] = NULL;
>>> -		}
>>> -	}
>>> -	spin_unlock_irqrestore(&pfdev->js->job_lock, flags);
>>> -
>>> -	panfrost_device_reset(pfdev);
>>> -
>>> -	for (i = 0; i < NUM_JOB_SLOTS; i++)
>>> -		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
>>> -
>>> -	mutex_unlock(&pfdev->reset_lock);
>>> -
>>> -	/* restart scheduler after GPU is usable again */
>>> -	for (i = 0; i < NUM_JOB_SLOTS; i++)
>>> -		drm_sched_start(&pfdev->js->queue[i].sched, true);
>>> +	/* Schedule a reset. */
>>> +	atomic_set(&pfdev->reset.pending, 1);
>>
>> Maybe I'm missing something, but I can't work out what setting
>> reset.pending here gives us. See below.
>>
>>> +	schedule_work(&pfdev->reset.work);
>>>    }
>>>    
>>>    static const struct drm_sched_backend_ops panfrost_sched_ops = {
>>> @@ -531,11 +504,62 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>>>    	return IRQ_HANDLED;
>>>    }
>>>    
>>> +static void panfrost_reset(struct work_struct *work)
>>> +{
>>> +	struct panfrost_device *pfdev = container_of(work,
>>> +						     struct panfrost_device,
>>> +						     reset.work);
>>> +	unsigned long flags;
>>> +	unsigned int i;
>>> +
>>> +	if (!atomic_read(&pfdev->reset.pending))
>>> +		return;
>>
>> AFAICT the only time this return will be hit is in the following case:
>>
>> CPU 0                     |  CPU 1
>> --------------------------+-------------------
>> job_timedout()            |
>> panfrost_reset()          |
>>    ...                      | job_timedout()
>>    - atomic_set(pending, 0) | ...
>>                             | if (!atomic_read()) - returns early
> 
> AFAICT a work can only be scheduled on one workqueue, IOW, it can't run
> on 2 CPUs simultaneously, and your example seems to imply that it can
> (both 'atomic_set(pending, 0)' and 'if (!atomic_read()) - returns
> early' are done in the reset handler).

Ah, I knew I was missing something! You're right, by default a work 
cannot simulatenously run on two CPUs.

>>
>> However, reordering that a little we can see it can fail:
>>
>> CPU 0                     |  CPU 1
>> --------------------------+-------------------
>> job_timedout()            |
>>    ...                      |
>> panfrost_reset()          |
>>    ...                      | job_timedout()
>>    ...                      | panfrost_reset()
>>    ...                      | if (atomic_read()) - doesn't return early
>>    - atomic_set(pending, 0) | ...
>>
>> I don't see anything which prevents the second scenario, so this pending
>> flag doesn't seem to be stopping any race condition.
>>
>> What am I missing?
> 
> The pending state is just here to overcome the lack of cancel_work():
> if we schedule a reset while the reset handler is running, this handler
> will be called again just after it returns, but we only need to reset
> the GPU again if the timeout handler scheduled the reset work after the
> GPU has been reset and queues have been restarted.

Got it.

>>
>> I would have expected something more along the lines of:
>>
>> 	/* Schedule a reset */
>> 	if (atomic_cmpxchg(&pfdev->reset.pending, 0, 1)) {
>> 		/* Reset already in progress */
>> 		return;
>> 	}
>> 	schedule_work(&pfdev->reset.work);
>>
>> What do you think?
> 
> That would work too, and allows us to get rid of the atomic_read() in
> the reset handler. I'll go for this version. This being said, I'm pretty
> sure my version was safe too ;-).

Yes, I think you're right. Somehow I'd got it into my head that it must 
be a race between CPUs in the reset worker that you were trying to solve.

>>
>> Also FYI I applied this on top of my panfrost-dev branch and managed to
>> hit the following splat. I haven't yet got to the bottom of it, so it
>> might well be an unrelated bug. At first glance this looks like the job
>> is managing to outlive the MMU context it's tied to.
> 
> Hm, I think I don't see those because I have "drm/panfrost: Make sure
> MMU context lifetime is not bound to panfrost_priv" applied. We should
> really work on a proper fix for that problem, or maybe apply the
> proposed fix until we have time to work on a better solution.

Yes, a bit of investigation showed that my hack for the same problem was 
tripped up by the deferring of the reset onto a workqueue. So the 
problem was just that my hack wasn't complete.

As I see it there are basically two options: extend the MMU context 
lifetime (see your fix above) or block the close of a scheduler entity 
until all it's jobs have finished (see [1] for my hackish attempt).

I'm somewhat puzzled how other drivers handle this safely. Killing off 
the jobs before closing the context seems logical, but the DRM scheduler 
doesn't seem to provide support for that. Extending the MMU context 
lifetime works, but has the unfortunate side-effect of keeping zombie 
jobs running for a short while after the process owning them has gone.

Steve

[1] 
https://gitlab.arm.com/linux-arm/linux-sp/-/commit/0bb29aaad61a9fb39d1f4efc555965376615d9bf
