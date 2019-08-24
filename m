Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B916C9BAE4
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 04:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfHXCdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 22:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfHXCdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 22:33:00 -0400
Received: from localhost (65-114-90-19.dia.static.qwest.net [65.114.90.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5FF21670;
        Sat, 24 Aug 2019 02:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566613979;
        bh=bIZr2EfqJP+oA7d2q9aSr2i35w3Q3/VnBY7KY54whTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nW2dot+22aws5M2vIfV+U682OQ2Yy3jF0732IK8djjLjS/EhRXgAhCI0k95IoMO8N
         rG6usWOBIMsg/1Y2MGbMyBQlDaluwTdmLbpKN062Nn8cFeuhNtF+1fUcxssIUPc6sd
         Xk15GD9aKmAzfktDd542Yl0TN4ETn+Q/72XAmrvg=
Date:   Fri, 23 Aug 2019 19:32:58 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190824023258.GA9862@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
 <20190822172619.GA22458@kroah.com>
 <20190823000527.0ea91c6b@mir>
 <20190822233847.GB24034@kroah.com>
 <20190823024248.11e2dac3@mir>
 <20190823062853.GC1581@sasha-vm>
 <20190823173627.GA1040@kroah.com>
 <20190824011805.GH1581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824011805.GH1581@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 09:18:05PM -0400, Sasha Levin wrote:
> On Fri, Aug 23, 2019 at 10:36:27AM -0700, Greg KH wrote:
> > On Fri, Aug 23, 2019 at 02:28:53AM -0400, Sasha Levin wrote:
> > > On Fri, Aug 23, 2019 at 02:42:48AM +0200, Stefan Lippers-Hollmann wrote:
> > > > Hi
> > > >
> > > > On 2019-08-22, Greg KH wrote:
> > > > > On Fri, Aug 23, 2019 at 12:05:27AM +0200, Stefan Lippers-Hollmann wrote:
> > > > > > On 2019-08-22, Greg KH wrote:
> > > > > > > On Thu, Aug 22, 2019 at 01:05:56PM -0400, Sasha Levin wrote:
> > > > [...]
> > > > > > It might be down to kernel.org mirroring, but the patch file doesn't
> > > > > > seem to be available yet (404), both in the wrong location listed
> > > > > > above - and the expected one under
> > > > > >
> > > > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
> > > > [...]
> > > > > Ah, no, it's not a mirroring problem, Sasha and I didn't know if anyone
> > > > > was actually using the patch files anymore, so it was simpler to do a
> > > > > release without them to see what happens. :)
> > > > >
> > > > > Do you rely on these, or can you use the -rc git tree or the quilt
> > > > > series?  If you do rely on them, we will work to fix this, it just
> > > > > involves some scripting that we didn't get done this morning.
> > > >
> > > > "Rely" is a strong word, I can adapt if they're going away, but
> > > > I've been using them so far, as in (slightly simplified):
> > > >
> > > > $ cd patches/upstream/
> > > > $ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.2.9.xz
> > > > $ xz -d patch-5.2.9.xz
> > > > $ wget https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
> > > > $ gunzip patch-5.2.10-rc1.gz
> > > > $ vim ../series
> > > > $ quilt ...
> > > >
> > > > I can switch to importing the quilt queue with some sed magic (and I
> > > > already do that, if interesting or just a larger amounts of patches are
> > > > queuing up for more than a day or two), but using the -rc patches has
> > > > been convenient in that semi-manual workflow, also to make sure to really
> > > > get and test the formal -rc patch, rather than something inbetween.
> > > 
> > > An easy way to generate a patch is to just use the git.kernel.org web
> > > interface. A patch for 5.2.10-rc1 would be:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.2.y&id2=v5.2.9
> > > 
> > > Personally this patch upload story sounded to me like a pre-git era
> > > artifact...
> > 
> > Given that we no longer do patches for Linus's -rc releases for the past
> > few years, maybe it is time to move to do the same for the stable
> > releases to be consistent.
> 
> Or tarballs? Why do we generate tarballs (and go through kup)?
> git.kernel.org already does it for us.

As I mentioned yesterday, but writing it down here for posterity,
there's a number of reasons.

First off, the release process doesn't require kup for when a "real"
release happens, that's all now donw on git.kernel.org with a process
involving a signed note and some other fun backend stuff.  We are
working on expanding that in the future with some other signature
validation as well, to make it easier to verify tarballs are "correct"
as what we do today is a bit different than other projects.

As for the tarball itself, it's still needed for the same reasons we do
so on Linus's releases:
	- distros use these.  Don't want all Gentoo users hammering on
	  git.kernel.org for their updated builds, that's a huge waste.
	- mirroring works _so_ much better around the world for tarballs
	- legal reasons.  git is not yet "recognized" as being something
	  that properly is reflective of a specific point in time while
	  as online tarballs that are mirrored and stored around the
	  world are finally almost properly recognized for this.
	- historical, people are used to using them, and workflows are
	  built up around them.  People don't like rewriting scripts, as
	  can be seen in my monstrosity of a mess that I use for
	  releases :)

there are probably others, I know it came up when Linus stopped doing it
for the -rc releases and it was considered to do the same for the "real"
releases.

thanks,

greg k-h
