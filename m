Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945D46B60B6
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 21:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCKUyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCKUyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 15:54:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5980012BDB;
        Sat, 11 Mar 2023 12:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60778B80860;
        Sat, 11 Mar 2023 20:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FABAC433D2;
        Sat, 11 Mar 2023 20:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678568012;
        bh=ZYkjr2XoMlM0btFqxi7zQgF66jQtbZ3GF/Lmict1DWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYS4ED4DwOIfFB8hxVbnHmo21VrH5RzGiYYB1OrKCI5jmSVKa+Xr7VWmm+mio0cyP
         Dk612Y9t/dK6zJzgj1jXJwhFb96urx535TksWvwSFa1Fbfw2b5CxET7/wougY1z03M
         /X3rv0N3J5v3Kf1UVXJyTCeMNTaoz0Sl66YtpvcrwCbBMkqFrfABVSXbF+rb7ECIoR
         wBsGpmUHTGtVRXV83wEVA9Nx6H/F5HND4w9cXXB0Wb91jJpP3+NcOeGARkP58ZE5Oe
         i7u5twlT9eBo+k87IeAwE1tfz9Uhm6o1uSQ3hAJo073TsXwZIVl+nNBEWmqx4PrEQ7
         MjR36mkWhQXzA==
Date:   Sat, 11 Mar 2023 12:53:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzqSeus4iqCOf1O@sol.localdomain>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzghyeiac3Zh8Hh@1wt.eu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 09:11:51PM +0100, Willy Tarreau wrote:
> On Sat, Mar 11, 2023 at 11:24:31AM -0800, Eric Biggers wrote:
> > > But thinking that having one person review patches affecting many
> > > subsystem after pre-selection and extra info regarding discussions on
> > > each individual patch could result in more reliable stable releases is
> > > just an illusion IMHO, because the root of problem is that there are not
> > > enough humans to fix all the problems that humans introduce in the first
> > > place, and despite this we need to fix them. Just like automated scripts
> > > scraping lore, AUTOSEL does bring some value if it offloads some work
> > > from the available humans, even in its current state. And I hope that
> > > more of the selection and review work in the future will be automated
> > > and even less dependent on humans, because it does have a chance to be
> > > more reliable in front of that vast amount of work.
> > 
> > As I said in a part of my email which you did not quote, the fallback option is
> > to send the list of issues to the mailing list for others to review.
> 
> Honestly, patches are already being delivered publicly tagged AUTOSEL,
> then published again as part of the stable review process. Have you seen
> the amount of feedback ? Once in a while there are responses, but aside
> Guenter reporting build successes or failures, it's a bit quiet. What
> makes you think that sending more detailed stuff that require even more
> involvement and decision would trigger more participation ?

Well, there is not much people can do with 1000 patches with no context, but if
there's a much shorter list of potential issues to pay attention to, I'd hope
that would be helpful.

> > I checked the entire email thread
> > (https://lore.kernel.org/stable/?q=f%3Aebiggers+trivial).  The only place I used
> > the word "trivial" was mentioning that querying lore.kernel.org from a Python
> > script might be trivial, which is true.
> 
> I'm unable to do it, so at best it's trivial for someone at ease with
> Python and the lore API. And parsing the results and classifying them
> might not be trivial at all either. Getting information is one part,
> processing it is another thing.
> 
> > And also in my response to Sasha's
> > similar false claim that I was saying everything would be trivial.
> > 
> > I'm not sure why you're literally just making things up; it's not a very good
> > way to have a productive discussion...
> 
> I'm not making things up. Maybe you wrote "trivial" only once but the tone
> of your suggestions from the beginning was an exact description of something
> called trivial and made me feel you find all of this "trivial", which you
> finally confirmed in that excerpt above.

You are indeed making things up, which is annoying as it makes it hard to have a
real discussion.  Anyway, hopefully we can get past that.

> Quite frankly, I'm not part of this process anymore and am really thankful
> that the current maintainers are doing that work. But it makes me feel
> really uneasy to read suggestions basically sounding like "why don't you
> fix your broken selection process" or "it should just be as trivial as
> collecting the missing info from lore". Had I received such contemptuous
> "suggestions" when I was doing that job, I would just have resigned. And
> just saying things like "I will not start helping before you change your
> attitude" you appear infantilizing at best and in no way looking like
> you're really willing to help. Sasha said he was open to receive proposals
> and suddenly the trivial job gets conditions. Just do your part of the
> work that seems poorly done to you, and everyone will see if your ideas
> and work finally helped or not. Nobody will even care if it was trivial
> or if it ended up taking 4 months of refining, as long as it helps in
> the end. But I suspect that you're not interested in helping, just in
> complaining.
> 
> One thing I think that could be within reach and could very slightly
> improve the process would be to indicate in a stable announce the amount
> of patches coming from autosel. I think that it could help either
> refining the selection by making users more conscious about the importance
> of this source, or encourage more developers to Cc stable to reduce that
> ratio. Just an idea.

I'll try to put something together, despite all the pushback I'm getting.  But
by necessity it will be totally separate from the current stable scripts, as it
seems there is no practical way for me to do it otherwise, given that the
current stable process is not properly open and lacks proper leadership.

- Eric
