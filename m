Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CEB17CF27
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 16:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgCGPrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 10:47:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55627 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCGPrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Mar 2020 10:47:08 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAbfL-0006eZ-M6; Sat, 07 Mar 2020 16:47:04 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7F7D0104088; Sat,  7 Mar 2020 16:47:01 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org> <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
Date:   Sat, 07 Mar 2020 16:47:01 +0100
Message-ID: <87ftek9ngq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:
> On Fri, Mar 6, 2020 at 6:26 PM Andy Lutomirski <luto@kernel.org> wrote:
>> +               /*
>> +                * We do not set KVM_ASYNC_PF_SEND_ALWAYS.  With the current
>> +                * KVM paravirt ABI, the following scenario is possible:
>> +                *
>> +                * #PF: async page fault (KVM_PV_REASON_PAGE_NOT_PRESENT)
>> +                *  NMI before CR2 or KVM_PF_REASON_PAGE_NOT_PRESENT
>> +                *   NMI accesses user memory, e.g. due to perf
>> +                *    #PF: normal page fault
>> +                *     #PF reads CR2 and apf_reason -- apf_reason should be 0
>> +                *
>> +                *  outer #PF reads CR2 and apf_reason -- apf_reason should be
>> +                *  KVM_PV_REASON_PAGE_NOT_PRESENT
>> +                *
>> +                * There is no possible way that both reads of CR2 and
>> +                * apf_reason get the correct values.  Fixing this would
>> +                * require paravirt ABI changes.
>> +                */
>> +
>
> Upon re-reading my own comment, I think the problem is real, but I
> don't think my patch fixes it.  The outer #PF could just as easily
> have come from user mode.  We may actually need the NMI code (and
> perhaps MCE and maybe #DB too) to save, clear, and restore apf_reason.
> If we do this, then maybe CPL0 async PFs are actually okay, but the
> semantics are so poorly defined that I'm not very confident about
> that.

I think even with the current mode this is fixable on the host side when
it keeps track of the state.

The host knows exactly when it injects a async PF and it can store CR2
and reason of that async PF in flight.

On the next VMEXIT it checks whether apf_reason is 0. If apf_reason is 0
then it knows that the guest has read CR2 and apf_reason. All good
nothing to worry about.

If not it needs to be careful.

As long as the apf_reason of the last async #PF is not cleared by the
guest no new async #PF can be injected. That's already correct because
in that case IF==0 which prevents a nested async #PF.

If MCE, NMI trigger a real pagefault then the #PF injection needs to
clear apf_reason and set the correct CR2. When that #PF returns then the
old CR2 and apf_reason need to be restored.

I tried to figure out whether any of this logic exists in the KVM code,
but I got completely lost in that code. Maybe I try later today again.

Thanks,

	tglx




