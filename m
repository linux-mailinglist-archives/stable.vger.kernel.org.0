Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47122CC6D5
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbgLBTkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:40:15 -0500
Received: from mail.efficios.com ([167.114.26.124]:33780 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbgLBTkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:40:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A8C1D29544F;
        Wed,  2 Dec 2020 14:39:33 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Juf7fZOUmck8; Wed,  2 Dec 2020 14:39:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 42EC3295672;
        Wed,  2 Dec 2020 14:39:33 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 42EC3295672
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1606937973;
        bh=8qc33ZStlXAXhk1WCojfkrs9hFdD+S7Sn+mQ9bpXG+8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=c7WG34O0nBIwTMcXLx2d5UeSEByS+b5m/ueRzktoVUzyqq9/zJXRE+jesnwwV+0D9
         l4wVnNj+UXTfvAwZZvWUgJ+7913raDWMLH8iQZrA+SBY1y4Ta3hCqJD4mahL938fR0
         tpx6fKc75+st1MQ4GqVCkFoN3V1KEApG3n9IK50vCtF2jlDz6PtjRTrQ8Hf4tg5eEU
         Q0Pb8olToOIOvvCc9kHU1jlblD6Ti+CSnD9QIoEWwwR9rnnqLbmO/+bwxUCFacqhB6
         lGn8ateiO5k9HsqkzLJj+ChdIzZaOQIpnREA5vR69AaMq0egXAu9Y1NB+dmIIobJ1j
         LZ9XMyfnMxSkQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QX2-WlH-OhAg; Wed,  2 Dec 2020 14:39:33 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 32B1B2957A5;
        Wed,  2 Dec 2020 14:39:33 -0500 (EST)
Date:   Wed, 2 Dec 2020 14:39:32 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Message-ID: <169451685.20.1606937972996.JavaMail.zimbra@efficios.com>
In-Reply-To: <8ee6202360fa1d1e2ab6e18846513bdbe20bc29c.1606923183.git.luto@kernel.org>
References: <cover.1606923183.git.luto@kernel.org> <8ee6202360fa1d1e2ab6e18846513bdbe20bc29c.1606923183.git.luto@kernel.org>
Subject: Re: [PATCH v2 4/4] membarrier: Execute SYNC_CORE on the calling
 thread
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF83 (Linux)/8.8.15_GA_3975)
Thread-Topic: membarrier: Execute SYNC_CORE on the calling thread
Thread-Index: o2ZDpFgcIydSZZIz/ZbuWAWGFNq7/A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 2, 2020, at 10:35 AM, Andy Lutomirski luto@kernel.org wrote:

> membarrier()'s MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is documented
> as syncing the core on all sibling threads but not necessarily the
> calling thread.  This behavior is fundamentally buggy and cannot be used
> safely.  Suppose a user program has two threads.  Thread A is on CPU 0
> and thread B is on CPU 1.  Thread A modifies some text and calls
> membarrier(MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE).  Then thread B
> executes the modified code.  If, at any point after membarrier() decides
> which CPUs to target, thread A could be preempted and replaced by thread
> B on CPU 0.  This could even happen on exit from the membarrier()
> syscall.  If this happens, thread B will end up running on CPU 0 without
> having synced.

Indeed, good catch! We only have sync core in the scheduler when switching
between mm, so indeed we cannot rely on the scheduler to issue a sync core
for us when switching between threads with the same mm.

> In principle, this could be fixed by arranging for the scheduler to
> sync_core_before_usermode() whenever switching between two threads in
> the same mm if there is any possibility of a concurrent membarrier()
> call, but this would have considerable overhead.  Instead, make
> membarrier() sync the calling CPU as well.

Yes, I agree that sync core on self is the right approach here.

> As an optimization, this avoids an extra smp_mb() in the default
> barrier-only mode.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> kernel/sched/membarrier.c | 49 +++++++++++++++++++++++++--------------
> 1 file changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
> index 01538b31f27e..7df7c0e60647 100644
> --- a/kernel/sched/membarrier.c
> +++ b/kernel/sched/membarrier.c
> @@ -352,8 +352,6 @@ static int membarrier_private_expedited(int flags, int
> cpu_id)
> 

