Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25AE342B8
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfFDJJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbfFDJJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 05:09:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2BE524CB3;
        Tue,  4 Jun 2019 09:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559639343;
        bh=IzPJUem37ux4j9d3G0oofHzcQRb6DVnER/OcXkjRq8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JUAfI6AslWlcKxnFIotnx2YnOvF1tJ6j42i0bGdTUFGouap7TwFDqLldpzlgRUkMR
         q5xVs2U24WRPcNJvG+sMTNVxIFsAkJhM13X+qceMrq67EcEVNzH7/4rCOGzWTefIcU
         CgnKibYBlHEIF3FDBlJFp8kyKCSMfl4JEL+A3HL0=
Date:   Tue, 4 Jun 2019 11:09:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <groeck@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zubin Mithra <zsm@chromium.org>,
        stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
Message-ID: <20190604090900.GD2855@kroah.com>
References: <20190603223851.GA162395@google.com>
 <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
 <20190604074624.GA6840@kroah.com>
 <CABXOdTeLtgjzL_V5rgsLnwZLaiK+MnL1BfOr8XeGXW8+Ws9zQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXOdTeLtgjzL_V5rgsLnwZLaiK+MnL1BfOr8XeGXW8+Ws9zQQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 01:52:06AM -0700, Guenter Roeck wrote:
> On Tue, Jun 4, 2019 at 12:46 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 04, 2019 at 09:38:27AM +0200, Ard Biesheuvel wrote:
> > > On Tue, 4 Jun 2019 at 00:38, Zubin Mithra <zsm@chromium.org> wrote:
> > > >
> > > > Hello,
> > > >
> > > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > > >
> > > > Could the patch be applied in order to v4.19.y?
> > > >
> > > > Tests run:
> > > > * Chrome OS tryjob
> > > >
> > >
> > > Unless I am missing something, it seems to me that there is some
> > > inflation going on when it comes to CVE number assignments.
> > >
> > > The code in question only affects systems that are explicitly booted
> > > with efi=old_map, and the memory allocation occurs so early during the
> > > boot sequence that even if we fail and handle it gracefully, it is
> > > highly unlikely that we can get to a point where the system is usable
> > > at all.
> > >
> > > Does Chrome OS boot in EFI mode? Does it use efi=old_map? Is the
> > > kernel built with 5 level paging enabled? Did you run it on 5 level
> > > paging hardware?
> > >
> > > Or is this just a tick the box exercise?
> > >
> > > Also, I am annoyed (does it show? :-))  that nobody mentioned the CVE
> > > at any point when the patch was under review (not even privately)
> >
> > CVEs are almost always asked for _after_ the patch is merged, as the
> > average fix-to-CVE request timeframe is -100 days.
> >
> > Also, for the kernel, CVEs almost mean nothing, so if this really isn't
> > an issue, I'll not backport this.
> >
> > And I really doubt that any chromeos device has 5 level page tables just
> > yet :)
> >
> 
> FWIW, Chrome OS kernels are not only used in Chromebooks nowadays.
> They are also used in VM images in systems with hundreds of GB of
> memory. At least some of those may well boot in EFI mode. Plus, as
> also mentioned, we do not (and will not) double-guess CVEs. If anyone
> has an issue with CVE creation, I would suggest to discuss with the
> respective bodies, not with us.

I have discussed it with the respective bodies and they agree that the
CVEs for kernel issues are a total joke.  The only way it can "be fixed"
is to burn it all down and create something new.  Some of us have some
plans for doing that, but it's on the back-burner due to "real world"
work to get done at this moment.

Again, like I said in the other email, treat CVE tags as a flag that you
might want to look at the patch.  But not as a "this must be applied!"
type of rule at all.

If this fix is needed for your systems, great, I'll be glad to queue it
up, Ard was just asking for confirmation about this resolving a real
issue for you or not.

> Zubin, as mentioned before, please hold back on -stable backport
> requests for CVE fixes. Please apply CVE fixes to our branches
> directly instead, per the above guidance ("for the kernel, CVEs almost
> mean nothing"). I'll revise our policy accordingly. Again, sorry for
> the trouble.

Again, don't take your toys and go away.  The backport requests you all
have been asking for are great, and hopefully saves you time in the end
by having the fix upstream and re-reviewed by everyone.  It also
benifits all of the non-Chromeos systems in the world, of which I know
Google relies on a lot of them, so you are doing work that the rest of
your company appreciates.

If someone asks "does this really resolve an issue for you", answer the
reasonable question :)

thanks,

greg k-h
