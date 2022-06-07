Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB0C541BFB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382257AbiFGVzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383978AbiFGVx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE51498CC;
        Tue,  7 Jun 2022 12:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y43DC+2YfSdMJE+0wfWBBaNfHVhOwNjTbW5CSeqHnSQ=; b=K9O7whU4/R+zGDFYBk45Xz+N3g
        CwtIs0BZo7IQx/VQDtriYNujQf8s9UhzyvyrTVeigBasiScz6mmn7YPu/2sGn7BjgMKQ9ABVy70Wx
        JWzDYTWG1H3arMSiHpVh3JVjBfaHDgLnN1RXzsFLWLoCIlUsq+E8XiRGVEaFtd1iT85xLDSI7RJLf
        CxMNHs+OSEyJBah8PGcJ/Sykmmmb39N+u7MKRvreRiRipDhIPTUCIgIYkQW2mfMURgkr050dVXdYM
        1/nNBEXQ/SzrMxXDRbdbuSfPORXEQ+mLIPX/LGXVVFVn62XmF2eTi/2m8OAeBj8vappFZ14Dk6EAg
        z1yV4Qmw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyecc-008yhF-2R; Tue, 07 Jun 2022 19:12:10 +0000
Date:   Tue, 7 Jun 2022 12:12:10 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
Message-ID: <Yp+jCv13n1II1b3V@bombadil.infradead.org>
References: <20220606143255.685988-1-amir73il@gmail.com>
 <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area>
 <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
 <20220607030147.GU227878@dread.disaster.area>
 <CAOQ4uxgP_knOriJPyU6PS_TYhsMRfAJon2nsJ2FO34SUbY6Ygw@mail.gmail.com>
 <Yp+ahuC1tWy1BOQm@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp+ahuC1tWy1BOQm@magnolia>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 11:35:50AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 07, 2022 at 09:09:47AM +0300, Amir Goldstein wrote:
> > Regarding explicit ACKs, I wasn't sure what to do.
> 
> Me neither.  It feels a little funny to ACK a patch in a stable queue
> that I already RVB'd for upstream, but is that peoples' expectation?

I think that's up to us, in particular because we don't want bots to do this
work for XFS, and so we must define what we feel comfortable with.

How about this: having at least one XFS maintainer Ack each of the
patches for the intent of getting into stable? If no Acks come back
by *2 weeks* the stable branch maintainers can use their discretion
to send upstream to the stable team.

> > I incorporated your feedback and wrote my plans in this email [3]
> 
> I'm going to offer my (probably controversial) opinion here: I would
> like to delegate /all/ of the power and responsibility for stable
> maintenance to all of you (Amir/Leah/Chandan/etc.) who are doing the
> work.  What Amir did here (send a candidate patchset, take suggestions
> for a week, run the batch through fstests) is more or less what I'd
> expect from whoever owns the LTS backport process.

I'm happy to provide advice as a paranoid developer who has seen
the incredibly odd things come up before and had to deal with them.
People can either ignore it or take it.

> I've been pondering this overnight, and I don't agree that the above
> scenario is the inevitable outcome.  Are you (LTS branch maintainers)
> willing to put your names in the MAINTAINERS file for the LTS kernels
> and let us (upstream maintainers) point downstream consumers (and their
> bug report) of those branches at you?  If so, then I see that as
> effective delegation of responsibilities to people who have taken
> ownership of the LTS branches, not merely blame shifting.

*This* is why when I volunteered to do xfs stable work a long time ago my
own bar for regression testing was and still remains *very high*. You really
need to put the fear in $deity in terms of responsibility because
without that, it is not fair to upstream developers for what loose
cannons there are for stable candidate patches for a filesystem. As
anyone doing "enterprise" could attest to, *that* work alone requires a
lot of time, and so one can't realistically multitask to both.

It is also why this work stopped eventually, because I lost my test rig after
one $EMPLOYER change and my focus was more on the "enterprise" side at SUSE.
It is why after yet another $EMPLOYER change this remains a long
priority, and I try to do what I can to help with this.

If we care about stable we need to seriously consider a scalable
solution which *includes* testing. And, I also think even the "bot"
enabled stable fixed filesystem could benefit from these best practices
as well.

> If yes, then ... do as you like, you're the branch owner.  I expect
> things to be rocky for a while, but it beats burning myself out with too
> many responsibilities that I have not been able to keep up with.  It's
> probably better for the long term stability of each LTS branch if
> there's one or two people who are really familiar with how that LTS has
> been doing, instead of me trying and failing to multiplex.
> 
> Also, as Greg points out, at worst, you /can/ decide to revert something
> that initially looked good but later turned out smelly.

If testing is paranoid the chances of these reverts are reduced.
The reason for paranoia is reasonably higher for filesystems since
we don't want to break a user's filesystem. It is up to each stable
branch maintainer to decide their level of paranoia, as they incur
the responsibility for the branch.

  Luis
