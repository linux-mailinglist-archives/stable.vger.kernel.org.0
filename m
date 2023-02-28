Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD99A6A5251
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 05:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjB1EZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 23:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjB1EZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 23:25:56 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE73E23644;
        Mon, 27 Feb 2023 20:25:47 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 31S4P6A5020441;
        Tue, 28 Feb 2023 05:25:06 +0100
Date:   Tue, 28 Feb 2023 05:25:06 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/2CItwJ4Yx8Jreo@1wt.eu>
References: <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/01z4EJNfioId1d@casper.infradead.org>
 <Y/1QV9mQ31wbqFnp@sashalap>
 <Y/1YJWs355TimFz1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/1YJWs355TimFz1@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 01:25:57AM +0000, Eric Biggers wrote:
> On Mon, Feb 27, 2023 at 07:52:39PM -0500, Sasha Levin wrote:
> > > > > Nothing has changed, but that doesn't mean that your process is actually
> > > > > working.  7 days might be appropriate for something that looks like a security
> > > > > fix, but not for a random commit with no indications it is fixing anything.
> > > > 
> > > > How do we know if this is working or not though? How do you quantify the
> > > > amount of useful commits?
> > > 
> > > Sasha, 7 days is too short.  People have to be allowed to take holiday.
> > 
> > That's true, and I don't have strong objections to making it longer. How
> > often did it happen though? We don't end up getting too many replies
> > past the 7 day window.
> > 
> > I'll bump it to 14 days for a few months and see if it changes anything.
> 
> It's not just for the review time, but also for the longer soak time in
> mainline.

There's a tradeoff to find. I'm sure there are way many more stable users
than mainline users. Does this mean we have to break stable from time to
time to detect regressions ? Sadly, yes. And it's not specific to Linux,
it's the same for virtually any other project that supports maintenance
branches. I personally like the principle of delaying backports to older
branches so that users relying on much older branches know they're having
a much more stable experience because the rare regressions that happen in
faster moving branches have more time to be caught. But that requires
incredibly more complex management.

On another project I'm sometimes seeing regressions caused by fixes pop
up after 6 months of exposure in stable. And comparatively, regressions
caused by new features tend to pop up faster, and users occasionally face
such bugs in stable just because the backport got delayed. So there's no
perfect balance, the problem is that any code change must be executed in
field a few times to know if it's solid or not. The larger the exposure
(i.e. stable) the faster regressions will be reported. The more frequent
the code is triggered, the faster as well. Fixes for bugs that are very
hard to trigger can cause regressions that will take ages to be reported.
But nonetheless users want these fixes because most of the time they are
correct.

When I was maintaining extended LTS kernels such as 2.6.32 or 3.10, users
were mostly upgrading when they were waiting for a specific fix. And even
there, despite patches having being present in regular stable kernels for
months, we faced regressions. Sometimes a fix was not suitable for that
branch, sometimes it was incorrectly backported, etc. What's certain
however, is that the longer you wait for a backport, the more difficult
it becomes to find someone who still remembers well about that fix and
its specificities, even during the review. This really has to be taken
into account when suggesting increased delays.

I really think that it's important to get backports early in recent stable
branches. E.g. we could keep these 7 days till the last LTS branch, and
let them cook one or two extra weeks before reaching older releases. But
we wouldn't want to delay important fixes too much (which are still likely
to cause regressions, especially security fixes which tend to focus on a
specifically reported case). Maybe we could imagine that the Cc: stable
could have a variant to mean "urgent" for important fixes that we want
to bypass the wait time, and that by default other ones would flow a bit
more slowly. This could satisfy most users by staying on the branch that
brings them the update rate they need. But that would certainly be quite
some extra work for Greg and for reviewers and that's certainly not cool,
so we need to be reasonable here as well.

Just my two cents,
Willy
