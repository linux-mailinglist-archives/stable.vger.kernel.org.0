Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18871312BD
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 14:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAFNU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 08:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAFNUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 08:20:55 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8412071A;
        Mon,  6 Jan 2020 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578316855;
        bh=mM+iD0kGEEU1a0nAuY0M/dAz86bzvbki6bF1CZGUYYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edOx1dqKP7AlG+c8eYfgLWXGwJkBa+G0Z8qVljVFaep0mslAGsLO+nV/LXp3yiLFX
         7nfkksV5w+/lA1au/6/sl1e0+gADROe4/9ewPtZk3phGkYFowmAvk1Sf+qgzR08Xen
         fhNSIoep7TbXr12thR+gKQ9IMAqFqwl8ab4IHyRA=
Date:   Mon, 6 Jan 2020 08:20:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200106132053.GA1706@sasha-vm>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com>
 <20200102212837.GA9400@roeck-us.net>
 <20200103004024.GM16372@sasha-vm>
 <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
 <20200105160204.GR16372@sasha-vm>
 <9c295487-5e28-0fa7-7892-59e61cd7d07e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9c295487-5e28-0fa7-7892-59e61cd7d07e@roeck-us.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 05, 2020 at 08:34:59AM -0800, Guenter Roeck wrote:
>I think we are going into the absolutely wrong direction. Expecting that
>everyone would use mainline is absolutely unrealistic, and backporting
>more and more patches to stable branches can only result in destabilizing
>stable branches, which in turn will drive people away from it (and _not_
>to use mainline). The only reason it wasn't a disaster yet is that we have
>better testing now. But we offset that better testing with backporting
>more patches, which has the opposite effect. One stabilizes, the other
>destabilizes. The end result is the same. Actually, it is worse - the
>indiscriminate backporting not only causes unnecessary regressions,
>it (again) gives people an argument against merging stable releases.
>And, this time I have to admit they are right.

Just to get an idea of how the AUTOSEL commits affect the kernel tree I
tried the following:

We have 10648 commits on top of 4.19 in the 4.19 LTS tree:

$ git log --oneline v4.19..stable/linux-4.19.y | wc -l
10468

I've tried to identify how many of them have a "Fixes:" tag pointing to
them, and how many were reverted (using it to identify buggy commits in
the stable tree), ending up with:

$ wc -l fixes
637 fixes

So about 6% of the commits that go in the stable tree have a follow up
fix or revert. Now, let's see where commits in the 4.19 LTS tree come
from:

$ git log --oneline --grep "Signed-off-by: Sasha Levin <sashal@kernel.org>" v4.19..stable/linux-4.19.y | wc -l
5475
$ git log --invert-grep --oneline --grep "Signed-off-by: Sasha Levin <sashal@kernel.org>" v4.19..stable/linux-4.19.y | wc -l
4993

In general, Greg is the one who picks up commits that are tagged for
stable, security issues, and patches requested by folks on the mailing
list. I'm mostly doing AUTOSEL, other distro trees, and mailing list
(but Greg still does the most of the mailing list work).

Anyway, looks like mostly an equal split between stable tagged commits
and AUTOSEL ones.

Now, looking at the buggy commits again, I check whether the commit came
via Greg or myself (just using it as a way to differentiate between
stable tagged commits/commits requested by users/etc and commits that
came in using AUTOSEL), and I get:

$ for i in $(cat fixes | awk {'print $2'}); do if [ $(git show $i | grep 'Signed-off-by: Sasha Levin <sashal@kernel.org>' | wc -l) -gt 0 ]; then echo "Sasha"; else echo "Greg"; fi; done | sort | uniq -c
    367 Greg
    270 Sasha

Which seems to show that AUTOSEL commits are actually less buggy than
stable tagged commits. Sure, this analysis isn't perfect, but if we
treat it purely as ballpark figures I think that it's enough to show
that picking up more fixes doesn't contribute to "destabilizing" the
stable trees.

-- 
Thanks,
Sasha
