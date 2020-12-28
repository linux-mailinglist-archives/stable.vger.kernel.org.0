Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4922E6BAF
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgL1Wzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbgL1Wvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 17:51:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B030F2226A;
        Mon, 28 Dec 2020 22:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609195866;
        bh=iMRjbjaR2yMEmtGT58pNNt08sR3YmHcbZswHYOf0MX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fkRh+y6Qocu59DgvSmFG5miNVDQoQY6VVufiGGR3UZiR6Pi9Cf9EYSQAwdsuiUjVh
         r4Q1Zh4Da7xYZfML7OOD5vMUIrR4bNCDPypnIzVnL2TwIb1n+2Xv2AS8AJqjsz6SoN
         ZPM0T2laWypOhvX4buyvzLCaXgv5e6GtssG9ixOX3oaonXLFacwPJXYji4+AE6uPqd
         9rTxa2u+UKSadIOxYdmWaxFj9GGp2afF3pCb8LN/5kt6s4rLdEh3n/cFx0i13fe+Z2
         o/EoYlSwH1ybiOQIdiJNUmoColoRI9tQqLv8r6x+qv72lUnkWAra+z9MiSZ8hOHsxz
         F67YbwnfvM5GA==
Date:   Mon, 28 Dec 2020 14:51:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?QmrDtnJu?= =?UTF-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@intel.com>
Subject: Re: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the
 next_to_use descriptor
Message-ID: <20201228145105.4eb4a14f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228222907.GG2790422@sasha-vm>
References: <20201228125020.963311703@linuxfoundation.org>
        <20201228125043.105740628@linuxfoundation.org>
        <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201228222907.GG2790422@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 17:29:07 -0500 Sasha Levin wrote:
> On Mon, Dec 28, 2020 at 10:54:23AM -0800, Jakub Kicinski wrote:
> >On Mon, 28 Dec 2020 13:47:40 +0100 Greg Kroah-Hartman wrote: =20
> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>
> >> [ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]
> >>
> >> On the Rx side, the next_to_use index points to the next item in the
> >> HW ring to be refilled/allocated, and next_to_clean points to the next
> >> item to potentially be processed.
> >>
> >> When the HW Rx ring is fully refilled, i.e. no packets has been
> >> processed, the next_to_use will be next_to_clean - 1. When the ring is
> >> fully processed next_to_clean will be equal to next_to_use. The latter
> >> case is where a bug is triggered.
> >>
> >> If the next_to_use bits are not cleared, and the "fully processed"
> >> state is entered, a stale descriptor can be processed.
> >>
> >> The skb-path correctly clear the status bit for the next_to_use
> >> descriptor, but the AF_XDP zero-copy path did not do that.
> >>
> >> This change adds the status bits clearing of the next_to_use
> >> descriptor.
> >>
> >> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> >> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org> =20
> >
> >Oh wow, so much for Sasha waiting longer for code to get tested before
> >auto-pulling things into stable :/ =20
>=20
> The timeline is usually for a commit to appear in a release, and it did.
> Was it too early?

Hm, I'm not sure of exact semantics but I meant a final release,=20
not an -rc.=20

Plus I thought the point of things being part of a release is that
people actually get a chance to test that release. -rc1 was cut 24
hours ago. I guess a "release" is used as a yardstick here, to=20
measure time, not for practical reasons?

> >I have this change and other changes here queued, but haven't sent the
> >submission yet. =20
>=20
> What do you mean with "queued"? Its in Linus's tree for about two weeks
> now.

Networking maintainers have their own queue for patches that will go to
stable:

https://patchwork.kernel.org/bundle/netdev/stable/?state=3D*

> >How long is the auto-backporting delay in terms of calendar days? =20
>=20
> The autosel stuff is about 2-3(-4) weeks at this point, stuff with a
> fixes tag gets picked up in about 2 weeks.

$ git show 8d14768a7972b92c73259f0c9c45b969d85e3a60 --format=3D'%cD' --no-p=
atch
Wed, 16 Dec 2020 10:51:07 -0800
$ git show 8d14768a7972b92c73259f0c9c45b969d85e3a60 --format=3D'%aD' --no-p=
atch
Fri, 11 Dec 2020 15:57:11 +0100

Two weeks from author date. That's a little short because.. I also
delay things by up to two weeks :) so you'll grab patches which are
sitting in networking stable queue.

And all networking fixes should have a Fixes tag, so that's no
discriminator to be honest.
