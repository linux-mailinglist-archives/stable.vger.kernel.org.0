Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFA2E6CCD
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgL2Abd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:31:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730120AbgL2Abd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 19:31:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C6F223E8
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609201852;
        bh=yV4j/cRgE8H7aOVGN5jCQGtvZBZobooTVQ66898JI4I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f5OovboTlW7EYpT8oivw2g8c4aQCg45IJs780xMsZVv9BXlppqEZqy3983beo0x51
         kFMuwRgSh0/pRPeHHA20PsWMQmrb9zMZ6QqyMI/pLw0gOiomHhkRC7FHT0chpCeFj0
         QWCj2/OWKlLN3lFN+EQ8jvqmX67Op9swBowXWGtd1BIrwQkdP/5XH+oR4o5a74MF+d
         4BHKEJlBKCraDuT70SOJkWP8mxSfeiGcFCmj2MxMhIxG2DAuhYkqV06UPt8Iw3reyP
         0RVrPJOloYf8YlLTPvAgv1smAbWsM3TS3YPalrnRrPy9vni75J5C/h+t61dUR/GoRh
         K4yiWQpZEE7+A==
Received: by mail-wm1-f48.google.com with SMTP id r4so793791wmh.5
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 16:30:52 -0800 (PST)
X-Gm-Message-State: AOAM531HFRvBCEBBM30WeySSsObQ4E1e+b0yPGMRKut6pvthym5J2Rsl
        RQpztX7sZ/HniilSuI9xp7kAmUHlouqRYkGtET+XVA==
X-Google-Smtp-Source: ABdhPJyTSyI1fcHiawazSCE0V3NGTirXlbcKcNazoOxkfqoxtb4dfAOpbR4IJMj2HYqQ9DARh1IpAW6OOBL8GRTvWuI=
X-Received: by 2002:a1c:2188:: with SMTP id h130mr1080293wmh.176.1609201851177;
 Mon, 28 Dec 2020 16:30:51 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com> <1670059472.3671.1609189779376.JavaMail.zimbra@efficios.com>
In-Reply-To: <1670059472.3671.1609189779376.JavaMail.zimbra@efficios.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Dec 2020 16:30:39 -0800
X-Gmail-Original-Message-ID: <CALCETrWaYU26z6RzHCN+VsTvS-uhApjr+jahS85de6WB_V37Tg@mail.gmail.com>
Message-ID: <CALCETrWaYU26z6RzHCN+VsTvS-uhApjr+jahS85de6WB_V37Tg@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andy Lutomirski <luto@kernel.org>, paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Russell King, ARM Linux" <linux@armlinux.org.uk>,
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

On Mon, Dec 28, 2020 at 1:09 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Dec 27, 2020, at 4:36 PM, Andy Lutomirski luto@kernel.org wrote:
>
> [...]
>
> >> You seem to have noticed odd cases on arm64 where this guarantee does not
> >> match reality. Where exactly can we find this in the code, and which part
> >> of the architecture manual can you point us to which supports your concern ?
> >>
> >> Based on the notes I have, use of `eret` on aarch64 guarantees a context
> >> synchronizing
> >> instruction when returning to user-space.
> >
> > Based on my reading of the manual, ERET on ARM doesn't synchronize
> > anything at all.  I can't find any evidence that it synchronizes data
> > or instructions, and I've seen reports that the CPU will happily
> > speculate right past it.
>
> Reading [1] there appears to be 3 kind of context synchronization events:
>
> - Taking an exception,
> - Returning from an exception,
> - ISB.

My reading of [1] is that all three of these are "context
synchronization event[s]", but that only ISB flushes the pipeline,
etc.  The little description of context synchronization seems to
suggest that it only implies that certain register changes become
effective.

>
> This other source [2] adds (search for Context synchronization operation):
>
> - Exit from Debug state
> - Executing a DCPS instruction
> - Executing a DRPS instruction
>
> "ERET" falls into the second kind of events, and AFAIU should be context
> synchronizing. That was confirmed to me by Will Deacon when membarrier
> sync-core was implemented for aarch64. If the architecture reference manuals
> are wrong, is there an errata ?
>
> As for the algorithm to use on ARMv8 to update instructions, see [2]
> B2.3.4  Implication of caches for the application programmer
> "Synchronization and coherency issues between data and instruction accesses"

This specifically discusses ISB.

Let's wait for an actual ARM64 expert to chime in, though.
