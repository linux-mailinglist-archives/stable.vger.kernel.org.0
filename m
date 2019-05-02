Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3214119F7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 15:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBNUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 09:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfEBNUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 09:20:34 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5CD2063F;
        Thu,  2 May 2019 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556803233;
        bh=lnBk0334Jw7S1ntJD6loqfr3/5TE3zzisr0gGgvbCf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1DW+SZKdsZBuwirEld6Cstp5DbaXwO1uukz+H8oVkn+s9KAxk7RqCqzZP5B9+6mp
         wgSqx7is2SyZHeRF40/7vsqOM/H304D3kTZlhogDIJSgFILpEcmuavg4YIg22Lo8WR
         Ijh7C75sXrjlIJNL1qgDWrQka4ilN9e6jyWrSbzg=
Date:   Thu, 2 May 2019 09:20:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andre Noll <maan@tuebingen.mpg.de>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502132027.GF11584@sasha-vm>
References: <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190502114440.GB21563@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 01:44:40PM +0200, Greg Kroah-Hartman wrote:
>On Thu, May 02, 2019 at 08:11:07AM +1000, Dave Chinner wrote:
>> On Wed, May 01, 2019 at 12:28:22PM -0700, Darrick J. Wong wrote:
>> > On Wed, May 01, 2019 at 07:51:29PM +0200, Andre Noll wrote:
>> > > On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
>> > > > On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
>> > > > > On Wed, May 01, 08:36, Darrick J. Wong wrote
>> > > > > > > > You could send this patch to the stable list, but my guess is that
>> > > > > > > > they'd prefer a straight backport of all three commits...
>> > > > > > >
>> > > > > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
>> > > > > > > four conflicting files. The conflicts are trivial to resolve (git
>> > > > > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
>> > > > > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
>> > > > > > > (xfs: create a function to query all records in a btree) is needed as
>> > > > > > > well. But then, applying 86210fbebae (xfs: move various type verifiers
>> > > > > > > to common file) on top of that gives non-trivial conflicts.
>> > > > > >
>> > > > > > Ah, I suspected that might happen.  Backports are hard. :(
>> > > > > >
>> > > > > > I suppose one saving grace of the patch you sent is that it'll likely
>> > > > > > break the build if anyone ever /does/ attempt a backport of those first
>> > > > > > two commits.  Perhaps that is the most practical way forward.
>> > > > > >
>> > > > > > > So, for automatic backporting we would need to cherry-pick even more,
>> > > > > > > and each backported commit should be tested of course. Given this, do
>> > > > > > > you still think Greg prefers a rather large set of straight backports
>> > > > > > > over the simple commit that just pulls in the missing function?
>> > > > > >
>> > > > > > I think you'd have to ask him that, if you decide not to send
>> > > > > > yesterday's patch.
>> > > > >
>> > > > > Let's try. I've added a sentence to the commit message which explains
>> > > > > why a straight backport is not practical, and how to proceed if anyone
>> > > > > wants to backport the earlier commits.
>> > > > >
>> > > > > Greg: Under the given circumstances, would you be willing to accept
>> > > > > the patch below for 4.9?
>> > > >
>> > > > If the xfs maintainers say this is ok, it is fine with me.
>> > >
>> > > Darrick said, he's in favor of the patch, so I guess I can add his
>> > > Acked-by. Would you also like to see the ack from Dave (the author
>> > > of the original commit)?
>> >
>> > FWIW it seems fine to me, though Dave [cc'd] might have stronger opinions...
>>
>> Only thing I care about is whether it is QA'd properly. Greg, Sasha,
>> is the 4.9 stable kernel having fstests run on it as part of the
>> release gating?
>
>I do not know about fstests, I know Linaro was looking into doing it as
>part of the test suites that they verify before I do a release.  But I
>doubt it's run on an XFS filesystem.
>
>Sasha was doing some work in this area though, Sasha?

My biggest blocker at this point that it is extremely difficult to get a
baseline for a kernel version.

Even after adding all the "known" failures to the expunge list, I ket
hitting issues that reproduced once every 100 runs, and once those are
expunged I started hitting even rarer stuff.

While there's no actual real difficulty in building these expunge lists,
it ended up being somewhat of a loop where I couldn't establish a solid
baseline since random things kept breaking.

--
Thanks,
Sasha
