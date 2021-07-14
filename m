Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706253C89DC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 19:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhGNRhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 13:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237394AbhGNRhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 13:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C24E613BE;
        Wed, 14 Jul 2021 17:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626284056;
        bh=VXOK22zekk8d0nAluf7/iFpjMB0tQ21s1pyi6ngOZa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lL8g74uPTYRpKc+z4V1/510oVl+jgZ6caECWjeZuzaqzCzn3uR+r5aMaiMJ4Oo5We
         UgTfe7AkQash+rWa6L0oPD8D7bQlCdtklmuL90kCB5q7CApXJ+xwHqcUtCiddQkFSe
         jZVpmLGMEe5nZCmTpDw3gra83zFzeJRMcOU8aAmI=
Date:   Wed, 14 Jul 2021 19:34:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO8gFgQIRYvCODBT@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
 <YO8EQZF4+iQ13QU/@mit.edu>
 <YO8Gzl2zmg8+R8Uu@kroah.com>
 <YO8dN9U7J2bi1gkf@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO8dN9U7J2bi1gkf@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 01:21:59PM -0400, Theodore Y. Ts'o wrote:
> On Wed, Jul 14, 2021 at 05:46:22PM +0200, Greg Kroah-Hartman wrote:
> > 
> > The number of valid cases where someone puts a "Fixes:" tag, and that
> > patch should NOT be backported is really really slim.  Why would you put
> > that tag and not want to have known-broken kernels fixed?
> > 
> > If it really is not an issue, just do not put the "Fixes:" tag?
> 
> I think it really boils down to what the tags are supposed to mean and
> what do they imply.
> 
> The argument from the other side is if the Stable maintainers are
> interpreting the Fixes: tag as an implicit "CC: stable", why should we
> have the "Cc: stable" tag at all in that case?

I would love to not have to look at the Fixes: tag, but today we have to
because not all subsystems DO use cc: stable.

We miss loads of real fixes if we only go by cc: stable right now.  If
you can go and fix those subsystems to actually remember to do this
"properly", wonderful, we will not have to mess with only Fixes: tags
again.

But until that happens, we have to live with what we have.  And all we
have are "hints" like Fixes: to go off of.

> We could also have the policy that in the case where you have a fix
> for a bug, but it's super subtle, and shouldn't be automatically
> backported, that the this should be explained in the commit, e.g.,
> 
>    This commit fixes a bug in "1adeadbeef33: lorem ipsum dolor sit
>    amet" but it is touching code which subtle and quick to anger, the
>    bug isn't all that serious.  So please don't backport it
>    automatically; someone should manually do the backport and run the
>    fooblat test before sumitting it to the stable maintainers.

That's wonderful, I would love to see that more, and we do see that on
some commits.  And we mostly catch them (I miss them at times, but
that's my fault, not the developer/maintainers fault.)

> Andrew seems to be of the opinion that these sorts of cases are very
> common.  I don't have enough data to have a strong opinion either way.
> But if you are right that it is a rare case, then sure, simply
> omitting the Fixes: tag and using text in the commit description would
> work.  We just need to agree that this is the convention that we all
> shoulf be using.
> 
> I still wonder though what's the point of having the "Cc: stable" tag
> if it's implicitly assumed to be there if there is a Fixes: tagle.

Because cc: stable came first, and for some reason people think that it
is all that is necessary to get patches committed to the stable tree,
despite it never being documented or that way.  I have to correct
someone about this about 2x a month on the stable@vger list.

thanks,

greg k-h
