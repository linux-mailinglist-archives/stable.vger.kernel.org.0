Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEBF6A50D1
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 02:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjB1Bxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 20:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjB1Bxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 20:53:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13E81025A;
        Mon, 27 Feb 2023 17:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50293B80DD4;
        Tue, 28 Feb 2023 01:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94A6C433EF;
        Tue, 28 Feb 2023 01:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677549212;
        bh=XQgg7okNSt0UU7e0L/mKAh+e8h6zanHG5wBT7ARFUZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rjyqg/LjcvYKncjmpomKVMxb4CqnZ8IkgrAaGDIUZ6jZtTWO/jKU3NxzKnxJiCUKO
         cP1SOikVRCp4p/nxngLJvBBj6Nsu/dXipxeveSmfKxnszy6zyXcFIWbUkijTOBpTtE
         WIkUUf37Eo/oOii4zsYZNbXr0Szj+qLp7bqcAwFf39pOBB4KLST1kl4tHd672cZ9o6
         JaFSaaIIo3gO7kzQhqbWExf4uK8KndCIvnugsWAyB5rTKBsl0+LPwouc+YKU919f8F
         AaLik4l7QmXQZfrIoybE704GFYvIC0/7qYRp0UJhNsgLsjEIbe9Z4RXTrYkNjJB2oZ
         0NldmEbKcu4YA==
Date:   Mon, 27 Feb 2023 20:53:31 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/1em4ygHgSjIYau@sashalap>
References: <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/1LlA5WogOAPBNv@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 12:32:20AM +0000, Eric Biggers wrote:
>On Mon, Feb 27, 2023 at 05:35:30PM -0500, Sasha Levin wrote:
>> > > Note, however, that it's not enough to keep pointing at a tiny set and
>> > > using it to suggest that the entire process is broken. How many AUTOSEL
>> > > commits introduced a regression? How many -stable tagged ones did? How
>> > > many bugs did AUTOSEL commits fix?
>> >
>> > So basically you don't accept feedback from individual people, as individual
>> > people don't have enough data?
>>
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
>>
>> Looking at the commits in the 5.15 tree:
>>
>> With stable tag:
>>
>> 	$ git log --oneline -i --grep "cc.*stable" v5.15..stable/linux-5.15.y | wc -l
>> 	3676
>>
>> Without stable tag (-96 commits which are version bumps):
>>
>> 	$ git log --oneline --invert-grep -i --grep "cc.*stable" v5.15..stable/linux-5.15.y | wc -l
>> 	10649
>>
>> Regression rate for commits with stable tag: 170 / 3676 = 4.62%
>> Regression rate for commits without a stable tag: 434 / 10553 = 4.11%
>>
>> Is the analysis flawed somehow? Probably, and I'd happy take feedback on
>> how/what I can do better, but this type of analysis is what I look for
>> to know if the process is working well or not.
>
>I'm shocked that these are the statistics you use to claim the current AUTOSEL
>process is working.  I think they actually show quite the opposite!
>
>First, since many AUTOSEL commits aren't actually fixes but nearly all
>stable-tagged commits *are* fixes, the rate of regressions per commit would need
>to be lower for AUTOSEL commits than for stable-tagged commits in order for
>AUTOSEL commits to have the same rate of regressions *per fix*.  Your numbers
>suggest a similar regression rate *per commit*.  Thus, AUTOSEL probably
>introduces more regressions *per fix* than stable-tagged commits.

Interesting claim. How many of the AUTOSEL commits are "actual" fixes?
How do you know if a commit is a fix for anything or not?

Could you try and back claims with some evidence?

Yes, in a perfect world where we know if a commit is a fix we could
avoid introducing regressions into the stable trees. Heck, maybe we could
even stop writing buggy code to begin with?

>Second, the way you're identifying regression-introducing commits seems to be
>excluding one of the most common, maybe *the* most common, cause of AUTOSEL
>regressions: missing prerequisite commits.  A very common case that I've seen
>repeatedly is AUTOSEL picking just patch 2 or higher of a multi-patch series.
>For an example, see the patch that started this thread...  If a missing
>prerequisite is backported later, my understanding is that it usually isn't
>given a Fixes tag, as the upstream commit didn't have it.  I think such
>regressions aren't counted in your statistic, which only looks at Fixes tags.

It definitely happens, but we usually end up dropping the AUTOSEL-ed
commit rather than bringing in complex dependency chains.

Look at the stable-queue for a record of those.

>(Of course, stable-tagged commits sometimes have missing prerequisite bugs too.
>But it's expected to be at a lower rate, since the original developers and
>maintainers are directly involved in adding the stable tags.  These are the
>people who are more familiar than anyone else with prerequisites.)

You'd be surprised. There is documentation around how one would annotate
dependencies for stable tagged commits, something along the lines of:

	cc: stable@kernel.org # dep1 dep2

Grep through the git log and see how often this is actually used.

>Third, the category "commits without a stable tag" doesn't include just AUTOSEL
>commits, but also non-AUTOSEL commits that people asked to be added to stable
>because they fixed a problem for them.  Such commits often have been in mainline
>for a long time, so naturally they're expected to have a lower regression rate
>than stable-tagged commits due to the longer soak time, on average.  So if the
>regression rate of stable-tagged and non-stable-tagged commits is actually
>similar, that suggests the regression rate of non-stable-tagged commits is being
>brought up artifically by a high regression rate in AUTOSEL commits...

Yes, the numbers are pretty skewed up by different aspects of the
process.

>So, I think your statistics actually reflect quite badly on AUTOSEL in its
>current form.
>
>By the way, to be clear, AUTOSEL is absolutely needed.  The way you are doing it
>currently is not working well, though.  I think it needs to be tuned to select
>fewer, higher-confidence fixes, and you need to do some basic checks against
>each one, like "does this commit have a pending fix" and "is this commit part of

Keep in mind that there's some lag time between when we do our thing vs
when things appear upstream.

Greg actually runs the "is there a pending fix" check even after I've
pushed the patches, before he cuts releases.

>a multi-patch series, and if so are earlier patches needed as prerequisites".
>There also needs to be more soak time in mainline, and more review time.

Tricky bit with mainline/review time is that very few of our users
actually run -rc trees.

We end up hitting many of the regressions because the commits actually
end up in stable trees. Should it work that way? No, but our testing
story around -rc releases is quite lacking.

>IMO you also need to take a hard look at whatever neural network thing you are
>using, as from what I've seen its results are quite poor...  It does pick up
>some obvious fixes, but it seems they could have just as easily been found
>through some heuristics with grep.  Beyond those obvious fixes, what it picks up
>seems to be barely distinguishable from a random selection.

I mean... patches welcome? Do you want to come up with a set of
heuristics that performs better and give it a go? I'll happily switch
over.

I'm not sure how feedback in the form of "this sucks but I'm sure it
could be much better" is useful.

-- 
Thanks,
Sasha
