Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15AB21B37B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGJKuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:50:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:34464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgGJKuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:50:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3878AD75;
        Fri, 10 Jul 2020 10:50:19 +0000 (UTC)
Subject: Re: [PATCH] xen: don't reschedule in preemption off sections
To:     Jan Beulich <jbeulich@suse.com>
Cc:     xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sarah Newman <srn@prgmr.com>
References: <20200710075050.4769-1-jgross@suse.com>
 <988ff766-b7de-2e25-2524-c412379686fc@suse.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <742457cf-4892-0e85-2fc8-d2eb9f8a3a51@suse.com>
Date:   Fri, 10 Jul 2020 12:50:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <988ff766-b7de-2e25-2524-c412379686fc@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.20 11:49, Jan Beulich wrote:
> On 10.07.2020 09:50, Juergen Gross wrote:
>> For support of long running hypercalls xen_maybe_preempt_hcall() is
>> calling cond_resched() in case a hypercall marked as preemptible has
>> been interrupted.
>>
>> Normally this is no problem, as only hypercalls done via some ioctl()s
>> are marked to be preemptible. In rare cases when during such a
>> preemptible hypercall an interrupt occurs and any softirq action is
>> started from irq_exit(), a further hypercall issued by the softirq
>> handler will be regarded to be preemptible, too. This might lead to
>> rescheduling in spite of the softirq handler potentially having set
>> preempt_disable(), leading to splats like:
>>
>> BUG: sleeping function called from invalid context at drivers/xen/preempt.c:37
>> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 20775, name: xl
>> INFO: lockdep is turned off.
>> CPU: 1 PID: 20775 Comm: xl Tainted: G D W 5.4.46-1_prgmr_debug.el7.x86_64 #1
>> Call Trace:
>> <IRQ>
>> dump_stack+0x8f/0xd0
>> ___might_sleep.cold.76+0xb2/0x103
>> xen_maybe_preempt_hcall+0x48/0x70
>> xen_do_hypervisor_callback+0x37/0x40
>> RIP: e030:xen_hypercall_xen_version+0xa/0x20
>> Code: ...
>> RSP: e02b:ffffc900400dcc30 EFLAGS: 00000246
>> RAX: 000000000004000d RBX: 0000000000000200 RCX: ffffffff8100122a
>> RDX: ffff88812e788000 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffffffff83ee3ad0 R08: 0000000000000001 R09: 0000000000000001
>> R10: 0000000000000000 R11: 0000000000000246 R12: ffff8881824aa0b0
>> R13: 0000000865496000 R14: 0000000865496000 R15: ffff88815d040000
>> ? xen_hypercall_xen_version+0xa/0x20
>> ? xen_force_evtchn_callback+0x9/0x10
>> ? check_events+0x12/0x20
>> ? xen_restore_fl_direct+0x1f/0x20
>> ? _raw_spin_unlock_irqrestore+0x53/0x60
>> ? debug_dma_sync_single_for_cpu+0x91/0xc0
>> ? _raw_spin_unlock_irqrestore+0x53/0x60
>> ? xen_swiotlb_sync_single_for_cpu+0x3d/0x140
>> ? mlx4_en_process_rx_cq+0x6b6/0x1110 [mlx4_en]
>> ? mlx4_en_poll_rx_cq+0x64/0x100 [mlx4_en]
>> ? net_rx_action+0x151/0x4a0
>> ? __do_softirq+0xed/0x55b
>> ? irq_exit+0xea/0x100
>> ? xen_evtchn_do_upcall+0x2c/0x40
>> ? xen_do_hypervisor_callback+0x29/0x40
>> </IRQ>
>> ? xen_hypercall_domctl+0xa/0x20
>> ? xen_hypercall_domctl+0x8/0x20
>> ? privcmd_ioctl+0x221/0x990 [xen_privcmd]
>> ? do_vfs_ioctl+0xa5/0x6f0
>> ? ksys_ioctl+0x60/0x90
>> ? trace_hardirqs_off_thunk+0x1a/0x20
>> ? __x64_sys_ioctl+0x16/0x20
>> ? do_syscall_64+0x62/0x250
>> ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> Fix that by testing preempt_count() before calling cond_resched().
>>
>> In kernel 5.8 this can't happen any more due to the entry code rework.
>>
>> Reported-by: Sarah Newman <srn@prgmr.com>
>> Fixes: 0fa2f5cb2b0ecd8 ("sched/preempt, xen: Use need_resched() instead of should_resched()")
>> Cc: Sarah Newman <srn@prgmr.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   drivers/xen/preempt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/xen/preempt.c b/drivers/xen/preempt.c
>> index 17240c5325a3..6ad87b5c95ed 100644
>> --- a/drivers/xen/preempt.c
>> +++ b/drivers/xen/preempt.c
>> @@ -27,7 +27,7 @@ EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
>>   asmlinkage __visible void xen_maybe_preempt_hcall(void)
>>   {
>>   	if (unlikely(__this_cpu_read(xen_in_preemptible_hcall)
>> -		     && need_resched())) {
>> +		     && need_resched() && !preempt_count())) {
> 
> Doesn't this have the at least latent risk of hiding issues in
> other call trees (by no longer triggering logging like the one
> that has propmted this change)? Wouldn't it be better to save,
> clear, and restore the flag in one of xen_evtchn_do_upcall() or
> xen_do_hypervisor_callback()?

First regarding "risk of hiding issues": it seems as if lots of kernels
aren't even configured to trigger this logging. It would need
CONFIG_DEBUG_ATOMIC_SLEEP to be enabled and at least SUSE kernels don't
seem to have it on. I suspect the occasional xen_mc_flush() failures we
have seen are related to this problem.

And in theory saving, clearing and restoring the flag would be fine, but
it can't be done in a single function with the code flow as up to 5.7.
What would need to be done is to save and clear the flag in e.g.
__xen_evtchn_do_upcall() and to pass it to xen_maybe_preempt_hcall() as
a parameter. In xen_maybe_preempt_hcall() the passed flag value would
need to be used for the decision whether to call cond_resched() and then
the flag could be restored (after the cond_resched() call).

This is basically the code flow as in kernel 5.8, but the flag handling
would need to be spread over various source files.

A problem would be possible only in case there is a missing
preempt_disable() when doing a hypercall which should not be subject to
be interrupted by scheduling, but then a kernel configured with
preemption would already have a problem.

In order to keep this patch - which is for stable only, after all - as
simple as possible I'd rather leave it as is.


Juergen
