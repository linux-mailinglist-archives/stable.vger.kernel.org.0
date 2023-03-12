Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADFA6B636A
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 06:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjCLFtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 00:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjCLFtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 00:49:07 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16F1C3ABC;
        Sat, 11 Mar 2023 21:48:53 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 32C5mbBh000603;
        Sun, 12 Mar 2023 06:48:37 +0100
Date:   Sun, 12 Mar 2023 06:48:37 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA1ntR9zulFAZyKJ@1wt.eu>
References: <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain>
 <ZA1V4MbG6U3wP6q6@1wt.eu>
 <ZA1hdkrOKLG697RG@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA1hdkrOKLG697RG@sol.localdomain>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:21:58PM -0800, Eric Biggers wrote:
> I mean, "patches welcome" is a bit pointless when there is nothing to patch, is
> it not?

Maybe it's because they're used to regularly receive complaints suggesting
to improve the process without knowing where to start from.

> Even Sasha's stable-tools, which he finally gave a link to, does not
> include anything related to AUTOSEL.  It seems AUTOSEL is still closed source.

I don't know.

> BTW, I already did something similar "off to the side" a few years ago when I
> wrote a script to keep track of and prioritize syzbot reports from
> https://syzkaller.appspot.com/, and generate per-subsystem reminder emails.
> 
> I eventually ended up abandoning that, because doing something off to the side
> is not very effective and is hard to keep up with.  The right approach is to
> make improvements to the "upstream" process (which was syzbot in that case), not
> to bolt something on to the side to try to fix it after the fact.

I think that improving the upstreaming process does have some value,
of course, especially when it's done from tools that can reliably and
durably be improved. But it's not rocket science when input comes from
humans. We still occasionally see patches missing an s-o-b. Humans can't
be fixed, and the more the constraints that are added on them, the higher
the failure rate they will show. However, regardless of the detailed
knowledge of how to format this or that tag, it should still be possible
for any patch author to answer the question "what do you want us to do
with that patch". If most of the patches at least contain such info, it
already becomes possible to figure after it gets merged whether the intent
was to get it backported or not. It's not trivial but NLP and code analysis
definitely help on this. And there will always be some patches whose need
for backporting will be detected after the merge. That's why I'm seeing a
lot of value in the post-processing part, because for me trying to fix
the input will have a very limited effect.

And let's face it, if a patch series gets merged, it means that at some
point someone understood what to do with it, so all the needed information
was already there, given a certain context. The cost is thousands of
brains needed to decode that. But with the improvements in language
processing, we should at some point be able to release some brains with
more-or-less similar results and try to lower the barrier to contribution
by relaxing patch submission rules instead of adding more. My feeling is
that it's what we should aim for given that the number of maintainers and
contributors doesn't seem to grow as fast as the code size and complexity.

That's where I'm seeing a lot of value in the AUTOSEL work. If it can show
the direction to something better so that in 3 or 4 years we can think
back and say "remember the garbage it was compared to what we have now",
I think it will have been a fantastic success.

> So I hope people can understand where I'm coming from, with hoping that what the
> stable maintainers are doing can just be improved directly, without first
> building something from scratch off to the side as that is just not a good way
> to do things.

It's generally not good but here there's little to start from, and
experimenting with your ideas on LKML threads or commit series can be
a nice way to explore completely different approaches without being
limited by what currently exists. Maybe you'll end up with something
completely orthogonal and the combination of both of your solutions
will already be a nice improvement. who knows.

> But sure, if that's the only option to get anything nontrivial
> changed, I'll try to do it.

Thanks!
Willy