There is one small optimization you will want to adapt here:

        if (atomic_read(&mm->mm_users) == 1 || num_online_cpus() == 1)
                return 0;

should become:

        if (flags != MEMBARRIER_FLAG_SYNC_CORE && atomic_read(&mm->mm_users) == 1 || num_online_cpus() == 1)
                return 0;

So we issue a core sync for self in single-threaded applications,
to make things consistent. We can then document that membarrier sync core
issues a core sync on all thread siblings including the caller thread.

> 		if (cpu_id >= nr_cpu_ids || !cpu_online(cpu_id))
> 			goto out;
> -		if (cpu_id == raw_smp_processor_id())
> -			goto out;
> 		rcu_read_lock();
> 		p = rcu_dereference(cpu_rq(cpu_id)->curr);
> 		if (!p || p->mm != mm) {
> @@ -368,16 +366,6 @@ static int membarrier_private_expedited(int flags, int
> cpu_id)
> 		for_each_online_cpu(cpu) {
> 			struct task_struct *p;
> 
> -			/*
> -			 * Skipping the current CPU is OK even through we can be
> -			 * migrated at any point. The current CPU, at the point
> -			 * where we read raw_smp_processor_id(), is ensured to
> -			 * be in program order with respect to the caller
> -			 * thread. Therefore, we can skip this CPU from the
> -			 * iteration.
> -			 */
> -			if (cpu == raw_smp_processor_id())
> -				continue;
> 			p = rcu_dereference(cpu_rq(cpu)->curr);
> 			if (p && p->mm == mm)
> 				__cpumask_set_cpu(cpu, tmpmask);
> @@ -385,12 +373,39 @@ static int membarrier_private_expedited(int flags, int
> cpu_id)
> 		rcu_read_unlock();
> 	}
> 
> -	preempt_disable();
> -	if (cpu_id >= 0)
> +	if (cpu_id >= 0) {
> +		/*
> +		 * smp_call_function_single() will call ipi_func() if cpu_id
> +		 * is the calling CPU.
> +		 */
> 		smp_call_function_single(cpu_id, ipi_func, NULL, 1);
> -	else
> -		smp_call_function_many(tmpmask, ipi_func, NULL, 1);
> -	preempt_enable();
> +	} else {
> +		/*
> +		 * For regular membarrier, we can save a few cycles by
> +		 * skipping the current cpu -- we're about to do smp_mb()
> +		 * below, and if we migrate to a different cpu, this cpu
> +		 * and the new cpu will execute a full barrier in the
> +		 * scheduler.
> +		 *
> +		 * For CORE_SYNC, we do need a barrier on the current cpu --
> +		 * otherwise, if we are migrated and replaced by a different
> +		 * task in the same mm just before, during, or after
> +		 * membarrier, we will end up with some thread in the mm
> +		 * running without a core sync.
> +		 *
> +		 * For RSEQ, it seems polite to target the calling thread
> +		 * as well, although it's not clear it makes much difference
> +		 * either way.  Users aren't supposed to run syscalls in an
> +		 * rseq critical section.

Considering that we want a consistent behavior between single and multi-threaded
programs (as I pointed out above wrt the optimization change), I think it would
be better to skip self for the rseq ipi, in the same way we'd want to return
early for a membarrier-rseq-private on a single-threaded mm. Users are _really_
not supposed to run system calls in rseq critical sections. The kernel even kills
the offending applications when run on kernels with CONFIG_DEBUG_RSEQ=y. So it seems
rather pointless to waste cycles doing a rseq fence on self considering this.

Thanks,

Mathieu

> +		 */
> +		if (ipi_func == ipi_mb) {
> +			preempt_disable();
> +			smp_call_function_many(tmpmask, ipi_func, NULL, true);
> +			preempt_enable();
> +		} else {
> +			on_each_cpu_mask(tmpmask, ipi_func, NULL, true);
> +		}
> +	}
> 
> out:
> 	if (cpu_id < 0)
> --
> 2.28.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
