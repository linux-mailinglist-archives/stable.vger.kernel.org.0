Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DFF1A2C18
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 01:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDHXHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 19:07:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50951 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHXHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 19:07:00 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMJmV-0005lr-S9; Thu, 09 Apr 2020 01:06:52 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 4E299101150; Thu,  9 Apr 2020 01:06:51 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <20200408203425.GD93547@redhat.com>
Date:   Thu, 09 Apr 2020 01:06:51 +0200
Message-ID: <875ze9r304.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
> On Wed, Apr 08, 2020 at 08:01:36PM +0200, Thomas Gleixner wrote:
>> Forget the current pf async semantics (or the lack of). You really want
>> to start from scratch and igore the whole thing.
>> 
>> The charm of #VE is that the hardware can inject it and it's not nesting
>> until the guest cleared the second word in the VE information area. If
>> that word is not 0 then you get a regular vmexit where you suspend the
>> vcpu until the nested problem is solved.
>
> So IIUC, only one process on a vcpu could affort to relinquish cpu to
> another task. If next task also triggers EPT violation, that will result
> in VM exit (as previous #VE is not complete yet) and vcpu will be
> halted.

No. The guest #VE handler reads VE information, stores it into a PV page
which is used to communicate with the host, invokes the hypercall and
clears word1 so a consecutive #VE can be handled.

If the hypercall is telling the host to suspend the guest (e.g. because
the exception hit an interrupt or preemption disabled region where
scheduling is not possible) then the host suspends the vCPU until the
EPT issue is fixed. Before that hypercall returns the state of the
recursion prevention word is irrelevant as the vCPU is not running, so
it's fine to clear it afterwards.

If the hypercall is telling the host that it can schedule and do
something else, then the word is cleared after the hypercall
returns. This makes sure that the host has gathered the information
before another VE can be injected.

TBH, I really was positively surprised that this HW mechanism actually
makes sense. It prevents the following situation:

  1) Guest triggers a EPT fail

  2) HW injects #VE sets VE info

  3) Guest handles #VE and before being able to gather the VE info data
     it triggers another EPT fail

  4) HW injects #VE sets VE info -> FAIL

So if we clear the reentrancy protection after saving the info in the
PV page and after the hypercall returns, it's guaranteed that the above
results in:

  1) Guest triggers a EPT fail

  2) HW injects #VE sets VE info

  3) Guest handles #VE and before being able to gather the VE info data
     and clearing the reentrancy protection it triggers another EPT fail

  4) VMEXIT which needs to be handled by suspending the vCPU, solving
     the issue and resuming it, which allows it to handle the original
     fail #1

>> So you really don't worry about the guest CPU state at all. The guest
>> side #VE handler has to decide what it wants from the host depending on
>> it's internal state:
>> 
>>      - Suspend me and resume once the EPT fail is solved
>> 
>>      - Let me park the failing task and tell me once you resolved the
>>        problem.
>> 
>> That's pretty straight forward and avoids the whole nonsense which the
>> current mess contains. It completely avoids the allocation stuff as well
>> as you need to use a PV page where the guest copies the VE information
>> to.
>> 
>> The notification that a problem has been resolved needs to go through a
>> separate vector which still has the IF=1 requirement obviously.
>
> How is this vector decided between guest and host.

That's either a fixed vector which then becomes ABI or the guest tells
the host via some PV/hypercall interface that it can handle #VE and that
the vector for notification is number X.

> Failure to fault in page will be communicated through same
> vector?

The PV page which communicates the current and eventually pending EPT
fails to the host is also the communication mechanism for the outcome.

Lets assume that the PV page contains an array of guest/host
communication data structures:

struct ve_info {
	struct ve_hw_info	hw_info;
        unsigned long		state;
        struct rcu_wait         wait;
);

The PV page looks like this:

struct ve_page {
	struct ve_info		info[N_ENTRIES];
        unsigned int		guest_current;
        unsigned int		host_current;
        unsigned long		active[BITS_TO_LONGS(N_ENTRIES)];
};

The #VE handler does:

        struct ve_page *vp = this_cpu_ptr(&ve_page);
        struct ve_info *info;
        bool can_continue;

        idx = find_first_zero_bit(vp->active, N_ENTRIES);
        BUG_ON(idx >= N_ENTRIES);
        set_bit(idx, vp->active);
        info = vp->info + idx;

        copy_ve_info(&info->hw_info, ve_hwinfo);
        vp->guest_current = idx;

        if (test_and_set_thread_flag(TIF_IN_VE) || bitmap_full(vp->active, N_ENTRIES))
                can_continue = false;
        else
                can_continue = user_mode(regs) || preemptible();

        if (can_continue) {
                info->state = CAN_CONTINUE;
        	hypercall_ve();
                ve_hwinfo.reentrancy_protect = 0;
                rcuwait_wait_event(&info->wait, info->state != CAN_CONTINUE, TASK_IDLE);
        } else {        
                info->state = SUSPEND_ME;
        	hypercall_ve();
                ve_hwinfo.reentrancy_protect = 0;
	}

	state = info->state;
        info->state = NONE;
        clear_bit(idx, vp->active);

        switch (state) {
        case RESOLVED:
        	break;

        case FAIL:
        	if (user_mode(regs))
                	send_signal(.....);
                else if (!fixup_exception())
                	panic("I'm toast");
                break;

        default:
        	panic("Confused");
        }
        
        clear_thread_flag(TIF_IN_VE);
        
Now the host completion does:

        struct ve_page *vp = vcpu->ve_page;
        struct ve_info *info = vp->info + idx;

        state = info->state;
        info->state = resolved_state;

        switch (state) {
        case SUSPEND_ME:
        	resume_vcpu(vcpu);
                break;
        case CAN_CONTINUE:
        	queue_completion(vcpu, idx);
                break;
        default:
                kill_guest();
        }

and the host completion injection which handles the queued completion
when guest IF=0 does:

        struct ve_page *vp = vcpu->ve_page;

        vp->host_current = idx;
        inject_ve_complete(vcpu);

The guest completion does:

        struct ve_page *vp = this_cpu_ptr(&ve_page);
        struct ve_info *info;

        info = vp->info + vp->host_current;
        rcuwait_wake_up(&info->wait);

There are a bunch of life time issues to think about (not rocket
science), but you get the idea.

Thanks,

        tglx
