Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869E19A8AC
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 09:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbfHWHWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 03:22:51 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:29759 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731070AbfHWHWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 03:22:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TaCAom5_1566544956;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0TaCAom5_1566544956)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Aug 2019 15:22:37 +0800
Subject: Re: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
To:     bsegall@google.com, Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, shanpeic@linux.alibaba.com,
        xlpang@linux.alibaba.com, pjt@google.com, stable@vger.kernel.org
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
 <20190820105420.7547-1-valentin.schneider@arm.com>
 <xm26lfvlhw93.fsf@bsegall-linux.svl.corp.google.com>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <83cc309c-6072-b1c5-7c28-1f059ee74d76@linux.alibaba.com>
Date:   Fri, 23 Aug 2019 15:22:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <xm26lfvlhw93.fsf@bsegall-linux.svl.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Resend.

Sorry that my previous email has format issue.

On 19/8/23 上午2:48, bsegall@google.com wrote:
> Valentin Schneider <valentin.schneider@arm.com> writes:
> 
>> Turns out a cfs_rq->runtime_remaining can become positive in
>> assign_cfs_rq_runtime(), but this codepath has no call to
>> unthrottle_cfs_rq().
>>
>> This can leave us in a situation where we have a throttled cfs_rq with
>> positive ->runtime_remaining, which breaks the math in
>> distribute_cfs_runtime(): this function expects a negative value so that
>> it may safely negate it into a positive value.
>>
>> Add the missing unthrottle_cfs_rq(). While at it, add a WARN_ON where
>> we expect negative values, and pull in a comment from the mailing list
>> that didn't make it in [1].
>>
>> [1]: https://lkml.kernel.org/r/BANLkTi=NmCxKX6EbDQcJYDJ5kKyG2N1ssw@mail.gmail.com
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: ec12cb7f31e2 ("sched: Accumulate per-cfs_rq cpu usage and charge against bandwidth")
>> Reported-by: Liangyan <liangyan.peng@linux.alibaba.com>
>> Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
> 
> Having now seen the rest of the thread:
> 
> Could you send the repro, as it doesn't seem to have reached lkml, so
> that I can confirm my guess as to what's going on?
> 
> It seems most likely we throttle during one of the remove-change-adds in
> set_cpus_allowed and friends or during the put half of pick_next_task
> followed by idle balance to drop the lock. Then distribute races with a
> later assign_cfs_rq_runtime so that the account finds runtime in the
> cfs_b.
> 
pick_next_task_fair calls update_curr but get zero runtime because of 
cfs_b->runtime=0, then throttle current cfs_rq because of 
cfs_rq->runtime_remaining=0, then call put_prev_entity to 
__account_cfs_rq_runtime to assign new runtime since dequeue_entity on 
another cpu just call return_cfs_rq_runtime to return some runtime to 
cfs_b->runtime.


Please check below debug log to trace this logic.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f35930f..0da556c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4395,6 +4395,12 @@ static void __account_cfs_rq_runtime(struct 
cfs_rq *cfs_rq, u64 delta_exec)
         if (likely(cfs_rq->runtime_remaining > 0))
                 return;

