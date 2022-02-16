Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707584B8528
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 11:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiBPKFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 05:05:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiBPKFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 05:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A9879C65;
        Wed, 16 Feb 2022 02:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 417EB61910;
        Wed, 16 Feb 2022 10:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3653C004E1;
        Wed, 16 Feb 2022 10:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645005906;
        bh=Fa76VFxNIYJM7go5uhQ4lcrqW2IzVwQ1BV24lt+tgY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Feu0b1Y4WFW0ULFnIg0+qWFCcSI3SXRuHtw+iXX6k1CJOrMeggHB788iWBhtSVtIb
         Ja67MAf2XXUteBGSTykNr94rf1IymPlFEeERvi2TCcX/jtaAger2gOxGXry6uMmhvW
         S+r4rOMQFCV2PB94F1XJ3Rnsh+sO81TbFLO5mtdM=
Date:   Wed, 16 Feb 2022 11:05:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Geffon <bgeffon@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
Message-ID: <YgzMTrVMCVt+n7cE@kroah.com>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com>
 <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 04:32:48PM -0500, Brian Geffon wrote:
> On Tue, Feb 15, 2022 at 2:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Feb 15, 2022 at 11:22:33AM -0800, Brian Geffon wrote:
> > > When eagerly switching PKRU in switch_fpu_finish() it checks that
> > > current is not a kernel thread as kernel threads will never use PKRU.
> > > It's possible that this_cpu_read_stable() on current_task
> > > (ie. get_current()) is returning an old cached value. To resolve this
> > > reference next_p directly rather than relying on current.
> > >
> > > As written it's possible when switching from a kernel thread to a
> > > userspace thread to observe a cached PF_KTHREAD flag and never restore
> > > the PKRU. And as a result this issue only occurs when switching
> > > from a kernel thread to a userspace thread, switching from a non kernel
> > > thread works perfectly fine because all that is considered in that
> > > situation are the flags from some other non kernel task and the next fpu
> > > is passed in to switch_fpu_finish().
> > >
> > > This behavior only exists between 5.2 and 5.13 when it was fixed by a
> > > rewrite decoupling PKRU from xstate, in:
> > >   commit 954436989cc5 ("x86/fpu: Remove PKRU handling from switch_fpu_finish()")
> > >
> > > Unfortunately backporting the fix from 5.13 is probably not realistic as
> > > it's part of a 60+ patch series which rewrites most of the PKRU handling.
> > >
> > > Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
> > > Signed-off-by: Brian Geffon <bgeffon@google.com>
> > > Signed-off-by: Willis Kung <williskung@google.com>
> > > Tested-by: Willis Kung <williskung@google.com>
> > > Cc: <stable@vger.kernel.org> # v5.4.x
> > > Cc: <stable@vger.kernel.org> # v5.10.x
> > > ---
> > >  arch/x86/include/asm/fpu/internal.h | 13 ++++++++-----
> > >  arch/x86/kernel/process_32.c        |  6 ++----
> > >  arch/x86/kernel/process_64.c        |  6 ++----
> > >  3 files changed, 12 insertions(+), 13 deletions(-)
> >
> > So this is ONLY for 5.4.y and 5.10.y?  I'm really really loath to take
> > non-upstream changes as 95% of the time (really) it goes wrong.
> 
> That's correct, this bug was introduced in 5.2 and that code was
> completely refactored in 5.13 indirectly fixing it.

What series of commits contain that work?

And again, why not just take them?  What is wrong with that if this is
such a big issue?

> > How was this tested, and what do the maintainers of this subsystem
> > think?  And will you be around to fix the bugs in this when they are
> > found?
> 
> This has been trivial to reproduce, I've used a small repro which I've
> put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
> , I also was able to reproduce this using the protection_keys self
> tests on a 11th Gen Core i5-1135G7. I'm happy to commit to addressing
> any bugs that may appear. I'll see what the maintainers say, but there
> is also a smaller fix that just involves using this_cpu_read() in
> switch_fpu_finish() for this specific issue, although that approach
> isn't as clean.

Can you add the test to the in-kernel tests so that we make sure it is
fixed and never comes back?

thanks,

greg k-h
