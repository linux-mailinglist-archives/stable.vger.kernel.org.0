Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F428038B
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgJAQHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:07:00 -0400
Received: from foss.arm.com ([217.140.110.172]:38686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732026AbgJAQGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 12:06:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9AA030E;
        Thu,  1 Oct 2020 09:06:29 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC94A3F70D;
        Thu,  1 Oct 2020 09:06:28 -0700 (PDT)
Subject: Re: [PATCH] panfrost: Fix job timeout handling
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201001140143.1058669-1-boris.brezillon@collabora.com>
 <b51d154f-978d-3439-fbb3-e960378b53c0@arm.com>
 <20201001174931.0ab0746b@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <327ca23d-ba25-caaf-f70e-8ad6b244180c@arm.com>
Date:   Thu, 1 Oct 2020 17:05:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001174931.0ab0746b@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/10/2020 16:49, Boris Brezillon wrote:
> On Thu, 1 Oct 2020 15:49:39 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 01/10/2020 15:01, Boris Brezillon wrote:
>>> If more than two or more jobs end up timeout-ing concurrently, only one
>>> of them (the one attached to the scheduler acquiring the lock) is fully
>>> handled. The other one remains in a dangling state where it's no longer
>>> part of the scheduling queue, but still blocks something in scheduler
>>> thus leading to repetitive timeouts when new jobs are queued.
>>>
>>> Let's make sure all bad jobs are properly handled by the thread acquiring
>>> the lock.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
>>> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    drivers/gpu/drm/panfrost/panfrost_job.c | 18 ++++++++++++++----
>>>    1 file changed, 14 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
>>> index 30e7b7196dab..e87edca51d84 100644
>>> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
>>> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
>>> @@ -25,7 +25,7 @@
>>>    
>>>    struct panfrost_queue_state {
>>>    	struct drm_gpu_scheduler sched;
>>> -
>>> +	struct drm_sched_job *bad;
>>>    	u64 fence_context;
>>>    	u64 emit_seqno;
>>>    };
>>> @@ -392,19 +392,29 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>>>    		job_read(pfdev, JS_TAIL_LO(js)),
>>>    		sched_job);
>>>    
>>> +	/*
>>> +	 * Collect the bad job here so it can be processed by the thread
>>> +	 * acquiring the reset lock.
>>> +	 */
>>> +	pfdev->js->queue[js].bad = sched_job;
>>> +
>>>    	if (!mutex_trylock(&pfdev->reset_lock))
>>>    		return;
>>>    
>>>    	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>>>    		struct drm_gpu_scheduler *sched = &pfdev->js->queue[i].sched;
>>>    
>>> -		drm_sched_stop(sched, sched_job);
>>>    		if (js != i)
>>>    			/* Ensure any timeouts on other slots have finished */
>>>    			cancel_delayed_work_sync(&sched->work_tdr);
>>> -	}
>>>    
>>> -	drm_sched_increase_karma(sched_job);
>>> +		drm_sched_stop(sched, pfdev->js->queue[i].bad);
>>
>> So I can see that the call to drm_sched_stop() needs to move below the
>> cancel_delayed_work_sync() to ensure that the update to queue->bad is
>> synchronised. What I'm not so sure about is whether it's possible for
>> the scheduler to make progress between the 'cancel' and the 'stop' -
>> there is a reason I wrote it the other way round...
> 
> Ok, I think see what you mean now. So, there's indeed a race between
> the cancel_delayed_work_sync() and drm_sched_stop() calls, and a
> timeout might go undetected because of that. This being said, the only
> problem I see is that we would not increase karma on that job. In any
> case the job will be re-queued, and unless we keep having timeouts on
> the other queues it should be detected at some point. I can also try to
> retrieve the deadline before canceling the delayed work and check it
> before stopping the scheduler, but I'm not sure it's worth it.

Yes - well explained, I was trying to write an explanation but you beat 
me to it ;)

However I think it's worse than just the karma - the second timeout of a 
job could take a while to execute and actually execute *after* the first 
timeout has completed. I'm wondering whether we just need something like:

  cancel_delayed_work_sync()
  drm_sched_stop()
  cancel_delayed_work_sync()

that way we ensure that any other timeouts will definitely have 
completed before performing the reset.

There's still a minor race regarding the karma - but that shouldn't 
matter as you mention.

Steve

>>
>> The hole for things to go round is clearly much smaller with this
>> change, but I'm not sure it's completely plugged. Am I missing something?
>>
>>> +
>>> +		if (pfdev->js->queue[i].bad)
>>> +			drm_sched_increase_karma(pfdev->js->queue[i].bad);
>>> +
>>> +		pfdev->js->queue[i].bad = NULL;
>>> +	}
>>>    
>>>    	spin_lock_irqsave(&pfdev->js->job_lock, flags);
>>>    	for (i = 0; i < NUM_JOB_SLOTS; i++) {
>>>    
>>
>> While we're on potential holes... some more context:
>>
>>> 		if (pfdev->jobs[i]) {
>>> 			pm_runtime_put_noidle(pfdev->dev);
>>> 			panfrost_devfreq_record_idle(pfdev);
>>> 			pfdev->jobs[i] = NULL;
>>> 		}
>>> 	}
>>> 	spin_unlock_irqrestore(&pfdev->js->job_lock, flags);
>>>
>>> 	panfrost_device_reset(pfdev);
>>>
>>> 	for (i = 0; i < NUM_JOB_SLOTS; i++)
>>> 		drm_sched_resubmit_jobs(&pfdev->js->queue[i].sched);
>>>
>>> 	/* restart scheduler after GPU is usable again */
>>> 	for (i = 0; i < NUM_JOB_SLOTS; i++)
>>> 		drm_sched_start(&pfdev->js->queue[i].sched, true);
>>>
>>> 	mutex_unlock(&pfdev->reset_lock);
>>
>> I'm wondering whether the mutex_unlock() should actually happen before
>> the drm_sched_start() - in the (admittedly very unlikely) case where a
>> timeout occurs before all the drm_sched_start() calls have completed
>> it's possible for the timeout to be completely missed because the mutex
>> is still held.
>>
>> Thanks,
>>
>> Steve
> 

