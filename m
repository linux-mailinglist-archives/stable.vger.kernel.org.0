Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183F524AF2A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 08:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgHTGUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 02:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTGUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 02:20:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 712702075E;
        Thu, 20 Aug 2020 06:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597904420;
        bh=Y8ZGx0NT8knWFeR0USDpgJQGE3ZOUB1sx6B1FrzP2Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kaTJNaxEydMFrx4Jao0fP3HcPUj3rXRoovHRkJClWO7VT03GMzsmwn/0HD91nbfSk
         zQk1GExNT2dQmei7usc5EuFLzFXHxkLhSVN/YdtWkcN9BrfHt5CEP+m6hxu9Zl9dKr
         fNI1wn2Py41IjCtBV+b0HE0moGa0jZU2MqW6Snvo=
Date:   Thu, 20 Aug 2020 08:20:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     Sarah Newman <srn@prgmr.com>, Jan Beulich <jbeulich@suse.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Chris Brannon <cmb@prgmr.com>
Subject: Re: [PATCH] xen: don't reschedule in preemption off sections
Message-ID: <20200820062017.GA1876938@kroah.com>
References: <20200710075050.4769-1-jgross@suse.com>
 <988ff766-b7de-2e25-2524-c412379686fc@suse.com>
 <742457cf-4892-0e85-2fc8-d2eb9f8a3a51@suse.com>
 <af6db1b7-7802-0b2e-eb5f-ce69533b771f@suse.com>
 <97b15bd2-11f0-b530-dc07-b7d523bf88a2@suse.com>
 <9b822b7b-5bbe-1714-843f-3ec5a0d1673b@prgmr.com>
 <4f33a18e-3491-d6ff-63bc-9bc619bd88cd@suse.com>
 <20200820054419.GA1874724@kroah.com>
 <446f02fb-119b-ae49-f812-74a31d07b08f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <446f02fb-119b-ae49-f812-74a31d07b08f@suse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 07:58:55AM +0200, Jürgen Groß wrote:
