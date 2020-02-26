Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31435170BCE
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 23:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBZWox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 17:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgBZWox (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 17:44:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1EB920658;
        Wed, 26 Feb 2020 22:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582757092;
        bh=oMlyTNobOYOn8hzxo1C1/1YV1DjH0l+4V8RXNwQZwOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gglhqb6khdP94KUdK0h8iEEuEsj9IQDBBmpBk/LHKD2Xi/ugIWcWHgHlz6owEmBAY
         8am5p+hjWolOnFou8dhzJfSq7+C4+T3T/G3eFej7ZG+HzxmPoaJv2iNJhYKOQYFkIJ
         m5Ol24Tnl2m0qGRtbMqEclUV3DyX2zsFfAIy7BUk=
Date:   Wed, 26 Feb 2020 17:44:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     gustavold@linux.ibm.com, mikey@neuling.org, mpe@ellerman.id.au,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/tm: Fix clearing MSR[TS] in
 current when reclaiming" failed to apply to 4.14-stable tree
Message-ID: <20200226224451.GB22178@sasha-vm>
References: <15827130459849@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15827130459849@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 11:30:45AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 2464cc4c345699adea52c7aef75707207cb8a2f6 Mon Sep 17 00:00:00 2001
>From: Gustavo Luiz Duarte <gustavold@linux.ibm.com>
>Date: Tue, 11 Feb 2020 00:38:29 -0300
>Subject: [PATCH] powerpc/tm: Fix clearing MSR[TS] in current when reclaiming
> on signal delivery
>
>After a treclaim, we expect to be in non-transactional state. If we
>don't clear the current thread's MSR[TS] before we get preempted, then
>tm_recheckpoint_new_task() will recheckpoint and we get rescheduled in
>suspended transaction state.
>
>When handling a signal caught in transactional state,
>handle_rt_signal64() calls get_tm_stackpointer() that treclaims the
>transaction using tm_reclaim_current() but without clearing the
>thread's MSR[TS]. This can cause the TM Bad Thing exception below if
>later we pagefault and get preempted trying to access the user's
>sigframe, using __put_user(). Afterwards, when we are rescheduled back
>into do_page_fault() (but now in suspended state since the thread's
>MSR[TS] was not cleared), upon executing 'rfid' after completion of
>the page fault handling, the exception is raised because a transition
>from suspended to non-transactional state is invalid.
>
>  Unexpected TM Bad Thing exception at c00000000000de44 (msr 0x8000000302a03031) tm_scratch=800000010280b033
>  Oops: Unrecoverable exception, sig: 6 [#1]
>  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>  CPU: 25 PID: 15547 Comm: a.out Not tainted 5.4.0-rc2 #32
>  NIP:  c00000000000de44 LR: c000000000034728 CTR: 0000000000000000
>  REGS: c00000003fe7bd70 TRAP: 0700   Not tainted  (5.4.0-rc2)
>  MSR:  8000000302a03031 <SF,VEC,VSX,FP,ME,IR,DR,LE,TM[SE]>  CR: 44000884  XER: 00000000
>  CFAR: c00000000000dda4 IRQMASK: 0
>  PACATMSCRATCH: 800000010280b033
>  GPR00: c000000000034728 c000000f65a17c80 c000000001662800 00007fffacf3fd78
>  GPR04: 0000000000001000 0000000000001000 0000000000000000 c000000f611f8af0
>  GPR08: 0000000000000000 0000000078006001 0000000000000000 000c000000000000
>  GPR12: c000000f611f84b0 c00000003ffcb200 0000000000000000 0000000000000000
>  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000f611f8140
>  GPR24: 0000000000000000 00007fffacf3fd68 c000000f65a17d90 c000000f611f7800
>  GPR28: c000000f65a17e90 c000000f65a17e90 c000000001685e18 00007fffacf3f000
>  NIP [c00000000000de44] fast_exception_return+0xf4/0x1b0
>  LR [c000000000034728] handle_rt_signal64+0x78/0xc50
>  Call Trace:
>  [c000000f65a17c80] [c000000000034710] handle_rt_signal64+0x60/0xc50 (unreliable)
>  [c000000f65a17d30] [c000000000023640] do_notify_resume+0x330/0x460
>  [c000000f65a17e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
>  Instruction dump:
>  7c4ff120 e8410170 7c5a03a6 38400000 f8410060 e8010070 e8410080 e8610088
>  60000000 60000000 e8810090 e8210078 <4c000024> 48000000 e8610178 88ed0989
>  ---[ end trace 93094aa44b442f87 ]---
>
>The simplified sequence of events that triggers the above exception is:
>
>  ...				# userspace in NON-TRANSACTIONAL state
>  tbegin			# userspace in TRANSACTIONAL state
>  signal delivery		# kernelspace in SUSPENDED state
>  handle_rt_signal64()
>    get_tm_stackpointer()
>      treclaim			# kernelspace in NON-TRANSACTIONAL state
>    __put_user()
>      page fault happens. We will never get back here because of the TM Bad Thing exception.
>
>  page fault handling kicks in and we voluntarily preempt ourselves
>  do_page_fault()
>    __schedule()
>      __switch_to(other_task)
>
>  our task is rescheduled and we recheckpoint because the thread's MSR[TS] was not cleared
>  __switch_to(our_task)
>    switch_to_tm()
>      tm_recheckpoint_new_task()
>        trechkpt			# kernelspace in SUSPENDED state
>
>  The page fault handling resumes, but now we are in suspended transaction state
>  do_page_fault()    completes
>  rfid     <----- trying to get back where the page fault happened (we were non-transactional back then)
>  TM Bad Thing			# illegal transition from suspended to non-transactional
>
>This patch fixes that issue by clearing the current thread's MSR[TS]
>just after treclaim in get_tm_stackpointer() so that we stay in
>non-transactional state in case we are preempted. In order to make
>treclaim and clearing the thread's MSR[TS] atomic from a preemption
>perspective when CONFIG_PREEMPT is set, preempt_disable/enable() is
>used. It's also necessary to save the previous value of the thread's
>MSR before get_tm_stackpointer() is called so that it can be exposed
>to the signal handler later in setup_tm_sigcontexts() to inform the
>userspace MSR at the moment of the signal delivery.
>
>Found with tm-signal-context-force-tm kernel selftest.
>
>Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the signal context")
>Cc: stable@vger.kernel.org # v3.9
>Signed-off-by: Gustavo Luiz Duarte <gustavold@linux.ibm.com>
>Acked-by: Michael Neuling <mikey@neuling.org>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20200211033831.11165-1-gustavold@linux.ibm.com

I took these two additional patches (which looks like fixes on their
own) and queued all 3 for 4.14 and 4.9:

92fb8690bd04 ("powerpc/tm: P9 disable transactionally suspended sigcontexts")
1c200e63d055 ("powerpc/tm: Fix endianness flip on trap")


The 4.4 backport looks a bit more complex.

-- 
Thanks,
Sasha
