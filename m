Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20ACF5A9829
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiIANMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiIANLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:11:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F85303A;
        Thu,  1 Sep 2022 06:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F338B8263E;
        Thu,  1 Sep 2022 13:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3F7C433C1;
        Thu,  1 Sep 2022 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662037656;
        bh=fkZEmaZoVvoyPmctVOyAmSTzIu4rPdqDgi8UTOZaUn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Isepg++kEaFrlFDLw7gC1ZrFXphhI04e6YSS21Vggtjb0PFTry8z3T19x7x8uBmRT
         LHpr0LtkLCQiuEueMeXzXCpD9FLm1q9pV2FCY1BC5RDJA4dHOg/HsoPP2mxnm3xhaI
         USPlzjQY1U+2RuscCIE1wocS6NvATb1GQfzC+ce0=
Date:   Thu, 1 Sep 2022 15:07:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in
 xfs_ifree
Message-ID: <YxCulVd4dESBjCUM@kroah.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
 <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
 <YxB+QmIwCgMtj1r+@kroah.com>
 <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
 <YxCIvDAMzWdQrpEh@kroah.com>
 <CAOQ4uxh0We9+56EJUSw_NAqd_TLLV1v0yvyY=dj645H_4M_AyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh0We9+56EJUSw_NAqd_TLLV1v0yvyY=dj645H_4M_AyQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 03:37:59PM +0300, Amir Goldstein wrote:
> On Thu, Sep 1, 2022 at 1:26 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Sep 01, 2022 at 01:16:33PM +0300, Amir Goldstein wrote:
> > > On Thu, Sep 1, 2022 at 12:41 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> > > > > On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> > > > > >
> > > > > > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > > >
> > > > > > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > > > > > >
> > > > > > > [backport for 5.10.y]
> > > > > >
> > > > > > Hi Amir, hi Dave,
> > > > > >
> > > > > > I've got no objections to backporting this change at all. We've been
> > > > > > using the patch on our internal 5.15 tracker branch happily for
> > > > > > several months now.
> > > > > >
> > > > > > Would like to highlight though that it's currently not yet merged in
> > > > > > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > > > > > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> > > > > >
> > > > >
> > > > > Hi Frank,
> > > > >
> > > > > Quoting from my cover letter:
> > > > >
> > > > > Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> > > > > I pointed Leah's attention to these patches and she said she will
> > > > > include them in a following 5.15.y update.
> > > >
> > > > And as you know, this means I can't take this series at all until that
> > > > series is ready, so to help us out, in the future, just don't even send
> > > > them until they are all ready together.
> > > >
> > >
> > > What?
> > >
> > > You cannot take backports to 5.10.y before they are applied to 5.15.y?
> > > Since when?
> >
> > Since always.
> >
> > Why would you ever want someone to upgrade from an older tree (like
> > 5.10.y) to a newer one (5.15.y) and have a regression?
> >
> 
> That is certainly not a goal when backporting fixes to 5.10.y, but it
> can happen as a by-product of the decentralized nature of testing
> backports.
> 
> But it did not bother you when xfs patches were applied to 5.4.y and
> no xfs patches at all applied to 5.10.y for two years?

I've been bothered by xfs patches for so long that really, I didn't care
as the maintainers didn't seem bothered either :)

But now that everything is working properly, let's do it correctly
please.

> > So we always try to make sure patches are always applied to newer trees
> > first.  Yes, sometimes we miss this and make mistakes, but it's always
> > been this way and we fix that whenever it happens accidentally.
> >
> 
> That is my intention.
> I will try to keep to that rule in the future.
> I would have waited for the patches to land in 5.15.y, but
> Leah got distracted by another task so I decided to not wait,
> knowing that the patches are already in her queue.
> 
> > I'll drop this series from my review queue for now until the 5.15.y
> > series shows up.
> 
> Please don't drop the series.
> Please drop patches 6-7 if you must
> Or if you insist I can re-post patches 1-5.

Please resend as just the correct ones that you want so I know what to
pick exactly.

thanks,

greg k-h
