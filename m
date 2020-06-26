Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA320B2AC
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFZNlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgFZNlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 09:41:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634F020656;
        Fri, 26 Jun 2020 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593178897;
        bh=d93gG8xLu0bdWSvPzGYw0JlH0G+Lle8pWw+rkNrkt0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EF9rfQkG8ACsYgD9pUm964oeFST7l6PwV8BSuulzJFGJPGZ/b+3T0Ezm7yc6EXaqj
         nlfCufn6Gw00cXo308+WvEBZbYJuZdZvKl2AZ2UYKRJc3KOWbwbj7TFscvIEW0O6Cc
         RJuF6zVEql+ZA6W7GvK3EoaFdN0ZQV1grJ7Od3Vc=
Date:   Fri, 26 Jun 2020 15:41:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steve McIntyre <steve@einval.com>
Cc:     Jann Horn <jannh@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        963493@bugs.debian.org
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+
 onwards
Message-ID: <20200626134132.GB4024297@kroah.com>
References: <20200626113558.GA32542@unset.einval.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626113558.GA32542@unset.einval.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 12:35:58PM +0100, Steve McIntyre wrote:
> Hi folks,
> 
> I'm the maintainer in Debian for strace. Trying to reproduce
> https://bugs.debian.org/963462 on my machine (Thinkpad T470), I've
> found a repeatable hard lockup running the strace testsuite. Each time
> it seems to have failed in a slightly different place in the testsuite
> (suggesting it's not one particular syscall test that's triggering the
> failure). I initially found this using Debian's current Buster kernel
> (4.19.118+2+deb10u1), then backtracking I found that 4.19.98+1+deb10u1
> worked fine.
> 
> I've bisected to find the failure point along the linux-4.19.y stable
> branch and what I've got to is the following commit:
> 
> e58f543fc7c0926f31a49619c1a3648e49e8d233 is the first bad commit
> commit e58f543fc7c0926f31a49619c1a3648e49e8d233
> Author: Jann Horn <jannh@google.com>
> Date:   Thu Sep 13 18:12:09 2018 +0200
> 
>     apparmor: don't try to replace stale label in ptrace access check
> 
>     [ Upstream commit 1f8266ff58840d698a1e96d2274189de1bdf7969 ]
> 
>     As a comment above begin_current_label_crit_section() explains,
>     begin_current_label_crit_section() must run in sleepable context because
>     when label_is_stale() is true, aa_replace_current_label() runs, which uses
>     prepare_creds(), which can sleep.
>     Until now, the ptrace access check (which runs with a task lock held)
>     violated this rule.
> 
>     Also add a might_sleep() assertion to begin_current_label_crit_section(),
>     because asserts are less likely to be ignored than comments.
> 
>     Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
>     Signed-off-by: Jann Horn <jannh@google.com>
>     Signed-off-by: John Johansen <john.johansen@canonical.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> :040000 040000 ca92f885a38c1747b812116f19de6967084a647e 865a227665e460e159502f21e8a16e6fa590bf50 M security
> 
> Considering I'm running strace build tests to provoke this bug,
> finding the failure in a commit talking about ptrace changes does look
> very suspicious...!
> 
> Annoyingly, I can't reproduce this on my disparate other machines
> here, suggesting it's maybe(?) timing related.
> 
> Hope this helps - happy to give more information, test things, etc.

So if you just revert this one patch, all works well?

I've added the authors of the patch to the cc: list...

Also, does this problem happen on Linus's tree?

thanks,

greg k-h
