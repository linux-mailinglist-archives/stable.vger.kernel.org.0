Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A44C6A4EC8
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 23:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjB0Wkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 17:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjB0WkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 17:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDAA303D4;
        Mon, 27 Feb 2023 14:37:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B2060EAC;
        Mon, 27 Feb 2023 22:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310E5C433D2;
        Mon, 27 Feb 2023 22:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677537332;
        bh=fBeTkS+fd7Qr2Pj1z9Nh1MUMay2j+R7rnVrdsuV9lKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VktEHKm7x7XYAvqz7f/5hgkgPNzH6fJdZVOx/La4j5b15PvLzDM+1QFRUUiCTeZue
         iBe+K52gvxr3aWHQxlVGeIG6IzDtrCKExXf2JrOzdCiuwReb5kqBiQPoPXIfo+J4WT
         RrCOV/hN6GzSv1wZvBQwOUuxY4BqWLgNgQ3v1JAzKGMKnt5GtjF1DdE3KQ1DBdSMNA
         8ChKq5TWsdI8o105oZMah72+UkmsZxCrSxmmyEKcrQ7DZHnjf3Tff5+ICG69ldXOx9
         axdoOQjCRNIKWK6qGdCDc4UWX2svq/5M8Iqj3XtIx3OLjMFVERDYKVZcQX7mHARKPJ
         RdoYkpPR8WKhQ==
Date:   Mon, 27 Feb 2023 17:35:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/0wMiOwoeLcFefc@sashalap>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y/0i5pGYjrVw59Kk@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 09:38:46PM +0000, Eric Biggers wrote:
>On Mon, Feb 27, 2023 at 03:39:14PM -0500, Sasha Levin wrote:
>> > > So to summarize, that buggy commit was backported even though:
>> > >
>> > >   * There were no indications that it was a bug fix (and thus potentially
>> > >     suitable for stable) in the first place.
>> > >   * On the AUTOSEL thread, someone told you the commit is broken.
>> > >   * There was already a thread that reported a regression caused by the commit.
>> > >     Easily findable via lore search.
>> > >   * There was also already a pending patch that Fixes the commit.  Again easily
>> > >     findable via lore search.
>> > >
>> > > So it seems a *lot* of things went wrong, no?  Why?  If so many things can go
>> > > wrong, it's not just a "mistake" but rather the process is the problem...
>> >
>> > BTW, another cause of this is that the commit (66f99628eb24) was AUTOSEL'd after
>> > only being in mainline for 4 days, and *released* in all LTS kernels after only
>> > being in mainline for 12 days.  Surely that's a timeline befitting a critical
>> > security vulnerability, not some random neural-network-selected commit that
>> > wasn't even fixing anything?
>>
>> I would love to have a mechanism that tells me with 100% confidence if a
>> given commit fixes a bug or not, could you provide me with one?
>
>Just because you can't be 100% certain whether a commit is a fix doesn't mean
>you should be rushing to backport random commits that have no indications they
>are fixing anything.

The difference in opinion here is that I don't think it's rushing: the
stable kernel rules say a commit must be in a released kernel, while the
AUTOSEL timelines make it so a commit must have been in two released
kernels.

Should we extend it? Maybe, I just don't think we have enough data to
make a decision either way.

>> w.r.t timelines, this is something that was discussed on the mailing
>> list a few years ago where we decided that giving AUTOSEL commits 7 days
>> of soaking time is sufficient, if anything changed we can have this
>> discussion again.
>
>Nothing has changed, but that doesn't mean that your process is actually
>working.  7 days might be appropriate for something that looks like a security
>fix, but not for a random commit with no indications it is fixing anything.

How do we know if this is working or not though? How do you quantify the
amount of useful commits?

How do you know if a certain fix has security implications? Or even if
it actually fixes anything? For every "security" commit tagged for
stable I could probably list a "security" commit with no tags whatsoever.

>BTW, based on that example it's not even 7 days between AUTOSEL and patch
>applied, but actually 7 days from AUTOSEL to *release*.  So e.g. if someone
>takes just a 1 week vacation, in that time a commit they would have NAK'ed can
>be AUTOSEL'ed and pushed out across all LTS kernels...

Right, and same as above: what's "enough"?

>> Note, however, that it's not enough to keep pointing at a tiny set and
>> using it to suggest that the entire process is broken. How many AUTOSEL
>> commits introduced a regression? How many -stable tagged ones did? How
>> many bugs did AUTOSEL commits fix?
>
>So basically you don't accept feedback from individual people, as individual
>people don't have enough data?

I'd love to improve the process, but for that we need to figure out
criteria for what we consider good or bad, collect data, and make
decisions based on that data.

What I'm getting from this thread is a few anecdotal examples and
statements that the process isn't working at all.

I took Jon's stablefixes script which he used for his previous articles
around stable kernel regressions (here:
https://lwn.net/Articles/812231/) and tried running it on the 5.15
stable tree (just a random pick). I've proceeded with ignoring the
non-user-visible regressions as Jon defined in his article (basically
issues that were introduced and fixed in the same releases) and ended up
with 604 commits that caused a user visible regression.

Out of those 604 commits:

  - 170 had an explicit stable tag.
  - 434 did not have a stable tag.

Looking at the commits in the 5.15 tree:

With stable tag:

	$ git log --oneline -i --grep "cc.*stable" v5.15..stable/linux-5.15.y | wc -l
	3676

Without stable tag (-96 commits which are version bumps):

	$ git log --oneline --invert-grep -i --grep "cc.*stable" v5.15..stable/linux-5.15.y | wc -l
	10649

Regression rate for commits with stable tag: 170 / 3676 = 4.62%
Regression rate for commits without a stable tag: 434 / 10553 = 4.11%

Is the analysis flawed somehow? Probably, and I'd happy take feedback on
how/what I can do better, but this type of analysis is what I look for
to know if the process is working well or not.

-- 
Thanks,
Sasha
