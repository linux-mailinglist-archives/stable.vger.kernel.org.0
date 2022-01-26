Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9641949CB88
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiAZNyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:54:39 -0500
Received: from foss.arm.com ([217.140.110.172]:41392 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241745AbiAZNye (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 08:54:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F007C1FB;
        Wed, 26 Jan 2022 05:54:32 -0800 (PST)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A06E23F793;
        Wed, 26 Jan 2022 05:54:29 -0800 (PST)
Subject: Re: [PATCH v3] sched/fair: Fix fault in reweight_entity
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, peterz@infradead.org
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
References: <20220125193403.778497-1-tadeusz.struk@linaro.org>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <bb01425b-0f6a-e69f-c24b-567821c1472f@arm.com>
Date:   Wed, 26 Jan 2022 14:53:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220125193403.778497-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/01/2022 20:34, Tadeusz Struk wrote:
> Syzbot found a GPF in reweight_entity. This has been bisected to commit
> 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> 
> There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
> within a thread group that causes a null-ptr-deref in reweight_entity()
> in CFS. The scenario is that the main process spawns number of new
> threads, which then call setpriority(PRIO_PGRP, 0, -20), wait, and exit.
> For each of the new threads the copy_process() gets invoked, which adds
> the new task_struct and calls sched_post_fork() for it.
> 
> In the above scenario there is a possibility that setpriority(PRIO_PGRP)
> and set_one_prio() will be called for a thread in the group that is just
> being created by copy_process(), and for which the sched_post_fork() has
> not been executed yet. This will trigger a null pointer dereference in
> reweight_entity(), as it will try to access the run queue pointer, which
> hasn't been set. This results it a crash as shown below:
> 
> KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
> CPU: 0 PID: 2392 Comm: reduced_repro Not tainted 5.16.0-11201-gb42c5a161ea3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
> RIP: 0010:reweight_entity+0x15d/0x440
> RSP: 0018:ffffc900035dfcf8 EFLAGS: 00010006
> Call Trace:
> <TASK>
> reweight_task+0xde/0x1c0
> set_load_weight+0x21c/0x2b0
> set_user_nice.part.0+0x2d1/0x519
> set_user_nice.cold+0x8/0xd
> set_one_prio+0x24f/0x263
> __do_sys_setpriority+0x2d3/0x640
> __x64_sys_setpriority+0x84/0x8b
> do_syscall_64+0x35/0xb0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> </TASK>
> ---[ end trace 9dc80a9d378ed00a ]---
> 
> Before the mentioned change the cfs_rq pointer for the task  has been
> set in sched_fork(), which is called much earlier in copy_process(),
> before the new task is added to the thread_group.
> Now it is done in the sched_post_fork(), which is called after that.
> To fix the issue the update_load condition passed to set_load_weight()
> in set_user_nice() and __sched_setscheduler() has been changed from
> always true to true if the task->state != TASK_NEW.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
> Cc: Zhang Qiao <zhangqiao22@huawei.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
> Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> Changes in v3:
> - Removed the new check and changed the update_load condition from
>   always true to true if p->state != TASK_NEW
> 
> Changes in v2:
> - Added a check in set_user_nice(), and return from there if the task
>   is not fully setup instead of returning from reweight_entity()
> ---
> ---
>  kernel/sched/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 848eaa0efe0e..3d7ede06b971 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6921,7 +6921,7 @@ void set_user_nice(struct task_struct *p, long nice)
>  		put_prev_task(rq, p);
>  
>  	p->static_prio = NICE_TO_PRIO(nice);
> -	set_load_weight(p, true);
> +	set_load_weight(p, !(READ_ONCE(p->__state) & TASK_NEW));
>  	old_prio = p->prio;
>  	p->prio = effective_prio(p);
>  
> @@ -7212,7 +7212,7 @@ static void __setscheduler_params(struct task_struct *p,
>  	 */
>  	p->rt_priority = attr->sched_priority;
>  	p->normal_prio = normal_prio(p);
> -	set_load_weight(p, true);
> +	set_load_weight(p, !(READ_ONCE(p->__state) & TASK_NEW));
>  }

Can we then not get rid of `bool update_load` parameter of
set_load_weight() completely?

@@ -1214,8 +1214,9 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
+       int task_new = READ_ONCE(p->__state) & TASK_NEW;
        int prio = p->static_prio - MAX_RT_PRIO;
        struct load_weight *load = &p->se.load;
 
@@ -1232,7 +1233,7 @@ static void set_load_weight(struct task_struct *p, bool update_load)
         * SCHED_OTHER tasks have to update their load when changing their
         * weight
         */
-       if (update_load && p->sched_class == &fair_sched_class) {
+       if (!task_new && p->sched_class == &fair_sched_class) {
                reweight_task(p, prio);
        } else {
                load->weight = scale_load(sched_prio_to_weight[prio]);


p in sched_fork() would have `p->__state = TASK_NEW` and in sched_init()
`init_task->sched_class is NULL so != &fair_sched_class`.
