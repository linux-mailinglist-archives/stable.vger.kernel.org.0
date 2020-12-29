Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD32E6D7B
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgL2DKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 22:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2DJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 22:09:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD461C0613D6;
        Mon, 28 Dec 2020 19:09:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v1so757823pjr.2;
        Mon, 28 Dec 2020 19:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=HFGaJTE22Gpn3DcxiKrTMqBFFyZf1EzPU/aFKmc9vk4=;
        b=EqKPukiHlrZ+yEPAbVVHOlCWIHXbhJ90cIcuw7vXjETKCP19iLwGx/nXV3YbmqeHg/
         tLBdS5Y61yJwAD7YyPJl6a+ZwvVpk0odYj6Ch8fK/r1jV4V7GAjUtGPbI/8QnaQdh8x4
         jERK3Jj2WCyBLu0ZvafqrHE0DEGUNWyu9xietjw6CCNEZHoOi3v49bKMAhFCYe8GdcuD
         nWuiA0XHEAGcu5vw/uANNtnlUpDo2GkmbQTf1Kt5wD4Oarb8nlT4n9X51TqyPodxDLrU
         9VbxFIl2QviFvoM/C3RPuC9O0holXVUq4JQrQRcgVGDJeZv7IXwNmrKZTyhs+lgfBLIS
         56KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=HFGaJTE22Gpn3DcxiKrTMqBFFyZf1EzPU/aFKmc9vk4=;
        b=ESv64FXGZb9lHfVJibmvYy1xwssow4J0UWxaNgXLAJk8ZUJoDfQ/7vo/2bmM10sLYR
         jo1q7t68Yl09rpCfgmucNwp5cAcHagwJT0K6W3oQx/A8DGEYvKQqo4rYyThdCwhyKHbR
         hw3hHr1HfyQLn6thuWifs3KVMpUVaoqSvxwyFim7XaUxotkEBn0IJCW8xVzlxBTUaX1F
         RoE1HILxbCbZEtLtopdxMfKd0sSu0S/Gy2cH+ZllHSmCTwM0s2JUC3eh150zI/M31iiI
         WuU5YEie5MWg62siAd35YGBd9SfBOMxP1gQXuG/019OXQOCNS2RAMZlSGsk7KI1sgtHr
         eSIw==
X-Gm-Message-State: AOAM5301s7Idy4VK/fW7Xb0bjTH34FHZYb0s07UKITic7pnTNA499tGd
        Lht/KRckrbTHGrWxdVfnb9c=
X-Google-Smtp-Source: ABdhPJwMRA/X8wkBlvKJOB2qGxT8DL7lnVlIZ66Zvzbt+yLaAcb1DenG2dB65ez7zAPdfQJ0PvVfFQ==
X-Received: by 2002:a17:90a:5501:: with SMTP id b1mr1895272pji.7.1609211358983;
        Mon, 28 Dec 2020 19:09:18 -0800 (PST)
Received: from localhost (193-116-97-30.tpgi.com.au. [193.116.97.30])
        by smtp.gmail.com with ESMTPSA id u25sm35667410pfn.101.2020.12.28.19.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 19:09:18 -0800 (PST)
Date:   Tue, 29 Dec 2020 13:09:12 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jann Horn <jannh@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        paulmck <paulmck@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
        <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
        <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
        <20201228102537.GG1551@shell.armlinux.org.uk>
        <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
        <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
        <20201228190852.GI1551@shell.armlinux.org.uk>
        <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
        <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
        <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
        <1609200902.me5niwm2t6.astroid@bobo.none>
        <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
In-Reply-To: <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1609210162.4d8dqilke6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Andy Lutomirski's message of December 29, 2020 10:56 am:
> On Mon, Dec 28, 2020 at 4:36 PM Nicholas Piggin <npiggin@gmail.com> wrote=
:
>>
>> Excerpts from Andy Lutomirski's message of December 29, 2020 7:06 am:
>> > On Mon, Dec 28, 2020 at 12:32 PM Mathieu Desnoyers
>> > <mathieu.desnoyers@efficios.com> wrote:
>> >>
>> >> ----- On Dec 28, 2020, at 2:44 PM, Andy Lutomirski luto@kernel.org wr=
ote:
>> >>
>> >> > On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
>> >> > <linux@armlinux.org.uk> wrote:
>> >> >>
>> >> >> On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
>> >> >> > After chatting with rmk about this (but without claiming that an=
y of
>> >> >> > this is his opinion), based on the manpage, I think membarrier()
>> >> >> > currently doesn't really claim to be synchronizing caches? It ju=
st
>> >> >> > serializes cores. So arguably if userspace wants to use membarri=
er()
>> >> >> > to synchronize code changes, userspace should first do the code
>> >> >> > change, then flush icache as appropriate for the architecture, a=
nd
>> >> >> > then do the membarrier() to ensure that the old code is unused?
>> >>
>> >> ^ exactly, yes.
>> >>
>> >> >> >
>> >> >> > For 32-bit arm, rmk pointed out that that would be the cacheflus=
h()
>> >> >> > syscall. That might cause you to end up with two IPIs instead of=
 one
