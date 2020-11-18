Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1B22B76D5
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 08:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgKRHTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 02:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgKRHTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 02:19:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E02532223D;
        Wed, 18 Nov 2020 07:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605683989;
        bh=NEsHhOBEkvu8whyvSBPaU0e4CXyz0LEOAoebVck/w9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJFrZA2D4DyWE9679kpxUFkK/1Gcmk30n/KXc7lmTTI3+ZQVIxbBJCYrek0XKeglR
         wFGEr9C7EWYylaKpcsBdfiyxGUSmT8273xFk7nOkWTSdR6p7dAu9f5FyzfiA4bqkbX
         u7+/XjN0vR5ckHzgYk//HRgCOgXOZ19TyG0EuoGM=
Date:   Wed, 18 Nov 2020 08:20:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     Hussam Al-Tayeb <ht990332@gmx.com>, stable@vger.kernel.org
Subject: Re: Suggestion: Lengthen the review period for stable releases from
 48 hours to 7 days.
Message-ID: <X7TLRCbNRM6ovIj9@kroah.com>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
 <20201117080141.GA6275@amd>
 <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
 <1605651898@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1605651898@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 11:29:16PM +0100, Christoph Biedl wrote:
> >> On Sat 2020-11-14 17:40:36, Hussam Al-Tayeb wrote:
> 
> >>> Hello. I would like to suggest lengthening the review period for stable
> >>> releases from 48 hours to 7 days.
> >>> The rationale is that 48 hours is not enough for people to test those
> >>> stable releases and make sure there are no regressions for
> >>> particular workflows.
> 
> Disclaimer: I am mostly a user of stable
> 
> It's hard to make a good decision here. I share your position the 48-ish
> hours are a fairly short amound of time, and increasing it would grant
> more time for tests. As for me, I might resume testing -rc on a regular
> base as I used to in the past - which is a time-consuming procedure, and
> since I do that as a hobby, sometimes more important things are in the
> way. But I have to concede the number of issues that occured only here
> was never high, and I don't expect it would grow significantly.
> 
> On the other hand the pace of the stable patches became fairly high¹, so
> during a week of -rc review a *lot* of them will queue up and I predict
> we'll see requests for fast-laning some of them. Also, a release would
> immediately be followed by the next -rc review period, a procedure that
> gives me a bad feeling.
> 
> So for me, I'd appreciate an extension of the review period, even if
> it's just four days. But I understand if people prefer to keep the
> procedures simple, and get fixes out of the door as soon as possible.

That's the thing, these releases almost always contain fixes that we
know people are having in the real world, or they fix reported security
issues, so we need to get them out to everyone as soon as possible.

If you are only a week or so behind (because your testing framework
takes a week), that's fine, let us know if we broke something last week
and we will be glad to revert it or find the fixup patch for it that is
in Linus's tree.  I work with almost all of the major SoC vendors and
they get back to me on this type of delayed cycle because their tests do
take longer, and it works fine.

Also, note that I do a release when the testers that I have come to rely
on tell me that all is good.  I think they are running some 50k+ tests
on each release at the moment, so while quantity isn't a substitute for
quality, it is a good indication that nothing regressed here which is
what I am looking for.  Recently these tests are coming back sooner than
2 days, which is great and why I do a release quicker at times
(sometimes it is because of just logistics reasons).

So slowing down releases is not the answer.  Getting back to me when you
have issues is the solution.  1-2-4 weeks is fine, just let us know if
you have regressions when you find them, otherwise we don't know that
there is an issue that needs to be resolved.

> ¹ If somebody made statistics on the development of the number of
>   patches for stable kernels (in count/second), I'd be curious to see
>   the numbers.

Yes, I have those numbers, we run about 30-35 patches/day in the stable
releases at the moment.  You can see this in the spreadsheet I keep at:
	https://github.com/gregkh/kernel-history
in the kernel_stats.ods file, look at the tabs on the bottom to see the
rate of change for the different stable releases.  It usually is a few
releases old, but I try to update it monthly.

thanks,

greg k-h
