Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0583164470
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 13:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBSMkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 07:40:02 -0500
Received: from ozlabs.org ([203.11.71.1]:46633 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgBSMkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 07:40:01 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48My3g1jpSz9sSR; Wed, 19 Feb 2020 23:39:58 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 2464cc4c345699adea52c7aef75707207cb8a2f6
In-Reply-To: <20200211033831.11165-1-gustavold@linux.ibm.com>
To:     Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     mikey@neuling.org, Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        stable@vger.kernel.org, gromero@linux.ibm.com
Subject: Re: [PATCH v3 1/3] powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal delivery
Message-Id: <48My3g1jpSz9sSR@ozlabs.org>
Date:   Wed, 19 Feb 2020 23:39:58 +1100 (AEDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-02-11 at 03:38:29 UTC, Gustavo Luiz Duarte wrote:
> After a treclaim, we expect to be in non-transactional state. If we don't clear
> the current thread's MSR[TS] before we get preempted, then
> tm_recheckpoint_new_task() will recheckpoint and we get rescheduled in
> suspended transaction state.
> 
> When handling a signal caught in transactional state, handle_rt_signal64()
> calls get_tm_stackpointer() that treclaims the transaction using
> tm_reclaim_current() but without clearing the thread's MSR[TS]. This can cause
> the TM Bad Thing exception below if later we pagefault and get preempted trying
> to access the user's sigframe, using __put_user(). Afterwards, when we are
> rescheduled back into do_page_fault() (but now in suspended state since the
> thread's MSR[TS] was not cleared), upon executing 'rfid' after completion of
> the page fault handling, the exception is raised because a transition from
> suspended to non-transactional state is invalid.
> 
> 	Unexpected TM Bad Thing exception at c00000000000de44 (msr 0x8000000302a03031) tm_scratch=800000010280b033
> 	Oops: Unrecoverable exception, sig: 6 [#1]
> 	LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> 	Modules linked in: nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6_tables ip_tables nft_compat ip_set nf_tables nfnetlink xts vmx_crypto sg virtio_balloon
> 	r_mod cdrom virtio_net net_failover virtio_blk virtio_scsi failover dm_mirror dm_region_hash dm_log dm_mod
> 	CPU: 25 PID: 15547 Comm: a.out Not tainted 5.4.0-rc2 #32
> 	NIP:  c00000000000de44 LR: c000000000034728 CTR: 0000000000000000
> 	REGS: c00000003fe7bd70 TRAP: 0700   Not tainted  (5.4.0-rc2)
> 	MSR:  8000000302a03031 <SF,VEC,VSX,FP,ME,IR,DR,LE,TM[SE]>  CR: 44000884  XER: 00000000
> 	CFAR: c00000000000dda4 IRQMASK: 0
> 	PACATMSCRATCH: 800000010280b033
> 	GPR00: c000000000034728 c000000f65a17c80 c000000001662800 00007fffacf3fd78
> 	GPR04: 0000000000001000 0000000000001000 0000000000000000 c000000f611f8af0
> 	GPR08: 0000000000000000 0000000078006001 0000000000000000 000c000000000000
> 	GPR12: c000000f611f84b0 c00000003ffcb200 0000000000000000 0000000000000000
> 	GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> 	GPR20: 0000000000000000 0000000000000000 0000000000000000 c000000f611f8140
> 	GPR24: 0000000000000000 00007fffacf3fd68 c000000f65a17d90 c000000f611f7800
> 	GPR28: c000000f65a17e90 c000000f65a17e90 c000000001685e18 00007fffacf3f000
> 	NIP [c00000000000de44] fast_exception_return+0xf4/0x1b0
> 	LR [c000000000034728] handle_rt_signal64+0x78/0xc50
> 	Call Trace:
> 	[c000000f65a17c80] [c000000000034710] handle_rt_signal64+0x60/0xc50 (unreliable)
> 	[c000000f65a17d30] [c000000000023640] do_notify_resume+0x330/0x460
> 	[c000000f65a17e20] [c00000000000dcc4] ret_from_except_lite+0x70/0x74
> 	Instruction dump:
> 	7c4ff120 e8410170 7c5a03a6 38400000 f8410060 e8010070 e8410080 e8610088
> 	60000000 60000000 e8810090 e8210078 <4c000024> 48000000 e8610178 88ed0989
> 	---[ end trace 93094aa44b442f87 ]---
> 
> The simplified sequence of events that triggers the above exception is:
> 
>   ...				# userspace in NON-TRANSACTIONAL state
>   tbegin			# userspace in TRANSACTIONAL state
>   signal delivery		# kernelspace in SUSPENDED state
>   handle_rt_signal64()
>     get_tm_stackpointer()
>       treclaim			# kernelspace in NON-TRANSACTIONAL state
>     __put_user()
>       page fault happens. We will never get back here because of the TM Bad Thing exception.
> 
>   page fault handling kicks in and we voluntarily preempt ourselves
>   do_page_fault()
>     __schedule()
>       __switch_to(other_task)
> 
>   our task is rescheduled and we recheckpoint because the thread's MSR[TS] was not cleared
>   __switch_to(our_task)
>     switch_to_tm()
>       tm_recheckpoint_new_task()
>         trechkpt			# kernelspace in SUSPENDED state
> 
>   The page fault handling resumes, but now we are in suspended transaction state
>   do_page_fault()    completes
>   rfid     <----- trying to get back where the page fault happened (we were non-transactional back then)
>   TM Bad Thing			# illegal transition from suspended to non-transactional
> 
> This patch fixes that issue by clearing the current thread's MSR[TS] just after
> treclaim in get_tm_stackpointer() so that we stay in non-transactional state in
> case we are preempted. In order to make treclaim and clearing the thread's
> MSR[TS] atomic from a preemption perspective when CONFIG_PREEMPT is set,
> preempt_disable/enable() is used. It's also necessary to save the previous
> value of the thread's MSR before get_tm_stackpointer() is called so that it can
> be exposed to the signal handler later in setup_tm_sigcontexts() to inform the
> userspace MSR at the moment of the signal delivery.
> 
> Found with tm-signal-context-force-tm kernel selftest.
> 
> v3: Subject and comment improvements.
> v2: Fix build failure when tm is disabled.
> 
> Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the signal context")
> Cc: stable@vger.kernel.org # v3.9
> Signed-off-by: Gustavo Luiz Duarte <gustavold@linux.ibm.com>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/2464cc4c345699adea52c7aef75707207cb8a2f6

cheers
