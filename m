Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F76DAC8C
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 14:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbjDGMOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 08:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDGMOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 08:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E4F902D
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 05:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C56FC65021
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 12:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC20C433EF;
        Fri,  7 Apr 2023 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680869643;
        bh=G1IlEJktf8aHYscJpiEvM9nPG5cHp7XjR+h6qJYI0t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jAOCK1dS+ESWNzpqskQ6BuIhICqiVqikpQC5U7To2K3em4xRyLDWEh3iR5/1y2Eyu
         WsGYKEnZ/GL/5cH9cSY26PTpFxoXsQcT9mi6fW+1oh31vwboEi6QneuhF6SOyYW0At
         GSG04kR79FizCQV/GFYCRWoukwt3MXeOI2q++LxA=
Date:   Fri, 7 Apr 2023 14:14:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rainer Fiebig <jrf@mailbox.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        stable@vger.kernel.org, tim.huang@amd.com,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: 6.1.22: Resume from hibernate fails; bisected
Message-ID: <2023040709-register-feminize-d452@gregkh>
References: <b52bfd11-0d90-739b-be3e-058e246478f7@mailbox.org>
 <c87add10-3e8f-b17e-f3f5-067431a23e16@leemhuis.info>
 <d3ac4ff5-863f-2179-1120-191774d80a27@mailbox.org>
 <ZC8m_gjbB4oVlO5t@kroah.com>
 <635357ce-8793-1788-e47e-369ed8ded673@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <635357ce-8793-1788-e47e-369ed8ded673@mailbox.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 07, 2023 at 01:56:49PM +0200, Rainer Fiebig wrote:
> Am 06.04.23 um 22:09 schrieb Greg KH:
> > On Thu, Apr 06, 2023 at 05:39:07PM +0200, Rainer Fiebig wrote:
> >> Am 06.04.23 um 15:30 schrieb Linux regression tracking (Thorsten Leemhuis):
> >>> [CCing the regression list, as it should be in the loop for regressions:
> >>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
> >>>
> >>> On 06.04.23 14:06, Rainer Fiebig wrote:
> >>>> Hi! Since kernel 6.1.22 starting a resume from hibernate by hitting a
> >>>> key on the keyboard fails. However, if the PC was switched off and on
> >>>> again (or reset), the resume is OK. The APU  is a Ryzen 5600G.
> >>>>
> >>>> Bisecting between 6.1.21/22 turned up this:
> >>>>
> >>>>
> >>>> Author: Tim Huang <tim.huang@amd.com>
> >>>> Date:   Thu Mar 9 16:27:51 2023 +0800
> >>>>
> >>>>     drm/amdgpu: skip ASIC reset for APUs when go to S4
> >>>>
> >>>>     commit b589626674de94d977e81c99bf7905872b991197 upstream.
> >>>>
> >>>>     For GC IP v11.0.4/11, PSP TMR need to be reserved
> >>>>     for ASIC mode2 reset. But for S4, when psp suspend,
> >>>>     it will destroy the TMR that fails the ASIC reset.
> >>>> [...]
> >>>>
> >>>>
> >>>> Reverting the commit solves the problem.
> >>>> Thanks.
> >>>
> >>> Please try 6.1.23 and report back, because from the thread
> >>> https://lore.kernel.org/all/20230330160740.1dbff94b@schienar/
> >>> it sounds a lot like "drm/amdgpu: allow more APUs to do mode2 reset when
> >>> go to S4" might be fixing this, which went into 6.1.23.
> >> Yes, 6.1.23 seems OK so far.
> >>
> >> I think, however, that rc-kernels and LTS-kernels are different matters.
> >>  With a bleeding edge kernel, problems are to be expected.  But an
> >> LTS-kernel is chosen for stability.  And this is the second time within
> >> just a few weeks that I've been bitten by a time-consuming hibernate-bug
> >> caused by a backport of a commit in amdgpu.
> >>
> >> So I'm asking the devs to either test their patches more thoroughly or
> >> to be a bit more conservative with what they recommend for backporting
> >> to LTS-kernels.  Thanks.
> > 
> > Please feel free to suggest better ways to have automated tests for
> > stuff like this, or to help provide testing for the -rc LTS/stable
> > kernel releases.
> Well, I'm afraid I can't offer a panacea or the ultimate automated
> quality assurance system.  But for the two cases that I've encountered
> lately, a simple hibernate/resume would have shown that there's a
> problem.  After all, that's how I and other users noticed it.
> 
> So I think the primary line of defence against regressions remains the
> developer himself who should try hard to imagine what ramifications his
> patch might have and test it accordingly.  But I'm aware of the fact
> that we are all only humans.
> 
> Another idea might be to give patches that introduce new features or
> only minimal improvements ample time to mature in the latest stable
> kernel before backporting them to LTS-kernels, say three or four
> point-releases.  Or to only backport fixes for bugs or security issues.

This is a long-running discussion.  How do you determine that a "bug
fix" should not be backported now?  For example, this bugfix that caused
a problem was a reported fix for something else, and it had passed the
automated testing system that the DRM developers have.  So why wait on
it?

There's always going to be slip ups, and fixes needed for fixes as we
can't test all hardware configurations or use-cases, all we can do is
react quickly to fix problems when reported.

And in this case, it was fixed _before_ you reported it, which to be
honest, is pretty fast :)

thanks,

greg k-h
