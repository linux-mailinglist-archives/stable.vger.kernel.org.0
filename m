Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604866A504C
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 01:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjB1Awu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 19:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB1Awp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 19:52:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2739298DB;
        Mon, 27 Feb 2023 16:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52E70B80DD6;
        Tue, 28 Feb 2023 00:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC39C433EF;
        Tue, 28 Feb 2023 00:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677545561;
        bh=wX7w95mMFRf+sC/g2N5poZRs+gBImsllRdEeOYedA9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFx/vAvFODfYDII8Rr81BwnChAYdCNxC9tNo/Oz8VhEONHDOUm1EMX7MCdbp8A6LR
         +oMdRD9iRi2cax4VuNTZAHEcg23Zjrrwan14eFgnL3TPGccGR8bRM14OXi9jeIrNxQ
         s+zayBX3Z/VlntOznziR+Qqpt3c0IWFqEBOhLf44sbmRSw4ZUCWM4IIh9C60UDCWYH
         6Dlb8UBRi8u9jKCJ2RCMIeahLTMuXGU2OZtWSgoCXZEKLa9PdMqSdQhhq7Tsvj7tdz
         mshnY1R2JWhsL8aP2Urut2dmuVq0eN0NdnOKH6HOj7XkweUGoK/z9hW4rk8W7mE9di
         h/8QRUJvQx5Ug==
Date:   Mon, 27 Feb 2023 19:52:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/1QV9mQ31wbqFnp@sashalap>
References: <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/01z4EJNfioId1d@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/01z4EJNfioId1d@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 10:59:27PM +0000, Matthew Wilcox wrote:
>On Mon, Feb 27, 2023 at 05:35:30PM -0500, Sasha Levin wrote:
>> On Mon, Feb 27, 2023 at 09:38:46PM +0000, Eric Biggers wrote:
>> > Just because you can't be 100% certain whether a commit is a fix doesn't mean
>> > you should be rushing to backport random commits that have no indications they
>> > are fixing anything.
>>
>> The difference in opinion here is that I don't think it's rushing: the
>> stable kernel rules say a commit must be in a released kernel, while the
>> AUTOSEL timelines make it so a commit must have been in two released
>> kernels.
>
>Patches in -rc1 have been in _no_ released kernels.  I'd feel a lot
>better about AUTOSEL if it didn't pick up changes until, say, -rc4,
>unless they were cc'd to stable.

This happened before my time, but -rc are considered releases.

The counter point to your argument/ask is that if you run the numbers on
regressions between -rc releases, it's the later one that tend to
introduce (way) more issues.

I've actually written about it a few years back to ksummit discuss
(here: https://lwn.net/Articles/753329/) because the numbers I saw
indicate that later -rc releases are 3x likely to introduce a
regression.

Linus pushed back on it saying that it is "by design" because those
commits are way more complex than ones that land during the early -rc
cycles.

So yes, I don't mind modifying the release workflow to decrease the
regressions we introduce, but I think that there's a difference between
what folks see as "helpful" and the outcome it would have.

>> > Nothing has changed, but that doesn't mean that your process is actually
>> > working.  7 days might be appropriate for something that looks like a security
>> > fix, but not for a random commit with no indications it is fixing anything.
>>
>> How do we know if this is working or not though? How do you quantify the
>> amount of useful commits?
>
>Sasha, 7 days is too short.  People have to be allowed to take holiday.

That's true, and I don't have strong objections to making it longer. How
often did it happen though? We don't end up getting too many replies
past the 7 day window.

I'll bump it to 14 days for a few months and see if it changes anything.

>> I'd love to improve the process, but for that we need to figure out
>> criteria for what we consider good or bad, collect data, and make
>> decisions based on that data.
>>
>> What I'm getting from this thread is a few anecdotal examples and
>> statements that the process isn't working at all.
>>
>> I took Jon's stablefixes script which he used for his previous articles
>> around stable kernel regressions (here:
>> https://lwn.net/Articles/812231/) and tried running it on the 5.15
>> stable tree (just a random pick). I've proceeded with ignoring the
>> non-user-visible regressions as Jon defined in his article (basically
>> issues that were introduced and fixed in the same releases) and ended up
>> with 604 commits that caused a user visible regression.
>>
>> Out of those 604 commits:
>>
>>  - 170 had an explicit stable tag.
>>  - 434 did not have a stable tag.
>
>I think a lot of people don't realise they have to _both_ put a Fixes
>tag _and_ add a Cc: stable.  How many of those 604 commits had a Fixes
>tag?

What do you mean? Just a cc: stable tag is enough to land it in stable,
you don't have to do both. The numbers above reflect that.

Running the numbers, there are 9422 commits with a Fixes tag in the 5.15
tree, out of which 360 had a regression, so 360 / 9422 = 3.82%.

-- 
Thanks,
Sasha
