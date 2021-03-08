Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EAE330802
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 07:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhCHGOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 01:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234832AbhCHGNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 01:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55C765142;
        Mon,  8 Mar 2021 06:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615184026;
        bh=2LFpEcY5EpUHEDML2bEb4boWC/k56iCOmwWKUbIrQmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=luyJGe12MUFgZVYOVi4cG8AW9SMG1D1xRnX/LFLo+SS8Fbtfnlnwq8941KUo4QMi9
         gdKZ7cPphc6rqnF1s3H2F0v8IRI5BKvvia/X0S7Q75esQTeAUrs22qhSMJV09sGByO
         G7A3fEIAc6imC903TpPjSJkQ+3EnsJGQTtBAIBBo=
Date:   Mon, 8 Mar 2021 07:13:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: stable: KASan for ARM
Message-ID: <YEXAlqye+r0qnchW@kroah.com>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
 <YETvOfBpfGrzewmt@kroah.com>
 <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
 <20210307224854.GF1463@shell.armlinux.org.uk>
 <20210307233439.GA8915@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210307233439.GA8915@qmqm.qmqm.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 12:34:39AM +0100, Michał Mirosław wrote:
> On Sun, Mar 07, 2021 at 10:48:54PM +0000, Russell King - ARM Linux admin wrote:
> > On Sun, Mar 07, 2021 at 05:10:43PM +0100, Ard Biesheuvel wrote:
> > > (+ Russell)
> > > 
> > > On Sun, 7 Mar 2021 at 16:21, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Sun, Mar 07, 2021 at 04:00:40PM +0100, Michał Mirosław wrote:
> > > > > Dear Greg,
> > > > >
> > > > > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> > > > > are 7a1be318f579..421015713b30 if I understand correctly. They are
> > > > > not normal stable material, but I think they will help tremendously in
> > > > > discovering kernel bugs on 32-bit ARMs.
> > > >
> > > > Looks like a new feature to me, right?
> > > >
> > > > How many patches, and have you tested them?  If so, submit them as a
> > > > patch series and we can review them, but if this is a new feature, it
> > > > does not meet the stable kernel rules.
> > > >
> > > > And why not just use 5.11 or newer for discovering kernel bugs?  Why
> > > > does 5.10 matter here?
> > > 
> > > The KASan support was rather tricky to get right, so I don't think
> > > this is suitable for stable. The range 7a1be318f579..421015713b30 is
> > > definitely not complete (we'd need at least
> > > e9a2f8b599d0bc22a1b13e69527246ac39c697b4 and
> > > 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 as well), and the intrusive
> > > nature of those changes means they are definitely not appropriate as
> > > stable backports.
> > 
> > I agree - it took quite a while for KASan to settle down - and our last
> > issue with KASan causing a panic in the Kprobes codes was in February.
> > So, I think at the very least, requesting to backport this so soon is
> > premature. That fix is not included even in what you mention above.
> > Maybe that fix has already been picked up in stable, I don't know.
> > 
> > So, we know that there's probably more to getting kprobes working on
> > 32-bit ARM than even you've mentioned above.
> > 
> > Is it worth backporting such a major feature to stable kernels? Or
> > would it be better to backport the fixes found by KASan from later
> > kernels? My feeling is the latter is the better all round approach.
> 
> I guessed that KASan support code does not pose problems with
> CONFIG_KASAN=n.  If it does, then I understand that this is definitely
> a deal-breaker for stable, and I agree there is no point in further
> discussion. But, if in disabled state KASan patches meet the stable
> requirements, then maybe it is worth the trouble to help those who
> have to stay on a LTS kernel?

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for what types of patches are acceptable for stable kernels.  These do
not seem to fit into those categories at all.

thanks,

greg k-h
