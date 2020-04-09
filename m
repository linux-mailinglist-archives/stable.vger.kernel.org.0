Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB8E1A38EE
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 19:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDIRcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 13:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgDIRcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 13:32:53 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5859420B1F
        for <stable@vger.kernel.org>; Thu,  9 Apr 2020 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586453573;
        bh=IBuZEgijyAZREsl+G4BQjvkNizxCg7cks8fO++AV2XA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kFEzwXHDig+6mpRJP27Lvw+9no7VIbkjMrVguBlJqMoPADnJXy15cQD67IadXBR5u
         fxXeDn5OkQ/p+8cSUhhW+LeX5Dh3Jgzhnb+ybqMccG8bSjw1lgwgksU/TZz20gZ/64
         xInCI3KMBKixQaZsTEqS33BJKp2UqR6jeIxy3QGk=
Received: by mail-wr1-f53.google.com with SMTP id 31so12860114wre.5
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 10:32:53 -0700 (PDT)
X-Gm-Message-State: AGi0PuauJO5/4UZKozscA1wpa/PKbHp+XXbzpXhgHGkskOcBWwb5cykS
        2jZhy22KMd7681Mh0YTm8B4fu1cjNjtZ5aXfX91+9g==
X-Google-Smtp-Source: APiQypLEiHQsMq8szXbLnpQbM1VupAPJctZFhnFSSXM3V5XoGXOx1XbOz0uCtxrbjmBSCYE2gAQxGXqRHjzPLG1/z74=
X-Received: by 2002:adf:aad7:: with SMTP id i23mr254511wrc.184.1586453571673;
 Thu, 09 Apr 2020 10:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <c09dd91f-c280-85a6-c2a2-d44a0d378bbc@redhat.com>
 <4EB5D96F-F322-45BB-9169-6BF932D413D4@amacapital.net> <931f6e6d-ac17-05f9-0605-ac8f89f40b2b@redhat.com>
In-Reply-To: <931f6e6d-ac17-05f9-0605-ac8f89f40b2b@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 9 Apr 2020 10:32:39 -0700
X-Gmail-Original-Message-ID: <CALCETrUpWBKHHyfMoqD2ZT3CnDdguNnK=KoZiTmN5PnbnD_k0A@mail.gmail.com>
Message-ID: <CALCETrUpWBKHHyfMoqD2ZT3CnDdguNnK=KoZiTmN5PnbnD_k0A@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Tony.  I'm adding you because, despite the fact that everyone in
this thread is allergic to #MC, this seems to be one of your favorite
topics :)

> On Apr 9, 2020, at 8:17 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> =EF=BB=BFOn 09/04/20 17:03, Andy Lutomirski wrote:
>>> No, I think we wouldn't use a paravirt #VE at this point, we would
>>> use the real thing if available.
>>>
>>> It would still be possible to switch from the IST to the main
>>> kernel stack before writing 0 to the reentrancy word.
>>
>> Almost but not quite. We do this for NMI-from-usermode, and it=E2=80=99s
>> ugly. But we can=E2=80=99t do this for NMI-from-kernel or #VE-from-kerne=
l
>> because there might not be a kernel stack.  Trying to hack around
>> this won=E2=80=99t be pretty.
>>
>> Frankly, I think that we shouldn=E2=80=99t even try to report memory fai=
lure
>> to the guest if it happens with interrupts off. Just kill the guest
>> cleanly and keep it simple. Or inject an intentionally unrecoverable
>> IST exception.
>
> But it would be nice to use #VE for all host-side page faults, not just
> for memory failure.
>
> So the solution would be the same as for NMIs, duplicating the stack
> frame and patching the outer handler's stack from the recursive #VE
> (https://lwn.net/Articles/484932/).  It's ugly but it's a known ugliness.
>
>

Believe me, I know all about how ugly it is, since I=E2=80=99m the one who
fixed most of the bugs in the first few implementations.  And, before
I wrote or ack any such thing for #VE, I want to know why.  What,
exactly, is a sufficiently strong motivation for using #VE *at all*
that Linux should implement a #VE handler?

As I see it, #VE has several downsides:

1. Intel only.

2. Depending on precisely what it's used for, literally any memory
access in the kernel can trigger it as a fault.  This means that it
joins NMI and #MC (and, to a limited extent, #DB) in the horrible
super-atomic-happens-in-bad-contexts camp.  IST is mandatory, and IST
is not so great.

3. Just like NMI and MCE, it comes with a fundamentally broken
don't-recurse-me mechanism.

If we do support #VE, I would suggest we do it roughly like this.  The
#VE handler is a regular IST entry -- there's a single IST stack, and
#VE from userspace stack-switches to the regular kernel stack.  The C
handler (do_virtualization_exception?) is permitted to panic if
something is horribly wrong, but is *not* permitted to clear the word
at byte 4 to re-enable #VE.  Instead, it does something to trigger a
deferred re-enable.  For example, it sends IPI to self and the IPI
handler clears the magic re-enable flag.

There are definitely horrible corner cases here.  For example, suppose
user code mmaps() some kind of failable memory (due to NVDIMM hardware
failures, truncation, whatever).  Then user code points RBP at it and
we get a perf NMI.  Now the perf code tries to copy_from_user_nmi()
the user stack and hits the failure.  It gets #MC or #VE or some
paravirt thing.  Now we're in a situation where we got an IST
exception in the middle of NMI processing and we're expected to do
something intelligent about it.  Sure, we can invoke the extable
handler, but it's not really clear how to recover if we somehow hit
the same type of failure again in the same NMI.

A model that could actually work, perhaps for #VE and #MC, is to have
the extable code do the re-enabling.  So ex_handler_uaccess() and
ex_handler_mcsafe() will call something like rearm_memory_failure(),
and that will do whatever is needed to re-arm the specific memory
failure reporting mechanism in use.

But, before I touch that with a ten-foot pole, I want to know *why*.
What's the benefit?  Why do we want convertible EPT violations?
