Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FD2EABE2
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 14:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbhAEN1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 08:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbhAEN1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 08:27:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2194225AC;
        Tue,  5 Jan 2021 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609853189;
        bh=TmYNnmKpWB2t2Q9JsIHgrp8V/YLclj6QFBBv76JxcGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6CBueejxaIU+YgJTNSnl5xkqm0WnsJZ3JQodk76eUGNSvSvFWbgqtFlerBNe46O7
         KCfs6qTXHvoxl+KgOgnyYCRImBCjtoRl0Sv9bjlNM7osRSXL5kzyWRuDlBkuA2sEY2
         QXO+02ZXf0Vjg2WEgjj4nZeO5cWIkYARBS9IHsx3rT4etAm5hg7/iHbpBjw4rbhuhK
         qIJDgYPl94MPe9+jLH00xJ+fEhNuG22bB4+WGxTTh4ZRaynB+XUSxJRtTlY+EJebkh
         /xRJUMzBCY5wKF+Ee1YMNjFs4ud+Tv7pSwnGv6QdEHPG7ED4APzW6rwyo2ugYIjNbk
         qXL4nmbqdI1PQ==
Date:   Tue, 5 Jan 2021 13:26:23 +0000
From:   Will Deacon <will@kernel.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        X86 ML <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Message-ID: <20210105132623.GB11108@willie-the-truck>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1609199804.yrsu9vagzk.astroid@bobo.none>
 <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX4v1KEf6ikVtFg6juh3Z_esJ-+6PLT1A21JJeTVh2k8g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

Sorry for the slow reply, I was socially distanced from my keyboard.

On Mon, Dec 28, 2020 at 04:36:11PM -0800, Andy Lutomirski wrote:
> On Mon, Dec 28, 2020 at 4:11 PM Nicholas Piggin <npiggin@gmail.com> wrote:
> > > +static inline void membarrier_sync_core_before_usermode(void)
> > > +{
> > > +     /*
> > > +      * XXX: I know basically nothing about powerpc cache management.
> > > +      * Is this correct?
> > > +      */
> > > +     isync();
> >
> > This is not about memory ordering or cache management, it's about
> > pipeline management. Powerpc's return to user mode serializes the
> > CPU (aka the hardware thread, _not_ the core; another wrongness of
> > the name, but AFAIKS the HW thread is what is required for
> > membarrier). So this is wrong, powerpc needs nothing here.
> 
> Fair enough.  I'm happy to defer to you on the powerpc details.  In
> any case, this just illustrates that we need feedback from a person
> who knows more about ARM64 than I do.

I think we're in a very similar boat to PowerPC, fwiw. Roughly speaking:

  1. SYNC_CORE does _not_ perform any cache management; that is the
     responsibility of userspace, either by executing the relevant
     maintenance instructions (arm64) or a system call (arm32). Crucially,
     the hardware will ensure that this cache maintenance is broadcast
     to all other CPUs.

  2. Even with all the cache maintenance in the world, a CPU could have
     speculatively fetched stale instructions into its "pipeline" ahead of
     time, and these are _not_ flushed by the broadcast maintenance instructions
     in (1). SYNC_CORE provides a means for userspace to discard these stale
     instructions.

  3. The context synchronization event on exception entry/exit is
     sufficient here. The Arm ARM isn't very good at describing what it
     does, because it's in denial about the existence of a pipeline, but
     it does have snippets such as:

	(s/PE/CPU/)
       | For all types of memory:
       | The PE might have fetched the instructions from memory at any time
       | since the last Context synchronization event on that PE.

     Interestingly, the architecture recently added a control bit to remove
     this synchronisation from exception return, so if we set that then we'd
     have a problem with SYNC_CORE and adding an ISB would be necessary (and
     we could probable then make kernel->kernel returns cheaper, but I
     suspect we're relying on this implicit synchronisation in other places
     too).

Are you seeing a problem in practice, or did this come up while trying to
decipher the semantics of SYNC_CORE?

Will
