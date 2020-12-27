Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42A2E3302
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 22:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgL0VhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 16:37:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgL0VhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 16:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DF7522B2C
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609104987;
        bh=xf1xhuCSbIvU6yFstK8GVJEOxP3WIu96vlXc4UxPWjg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AqlCdXKHE+ITIKKRlqblXCSPB1fZi8/UDAb1RDKCM1LvBmfFUzWwvmRaxDmO2t3hX
         Nk6pMZGldD5DaO605Rtt8TjjpOD/gSk58ws/PQ9FMfNSuHWbyzwf58epdI6g3zk8xZ
         Igbu0xStOGQWdGd9Kogu2VJnNRAWN3zsxS3vBuHZhFn096dU225m4SpqgJdSX6aMov
         EBd0pc/BjZrshn7beSWmBBUXcEIKmk+336nrsvKpQCdQceJupZ7MtSF8mohlT+MVwl
         hKrhBGpC7tm8GB4+e/xrihyvUg8Ly26YAqTnggMTfP4n7AumuBvcriGH+eaPw+YB2h
         jGdZuFrFFMGPQ==
Received: by mail-wr1-f53.google.com with SMTP id d13so8923020wrc.13
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 13:36:27 -0800 (PST)
X-Gm-Message-State: AOAM530YdMspiBIuYVgxsoAFXGznpVXwyUkO4syekgouLUSua2dhg8lB
        FU8WzvvjHGKgBGENBUurTyrmkh/MWKJ6RWjiV1Zs1w==
X-Google-Smtp-Source: ABdhPJwL0d4jxly4xZo1ozG4f8+9aazYql5ttlOL3TT+E+3PWhEM6R+ijPQOdmXIla5FWQwjhuFdendweCd9l/QAEJQ=
X-Received: by 2002:a5d:4905:: with SMTP id x5mr47749724wrq.75.1609104985693;
 Sun, 27 Dec 2020 13:36:25 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
In-Reply-To: <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 27 Dec 2020 13:36:13 -0800
X-Gmail-Original-Message-ID: <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
Message-ID: <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Andy Lutomirski <luto@kernel.org>, x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 12:18 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Dec 27, 2020, at 1:28 PM, Andy Lutomirski luto@kernel.org wrote:
>

> >
> > I admit that I'm rather surprised that the code worked at all on arm64,
> > and I'm suspicious that it has never been very well tested.  My apologies
> > for not reviewing this more carefully in the first place.
>
> Please refer to Documentation/features/sched/membarrier-sync-core/arch-support.txt
>
> It clearly states that only arm, arm64, powerpc and x86 support the membarrier
> sync core feature as of now:

Sigh, I missed arm (32).  Russell or ARM folks, what's the right
incantation to make the CPU notice instruction changes initiated by
other cores on 32-bit ARM?

>
>
> # Architecture requirements
> #
> # * arm/arm64/powerpc
> #
> # Rely on implicit context synchronization as a result of exception return
> # when returning from IPI handler, and when returning to user-space.
> #
> # * x86
> #
> # x86-32 uses IRET as return from interrupt, which takes care of the IPI.
> # However, it uses both IRET and SYSEXIT to go back to user-space. The IRET
> # instruction is core serializing, but not SYSEXIT.
> #
> # x86-64 uses IRET as return from interrupt, which takes care of the IPI.
> # However, it can return to user-space through either SYSRETL (compat code),
> # SYSRETQ, or IRET.
> #
> # Given that neither SYSRET{L,Q}, nor SYSEXIT, are core serializing, we rely
> # instead on write_cr3() performed by switch_mm() to provide core serialization
> # after changing the current mm, and deal with the special case of kthread ->
> # uthread (temporarily keeping current mm into active_mm) by issuing a
> # sync_core_before_usermode() in that specific case.
>

I need to update that document as part of my series.

> This is based on direct feedback from the architecture maintainers.
>
> You seem to have noticed odd cases on arm64 where this guarantee does not
> match reality. Where exactly can we find this in the code, and which part
> of the architecture manual can you point us to which supports your concern ?
>
> Based on the notes I have, use of `eret` on aarch64 guarantees a context synchronizing
> instruction when returning to user-space.

Based on my reading of the manual, ERET on ARM doesn't synchronize
anything at all.  I can't find any evidence that it synchronizes data
or instructions, and I've seen reports that the CPU will happily
speculate right past it.

--Andy
