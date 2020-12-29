Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9483C2E6CD1
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgL2AhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgL2AhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 19:37:03 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA58C061793;
        Mon, 28 Dec 2020 16:36:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 11so7148248pfu.4;
        Mon, 28 Dec 2020 16:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=XhkB3zwKSFpfJJL95j/uWWsVgCC/SyOzuksaUOmpjVA=;
        b=MeyxK40WLYO0yC90yvfamYIsyRo4Xz+GSBNd+z//rnlWQ7IkSbd7O0Bz27btLYO8tg
         UHfFNRyUqITBFIBEQOw3phV8GdzVbpeF5jJVWWkYQDYTHTsOpOj1nUF4G5M+mRO3lOdS
         ucPyz9/DvHVORWimibQRBNXJfwEh8mycQFNAGFg1eoXZKR7L5wceO8fh5TikiRfCFG3T
         fR6Jz5QFn4I8eZhhSU2XEoPYw7LLxsE2ViAKLVQVhhMAYZ7aJu8xJiR+CZaXk1WzMiZ9
         oiFEi0lr6nMTRoHTWFI/2fJzDFY84VflCUCKbK6Cr3hme9aIGSjoT2yTj7GyOpOjsghR
         ywMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=XhkB3zwKSFpfJJL95j/uWWsVgCC/SyOzuksaUOmpjVA=;
        b=M1+0ff3J0DenwqkCbrw85Xq0piAG/tC5022PcId55xz6wwASQ0hMgSseMxicxZWu7e
         zlXHMQxKhHoJV2lPxI/FOyNxjd88aI++3bW+l6ho3MhADjvlWgQxxYPZTTgGQ3TdJTn+
         ZI376YCfSVUFrHjzaxiepvqurSdrTZ5y+bJWV5qNP7+vBOSf1QrT6tqJq7Q5haPFfdMg
         iQo06cow5u7qTyVvPR5gy+/ab3BcneXvomthaWc7as4TbNEzLjcCWAnYeEOBtj2WVHN6
         vr+McA0ijlwDB4DscpuMuOncMdFcqdt/5uyz3+SkIm/2DTJj49ie40eLYSpXNPguZPH7
         64Eg==
X-Gm-Message-State: AOAM531s5A7WzELnDIWFqAQQALlvg0yZk4tR5mzmj8JtmMJ5zYFM4Ra5
        33eMm+6M7lubc86sh6qVTUs=
X-Google-Smtp-Source: ABdhPJw/4YK0yucnDxztvfORV1tzUrP7e8hPYsw08vEhyvhWIh5qfVEa3S1Lj3OwBfDqpGkrR8pQog==
X-Received: by 2002:a65:5283:: with SMTP id y3mr12944392pgp.174.1609202182882;
        Mon, 28 Dec 2020 16:36:22 -0800 (PST)
Received: from localhost (193-116-97-30.tpgi.com.au. [193.116.97.30])
        by smtp.gmail.com with ESMTPSA id i6sm30030828pgc.58.2020.12.28.16.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 16:36:22 -0800 (PST)
Date:   Tue, 29 Dec 2020 10:36:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jann Horn <jannh@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
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
In-Reply-To: <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1609200902.me5niwm2t6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Andy Lutomirski's message of December 29, 2020 7:06 am:
> On Mon, Dec 28, 2020 at 12:32 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> ----- On Dec 28, 2020, at 2:44 PM, Andy Lutomirski luto@kernel.org wrote=
:
>>
>> > On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
>> > <linux@armlinux.org.uk> wrote:
>> >>
>> >> On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
>> >> > After chatting with rmk about this (but without claiming that any o=
f
>> >> > this is his opinion), based on the manpage, I think membarrier()
>> >> > currently doesn't really claim to be synchronizing caches? It just
>> >> > serializes cores. So arguably if userspace wants to use membarrier(=
)
>> >> > to synchronize code changes, userspace should first do the code
>> >> > change, then flush icache as appropriate for the architecture, and
>> >> > then do the membarrier() to ensure that the old code is unused?
>>
>> ^ exactly, yes.
>>
>> >> >
>> >> > For 32-bit arm, rmk pointed out that that would be the cacheflush()
>> >> > syscall. That might cause you to end up with two IPIs instead of on=
e
>> >> > in total, but we probably don't care _that_ much about extra IPIs o=
n
>> >> > 32-bit arm?
>>
>> This was the original thinking, yes. The cacheflush IPI will flush speci=
fic
>> regions of code, and the membarrier IPI issues context synchronizing
>> instructions.

APIs should be written in terms of the service they provide to=20
userspace, and in highest level terms as possible, rather than directing=20
hardware to do some low level operation. Unfortunately we're stuck with
this for now. We could deprecate it and replace it though.

If userspace wants to modify code and ensure that after the system call
returns then no other thread will be executing the previous code, then
there should be an API for that. It could actually combine the two IPIs
into one for architectures that require both too.=20

>>
>> Architectures with coherent i/d caches don't need the cacheflush step.
>=20
> There are different levels of coherency -- VIVT architectures may have
> differing requirements compared to PIPT, etc.
>=20
> In any case, I feel like the approach taken by the documentation is
> fundamentally confusing.  Architectures don't all speak the same
> language  How about something like:
>=20
> The SYNC_CORE operation causes all threads in the caller's address
> space (including the caller) to execute an architecture-defined
> barrier operation.  membarrier() will ensure that this barrier is
> executed at a time such that all data writes done by the calling
> thread before membarrier() are made visible by the barrier.
> Additional architecture-dependent cache management operations may be
> required to use this for JIT code.

As said this isn't what SYNC_CORE does, and it's not what powerpc
context synchronizing instructions do either, it will very much
re-order visibility of stores around such an instruction.

A thread completes store instructions into a store queue, which is
as far as a context synchronizing event goes. Visibility comes at
some indeterminite time later.

Also note that the regular membarrier syscall which does order
memory also does not make writes visible, it just ensures an
ordering.

>=20
> x86: SYNC_CORE executes a barrier that will cause subsequent
> instruction fetches to observe prior writes.  Currently this will be a

I would be surprised if x86's serializing instructions were different=20
than powerpc. rdtsc ordering or flushing stores to cache would be
surprising.

Thanks,
Nick

> "serializing" instruction, but, if future improved CPU documentation
> becomes available and relaxes this requirement, the barrier may
> change.  The kernel guarantees that writing new or modified
> instructions to normal memory (and issuing SFENCE if the writes were
> non-temporal) then doing a membarrier SYNC_CORE operation is
> sufficient to cause all threads in the caller's address space to
> execute the new or modified instructions.  This is true regardless of
> whether or not those instructions are written at the same virtual
> address from which they are subsequently executed.  No additional
> cache management is required on x86.
>=20
> arm: Something about the cache management syscalls.
>=20
> arm64: Ditto
>=20
> powerpc: I have no idea.
>=20
