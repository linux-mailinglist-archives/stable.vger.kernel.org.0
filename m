Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF036CFC
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 09:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFFHIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 03:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFHIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 03:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CDA2083D;
        Thu,  6 Jun 2019 07:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559804889;
        bh=sOq1aIPwoGF1dlKwf8g6qXJnPdLXODwo9qjIaiPRjr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmXsfdmVy+fYk40zwh0ypfxRSF+bHgzmqyKHAiM+pwFTnrkAYrmCy4z6OTf5t0zFp
         +i6i3PMpxynsI4LQIarHQz/erzaloaH+NgO6vu4I8GL0Ug4OinVxnYitknMlGd1KDv
         5OIG5iFXvxUcXdZFqCU1PpD43K9Fp16HZ8wVeVgo=
Date:   Thu, 6 Jun 2019 09:08:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x
 (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Message-ID: <20190606070807.GA17985@kroah.com>
References: <779905244.a0lJJiZRjM@devpool35>
 <20190605162626.GA31164@kroah.com>
 <CAKv+Gu9QkKwNVpfpQP7uDd2-66jU=qkeA7=0RAoO4TNaSbG+tg@mail.gmail.com>
 <CAKwvOdnPcjESFrQRR_=cCVag3ZSnC0nBqF7+LFHrcDArT_segA@mail.gmail.com>
 <CAKv+Gu9Leaq_s2kVNzHx+zkdKFXgQVkouN3M56u5nou5WX=cKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Leaq_s2kVNzHx+zkdKFXgQVkouN3M56u5nou5WX=cKg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 08:55:29AM +0200, Ard Biesheuvel wrote:
> On Wed, 5 Jun 2019 at 22:48, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Wed, Jun 5, 2019 at 11:42 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > > For the record, this is an example of why I think backporting those
> > > clang enablement patches is a bad idea.
> >
> > There's always a risk involved with backports of any kind; more CI
> > coverage can help us mitigate some of these risks in an automated
> > fashion before we get user reports like this.  I meet with the
> > KernelCI folks weekly, so I'll double check on the coverage of the
> > stable tree's branches.  The 0day folks are also very responsive and
> > I've spoken with them a few times, so I'll try to get to the bottom of
> > why this wasn't reported by either of those.
> >
> > Also, these patches help keep Android, CrOS, and Google internal
> > production kernels closer to their upstream sources.
> >
> > > We can't actually build those
> > > kernels with clang, can we? So what is the point? </grumpy>
> >
> > Here's last night's build:
> > https://travis-ci.com/ClangBuiltLinux/continuous-integration/builds/114388434
> >
> 
> If you are saying that plain upstream 4.9-stable defconfig can be
> built with Clang, then I am pleasantly surprised.

I know some specific configs can, there's no rule that I know of that
'defconfig' support is required.  But then again, it might also work,
try it and see :)

> > Also, Android and CrOS have shipped X million devices w/ 4.9 kernels
> > built with Clang.  I think this number will grow at least one order of
> > magnitude imminently.
> >
> 
> I know that (since you keep reminding me :-)), but obviously, Google
> does not care about changes that regress GCC support.

What are you talking about?  Bugs happen all the time, what specifically
did "Google" do to break gcc support?  If you are referring to this
patch, and it is a regression, of course I will revert it.  But note
that gcc and 4.9 works just fine for all of the other users right now,
remember we do do a lot of testing of these releases.

thanks,

greg k-h
