Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7AD6B6068
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCKUMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 15:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCKUMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 15:12:12 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E2494E5CC;
        Sat, 11 Mar 2023 12:12:09 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32BKBpGh030409;
        Sat, 11 Mar 2023 21:11:51 +0100
Date:   Sat, 11 Mar 2023 21:11:51 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzghyeiac3Zh8Hh@1wt.eu>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzVbzthi8IfptFZ@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 11:24:31AM -0800, Eric Biggers wrote:
> > But thinking that having one person review patches affecting many
> > subsystem after pre-selection and extra info regarding discussions on
> > each individual patch could result in more reliable stable releases is
> > just an illusion IMHO, because the root of problem is that there are not
> > enough humans to fix all the problems that humans introduce in the first
> > place, and despite this we need to fix them. Just like automated scripts
> > scraping lore, AUTOSEL does bring some value if it offloads some work
> > from the available humans, even in its current state. And I hope that
> > more of the selection and review work in the future will be automated
> > and even less dependent on humans, because it does have a chance to be
> > more reliable in front of that vast amount of work.
> 
> As I said in a part of my email which you did not quote, the fallback option is
> to send the list of issues to the mailing list for others to review.

Honestly, patches are already being delivered publicly tagged AUTOSEL,
then published again as part of the stable review process. Have you seen
the amount of feedback ? Once in a while there are responses, but aside
Guenter reporting build successes or failures, it's a bit quiet. What
makes you think that sending more detailed stuff that require even more
involvement and decision would trigger more participation ?

> If even that fails, then it could be cut down to the *just the most useful*
> heuristics and decisions made automatically based on those...  "Don't AUTOSEL
> patch N of a series without 1...N-1" might be a good one.

I do think that this one would be an improvement. But it needs to push
harder. Not "don't autosel", but sending the message to relevant parties
(all those involved in the patch being reviewed and merged) indicating
"we are going to merge this patch, but it's part of the following series,
should any/all/none of them be picked ? barring any response only this
patch will be picked". And of course, ideally all selected ones from a
series should be proposed at once to ease the review.

> But again, this comes back to one of the core issues here which is how does one
> even build something for the stable maintainers if their requirements are
> unknown to others?

Well, the description of the commit message is there for anyone to
consume in the first place. A commit message is an argument for a
patch to get adopted and resist any temptations to revert it. So
it must be descriptive enough and give instructions. Dependencies
should be clear there. When you seen github-like one-liners there's
no hope to get much info, and it's not a matter of requirements,
but of respect for a team development process where some facing your
patch might miss the skills required to grasp the details. With a
sufficiently clear commit message, even a bot can find (or suggest)
dependencies. And this is not specific to -stable: if one of the
dependencies is found to break stuff, how do you know it must not be
reverted without reverting the whole series if that's not described
anywhere ?

> > And in any case I've seen you use the word "trivial" several times in
> > this thread, and for having been through a little bit of this process
> > in the past, I wouldn't use that word anywhere in a description of what
> > my experience had been. You really seem to underestimate the difficulty
> > here.
> 
> I checked the entire email thread
> (https://lore.kernel.org/stable/?q=f%3Aebiggers+trivial).  The only place I used
> the word "trivial" was mentioning that querying lore.kernel.org from a Python
> script might be trivial, which is true.

I'm unable to do it, so at best it's trivial for someone at ease with
Python and the lore API. And parsing the results and classifying them
might not be trivial at all either. Getting information is one part,
processing it is another thing.

> And also in my response to Sasha's
> similar false claim that I was saying everything would be trivial.
> 
> I'm not sure why you're literally just making things up; it's not a very good
> way to have a productive discussion...

I'm not making things up. Maybe you wrote "trivial" only once but the tone
of your suggestions from the beginning was an exact description of something
called trivial and made me feel you find all of this "trivial", which you
finally confirmed in that excerpt above.

Quite frankly, I'm not part of this process anymore and am really thankful
that the current maintainers are doing that work. But it makes me feel
really uneasy to read suggestions basically sounding like "why don't you
fix your broken selection process" or "it should just be as trivial as
collecting the missing info from lore". Had I received such contemptuous
"suggestions" when I was doing that job, I would just have resigned. And
just saying things like "I will not start helping before you change your
attitude" you appear infantilizing at best and in no way looking like
you're really willing to help. Sasha said he was open to receive proposals
and suddenly the trivial job gets conditions. Just do your part of the
work that seems poorly done to you, and everyone will see if your ideas
and work finally helped or not. Nobody will even care if it was trivial
or if it ended up taking 4 months of refining, as long as it helps in
the end. But I suspect that you're not interested in helping, just in
complaining.

One thing I think that could be within reach and could very slightly
improve the process would be to indicate in a stable announce the amount
of patches coming from autosel. I think that it could help either
refining the selection by making users more conscious about the importance
of this source, or encourage more developers to Cc stable to reduce that
ratio. Just an idea.

Willy
