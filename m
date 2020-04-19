Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FB81AF82C
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgDSHTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 03:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgDSHTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 03:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF75B21473;
        Sun, 19 Apr 2020 07:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587280745;
        bh=2hd3+tG/b2HomgOrCn5aeT5qors0DQLI7HGOz4+Ji4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xzqnkESGnFiAu28ZMYIqzZ26/j1HZ/bCclHvB0RXV25qwYZtme2jIiTVfHle23SJP
         Ixs4oCfWsaEbF1E9UFQwJuhtYMvdmNa5vp0TB9CPn2tzfjIBSq06XOWMUXiVZPcfkH
         V2j7ILBvEdrCeEPtoHHp1uDTfYPwXD9Kl55VBork=
Date:   Sun, 19 Apr 2020 09:19:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [regression 5.7-rc1] System does not power off, just halts
Message-ID: <20200419071902.GA3544449@kroah.com>
References: <f4eaf0ca-6cd6-c224-9205-bf64ca533ff5@molgen.mpg.de>
 <dcc4851e-0ab5-683a-2cf2-687d64a3c9da@molgen.mpg.de>
 <CADnq5_OXdpEebFY3+kyQb-WEw0Rb6cqoOFKGqgxaigU5hean1g@mail.gmail.com>
 <20200414082150.GD4149624@kroah.com>
 <CADnq5_NCnHFO9kZY-8L34B3uVX5aghXO8+gXNC_cPMOnP7UGAg@mail.gmail.com>
 <ed41bd20-4cd7-d498-db67-9aa981e656b9@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed41bd20-4cd7-d498-db67-9aa981e656b9@mageia.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 18, 2020 at 10:09:28PM +0300, Thomas Backlund wrote:
> Den 14-04-2020 kl. 16:07, skrev Alex Deucher:
> > On Tue, Apr 14, 2020 at 4:21 AM Greg KH <greg@kroah.com> wrote:
> > > 
> > > On Mon, Apr 13, 2020 at 01:48:58PM -0400, Alex Deucher wrote:
> > > > On Mon, Apr 13, 2020 at 1:47 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > > > > 
> > > > > Dear Prike, dear Alex, dear Linux folks,
> > > > > 
> > > > > 
> > > > > Am 13.04.20 um 10:44 schrieb Paul Menzel:
> > > > > 
> > > > > > A regression between causes a system with the AMD board MSI B350M MORTAR
> > > > > > (MS-7A37) with an AMD Ryzen 3 2200G not to power off any more but just
> > > > > > to halt.
> > > > > > 
> > > > > > The regression is introduced in 9ebe5422ad6c..b032227c6293. I am in the
> > > > > > process to bisect this, but maybe somebody already has an idea.
> > > > > 
> > > > > I found the Easter egg:
> > > > > 
> > > > > > commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58
> > > > > > Author: Prike Liang <Prike.Liang@amd.com>
> > > > > > Date:   Tue Apr 7 20:21:26 2020 +0800
> > > > > > 
> > > > > >      drm/amdgpu: fix gfx hang during suspend with video playback (v2)
> > > > > > 
> > > > > >      The system will be hang up during S3 suspend because of SMU is pending
> > > > > >      for GC not respose the register CP_HQD_ACTIVE access request.This issue
> > > > > >      root cause of accessing the GC register under enter GFX CGGPG and can
> > > > > >      be fixed by disable GFX CGPG before perform suspend.
> > > > > > 
> > > > > >      v2: Use disable the GFX CGPG instead of RLC safe mode guard.
> > > > > > 
> > > > > >      Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > > > >      Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
> > > > > >      Reviewed-by: Huang Rui <ray.huang@amd.com>
> > > > > >      Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > > >      Cc: stable@vger.kernel.org
> > > > > 
> > > > > It reverts cleanly on top of 5.7-rc1, and this fixes the issue.
> > > > > 
> > > > > Greg, please do not apply this to the stable series. The commit message
> > > > > doesn’t even reference a issue/bug report, and doesn’t give a detailed
> > > > > problem description. What system is it?
> > > > > 
> > > > > Dave, Alex, how to proceed? Revert? I created issue 1094 [1].
> > > > 
> > > > Already fixed:
> > > > https://patchwork.freedesktop.org/patch/361195/
> > > 
> > > Any reason that doesn't have a cc: stable tag on it?
> > > 
> > > And is it committed to any tree at the moment?
> > 
> > It's going out in my -fixes pull this week with a stable tag.
> > 
> > Alex
> > 
> 
> 
> The fix is now in linus tree as:
> b2a7e9735ab2864330be9d00d7f38c961c28de5d
> 
> and should be added to fix all theese stable trees where the breakage got
> added despite the warnings in this thread:
> 
> releases/5.4.33/drm-amdgpu-fix-gfx-hang-during-suspend-with-video-pl.patch:[
> Upstream commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 ]
> releases/5.6.5/drm-amdgpu-fix-gfx-hang-during-suspend-with-video-pl.patch:[
> Upstream commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 ]
> releases/5.5.18/drm-amdgpu-fix-gfx-hang-during-suspend-with-video-pl.patch:[
> Upstream commit 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 ]

Now queued up, thanks.

greg k-h
