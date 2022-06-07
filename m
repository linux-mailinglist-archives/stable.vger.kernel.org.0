Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74860541597
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376422AbiFGUf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377751AbiFGUeD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9321D1E716D;
        Tue,  7 Jun 2022 11:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 247FDB8237D;
        Tue,  7 Jun 2022 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C97C34115;
        Tue,  7 Jun 2022 18:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654626950;
        bh=Bim1OVAnFA6EnLNutNwHm5Oyq0m/QSz9QB+4ZUGYea4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxZhXqrEBRnVMBU9vU93xrTy7Q3aKKjdis4NPrmF1Iwx8eV42FPak7+lko8K9FamS
         fO8G68CJXlF3fwo4K/RyK3FcGiSQhiEtItk5ECD0QKTSlN9Hfpcqj3M1upDopMMf6h
         uwoWk/GXWN439zWNRDjbZIICUqwBLmoshUFb2CGowwfzUy7OUmSkDcs/LXzGR2QCBV
         AL9NgE3cq60sAyUQ0yPDtfUgXv1nuFeTax9NvR4qaE/T4bgjRJaSKR9yywhxQXaxhi
         hc3HAepLikyx2IDYEDqDqUmp+MoToXoXFF0X76feN4fJxgBLrsB+I2lbDFqMLKl7IV
         ZUxgwqmxoYcyg==
Date:   Tue, 7 Jun 2022 11:35:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
Message-ID: <Yp+ahuC1tWy1BOQm@magnolia>
References: <20220606143255.685988-1-amir73il@gmail.com>
 <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area>
 <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
 <20220607030147.GU227878@dread.disaster.area>
 <CAOQ4uxgP_knOriJPyU6PS_TYhsMRfAJon2nsJ2FO34SUbY6Ygw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgP_knOriJPyU6PS_TYhsMRfAJon2nsJ2FO34SUbY6Ygw@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 09:09:47AM +0300, Amir Goldstein wrote:
> On Tue, Jun 7, 2022 at 6:01 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Jun 07, 2022 at 01:33:06AM +0300, Amir Goldstein wrote:
> > > On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > >
> > > > > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> > > > >
> > > > > xfs/538 on a 1kB block filesystem failed with this assert:
> > > > >
> > > > > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> > > >
> > > > You haven't mentioned that you combined a second upstream
> > > > commit into this patch to fix the bug in this commit.....
> > > >
> > >
> > > I am confused.
> > >
> > > patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
> > > is the patch that I backported from 5.12 and posted for review.
> > > This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
> > > that I should take to fix the bug in patch [5.10 7/8].
> >
> > Sorry, I missed that this was a new patch because the set looked
> > the same as the last posting and you said in the summary letter:
> >
> > "These fixes have been posted to review on xfs list [1]."
> 
> Sorry, I forgot to edit this part of the template.
> 
> >
> > Except this patch *wasn't part of that set*. I mistook it for the
> > patch that introduced the assert because I assumed from the above
> > statement, the absence of a changelog in cover letter and that you'd
> > sent it to Greg meant for inclusion meant *no new patches had been
> > added*.
> >
> > Add to that the fact I rushed through them because I saw that Greg
> > has already queued these before anyone had any time to actually
> > review the posting. Hence the timing of the release of unreviewed
> > patches has been taken completely out of our control, and so I
> > rushed through them and misinterpreted what I was seeing.
> >
> > That's not how the review process is supposed to work. You need to
> > wait for people to review the changes and ACK them before then
> > asking for them to be merged into the stable trees. You need to have
> > changelogs in your summary letters. You need to do all the things
> > that you've been complaining bitterly about over the past month that
> > upstream developers weren't doing 18 months ago.
> 
> Of course I need to do all things.
> If I am not doing them it could be because I made a mistake
> or misunderstood something.
> I am always trying to improve and incorporate feedback on my mistakes.

One thing I've noticed watching the candidate series going by on the
list -- is there something consistent that could go in the subject line of a
candidate series from the first posting all the way until the stable
maintainers queue them up?

"[PATCH 5.10 v2 0/8] xfs fixes for 5.10.y (part 2)"

isn't quite specific enough to make it easy to find the threads in
mutt, at least not if they're all called "xfs fixes for 5.10.y".  I'm
not sure what to suggest here though -- pick two random dictionary
words?

