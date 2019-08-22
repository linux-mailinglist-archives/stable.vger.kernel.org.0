Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B299A151
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732819AbfHVUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:40:58 -0400
Received: from foss.arm.com ([217.140.110.172]:52234 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731895AbfHVUk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 16:40:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F7B7337;
        Thu, 22 Aug 2019 13:40:55 -0700 (PDT)
Received: from [10.0.2.15] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C9D923F706;
        Thu, 22 Aug 2019 13:40:53 -0700 (PDT)
Subject: Re: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
To:     bsegall@google.com
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, liangyan.peng@linux.alibaba.com,
        shanpeic@linux.alibaba.com, xlpang@linux.alibaba.com,
        pjt@google.com, stable@vger.kernel.org
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
 <20190820105420.7547-1-valentin.schneider@arm.com>
 <xm26lfvlhw93.fsf@bsegall-linux.svl.corp.google.com>
From:   Valentin Schneider <valentin.schneider@arm.com>
Message-ID: <20382abf-4741-7792-d830-34603409361e@arm.com>
Date:   Thu, 22 Aug 2019 21:40:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <xm26lfvlhw93.fsf@bsegall-linux.svl.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/08/2019 19:48, bsegall@google.com wrote:> Having now seen the rest of the thread:
> 
> Could you send the repro, as it doesn't seem to have reached lkml, so
> that I can confirm my guess as to what's going on?
> 

Huh, odd. Here's the thing:

delay.c:
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

unsigned long NUM_LOOPS=2500000*250;

/* simple loop based delay: */
static void delay_loop(unsigned long loops)
{
	asm volatile(
		"	test %0,%0	\n"
		"	jz 3f		\n"
		"	jmp 1f		\n"

		".align 16		\n"
		"1:	jmp 2f		\n"

		".align 16		\n"
		"2:	dec %0		\n"
		"	jnz 2b		\n"
		"3:	dec %0		\n"

		: /* we don't need output */
		:"a" (loops)
	);
}

void __const_udelay(unsigned long xloops)
{
	int d0;

	xloops *= 4;
	asm("mull %%edx"
		:"=d" (xloops), "=&a" (d0)
		:"1" (xloops), "0"
		(NUM_LOOPS));

	delay_loop(++xloops);
}

void __udelay(unsigned long usecs)
{
	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
}

static void *thread_start(void *arg)
{
    while(1) {
	__udelay((unsigned long)arg);
	usleep(7000);
    }
}

int main(int argc, char*argv[])
{
	int i;
	int thread;
	unsigned long timeout;
	pthread_t new_th;

	if (argc != 3) {
		printf("./delay nr_thread work_loop\n");
		exit(-1);
	}

	thread = atoi(argv[1]);
	timeout = (unsigned long)atoi(argv[2]);

	for (i = 0; i < thread; i++) {
		pthread_create(&new_th, NULL, thread_start, (void *)timeout);
		usleep(100);
	}

	while(1) {
		sleep(10);
	}
}


do-delay.sh:
#!/bin/bash

mkdir /sys/fs/cgroup/cpu/test1
echo 100000 > /sys/fs/cgroup/cpu/cpu.cfs_period_us
echo 1600000 > /sys/fs/cgroup/cpu/test1/cpu.cfs_quota_us
./delay 500 1000 &
echo $! > /sys/fs/cgroup/cpu/test1/cgroup.procs
mkdir /sys/fs/cgroup/cpu/test2
echo 100000 > /sys/fs/cgroup/cpu/test2/cpu.cfs_period_us
echo 800000 > /sys/fs/cgroup/cpu/test2/cpu.cfs_quota_us
./delay 500 1000 &
echo $! > /sys/fs/cgroup/cpu/test2/cgroup.procs
prev=0;while true; do curr=`cat /sys/fs/cgroup/cpu/test1/cpuacct.usage` && echo $(($curr-$prev)) && prev=$curr && sleep 1; done


I ran the thing on a dual-socket x86 test box and could trigger the issue
quite rapidly (w/ the WARN_ON in distribute_cfs_runtime()).

> It seems most likely we throttle during one of the remove-change-adds in
> set_cpus_allowed and friends or during the put half of pick_next_task
> followed by idle balance to drop the lock. Then distribute races with a
> later assign_cfs_rq_runtime so that the account finds runtime in the
> cfs_b.
> 

I should still have a trace laying around, let me have a look.

> Re clock_task, it's only frozen for the purposes of pelt, not delta_exec
> 

Noted, thanks. But then we shouldn't expect throttled rq's to call into
update_curr(), right? Maybe just right after they've been throttled, but not
beyond that. Otherwise I fail to see how that would make sense.

> The other possible way to fix this would be to skip assign if throttled,
> since the only time it could succeed is if we're racing with a
> distribute that will unthrottle use anyways.
> 

So pretty much the change Liangyan originally proposed? (so much for trying
to help :p)

> The main advantage of that is the risk of screwy behavior due to unthrottling
> in the middle of pick_next/put_prev. The disadvantage is that we already
> have the lock, if it works we don't need an ipi to trigger a preempt,
> etc. (But I think one of the issues is that we may trigger the preempt
> on the previous task, not the next, and I'm not 100% sure that will
> carry over correctly)
> 
