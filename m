Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B8C330533
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 00:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhCGXfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 18:35:01 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:55704 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhCGXeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 18:34:46 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4DtyVr26cyz6r;
        Mon,  8 Mar 2021 00:34:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1615160085; bh=34tf9yuKwerK8pFwi4ro7a4BQzaDEs6yraBJi8SnrD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lPOMIjqhm59wGNh4dtrfue7T9Q7DwzvJ1QA6qQeVtq8TpM/lwsSUm7jLKslFXbnRE
         dk9Xhi0/DMZ7TvGNpEIufVCDlUz4I7fcgg4F7TDehCcTk30Lar+yBMjHxZE0uyyg7T
         BYR1k80YK9n2gg1bbrLLt36d+sUgTq9XMDU0edM9OsM0yOakG306W5NTZbeUVmGGfA
         /V4Skr4f3LGZr2Z/7c5Q7YuxXBd2iqvVfrnKkOCt/NhxgxQf9fZCqjaykUkzOBi3TT
         Lafedk4lrykuaAzuqFIYEd1RXlz8kDDXmGTWH6GAqBMAhKg1PbDND7GDACt3HfzXG0
         64f6rKTh6UCKA==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.4 at mail
Date:   Mon, 8 Mar 2021 00:34:39 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: stable: KASan for ARM
Message-ID: <20210307233439.GA8915@qmqm.qmqm.pl>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
 <YETvOfBpfGrzewmt@kroah.com>
 <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
 <20210307224854.GF1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210307224854.GF1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 10:48:54PM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Mar 07, 2021 at 05:10:43PM +0100, Ard Biesheuvel wrote:
> > (+ Russell)
> > 
> > On Sun, 7 Mar 2021 at 16:21, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Mar 07, 2021 at 04:00:40PM +0100, Micha³ Miros³aw wrote:
> > > > Dear Greg,
> > > >
> > > > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> > > > are 7a1be318f579..421015713b30 if I understand correctly. They are
> > > > not normal stable material, but I think they will help tremendously in
> > > > discovering kernel bugs on 32-bit ARMs.
> > >
> > > Looks like a new feature to me, right?
> > >
> > > How many patches, and have you tested them?  If so, submit them as a
> > > patch series and we can review them, but if this is a new feature, it
> > > does not meet the stable kernel rules.
> > >
> > > And why not just use 5.11 or newer for discovering kernel bugs?  Why
> > > does 5.10 matter here?
> > 
> > The KASan support was rather tricky to get right, so I don't think
> > this is suitable for stable. The range 7a1be318f579..421015713b30 is
> > definitely not complete (we'd need at least
> > e9a2f8b599d0bc22a1b13e69527246ac39c697b4 and
> > 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 as well), and the intrusive
> > nature of those changes means they are definitely not appropriate as
> > stable backports.
> 
> I agree - it took quite a while for KASan to settle down - and our last
> issue with KASan causing a panic in the Kprobes codes was in February.
> So, I think at the very least, requesting to backport this so soon is
> premature. That fix is not included even in what you mention above.
> Maybe that fix has already been picked up in stable, I don't know.
> 
> So, we know that there's probably more to getting kprobes working on
> 32-bit ARM than even you've mentioned above.
> 
> Is it worth backporting such a major feature to stable kernels? Or
> would it be better to backport the fixes found by KASan from later
> kernels? My feeling is the latter is the better all round approach.

I guessed that KASan support code does not pose problems with
CONFIG_KASAN=n.  If it does, then I understand that this is definitely
a deal-breaker for stable, and I agree there is no point in further
discussion. But, if in disabled state KASan patches meet the stable
requirements, then maybe it is worth the trouble to help those who
have to stay on a LTS kernel?

Regarding testing KASan for ARM: I'm currently running it on a SAMA5D2
board. The 4 patches on top of v5.10.21 did allow the device to boot up
(after fixing a false-positive in __clear_user_memset()).  I also applied
the three patches Ard mentioned just to be closer to upstream and the
board still went up. Kernel gets big and slow after enabling KASan,
but I think this is expected.

Best Regards
Micha³ Miros³aw
