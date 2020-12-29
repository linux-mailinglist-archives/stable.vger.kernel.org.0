Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986F92E6CC8
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgL2A3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgL2A3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 19:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24045207CF;
        Tue, 29 Dec 2020 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609201731;
        bh=tnJABDWPQWntANFkFwHDUvUeZt2eF6rX+Zy1QI8S7jE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WfSgS7M+hdPh2BFgpd3MrVE9Jf2hFLJIybT4vQ5DJV5ui/v1ySyYydKZW2TUhFi4f
         Yh/htHKRH6M69HgIPENIuU/LgTNJQ39Pq/0OFYHUGMjmZHbt7DkpbNdmWpwrV4eRm7
         WEEQq2FpF+lwRQO3KA2qe0dbuYh9KPZxBPH4E7b6Ki/mmRzkHj2cxtEctZ7YgUj6KI
         o5AWutBzE3kYrwblnMiSaMX50CdC7AN9exkd037DRRALu95TGzhWcjBSaOaYz62NGk
         l6tsfvEEgaXCi52aI7QhqUCMM9HuYvBROMz69D/bIhDCJqDZ9EpVMGqYsjbSD0wfYI
         rbupaiuyrCz5g==
Date:   Mon, 28 Dec 2020 16:28:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?QmrDtnJu?= =?UTF-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@intel.com>
Subject: Re: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the
 next_to_use descriptor
Message-ID: <20201228162850.4c648479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228234336.GK2790422@sasha-vm>
References: <20201228125020.963311703@linuxfoundation.org>
        <20201228125043.105740628@linuxfoundation.org>
        <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201228222907.GG2790422@sasha-vm>
        <20201228145105.4eb4a14f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201228234336.GK2790422@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 18:43:36 -0500 Sasha Levin wrote:
> On Mon, Dec 28, 2020 at 02:51:05PM -0800, Jakub Kicinski wrote:
> >On Mon, 28 Dec 2020 17:29:07 -0500 Sasha Levin wrote: =20
> >> On Mon, Dec 28, 2020 at 10:54:23AM -0800, Jakub Kicinski wrote: =20
> >> >On Mon, 28 Dec 2020 13:47:40 +0100 Greg Kroah-Hartman wrote: =20
> >> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> >>
> >> >> [ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]
> >> >>
> >> >> On the Rx side, the next_to_use index points to the next item in the
> >> >> HW ring to be refilled/allocated, and next_to_clean points to the n=
ext
> >> >> item to potentially be processed.
> >> >>
> >> >> When the HW Rx ring is fully refilled, i.e. no packets has been
> >> >> processed, the next_to_use will be next_to_clean - 1. When the ring=
 is
> >> >> fully processed next_to_clean will be equal to next_to_use. The lat=
ter
> >> >> case is where a bug is triggered.
> >> >>
> >> >> If the next_to_use bits are not cleared, and the "fully processed"
> >> >> state is entered, a stale descriptor can be processed.
> >> >>
> >> >> The skb-path correctly clear the status bit for the next_to_use
> >> >> descriptor, but the AF_XDP zero-copy path did not do that.
> >> >>
> >> >> This change adds the status bits clearing of the next_to_use
> >> >> descriptor.
> >> >>
> >> >> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> >> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> >> Signed-off-by: Sasha Levin <sashal@kernel.org> =20
> >> >
> >> >Oh wow, so much for Sasha waiting longer for code to get tested before
> >> >auto-pulling things into stable :/ =20
> >>
> >> The timeline is usually for a commit to appear in a release, and it di=
d.
> >> Was it too early? =20
> >
> >Hm, I'm not sure of exact semantics but I meant a final release,
> >not an -rc.
> >
> >Plus I thought the point of things being part of a release is that
> >people actually get a chance to test that release. -rc1 was cut 24
> >hours ago. I guess a "release" is used as a yardstick here, to
> >measure time, not for practical reasons? =20
>=20
> Note that it wasn't actually released yet, at this point folks are
> supposed to be testing 5.10.4-rc1 to make sure that those patches are
> okay.
>=20
> I still think that there are no significant users of Linus's tree, so
> the idea of having a patch "in a release" doesn't mean as much as folks
> think it does. Sure, we have a lot of folks who test -rc releases, but
> are you aware of anyone who runs -rc on real world workloads to test it?

Ack, I'm not disagreeing. From my limited information/experience testing
seems to happen mostly in the -next trees (be it linux-next or more
likely net-next for networking) and in production releases (either final
produced by Linus or when patch hits some stable tree).

I'd actually be on board of removing this "must be in Linus's tag"
requirement. I don't see why anyone would test rcX instead of just
pulling latest linux/master.

> >> >I have this change and other changes here queued, but haven't sent the
> >> >submission yet. =20
> >>
> >> What do you mean with "queued"? Its in Linus's tree for about two weeks
> >> now. =20
> >
> >Networking maintainers have their own queue for patches that will go to
> >stable:
> >
> >https://patchwork.kernel.org/bundle/netdev/stable/?state=3D* =20
>=20
> This part has always been tricky to me: some parts of net/ and
> drivers/net/ don't go through netdev, and some do. I have a filter to
> ignore net/ completely, but I found that quite a lot of drivers/net/
> wasn't covered by this process.
>=20
> How could I blacklist/ignore the parts of the tree you're looking at?
>=20
> Also, is drivers/net/ stuff covered as well as net/? I found in the past
> that it's not the case when I was looking at missing patches for the
> hyper-v driver.

Yeah, it's tricky, I've produced some criteria for build testing things
which hit the mailing list:

https://github.com/kuba-moo/nipa/blob/master/netdev/tree_match.py#L47

But it's far from 100% accurate. I think your best shot would be to
filter by committer? :S The special rules only apply to patches which
went directly into net or net-next so committed by DaveM (or myself).
