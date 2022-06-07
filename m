Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0CF53F442
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 05:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiFGDB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 23:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiFGDBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 23:01:55 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02BBCCC148;
        Mon,  6 Jun 2022 20:01:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 467115EC54D;
        Tue,  7 Jun 2022 13:01:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyPTX-003bu1-IB; Tue, 07 Jun 2022 13:01:47 +1000
Date:   Tue, 7 Jun 2022 13:01:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
Message-ID: <20220607030147.GU227878@dread.disaster.area>
References: <20220606143255.685988-1-amir73il@gmail.com>
 <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area>
 <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629ebfa0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=m8TDx-50O8R2JX1nkC4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 01:33:06AM +0300, Amir Goldstein wrote:
> On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> > >
> > > xfs/538 on a 1kB block filesystem failed with this assert:
> > >
> > > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> >
> > You haven't mentioned that you combined a second upstream
> > commit into this patch to fix the bug in this commit.....
> >
> 
> I am confused.
> 
> patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
> is the patch that I backported from 5.12 and posted for review.
> This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
> that I should take to fix the bug in patch [5.10 7/8].

Sorry, I missed that this was a new patch because the set looked
the same as the last posting and you said in the summary letter:

"These fixes have been posted to review on xfs list [1]."

Except this patch *wasn't part of that set*. I mistook it for the
patch that introduced the assert because I assumed from the above
statement, the absence of a changelog in cover letter and that you'd
sent it to Greg meant for inclusion meant *no new patches had been
added*.

Add to that the fact I rushed through them because I saw that Greg
has already queued these before anyone had any time to actually
review the posting. Hence the timing of the release of unreviewed
patches has been taken completely out of our control, and so I
rushed through them and misinterpreted what I was seeing.

That's not how the review process is supposed to work. You need to
wait for people to review the changes and ACK them before then
asking for them to be merged into the stable trees. You need to have
changelogs in your summary letters. You need to do all the things
that you've been complaining bitterly about over the past month that
upstream developers weren't doing 18 months ago.

And I notice that you've already sent out yet another set of stable
patches for review despite the paint not even being dry on these
ones. Not to mention that there's a another set of different 5.15
stable patches out for review as well.

This is not a sustainable process.

Seriously: slow down and stop being so damn aggressive. Let everyone
catch up and build sustainable processes and timetables. If you keep
going like this, you are going break people.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
