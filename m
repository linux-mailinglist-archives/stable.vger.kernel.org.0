Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99453A0CE6
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhFIHAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 03:00:44 -0400
Received: from muru.com ([72.249.23.125]:39812 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236430AbhFIHAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 03:00:42 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 291FF80F5;
        Wed,  9 Jun 2021 06:58:56 +0000 (UTC)
Date:   Wed, 9 Jun 2021 09:58:44 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for linux-5.4.y PATCH 2/4] ARM: OMAP2+: Prepare timer
 code to backport dra7 timer wrap errata i940
Message-ID: <YMBmpAY04FRKOLMT@atomide.com>
References: <20210602104625.6079-1-tony@atomide.com>
 <20210602104625.6079-2-tony@atomide.com>
 <YL+lOumPYQ1fNoYw@kroah.com>
 <YMBcIbBPfr6W19j5@atomide.com>
 <YMBeI4aOMmWMRsu/@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMBeI4aOMmWMRsu/@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg KH <greg@kroah.com> [210609 06:22]:
> On Wed, Jun 09, 2021 at 09:13:53AM +0300, Tony Lindgren wrote:
> > How about the following for the description:
> > 
> > Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
> > struct dmtimer_clockevent backported to the platform timer code
> > still used in linux-5.4.y stable kernel. Needed to backport upstream
> > commit 3efe7a878a11c13b5297057bfc1e5639ce1241ce and commit
> > 25de4ce5ed02994aea8bc111d133308f6fd62566. Earlier kernels use
> > mach-omap2/timer instead of drivers/clocksource as these kernels still
> > depend on legacy platform code for booting.
> 
> Why are you combining 2 commits into one here?

OK so still too confusing, how about let's just have:

Upstream commit 52762fbd1c4778ac9b173624ca0faacd22ef4724 usage of
struct dmtimer_clockevent backported to the platform timer code
still used in linux-5.4.y stable kernel.

> I do not understand what this commit really is at all still, sorry.

It allows upstream fixes for drivers/clocksource/timer-ti-dm-systimer.c
to be backported to the legacy platform timer code in linux-5.4.y in
arch/arm/mach-omap2/timer.c.

We assume a single dmtimer clockevent instance only in linux-5.4.y
kernels, while for the dra7 hardware errata workaround we now need
extra percpu timers configured and need struct dmtimer_clockevent.

Backporting drivers/clocksource/timer-ti-dm-systimer.c directly seems
risky to me as linux-5.4.y still depends on legacy platform code for
booting and timers, including also the timer instances not used for
clocksource and clockevent. And it would be intrusive also for the
other SoCs not affected by the timer errata.

Of course the best option for folks using the stable kernels is to
move to the current long term kernel that already has the fixes for
drivers/clocksource/timer-ti-dm-systimer.c :)

> How about just providing backports for the individual commits, do not
> combine them as that just is a mess.

OK

> > Hmm so what's the correct way to prevent automatically applying these
> > into the earlier stable kernels?
> 
> What would cause them to be automatically applied?  You need to let us
> know what kernel(s) they should go to.

OK thanks, good to hear.

Regards,

Tony
