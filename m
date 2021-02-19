Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEAF31F9B0
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 14:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBSNND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 08:13:03 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:44069 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhBSNND (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 08:13:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UOyXQVY_1613740332;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UOyXQVY_1613740332)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Feb 2021 21:12:17 +0800
From:   Wen Yang <simon.wy@alibaba-inc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Wen Yang <simon.wy@alibaba-inc.com>
Subject: [PATCH 4.9] smp: Warn on function calls from softirq context
Date:   Fri, 19 Feb 2021 21:12:10 +0800
Message-Id: <20210219131210.72241-1-simon.wy@alibaba-inc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> On Fri, Feb 19, 2021 at 02:43:34PM +0800, Wen Yang wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>> 
>> commit 19dbdcb8039cff16669a05136a29180778d16d0a upstream.
>> 
>> It's clearly documented that smp function calls cannot be invoked from
>> softirq handling context. Unfortunately nothing enforces that or emits a
>> warning.
>> 
>> A single function call can be invoked from softirq context only via
>> smp_call_function_single_async().
>> 
>> The only legit context is task context, so add a warning to that effect.
>> 
>> Reported-by: luferry <luferry@163.com>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Link: https://lkml.kernel.org/r/20190718160601.GP3402@hirez.programming.kicks-ass.net
>> Cc: stable <stable@vger.kernel.org> # 4.9.x
>> Signed-off-by: Wen Yang <simon.wy@alibaba-inc.com>
>> ---
>>  kernel/smp.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>> 
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index 399905f..f2b29c4 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -276,6 +276,14 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
>>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>>  	     && !oops_in_progress);
>>  
>> +	/*
>> +	 * When @wait we can deadlock when we interrupt between llist_add() and
>> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
>> +	 * csd_lock() on because the interrupt context uses the same csd
>> +	 * storage.
>> +	 */
>> +	WARN_ON_ONCE(!in_task());
>> +
>>  	csd = &csd_stack;
>>  	if (!wait) {
>>  	csd = this_cpu_ptr(&csd_data);
>> @@ -401,6 +409,14 @@ void smp_call_function_many(const struct cpumask *mask,
>>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>>  	     && !oops_in_progress && !early_boot_irqs_disabled);
>>  
>> +	/*
>> +	 * When @wait we can deadlock when we interrupt between llist_add() and
>> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
>> +	 * csd_lock() on because the interrupt context uses the same csd
>> +	 * storage.
>> +	 */
>> +	WARN_ON_ONCE(!in_task());
>> +
>>  	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
>>  	cpu = cpumask_first_and(mask, cpu_online_mask);
>>  	if (cpu == this_cpu)
>> -- 
>> 1.8.3.1
>> 
> 
> WHy do you want this in the 4.9.y kernel tree only, and not all others?
> What bug/problem does this fix?  It seems that it will only report
> problems that other code has, not fix existing code.  If anything, it's
> going to start causing machines to reboot that have "panic on warn" set,
> is that a good thing to do?

4.9, 4.14 and 4.19 should all need it.

We find that some third party kernel modules occasionally cause kernel
panic (such as watchdog reset). After further analysis, it is found that the
functions such as smp_call_function()/on_each_cpu() are called in the interrupt
context or softirq context.

Since these usages are illegal and cannot be prohibited, we should add a warning
to enhance the robustness of the stable kernel and/or facilitate the analysis of
the problems.

thanks,

Wen
