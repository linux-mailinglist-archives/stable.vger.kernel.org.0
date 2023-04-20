Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CC76E94C8
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 14:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjDTMmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 08:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjDTMmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 08:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3092893
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 05:42:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A3B64940
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 12:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7ADC433EF;
        Thu, 20 Apr 2023 12:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681994552;
        bh=J08Sn7rYTVyGUhrfk6mEoex3lK0bQFm0tFA0bQAHwTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lfpIDrHDJZBE2DCtkIPlLBUXRxiJv4FNUWgymd+cHHjhkMmYyIQ6SpFCd9GmNEN8R
         1G6QGtCS1yS2fyCX6Uooe91MQ9c/bViQ3KbmfmtSv4ZFooJBqyZS5HCaTSKNXqFLWw
         3S38BEi2AvRFS5hzh2Auz22DiKvOScuRLzJ0acU0=
Date:   Thu, 20 Apr 2023 14:42:29 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Message-ID: <ZEEzNSEq-15PxS8r@kroah.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
 <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 09:36:28AM -0300, Guilherme G. Piccoli wrote:
> On 19/04/2023 17:04, Deucher, Alexander wrote:
> > [...]
> >> So, let me check if I understood properly: there are 2 trees (-fixes a=
nd -next),
> >> and the problem is that their merge onto mainline happens apart and th=
ere
> >> are kind of duplicate commits, that were first merged on -fixes, then =
"re-
> >> merged" on -next, right?
> >>
> >=20
> > Each subsystem works on new features, then when the merge window opens,=
 Linus pulls them into mainline.  At that point, mainline goes into RCs and=
 then mainline is bug fixes only.  Meanwhile in parallel, each subsystem is=
 working on new feature development for the next merge window (subsystem -n=
ext trees).  The trees tend to lag behind mainline a bit.  Most developers =
focus on them in support of upcoming features.  They are usually also where=
 bugs are fixed.  If a bug is fixed in the -next tree, what's the best way =
to get it into mainline?  I guess ideally it would be fixed in mainline and=
 them mainline would be merged into everyone's -next branch, but that's not=
 always practical.  Often times new features depend on bug fixes and then y=
ou'd end up stalling new development waiting for a back merge, or you'd hav=
e to rebase your -next branches regularly so that they would shed any patch=
es in mainline which is not great either.  We try and cherry-pick -x when w=
e can to show the relationship.
> >=20
> >> Would be possible to clean the -next tree right before the merge, using
> >> some script to find commits there that are going to be merged but are
> >> already present? Then you'd have a -next-to-merge tree that is clean a=
nd
> >> doesn't present dups, avoiding this.
> >=20
> > There's no real way to clean it without rewriting history.  You'd basic=
ally need to do regular backmerges and rebases of the -next trees.  Also th=
en what do you do if you already have a feature in -next (say Dave or Danie=
l have already pulled in my latest amdgpu PR for -next) and you realize tha=
t one of those patches is an important bug fix for mainline?  If the drm -n=
ext tree rebased then all of the other drm driver trees that feed into it w=
ould need to rebase as well otherwise they'd have stale history.
> >=20
> > You also have the case of a fix in -next needing to land in mainline, b=
ut due to differences in the trees, it needs backporting to apply properly.
> >=20
> >>
> >> Disclaimer: I'm not a maintainer, maybe there are smart ways of doing =
that or
> >> perhaps my suggestion is silly and unfeasible heh But seems likely tha=
t other
> >> maintainers face this problem as well and came up with some solution -
> >> avoiding the dups would be a good thing, IMO, if possible.
> >=20
> >=20
> > No worries.  I agree.  I haven't seen anything so far that really addre=
sses handles this effectively.
> >=20
> > Alex
>=20
> Thanks a bunch Alex, I appreciate your time detailing the issue, which
> seems...quite complex and annoying, indeed =3D{

And it drives me crazy, I hate seeing drm patches show up in my stable
queue and I put them at the end of the list for this very reason.  I've
complained about it for years, but oh well...

> @Greg, can you pick this one? Thanks!

Which "one" are you referring to here?

confused,

greg k-h
