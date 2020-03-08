Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A112117D231
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 08:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgCHHXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 03:23:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56289 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgCHHXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 03:23:14 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAqHF-0003H3-MR; Sun, 08 Mar 2020 08:23:09 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 97952104096; Sun,  8 Mar 2020 08:23:08 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <87a74s9ehb.fsf@nanos.tec.linutronix.de>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org> <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com> <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com> <87a74s9ehb.fsf@nanos.tec.linutronix.de>
Date:   Sun, 08 Mar 2020 08:23:08 +0100
Message-ID: <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
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
> Andy Lutomirski <luto@kernel.org> writes:
>> On Sat, Mar 7, 2020 at 7:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>>> The host knows exactly when it injects a async PF and it can store CR2
>>> and reason of that async PF in flight.
>>>
>>> On the next VMEXIT it checks whether apf_reason is 0. If apf_reason is 0
>>> then it knows that the guest has read CR2 and apf_reason. All good
>>> nothing to worry about.
>>>
>>> If not it needs to be careful.
>>>
>>> As long as the apf_reason of the last async #PF is not cleared by the
>>> guest no new async #PF can be injected. That's already correct because
>>> in that case IF==0 which prevents a nested async #PF.
>>>
>>> If MCE, NMI trigger a real pagefault then the #PF injection needs to
>>> clear apf_reason and set the correct CR2. When that #PF returns then the
>>> old CR2 and apf_reason need to be restored.
>>
>> How is the host supposed to know when the #PF returns?  Intercepting
>> IRET sounds like a bad idea and, in any case, is not actually a
>> reliable indication that #PF returned.
>
> The host does not care about the IRET. It solely has to check whether
> apf_reason is 0 or not. That way it knows that the guest has read CR2
> and apf_reason.

Bah. I'm a moron. Of course it needs to trap the IRET of the #PF in
order to restore CR2 and apf_reason. Alternatively it could trap the CR2
read of #PF, but yes that's all nasty.

Thanks,

        tglx
