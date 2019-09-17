Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D295B49B8
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfIQInw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:43:52 -0400
Received: from 8.mo5.mail-out.ovh.net ([178.32.116.78]:58061 "EHLO
        8.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfIQInv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 04:43:51 -0400
X-Greylist: delayed 6611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 04:43:50 EDT
Received: from player735.ha.ovh.net (unknown [10.109.159.132])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 6AD8224C4B9
        for <stable@vger.kernel.org>; Tue, 17 Sep 2019 08:13:57 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player735.ha.ovh.net (Postfix) with ESMTPSA id CB4239E45C6B;
        Tue, 17 Sep 2019 06:13:51 +0000 (UTC)
Date:   Tue, 17 Sep 2019 08:13:50 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Greg KH <greg@kroah.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/xive: Fix bogus error code returned by OPAL
Message-ID: <20190917081350.26097928@bahia.lan>
In-Reply-To: <20190917050628.GB2056553@kroah.com>
References: <156821713818.1985334.14123187368108582810.stgit@bahia.lan>
        <20190912073049.CF36B20830@mail.kernel.org>
        <20190913131221.3ea88b5a@bahia.lan>
        <87sgovsgvs.fsf@mpe.ellerman.id.au>
        <20190917050628.GB2056553@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8765412250449975783
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudeggddutdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Sep 2019 07:06:28 +0200
Greg KH <greg@kroah.com> wrote:

> On Tue, Sep 17, 2019 at 02:09:43PM +1000, Michael Ellerman wrote:
> > Greg Kurz <groug@kaod.org> writes:
> > > On Thu, 12 Sep 2019 07:30:49 +0000
> > > Sasha Levin <sashal@kernel.org> wrote:
> > >
> > >> Hi,
> > >> 
> > >> [This is an automated email]
> > >> 
> > >> This commit has been processed because it contains a -stable tag.
> > >> The stable tag indicates that it's relevant for the following trees: 4.12+
> > >> 
> > >> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143.
> > >> 
> > >> v5.2.14: Build OK!
> > >> v4.19.72: Failed to apply! Possible dependencies:
> > >>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
> > >
> > > This is the only dependency indeed.
> > 
> > But it's a large and intrusive change, so we don't want to backport it
> > just for this.
> > 
> > >> v4.14.143: Failed to apply! Possible dependencies:
> > >>     104daea149c4 ("kconfig: reference environment variables directly and remove 'option env='")
> > >>     21c54b774744 ("kconfig: show compiler version text in the top comment")
> > >>     315bab4e972d ("kbuild: fix endless syncconfig in case arch Makefile sets CROSS_COMPILE")
> > >>     3298b690b21c ("kbuild: Add a cache for generated variables")
> > >>     4e56207130ed ("kbuild: Cache a few more calls to the compiler")
> > >>     75d9fc7fd94e ("powerpc/powernv: move OPAL call wrapper tracing and interrupt handling to C")
> > >>     8f2133cc0e1f ("powerpc/pseries: hcall_exit tracepoint retval should be signed")
> > >>     9a234a2e3843 ("kbuild: create directory for make cache only when necessary")
> > >>     d677a4d60193 ("Makefile: support flag -fsanitizer-coverage=trace-cmp")
> > >>     e08d6de4e532 ("kbuild: remove kbuild cache")
> > >>     e17c400ae194 ("kbuild: shrink .cache.mk when it exceeds 1000 lines")
> > >>     e501ce957a78 ("x86: Force asm-goto")
> > >>     e9666d10a567 ("jump_label: move 'asm goto' support test to Kconfig")
> > >> 
> > >
> > > That's quite a lot of patches to workaround a hard to hit skiboot bug.
> > > As an alternative, the patch can be backported so that it applies the
> > > following change:
> > >
> > > -OPAL_CALL(opal_xive_allocate_irq,              OPAL_XIVE_ALLOCATE_IRQ);
> > > +OPAL_CALL(opal_xive_allocate_irq_raw,          OPAL_XIVE_ALLOCATE_IRQ);
> > >
> > > to "arch/powerpc/platforms/powernv/opal-wrappers.S"
> > > instead of "arch/powerpc/platforms/powernv/opal-call.c" .
> > >
> > > BTW, this could also be done for 4.19.y .
> > >
> > >> 
> > >> NOTE: The patch will not be queued to stable trees until it is upstream.
> > >> 
> > >> How should we proceed with this patch?
> > >> 
> > >
> > > Michael ?
> > 
> > We should do a manual backport for v4.14 and v4.19. Greg do you have
> > cycles to do that?
> 
> Me?  No, sorry.  If you want this fix there, I need someone to send the
> backport.
> 

Heh I guess Michael was asking me :) I'll send the backport.

Cheers,

--
Greg

> thanks,
> 
> greg k-h

