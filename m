Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A551D17DC27
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 10:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgCIJJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 05:09:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58275 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgCIJJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 05:09:05 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jBEPF-0004Dh-IA; Mon, 09 Mar 2020 10:09:01 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A737310408A; Mon,  9 Mar 2020 10:09:00 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org> <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com> <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com> <87a74s9ehb.fsf@nanos.tec.linutronix.de> <87wo7v8g4j.fsf@nanos.tec.linutronix.de> <877dzu8178.fsf@nanos.tec.linutronix.de> <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
Date:   Mon, 09 Mar 2020 10:09:00 +0100
Message-ID: <871rq199oz.fsf@nanos.tec.linutronix.de>
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
> On 09/03/20 07:57, Thomas Gleixner wrote:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>>
>> guest side:
>> 
>>    nmi()/mce() ...
>>    
>>         stash_crs();
>> 
>> +       stash_and_clear_apf_reason();
>> 
>>         ....
>> 
>> +       restore_apf_reason();
>> 
>> 	restore_cr2();
>> 
>> Too obvious, isn't it?
>
> Yes, this works but Andy was not happy about adding more
> save-and-restore to NMIs.  If you do not want to do that, I'm okay with
> disabling async page fault support for now.

I'm fine with doing that save/restore dance, but I have no strong
opinion either.

> Storing the page fault reason in memory was not a good idea.  Better
> options would be to co-opt the page fault error code (e.g. store the
> reason in bits 31:16, mark bits 15:0 with the invalid error code
> RSVD=1/P=0), or to use the virtualization exception area.

Memory store is not the problem. The real problem is hijacking #PF.

If you'd have just used a separate VECTOR_ASYNC_PF then none of these
problems would exist at all.

Thanks,

        tglx