+       if (cfs_rq->throttled && smp_processor_id()==20) {
+ 
pr_err("__account_cfs_rq_runtime:cfs_rq=%p,comm=%s,pid=%d,cpu=%d\n",cfs_rq,current->comm,current->pid,smp_processor_id());
+               dump_stack();
+       }
+       //if (cfs_rq->throttled)
+       //      return;
         /*
          * if we're unable to extend our runtime we resched so that the 
active
          * hierarchy can be throttled
@@ -4508,6 +4514,13 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
                 sub_nr_running(rq, task_delta);

         cfs_rq->throttled = 1;
+       {
+               if (cfs_rq->nr_running > 0 && smp_processor_id()==20) {
+ 
pr_err("throttle_cfs_rq:cfs_rq=%p,comm=%s,pid=%d,cpu=%d\n",cfs_rq,current->comm,current->pid,smp_processor_id());
+                       dump_stack();
+               }
+       }
         cfs_rq->throttled_clock = rq_clock(rq);
         raw_spin_lock(&cfs_b->lock);
         empty = list_empty(&cfs_b->throttled_cfs_rq);


[  257.406397] 
throttle_cfs_rq:cfs_rq=00000000b012d731,comm=delay,pid=4307,cpu=20
[  257.407251] CPU: 20 PID: 4307 Comm: delay Tainted: G        W   E 
5.2.0-rc3+ #9
[  257.408795] Call Trace:
[  257.409085]  dump_stack+0x5c/0x7b
[  257.409482]  throttle_cfs_rq+0x2c3/0x2d0
[  257.409940]  check_cfs_rq_runtime+0x2f/0x50
[  257.410430]  pick_next_task_fair+0xb1/0x740
[  257.410918]  __schedule+0x104/0x670
[  257.411333]  schedule+0x33/0x90
[  257.411706]  exit_to_usermode_loop+0x6a/0xf0
[  257.412201]  prepare_exit_to_usermode+0x80/0xc0
[  257.412734]  retint_user+0x8/0x8
[  257.413114] RIP: 0033:0x4006d0
[  257.413480] Code: 7d f8 48 8b 45 f8 48 85 c0 74 24 eb 0d 0f 1f 00 66 
2e 0f 1f 84 00 00 00 00 00 eb 0e 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 
00 <48> ff c8 75 fb 48 ff c8 90 5d c3 55 48 89 e5 48 83 ec 18 48 89 7d
[  257.415630] RSP: 002b:00007f9b74abbe90 EFLAGS: 00000206 ORIG_RAX: 
ffffffffffffff13
[  257.416508] RAX: 0000000000060f7b RBX: 0000000000000000 RCX: 
0000000000000000
[  257.417333] RDX: 00000000002625b3 RSI: 0000000000000000 RDI: 
00000000002625b4
[  257.418155] RBP: 00007f9b74abbe90 R08: 00007f9b74abc700 R09: 
00007f9b74abc700
[  257.418983] R10: 00007f9b74abc9d0 R11: 0000000000000000 R12: 
00007ffee72e1afe
[  257.419813] R13: 00007ffee72e1aff R14: 00007ffee72e1b00 R15: 
0000000000000000


[  257.420718] 
__account_cfs_rq_runtime:cfs_rq=00000000b012d731,comm=delay,pid=4307,cpu=20
[  257.421646] CPU: 20 PID: 4307 Comm: delay Tainted: G        W   E 
5.2.0-rc3+ #9
[  257.422538] Call Trace:
[  257.424712]  dump_stack+0x5c/0x7b
[  257.425101]  __account_cfs_rq_runtime+0x1d7/0x1e0
[  257.425656]  put_prev_entity+0x90/0x100
[  257.426102]  pick_next_task_fair+0x334/0x740
[  257.426605]  __schedule+0x104/0x670
[  257.427013]  schedule+0x33/0x90
[  257.427384]  exit_to_usermode_loop+0x6a/0xf0
[  257.427879]  prepare_exit_to_usermode+0x80/0xc0
[  257.428406]  retint_user+0x8/0x8
[  257.428783] RIP: 0033:0x4006d0


> Re clock_task, it's only frozen for the purposes of pelt, not delta_exec
> 
> The other possible way to fix this would be to skip assign if throttled,
> since the only time it could succeed is if we're racing with a
> distribute that will unthrottle use anyways.

I ever posted a similar patch here
https://lkml.org/lkml/2019/8/14/1176

> 
> The main advantage of that is the risk of screwy behavior due to unthrottling
> in the middle of pick_next/put_prev. The disadvantage is that we already
> have the lock, if it works we don't need an ipi to trigger a preempt,
> etc. (But I think one of the issues is that we may trigger the preempt
> on the previous task, not the next, and I'm not 100% sure that will
> carry over correctly)
> 
> 
> 
>> ---
>>   kernel/sched/fair.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 1054d2cf6aaa..219ff3f328e5 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4385,6 +4385,11 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
>>   	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
>>   }
>>   
>> +static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>> +{
>> +	return cfs_bandwidth_used() && cfs_rq->throttled;
>> +}
>> +
>>   /* returns 0 on failure to allocate runtime */
>>   static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>>   {
>> @@ -4411,6 +4416,9 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>>   
>>   	cfs_rq->runtime_remaining += amount;
>>   
>> +	if (cfs_rq->runtime_remaining > 0 && cfs_rq_throttled(cfs_rq))
>> +		unthrottle_cfs_rq(cfs_rq);
>> +
>>   	return cfs_rq->runtime_remaining > 0;
>>   }
>>   
>> @@ -4439,11 +4447,6 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
>>   	__account_cfs_rq_runtime(cfs_rq, delta_exec);
>>   }
>>   
>> -static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>> -{
>> -	return cfs_bandwidth_used() && cfs_rq->throttled;
>> -}
>> -
>>   /* check whether cfs_rq, or any parent, is throttled */
>>   static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
>>   {
>> @@ -4628,6 +4631,10 @@ static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b, u64 remaining)
>>   		if (!cfs_rq_throttled(cfs_rq))
>>   			goto next;
>>   
>> +		/* By the above check, this should never be true */
>> +		WARN_ON(cfs_rq->runtime_remaining > 0);
>> +
>> +		/* Pick the minimum amount to return to a positive quota state */
>>   		runtime = -cfs_rq->runtime_remaining + 1;
>>   		if (runtime > remaining)
>>   			runtime = remaining;