"xfs: fixes for 5.10.y (trews sphenic)"

But that just looks like your $pet walked over the keyboard.  Maybe
something boring like the date the candidate series was first posted?

> Regarding changelogs, I do not understand what you mean.
> Isn't that a changelog at the bottom of my cover letter?
> Do you mean something else?

I /think/ Dave wanted to see something at the bottom of the cover letter
like this.  Actually, I won't speak for Dave, but this is what I'd like
to see if you make substantive changes between the CANDIDATE patchset
and the one that actually gets sent to -stable:

"I would like to thank Samsung for contributing the hardware for the
kdevops test environment and especially to Luis for his ongoing support
in the test environment, which does most of the work for me :)

"v3: Change frob to brof, per maintainer request.
v2: Add patch 7, which it turns out was a hidden prerequisite for patch 8.

"Thanks,
Amir."

> Regarding explicit ACKs, I wasn't sure what to do.

Me neither.  It feels a little funny to ACK a patch in a stable queue
that I already RVB'd for upstream, but is that peoples' expectation?

> Ted has asked this on this thread [1].
> 
> [1] https://lore.kernel.org/linux-fsdevel/YieG8rZkgnfwygyu@mit.edu/
> 
> I asked this in my reply [2] to Darrick's email, but got no reply:
> 
> :Should we post to xfs list and wait for explicit ACK/RVB on every patch?
> :Should we post to xfs list and if no objections are raised post to stable?
> 
> [2] https://lore.kernel.org/linux-xfs/CAOQ4uxjtOJ_=65MXVv0Ry0Z224dBxeLJ44FB_O-Nr9ke1epQ=Q@mail.gmail.com/

TBH there have been enough stable process discussion threads in the past
month that I've probably lost track of ... well, clearly, those two. :/

> Since I had no explicit rules, I used my common sense, which is a recipe
> for misunderstandings... :-/
> 
> I posted the candidates one week ago, so I thought everyone had the
> opportunity to comment.
> You gave me comments on patches 1 and 7 so I had assumed that
> you had seen the entire series and had no objections to the rest.
> 
> I incorporated your feedback and wrote my plans in this email [3]

I'm going to offer my (probably controversial) opinion here: I would
like to delegate /all/ of the power and responsibility for stable
maintenance to all of you (Amir/Leah/Chandan/etc.) who are doing the
work.  What Amir did here (send a candidate patchset, take suggestions
for a week, run the batch through fstests) is more or less what I'd
expect from whoever owns the LTS backport process.

Frankly, I don't see so much difference between what I do between -rc1
and -rc4 and what Amir's doing -- propose a bunch of fixpatches, wait a
few days, and if there aren't any strenuous objections, send them on
their way.  IOWS, I own whatever's going to the upstream tree; Amir owns
whatever's going to 5.10; Leah and Chandan own whatever's going to 5.15;
and (I guess?) Chandan owns whatever's going to 5.4.

I think Dave's afraid that if something goes wrong with an LTS kernel
then the downstream consumers of those LTS kernels will show up on the
list with bug reports and asking for fixes, and that will just put more
pressure on the upstream maintainers since those consumers don't care
about who they're talking to, they just want a resolution.  But I'll let
him express his thoughts.

I've been pondering this overnight, and I don't agree that the above
scenario is the inevitable outcome.  Are you (LTS branch maintainers)
willing to put your names in the MAINTAINERS file for the LTS kernels
and let us (upstream maintainers) point downstream consumers (and their
bug report) of those branches at you?  If so, then I see that as
effective delegation of responsibilities to people who have taken
ownership of the LTS branches, not merely blame shifting.

If yes, then ... do as you like, you're the branch owner.  I expect
things to be rocky for a while, but it beats burning myself out with too
many responsibilities that I have not been able to keep up with.  It's
probably better for the long term stability of each LTS branch if
there's one or two people who are really familiar with how that LTS has
been doing, instead of me trying and failing to multiplex.

Also, as Greg points out, at worst, you /can/ decide to revert something
that initially looked good but later turned out smelly.

The one thing I /will/ caution you about -- watch out for changes that
affect what gets persisted to disk.  Those need more review because
fixing those things up after the fact (look at the AGFL padding
corrections we had to do to fix some uncaught problems upstream) is
/not/ fun.

