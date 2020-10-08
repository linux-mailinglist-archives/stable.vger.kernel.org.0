Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED028715E
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJHJYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgJHJYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 05:24:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AFA215A4;
        Thu,  8 Oct 2020 09:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602149082;
        bh=cu0nQ+F2s+sCxlnVpby8d1SlJWNvj9tLwLZCvbl8+VY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5XR+0Lvj4PoOIEaG66XRqS1JDdDpDMco5R8RQFmeu0OFFeAEZEZIzYC/W+NgkZ7Y
         jb+ojIQesRZ44bvV4sY5+nsZxOWYrwCJ3YA9SQrwVF6kWU2PsLs+YfRHOJI+LI9dV6
         cpTotqapyNhdFkzE5XKabxivUiVnILhimJTFfksY=
Date:   Thu, 8 Oct 2020 11:25:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com,
        Andrey Konovalov <andreyknvl@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 5.8 05/85] Revert "usbip: Implement a match function to
 fix usbip"
Message-ID: <20201008092525.GA263468@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <20201005142115.000911358@linuxfoundation.org>
 <ad55b590-da4a-4aa8-7a04-302a8d55d723@runbox.com>
 <20201007091324.GF614379@kroah.com>
 <bb5f0904-af0e-e9a3-3d72-2d2d198ff6fa@runbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb5f0904-af0e-e9a3-3d72-2d2d198ff6fa@runbox.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 04:56:56AM -0400, M. Vefa Bicakci wrote:
> On 07/10/2020 12.13, Greg Kroah-Hartman wrote:
> > On Tue, Oct 06, 2020 at 04:26:27PM +0300, M. Vefa Bicakci wrote:
> > > On 05/10/2020 18.26, Greg Kroah-Hartman wrote:
> > > > From: M. Vefa Bicakci <m.v.b@runbox.com>
> > > > 
> > > > commit d6407613c1e2ef90213dee388aa16b6e1bd08cbc upstream.
> > > > 
> > > > This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
> > > > function to fix usbip").
> > > > 
> > > > In summary, commit d5643d2249b2 ("USB: Fix device driver race")
> > > > inadvertently broke usbip functionality, which I resolved in an incorrect
> > > > manner by introducing a match function to usbip, usbip_match(), that
> > > > unconditionally returns true.
> > > > 
> > > > However, the usbip_match function, as is, causes usbip to take over
> > > > virtual devices used by syzkaller for USB fuzzing, which is a regression
> > > > reported by Andrey Konovalov.
> > > > 
> > > > Furthermore, in conjunction with the fix of another bug, handled by another
> > > > patch titled "usbcore/driver: Fix specific driver selection" in this patch
> > > > set, the usbip_match function causes unexpected USB subsystem behaviour
> > > > when the usbip_host driver is loaded. The unexpected behaviour can be
> > > > qualified as follows:
> > > > - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
> > > >     in the kernel, then all USB devices are bound to the usbip_host
> > > >     driver, which appears to the user as if all USB devices were
> > > >     disconnected.
> > > > - If the same commit (41160802ab8e) is not in the kernel (as is the case
> > > >     with v5.8.10) then all USB devices are re-probed and re-bound to their
> > > >     original device drivers, which appears to the user as a disconnection
> > > >     and re-connection of USB devices.
> > > > 
> > > > Please note that this commit will make usbip non-operational again,
> > > > until yet another patch in this patch set is merged, titled
> > > > "usbcore/driver: Accommodate usbip".
> > > > 
> > > > Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
> > > > Cc: <stable@vger.kernel.org> # 5.8
> > > 
> > > Hello Greg,
> > > 
> > > Sorry for the lateness of this e-mail.
> > > 
> > > I had noted commit 41160802ab8e ("USB: Simplify USB ID table match") as a
> > > prerequisite in the commit message, but I just realized that the commit
> > > identifier refers to a commit in my local git tree, and not to the actual
> > > commit in Linus Torvalds' git tree! I apologize for this mistake.
> > > 
> > > Here is the correct commit identifier:
> > >    0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944 ("USB: Simplify USB ID table match")
> > > 
> > > Perhaps this is why the prerequisite commit was not cherry-picked to the 5.8.y
> > > branch.
> > > 
> > > As a justification for the cherry-pick, commit 0ed9498f9ecf actually resolves
> > > a bug. In summary, this commit works together with commit adb6e6ac20ee ("USB:
> > > Also match device drivers using the ->match vfunc", which has been cherry-picked
> > > as part of v5.8.6) and ensures that a USB driver's ->match function is also
> > > called during the search for a more specialized/appropriate USB driver, in case
> > > the driver in question does not have an id_table.
> > > 
> > > If I am to be the devil's advocate, however, then given that there is only one
> > > specialized USB device driver ("apple-mfi-fastcharge"), which conveniently has
> > > an id_table, and also given that usbip no longer has a match function, I also
> > > realize that it may not be crucial to cherry-pick 0ed9498f9ecf as a prerequisite
> > > commit.
> > 
> > I'm sorry, but I don't really understand.  Does 5.8.y need an additional
> > patch here, or is all ok because I missed the above patch?
> 
> No worries; sorry for not communicating clearly and for the delay.
> 
> I meant to state that it would be good to have commit 0ed9498f9ecf ("USB: Simplify
> USB ID table match") cherry picked to 5.8.y, as it fixes a bug, albeit a minor one.

What bug does it fix now?  Is usbip or the apple charger driver not
working properly on 5.8.14?  If nothing is broken, no need to add this
patch...

thanks,

greg k-h
