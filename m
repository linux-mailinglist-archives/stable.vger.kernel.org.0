Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D3025027D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgHXQc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgHXQcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:32:16 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8902067C;
        Mon, 24 Aug 2020 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286735;
        bh=JWw68BuVJ7xfLohloWh48lvCAxIed5C9r3jJcJyxoFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y+9T9DDdaJQxrm+zCaoyAUMyqLdeyuK0qOA+cQzh+mMxS41Bv8U+rmlEuVsrkVvGw
         v9T2hfFFPIeGCAOD2/nhQS5SvGDVtpEeC13I06nqHVJYs1m8Q2JYslDw/NiOUG9GRB
         UkP89VXdr0z4pAX8KrTtN8anYDfYxYgeaWa6l96g=
Date:   Mon, 24 Aug 2020 17:32:09 +0100
From:   Will Deacon <will@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
Message-ID: <20200824163208.GA25316@willie-the-truck>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
 <20200720130411.GB494210@kroah.com>
 <df1de420-ac59-3647-3b81-a0c163783225@gmail.com>
 <9c29080e-8b3a-571c-3296-e0487fa473fa@gmail.com>
 <20200807131429.GB664450@kroah.com>
 <20200821160316.GE21517@willie-the-truck>
 <7480435b-355d-b9f7-3a42-b72a9c4b6f63@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7480435b-355d-b9f7-3a42-b72a9c4b6f63@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Florian,

On Fri, Aug 21, 2020 at 10:16:23AM -0700, Florian Fainelli wrote:
> On 8/21/20 9:03 AM, Will Deacon wrote:
> > On Fri, Aug 07, 2020 at 03:14:29PM +0200, Greg KH wrote:
> >> On Thu, Aug 06, 2020 at 01:00:54PM -0700, Florian Fainelli wrote:
> >>> Greg, did you have a chance to queue those changes for 4.9, 4.14 and 4.19?
> >>>
> >>> https://lore.kernel.org/linux-arm-kernel/20200720182538.13304-1-f.fainelli@gmail.com/
> >>> https://lore.kernel.org/linux-arm-kernel/20200720182937.14099-1-f.fainelli@gmail.com/
> >>> https://lore.kernel.org/linux-arm-kernel/20200709195034.15185-1-f.fainelli@gmail.com/
> >>
> >> Nope, I was waiting for Will's "ack" for these.
> > 
> > This patch doesn't even build for me (the 'sb' macro is not defined in 4.9),
> > and I really wonder why we bother backporting it at all. Nobody's ever shown
> > it to be a problem in practice, and it's clear that this is just being
> > submitted to tick a box rather than anything else (otherwise it would build,
> > right?).
> 
> Doh, I completely missed submitting the patch this depended on that's
> why I did not notice the build failure locally, sorry about that, what a
> shame.
> 
> Would not be the same "tick a box" argument be used against your
> original submission then? Sure, I have not been able to demonstrate in
> real life this was a problem, however the same can be said about a lot
> security related fixes.

Sort of, although I wrote the original patch because it was dead easy to do
and saved having to think too much about the problem, whereas the complexity
of backporting largerly diminishes that imo.

> What if it becomes exploitable in the future, would not it be nice to
> have it in a 6 year LTS kernel?

Even if people are stuck on an old LTS, they should still be taking the
regular updates for it, and we would obviously need to backport the fix if
it turned out to be exploitable (and hey, we could even test it then!).

> > So I'm not going to Ack any of them. As with a lot of this side-channel
> > stuff the cure is far worse than the disease.
> Assuming that my v3 does build correctly, which it will, would you be
> keen on changing your position?

Note that I'm not trying to block this patch from going in, I'm just saying
that I'm not supportive of it. Perhaps somebody from Arm can review it if
they think it's worth the effort.

Will
