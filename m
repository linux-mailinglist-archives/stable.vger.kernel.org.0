Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9971A185E
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDGWtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:49:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39164 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726492AbgDGWtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586299747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klofTqKtlvNGbqYKzbbwsFIAPu33LeJ5oRihi1bIRxQ=;
        b=fAQrJgvffyer5iS0a74AwFN66Oi2FlXBFsy8qHtYMFVRLOQxYjo0RwZ0fsy6v9bBzDeCs2
        X/BSiu9ee3n5y7km1DasoaWijUFtrmZY16ADPsGQpYcdn3WxeLfksh7M3BkRNC2Pq12LM3
        SSVFTGmH9591SkDuNDhBHurSgDAKoDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-zDuNRxofOWS4Onw6MpmH1g-1; Tue, 07 Apr 2020 18:49:05 -0400
X-MC-Unique: zDuNRxofOWS4Onw6MpmH1g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E4E1005513;
        Tue,  7 Apr 2020 22:49:04 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-142.rdu2.redhat.com [10.10.115.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1B3A9DD66;
        Tue,  7 Apr 2020 22:49:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4467C220604; Tue,  7 Apr 2020 18:49:03 -0400 (EDT)
Date:   Tue, 7 Apr 2020 18:49:03 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200407224903.GC64635@redhat.com>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 02:41:02PM -0700, Andy Lutomirski wrote:
>=20
>=20
> > On Apr 7, 2020, at 1:20 PM, Thomas Gleixner <tglx@linutronix.de> wrot=
e:
> >=20
> > =EF=BB=BFAndy Lutomirski <luto@amacapital.net> writes:
> >>>> On Apr 7, 2020, at 10:21 AM, Vivek Goyal <vgoyal@redhat.com> wrote=
:
> >>> Whether interrupts are enabled or not check only happens before we =
decide
> >>> if async pf protocol should be followed or not. Once we decide to
> >>> send PAGE_NOT_PRESENT, later notification PAGE_READY does not check
> >>> if interrupts are enabled or not. And it kind of makes sense otherw=
ise
> >>> guest process will wait infinitely to receive PAGE_READY.
> >>>=20
> >>> I modified the code a bit to disable interrupt and wait 10 seconds =
(after
> >>> getting PAGE_NOT_PRESENT message). And I noticed that error async p=
f
> >>> got delivered after 10 seconds after enabling interrupts. So error
> >>> async pf was not lost because interrupts were disabled.
> >=20
> > Async PF is not the same as a real #PF. It just hijacked the #PF vect=
or
> > because someone thought this is a brilliant idea.
> >=20
> >>> Havind said that, I thought disabling interrupts does not mask exce=
ptions.
> >>> So page fault exception should have been delivered even with interr=
upts
> >>> disabled. Is that correct? May be there was no vm exit/entry during
> >>> those 10 seconds and that's why.
> >=20
> > No. Async PF is not a real exception. It has interrupt semantics and =
it
> > can only be injected when the guest has interrupts enabled. It's bad
> > design.
> >=20
> >> My point is that the entire async pf is nonsense. There are two type=
s of events right now:
> >>=20
> >> =E2=80=9CPage not ready=E2=80=9D: normally this isn=E2=80=99t even v=
isible to the guest =E2=80=94 the
> >> guest just waits. With async pf, the idea is to try to tell the gues=
t
> >> that a particular instruction would block and the guest should do
> >> something else instead. Sending a normal exception is a poor design,
> >> though: the guest may not expect this instruction to cause an
> >> exception. I think KVM should try to deliver an *interrupt* and, if =
it
> >> can=E2=80=99t, then just block the guest.
> >=20
> > That's pretty much what it does, just that it runs this through #PF a=
nd
> > has the checks for interrupts disabled - i.e can't right now' around
> > that. If it can't then KVM schedules the guest out until the situatio=
n
> > has been resolved.
> >=20
> >> =E2=80=9CPage ready=E2=80=9D: this is a regular asynchronous notific=
ation just like,
> >> say, a virtio completion. It should be an ordinary interrupt.  Some =
in
> >> memory data structure should indicate which pages are ready.
> >>=20
> >> =E2=80=9CPage is malfunctioning=E2=80=9D is tricky because you *must=
* deliver the
> >> event. x86=E2=80=99s #MC is not exactly a masterpiece, but it does k=
ind of
> >> work.
> >=20
> > Nooooo. This does not need #MC at all. Don't even think about it.
>=20
> Yessssssssssss.  Please do think about it. :)
>=20
> >=20
> > The point is that the access to such a page is either happening in us=
er
> > space or in kernel space with a proper exception table fixup.
> >=20
> > That means a real #PF is perfectly fine. That can be injected any tim=
e
> > and does not have the interrupt semantics of async PF.
>=20
> The hypervisor has no way to distinguish between MOV-and-has-valid-stac=
k-and-extable-entry and MOV-definitely-can=E2=80=99t-fault-here.  Or, for=
 that matter, MOV-in-do_page_fault()-will-recurve-if-it-faults.
>=20
> >=20
> > So now lets assume we distangled async PF from #PF and made it a regu=
lar
> > interrupt, then the following situation still needs to be dealt with:
> >=20
> >   guest -> access faults
> >=20
> > host -> injects async fault
> >=20
> >   guest -> handles and blocks the task
> >=20
> > host figures out that the page does not exist anymore and now needs t=
o
> > fixup the situation.
> >=20
> > host -> injects async wakeup
> >=20
> >   guest -> returns from aysnc PF interrupt and retries the instructio=
n
> >            which faults again.
> >=20
> > host -> knows by now that this is a real fault and injects a proper #=
PF
> >=20
> >   guest -> #PF runs and either sends signal to user space or runs
> >            the exception table fixup for a kernel fault.
>=20
> Or guest blows up because the fault could not be recovered using #PF.
>=20
> I can see two somewhat sane ways to make this work.
>=20
> 1. Access to bad memory results in an async-page-not-present, except th=
at,  it=E2=80=99s not deliverable, the guest is killed. Either that async=
-page-not-present has a special flag saying =E2=80=9Cmemory failure=E2=80=
=9D or the eventual wakeup says =E2=80=9Cmemory failure=E2=80=9D.
>=20
> 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it=E2=
=80=99s an *architectural* turd. By all means, have a nice simple PV mech=
anism to tell the #MC code exactly what went wrong, but keep the overall =
flow the same as in the native case.
>=20

Should we differentiate between two error cases. In this case memory is
not bad. Just that page being asked for can't be faulted in anymore. And
another error case is real memory failure. So for the first case it
could be injected into guest using #PF or #VE or something paravirt
specific and real hardware failures take #MC path (if they are not
already doing so).

Thanks
Vivek

