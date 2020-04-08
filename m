Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910AE1A2A79
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 22:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgDHUea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 16:34:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31217 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgDHUea (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 16:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586378069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=151LHWUJtSDB+75+jyNegOreKhf7IJmTVrlaiuCLhsY=;
        b=eO6BSIeQ4gPcDLDradVB9tbQEtIGRvOeKxuGm8y0VTjQ1geaYWAAMAZzdSK0HMvSQCM+uO
        b4fC81yR3M2VFowQib/EKHFgc59pYXFp7pxVaASeRSTLSXnk6AdPWsWSwrY3i7tnaeUTuL
        kZwePcFj+fhLGuvzi1eIueN8mSGkiow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-1QQRLG7LOPa-SnRwx8FAtA-1; Wed, 08 Apr 2020 16:34:27 -0400
X-MC-Unique: 1QQRLG7LOPa-SnRwx8FAtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B04107B114;
        Wed,  8 Apr 2020 20:34:26 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-85.rdu2.redhat.com [10.10.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA125DA84;
        Wed,  8 Apr 2020 20:34:25 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4583D2202B8; Wed,  8 Apr 2020 16:34:25 -0400 (EDT)
Date:   Wed, 8 Apr 2020 16:34:25 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408203425.GD93547@redhat.com>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d08hc0vz.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 08:01:36PM +0200, Thomas Gleixner wrote:
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
> >> 	kvm_mmu_set_spte_init_value(VMX_EPT_SUPPRESS_VE_BIT);
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

So IIUC, only one process on a vcpu could affort to relinquish cpu to
another task. If next task also triggers EPT violation, that will result
in VM exit (as previous #VE is not complete yet) and vcpu will be halted.

> 
> So you really don't worry about the guest CPU state at all. The guest
> side #VE handler has to decide what it wants from the host depending on
> it's internal state:
> 
>      - Suspend me and resume once the EPT fail is solved
> 
>      - Let me park the failing task and tell me once you resolved the
>        problem.
> 
> That's pretty straight forward and avoids the whole nonsense which the
> current mess contains. It completely avoids the allocation stuff as well
> as you need to use a PV page where the guest copies the VE information
> to.
> 
> The notification that a problem has been resolved needs to go through a
> separate vector which still has the IF=1 requirement obviously.

How is this vector decided between guest and host. Failure to fault in
page will be communicated through same vector?

Thanks
Vivek

