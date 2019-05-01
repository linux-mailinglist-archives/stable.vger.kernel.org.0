Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A7710F0E
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfEAWiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 18:38:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60114 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfEAWiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 18:38:50 -0400
X-Greylist: delayed 1659 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2019 18:38:48 EDT
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8A5FC439C33;
        Thu,  2 May 2019 08:11:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hLxRT-0004tM-3S; Thu, 02 May 2019 08:11:07 +1000
Date:   Thu, 2 May 2019 08:11:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Andre Noll <maan@tuebingen.mpg.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501221107.GI29573@dread.disaster.area>
References: <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501192822.GM5207@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=UJetJGXy c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=BAPyJwD9Ct5AMgICnHAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 01, 2019 at 12:28:22PM -0700, Darrick J. Wong wrote:
> On Wed, May 01, 2019 at 07:51:29PM +0200, Andre Noll wrote:
> > On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
> > > On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
> > > > On Wed, May 01, 08:36, Darrick J. Wong wrote
> > > > > > > You could send this patch to the stable list, but my guess is that
> > > > > > > they'd prefer a straight backport of all three commits...
> > > > > > 
> > > > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
> > > > > > four conflicting files. The conflicts are trivial to resolve (git
> > > > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> > > > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> > > > > > (xfs: create a function to query all records in a btree) is needed as
> > > > > > well. But then, applying 86210fbebae (xfs: move various type verifiers
> > > > > > to common file) on top of that gives non-trivial conflicts.
> > > > > 
> > > > > Ah, I suspected that might happen.  Backports are hard. :(
> > > > > 
> > > > > I suppose one saving grace of the patch you sent is that it'll likely
> > > > > break the build if anyone ever /does/ attempt a backport of those first
> > > > > two commits.  Perhaps that is the most practical way forward.
> > > > > 
> > > > > > So, for automatic backporting we would need to cherry-pick even more,
> > > > > > and each backported commit should be tested of course. Given this, do
> > > > > > you still think Greg prefers a rather large set of straight backports
> > > > > > over the simple commit that just pulls in the missing function?
> > > > > 
> > > > > I think you'd have to ask him that, if you decide not to send
> > > > > yesterday's patch.
> > > > 
> > > > Let's try. I've added a sentence to the commit message which explains
> > > > why a straight backport is not practical, and how to proceed if anyone
> > > > wants to backport the earlier commits.
> > > > 
> > > > Greg: Under the given circumstances, would you be willing to accept
> > > > the patch below for 4.9?
> > > 
> > > If the xfs maintainers say this is ok, it is fine with me.
> > 
> > Darrick said, he's in favor of the patch, so I guess I can add his
> > Acked-by. Would you also like to see the ack from Dave (the author
> > of the original commit)?
> 
> FWIW it seems fine to me, though Dave [cc'd] might have stronger opinions...

Only thing I care about is whether it is QA'd properly. Greg, Sasha,
is the 4.9 stable kernel having fstests run on it as part of the
release gating?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
