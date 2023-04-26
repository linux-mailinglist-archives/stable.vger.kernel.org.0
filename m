Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E3B6EF4BD
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbjDZMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240843AbjDZMxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:53:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FE24481
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 05:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D02AA6164E
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 12:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D474C433EF;
        Wed, 26 Apr 2023 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682513583;
        bh=5lPpVE2sf2uN5ANc5UmvR4oPK8r9Whz2W8PwaWNWD+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y6mWPOn1Tk2HWeXW+GTI03XsYjuJZAtQHSUXoibU7Qy39od0pR32iyDojwZI84ift
         g1BqJ0hqP7z6o6wZQWebHZPLZPaSvGh7zQYJpcW27lM/b9xi7M0I6OU17Y0wy8A6LR
         Fc/8U2K27Fw6XgnglzV3NJKv4+2kXCaEe8+kkv/s=
Date:   Wed, 26 Apr 2023 14:53:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kristof Havasi <havasiefr@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
Message-ID: <2023042646-cherisher-ludicrous-a75d@gregkh>
References: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
 <ZEfoC9UDzniw6mo_@kroah.com>
 <CADBnMviZ4Q3LpUUfnGYrM6aiPQFLD6ohC1qjetJp0RcDGTTYsg@mail.gmail.com>
 <2023042519-powdery-passerby-213a@gregkh>
 <CADBnMviE3-DZhjO1iLgoAfBjFGFnyNTTHpLUobpAQdF5=Rt_3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADBnMviE3-DZhjO1iLgoAfBjFGFnyNTTHpLUobpAQdF5=Rt_3A@mail.gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 26, 2023 at 11:44:30AM +0200, Kristof Havasi wrote:
> On Tue, 25 Apr 2023 at 20:08, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Apr 25, 2023 at 06:27:24PM +0200, Kristof Havasi wrote:
> > > On Tue, 25 Apr 2023 at 16:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Apr 25, 2023 at 04:08:30PM +0200, Kristof Havasi wrote:
> > > > > Hi there,
> > > > >
> > > > > I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
> > > > > revolt around load tearing and reference an ancient Kernel commit:
> > > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > >
> > > > > I am not sure whether they are applicable to the v5.4.y branch as well.
> > > >
> > > > I do not know, what specific commits are you referring to?  CVEs mean
> > > > nothing, they are not valid identifiers, sorry.
> > > >
> > > > And have you tried applying them to the older kernels and testing to see
> > > > if they solve any specific issue?
> > > >
> > > > Or better yet, why use the older kernels, why not stick to the most
> > > > recent one?  What is preventing you from switching?
> > >
> > > Thank you for the quick response!
> > >
> > > I meant the following commits:
> > > f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 and
> > > 364f997b5cfe1db0d63a390fe7c801fa2b3115f6
> > >
> > > The v5.4 kernel is used in an embedded device where due to certification
> > > processes a quick upgrade of the Kernel isn't realistic until at least
> > > another year.
> >
> > You do realize that stable kernel updates can radically change the whole
> > system (look at the changes needed for retbleed), so any update needs to
> > always be properly tested.  Version numbers mean nothing, so even if we
> > do take these patches, you still need to do proper testing, the same
> > amount of testing you would have done for moving to a new kernel
> > version.
> 
> Yes, we are working on extending the tests, that is also how I found a
> regression
> candidate on the v5.4 LTS branch:
> https://lore.kernel.org/lkml/1473b364-777a-ede8-3ff6-36d9e1d577ad@leemhuis.info/
> 
> >
> > > The patches are quite small, I could cherry-pick them on the latest v5.4 tag,
> > > and the kernel builds... only for
> > > f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 USER_SOCKPTR
> > > isn't available in 5.4, so I sticked to `char __user *`.
> >
> > Note that you also need to provide backports for 5.15.y and 5.10.y as
> > you do not want to upgrade to a new version and have a regression,
> > right?
> 
> Thank you, I didn't know that. Sorry for that, I am still just getting familiar
> with the Kernel development process and tooling.

Also, try sending emails for the individual patches, AND cc: the
developers and subsystems involved to get their opinions.  To not do so
is wasteful as the developers know the change best, right?

> > > I will get a device tomorrow and try whether I can netcat between them
> > > via IPv4 and v6.
> > > Any other tests, which would be needed?
> >
> > Why does the existance of a random CVE number mean anything?  You do
> > know that MITRE (the entity that deals out CVEs), refuses to give the
> > kernel team new CVE numbers for bug reports, right?  So that means that
> > any kernel-related CVE that you see are created by vendors who are using
> > them to facilitate their internal engineering processes, not necessarily
> > anything else.
> >
> > I gave a whole long talk about this a few years ago if you are
> > interested:
> >         https://kernel-recipes.org/en/2019/talks/cves-are-dead-long-live-the-cve/
> >
> 
> OMG, thanks for the link, you summed up quite the frustration of mine from
> the past days, since I had to go through 500+ CVEs and classify them,
> whether they "affect" 5.4.238... The whole "versioning" and references
> are so lacking. But common criteria evaluations want to see all CVEs
> classified... (Don't want to start another rant on CC...)

Why are you all saying that CVEs are even a valid thing for the kernel
at all?  Please don't.

> But if we forget the whole CVE thing for a moment, if there is a commit,
> in the mainline which references a 2.6 kernel commit via "Fixes",
> but this commit isn't picked into the LTS streams, how should I proceed?
> (Not relevant or slipped through the creeks?)

A "bare" Fixes: tag never means that the change needs to be backported
to stable kernels, as per our documentation, you need to add a cc:
stable to the patch as well to guarantee it.

That being said, we do sweep the tree at times and pick up obvious
things that have Fixes only, and try to apply them, but do so at a "best
case" basis.

For these specific patches, they just do not apply to older kernels at
all, so of course they will not be added to older kernels.  If you think
they do need to be applied, please rework them and submit them to us and
we will be glad to review them (and cc: the relevant developers as
well.)

So that's why they were not backported further than where they are now,
no one took the time to do the work.

Also, are these actually real issues for you?  Dealing with smp tearing
issues like this is good to fix, but can you hit them in your device and
are they relevant for your processor?  (yet another reason why CVEs for
the kernel are bunk, hardware is never taken into consideration...)

> > So maybe work to see if this is a real problem or not first, before
> > worrying about backporting it?
> 
> Seeing the commit merged into the mainline tree and that it looked rather
> reasonable to do the ref-counting, made the impression to me that it is
> a valid patch.

They are valid changes for the kernels they were written for.  Now if
they are relevant for older kernels or not is unknown.  How about asking
the vendor who created those CVEs?  They would know why they created the
entries, even if it was to handle their internal engineering
processes...

Hope this helps,

greg k-h
