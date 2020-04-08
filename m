Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6941A2833
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 20:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgDHSBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 14:01:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50275 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgDHSBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 14:01:50 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMF17-0002Uv-PU; Wed, 08 Apr 2020 20:01:38 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id EE86010069D; Wed,  8 Apr 2020 20:01:36 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net> <87eeszjbe6.fsf@nanos.tec.linutronix.de> <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com> <874ktukhku.fsf@nanos.tec.linutronix.de> <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com> <20200408153413.GA11322@linux.intel.com> <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
Date:   Wed, 08 Apr 2020 20:01:36 +0200
Message-ID: <87d08hc0vz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 08/04/20 17:34, Sean Christopherson wrote:
>> On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
>>> Page-not-present async page faults are almost a perfect match for the
>>> hardware use of #VE (and it might even be possible to let the processor
>>> deliver the exceptions).
>> 
>> My "async" page fault knowledge is limited, but if the desired behavior is
>> to reflect a fault into the guest for select EPT Violations, then yes,
>> enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
>> KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
>> MMU page, otherwise not-present faults on zero-initialized EPTEs will get
>> reflected.
>> 
>> Attached a patch that does the prep work in the MMU.  The VMX usage would be:
>> 
>> 	kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
>> 
>> when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
>> initialize EPTEs.  32-bit could also be supported by doing memcpy() from
>> a static page.
>
> The complication is that (at least according to the current ABI) we
> would not want #VE to kick if the guest currently has IF=0 (and possibly
> CPL=0).  But the ABI is not set in stone, and anyway the #VE protocol is
> a decent one and worth using as a base for whatever PV protocol we design.

Forget the current pf async semantics (or the lack of). You really want
to start from scratch and igore the whole thing.

The charm of #VE is that the hardware can inject it and it's not nesting
until the guest cleared the second word in the VE information area. If
that word is not 0 then you get a regular vmexit where you suspend the
vcpu until the nested problem is solved.

So you really don't worry about the guest CPU state at all. The guest
side #VE handler has to decide what it wants from the host depending on
it's internal state:

     - Suspend me and resume once the EPT fail is solved

     - Let me park the failing task and tell me once you resolved the
       problem.

That's pretty straight forward and avoids the whole nonsense which the
current mess contains. It completely avoids the allocation stuff as well
as you need to use a PV page where the guest copies the VE information
to.

The notification that a problem has been resolved needs to go through a
separate vector which still has the IF=1 requirement obviously.

Thanks,

        tglx
