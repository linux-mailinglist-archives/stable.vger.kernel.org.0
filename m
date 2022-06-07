Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8053F544
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiFGErx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbiFGErk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:47:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCF4FC50;
        Mon,  6 Jun 2022 21:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97BDEB81CA9;
        Tue,  7 Jun 2022 04:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8543DC385A5;
        Tue,  7 Jun 2022 04:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654577249;
        bh=76beSbAffKgR1ju5ajqnTe0btnAx0H79wqEaXuHKV84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vdznkf0hzD5GoIe2jdZ7YMCofYd3kNDph5qA3gb884gpKNyzvplB8+kpRTAVkA4Tp
         AKynY7LKnpscONFXPmS+y03uIbJduuGre07QmYHITwSXReGSuED5lq2tTa1eAlScnL
         r2dC2vROka4IQM9HQ/fgyd0xDi9I9i1cTPMjzdEo=
Date:   Tue, 7 Jun 2022 06:47:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
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
Message-ID: <Yp7YXqn4BIZrebq7@kroah.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
 <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area>
 <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
 <20220607030147.GU227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607030147.GU227878@dread.disaster.area>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 01:01:47PM +1000, Dave Chinner wrote:
> On Tue, Jun 07, 2022 at 01:33:06AM +0300, Amir Goldstein wrote:
> > On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> > > >
> > > > xfs/538 on a 1kB block filesystem failed with this assert:
> > > >
> > > > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> > >
> > > You haven't mentioned that you combined a second upstream
> > > commit into this patch to fix the bug in this commit.....
> > >
> > 
> > I am confused.
> > 
> > patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
> > is the patch that I backported from 5.12 and posted for review.
> > This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
> > that I should take to fix the bug in patch [5.10 7/8].
> 
> Sorry, I missed that this was a new patch because the set looked
> the same as the last posting and you said in the summary letter:
> 
> "These fixes have been posted to review on xfs list [1]."
> 
> Except this patch *wasn't part of that set*. I mistook it for the
> patch that introduced the assert because I assumed from the above
> statement, the absence of a changelog in cover letter and that you'd
> sent it to Greg meant for inclusion meant *no new patches had been
> added*.
> 
> Add to that the fact I rushed through them because I saw that Greg
> has already queued these before anyone had any time to actually
> review the posting. Hence the timing of the release of unreviewed
> patches has been taken completely out of our control, and so I
> rushed through them and misinterpreted what I was seeing.
> 
> That's not how the review process is supposed to work. You need to
> wait for people to review the changes and ACK them before then
> asking for them to be merged into the stable trees. You need to have
> changelogs in your summary letters. You need to do all the things
> that you've been complaining bitterly about over the past month that
> upstream developers weren't doing 18 months ago.

I thought these had already been reviewed, which is why I took them.

And there still are days before these go anywhere, just adding them to
the stable queue doesn't mean they are "set in stone".

Heck, even if they do get merged into a stable release, 'git revert' is
our friend here, and we can easily revert anything that is found to be
wrong.

> And I notice that you've already sent out yet another set of stable
> patches for review despite the paint not even being dry on these
> ones. Not to mention that there's a another set of different 5.15
> stable patches out for review as well.
> 
> This is not a sustainable process.
> 
> Seriously: slow down and stop being so damn aggressive. Let everyone
> catch up and build sustainable processes and timetables. If you keep
> going like this, you are going break people.

What am I supposed to do here, not take patches you all send me?  Wait
X number of days?

totally confused,

greg k-h