>> >> >> > in total, but we probably don't care _that_ much about extra IPI=
s on
>> >> >> > 32-bit arm?
>> >>
>> >> This was the original thinking, yes. The cacheflush IPI will flush sp=
ecific
>> >> regions of code, and the membarrier IPI issues context synchronizing
>> >> instructions.
>>
>> APIs should be written in terms of the service they provide to
>> userspace, and in highest level terms as possible, rather than directing
>> hardware to do some low level operation. Unfortunately we're stuck with
>> this for now. We could deprecate it and replace it though.
>>
>> If userspace wants to modify code and ensure that after the system call
>> returns then no other thread will be executing the previous code, then
>> there should be an API for that. It could actually combine the two IPIs
>> into one for architectures that require both too.
>=20
> I agree.  The membarrier API for SYNC_CORE is pretty nasty.  I would
> much prefer a real API for JITs to use.
>=20
>>
>> >>
>> >> Architectures with coherent i/d caches don't need the cacheflush step=
.
>> >
>> > There are different levels of coherency -- VIVT architectures may have
>> > differing requirements compared to PIPT, etc.
>> >
>> > In any case, I feel like the approach taken by the documentation is
>> > fundamentally confusing.  Architectures don't all speak the same
>> > language  How about something like:
>> >
>> > The SYNC_CORE operation causes all threads in the caller's address
>> > space (including the caller) to execute an architecture-defined
>> > barrier operation.  membarrier() will ensure that this barrier is
>> > executed at a time such that all data writes done by the calling
>> > thread before membarrier() are made visible by the barrier.
>> > Additional architecture-dependent cache management operations may be
>> > required to use this for JIT code.
>>
>> As said this isn't what SYNC_CORE does, and it's not what powerpc
>> context synchronizing instructions do either, it will very much
>> re-order visibility of stores around such an instruction.
>=20
> Perhaps the docs should be entirely arch-specific.  It may well be
> impossible to state what it does in an arch-neutral way.

I think what I wrote above -- after the call returns, none of the
threads in the process will be executing instructions overwritten
previously by the caller (provided their i-caches are made coherent
with the caller's modifications).

>> A thread completes store instructions into a store queue, which is
>> as far as a context synchronizing event goes. Visibility comes at
>> some indeterminite time later.
>=20
> As currently implemented, it has the same visibility semantics as
> regular membarrier, too.

Ah I actually missed that SYNC_CORE is in _addition_ to the memory
barriers, and that's documented API too, not just implementation
sorry.

> So if I do:
>=20
> a =3D 1;
> membarrier(SYNC_CORE);
> b =3D 1;
>=20
> and another thread does:
>=20
> while (READ_ONCE(b) !=3D 1)
>   ;
> barrier();
> assert(a =3D=3D 1);

Right that's true, due to the MEMBARRIER_CMD_PRIVATE_EXPEDITED. Neither
that barrier or the added SYNC_CORE behaviour imply visibility though.

>=20
> then the assertion will pass.  Similarly, one can do this, I hope:
>=20
> memcpy(codeptr, [some new instructions], len);
> arch_dependent_cache_flush(codeptr, len);
> membarrier(SYNC_CORE);
> ready =3D 1;
>=20
> and another thread does:
>=20
> while (READ_ONCE(ready) !=3D 1)
>   ;
> barrier();
> (*codeptr)();
>=20
> arch_dependent_cache_flush is a nop on x86.  On arm and arm64, it
> appears to be a syscall, although maybe arm64 can do it from
> userspace.  I still don't know what it is on powerpc.
>=20
> Even using the term "cache" here is misleading.  x86 chips have all
> kinds of barely-documented instruction caches, and they have varying
> degrees of coherency.  The architecture actually promises that, if you
> do a certain incantation, then you get the desired result.
> membarrier() allows a user to do this incantation.  But trying to
> replicate the incantation verbatim on an architecture like ARM is
> insufficient, and trying to flush the things that are documented as
> being caches on x86 is expensive and a complete waste of time on x86.
> When you write some JIT code, you do *not* want to flush it all the
> way to main memory, especially on CPUs don't have the ability to write
> back invalidating.  (That's most CPUs.)
>=20
> Even on x86, I suspect that the various decoded insn caches are rather
> more coherent than documented, and I have questions in to Intel about
> this.  No answers yet.
>=20
> So perhaps the right approach is to say that membarrier() helps you
> perform the architecture-specific sequence of steps needed to safely
> modify code.  On x86, you use it like this.  On arm64, you do this
> other thing.  On powerpc, you do something else.

I think it should certainly be documented in terms of what guarantees
it provides to application, _not_ the kinds of instructions it may or
may not induce the core to execute. And if existing API can't be
re-documented sanely, then deprecatd and new ones added that DTRT.
Possibly under a new system call, if arch's like ARM want a range
flush and we don't want to expand the multiplexing behaviour of
membarrier even more (sigh).

>=20
>>
>> I would be surprised if x86's serializing instructions were different
>> than powerpc. rdtsc ordering or flushing stores to cache would be
>> surprising.
>>
>=20
> At the very least, x86 has several levels of what ARM might call
> "context synchronization" AFAICT.  STAC, CLAC, and POPF do a form of
> context synchronization in that the changes they cause to the MMU take
> effect immediately, but they are not documented as synchronizing the
> instruction stream.  "Serializing" instructions do all kinds of
> things, not all of which may be architecturally visible at all.
> MFENCE and LFENCE do various complicated things, and LFENCE has magic
> retroactive capabilities on old CPUs that were not documented when
> those CPUs were released.  SFENCE does a different form of
> synchronization entirely.  LOCK does something else.  (The
> relationship between LOCK and MFENCE is confusing at best.)  RDTSC
> doesn't serialize anything at all, but RDTSCP does provide a form of
> serialization that's kind of ilke LFENCE.  It's a mess.  Even the
> manuals are inconsistent about what "serialize" means.  JMP has its
> own magic on x86, but only on very very old CPUs.
>=20
> The specific instruction that flushes everything into the coherency
> domain is SFENCE, and SFENCE is not, for normal purposes, needed for
> self- or cross-modifying code.
>=20

Good reason to avoid such language in the system call interface!

Thanks,
Nick
