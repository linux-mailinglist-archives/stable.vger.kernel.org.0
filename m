Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9133056D
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 01:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhCHAnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 19:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230496AbhCHAmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 19:42:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F0365092;
        Mon,  8 Mar 2021 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615164170;
        bh=2eu1tjNIFC7h9DpaRDU1LjO7RYm+wiDuYQ8VJiszxHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YhaQGnDrzo4PETvwytgSY7GEQk+LPzJwdLfd2tjvMAVYnCFlIKYkqDh/zVqc3KyzR
         FM3EYmJ9bg16aSSXWelXDOV6YuD/TL4CDQPvAFGVNu3lX2rNCHOR9rWoon5uJMo6r9
         llgVFPIg6J2SWkHAqU8++fKVTPw+sApnqwPffw4NYyJgQedO9lfvjNIEDOlbGZTEO/
         TVCQ8k9h7IqxOPFZlNdHiLTuvoS13fubUYuxZIRTgdfOz9XWRSS7C2X4IBAO9MROaP
         rDsWr/SkY7qA9vcOJKtkghKMbFdNTaiBMprM8rXYbHGanZF+D8dg09wZXvBY4RazkD
         FkZ0YbpnZw53w==
Date:   Sun, 7 Mar 2021 19:42:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: stable: KASan for ARM
Message-ID: <YEVzCY5hi0CEYyxZ@sashalap>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
 <YETvOfBpfGrzewmt@kroah.com>
 <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
 <20210307224854.GF1463@shell.armlinux.org.uk>
 <20210307233439.GA8915@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210307233439.GA8915@qmqm.qmqm.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 12:34:39AM +0100, Michał Mirosław wrote:
>On Sun, Mar 07, 2021 at 10:48:54PM +0000, Russell King - ARM Linux admin wrote:
>> On Sun, Mar 07, 2021 at 05:10:43PM +0100, Ard Biesheuvel wrote:
>> > (+ Russell)
>> >
>> > On Sun, 7 Mar 2021 at 16:21, Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> > >
>> > > On Sun, Mar 07, 2021 at 04:00:40PM +0100, Michał Mirosław wrote:
>> > > > Dear Greg,
>> > > >
>> > > > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
>> > > > are 7a1be318f579..421015713b30 if I understand correctly. They are
>> > > > not normal stable material, but I think they will help tremendously in
>> > > > discovering kernel bugs on 32-bit ARMs.
>> > >
>> > > Looks like a new feature to me, right?
>> > >
>> > > How many patches, and have you tested them?  If so, submit them as a
>> > > patch series and we can review them, but if this is a new feature, it
>> > > does not meet the stable kernel rules.
>> > >
>> > > And why not just use 5.11 or newer for discovering kernel bugs?  Why
>> > > does 5.10 matter here?
>> >
>> > The KASan support was rather tricky to get right, so I don't think
>> > this is suitable for stable. The range 7a1be318f579..421015713b30 is
>> > definitely not complete (we'd need at least
>> > e9a2f8b599d0bc22a1b13e69527246ac39c697b4 and
>> > 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 as well), and the intrusive
>> > nature of those changes means they are definitely not appropriate as
>> > stable backports.
>>
>> I agree - it took quite a while for KASan to settle down - and our last
>> issue with KASan causing a panic in the Kprobes codes was in February.
>> So, I think at the very least, requesting to backport this so soon is
>> premature. That fix is not included even in what you mention above.
>> Maybe that fix has already been picked up in stable, I don't know.
>>
>> So, we know that there's probably more to getting kprobes working on
>> 32-bit ARM than even you've mentioned above.
>>
>> Is it worth backporting such a major feature to stable kernels? Or
>> would it be better to backport the fixes found by KASan from later
>> kernels? My feeling is the latter is the better all round approach.
>
>I guessed that KASan support code does not pose problems with
>CONFIG_KASAN=n.  If it does, then I understand that this is definitely
>a deal-breaker for stable, and I agree there is no point in further
>discussion. But, if in disabled state KASan patches meet the stable
>requirements, then maybe it is worth the trouble to help those who
>have to stay on a LTS kernel?

Following this logic nearly every upstream feature can be backported to
stable.

You can't have both worlds; you can't stay on an older "stable" tree
while still benefiting from new features that land upstream.

-- 
Thanks,
Sasha
