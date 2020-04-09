Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2195C1A2E83
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 06:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgDIEvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 00:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgDIEvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 00:51:12 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1321720BED
        for <stable@vger.kernel.org>; Thu,  9 Apr 2020 04:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586407872;
        bh=zL/sv2TnFIJcsZ2qzDSKXB1+v/r4O04Hzf+kLlRD5uM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=brDq42+AmbPxTcoT+JX097pz4y1ytIBS0yRdNpTqmslO0W5B+fZFLnKNDtoScaxn7
         58tAIs4txYUMc6vpLdZrt/1ecuql1v97bl54MQRlMzWM6UyzrvidDXg46b39HDGXhe
         fok5B7ZthGhCtddZoJIErgd6czecKHNk/FAuGelo=
Received: by mail-wm1-f46.google.com with SMTP id e26so2463011wmk.5
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 21:51:11 -0700 (PDT)
X-Gm-Message-State: AGi0PuYPidNcnQs5Aps8bbZWcVCPadrWOA/NxXt8azkv2YPZjrsqgR76
        371lG9wlhuthy6NNs0cRLhf/ialeVl8zIgRZi/mgyg==
X-Google-Smtp-Source: APiQypKr49vnhnHEoFubJa3hBO/w1Qt2bg9d+RaftXenVgRyZDqyimV5rs4ZBOhDQYb7yQpUNIx/wET63DxM6De5mSI=
X-Received: by 2002:a1c:1904:: with SMTP id 4mr7903255wmz.21.1586407870332;
 Wed, 08 Apr 2020 21:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de> <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de> <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com> <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87d08hc0vz.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 8 Apr 2020 21:50:58 -0700
X-Gmail-Original-Message-ID: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Message-ID: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 8, 2020 at 11:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Paolo Bonzini <pbonzini@redhat.com> writes:
> > On 08/04/20 17:34, Sean Christopherson wrote:
> >> On Wed, Apr 08, 2020 at 10:23:58AM +0200, Paolo Bonzini wrote:
> >>> Page-not-present async page faults are almost a perfect match for the
> >>> hardware use of #VE (and it might even be possible to let the processor
> >>> deliver the exceptions).
> >>
> >> My "async" page fault knowledge is limited, but if the desired behavior is
> >> to reflect a fault into the guest for select EPT Violations, then yes,
> >> enabling EPT Violation #VEs in hardware is doable.  The big gotcha is that
> >> KVM needs to set the suppress #VE bit for all EPTEs when allocating a new
> >> MMU page, otherwise not-present faults on zero-initialized EPTEs will get
> >> reflected.
> >>
> >> Attached a patch that does the prep work in the MMU.  The VMX usage would be:
> >>
> >>      kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
> >>
> >> when EPT Violation #VEs are enabled.  It's 64-bit only as it uses stosq to
> >> initialize EPTEs.  32-bit could also be supported by doing memcpy() from
> >> a static page.
> >
> > The complication is that (at least according to the current ABI) we
> > would not want #VE to kick if the guest currently has IF=0 (and possibly
> > CPL=0).  But the ABI is not set in stone, and anyway the #VE protocol is
> > a decent one and worth using as a base for whatever PV protocol we design.
>
> Forget the current pf async semantics (or the lack of). You really want
> to start from scratch and igore the whole thing.
>
> The charm of #VE is that the hardware can inject it and it's not nesting
> until the guest cleared the second word in the VE information area. If
> that word is not 0 then you get a regular vmexit where you suspend the
> vcpu until the nested problem is solved.

Can you point me at where the SDM says this?

Anyway, I see two problems with #VE, one big and one small.  The small
(or maybe small) one is that any fancy protocol where the guest
returns from an exception by doing, logically:

Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
IRET;

is fundamentally racy.  After we say we're done and before IRET, we
can be recursively reentered.  Hi, NMI!

The big problem is that #VE doesn't exist on AMD, and I really think
that any fancy protocol we design should work on AMD.  I have no
problem with #VE being a nifty optimization to the protocol on Intel,
but it should *work* without #VE.

>
> So you really don't worry about the guest CPU state at all. The guest
> side #VE handler has to decide what it wants from the host depending on
> it's internal state:
>
>      - Suspend me and resume once the EPT fail is solved

I'm not entirely convinced this is better than the HLT loop.  It's
*prettier*, but the HLT loop avoids an extra hypercall and has the
potentially useful advantage that the guest can continue to process
interrupts even if it is unable to make progress otherwise.

Anyway, the whole thing can be made to work reasonably well without
#VE, #MC or any other additional special exception, like this:

First, when the guest accesses a page that is not immediately
available (paged out or failed), the host attempts to deliver the
"page not present -- try to do other stuff" event.  This event has an
associated per-vCPU data structure along these lines:

struct page_not_present_data {
  u32 inuse;  /* 1: the structure is in use.  0: free */
  u32 token;
  u64 gpa;
  u64 gva;  /* if known, and there should be a way to indicate that
it's not known. */
};

Only the host ever changes inuse from 0 to 1 and only the guest ever
changes inuse from 1 to 0.

The "page not present -- try to do other stuff" event has interrupt
semantics -- it is only delivered if the vCPU can currently receive an
interrupt.  This means IF = 1 and STI and MOV SS shadows are not
active.  Arguably TPR should be checked too.  It is also only
delivered if page_not_present_data.inuse == 0 and if there are tokens
available -- see below.  If the event can be delivered, then
page_not_present_data is filled out and the event is delivered.  If
the event is not delivered, then one of three things happens:

a) If the page not currently known to be failed (e.g. paged out or the
host simply does not know yet until it does some IO), then the vCPU
goes to sleep until the host is ready.
b) If the page is known to be failed, and no fancy #VE / #MC is
available, then the guest is killed and the host logs an error.
c) If some fancy recovery mechanism is implemented, which is optional,
then the guest gets an appropriate fault.

If a page_not_present event is delivered, then the host promises to
eventually resolve it.  Resolving it looks like this:

struct page_not_present_resolution {
  u32 result;  /* 0: guest should try again.  1: page is failed */
  u32 token;
};

struct page_not_present_resolutions {
  struct page_not_present_resolution events[N];
  u32 head, tail;
};

Only N page-not-presents can be outstanding and unresolved at a time.
it is entirely legal for the host to write the resolution to the
resolution list before delivering page-not-present.

When a page-not-present is resolved, the host writes the outcome to
the page_not_present_resolutions ring.  If there is no space, this
means that either the host or guest messed up (the host will not
allocate more tokens than can fit in the ring) and the guest is
killed.  The host also sends the guest an interrupt.  This is a
totally normal interrupt.

If the guest gets a "page is failed" resolution, the page is failed.
If the guest accesses the failed page again, then the host will try to
send a page-not-present event again.  If there is no space in the
ring, then the rules above are followed.

This will allow the sensible cases of memory failure to be recovered
by the guest without the introduction of any super-atomic faults. :)


Obviously there is more than one way to rig up the descriptor ring.
My proposal above is just one way to do it, not necessarily the best
way.