> On 20.08.20 07:44, Greg Kroah-Hartman wrote:
> > On Thu, Aug 20, 2020 at 07:13:00AM +0200, Jürgen Groß wrote:
> > > On 19.08.20 18:57, Sarah Newman wrote:
> > > > On 7/10/20 5:01 AM, Jürgen Groß wrote:
> > > > > On 10.07.20 13:55, Jan Beulich wrote:
> > > > > > On 10.07.2020 12:50, Jürgen Groß wrote:
> > > > > > > On 10.07.20 11:49, Jan Beulich wrote:
> > > > > > > > On 10.07.2020 09:50, Juergen Gross wrote:
> > > > > > > > > For support of long running hypercalls xen_maybe_preempt_hcall() is
> > > > > > > > > calling cond_resched() in case a hypercall marked as preemptible has
> > > > > > > > > been interrupted.
> > > > > > > > > 
> > > > > > > > > Normally this is no problem, as only hypercalls done
> > > > > > > > > via some ioctl()s
> > > > > > > > > are marked to be preemptible. In rare cases when during such a
> > > > > > > > > preemptible hypercall an interrupt occurs and any softirq action is
> > > > > > > > > started from irq_exit(), a further hypercall issued by the softirq
> > > > > > > > > handler will be regarded to be preemptible, too. This might lead to
> > > > > > > > > rescheduling in spite of the softirq handler potentially having set
> > > > > > > > > preempt_disable(), leading to splats like:
> > > > > > > > > 
> > > > > > > > > BUG: sleeping function called from invalid context
> > > > > > > > > at drivers/xen/preempt.c:37
> > > > > > > > > in_atomic(): 1, irqs_disabled(): 0, non_block: 0,
> > > > > > > > > pid: 20775, name: xl
> > > > > > > > > INFO: lockdep is turned off.
> > > > > > > > > CPU: 1 PID: 20775 Comm: xl Tainted: G D W
> > > > > > > > > 5.4.46-1_prgmr_debug.el7.x86_64 #1
> > > > > > > > > Call Trace:
> > > > > > > > > <IRQ>
> > > > > > > > > dump_stack+0x8f/0xd0
> > > > > > > > > ___might_sleep.cold.76+0xb2/0x103
> > > > > > > > > xen_maybe_preempt_hcall+0x48/0x70
> > > > > > > > > xen_do_hypervisor_callback+0x37/0x40
> > > > > > > > > RIP: e030:xen_hypercall_xen_version+0xa/0x20
> > > > > > > > > Code: ...
> > > > > > > > > RSP: e02b:ffffc900400dcc30 EFLAGS: 00000246
> > > > > > > > > RAX: 000000000004000d RBX: 0000000000000200 RCX: ffffffff8100122a
> > > > > > > > > RDX: ffff88812e788000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > > > > > > RBP: ffffffff83ee3ad0 R08: 0000000000000001 R09: 0000000000000001
> > > > > > > > > R10: 0000000000000000 R11: 0000000000000246 R12: ffff8881824aa0b0
> > > > > > > > > R13: 0000000865496000 R14: 0000000865496000 R15: ffff88815d040000
> > > > > > > > > ? xen_hypercall_xen_version+0xa/0x20
> > > > > > > > > ? xen_force_evtchn_callback+0x9/0x10
> > > > > > > > > ? check_events+0x12/0x20
> > > > > > > > > ? xen_restore_fl_direct+0x1f/0x20
> > > > > > > > > ? _raw_spin_unlock_irqrestore+0x53/0x60
> > > > > > > > > ? debug_dma_sync_single_for_cpu+0x91/0xc0
> > > > > > > > > ? _raw_spin_unlock_irqrestore+0x53/0x60
> > > > > > > > > ? xen_swiotlb_sync_single_for_cpu+0x3d/0x140
> > > > > > > > > ? mlx4_en_process_rx_cq+0x6b6/0x1110 [mlx4_en]
> > > > > > > > > ? mlx4_en_poll_rx_cq+0x64/0x100 [mlx4_en]
> > > > > > > > > ? net_rx_action+0x151/0x4a0
> > > > > > > > > ? __do_softirq+0xed/0x55b
> > > > > > > > > ? irq_exit+0xea/0x100
> > > > > > > > > ? xen_evtchn_do_upcall+0x2c/0x40
> > > > > > > > > ? xen_do_hypervisor_callback+0x29/0x40
> > > > > > > > > </IRQ>
> > > > > > > > > ? xen_hypercall_domctl+0xa/0x20
> > > > > > > > > ? xen_hypercall_domctl+0x8/0x20
> > > > > > > > > ? privcmd_ioctl+0x221/0x990 [xen_privcmd]
> > > > > > > > > ? do_vfs_ioctl+0xa5/0x6f0
> > > > > > > > > ? ksys_ioctl+0x60/0x90
> > > > > > > > > ? trace_hardirqs_off_thunk+0x1a/0x20
> > > > > > > > > ? __x64_sys_ioctl+0x16/0x20
> > > > > > > > > ? do_syscall_64+0x62/0x250
> > > > > > > > > ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > > > > > 
> > > > > > > > > Fix that by testing preempt_count() before calling cond_resched().
> > > > > > > > > 
> > > > > > > > > In kernel 5.8 this can't happen any more due to the
> > > > > > > > > entry code rework.
> > > > > > > > > 
> > > > > > > > > Reported-by: Sarah Newman <srn@prgmr.com>
> > > > > > > > > Fixes: 0fa2f5cb2b0ecd8 ("sched/preempt, xen: Use
> > > > > > > > > need_resched() instead of should_resched()")
> > > > > > > > > Cc: Sarah Newman <srn@prgmr.com>
> > > > > > > > > Signed-off-by: Juergen Gross <jgross@suse.com>
> > > > > > > > > ---
> > > > > > > > >     drivers/xen/preempt.c | 2 +-
> > > > > > > > >     1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/drivers/xen/preempt.c b/drivers/xen/preempt.c
> > > > > > > > > index 17240c5325a3..6ad87b5c95ed 100644
> > > > > > > > > --- a/drivers/xen/preempt.c
> > > > > > > > > +++ b/drivers/xen/preempt.c
> > > > > > > > > @@ -27,7 +27,7 @@ EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
> > > > > > > > >     asmlinkage __visible void xen_maybe_preempt_hcall(void)
> > > > > > > > >     {
> > > > > > > > >         if (unlikely(__this_cpu_read(xen_in_preemptible_hcall)
> > > > > > > > > -             && need_resched())) {
> > > > > > > > > +             && need_resched() && !preempt_count())) {
> > > > > > > > 
> > > > > > > > Doesn't this have the at least latent risk of hiding issues in
> > > > > > > > other call trees (by no longer triggering logging like the one
> > > > > > > > that has propmted this change)? Wouldn't it be better to save,
> > > > > > > > clear, and restore the flag in one of xen_evtchn_do_upcall() or
> > > > > > > > xen_do_hypervisor_callback()?
> > > > > > > 
> > > > > > > First regarding "risk of hiding issues": it seems as if lots of kernels
> > > > > > > aren't even configured to trigger this logging. It would need
> > > > > > > CONFIG_DEBUG_ATOMIC_SLEEP to be enabled and at least SUSE kernels don't
> > > > > > > seem to have it on. I suspect the occasional xen_mc_flush() failures we
> > > > > > > have seen are related to this problem.
> > > > > > > 
> > > > > > > And in theory saving, clearing and restoring the flag would
> > > > > > > be fine, but
> > > > > > > it can't be done in a single function with the code flow as up to 5.7.
> > > > > > > What would need to be done is to save and clear the flag in e.g.
> > > > > > > __xen_evtchn_do_upcall() and to pass it to xen_maybe_preempt_hcall() as
> > > > > > > a parameter. In xen_maybe_preempt_hcall() the passed flag value would
> > > > > > > need to be used for the decision whether to call
> > > > > > > cond_resched() and then
> > > > > > > the flag could be restored (after the cond_resched() call).
> > > > > > 
> > > > > > I'm afraid I don't follow: If __xen_evtchn_do_upcall() cleared the flag,
> > > > > > xen_maybe_preempt_hcall() would amount to a no-op (up and until the
> > > > > > flag's prior value would get restored), wouldn't it? No need to pass
> > > > > > anything into there.
> > > > > 
> > > > > The problem is after __xen_evtchn_do_upcall() restoring the flag.
> > > > > As soon as irq_exit() is being called (either by xen_evtchn_do_upcall()
> > > > > or by the caller of xen_hvm_evtchn_do_upcall()) softirq handling might
> > > > > be executed resulting in another hypercall, which might be preempted
> > > > > afterwards. And this is the case which happened in the original
> > > > > report by Sarah.
> > > > 
> > > > Tested-by: Chris Brannon <cmb@prgmr.com>
> > > > 
> > > > We're no longer observing this bug. We've been running this on a test
> > > > system for about 3 weeks. Is it possible to merge?
> > > 
> > > Greg, could you please take the patch for stable?
> > 
> > What is the git commit id of the patch in Linus's tree?
> 
> There is none, as the issue was discovered only when the upstream
> kernel (5.8 at this time) was already modified in a way which would
> make the issue go away.
> 
> Backporting those changes to stable (all the x86 entry code
> modifications of 5.8, summing up to IIRC more than 100 patches)
> would be not practical IMO.

Ok, can someone please resend this patch, with all of the gathered
tested-by and the like, and explain this in the changelog text so it is
obvious?

> > And what stable tree(s) should it go to?
> 
> The issue was introduced in 4.3 (see Fixes tag of the patch), so all
> stable kernels down to that.

So older than 5.8, ok, again, can that go in the changelog text?  This
is a long thread to have to dig that out of...

thanks,

greg k-h
