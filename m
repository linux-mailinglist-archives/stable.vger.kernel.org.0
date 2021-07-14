Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4653C89A8
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhGNRZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 13:25:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:32785 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229592AbhGNRZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 13:25:09 -0400
Received: from callcc.thunk.org (96-65-121-81-static.hfc.comcastbusiness.net [96.65.121.81])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16EHLxpS021655
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 13:22:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 59F2A4202F5; Wed, 14 Jul 2021 13:21:59 -0400 (EDT)
Date:   Wed, 14 Jul 2021 13:21:59 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <YO8dN9U7J2bi1gkf@mit.edu>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
 <YO8EQZF4+iQ13QU/@mit.edu>
 <YO8Gzl2zmg8+R8Uu@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO8Gzl2zmg8+R8Uu@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 05:46:22PM +0200, Greg Kroah-Hartman wrote:
> 
> The number of valid cases where someone puts a "Fixes:" tag, and that
> patch should NOT be backported is really really slim.  Why would you put
> that tag and not want to have known-broken kernels fixed?
> 
> If it really is not an issue, just do not put the "Fixes:" tag?

I think it really boils down to what the tags are supposed to mean and
what do they imply.

The argument from the other side is if the Stable maintainers are
interpreting the Fixes: tag as an implicit "CC: stable", why should we
have the "Cc: stable" tag at all in that case?

We could also have the policy that in the case where you have a fix
for a bug, but it's super subtle, and shouldn't be automatically
backported, that the this should be explained in the commit, e.g.,

   This commit fixes a bug in "1adeadbeef33: lorem ipsum dolor sit
   amet" but it is touching code which subtle and quick to anger, the
   bug isn't all that serious.  So please don't backport it
   automatically; someone should manually do the backport and run the
   fooblat test before sumitting it to the stable maintainers.

Andrew seems to be of the opinion that these sorts of cases are very
common.  I don't have enough data to have a strong opinion either way.
But if you are right that it is a rare case, then sure, simply
omitting the Fixes: tag and using text in the commit description would
work.  We just need to agree that this is the convention that we all
shoulf be using.

I still wonder though what's the point of having the "Cc: stable" tag
if it's implicitly assumed to be there if there is a Fixes: tagle.

Cheers,

					- Ted
