Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009A417D975
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 07:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgCIG5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 02:57:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57846 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIG5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 02:57:52 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jBCMG-00010u-G5; Mon, 09 Mar 2020 07:57:48 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id BEB1F10408A; Mon,  9 Mar 2020 07:57:47 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org> <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com> <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com> <87a74s9ehb.fsf@nanos.tec.linutronix.de> <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
Date:   Mon, 09 Mar 2020 07:57:47 +0100
Message-ID: <877dzu8178.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Thomas Gleixner <tglx@linutronix.de> writes:
>> Andy Lutomirski <luto@kernel.org> writes:
>>> On Sat, Mar 7, 2020 at 7:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>>>> The host knows exactly when it injects a async PF and it can store CR2
>>>> and reason of that async PF in flight.
>>>>
>>>> On the next VMEXIT it checks whether apf_reason is 0. If apf_reason is 0
>>>> then it knows that the guest has read CR2 and apf_reason. All good
>>>> nothing to worry about.
>>>>
>>>> If not it needs to be careful.
>>>>
>>>> As long as the apf_reason of the last async #PF is not cleared by the
>>>> guest no new async #PF can be injected. That's already correct because
>>>> in that case IF==0 which prevents a nested async #PF.
>>>>
>>>> If MCE, NMI trigger a real pagefault then the #PF injection needs to
>>>> clear apf_reason and set the correct CR2. When that #PF returns then the
>>>> old CR2 and apf_reason need to be restored.
>>>
>>> How is the host supposed to know when the #PF returns?  Intercepting
>>> IRET sounds like a bad idea and, in any case, is not actually a
>>> reliable indication that #PF returned.
>>
>> The host does not care about the IRET. It solely has to check whether
>> apf_reason is 0 or not. That way it knows that the guest has read CR2
>> and apf_reason.
>
> Bah. I'm a moron. Of course it needs to trap the IRET of the #PF in
> order to restore CR2 and apf_reason. Alternatively it could trap the CR2
> read of #PF, but yes that's all nasty.

Some hours or sleep and not staring at this meess later and while
reading the leaves of my morning tea:

guest side:

   nmi()/mce() ...
   
        stash_crs();

+       stash_and_clear_apf_reason();

        ....

+       restore_apf_reason();

	restore_cr2();

Too obvious, isn't it?

Thanks,

        tglx
