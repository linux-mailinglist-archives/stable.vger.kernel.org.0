Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E52517E803
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCITFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:05:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60013 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbgCITFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:05:23 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jBNiJ-0005bg-Ev; Mon, 09 Mar 2020 20:05:19 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 4BE8010408A; Mon,  9 Mar 2020 20:05:18 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org> <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com> <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com> <87a74s9ehb.fsf@nanos.tec.linutronix.de> <87wo7v8g4j.fsf@nanos.tec.linutronix.de> <877dzu8178.fsf@nanos.tec.linutronix.de> <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com> <871rq199oz.fsf@nanos.tec.linutronix.de> <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
Date:   Mon, 09 Mar 2020 20:05:18 +0100
Message-ID: <87d09l73ip.fsf@nanos.tec.linutronix.de>
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
> On Mon, Mar 9, 2020 at 2:09 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> > Yes, this works but Andy was not happy about adding more
>> > save-and-restore to NMIs.  If you do not want to do that, I'm okay with
>> > disabling async page fault support for now.
>>
>> I'm fine with doing that save/restore dance, but I have no strong
>> opinion either.
>>
>> > Storing the page fault reason in memory was not a good idea.  Better
>> > options would be to co-opt the page fault error code (e.g. store the
>> > reason in bits 31:16, mark bits 15:0 with the invalid error code
>> > RSVD=1/P=0), or to use the virtualization exception area.
>>
>> Memory store is not the problem. The real problem is hijacking #PF.
>>
>> If you'd have just used a separate VECTOR_ASYNC_PF then none of these
>> problems would exist at all.
>>
>
> I'm okay with the save/restore dance, I guess.  It's just yet more
> entry crud to deal with architecture nastiness, except that this
> nastiness is 100% software and isn't Intel/AMD's fault.

And we can do it in C and don't have to fiddle with it in the ASM
maze.

Thanks,

        tglx
