Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C203D1A2581
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgDHPic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 11:38:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbgDHPib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 11:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xC074y/p1nAzD7enAbs41h9l8M7sWD/sq+pOy6inQow=; b=KqXDu8M8IypbmDOirZzt/98zFg
        2pq2f067O6hcZJxbwtbx7LIwWzWaorrNBH4Fr9CbJtEWIpenZBDBNySuQK0gPYRzTJwxEUXMCTPp3
        xnTpAR+/9OXx2mLkT4m0CyZre+bsHC2yd8t/xjReyV2cCzzSkqdDp9cQy/634qoEpjFgn6UL2SUJz
        xiyHQMtvIhf6D5eP1GplYH7ZawEQvL16T7SokQH2E8PK66PvjNztdcT9C9j5Lc9n/wKXjtuhSYqEy
        H9vLe1D6zbMCBAZQFj/jofWr/xonbUVjWFeTdHyPQY2UhE+DpxV248lbNKujyvtnesl5zIpRmjKMp
        uzPcAy5g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMCmY-0006pB-FA; Wed, 08 Apr 2020 15:38:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A39903062C2;
        Wed,  8 Apr 2020 17:38:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 900262BB02700; Wed,  8 Apr 2020 17:38:24 +0200 (CEST)
Date:   Wed, 8 Apr 2020 17:38:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408153824.GO20730@hirez.programming.kicks-ass.net>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <87pncib06x.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pncib06x.fsf@nanos.tec.linutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 03:01:58PM +0200, Thomas Gleixner wrote:
> And it comes with restrictions:
> 
>     The Do Other Stuff event can only be delivered when guest IF=1.
> 
>     If guest IF=0 then the host has to suspend the guest until the
>     situation is resolved.
> 
>     The 'Situation resolved' event must also wait for a guest IF=1 slot.

Moo, can we pretty please already kill that ALWAYS and IF nonsense? That
results in that terrifyingly crap HLT loop. That needs to die with
extreme prejudice.

So the host only inject these OMFG_DOS things when the guest is in
luserspace -- which it can see in the VMCS state IIRC. And then using
#VE for the make-it-go signal is far preferred over the currentl #PF
abuse.

> > Page-not-present async page faults are almost a perfect match for the
> > hardware use of #VE (and it might even be possible to let the
> > processor deliver the exceptions).  There are other advantages:
> >
> > - the only real problem with using #PF (with or without
> > KVM_ASYNC_PF_SEND_ALWAYS) seems to be the NMI reentrancy issue, which
> > would not be there for #VE.
> >
> > - #VE are combined the right way with other exceptions (the
> > benign/contributory/pagefault stuff)
> >
> > - adjusting KVM and Linux to use #VE instead of #PF would be less than
> > 100 lines of code.
> 
> If you just want to solve Viveks problem, then its good enough. I.e. the
> file truncation turns the EPT entries into #VE convertible entries and
> the guest #VE handler can figure it out. This one can be injected
> directly by the hardware, i.e. you don't need a VMEXIT.

That sounds like something that doesn't actually need the whole
'async'/do-something-else-for-a-while crap, right? It's a #PF trap from
kernel space where we need to report fail.

> If you want the opportunistic do other stuff mechanism, then #VE has
> exactly the same problems as the existing async "PF". It's not magicaly
> making that go away.

We need to somehow have the guest teach the host how to tell if it can
inject that OMFG_DOS thing or not. Injecting it only to then instantly
exit again is stupid and expensive.

Clearly we don't want to expose preempt_count and make that ABI, but is
there some way we can push a snippet of code to the host that instructs
the host how to determine if it can sleep or not? I realize that pushing
actual x86 .text is a giant security problem, so perhaps a snipped of
BPF that the host can verify, which it can run on the guest image ?

Make it a hard error (guest cpu dies) to inject the OMFG_DOS signal on a
context that cannot put the task to sleep.
