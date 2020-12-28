Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA22E699A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 18:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgL1RPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 12:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgL1RPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 12:15:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F4E22B30
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609175676;
        bh=nMFBr3AvYXRRq2owotQjD2yoFpgfyoWAPgMz9PhnD/Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZeSX2vRlCanroSsW4BK7DGUrK3k2SOzmqV2xEXyMyPjqu44pP9BiMfE8tPd3llJsX
         HUJ/W5trVCAdI7BSXID6rGbWhICir5MECyTiACa1g1J2CK43kMFJ9WaPpCNkxF8Joo
         EaN3FUyXtsgJiCyfnKA/EQBgRM+ls3mmBaXjI7gLHAHQBT5L1B+DKxooB1H4Mqx51z
         ngviP39PLF3mgFDcWB/8wL0SM/PIWLfUIcrvO5KuB8525M997tpEidUOcGxQKUfhxP
         Pg5tXjIQVuLfdHVd7iWP1C/S4quq69OdNPfQwCRTb4Aj4d6KObdBM86I/C8LATMP5B
         W7XvKz/a3n/fg==
Received: by mail-wr1-f43.google.com with SMTP id i9so11903414wrc.4
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 09:14:36 -0800 (PST)
X-Gm-Message-State: AOAM531M0D0QkfRElHg7LF9DF1cgPSZwHyahd9xrLfd6CvUQ/hfcyVgW
        BayV1MaahC3fcG5aIpx+UwaUhyhYolzVysC/ND0eWA==
X-Google-Smtp-Source: ABdhPJy0oinDLzaLY7q03WGWqBsF+upjqJxfvdljiaLA/MhTFGMKNak9Fp8Heg/rl+JnpYn31/xU0l5Nkg8k+wnrVDI=
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr51067579wrr.184.1609175674739;
 Mon, 28 Dec 2020 09:14:34 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com> <20201228102537.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20201228102537.GG1551@shell.armlinux.org.uk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Dec 2020 09:14:23 -0800
X-Gmail-Original-Message-ID: <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
Message-ID: <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        x86 <x86@kernel.org>,
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

On Mon, Dec 28, 2020 at 2:25 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sun, Dec 27, 2020 at 01:36:13PM -0800, Andy Lutomirski wrote:
> > On Sun, Dec 27, 2020 at 12:18 PM Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> > >
> > > ----- On Dec 27, 2020, at 1:28 PM, Andy Lutomirski luto@kernel.org wrote:
> > >
> >
> > > >
> > > > I admit that I'm rather surprised that the code worked at all on arm64,
> > > > and I'm suspicious that it has never been very well tested.  My apologies
> > > > for not reviewing this more carefully in the first place.
> > >
> > > Please refer to Documentation/features/sched/membarrier-sync-core/arch-support.txt
> > >
> > > It clearly states that only arm, arm64, powerpc and x86 support the membarrier
> > > sync core feature as of now:
> >
> > Sigh, I missed arm (32).  Russell or ARM folks, what's the right
> > incantation to make the CPU notice instruction changes initiated by
> > other cores on 32-bit ARM?
>
> You need to call flush_icache_range(), since the changes need to be
> flushed from the data cache to the point of unification (of the Harvard
> I and D), and the instruction cache needs to be invalidated so it can
> then see those updated instructions. This will also take care of the
> necessary barriers that the CPU requires for you.

With what parameters?   From looking at the header, this is for the
case in which the kernel writes some memory and then intends to
execute it.  That's not what membarrier() does at all.  membarrier()
works like this:

User thread 1:

write to RWX memory *or* write to an RW alias of an X region.
membarrier(...);
somehow tell thread 2 that we're ready (with a store release, perhaps,
or even just a relaxed store.)

User thread 2:

wait for the indication from thread 1.
barrier();
jump to the code.

membarrier() is, for better or for worse, not given a range of addresses.

On x86, the documentation is a bit weak, but a strict reading
indicates that thread 2 must execute a serializing instruction at some
point after thread 1 writes the code and before thread 2 runs it.
membarrier() does this by sending an IPI and ensuring that a
"serializing" instruction (thanks for great terminology, Intel) is
executed.  Note that flush_icache_range() is a no-op on x86, and I've
asked Intel's architects to please clarify their precise rules.  No
response yet.

On arm64, flush_icache_range() seems to send an IPI, and that's not
what I want.  membarrier() already does an IPI.

I suppose one option is to revert support for this membarrier()
operation on arm, but it would be nice to just implement it instead.

--Andy
