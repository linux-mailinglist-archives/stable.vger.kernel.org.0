Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39104A8195
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 10:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349790AbiBCJkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 04:40:35 -0500
Received: from foss.arm.com ([217.140.110.172]:34502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233414AbiBCJkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Feb 2022 04:40:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BBA7113E;
        Thu,  3 Feb 2022 01:40:30 -0800 (PST)
Received: from [192.168.178.6] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 532033F40C;
        Thu,  3 Feb 2022 01:40:28 -0800 (PST)
Subject: Re: [PATCH v4] sched/fair: Fix fault in reweight_entity
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, peterz@infradead.org
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
References: <20220125193403.778497-1-tadeusz.struk@linaro.org>
 <20220127205623.1258029-1-tadeusz.struk@linaro.org>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <dc241a1f-74c2-3db6-e932-04b653e469bb@arm.com>
Date:   Thu, 3 Feb 2022 10:40:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220127205623.1258029-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/01/2022 21:56, Tadeusz Struk wrote:
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
> To fix the issue the remove the update_load param from the
> update_load param() function and call reweight_task() only if the task
> flag doesn't have the TASK_NEW flag set.
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
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
> Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> Changes in v4:
> - Removed the update_load param from set_load_weight() and call
>   reweight_task() based on the TASK_NEW flag
> 
> Changes in v3:
> - Removed the new check and changed the update_load condition from
>   always true to true if p->state != TASK_NEW
> 
> Changes in v2:
> - Added a check in set_user_nice(), and return from there if the task
>   is not fully setup instead of returning from reweight_entity()
> ---
>  kernel/sched/core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 848eaa0efe0e..a0ef4670e695 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1214,10 +1214,12 @@ int tg_nop(struct task_group *tg, void *data)
>  }
>  #endif
>  
> -static void set_load_weight(struct task_struct *p, bool update_load)
> +static void set_load_weight(struct task_struct *p)
>  {
>  	int prio = p->static_prio - MAX_RT_PRIO;
>  	struct load_weight *load = &p->se.load;
> +	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);

nit-pick: reverse fir tree order

cat Documentation/process/maintainer-tip.rst | grep -A 10 "Variable
declarations"

I was able to recreate the initial issue with the reproducer on arm64
Juno-r0 with CONFIG_CGROUP_SCHED=y .

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
