Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7882E6CD3
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgL2AhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbgL2AhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 19:37:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F76E223E8
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609202185;
        bh=VX6lw2IJ/z/WjavzOW0lIGvJ2PJ7vI+cPiWmgFXCEi4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=klsW25bgbw2Tvtt4HCiG69FQv4hapU7eCpnsPT82tb4h4tFP+WN5MPXW0TPAeMUpE
         W1Bb4qLn/j8DCfX8hQQAiqGNj6lXOleMlM9evE8WGtODI/8ERWwzB3l6X0EzFK+iXl
         aG8FI0bAypxmmj1Cy8x44bo2yHoNpPH/NHkJKPAgCIV0dUb1vP3BbS8Q9dZ/pLQvqM
         JZtvRnlxRT1vQPPEfvC8rvHwMH6aovwMSGTBsxsIRvSryxDzpGLkz8A85O/i6JFVz8
         7hZEJ81kX43ATdY1/1QvFDU5BZScQNXGrav0we/3oQWufomEIHb9hrB9kNKBfqj888
         5Bi+xNXHb2INg==
Received: by mail-wr1-f51.google.com with SMTP id t16so12830536wra.3
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 16:36:25 -0800 (PST)
X-Gm-Message-State: AOAM531EikNKv1cnUM2fpDR96b3PQad0DDHrytK06ZognXwX05PlfQX3
        vDwfSxDArEaSXKtxcaro+k/mJSJLlhJHE5KYgDPGFA==
X-Google-Smtp-Source: ABdhPJztatywU6YOwSIVKLEbxZBNtEBa5iKSCwJTklOqEdD0ibLsWDGLhd7b2Cd3Fhyjte4DtXNSQn+FYl2eIOzIjDE=
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr52282122wrr.184.1609202183585;
 Mon, 28 Dec 2020 16:36:23 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1609199804.yrsu9vagzk.astroid@bobo.none>
In-Reply-To: <1609199804.yrsu9vagzk.astroid@bobo.none>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Dec 2020 16:36:11 -0800
X-Gmail-Original-Message-ID: <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
Message-ID: <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        X86 ML <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 4:11 PM Nicholas Piggin <npiggin@gmail.com> wrote:
>
> Excerpts from Andy Lutomirski's message of December 28, 2020 4:28 am:
> > The old sync_core_before_usermode() comments said that a non-icache-syncing
> > return-to-usermode instruction is x86-specific and that all other
> > architectures automatically notice cross-modified code on return to
> > userspace.  Based on my general understanding of how CPUs work and based on
> > my atttempt to read the ARM manual, this is not true at all.  In fact, x86
> > seems to be a bit of an anomaly in the other direction: x86's IRET is
> > unusually heavyweight for a return-to-usermode instruction.
>
> "sync_core_before_usermode" as I've said says nothing to arch, or to the
> scheduler, or to membarrier.

Agreed.  My patch tries to fix this.  I agree that the name is bad and
could be improved further.  We should define what
membarrier(...SYNC_CORE) actually does and have arch hooks to make it
happen.

> > So let's drop any pretense that we can have a generic way implementation
> > behind membarrier's SYNC_CORE flush and require all architectures that opt
> > in to supply their own.  This means x86, arm64, and powerpc for now.  Let's
> > also rename the function from sync_core_before_usermode() to
> > membarrier_sync_core_before_usermode() because the precise flushing details
> > may very well be specific to membarrier, and even the concept of
> > "sync_core" in the kernel is mostly an x86-ism.
>
> The concept of "sync_core" (x86: serializing instruction, powerpc: context
> synchronizing instruction, etc) is not an x86-ism at all. x86 just wanted
> to add a serializing instruction to generic code so it grew this nasty API,
> but the concept applies broadly.

I mean that the mapping from the name "sync_core" to its semantics is
x86 only.  The string "sync_core" appears in the kernel only in
arch/x86, membarrier code, membarrier docs, and a single SGI driver
that is x86-only.  Sure, the idea of serializing things is fairly
generic, but exactly what operations serialize what, when things need
serialization, etc is quite architecture specific.

Heck, on 486 you serialize the instruction stream with JMP.

> > +static inline void membarrier_sync_core_before_usermode(void)
> > +{
> > +     /*
> > +      * XXX: I know basically nothing about powerpc cache management.
> > +      * Is this correct?
> > +      */
> > +     isync();
>
> This is not about memory ordering or cache management, it's about
> pipeline management. Powerpc's return to user mode serializes the
> CPU (aka the hardware thread, _not_ the core; another wrongness of
> the name, but AFAIKS the HW thread is what is required for
> membarrier). So this is wrong, powerpc needs nothing here.

Fair enough.  I'm happy to defer to you on the powerpc details.  In
any case, this just illustrates that we need feedback from a person
who knows more about ARM64 than I do.
