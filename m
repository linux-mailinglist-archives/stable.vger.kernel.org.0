Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357FF3E2CF3
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhHFOx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:53:26 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34725 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhHFOx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 10:53:26 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 176Eqmad029650;
        Fri, 6 Aug 2021 16:52:48 +0200
Date:   Fri, 6 Aug 2021 16:52:48 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210806145248.GF27218@1wt.eu>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <20210805164254.GG17808@1wt.eu>
 <20210805172949.GA3691426@roeck-us.net>
 <20210805183055.GA21961@1wt.eu>
 <YQ1JO1KpaBrRdSNo@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQ1JO1KpaBrRdSNo@sashalap>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Fri, Aug 06, 2021 at 10:37:47AM -0400, Sasha Levin wrote:
> > Then in my opinion we should encourage *not* to use "Fixes:" on untested
> > patches (untested patches will always happen due to hardware availability
> > or lack of a reliable reproducer).
> > 
> > What about this to try to improve the situation in this specific case ?
> 
> No, please let's not. If there is no testing story behind a buggy patch
> then it'll explode either when we go to the next version, or when we
> pull it into -stable.
> 
> If we avoid taking groups of patches into -stable it'll just mean that
> we end up with a huge amount of issues waiting for us during a version
> upgrade.

I agree with this and that was the point I was explaining as well: someone
has to detect those bugs, and unfortunately if they're so hard to see that
they can't be detected before the users, it has to hit a user.

> Yes, we may be taking bugs in now, but the regression rate (according to
> LWN) is pretty low, and the somewhat linear distribution of those bugs
> throughout our releases makes them managable (to review when they're
> sent out, to find during testing, to bisect if we hit the bug).

I totally agree that they're extremely low. I only faced one in production
in 4 or 5 years now, and even then it was not a true one, it was caused by
a context change that made one local patch silently apply at the wrong place.

> As Guenter points out, the path forward should be to improve our testing
> story.

Yes but we also have to make people understand that it only improves the
situation a little bit and doesn't magically result in zero regression.
Most whiners seem to say "I've met a regression once, that's unacceptable".
This will not change their experience, it will just reduce the number of
whiners who complain about their first bug ever. The amount of effort to
invest in testing to reduce regressions by just 1% can be huge, and at
some point one has to wonder where resources are better assigned.

Again, I tend to think that releasing older releases less often (and with
more patches each time) could reassure some users. It used to happen in
the past when Paul, Ben and I were in charge of older & slower branches,
and it sometimes allowed us to drop one patch and its subsequent revert
from a series. That's still one regression saved whenever it happens.
And this maintains the principle of "older==extremely stable with slower
fixes, newer==very stable with faster fixes".

Cheers,
Willy
