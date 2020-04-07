Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77841A128C
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgDGRVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 13:21:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726420AbgDGRVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 13:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586280104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ucz9SaukjNH3KUxwG/Jha1WYhwEEYPbGhMm7KfE+q1I=;
        b=ijEEfrwZZy1EKrsIXNBa28URouY2YagDhpOab19jfaQU7d2OzSx75soxG848DTDE5Ruifb
        49dOxxfHAqUtnfld/YXgTNWplCoH8sg7EWw5TYMT6KkKvex+1KhWpXwZucCKyvrfaSTf6+
        /twzfV852ceSRRwBEKGWegGM1fJajyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-ADR7zu3nM5GZthsQxUQV7w-1; Tue, 07 Apr 2020 13:21:43 -0400
X-MC-Unique: ADR7zu3nM5GZthsQxUQV7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABC8D107ACCD;
        Tue,  7 Apr 2020 17:21:41 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-142.rdu2.redhat.com [10.10.115.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8800D5DA60;
        Tue,  7 Apr 2020 17:21:41 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 0A9B6220604; Tue,  7 Apr 2020 13:21:41 -0400 (EDT)
Date:   Tue, 7 Apr 2020 13:21:40 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200407172140.GB64635@redhat.com>
References: <6875DD55-2408-4216-B32A-9487A4FDEFD8@amacapital.net>
 <FFD7EE84-05FB-46E4-8CA5-18DD49081B5B@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <FFD7EE84-05FB-46E4-8CA5-18DD49081B5B@amacapital.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 01:42:28PM -0700, Andy Lutomirski wrote:
>=20
> > On Apr 6, 2020, at 1:32 PM, Andy Lutomirski <luto@amacapital.net> wro=
te:
> >=20
> > =EF=BB=BF
> >> On Apr 6, 2020, at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> >>=20
> >> =EF=BB=BFOn Mon, Apr 06, 2020 at 03:09:51PM -0400, Vivek Goyal wrote=
:
> >>>> On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
> >>>>> On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
> >>>>>> Andy Lutomirski <luto@kernel.org> writes:
> >>>>>=20
> >>>>>>> I'm okay with the save/restore dance, I guess.  It's just yet m=
ore
> >>>>>>> entry crud to deal with architecture nastiness, except that thi=
s
> >>>>>>> nastiness is 100% software and isn't Intel/AMD's fault.
> >>>>>>=20
> >>>>>> And we can do it in C and don't have to fiddle with it in the AS=
M
> >>>>>> maze.
> >>>>>=20
> >>>>> Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, ev=
en if
> >>>>> we do the save/restore in do_nmi(). That is some wild brain melt.=
 Also,
> >>>>> AFAIK none of the distros are actually shipping a PREEMPT=3Dy ker=
nel
> >>>>> anyway, so killing it shouldn't matter much.
> >>>=20
> >>> It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have a=
nother
> >>> use case outside CONFIG_PREEMPT.
> >>>=20
> >>> I am trying to extend async pf interface to also report page fault =
errors
> >>> to the guest.
> >>=20
> >> Then please start over and design a sane ParaVirt Fault interface. T=
he
> >> current one is utter crap.
> >=20
> > Agreed. Don=E2=80=99t extend the current mechanism. Replace it.
> >=20
> > I would be happy to review a replacement. I=E2=80=99m not really exci=
ted to review an extension of the current mess.  The current thing is bar=
ely, if at all, correct.
>=20
> I read your patch. It cannot possibly be correct.  You need to decide w=
hat happens if you get a memory failure when guest interrupts are off. If=
 this happens, you can=E2=80=99t send #PF, but you also can=E2=80=99t jus=
t swallow the error. The existing APF code is so messy that it=E2=80=99s =
not at all obvious what your code ends up doing, but I=E2=80=99m pretty s=
ure it doesn=E2=80=99t do anything sensible, especially since the ABI doe=
sn=E2=80=99t have a sensible option.

Hi Andy,

I am not familiar with this KVM code and trying to understand it. I think
error exception gets queued and gets delivered at some point of time, eve=
n
if interrupts are disabled at the time of exception. Most likely at the t=
ime
of next VM entry.

Whether interrupts are enabled or not check only happens before we decide
if async pf protocol should be followed or not. Once we decide to
send PAGE_NOT_PRESENT, later notification PAGE_READY does not check
if interrupts are enabled or not. And it kind of makes sense otherwise
guest process will wait infinitely to receive PAGE_READY.

I modified the code a bit to disable interrupt and wait 10 seconds (after
getting PAGE_NOT_PRESENT message). And I noticed that error async pf
got delivered after 10 seconds after enabling interrupts. So error
async pf was not lost because interrupts were disabled.

Havind said that, I thought disabling interrupts does not mask exceptions=
.
So page fault exception should have been delivered even with interrupts
disabled. Is that correct? May be there was no vm exit/entry during
those 10 seconds and that's why.

Thanks
Vivek

