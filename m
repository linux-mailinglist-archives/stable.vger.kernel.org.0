Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084383E19C4
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhHEQn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 12:43:27 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:34690 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhHEQn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 12:43:27 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 175GgsRE021493;
        Thu, 5 Aug 2021 18:42:54 +0200
Date:   Thu, 5 Aug 2021 18:42:54 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: Regressions in stable releases
Message-ID: <20210805164254.GG17808@1wt.eu>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Thu, Aug 05, 2021 at 09:11:02AM -0700, Guenter Roeck wrote:
> Hi folks,
> 
> we have (at least) two severe regressions in stable releases right now.
> 
> [SHAs are from linux-5.10.y]
> 
> 2435dcfd16ac spi: mediatek: fix fifo rx mode
> 	Breaks SPI access on all Mediatek devices for small transactions
> 	(including all Mediatek based Chromebooks since they use small SPI
> 	 transactions for EC communication)
> 
> 60789afc02f5 Bluetooth: Shutdown controller after workqueues are flushed or cancelled
> 	Breaks Bluetooth on various devices (Mediatek and possibly others)
> 	Discussion: https://lkml.org/lkml/2021/7/28/569
> 
> Unfortunately, it appears that all our testing doesn't cover SPI and Bluetooth.
> 
> I understand that upstream is just as broken until fixes are applied there.
> Still, it shows that our test coverage is far from where it needs to be,
> and/or that we may be too aggressive with backporting patches to stable
> releases.
> 
> If you have an idea how to improve the situation, please let me know.

The first one is really interesting. The author did all the job right
by documenting what commit this patch fixed, this commit was indeed
present in the stable branches, and given that the change is probably
only understood by the driver's maintainer, it's very likely that he
did that in good faith after some testing on real hardware. So there's
little chance that any extra form of automated testing will catch this
if it worked at least in one place.

It looks like a typical "works for me" regression. The best thing that
could possibly be done to limit such occurrences would be to wait "long
enough" before backporting them, in hope to catch breakage reports before
the backport, but here there were already 3 weeks between the patch was
submitted and it was backported.

One solution might be to further increase the delay between the patch
and its integration, but do we think it could increase the likelyhood
that the bug is detected and reported in *some* environment ? And if
so, is the overall situation any better with *some* users experiencing
a possible rare regression compared to leaving 100% of the users exposed
to a known bug in stable branches ? That's always difficult. As a user
of the stable branches I personally prefer to risk a rare regression and
report it than not getting fixes, because if the risk of regression in a
patch is 1%, I'd rather get 99 useful fixes and 1 regression than no fix
for a bug that bothers me.

So very likely the most robust solution is to further encourage users
to report regressions as soon as they are met so that the faulty commits
are spotted, reverted, and their author is aware that a corner case was
identified. Greg is always very fast to respond to requests for reverts.

Also, for a developer, being aware of a deployment exhibiting an issue
is extremely valuable, and the chances of spotting an issue and getting
it fixed are much higher if the delay between integration and deployment
is shorter. Otherwise it can sometimes take months to years before driver
code lands into users' hands, especially with embedded systems where the
rule remains "if it's not broken, don't touch it".

So in the end, the more often users upgrade, the better both for them and
to spot issues. I know it doesn't please everyone, but while nobody likes
bugs, someone has to face them at some point in order to report them :-/

In an ideal world we could imagine that postponing sensitive backports to
older branches would improve their stability and reduce users' exposure.
We're doing this to a certain extent in haproxy and it sort-of works. But
the cost of keeping fixes in queue and postponing them is high and the
risk of failing a backport is much higher this way, because either you
prepare all the backports at once and you risk that the context changed
between the initial backport and the merge, or you have to them at the
last moment, without remembering any of the analysis that had to be done
for the first branches.

Maybe in the end a sweet spot could be to just release older branches less
often and with more patches each time, offering more chances to expose the
faulty backports to more recent branches and affecting super-stable users
even less ?

Just my two cents on this never-ending debate :-/
Willy
