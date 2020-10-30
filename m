Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544CC2A01FB
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ3KAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 06:00:18 -0400
Received: from foss.arm.com ([217.140.110.172]:57962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgJ3KAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 06:00:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45051150C;
        Fri, 30 Oct 2020 03:00:17 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3251F3F719;
        Fri, 30 Oct 2020 03:00:16 -0700 (PDT)
Subject: Re: [PATCH] drm/panfrost: Move the GPU reset bits outside the timeout
 handler
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201030070826.582969-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <8185209b-b943-c1b8-90d8-fee894f6f829@arm.com>
Date:   Fri, 30 Oct 2020 10:00:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030070826.582969-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/10/2020 07:08, Boris Brezillon wrote:
> We've fixed many races in panfrost_job_timedout() but some remain.
> Instead of trying to fix it again, let's simplify the logic and move
> the reset bits to a separate work scheduled when one of the queue
> reports a timeout.
> 
> Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>   drivers/gpu/drm/panfrost/panfrost_device.c |   1 -
>   drivers/gpu/drm/panfrost/panfrost_device.h |   6 +-
>   drivers/gpu/drm/panfrost/panfrost_job.c    | 130 ++++++++++++---------
>   3 files changed, 82 insertions(+), 55 deletions(-)
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
> index 2e9cbd1c4a58..67f9f66904be 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -105,7 +105,11 @@ struct panfrost_device {
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
> index d0469e944143..745ee9563a54 100644
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
> +	/* Schedule a reset. */
> +	atomic_set(&pfdev->reset.pending, 1);

Maybe I'm missing something, but I can't work out what setting 
reset.pending here gives us. See below.

> +	schedule_work(&pfdev->reset.work);
>   }
>   
>   static const struct drm_sched_backend_ops panfrost_sched_ops = {
> @@ -531,11 +504,62 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
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
> +	if (!atomic_read(&pfdev->reset.pending))
> +		return;

AFAICT the only time this return will be hit is in the following case:

CPU 0                     |  CPU 1
--------------------------+-------------------
job_timedout()            |
panfrost_reset()          |
  ...                      | job_timedout()
  - atomic_set(pending, 0) | ...
                           | if (!atomic_read()) - returns early

However, reordering that a little we can see it can fail:

CPU 0                     |  CPU 1
--------------------------+-------------------
job_timedout()            |
  ...                      |
panfrost_reset()          |
  ...                      | job_timedout()
  ...                      | panfrost_reset()
  ...                      | if (atomic_read()) - doesn't return early
  - atomic_set(pending, 0) | ...

I don't see anything which prevents the second scenario, so this pending 
flag doesn't seem to be stopping any race condition.

What am I missing?

I would have expected something more along the lines of:

	/* Schedule a reset */
	if (atomic_cmpxchg(&pfdev->reset.pending, 0, 1)) {
		/* Reset already in progress */
		return;
	}
	schedule_work(&pfdev->reset.work);

What do you think?

Also FYI I applied this on top of my panfrost-dev branch and managed to 
hit the following splat. I haven't yet got to the bottom of it, so it 
might well be an unrelated bug. At first glance this looks like the job 
is managing to outlive the MMU context it's tied to.

Steve

[  554.032998] ------------[ cut here ]------------
[  554.035169] Unable to handle kernel NULL pointer dereference at 
virtual address 00000104
[  554.035199] pgd = a3e6a38a
[  554.035214] [00000104] *pgd=00000000
[  554.035238] Internal error: Oops: 805 [#1] SMP ARM
[  554.035245] Modules linked in: panfrost gpu_sched
[  554.035265] CPU: 1 PID: 59 Comm: kworker/1:2 Not tainted 5.9.0-rc5+ #14
[  554.035271] Hardware name: Rockchip (Device Tree)
[  554.035305] Workqueue: events panfrost_reset [panfrost]
[  554.035336] PC is at panfrost_mmu_as_get+0x7c/0x270 [panfrost]
[  554.035363] LR is at panfrost_mmu_as_get+0x3c/0x270 [panfrost]
[  554.035371] pc : [<bf00e65c>]    lr : [<bf00e61c>]    psr: 800f0013
[  554.035378] sp : ecfdfe40  ip : 00000000  fp : 02f79000
[  554.035384] r10: 00000000  r9 : eb748d68  r8 : eb748d3c
[  554.035390] r7 : 00000001  r6 : eb442200  r5 : 00000001  r4 : eb748c40
[  554.035398] r3 : eb442244  r2 : 00000122  r1 : 00000100  r0 : eb442240
[  554.035406] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment none
[  554.035415] Control: 10c5387d  Table: 2bb6406a  DAC: 00000051
[  554.035423] Process kworker/1:2 (pid: 59, stack limit = 0x4caadad3)
[  554.035430] Stack: (0xecfdfe40 to 0xecfe0000)
[  554.035445] fe40: 600f0013 ee1cdd24 ee1cdd24 c07934f0 00000001 
eb748c40 e96c8400 00000080
[  554.035458] fe60: 00000001 000018e0 e97d6480 00000000 02f79000 
bf00d3bc 00000006 00000000
[  554.035471] fe80: 00000005 00000000 c0d08ec8 ecfdfeb4 00000000 
ffffe000 eb81421c e96c8400
[  554.035483] fea0: eb814400 eac71d80 eb814278 00000000 00000238 
eb814418 00000000 bf000f40
[  554.035496] fec0: 83f5c473 eb748dd8 eb81421c 00000238 00000001 
00000000 00000238 bf0122de
[  554.035509] fee0: eb814040 bf00d088 bf00cf68 ecf94680 eefa5f40 
eb748dd8 c0dd62a7 eefa9400
[  554.035521] ff00: 00000000 00000000 00000001 c013a6b4 00000001 
00000000 c013a608 83f5c473
[  554.035534] ff20: ffffe000 c0d08ec8 bf0144f4 c126d4e0 00000000 
bf012441 00000000 83f5c473
[  554.035547] ff40: 00000000 ecf94680 ecf94694 eefa5f40 ecfde000 
eefa5f78 c0d05d00 c0deece8
[  554.035560] ff60: 00000000 c013b1a0 00000000 eea2f300 ecfde000 
ecf95540 c013af74 ecf94680
[  554.035573] ff80: eea49ea4 eea2f344 00000000 c0140a80 ecf95540 
c0140958 00000000 00000000
[  554.035584] ffa0: 00000000 00000000 00000000 c0100114 00000000 
00000000 00000000 00000000
[  554.035596] ffc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  554.035607] ffe0: 00000000 00000000 00000000 00000000 00000013 
00000000 00000000 00000000
[  554.035663] [<bf00e65c>] (panfrost_mmu_as_get [panfrost]) from 
[<bf00d3bc>] (panfrost_job_run+0x19c/0x2b4 [panfrost])
[  554.035717] [<bf00d3bc>] (panfrost_job_run [panfrost]) from 
[<bf000f40>] (drm_sched_resubmit_jobs+0x88/0xc4 [gpu_sched])
[  554.035771] [<bf000f40>] (drm_sched_resubmit_jobs [gpu_sched]) from 
[<bf00d088>] (panfrost_reset+0x120/0x190 [panfrost])
[  554.035809] [<bf00d088>] (panfrost_reset [panfrost]) from 
[<c013a6b4>] (process_one_work+0x238/0x53c)
[  554.035823] [<c013a6b4>] (process_one_work) from [<c013b1a0>] 
(worker_thread+0x22c/0x2e0)
[  554.035838] [<c013b1a0>] (worker_thread) from [<c0140a80>] 
(kthread+0x128/0x138)
[  554.035854] [<c0140a80>] (kthread) from [<c0100114>] 
(ret_from_fork+0x14/0x20)
[  554.035864] Exception stack(0xecfdffb0 to 0xecfdfff8)
[  554.043775] WARNING: CPU: 0 PID: 350 at drivers/gpu/drm/drm_mm.c:999 
panfrost_postclose+0x28/0x34 [panfrost]
[  554.050065] ffa0:                                     00000000 
00000000 00000000 00000000
[  554.050077] ffc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  554.050087] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  554.050101] Code: eb44454b e5962048 e2863044 e5961044 (e5812004)
[  554.050178] ---[ end trace 220c904d56e775c9 ]---