> :Just to make sure we are all on the same page.
> :
> :I have applied both patches to my test tree:
> :1. 1cd738b13ae9 xfs: consider shutdown in bmapbt cursor delete assert
> :2. 56486f307100 xfs: assert in xfs_btree_del_cursor should take into
> :account error
> :
> :Patch #2 looks pretty safe and it only affects builds with XFS_WARN/DEBUG,
> :so I am not too concerned about a soaking period.
> :I plan to send it along with patch #1 to stable after a few more test runs.
> 
> Once again, I *assumed* that you saw that because this was part of
> an ongoing conversation, not some random email.
> 
> 4 days later (after more testing) I did what I said I would do
> and posted the revised series to stable with feedback incorporated.
> This was also detailed in the cover letter to stable.
> 
> [3] https://lore.kernel.org/linux-xfs/CAOQ4uxhxLRTUfyhSy9D6nsGdVANrUOgRM8msVPVmFmw0oaky+w@mail.gmail.com/
> 
> If this situation repeats itself in the future, I will post v2 to xfs
> list first.

Yes, please do.  It has been customary to push a final patchset for 24h
prior to submission just to see if anything shakes out at the last
minute.

> > And I notice that you've already sent out yet another set of stable
> > patches for review despite the paint not even being dry on these
> > ones. Not to mention that there's a another set of different 5.15
> > stable patches out for review as well.
> 
> I will pace myself going forward and collaborate closer with Leah.
> I have two years of kernel releases to catch up with, but once we
> reach the point of selecting patches from the present releases
> Hopefully, some of the reviews for candidates for different LTS
> kernels will be shared.

Admittedly, a new patchset every week is kind of a lot to pick through
with everything /else/ going on ... particularly this week, since I
/was/ busy trying to get the online fsck design doc review started, and
dealing with a CVE for the grub xfs driver, and also trying to get the
new LARP/NREXT64 itself sorted.  That said, a couple of years is a lot
of stuff to get through, so if we need to do a continuous trickle of
patches to get caught up then so be it.

As long as you all end up doing a better job with LTS maintenance than I
was doing, it's an improvement, even with the lumps and bumps. :)

> >
> > This is not a sustainable process.
> >
> > Seriously: slow down and stop being so damn aggressive. Let everyone
> > catch up and build sustainable processes and timetables. If you keep
> > going like this, you are going break people.
> 
> I do not want that.
> 
> Let me explain my process. As I described in the meta-cover letter [4] for
> the multi part series:
> 
> :My intention is to post the parts for review on the xfs list on
> :a ~weekly basis and forward them to stable only after xfs developers
> :have had the chance to review the selection.
> 
> [4] https://lore.kernel.org/linux-xfs/20220525111715.2769700-1-amir73il@gmail.com/
> 
> To you, it may appear that "paint not even being dry on these ones"
> but to me, I perceived part 2 was already out of review and part 3 was already
> spinning in xfstests for a week, so I wanted to post those patches
> and give as much time for review as needed.
> 
> My idea of sustainable was posting ~7 stable candidates per week.
> This pace may be a bit higher than normal fixes flow, but I do need
> to catch up with 2 years of fixes, so the rate has to be a bit higher
> than the normal rate of fixes that go into upstream.

Pipelining is a bit more troublesome -- it's difficult for me to
concentrate on two similarly named patchsets at the same time.  If you
have (say) part 3 running through its paces internally but only post
part 3 after Greg lands part 2, that sounds acceptable to me.

> I had to choose something based on no other feedback, but of course
> the idea is to take feedback and incorporate it into the process
> in order to make it sustainable.
> 
> I will do my best to amend the things that were broken in this posting.
> I am sure this is not the last time I am going to make mistakes.
> I am trying to fix a process that has been broken for years.
> I invest a lot of my time and energy in this effort.
> 
> My request is that you assume good intentions on my part and if there
> are rules that you want me to follow please spell them out, so I won't
> end up guessing wrong again.

I know, and thank you all for your willingness to take on LTS
maintainership.  There will undoubtedly be more, uh, learning
opportunities, but I'll try to roll with them as gently as I can.
Emotional self-regulation has not been one of my strong points the last
year or so.

--D

> 
> Thanks,
> Amir.
