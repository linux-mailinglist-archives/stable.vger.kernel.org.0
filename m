Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C6B11AF2
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfEBOK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBOK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 10:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4E42085A;
        Thu,  2 May 2019 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556806227;
        bh=QxAlPHYrTQbmA3ABN8XKzZvh9O6MF8KxFjuWsdNo/g4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCIESwC6GtBYZPNJsZ/nzMn50n4zOPzRAa1/a+GtVPKZkHxYHUIYluzfflaQK7k72
         2vwZxly+RqRSNCMErGO+HMfIDJsAAjmCctvdCcgvBhxoKRge1T2Du3b9IlKkCYKksq
         ZgOa37cow98eE1Z0ChJl5/GrOZcEhsHWQWNZSDGU=
Date:   Thu, 2 May 2019 16:10:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andre Noll <maan@tuebingen.mpg.de>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502141025.GB13141@kroah.com>
References: <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502132027.GF11584@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 09:20:27AM -0400, Sasha Levin wrote:
> On Thu, May 02, 2019 at 01:44:40PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, May 02, 2019 at 08:11:07AM +1000, Dave Chinner wrote:
> > > On Wed, May 01, 2019 at 12:28:22PM -0700, Darrick J. Wong wrote:
> > > > On Wed, May 01, 2019 at 07:51:29PM +0200, Andre Noll wrote:
> > > > > On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
> > > > > > On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
> > > > > > > On Wed, May 01, 08:36, Darrick J. Wong wrote
> > > > > > > > > > You could send this patch to the stable list, but my guess is that
> > > > > > > > > > they'd prefer a straight backport of all three commits...
> > > > > > > > >
> > > > > > > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
> > > > > > > > > four conflicting files. The conflicts are trivial to resolve (git
> > > > > > > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> > > > > > > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> > > > > > > > > (xfs: create a function to query all records in a btree) is needed as
> > > > > > > > > well. But then, applying 86210fbebae (xfs: move various type verifiers
> > > > > > > > > to common file) on top of that gives non-trivial conflicts.
> > > > > > > >
> > > > > > > > Ah, I suspected that might happen.  Backports are hard. :(
> > > > > > > >
> > > > > > > > I suppose one saving grace of the patch you sent is that it'll likely
> > > > > > > > break the build if anyone ever /does/ attempt a backport of those first
> > > > > > > > two commits.  Perhaps that is the most practical way forward.
> > > > > > > >
> > > > > > > > > So, for automatic backporting we would need to cherry-pick even more,
> > > > > > > > > and each backported commit should be tested of course. Given this, do
> > > > > > > > > you still think Greg prefers a rather large set of straight backports
> > > > > > > > > over the simple commit that just pulls in the missing function?
> > > > > > > >
> > > > > > > > I think you'd have to ask him that, if you decide not to send
> > > > > > > > yesterday's patch.
> > > > > > >
> > > > > > > Let's try. I've added a sentence to the commit message which explains
> > > > > > > why a straight backport is not practical, and how to proceed if anyone
> > > > > > > wants to backport the earlier commits.
> > > > > > >
> > > > > > > Greg: Under the given circumstances, would you be willing to accept
> > > > > > > the patch below for 4.9?
> > > > > >
> > > > > > If the xfs maintainers say this is ok, it is fine with me.
> > > > >
> > > > > Darrick said, he's in favor of the patch, so I guess I can add his
> > > > > Acked-by. Would you also like to see the ack from Dave (the author
> > > > > of the original commit)?
> > > >
> > > > FWIW it seems fine to me, though Dave [cc'd] might have stronger opinions...
> > > 
> > > Only thing I care about is whether it is QA'd properly. Greg, Sasha,
> > > is the 4.9 stable kernel having fstests run on it as part of the
> > > release gating?
> > 
> > I do not know about fstests, I know Linaro was looking into doing it as
> > part of the test suites that they verify before I do a release.  But I
> > doubt it's run on an XFS filesystem.
> > 
> > Sasha was doing some work in this area though, Sasha?
> 
> My biggest blocker at this point that it is extremely difficult to get a
> baseline for a kernel version.
> 
> Even after adding all the "known" failures to the expunge list, I ket
> hitting issues that reproduced once every 100 runs, and once those are
> expunged I started hitting even rarer stuff.
> 
> While there's no actual real difficulty in building these expunge lists,
> it ended up being somewhat of a loop where I couldn't establish a solid
> baseline since random things kept breaking.

Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
should be using 4.9.y in a "server system" anymore, unless you happen to
have an enterprise kernel based on it.  So we should be fine as the
users of the older kernels don't run xfs.

thanks,

greg k-h
